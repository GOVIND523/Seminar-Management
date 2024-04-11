table 50101 "Seminar Setup"
{
    Caption = 'Seminar Setup';
    fields
    {
        field(50100; "Primary Key"; Code[10])
        {
            DataClassification = tobeclassified;
        }
        field(50102; "Seminar Nos."; Code[10])
        {
            DataClassification = tobeclassified;
            TableRelation = "No. Series";
        }
        field(50101; "Seminar Registration Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50103; "Posted Seminar Reg. Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }
}