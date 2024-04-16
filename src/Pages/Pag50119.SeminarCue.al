page 50119 "seminar Cue"
{
    ApplicationArea = All;
    Caption = 'seminar Cue';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Seminar Cue";

    layout
    {
        area(content)
        {
            cuegroup(General)
            {
                Caption = 'Seminar Registration';

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
