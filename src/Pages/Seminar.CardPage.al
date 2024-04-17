// SME1.00 - 2024-04-16 - Govind
//   Chapter 2 - Lab 3
//     - Seminar Card Page created
//     - AssistEdit() procedure trigger OnAssistEdit for No.  
//     - Adding comments action to view the comment sheet for the seminar

// SME1.00 - 2024-04-17 - Govind
//   Chapter 3 - Lab 1
//     - Added Available seats field

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
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. field.';
                    trigger OnAssistEdit()
                    begin
                        if rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("Maximum Participants"; Rec."Maximum Participants")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Maximum Participants field.';
                }
                field("Minimum Participants"; Rec."Minimum Participants")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Minimum Participants field.';
                }
                field("Available Seats"; Rec."Total Booking")
                {
                    ApplicationArea = all;
                    ToolTip = 'Shows the total registartions for the selected seminar';
                }
                field("Search Name"; Rec."Search Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Search Name field.';
                }
                field("Seminar Duration"; Rec."Seminar Duration")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Seminar Duration field.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Blocked field.';
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Last Date Modified field.';
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';

                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Gen. Prod. Posting Group field.';
                }
                field("Seminar Price"; Rec."Seminar Price")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Seminar Price field.';
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = all;
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
                    Caption = 'Comments', comment = 'NLB="Comments"';
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