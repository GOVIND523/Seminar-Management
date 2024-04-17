// SME1.00 - 2024-04-16 - Govind
//   Chapter 4 - Lab 1
//     - Added seminar cue table 

page 50119 "Seminar Details"
{
    ApplicationArea = All;
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Seminar Cue";

    layout
    {
        area(content)
        {
            cuegroup(General)
            {
                Caption = 'Seminars Registrations';
                field("Open Registration"; Rec."Open Registration")
                {
                    ToolTip = 'Specifies the value of the Open Registration field.';
                    Style = Ambiguous;

                }
                field("Pending Approval Registration"; Rec."Pending Approval Registration")
                {
                    ToolTip = 'Specifies the value of the Pending Approval Registration field.';
                    Style = StandardAccent;
                }
                field("Rejected Registration"; Rec."Rejected Registration")
                {
                    ToolTip = 'Specifies the value of the Rejected Registration field.';
                    Style = Attention;
                }
                field("Closed Registration"; Rec."Closed Registration")
                {
                    ToolTip = 'Specifies the value of the Closed Registration field.';
                    Style = Favorable;
                }
            }
        }

    }

    trigger OnOpenPage();
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;



}
