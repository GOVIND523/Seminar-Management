// SME1.00 - 2024-04-17 - Govind
//   Chapter 3 - Lab 2
//     - Source Code Setup Table extended

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
