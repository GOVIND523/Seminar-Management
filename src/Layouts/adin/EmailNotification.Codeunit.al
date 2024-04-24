// SME1.00 - 2024-04-17 - Govind
//   Chapter 4 - Lab 3 -  additional
//     -- EmailNotification Codeunit created

codeunit 50103 "EmailNotification"
{

    procedure SendEmailWithAttachment(SeminarRegistrationHeader: Record PostedSeminarRegHeader)
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
        Semline2: Record SeminarRegistrationLine;


    begin
        SemLine.Reset();
        SemLine.SetRange("Document No.", SeminarRegistrationHeader."No.");
        if SemLine.FindSet() then begin

            repeat
                Semline2.Reset();
                Semline2.SetRange("Line No.", SemLine."Line No.");
                RecRef.GetTable(SemLine);
                if Semline2.FindFirst() then begin
                    EmailMessage.Create('mercylynkay@gmail.com', 'Certificate Of Participation', 'Please find the Attached Certificate');
                    TempBlob.CreateOutStream(OutStr);
                    Report.SaveAs(Report::SeminarRegistrationCertificate, '', ReportFormat::Pdf, OutStr, RecRef);
                    TempBlob.CreateInStream(InStr);
                    EmailMessage.AddAttachment('Certificate.pdf', 'PDF', InStr);
                    Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
                end;
            until SemLine.Next() = 0;
            Message('Email Send');
        end;
    end;




}