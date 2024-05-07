// SME1.00 - 2024-04-17 - Govind
//   Chapter 4 - Lab 2
//     - SeminarJournalPostLine Codeunit created
//     - RunWithCheck() and Code() procedure added

codeunit 50110 SeminarJnlPostLine
{
    TableNo = SeminarJournalLine;

    trigger OnRun()
    begin

    end;

    var
        SeminarJnlLineToCheck: Record SeminarJournalLine;
        SeminarLedgerEntry: Record SeminarLedgerEntry;
        SeminarRegister: Record SeminarRegister;
        SeminarJnlCheckLine: Codeunit SeminarJnlCheckLine;
        NextEntryNo: Integer;

    //transfers the data to another record var and runs code procedure
    PROCEDURE RunWithCheck(VAR SeminarJnlLine: Record SeminarJournalLine)
    BEGIN
        SeminarJnlLineToCheck.COPY(SeminarJnlLine);
        Code;
        SeminarJnlLine := SeminarJnlLineToCheck;
    END;


    PROCEDURE Code()
    BEGIN
        IF SeminarJnlLineToCheck.EmptyLine THEN
            EXIT;

        SeminarJnlCheckLine.RunCheck(SeminarJnlLineToCheck);

        //getting the last assigned EntryNo in the seminar ledger entry
        IF NextEntryNo = 0 THEN BEGIN
            SeminarLedgerEntry.LOCKTABLE;
            IF SeminarLedgerEntry.FINDLAST THEN
                NextEntryNo := SeminarLedgerEntry."Entry No.";
            NextEntryNo := NextEntryNo + 1;
        END;

        IF SeminarJnlLineToCheck."Document Date" = 0D THEN
            SeminarJnlLineToCheck."Document Date" := SeminarJnlLineToCheck."Posting Date";

        //SeminarRegister update to create log of the ledger entry
        IF SeminarRegister."No." = 0 THEN BEGIN
            SeminarRegister.Reset();
            SeminarRegister.SetRange("No.");
            SeminarRegister.LOCKTABLE;
            IF (NOT SeminarRegister.FINDLAST) OR (SeminarRegister."To Entry No." <> 0) THEN BEGIN
                SeminarRegister.INIT;
                SeminarRegister."No." := SeminarRegister."No." + 1;
                SeminarRegister."From Entry No." := NextEntryNo;
                SeminarRegister."To Entry No." := NextEntryNo;
                SeminarRegister."Creation Date" := TODAY;
                SeminarRegister."Source Code" := SeminarJnlLineToCheck."Source Code";
                SeminarRegister."Journal Batch Name" := SeminarJnlLineToCheck."Journal Batch Name";
                SeminarRegister."User ID" := USERID;
                SeminarRegister.INSERT;
            END;
        END;
        SeminarRegister."To Entry No." := NextEntryNo;
        SeminarRegister.MODIFY;


        //Entry into the ledger table (posting)
        SeminarLedgerEntry.Reset();
        SeminarLedgerEntry.SetRange("Entry No.");
        SeminarLedgerEntry.INIT;
        SeminarLedgerEntry."Seminar No." := SeminarJnlLineToCheck."Seminar No.";
        SeminarLedgerEntry."Posting Date" := SeminarJnlLineToCheck."Posting Date";
        SeminarLedgerEntry."Document Date" := SeminarJnlLineToCheck."Document Date";
        SeminarLedgerEntry."Entry Type" := SeminarJnlLineToCheck."Entry Type";
        SeminarLedgerEntry."Document No." := SeminarJnlLineToCheck."Document No.";
        SeminarLedgerEntry.Description := SeminarJnlLineToCheck.Description;
        SeminarLedgerEntry."Bill-to Customer No." := SeminarJnlLineToCheck."Bill-to Customer No.";
        SeminarLedgerEntry."Charge Type" := SeminarJnlLineToCheck."Charge Type";
        SeminarLedgerEntry.Type := SeminarJnlLineToCheck.Type;
        SeminarLedgerEntry.Quantity := SeminarJnlLineToCheck.Quantity;
        SeminarLedgerEntry."Unit Price" := SeminarJnlLineToCheck."Unit Price";
        SeminarLedgerEntry."Total Price" := SeminarJnlLineToCheck."Total Price";
        SeminarLedgerEntry."Participant Contact No." := SeminarJnlLineToCheck."Participant Contact No.";
        SeminarLedgerEntry."Participant Name" := SeminarJnlLineToCheck."Participant Name";
        SeminarLedgerEntry.Chargeable := SeminarJnlLineToCheck.Chargeable;
        SeminarLedgerEntry."Room Code." := SeminarJnlLineToCheck."Room Code.";
        SeminarLedgerEntry."Instructor Code" := SeminarJnlLineToCheck."Instructor Code";
        SeminarLedgerEntry."Starting Date" := SeminarJnlLineToCheck."Starting Date";
        SeminarLedgerEntry."Seminar Registration No." := SeminarJnlLineToCheck."Seminar Registration No.";
        SeminarLedgerEntry."Res. Ledger Entry No." := SeminarJnlLineToCheck."Res. Ledger Entry No.";
        SeminarLedgerEntry."Source Type" := SeminarJnlLineToCheck."Source Type";
        SeminarLedgerEntry."Source No." := SeminarJnlLineToCheck."Source No.";
        SeminarLedgerEntry."Journal Batch Name" := SeminarJnlLineToCheck."Journal Batch Name";
        SeminarLedgerEntry."Source Code" := SeminarJnlLineToCheck."Source Code";
        SeminarLedgerEntry."Reason Code" := SeminarJnlLineToCheck."Reason Code";
        SeminarLedgerEntry."No. Series" := SeminarJnlLineToCheck."Posting No. Series";
        SeminarLedgerEntry."User ID" := USERID;
        SeminarLedgerEntry."Entry No." := NextEntryNo;
        SeminarLedgerEntry."Global Dimension Code 1" := SeminarJnlLineToCheck."Shortcut Dimension 1 Code";
        SeminarLedgerEntry."Global Dimension Code 2" := SeminarJnlLineToCheck."Shortcut Dimension 2 Code";
        SeminarLedgerEntry."Dimension Set ID" := SeminarJnlLineToCheck."Dimension Set ID";
        SeminarLedgerEntry.INSERT;
        NextEntryNo := NextEntryNo + 1;
    END;
}
