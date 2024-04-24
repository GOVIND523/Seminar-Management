// SME1.00 - 2024-04-17 - Govind
//   Chapter 4 - Lab 2
//     - PostedSeminarReg Listpage created
//     - Added action to view realated comment lines and charges

page 50113 PostedSeminarRegList
{
    ApplicationArea = All;
    Caption = 'Posted Seminar Registration List';
    PageType = List;
    SourceTable = PostedSeminarRegHeader;
    UsageCategory = Lists;
    Editable = false;
    CardPageId = PostedSeminarRegistration;

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
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                }
                field("Seminar No."; Rec."Seminar No.")
                {
                    ApplicationArea = All;
                }
                field("Seminar Name"; Rec."Seminar Name")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec."Seminar registartion Status")
                {
                    ApplicationArea = All;
                }
                field(Approval_Status; Rec."Approval Status")
                {
                    ApplicationArea = All;
                }
                field(Duration; Rec.Duration)
                {
                    ApplicationArea = All;
                }
                field("Maximum Participants"; Rec."Maximum Participants")
                {
                    ApplicationArea = All;
                }
                field("Room Code."; Rec."Room Resource No.")
                {
                    ApplicationArea = All;
                }
            }

        }
        area(FactBoxes)
        {
            part(SeminarDetails; SeminarDetailsFactbox)
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("Seminar No.");
            }
            systempart(RecordLinks; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            group("&Seminar Registration")
            {
                action("Co&mments")
                {
                    ApplicationArea = All;
                    Caption = 'Co&mments';
                    Image = Comment;
                    RunObject = page SeminarCommentSheet;
                    RunPageLink = "No." = field("No.");
                    RunPageView = where("Document Type" = const("Posted Seminar Registration"));
                }
                action("&Charges")
                {
                    ApplicationArea = All;
                    Caption = '&Charges';
                    Image = Cost;
                    RunObject = page PostedSeminarCharges;
                    RunPageLink = "Document No." = field("No.");
                }
            }
        }
        //     area(Processing)
        //     {
        //         action("&Navigate")
        //         {
        //             Image = Navigate;
        //             Promoted = true;
        //             PromotedCategory = Process;
        //             ApplicationArea = All;

        //             trigger OnAction()
        //             begin
        //                 Navigate.SetDoc(Rec."Posting Date", Rec."No.");
        //                 Navigate.Run();
        //             end;
        //         }
        //     }
    }

    var
        Navigate: Page Navigate;
}
