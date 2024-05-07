// SME1.00 - 2024-04-16 - Govind
//   Chapter 3 - Lab 1
//     - Seminar Reg Header Table Created
//     - added logic field and table triggers
//     - added procedure OnAssistEdit(), SetDateTime(), InItRecoord()

// SME1.00 - 2024-04-17 - Govind
//   Chapter 3 - Lab 1 Additional
//     -- added the available seats field as a flowfield

// SME1.00 - 2024-04-24 - Govind
//   Chapter 6 - Lab 1
//     - Added a field "No printed" 

table 50103 SeminarRegistrationHeader
{
    Caption = 'Seminar Registration Header';
    DataClassification = CustomerContent;
    LookupPageId = SeminarRegistrationList;
    DataCaptionFields = "No.", "Seminar Name", "Instructor Name", "Room Name";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SeminarSetup.Get();
                    NoSeries.TestManual(SeminarSetup."Seminar Registration Nos.");
                    "No. Series" := '';
                end;
                CreateDim(Database::Seminar, "Seminar No.", Database::Resource, "Instructor Resource No.", Database::Resource, "Room Resource No.");
            end;
        }
        field(2; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Starting Date" <> xRec."Starting Date" then
                    TestField("Seminar registartion Status", SeminarRegistrationStatus::Planning);
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

                SeminarRegLine.Reset();
                SeminarRegLine.SetRange("Document No.", "No.");
                SeminarRegLine.SetRange(Registered, True);
                if not SeminarRegLine.IsEmpty then
                    Error(ErrorCannotChangeSeminarNo, xRec."Seminar No.", "Seminar No.", FieldCaption("Seminar No."), SeminarRegLine.TableCaption, SeminarRegLine.FieldCaption(Registered), true);
                Seminar.GET("Seminar No.");
                Seminar.TESTFIELD(Blocked, FALSE);
                Seminar.TESTFIELD("Gen. Prod. Posting Group");
                Seminar.TESTFIELD("VAT Prod. Posting Group");
                "Seminar Name" := Seminar.Name;
                "Seminar Price" := Seminar."Seminar Price";
                "Gen. Prod. Posting Group" := Seminar."Gen. Prod. Posting Group";
                "VAT Prod. Posting Group" := Seminar."VAT Prod. Posting Group";
                "Minimum Participants" := Seminar."Minimum Participants";
                "Maximum Participants" := Seminar."Maximum Participants";
                "Seminar registartion Status" := seminar."Seminar registartion Status";
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
                CreateDim(Database::Seminar, "Seminar No.", Database::Resource, "Instructor Resource No.", Database::Resource, "Room Resource No.");
            end;
        }
        field(6; "Instructor Name"; Text[100])
        {
            Caption = 'Instructor Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Resource."No." where("No." = field("Instructor Resource No.")));

        }
        field(7; "Seminar registartion Status"; Enum SeminarRegistrationStatus)
        {
            Caption = 'Seminar registartion Status';
            DataClassification = CustomerContent;
        }
        field(8; Duration; Decimal)
        {
            Caption = 'Duration (Hours)';
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
        field(50100; "Total Bookings"; Integer)
        {
            Caption = 'Total Bookings';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Seminar."Total Booking" where("No." = field("Seminar No.")));
            trigger OnValidate()
            begin
                "Avaiable Bookings" := "Maximum Participants" - "Total Bookings";
            end;
        }
        field(50101; "Avaiable Bookings"; Integer)
        {
            Caption = 'Available Bookings';
            Editable = false;
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

                    // IF CurrFieldNo = 0 THEN
                    //     exit;

                    IF (SeminarRoom."Maximum Participants" <> 0) AND (SeminarRoom."Maximum Participants" < "Maximum Participants") THEN BEGIN
                        IF CONFIRM(ChangeSeminarRoomQst, TRUE, "Maximum Participants", SeminarRoom."Maximum Participants", FIELDCAPTION("Maximum Participants"), "Maximum Participants", SeminarRoom."Maximum Participants")
                        THEN
                            "Maximum Participants" := SeminarRoom."Maximum Participants";
                    END;
                END;


                CreateDim(Database::Seminar, "Seminar No.", Database::Resource, "Instructor Resource No.", Database::Resource, "Room Resource No.");
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
                PostCode.ValidatePostCode("Room City", "Room Post Code", "Room County", "Room Country/Reg. Code", (CurrFieldNo <> 0) and GuiAllowed);
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
            trigger OnValidate()
            begin
                if ("Seminar Price" <> xrec."Seminar Price") and ("Seminar registartion Status" <> "Seminar registartion Status"::Cancelled) then begin
                    SeminarRegLine.Reset();
                    SeminarRegLine.SetRange("Document No.", "No.");
                    SeminarRegLine.SetRange(Registered, false);
                    if SeminarRegLine.find
                    then
                        if confirm(ConfirmCharges, false, FieldCaption("Seminar Price"), SeminarRegLine.TableCaption) then begin
                            repeat
                                SeminarRegLine.Validate("Seminar Price", "Seminar Price");
                                SeminarRegLine.Modify();
                            until SeminarRegLine.next = 0;
                            Modify;
                        end;
                end;
            end;
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
        }
        field(28; "Posting No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(29; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
            trigger OnValidate()
            begin
                if "Ending Date" - "Starting Date" > 0 then begin
                    "NumberofDays" := "Ending Date" - "Starting Date";
                end;
            end;
        }

        field(40; "Approval Status"; Enum ApprovalStatus)
        {
            Caption = 'Approval Status';
        }
        field(41; No_Printed; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(42; "Total Amount"; Decimal)
        {
            Editable = false;
            DecimalPlaces = 0 : 5;
            FieldClass = FlowField;
            CalcFormula = sum(SeminarRegistrationLine.Amount where("Document No." = field("No.")));
        }
        field(43; "Line Discount"; Decimal)
        {
            Editable = false;
            DecimalPlaces = 0 : 5;
            FieldClass = FlowField;
            CalcFormula = sum(SeminarRegistrationLine."Line Discount Amount" where("Document No." = field("No.")));
        }
        field(44; "Number of Lines"; Integer)
        {
            Editable = false;
            CalcFormula = count(SeminarRegistrationLine where("Document No." = field("No.")));
            FieldClass = FlowField;
        }
        field(45; "ToTime"; Time)
        {
            Caption = 'To Time';
            DataClassification = ToBeClassified;
        }

        field(50103; NumberofDays; Integer)
        {
            Caption = 'Number of Days';
            DataClassification = ToBeClassified;
        }
        field(50105; FromTime; Time)
        {
            Caption = 'From Time';
            DataClassification = ToBeClassified;
        }

        field(46; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }

        field(47; "Shortcut Dimension 1 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(48; "Shortcut Dimension 2 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            trigger OnLookup()
            begin
                ShowDocDim();
            end;
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
        DimensionMgt: Codeunit DimensionManagement;
        SeminarSetup: Record "Seminar Setup";
        NoSeries: Codeunit "No. Series";
        PostCode: Record "Post Code";
        Seminar: Record Seminar;
        Text009: Label 'You may have changed a dimension.\\ Do you want to update the lines?';
        SeminarRegHeader: Record SeminarRegistrationHeader;
        SeminarCommentLine: Record SeminarCommentLine;
        ChangeSeminarRoomQst: Label 'This Seminar is for %1 participants. \The selected Room has a maximum of %2 participants \Do you want to change %3 for the Seminar from %4 to %5?';
        SeminarRegLine: Record SeminarRegistrationLine;
        SeminarCharge: Record SeminarCharge;
        ErrorCannotChangeSeminarNo: Label 'Cannot change the seminar number from %1 to %2 as there exists records in %3 as %4';
        ErrCannotDeleteLine: Label 'Cannot delete the Seminar Registration, there exists at least one %1 where %2=%3.';
        ErrCannotDeleteCharge: Label 'Cannot delete the Seminar Registration, there exists at least one %1.';
        ConfirmCharges: Label 'Confirm registration with %1 for the %2.';

    trigger OnInsert()
    begin
        if "No." = '' then begin
            SeminarSetup.Get();
            SeminarSetup.TestField("Seminar Registration Nos.");
            "No." := NoSeries.GetNextNo(SeminarSetup."Seminar Registration Nos.");
        END;
        InitRecord;

        if GetFilter("Seminar No.") <> '' then
            IF GetRangeMin("Seminar No.") = GetRangeMax("Seminar No.") THEN
                Validate("Seminar No.", GetRangeMin("Seminar No."));
    end;

    trigger OnDelete()
    begin
        TestField("Seminar registartion Status", SeminarRegistrationStatus::Cancelled);

        SeminarRegLine.RESET;
        SeminarRegLine.SETRANGE("Document No.", "No.");
        SeminarRegLine.SETRANGE(Registered, TRUE);
        IF SeminarRegLine.FIND('-') THEN
            ERROR(ErrCannotDeleteLine,
              SeminarRegLine.TABLECAPTION,
              SeminarRegLine.FIELDCAPTION(Registered),
              TRUE);
        SeminarRegLine.SETRANGE(Registered);
        SeminarRegLine.DELETEALL(TRUE);

        SeminarCharge.RESET;
        SeminarCharge.SETRANGE("Document No.", "No.");
        IF NOT SeminarCharge.ISEMPTY THEN
            ERROR(ErrCannotDeleteCharge, SeminarCharge.TABLECAPTION);

        SeminarCommentLine.Reset();
        SeminarCommentLine.SetRange("Document Type", SeminarCommentLine."Document Type"::"Seminar Registration");
        SeminarCommentLine.SetRange("No.", "No.");
        SeminarCommentLine.DeleteAll();
    end;

    procedure InitRecord()
    begin
        if "Posting Date" = 0D then
            "Posting Date" := WorkDate();

        "Document Date" := WorkDate();
        SeminarSetup.Get();
        SeminarSetup.TestField("Posted Seminar Reg. Nos.");
        "Posting No. Series" := SeminarSetup."Posted Seminar Reg. Nos.";
        "Posting No." := NoSeries.GetNextNo("Posting No. Series");

    end;

    procedure AssistEdit(OldSeminarRegHeader: Record SeminarRegistrationHeader): Boolean
    begin
        SeminarRegHeader := Rec;
        SeminarSetup.Get();
        SeminarSetup.TestField("Seminar Registration Nos.");
        if not NoSeries.LookupRelatedNoSeries(SeminarSetup."Seminar Registration Nos.", OldSeminarRegHeader."No. Series", "No. Series") then
            exit(false);
        SeminarSetup.Get();
        SeminarSetup.TestField("Seminar Registration Nos.");
        SeminarRegHeader."No." := NoSeries.GetNextNo(SeminarSetup."Seminar Registration Nos.");
        Rec := SeminarRegHeader;
        exit(TRUE);
    end;

    local procedure SeminarRegLinesExist(): Boolean
    begin
        SeminarRegLine.Reset();
        SeminarRegLine.SetRange("Document No.", "No.");
        exit(SeminarRegLine.FindFirst());
    end;

    local procedure CreateDim(Type1: integer; No1: Code[20]; Type2: Integer; No2: Code[20]; Type3: Integer; No3: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        sal: record "Sales Header";
        TableID: List of [Integer];
        No: list of [Code[20]];
        OldDimSetID: Integer;
        DimSource: List of [Dictionary of [Integer, Code[20]]];
        count: Integer;
    begin
        SourceCodeSetup.get;
        DimensionMgt.AddDimSource(DimSource, Type1, No1);
        DimensionMgt.AddDimSource(DimSource, Type2, No2);
        DimensionMgt.AddDimSource(DimSource, Type3, No3);

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" := DimensionMgt.GetRecDefaultDimID(Rec, CurrFieldNo, DimSource, SourceCodeSetup.Sales, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);
        if (OldDimSetID <> "Dimension Set ID") and SeminarRegLinesExist() then begin
            Modify();
            UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;


    local procedure ValidateShortcutDimCode(FieldNumber: Integer; Var ShortcutDimCode: COde[20])
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimensionMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        if "No." <> '' then
            Modify();
        if OldDimSetID <> "Dimension Set ID" then begin
            Modify();
            if SeminarRegLinesExist() then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end
    end;

    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" := DimensionMgt.EditDimensionSet("Dimension Set ID", "No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        if OldDimSetID <> "Dimension Set ID" then begin
            Modify();
            if SeminarRegLinesExist then
                updateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    local procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        NewDimSetID: Integer;
    begin
        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not confirm(Text009) then
            exit;
        SeminarRegLine.Reset();
        SeminarRegLine.SetRange("Document No.", "No.");
        SeminarRegLine.LockTable;
        if SeminarRegLine.Find('-') then
            repeat
                NewDimSetID := DimensionMgt.GetDeltaDimSetID(SeminarRegLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if SeminarRegLine."Dimension Set ID" <> NewDimSetID then begin
                    SeminarRegLine."Dimension Set ID" := NewDimSetID;
                    DimensionMgt.UpdateGlobalDimFromDimSetID(SeminarRegLine."Dimension Set ID", SeminarRegLine."Shortcut Dimension 1 Code", SeminarRegLine."Shortcut Dimension 2 Code");
                    SeminarRegLine.Modify;
                end;
            until SeminarRegLine.Next = 0;
    end;
}