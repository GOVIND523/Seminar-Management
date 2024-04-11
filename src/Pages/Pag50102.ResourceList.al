pageextension 50101 "ResourceListExt" extends "Resource List" //OriginalId
{
    layout
    {
        addafter(Type)
        {
            field("Internal/External"; Rec."Internal/External")
            {
                Caption = 'Internal/External';
                ToolTip = 'Specifies wether the resource is internal or external.';
                ApplicationArea = All;
            }
            // field("Quantity Per Day"; Rec."Quantity Per Day")
            // {
            //     Caption = 'Quantity Per Day';
            //     ToolTip = 'Specifies the quantity the resource can accomodate per day.';
            //     ApplicationArea = all;
            // }
            field("Maximum Participants"; Rec."Maximum Participants")
            {
                Caption = 'Maximum Participants';
                Visible = ShowMaxParticipants;
                Tooltip = 'Maximum participants for the resource';
                ApplicationArea = All;
            }
        }
        modify(Type)
        {
            Visible = ShowType;
        }
    }

    actions
    {
    }

    var
        ShowType: Boolean;
        ShowMaxParticipants: Boolean;

    trigger OnOpenPage()
    begin
        //Rec.FilterGroup(3);
        ShowType := Rec.GetFilter(Type) = '';
        ShowMaxParticipants := Rec.GetFilter(Type) = Format(rec.type::machine);
        //rec.FilterGroup(0);
    end;
}