codeunit 50113 SeminarEmail
{
    trigger OnRun()
    var
        PaticipantRep: Report RegParticipants;
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        InStr: Instream;
        OutStr: OutStream;
        ReportParameters: Text;
        xmlDoc: XmlDocument;
    begin
        ReportParameters := PaticipantRep.RunRequestPage();
        TempBlob.CreateOutStream(OutStr);
        Report.SaveAs(Report::"RegParticipants", ReportParameters, ReportFormat::Pdf, OutStr);
        TempBlob.CreateInStream(InStr);
        EmailMessage.Create('rajpurohitgovind942@gmail.com', 'Participants List', 'body');
        EmailMessage.AddAttachment('Participants.pdf', 'PDF', InStr);
        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
    end;
}