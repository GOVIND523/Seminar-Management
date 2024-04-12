page 50104 "Seminar card"
{
    ApplicationArea = All;
    Caption = 'Seminar card';
    PageType = Card;
    SourceTable = Seminar;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    trigger OnAssistEdit()
                    begin
                        if rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("Maximum Participants"; Rec."Maximum Participants")
                {
                    ToolTip = 'Specifies the value of the Maximum Participants field.';
                }
                field("Minimum Participants"; Rec."Minimum Participants")
                {
                    ToolTip = 'Specifies the value of the Minimum Participants field.';
                }
                field("Search Name"; Rec."Search Name")
                {
                    ToolTip = 'Specifies the value of the Search Name field.';
                }
                field("Seminar Duration"; Rec."Seminar Duration")
                {
                    ToolTip = 'Specifies the value of the Seminar Duration field.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies the value of the Blocked field.';
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ToolTip = 'Specifies the value of the Last Date Modified field.';
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';

                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ToolTip = 'Specifies the value of the Gen. Prod. Posting Group field.';
                }
                field("Seminar Price"; Rec."Seminar Price")
                {
                    ToolTip = 'Specifies the value of the Seminar Price field.';
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ToolTip = 'Specifies the value of the VAT Prod. Posting Group field.';
                }
            }
        }
        area(FactBoxes)
        {
            systempart(recordlinks; Links)
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