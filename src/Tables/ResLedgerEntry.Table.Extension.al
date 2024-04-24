// SME1.00 - 2024-04-17 - Govind
//   Chapter 4 - Lab 4
//     - ResourceLedgerEntry table extended 

//$$ ISSUES
//$$ There's an issues with adding these fields as rather they would only be available if we could change the resource journal line posting procedure 

tableextension 50114 ResLedgerEntry extends "Res. Ledger Entry"
{
    fields
    {
        field(50000; "Seminar Registration No."; Code[20])
        {
            Caption = 'Seminar Registration No.';
            DataClassification = ToBeClassified;
        }
        field(50001; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No';
            DataClassification = CustomerContent;
            TableRelation = Seminar;
        }
    }
}
