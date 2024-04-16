tableextension 50115 SourceCodeSetUpExt extends "Source Code Setup"
{
    fields
    {
        field(5000; Seminar; Code[10])
        {
            Caption = 'Seminar';
            DataClassification = CustomerContent;
            TableRelation = "Source Code";
        }


    }
}
