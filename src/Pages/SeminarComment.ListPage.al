// SME1.00 - 2024-04-17 - Govind
//   Chapter 4 - Lab 2
//     - SeminarComment Listpage created

page 50115 SeminarCommentList
{
    Caption = 'Seminar Comment List';
    PageType = List;
    SourceTable = SeminarCommentLine;
    UsageCategory = None;
    Editable = false;
    LinksAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                }
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }
}
