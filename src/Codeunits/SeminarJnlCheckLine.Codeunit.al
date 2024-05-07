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
    var
        tableID: array[10] of Integer;
        No: array[10] of Code[20];
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
        IF NOT DimensionMgt.CheckDimIDComb(SemJnlLine."Dimension Set ID") THEN
            ERROR(Text002, SemJnlLine.TABLECAPTION, SemJnlLine."Journal Template Name", SemJnlLine."Journal Batch Name", SemJnlLine."Line No.", DimensionMgt.GetDimCombErr);
       
       
        No[1] := SemJnlLine."Seminar No.";
        TableID[2] := DATABASE::Resource;
        No[2] := SemJnlLine."Instructor Code";
        TableID[3] := DATABASE::Resource;
        No[3] := SemJnlLine."Room Code.";
        // IF NOT DimensionMgt.CheckDimValuePosting(TableID, No, SemJnlLine."Dimension Set ID") THEN
        // IF "Line No." <> 0 THEN
        //     ERROR(Text003, TABLECAPTION, "Journal Template Name", "Journal Batch Name", "Line No.", DimensionMgt.GetDimValuePostingErr)
        // ELSE
        //     ERROR(DimensionMgt.GetDimValuePostingErr)

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


    local procedure CheckDimIDComb()
    begin

    end;


    var
        DimensionMgt: Codeunit DimensionManagement;
        GLSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";
        AllowPostingFrom: Date;
        AllowPostingTo: Date;
        TEXT001: Label 'cannot be a closing date';
        Text000: Label 'is not within your range of allowed posting dates';
        Text002: Label 'The combination of dimensions used in %1 %2, %3, %4 is blocked. %5';
        Text003: Label 'A dimension used in %1 %2,%3,$4 has caused an error. %5';

}
