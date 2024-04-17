// SME1.00 - 2024-04-16 - Govind
//   Chapter 2 - Lab 1
//      - Added Int/Ext, Max Participants to the listpage
pageextension 50101 "ResourceListPageExt" extends "Resource List" //OriginalId
{
    layout
    {
        addafter(Type)
        {
            field("Internal/External"; Rec."Internal/External")
            {
                ToolTip = 'Specifies wether the resource is internal or external.';
                ApplicationArea = All;
            }

            field("Maximum Participants"; Rec."Maximum Participants")
            {
                Visible = ShowMaxParticipants;
                Tooltip = 'Maximum participants for the resource.';
                ApplicationArea = All;
            }
        }
        modify(Type)
        {
            Visible = ShowType;
        }
    }

    var
        ShowType: Boolean;
        ShowMaxParticipants: Boolean;

    trigger OnAfterGetRecord()
    begin
        ShowType := Rec.GetFilter(Type) = '';
        ShowMaxParticipants := rec.GetFilter(Type) = Format(rec.type::machine)
    end;
}