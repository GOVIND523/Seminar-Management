tableextension 50113 ResJournalLine extends "Res. Journal Line"
{
    fields
    {
        field(50000; "Seminar Registration No."; code[20])
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
