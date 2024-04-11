page 50103 "Seminar Setup"
{
    ApplicationArea = All;
    Caption = 'Seminar Setup';
    PageType = Card;
    SourceTable = "Seminar Setup";

    layout
    {
        area(content)
        {
            group(Numbering)
            {
                Caption = 'Numbering';

                field("Seminar Nos."; Rec."Seminar Nos.")
                {
                    ToolTip = 'Specifies the value of the Seminar Nos. field.';
                }
                field("Seminar Registration Nos."; Rec."Seminar Registration Nos.")
                {
                    ToolTip = 'Specifies the value of the Seminar Registration Nos. field.';
                }
                field("Posted Seminar Reg. Nos."; Rec."Posted Seminar Reg. Nos.")
                {
                    ToolTip = 'Specifies the value of the Posted Seminar Reg. Nos. field.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not rec.findfirst then
            rec.Insert();
    end;
}


