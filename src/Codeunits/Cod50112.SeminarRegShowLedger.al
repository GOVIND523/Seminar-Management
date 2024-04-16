codeunit 50112 SeminarRegShowLedger
{
    TableNo = SeminarRegister;

    trigger OnRun()
    begin
        SeminarLedgerEntry.SetRange("Entry No.", Rec."From Entry No.", Rec."To Entry No.");
        PAGE.Run(PAGE::SeminarLedgerEntries, SeminarLedgerEntry);
    end;

    var
        SeminarLedgerEntry: Record SeminarLedgerEntry;
}
