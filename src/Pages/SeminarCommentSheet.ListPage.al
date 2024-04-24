// SME1.00 - 2024-04-17 - Govind
//   Chapter 4 - Lab 2
//     - SeminarCommentSheet listpage create

page 50110 SeminarCommentSheet
{
    Caption = 'Seminar Comment Sheet';
    PageType = List;
    SourceTable = SeminarCommentLine;
    UsageCategory = None;
    MultipleNewLines = true;
    LinksAllowed = false;
    DelayedInsert = true;
    DataCaptionFields = "No.";
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
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

    trigger OnOpenPage()
    begin
        Rec.SetUpNewLine();
    end;
}
