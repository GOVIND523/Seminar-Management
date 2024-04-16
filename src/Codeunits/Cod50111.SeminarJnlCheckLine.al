codeunit 50111 SeminarJnlCheckLine
{
    TableNo = SeminarJournalLine;

    trigger OnRun()
    begin
        RunCheck(Rec);
    end;

    var
        TEXT001: Label 'cannot be a closing date';
        Text000: Label 'is not within your range of allowed posting dates';

    procedure RunCheck(var SemJnlLine: Record SeminarJournalLine)

    begin
        If SemJnlLine.EmptyLine() then
            exit;

        SemJnlLine.TestField("Posting Date");
        SemJnlLine.TestField("Instructor Code");
        SemJnlLine.TestField("Seminar No.");
        // SemJnlLine.TestField("Job No.");

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

    local procedure CheckDates(SemJnlLine: Record SeminarJournalLine)
    begin
        if SemJnlLine."Posting Date" = ClosingDate(SemJnlLine."Posting Date") then
            SemJnlLine.FieldError("Posting Date", TEXT001);

        if (AllowPostingFrom = 0D) And (AllowPostingTo = 0D) then
            if UserId <> '' then
                if UserSetup.Get(UserId) then begin
                    AllowPostingFrom := UserSetup."Allow Deferral Posting From";
                    AllowPostingTo := UserSetup."Allow Posting To";
                end;

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

}