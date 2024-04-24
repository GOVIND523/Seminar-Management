// SME1.00 - 2024-04-17 - Govind
//   Chapter 3 - Lab 1
//     - added Seminar registartion Line table to the application area
//     - added procedures 
//     - added logic to table and field triggers
//     -- addded logic in OnInsert to check for avalibility of bookings and only then  insert the line
table 50104 SeminarRegistrationLine
{
    Caption = 'Seminar Registration Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
            TableRelation = SeminarRegistrationHeader;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }

        field(50100; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No';
            DataClassification = ToBeClassified;
        }
        field(3; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer where(Blocked = const(" "));

            trigger OnValidate()
            begin
                TestField(Registered, false);
            end;
        }
        field(4; "Participant Contact No."; Code[20])
        {
            Caption = 'Participant Contact No.';
            DataClassification = CustomerContent;
            TableRelation = Contact;

            trigger OnLookup()
            begin
                ContactBusinessRelation.RESET;
                ContactBusinessRelation.SETRANGE("Link to Table", ContactBusinessRelation."Link to Table"::Customer);
                ContactBusinessRelation.SETRANGE("No.", "Bill-to Customer No.");
                IF not ContactBusinessRelation.FINDFIRST THEN
                    exit;

                Contact.Reset();
                Contact.SETRANGE("Company No.", ContactBusinessRelation."Contact No.");
                IF PAGE.RUNMODAL(PAGE::"Contact List", Contact) = ACTION::LookupOK THEN BEGIN
                    "Participant Contact No." := Contact."No.";
                    "Participant Name" := Contact.Name;
                END;
            end;

            trigger OnValidate()
            begin
                IF ("Bill-to Customer No." = '') or ("Participant Contact No." = '') THEN
                    exit;

                Contact.GET("Participant Contact No.");
                ContactBusinessRelation.RESET;
                ContactBusinessRelation.SETCURRENTKEY("Link to Table", "No.");
                ContactBusinessRelation.SETRANGE("Link to Table", ContactBusinessRelation."Link to Table"::Customer);
                ContactBusinessRelation.SETRANGE("No.", "Bill-to Customer No.");
                IF not ContactBusinessRelation.FINDFIRST THEN
                    exit;

                IF ContactBusinessRelation."Contact No." <> Contact."Company No." THEN BEGIN
                    ERROR(ContactHasDifferentCompanyThanCustomer, Contact."No.", Contact.Name, "Bill-to Customer No.");
                END;
            end;
        }
        field(5; "Participant Name"; Text[100])
        {
            Caption = 'Participant Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(6; "Registration Date"; Date)
        {
            Caption = 'Registration Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(7; "To Invoice"; Boolean)
        {
            Caption = 'To Invoice';
            DataClassification = CustomerContent;
            InitValue = true;
        }
        field(8; Participated; Boolean)
        {
            Caption = 'Participated';
            DataClassification = CustomerContent;
        }
        field(9; "Confirmation Date"; Date)
        {
            Caption = 'Confirmation Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(10; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            trigger OnValidate()
            begin
                Validate("Line Discount %");
            end;
        }
        field(11; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DataClassification = CustomerContent;
            MinValue = 0;
            MaxValue = 100;
            DecimalPlaces = 0 : 5;
            trigger OnValidate()
            begin
                IF "Seminar Price" = 0 THEN BEGIN
                    "Line Discount Amount" := 0;
                END ELSE BEGIN
                    GLSetup.GET;
                    "Line Discount Amount" := ROUND("Line Discount %" * "Seminar Price" * 0.01, GLSetup."Amount Rounding Precision");
                END;
                UpdateAmount;
            end;
        }
        field(12; "Line Discount Amount"; Decimal)
        {
            Caption = 'Line Discount Amount';
            DataClassification = CustomerContent;
            AutoFormatType = 1;

            trigger OnValidate()
            begin
                IF "Seminar Price" = 0 THEN BEGIN
                    "Line Discount %" := 0;
                END ELSE BEGIN
                    GLSetup.GET;
                    "Line Discount %" := ROUND("Line Discount Amount" / "Seminar Price" * 100, GLSetup."Amount Rounding Precision");
                END;
                UpdateAmount;
            end;
        }
        field(13; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
            AutoFormatType = 1;

            trigger OnValidate()
            begin
                TESTFIELD("Bill-to Customer No.");
                TESTFIELD("Seminar Price");
                GLSetup.GET;
                Amount := ROUND(Amount, GLSetup."Amount Rounding Precision");
                "Line Discount Amount" := "Seminar Price" - Amount;
                IF "Seminar Price" = 0 THEN BEGIN
                    "Line Discount %" := 0;
                END ELSE BEGIN
                    "Line Discount %" := ROUND("Line Discount Amount" / "Seminar Price" * 100, GLSetup."Amount Rounding Precision");
                END;
            end;
        }
        field(14; Registered; Boolean)
        {
            Caption = 'Registered';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        Seminar: Record Seminar;
    begin
        GetSeminarRegHeader;
        if SeminarRegHeader."Total Bookings" = SeminarRegHeader."Maximum Participants" then
            Error(ErrorOnNoAvailibility, "Seminar No.", SeminarRegHeader."Seminar Name");

        Seminar.Get(SeminarRegHeader."Seminar No.");
        Seminar."Total Booking" += 1;
        Seminar.Modify;

        "Registration Date" := WORKDATE;
        "Seminar Price" := SeminarRegHeader."Seminar Price";
        Amount := SeminarRegHeader."Seminar Price";
    end;

    trigger OnDelete()
    begin
        TestField(Registered, false);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        SeminarRegHeader: Record SeminarRegistrationHeader;
        Contact: Record Contact;
        ContactBusinessRelation: Record "Contact Business Relation";
        ContactHasDifferentCompanyThanCustomer: Label 'Contact %1 %2 is related to a different company than customer %3.';
        Seminar: record Seminar;
        ErrorOnNoAvailibility: Label 'Cant register more participants as no more bookings are available for seminar %1 %2';

    PROCEDURE GetSeminarRegHeader();
    BEGIN
        IF SeminarRegHeader."No." <> "Document No." THEN BEGIN
            SeminarRegHeader.GET("Document No.");
            "Seminar No." := SeminarRegHeader."No.";
        END;
    END;

    PROCEDURE CalculateAmount(var Amount: Decimal): Decimal
    BEGIN
        Amount := ROUND(("Seminar Price" / 100) * (100 - "Line Discount %"));
        exit(Amount);
    END;

    PROCEDURE UpdateAmount();
    BEGIN
        GLSetup.GET;
        Amount := ROUND("Seminar Price" - "Line Discount Amount", GLSetup."Amount Rounding Precision");
    END;
}

