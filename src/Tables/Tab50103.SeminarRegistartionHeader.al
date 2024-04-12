table 50103 SeminarRegistrationHeader
{
    Caption = 'Seminar Registration Header';
    DataClassification = CustomerContent;
    //LookupPageId = SeminarRegistrationList;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "No." = xRec."No." then
                    exit;

                SeminarSetup.Get();
                SeminarSetup.TestField("Seminar Registration Nos.");
                NoSeries.TestManual(SeminarSetup."Seminar Registration Nos.");
                "No. Series" := '';
            end;
        }
        field(2; "Starting Date"; DateTime)
        {
            Caption = 'Starting Date';
            DataClassification = CustomerContent;
            trigger OnLookup()
            begin
                "Starting Date" := SetDateTime("Starting Date");
            end;

            trigger OnValidate()
            var
            begin
                // Calculate end time only if starting date and duration are provided
                if ("Starting Date" <> 0DT) AND ("Seminar No." <> '') THEN begin
                    MESSAGE('Starting Date: ' + FORMAT("Starting Date"));
                    MESSAGE('Duration: ' + FORMAT(Duration));


                    // Calculate end time by adding duration (in hours) to starting time
                    "End Time" := "Starting Date" + (Duration * 3600000); // Convert hours to seconds

                    Message(Format("End Time" - "Starting Date"));

                end;
            end;




        }
        field(3; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No.';
            DataClassification = CustomerContent;
            TableRelation = Seminar where(Blocked = const(false));

            trigger OnValidate()
            begin
                IF "Seminar No." = xRec."Seminar No." THEN
                    exit;

                Seminar.GET("Seminar No.");
                Seminar.TESTFIELD(Blocked, FALSE);
                Seminar.TESTFIELD("Gen. Prod. Posting Group");
                Seminar.TESTFIELD("VAT Prod. Posting Group");
                "Seminar Name" := Seminar.Name;
                Duration := Seminar."Seminar Duration";
                "Seminar Price" := Seminar."Seminar Price";
                "Gen. Prod. Posting Group" := Seminar."Gen. Prod. Posting Group";
                "VAT Prod. Posting Group" := Seminar."VAT Prod. Posting Group";
                "Minimum Participants" := Seminar."Minimum Participants";
                "Maximum Participants" := Seminar."Maximum Participants";
            end;
        }
        field(4; "Seminar Name"; Text[100])
        {
            Caption = 'Seminar Name';
            DataClassification = CustomerContent;
        }
        field(5; "Instructor Resource No."; Code[20])
        {
            Caption = 'Instructor Resource No.';
            DataClassification = CustomerContent;
            TableRelation = Resource where(Type = const(Person));

            trigger OnValidate()
            var
                Resource: Record Resource;
            begin
                if (Resource.Get("Instructor Resource No.")) then begin
                    "Instructor Name" := Resource.Name;
                end;
            end;
        }
        field(6; "Instructor Name"; Text[100])
        {
            Caption = 'Instructor Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Resource."No." where("No." = field("Instructor Resource No.")));

        }
        // field(7; Approval_Status; Enum SeminarRegistrationStatus)
        // {
        //     Caption = 'Status';
        //     DataClassification = CustomerContent;
        // }
        field(8; Duration; Decimal)
        {
            Caption = 'Duration';
            DataClassification = CustomerContent;
        }
        field(9; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
            DataClassification = CustomerContent;
        }
        field(10; "Minimum Participants"; Integer)
        {
            Caption = 'Minimum Participants';
            DataClassification = CustomerContent;
        }
        field(11; "Room Resource No."; Code[20])
        {
            Caption = 'Room Resource No.';
            DataClassification = CustomerContent;
            TableRelation = Resource where(Type = const(Machine));

            trigger OnValidate()
            var
                SeminarRoom: Record Resource;
            begin
                if "Room Resource No." = xRec."Room Resource No." then
                    exit;

                IF "Room Resource No." = '' THEN BEGIN
                    "Room Name" := '';
                    "Room Address" := '';
                    "Room Address 2" := '';
                    "Room Post Code" := '';
                    "Room City" := '';
                    "Room County" := '';
                    "Room Country/Reg. Code" := '';
                END ELSE BEGIN
                    SeminarRoom.GET("Room Resource No.");
                    "Room Name" := SeminarRoom.Name;
                    "Room Address" := SeminarRoom.Address;
                    "Room Address 2" := SeminarRoom."Address 2";
                    "Room Post Code" := SeminarRoom."Post Code";
                    "Room City" := SeminarRoom.City;
                    "Room County" := SeminarRoom.County;
                    "Room Country/Reg. Code" := SeminarRoom."Country/Region Code";

                    IF CurrFieldNo = 0 THEN
                        exit;

                    // IF (SeminarRoom."Maximum Participants" <> 0) AND
                    //    (SeminarRoom."Maximum Participants" < "Maximum Participants")
                    // THEN BEGIN
                    //     IF CONFIRM(ChangeSeminarRoomQst, TRUE,
                    //          "Maximum Participants",
                    //          SeminarRoom."Maximum Participants",
                    //          FIELDCAPTION("Maximum Participants"),
                    //          "Maximum Participants",
                    //          SeminarRoom."Maximum Participants")
                    //     THEN
                    //         "Maximum Participants" := SeminarRoom."Maximum Participants";
                    // END;
                END;
            end;
        }
        field(12; "Room Name"; Text[100])
        {
            Caption = 'Room Name';
            DataClassification = CustomerContent;
        }
        field(13; "Room Address"; Text[50])
        {
            Caption = 'Room Address';
            DataClassification = CustomerContent;
        }
        field(14; "Room Address 2"; Text[50])
        {
            Caption = 'Room Address 2';
            DataClassification = CustomerContent;
        }
        field(15; "Room Post Code"; Code[20])
        {
            Caption = 'Room Post Code';
            DataClassification = CustomerContent;
            TableRelation = "Post Code";
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode("Room City",
                    "Room Post Code",
                    "Room County",
                    "Room Country/Reg. Code",
                    (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(16; "Room City"; Text[50])
        {
            Caption = 'Room City';
            DataClassification = CustomerContent;
        }
        field(17; "Room Country/Reg. Code"; Code[10])
        {
            Caption = 'Room Country/Reg. Code';
            DataClassification = CustomerContent;
            TableRelation = "Country/Region";
        }
        field(18; "Room County"; Text[30])
        {
            Caption = 'Room County';
            DataClassification = CustomerContent;
        }
        field(19; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
            DataClassification = CustomerContent;
        }
        field(20; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Product Posting Group";
        }
        field(21; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            DataClassification = CustomerContent;
            TableRelation = "VAT Product Posting Group";
        }
        field(22; Comment; Boolean)
        {
            Caption = 'Comment';
            DataClassification = CustomerContent;
        }
        field(23; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(24; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }
        field(25; "Reason Code"; Code[20])
        {
            Caption = 'Reason Code';
            DataClassification = CustomerContent;
            TableRelation = "Reason Code";
        }
        field(26; "No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(27; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                if "Posting No. Series" = '' then
                    exit;
                TestField("Posting No.", '');

                SeminarSetup.Get();
                SeminarSetup.TestField("Seminar Registration Nos.");
                SeminarSetup.TestField("Posted Seminar Reg. Nos.");
                NoSeries.TestAreRelated(SeminarSetup."Posted Seminar Reg. Nos.", "Posting No. Series");
            end;

            trigger OnLookup()
            begin
                SeminarRegHeader := Rec;
                SeminarSetup.Get();
                SeminarSetup.TestField("Seminar Registration Nos.");
                SeminarSetup.TestField("Posted Seminar Reg. Nos.");
                if NoSeries.LookupRelatedNoSeries(SeminarSetup."Posted Seminar Reg. Nos.", "Posting No. Series") then
                    Validate("Posting No. Series");
                Rec := SeminarRegHeader;
            end;
        }
        field(28; "Posting No."; Code[20])
        {
            Caption = 'Posting No.';
            DataClassification = CustomerContent;
        }
        field(29; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }

        // field(40; Status; Enum ApprovalStatus)
        // {
        //     Caption = 'Approval Status';
        // }
        field(41; No_Printed; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        // field(42; "Total Amount"; Decimal)
        // {
        //     Editable = false;
        //     DecimalPlaces = 0 : 5;
        //     FieldClass = FlowField;
        //     CalcFormula = sum(SeminarRegistrationLine.Amount where("Document No." = field("No.")));
        // }
        // field(43; "Line Discount"; Decimal)
        // {
        //     Editable = false;
        //     DecimalPlaces = 0 : 5;
        //     FieldClass = FlowField;
        //     CalcFormula = sum(SeminarRegistrationLine."Line Discount Amount" where("Document No." = field("No.")));
        // }
        // field(44; "Number of Lines"; Integer)
        // {
        //     Editable = false;
        //     CalcFormula = count(SeminarRegistrationLine where("Document No." = field("No.")));
        //     FieldClass = FlowField;
        // }
        field(45; "End Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            trigger OnLookup()
            begin
                "End Time" := SetDateTime("End Time");
            end;
        }
        field(46; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }

    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Index2; "Room Resource No.")
        {
            SumIndexFields = Duration;
        }
    }
    var
        SeminarSetup: Record "Seminar Setup";
        NoSeries: Codeunit "No. Series";
        PostCode: Record "Post Code";
        Seminar: Record Seminar;
        SeminarRegHeader: Record SeminarRegistrationHeader;
        //SeminarCommentLine: Record SeminarCommentLine;
        //ChangeSeminarRoomQst: Label 'This Seminar is for %1 participants. \The selected Room has a maximum of %2 participants \Do you want to change %3 for the Seminar from %4 to %5?';
        //SeminarRegLine: Record SeminarRegistrationLine;
        //SeminarCharge: Record SeminarCharge;
        ErrCannotDeleteLine: Label 'Cannot delete the Seminar Registration, there exists at least one %1 where %2=%3.';
        ErrCannotDeleteCharge: Label 'Cannot delete the Seminar Registration, there exists at least one %1.';

    trigger OnInsert()
    begin
        if "No." = '' then begin
            SeminarSetup.Get();
            SeminarSetup.TestField("Seminar Registration Nos.");
            "No. Series" := NoSeries.GetNextNo(SeminarSetup."Seminar Nos.");
        END;
        InitRecord;

        if GetFilter("Seminar No.") = '' then
            exit;

        IF GetRangeMin("Seminar No.") = GetRangeMax("Seminar No.") THEN
            Validate("Seminar No.", GetRangeMin("Seminar No."));
    end;

    trigger OnDelete()
    begin
        //TestField(Approval_Status, Approval_Status::Cancelled);

        // SeminarRegLine.RESET;
        // SeminarRegLine.SETRANGE("Document No.", "No.");
        // SeminarRegLine.SETRANGE(Registered, TRUE);
        // IF SeminarRegLine.FIND('-') THEN
        //     ERROR(
        //       ErrCannotDeleteLine,
        //       SeminarRegLine.TABLECAPTION,
        //       SeminarRegLine.FIELDCAPTION(Registered),
        //       TRUE);
        // SeminarRegLine.SETRANGE(Registered);
        // SeminarRegLine.DELETEALL(TRUE);

        // SeminarCharge.RESET;
        // SeminarCharge.SETRANGE("Document No.", "No.");
        // IF NOT SeminarCharge.ISEMPTY THEN
        //     ERROR(ErrCannotDeleteCharge, SeminarCharge.TABLECAPTION);

        // SeminarCommentLine.Reset();
        // SeminarCommentLine.SetRange(
        //     "Document Type", SeminarCommentLine."Document Type"::"Seminar Registration");
        // SeminarCommentLine.SetRange("No.", "No.");
        // SeminarCommentLine.DeleteAll();
    end;

    procedure InitRecord()
    begin
        if "Posting Date" = 0D then
            "Posting Date" := WorkDate();

        "Document Date" := WorkDate();

        SeminarSetup.Get();
        SeminarSetup.TestField("Posted Seminar Reg. Nos.");
        "Posting No. Series" := NoSeries.GetNextNo(SeminarSetup."Posted Seminar Reg. Nos.");
    end;

    procedure AssistEdit(OldSeminarRegHeader: Record SeminarRegistrationHeader): Boolean
    begin
        SeminarRegHeader := Rec;
        SeminarSetup.Get();
        SeminarSetup.TestField("Seminar Registration Nos.");
        if not NoSeries.LookupRelatedNoSeries(
            SeminarSetup."Seminar Registration Nos.",
            OldSeminarRegHeader."No. Series", "No. Series") then
            exit(false);

        SeminarSetup.Get();
        SeminarSetup.TestField("Seminar Registration Nos.");
        SeminarRegHeader."No." := NoSeries.GetNextNo(SeminarSetup."Seminar Registration Nos.");
        Rec := SeminarRegHeader;
        exit(TRUE);
    end;

    local procedure SetDateTime(MainDateTime: DateTime): DateTime
    var
        DateTimePage: Page "Date-Time Dialog";
    begin
        DateTimePage.SetDateTime(MainDateTime);

        if DateTimePage.RunModal() = Action::OK then
            exit(DateTimePage.GetDateTime());
    end;



}