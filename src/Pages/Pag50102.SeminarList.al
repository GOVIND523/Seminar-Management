page 50102 "Seminar List"
{
    ApplicationArea = All;
    Caption = 'Seminar List';
    PageType = List;
    SourceTable = Seminar;
    UsageCategory = Lists;
    CardPageId = "Seminar card";
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("Seminar Duration"; Rec."Seminar Duration")
                {
                    ToolTip = 'Specifies the value of the Seminar Duration field.';
                }
                field("Seminar Price"; Rec."Seminar Price")
                {
                    ToolTip = 'Specifies the value of the Seminar Price field.';
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ToolTip = 'Specifies the value of the Gen. Prod. Posting Group field.';
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ToolTip = 'Specifies the value of the VAT Prod. Posting Group field.';
                }
            }
        }

        area(FactBoxes)
        {
            systempart(RecordLinks; Links)
            {
                ApplicationArea = all;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group("&Seminar")
            {
                action("Co&mments")
                {
                    ApplicationArea = All;
                    Caption = 'Comments', comment = 'NLB=""';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Comment;
                    RunObject = page "Comment Sheet";
                    RunPageLink = "Table Name" = const(Seminar), "No." = field("No.");
                }
            }
        }
    }
}