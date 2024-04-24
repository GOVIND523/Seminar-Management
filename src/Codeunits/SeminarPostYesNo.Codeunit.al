// SME1.00 - 2024-04-17 - Govind
//   Chapter 4 - Lab 5
//     - SeminarPostYesNo codeunit created

codeunit 50101 SeminarPostYesNo
{
    TableNo = SeminarRegistrationHeader;

    trigger OnRun()
    begin
        SeminarRegHeader.COPY(Rec);
        Code;
        Rec := SeminarRegHeader;
    end;

    var
        SeminarRegHeader: Record SeminarRegistrationHeader;
        SeminarPost: Codeunit SeminarPost;
        ContinuePostingQst: Label 'Continue to post Seminar Registration No.: %1?';
        PostedSemReg: Record PostedSeminarRegHeader;

    local procedure "Code"()
    begin
        if NOT Confirm(ContinuePostingQst, FALSE, SeminarRegHeader."No.") then
            exit;
        SeminarPost.Run(SeminarRegHeader);
        SeminarPost.postSeminar(SeminarRegHeader);
        if confirm('View the posted seminar registration') then begin
            PostedSemReg.Reset();
            PostedSemReg.Get(SeminarRegHeader."Posting No.");
            page.Run(50112, PostedSemReg);
        end;
        COMMIT;
    end;
}

