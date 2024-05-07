// SME1.00 - 2024-04-16 - Govind
//   Chapter 2 - Lab 2
//     - Add fields to the table 
//     - Configuring the comment line field as flow field
//     - adding primary and secondary key
//     - adding code to seminar table
//     - added code to table triggers 
//     - added a procedure OnAssistEdit()

// SME1.00 - 2024-04-17 - Govind
//   Chapter 3 - Lab 1
//     -- Adding a flowfield for maintaining booked seats for the seminar 

// SME1.00 - 2024-04-29 - Govind
//   Chapter 8 - Lab 1
//     - Added procedure ValidateShortcutDimCode
//     - Added fields GlobalDimensionCode1 and GlobalDImensionCode2 


table 50102 Seminar
{
    Caption = 'Seminar';
    LookupPageId = "Seminar List";
    DataCaptionFields = "No.", Name;

    fields
    {
        field(50100; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'No.';
            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SeminarSetupRec.Get();
                    NoSeries.TestManual(SeminarSetupRec."Seminar Nos.");
                    "No. Series" := '';
                end;
            end;
        }

        field(50101; "Name"; Text[150])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if "Name" = UpperCase(xRec.Name) then
                    "Search Name" := Name;
            end;
        }


        field(50103; "Minimum Participants"; Integer)
        {
            Caption = 'Minimum Participants';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if "Minimum Participants" > "Maximum Participants" then
                    Error('Minimum participants must be less than maximum participants.!!');
            end;
        }

        field(50104; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
            DataClassification = ToBeClassified;
        }

        field(50105; "Search Name"; Code[50])
        {
            Caption = 'Search Name';
            DataClassification = ToBeClassified;
        }

        field(50106; Blocked; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = ToBeClassified;
        }

        field(50107; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            DataClassification = ToBeClassified;
            Editable = false;
        }

        field(50108; Comment; Boolean)
        {
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = exist("Comment Line" where("Table Name" = const(Seminar), "No." = field("No.")));
        }

        field(50109; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
            DataClassification = ToBeClassified;
            AutoFormatType = 1;
        }
        field(7; "Seminar registartion Status"; Enum SeminarRegistrationStatus)
        {
            Caption = 'Seminar registartion Status';
            DataClassification = CustomerContent;
        }
        field(50110; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. prod. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate()
            begin
                if xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" then begin
                    if GenProPostingRec.ValidateVatProdPostingGroup(GenProPostingRec, "Gen. Prod. Posting Group") then begin
                        Validate("VAT Prod. Posting Group", GenProPostingRec."Def. VAT Prod. Posting Group");
                    end;
                end;
            end;
        }

        field(50111; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "VAT Product Posting Group";
        }

        field(50112; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }

        field(50113; "Total Booking"; Integer)
        {
            Caption = 'Total Bookings';
            Editable = false;
        }

        field(50114; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }

        field(50115; "Charge Type Filter"; Enum SeminarChargeType)
        {
            Caption = 'Charge Type Filter';
            FieldClass = FlowFilter;
        }

        field(50116; "Total Price"; Decimal)
        {
            Caption = 'Total Price';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum(SeminarLedgerEntry."Total Price" where("Seminar No." = field("No."), "Posting Date" = field("Date Filter"), "Charge Type" = field("Charge Type Filter")));
        }

        field(50117; "Total Price(Not Chargable)"; Decimal)
        {
            Caption = 'Total Price(Not Chargable))';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum(SeminarLedgerEntry."Total Price" where("Seminar No." = field("No."), "Posting Date" = field("Date Filter")));
            ;
        }
        field(50118; "Total Price(Chargable)"; Decimal)
        {
            Caption = 'Total Price(Chargable)';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum(SeminarLedgerEntry."Total Price" where("Seminar No." = field("No."), "Posting Date" = field("Date Filter")));
        }
        field(50119; "Global Dimension Code 1"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".code where("Global Dimension No." = const(1));
        }
        field(50120; "Global Dimension Code 2"; Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
    }

    keys
    {
        key(pk; "No.")
        {
            Clustered = true;
        }
        key(SK; "Search Name")
        { }
    }

    var
        SeminarSetupRec: Record "Seminar Setup";
        CommentLineRec: Record "Comment Line";
        SeminarRec: Record Seminar;
        GenProPostingRec: Record "Gen. Product Posting Group";
        NoSeries: Codeunit "No. Series";
        DimensionMgt: Codeunit DimensionManagement;
        defdim: Record "Default Dimension";
        SeminarRegHeader: Record SeminarRegistrationHeader;
        semRegLine: Record SeminarRegistrationLine;

    trigger OnInsert()
    begin
        if rec."No." = '' then begin
            SeminarSetupRec.Get();
            SeminarSetupRec.TestField("Seminar Nos.");
            "No." := NoSeries.GetNextNo(SeminarSetupRec."Seminar Nos.");
        end;

        DimensionMgt.UpdateDefaultDim(Database::Seminar, "No.", "Global Dimension Code 1", "Global Dimension Code 2");
    end;

    trigger OnModify()
    begin
        Rec."Last Date Modified" := Today;
        if SeminarRegHeader.FindFirst then begin
            SeminarRegHeader.SetRange("No.");
            SeminarRegHeader."Seminar Name" := Name;
            SeminarRegHeader."Seminar registartion Status" := "Seminar registartion Status";
            SeminarRegHeader."Maximum Participants" := "Maximum Participants";
            SeminarRegHeader."Minimum Participants" := "Minimum Participants";
            SeminarRegHeader."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
            SeminarRegHeader."VAT Prod. Posting Group" := "VAT Prod. Posting Group";
            SeminarRegHeader."Seminar Price" := "Seminar Price";
            SeminarRegHeader.Modify;
        end;
    end;

    trigger OnRename()
    begin
        Rec."Last Date Modified" := Today;
    end;

    trigger OnDelete()
    begin
        CommentLineRec.Reset();
        CommentLineRec.SetRange("Table Name", CommentLineRec."Table Name"::Seminar);
        CommentLineRec.SetRange("No.", "No.");
        CommentLineRec.DeleteAll();

        DimensionMgt.DeleteDefaultDim(Database::Seminar, "No.");
    end;


    procedure AssistEdit(OldSeminar: Record Seminar) Result: Boolean
    begin
        SeminarRec := Rec;
        SeminarSetupRec.Get();
        SeminarSetupRec.TestField("Seminar Nos.");
        if NoSeries.LookupRelatedNoSeries(SeminarSetupRec."Seminar Nos.", OldSeminar."No. Series", SeminarRec."No. Series") then begin
            SeminarRec."No." := NoSeries.GetNextNo(SeminarRec."No. Series");
            Rec := SeminarRec;
            exit(true);
        end;
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortCutDimCode: Code[20])
    begin
        DimensionMgt.ValidateDimValueCode(FieldNumber, ShortCutDimCode);
        DimensionMgt.SaveDefaultDim(Database::Customer, "No.", FieldNumber, ShortCutDimCode);
        Modify();
    end;
}