// SME1.00 - 2024-04-16 - Govind
//   Chapter 2 - Lab 2
//     - Setup table added to application area

table 50101 "Seminar Setup"
{
    Caption = 'Seminar Setup';

    fields
    {
        field(50100; "Primary Key"; Code[10])
        {
            Caption = 'Primary key';
        }
        field(50102; "Seminar Nos."; Code[10])
        {
            Caption = 'Seminar No.';
            TableRelation = "No. Series";
        }
        field(50101; "Seminar Registration Nos."; Code[10])
        {
            Caption = 'Seminar Registration No.';
            TableRelation = "No. Series";
        }
        field(50103; "Posted Seminar Reg. Nos."; Code[10])
        {
            Caption = 'Posted Seminar Registration No.';
            TableRelation = "No. Series";
        }


    }
}