// SME1.00 - 2024-04-17 - Govind
//   Chapter 4 - Lab 2
//     - SeminarJournalCheckLine Codeunit created
//     - RunCheck() and CheckDates() procedure added

codeunit 50111 SeminarJnlCheckLine
{
    TableNo = SeminarJournalLine;

    trigger OnRun()
    begin
        RunCheck(Rec);
    end;

    //run check for field validation as per the cases 
    procedure RunCheck(var SemJnlLine: Record SeminarJournalLine)
    begin
        If SemJnlLine.EmptyLine() then
            exit;

        SemJnlLine.TestField("Posting Date");
        SemJnlLine.TestField("Instructor Code");
        SemJnlLine.TestField("Seminar No.");

        CASE SemJnlLine."Charge Type" OF
            SemJnlLine."Charge Type"::Instructor:
                SemJnlLine.TestField("Instructor Code");
            SemJnlLine."Charge Type"::Room:
                SemJnlLine.TestField("Room Code.");
            SemJnlLine."Charge Type"::Participant:
                SemJnlLine.TestField("Participant Contact No.");
        END;

        IF SemJnlLine.Chargeable THEN
            SemJnlLine.TestField("Bill-to Customer No.");

        CheckDates(SemJnlLine);
    end;

    //check if the posting date is the closing date or not
    local procedure CheckDates(SemJnlLine: Record SeminarJournalLine)
    begin
        if SemJnlLine."Posting Date" = ClosingDate(SemJnlLine."Posting Date") then
            SemJnlLine.FieldError("Posting Date", TEXT001);

        //get the allowed posting dates for null userid 
        if (AllowPostingFrom = 0D) And (AllowPostingTo = 0D) then
            if UserId <> '' then
                if UserSetup.Get(UserId) then begin
                    AllowPostingFrom := UserSetup."Allow Deferral Posting From";
                    AllowPostingTo := UserSetup."Allow Posting To";
                end;
        //get teh allowed posting date 
        if (AllowPostingFrom = 0D) And (AllowPostingTo = 0D) then
            if GLSetup.Get then begin
                AllowPostingFrom := GLSetup."Allow Deferral Posting From";
                AllowPostingTo := GLSetup."Allow Posting To";
            end;

        if (SemJnlLine."Posting Date" < AllowPostingFrom) And (SemJnlLine."Posting Date" > AllowPostingTo) then
            SemJnlLine.FieldError("Posting Date", Text000);

        if (SemJnlLine."Document Date") <> 0D then
            if (SemJnlLine."Document Date") = ClosingDate(SemJnlLine."Posting Date") then
                SemJnlLine.FieldError("Document Date", TEXT001);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";
        AllowPostingFrom: Date;
        AllowPostingTo: Date;
        TEXT001: Label 'cannot be a closing date';
        Text000: Label 'is not within your range of allowed posting dates';

}