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

        field(50101; "Name"; Text[50])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if "Name" = UpperCase(xRec.Name) then
                    "Search Name" := Name;
            end;
        }

        field(50102; "Seminar Duration"; Decimal)
        {
            Caption = 'Seminar Duration';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 1;
        }

        field(50103; "Minimum Participants"; Integer)
        {
            Caption = 'Minimum Participants';
            DataClassification = ToBeClassified;
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

    trigger OnInsert()
    begin
        if rec."No." = '' then begin
            SeminarSetupRec.Get();
            SeminarSetupRec.TestField("Seminar Nos.");
            "No." := NoSeries.GetNextNo(SeminarSetupRec."Seminar Nos.");
        end;
    end;

    trigger OnModify()
    begin
        Rec."Last Date Modified" := Today;
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
}