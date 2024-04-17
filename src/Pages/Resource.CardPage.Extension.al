// SME1.00 - 2024-04-16 - Govind
//   Chapter 2 - Lab 1
//     - Added Internal/External and Quantity Per Day fields to General FastTab
//     - Added Max Participants field to Room FastTab
pageextension 50100 "ResourceCardPageExt" extends "Resource Card" //OriginalId
{
    layout
    {
        addlast(General)
        {
            field("Internal/External"; Rec."Internal/External")
            {
                Caption = 'Internal/External';
                ToolTip = 'Specifies wether the resource is internal or external.';
                ApplicationArea = All;
            }
            field("Quantity Per Day"; Rec."Quantity Per Day")
            {
                Caption = 'Quantity Per Day';
                ToolTip = 'Specifies the quantity the resource can accomodate per day.';
                ApplicationArea = all;
            }
        }
        addafter("Personal Data")
        {
            group(Room)
            {
                Caption = 'Room';
                field("Maximum Participants"; Rec."Maximum Participants")
                {
                    Caption = 'Maximum Participants';
                    Tooltip = 'Maximum participants for the resource';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}