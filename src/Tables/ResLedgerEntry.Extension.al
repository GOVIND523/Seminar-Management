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
