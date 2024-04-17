// SME1.00 - 2024-04-16 - Govind
//   Chapter 2 - Lab 1
//     - Add fields to the resource table 
tableextension 50100 "Resouce Extension" extends Resource
{
    fields
    {
        field(50100; "Internal/External"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Internal/external';
            OptionMembers = Internal,External;
            OptionCaption = 'Internal,External';
        }
        field(50101; "Maximum Participants"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Maximum Participants';
        }
        field(50102; "Quantity Per Day"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Qunatity Per Day';
        }
    }
}