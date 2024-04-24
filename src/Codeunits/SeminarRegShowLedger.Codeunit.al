// SME1.00 - 2024-04-18 - Govind
//   Chapter 4 - Lab 3
//     - SeminarLedgerEntries Listpage created 

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
