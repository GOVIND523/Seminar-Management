table 50102 Seminar
{
    Caption = 'Seminar';
    LookupPageId = "Seminar List";

    fields
    {
        field(50100; "No."; Code[20])
        {
            DataClassification = ToBeClassified;

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
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if Name = UpperCase(xRec.Name) then
                    "Search Name" := Name;
            end;
        }

        field(50102; "Seminar Duration"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 1;
        }

        field(50103; "Minimum Participants"; Integer)
        {
            DataClassification = ToBeClassified;
        }

        field(50104; "Maximum Participants"; Integer)
        {
            DataClassification = ToBeClassified;
        }

        field(50105; "Search Name"; Code[50])
        {
            DataClassification = ToBeClassified;
        }

        field(50106; Blocked; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(50107; "Last Date Modified"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }

        field(50108; Comment; Boolean)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = exist("Comment Line" where("Table Name" = const(Seminar), "No." = field("No.")));
        }

        field(50109; "Seminar Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            AutoFormatType = 1;
        }

        field(50110; "Gen. Prod. Posting Group"; Code[10])
        {
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
            DataClassification = ToBeClassified;
            TableRelation = "VAT Product Posting Group";
        }

        field(50112; "No. Series"; Code[10])
        {
            TableRelation = "No. Series";
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
            NoSeries.GetNextNo(SeminarSetupRec."Seminar Nos.");
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


    // needs adjustments
    procedure AssistEdit(): Boolean
    begin
        SeminarSetupRec.Get();
        SeminarSetupRec.TestField("Seminar Nos.");
        if NoSeries.LookupRelatedNoSeries(xRec."No. Series", "No. Series") then begin
            NoSeries.GetNextNo("No.");
            Rec := SeminarRec;
            exit(true);
        end;
    end;

}