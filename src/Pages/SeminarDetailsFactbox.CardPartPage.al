// SME1.00 - 2024-04-17 - Govind
//   Chapter 3 - Lab 2
//     - Seminar Details Factbox Cardpart page created

page 50109 SeminarDetailsFactbox
{
    Caption = 'Seminar Details Factbox';
    PageType = CardPart;
    SourceTable = Seminar;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Seminar Duration"; Rec."Seminar Duration")
                {
                    ApplicationArea = All;
                }
                field("Minimum Participants"; Rec."Minimum Participants")
                {
                    ApplicationArea = All;
                }
                field("Maximum Participants"; Rec."Maximum Participants")
                {
                    ApplicationArea = All;
                }
                field("Seminar Price"; Rec."Seminar Price")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}