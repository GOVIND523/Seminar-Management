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
        field(501012; "Quantity Per Day"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Qunatity Per Day';
        }
    }
}