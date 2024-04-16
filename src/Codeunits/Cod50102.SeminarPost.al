codeunit 50102 SeminarPost
{
    TableNo = SeminarRegistrationHeader;

    VAR
        SeminarRegHeader: Record "SeminarRegistrationHeader";
        SeminarRegLine: Record "SeminarRegistrationLine";
        PstdSeminarRegHeader: Record PostedSeminarRegHeader;
        PstdSeminarRegLine: Record PostedSeminarRegLine;
        SeminarCommentLine: Record "SeminarCommentLine";
        SeminarCommentLine2: Record "SeminarCommentLine";
        SeminarCharge: Record "SeminarCharge";
        PstdSeminarCharge: Record PostedSeminarCharge;
        Room: Record Resource;
        Instructor: Record Resource;
        Customer: Record Seminar;
        ResLedgEntry: Record "Res. Ledger Entry";
        SeminarJnlLine: Record SeminarJournalLine;
        SourceCodeSetup: Record "Source Code Setup";
        ResJnlLine: Record "Res. Journal Line";
        SeminarJnlPostLine: Codeunit SeminarJnlPostLine;
        ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimMgt: Codeunit DimensionManagement;
        Window: Dialog;
        SourceCode: Code[10];
        LineCount: Integer;
        NoParticipantErr: Label 'There is no participant to post.';
        PostingLineNoTxt: Label 'Posting lines              #2######\';
        Text003: Label 'Registration';
        Text004: Label 'Registration %1  -> Posted Reg. %2';
        Text005: Label 'The combination of dimensions used in %1 is blocked. %2';
        Text006: Label 'The combination of dimensions used in %1, line no. %2 is blocked. %3';
        Text007: Label 'The dimensions used in %1 are invalid. %2';
        Text008: Label 'The dimensions used in %1, line no. %2 are invalid. %3';
        SMTP: Codeunit "Email Message";



    trigger OnRun()
    begin
        CLEARALL;
        SeminarRegHeader := Rec;
        SeminarRegHeader.TESTFIELD("Posting Date");
        SeminarRegHeader.TESTFIELD("Document Date");
        SeminarRegHeader.TESTFIELD("Seminar No.");
        SeminarRegHeader.TESTFIELD(Duration);
        SeminarRegHeader.TESTFIELD("Instructor Resource No.");
        SeminarRegHeader.TESTFIELD("Room Resource No.");
        SeminarRegHeader.TESTFIELD(Approval_Status, SeminarRegHeader.Approval_Status::Closed);
        SeminarRegHeader.TestField(Status, SeminarRegHeader.Status::Approved);

        SeminarRegLine.RESET;
        SeminarRegLine.SETRANGE("Document No.", Rec."No.");
        IF SeminarRegLine.ISEMPTY THEN
            ERROR(NoParticipantErr);

        Window.OPEN(
          '#1#################################\\' +
           PostingLineNoTxt);
        Window.UPDATE(1, STRSUBSTNO('%1 %2', Text003, Rec."No."));

        IF SeminarRegHeader."Posting No." = '' THEN BEGIN
            Rec.TESTFIELD("Posting No. Series");
            Rec."Posting No." := NoSeriesMgt.GetNextNo(Rec."Posting No. Series", Rec."Posting Date", TRUE);
            Rec.MODIFY;
            COMMIT;
        END;
        SeminarRegLine.LOCKTABLE;

        SourceCodeSetup.GET;
        //SourceCode := SourceCodeSetup.Seminar;

        PstdSeminarRegHeader.INIT;
        PstdSeminarRegHeader.TRANSFERFIELDS(SeminarRegHeader);
        PstdSeminarRegHeader."No." := Rec."Posting No.";
        PstdSeminarRegHeader."No. Series" := Rec."Posting No. Series";
        PstdSeminarRegHeader."Source Code" := SourceCode;
        PstdSeminarRegHeader."User ID" := USERID;
        PstdSeminarRegHeader.INSERT;

        Window.UPDATE(1, STRSUBSTNO(Text004, Rec."No.",
          PstdSeminarRegHeader."No."));

        CopyCommentLines(
          SeminarCommentLine."Document Type"::"Seminar Registration",
          SeminarCommentLine."Document Type"::"Posted Seminar Registration",
          Rec."No.", PstdSeminarRegHeader."No.");
        CopyCharges(Rec."No.", PstdSeminarRegHeader."No.");

        LineCount := 0;
        SeminarRegLine.RESET;
        SeminarRegLine.SETRANGE("Document No.", Rec."No.");
        IF SeminarRegLine.FINDSET THEN BEGIN
            REPEAT
                LineCount := LineCount + 1;
                Window.UPDATE(2, LineCount);

                SeminarRegLine.TESTFIELD("Bill-to Customer No.");
                SeminarRegLine.TESTFIELD("Participant Contact No.");

                IF NOT SeminarRegLine."To Invoice" THEN BEGIN
                    SeminarRegLine."Seminar Price" := 0;
                    SeminarRegLine."Line Discount %" := 0;
                    SeminarRegLine."Line Discount Amount" := 0;
                    SeminarRegLine.Amount := 0;
                END;

                // Post seminar entry
                PostSeminarJnlLine(SeminarJnlLine."Charge Type"::Participant); // Participant

                // Insert posted seminar registration line
                PstdSeminarRegLine.INIT;
                PstdSeminarRegLine.TRANSFERFIELDS(SeminarRegLine);
                PstdSeminarRegLine."Document No." := PstdSeminarRegHeader."No.";
                PstdSeminarRegLine.INSERT;
            UNTIL SeminarRegLine.NEXT = 0;
        END;

        // Post charges to seminar ledger
        PostCharges;

        // Post instructor to seminar ledger
        PostSeminarJnlLine(SeminarJnlLine."Charge Type"::Instructor); // Instructor

        // Post seminar room to seminar ledger
        PostSeminarJnlLine(SeminarJnlLine."Charge Type"::Room); // Room

        Rec.DELETE;
        SeminarRegLine.DELETEALL;

        SeminarCommentLine.SETRANGE("Document Type",
          SeminarCommentLine."Document Type"::"Seminar Registration");
        SeminarCommentLine.SETRANGE("No.", Rec."No.");
        SeminarCommentLine.DELETEALL;

        SeminarCharge.SETRANGE(Description);
        SeminarCharge.DELETEALL;
        Rec := SeminarRegHeader;
    end;

    LOCAL PROCEDURE CopyCommentLines(
        FromDocumentType: Enum "SeminarCommentLineDocumentType";
        ToDocumentType: Enum "SeminarCommentLineDocumentType";
        FromNumber: Code[20]; ToNumber: Code[20])
    BEGIN
        SeminarCommentLine.RESET;
        SeminarCommentLine.SETRANGE("Document Type", FromDocumentType);
        SeminarCommentLine.SETRANGE("No.", FromNumber);
        IF SeminarCommentLine.FINDSET THEN BEGIN
            REPEAT
                SeminarCommentLine2 := SeminarCommentLine;
                SeminarCommentLine2."Document Type" := ToDocumentType;
                SeminarCommentLine2."No." := ToNumber;
                SeminarCommentLine2.INSERT;
            UNTIL SeminarCommentLine.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE CopyCharges(FromNumber: Code[20]; ToNumber: Code[20])
    BEGIN
        SeminarCharge.RESET;
        SeminarCharge.SETRANGE("Document No.", FromNumber);
        IF SeminarCharge.FINDSET THEN BEGIN
            REPEAT
                PstdSeminarCharge.TRANSFERFIELDS(SeminarCharge);
                PstdSeminarCharge."Document No." := ToNumber;
                PstdSeminarCharge.INSERT;
            UNTIL SeminarCharge.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE PostResJnlLine(Resource: Record Resource): Integer
    BEGIN
        //Resource.TESTFIELD("Quantity Per Day");
        ResJnlLine.INIT;
        ResJnlLine."Entry Type" := ResJnlLine."Entry Type"::Usage;
        ResJnlLine."Document No." := PstdSeminarRegHeader."No.";
        ResJnlLine."Resource No." := Resource."No.";
        ResJnlLine."Posting Date" := SeminarRegHeader."Posting Date";
        ResJnlLine."Reason Code" := SeminarRegHeader."Reason Code";
        ResJnlLine.Description := SeminarRegHeader."Seminar Name";
        ResJnlLine."Gen. Prod. Posting Group" := SeminarRegHeader."Gen. Prod. Posting Group";
        ResJnlLine."Posting No. Series" := SeminarRegHeader."Posting No. Series";
        ResJnlLine."Source Code" := SourceCode;
        ResJnlLine."Resource No." := Resource."No.";
        ResJnlLine."Unit of Measure Code" := Resource."Base Unit of Measure";
        ResJnlLine."Unit Cost" := Resource."Unit Cost";
        ResJnlLine."Qty. per Unit of Measure" := 1;
        //ResJnlLine.Quantity := SeminarRegHeader.Duration * Resource."Quantity Per Day";
        ResJnlLine."Total Cost" := ResJnlLine."Unit Cost" * ResJnlLine.Quantity;
        // ResJnlLine."Seminar No." := SeminarRegHeader."Seminar No.";
        // ResJnlLine."Seminar Registration No." := PstdSeminarRegHeader."No.";
        ResJnlPostLine.RunWithCheck(ResJnlLine);

        ResLedgEntry.FINDLAST;
        EXIT(ResLedgEntry."Entry No.");
    END;

    LOCAL PROCEDURE PostSeminarJnlLine(ChargeType: Enum "SeminarJournalChargeType")
    BEGIN
        SeminarJnlLine.INIT;
        SeminarJnlLine."Seminar No." := SeminarRegHeader."Seminar No.";
        SeminarJnlLine."Posting Date" := SeminarRegHeader."Posting Date";
        SeminarJnlLine."Document Date" := SeminarRegHeader."Document Date";
        SeminarJnlLine."Document No." := PstdSeminarRegHeader."No.";
        SeminarJnlLine."Charge Type" := ChargeType;
        SeminarJnlLine."Instructor Code" := SeminarRegHeader."Instructor Resource No.";
        SeminarJnlLine."Starting Date" := SeminarRegHeader."Starting Date";
        SeminarJnlLine."Seminar Registration No." := PstdSeminarRegHeader."No.";
        SeminarJnlLine."Room Code." := SeminarRegHeader."Room Resource No.";
        SeminarJnlLine."Source Type" := SeminarJnlLine."Source Type"::Seminar;
        SeminarJnlLine."Source No." := SeminarRegHeader."Seminar No.";
        SeminarJnlLine."Source Code" := SourceCode;
        SeminarJnlLine."Reason Code" := SeminarRegHeader."Reason Code";
        SeminarJnlLine."Posting No. Series" := SeminarRegHeader."Posting No. Series";
        CASE ChargeType OF
            ChargeType::Instructor:
                BEGIN
                    Instructor.GET(SeminarRegHeader."Instructor Resource No.");
                    SeminarJnlLine.Description := Instructor.Name;
                    SeminarJnlLine.Type := SeminarJnlLine.Type::Resource;
                    SeminarJnlLine.Chargeable := FALSE;
                    SeminarJnlLine.Quantity := SeminarRegHeader.Duration;
                    SeminarJnlLine."Res. Ledger Entry No." := PostResJnlLine(Instructor);
                END;
            ChargeType::Room:
                BEGIN
                    Room.GET(SeminarRegHeader."Room Resource No.");
                    SeminarJnlLine.Description := Room.Name;
                    SeminarJnlLine.Type := SeminarJnlLine.Type::Resource;
                    SeminarJnlLine.Chargeable := FALSE;
                    SeminarJnlLine.Quantity := SeminarRegHeader.Duration;
                    // Post to resource ledger
                    SeminarJnlLine."Res. Ledger Entry No." := PostResJnlLine(Room);
                END;
            ChargeType::Participant:
                BEGIN
                    SeminarJnlLine."Bill-to Customer No." := SeminarRegLine."Bill-to Customer No.";
                    SeminarJnlLine."Participant Contact No." := SeminarRegLine."Participant Contact No.";
                    SeminarJnlLine."Participant Name" := SeminarRegLine."Participant Name";
                    SeminarJnlLine.Description := SeminarRegLine."Participant Name";
                    SeminarJnlLine.Type := SeminarJnlLine.Type::Resource;
                    SeminarJnlLine.Chargeable := SeminarRegLine."To Invoice";
                    SeminarJnlLine.Quantity := 1;
                    SeminarJnlLine."Unit Price" := SeminarRegLine.Amount;
                    SeminarJnlLine."Total Price" := SeminarRegLine.Amount;
                END;
            ChargeType::Charge:
                BEGIN
                    SeminarJnlLine.Description := SeminarCharge.Description;
                    SeminarJnlLine."Bill-to Customer No." := SeminarCharge."Bill-to Customer No.";
                    SeminarJnlLine.Type := SeminarCharge.Type;
                    SeminarJnlLine.Quantity := SeminarCharge.Quantity;
                    SeminarJnlLine."Unit Price" := SeminarCharge."Unit Price";
                    SeminarJnlLine."Total Price" := SeminarCharge."Total Price";
                    SeminarJnlLine.Chargeable := SeminarCharge."To Invoice";
                END;
        END;

        SeminarJnlPostLine.RunWithCheck(SeminarJnlLine);
    END;

    LOCAL PROCEDURE PostCharges()

    BEGIN
        SeminarCharge.RESET;
        SeminarCharge.SETRANGE("Document No.", SeminarRegHeader."No.");
        IF SeminarCharge.FINDSET THEN BEGIN
            REPEAT

                //Contact.SetRange("No.", SeminarCharge.);
                PostSeminarJnlLine(SeminarJnlLine."Charge Type"::Charge); // Charge


            UNTIL SeminarCharge.NEXT = 0;

        END;
    END;

    procedure postSeminar(SeminarRegistrationHeader: Record "SeminarRegistrationHeader")
    var
        GenJnLine: Record "Gen. Journal Line";
        LineNo: Integer;
        SemRegLine: Record SeminarRegistrationLine;
        EmailBody: Text[500];
        Contact: Record Contact;
        Email1: Text[50];
        Email: Codeunit Email;
        CompanyInformation: Record "Company Information";


    begin

        GenJnLine.Reset();
        GenJnLine.SetRange("Journal Template Name", 'GENERAL');
        GenJnLine.SetRange("Journal Batch name", 'SEMINAR');
        GenJnLine.DeleteAll();
        LineNo := 10;

        //find customer
        SemRegLine.Reset();
        SemRegLine.SetRange("Document No.", SeminarRegistrationHeader."No.");
        if SemRegLine.FindSet() then begin
            repeat
                GenJnLine.Init();
                GenJnLine."Journal Template Name" := 'GENERAL';
                GenJnLine."Journal Batch Name" := 'SEMINAR';
                GenJnLine."Line No." := GenJnLine."Line No." + 10;
                GenJnLine."Account Type" := GenJnLine."Account Type"::Customer;
                GenJnLine."Account No." := SemRegLine."Bill-to Customer No.";
                GenJnLine.Validate("Account No.");
                GenJnLine."Posting Date" := Today;
                GenJnLine."Document No." := SeminarRegistrationHeader."No.";
                GenJnLine."External Document No." := SeminarRegistrationHeader."No.";
                GenJnLine.Description := 'Seminar Charges ' + '' + SemRegLine."Participant Contact No.";
                GenJnLine.Amount := SemRegLine.Amount;
                GenJnLine.Validate(Amount);
                GenJnLine."Bal. Account Type" := GenJnLine."Bal. Account Type"::"G/L Account";
                GenJnLine."Bal. Account No." := '6820';
                if GenJnLine.Amount <> 0 then
                    GenJnLine.Insert();
            until SemRegLine.Next() = 0;
            Codeunit.Run(Codeunit::"Gen. Jnl.-Post", GenJnLine);
        end;

        //email

        SemRegLine.Reset();
        SemRegLine.SetRange("Document No.", SeminarRegistrationHeader."No.");
        if SemRegLine.FindSet() then begin
            repeat
                Contact.Reset();
                Contact.SetRange("No.", SemRegLine."Participant Contact No.");
                if Contact.Findset then
                    message('%1', contact."No.");
                Email1 := Contact."E-Mail";
                //EmailBody := 'Dear Participant Please Find attached Email';

                EmailBody := 'Dear' + ' ' + '<b>' + Contact.Name + ',' + '</b><br>';
                EmailBody := EmailBody + ' ' + 'You have been registered for ' + SeminarRegistrationHeader."Seminar Name" + 'Seminar' + '<br>';
                EmailBody := EmailBody + ' ' + 'On Date' + ' ' + Format(SeminarRegistrationHeader."Starting Date") + 'For' + ' ' + Format(SeminarRegistrationHeader.Duration) + 'Hours' + '<br>';
                EmailBody := 'NB: This is a system generated Email. You do not need to respond to it. in case of any further clarifications or help, kindly contact us through seminaracademy.co.ke' + '<br>';


                CompanyInformation.Get();
                EmailBody := EmailBody + 'Kind regards,' +
                 '<b></br>' + CompanyInformation.Name + '</b></br>' + CompanyInformation.Address + '</br>' +
                 CompanyInformation.City + '</br>' + CompanyInformation."Post Code" + '</br>' +
                 CompanyInformation."Country/Region Code" + '</br>' + CompanyInformation."Phone No." + '</br>' +
                 CompanyInformation."E-Mail";
                SMTP.Create(Email1, 'Seminar Registration', EmailBody, true);
                Email.Send(SMTP, Enum::"Email Scenario"::Default);
            until SemRegLine.Next() = 0;
            Message('Email Notificattion Send');

        end;
        SeminarRegistrationHeader.Posted := true;
        SeminarRegistrationHeader.Modify(true);


    end;

    procedure SendEmailWithAttachment(SeminarRegistrationHeader: Record SeminarRegistrationHeader)
    var
        ReportExample: Report SeminarRegistrationCertificate;
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        InStr: Instream;
        OutStr: OutStream;
        ReportParameters: Text;
        SemHeader: Record SeminarRegistrationHeader;
        SemLine: Record SeminarRegistrationLine;
        Contact: Record Contact;
        Email2: Text[80];
        RecRef: RecordRef;

    begin
        //xReportParameters := ReportExample.RunRequestPage();
        // SemHeader.Reset();
        // SemHeader.SetRange("No.", SeminarRegistrationHeader."No.");
        // if SemHeader.FindFirst() then begin
        //     RecRef.GetTable(SemHeader);
        //     Message('%1', SemHeader."No.");
        SemLine.Reset();
        SemLine.SetRange("Document No.", SemHeader."No.");
        SemLine.SetRange("Line No.", SemLine."Line No.");
        Message('%1', SeminarRegistrationHeader."No.");
        if SemLine.FindSet() then
            repeat
            until SemLine.Next() = 0;
        Message('%1', SemLine."Line No.");
        SemLine.FindSet();
        if SemLine.FindSet() then begin
            repeat
                Contact.Reset();
                Contact.SetRange("No.", SemLine."Participant Contact No.");
                if Contact.Findset then
                    Email2 := Contact."E-Mail";
                Message('%1', SemLine."Participant Contact No.");


                EmailMessage.Create('mercylynkay@gmail.com', 'Certificate Of Participation', 'Please find the Attached Certificate');
                RecRef.GetTable(SemLine);
                TempBlob.CreateOutStream(OutStr);
                Report.SaveAs(Report::SeminarRegistrationCertificate, '', ReportFormat::Pdf, OutStr, RecRef);
                TempBlob.CreateInStream(InStr);
                EmailMessage.AddAttachment('Certificate.pdf', 'PDF', InStr);
                Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
            until SemLine.Next() = 0;
            Message('Email Send');
        end;


        //end;


    end;




}
