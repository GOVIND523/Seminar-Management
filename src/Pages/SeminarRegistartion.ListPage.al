// SME1.00 - 2024-04-17 - Govind
//   Chapter 4 - Lab 5
//     - SeminarRegistartion Listpage created

// SME1.00 - 2024-04-18 - Govind
//   Chapter 4 - Lab 5
//     - Added posting action
page 50108 SeminarRegistrationList
{
    ApplicationArea = All;
    Caption = 'Seminar Registration List';
    PageType = List;
    SourceTable = SeminarRegistrationHeader;
    UsageCategory = Lists;
    Editable = false;
    CardPageId = SeminarRegistration;

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
                field(Status; Rec."Approval Status")
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
                field("Room Code"; Rec."Room Resource No.")
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
                    RunPageView = where("Document Type" = const("Seminar Registration"));
                }
                action("&Charges")
                {
                    ApplicationArea = All;
                    Caption = '&Charges';
                    Image = Cost;
                    RunObject = page SeminarCharges;
                    RunPageLink = "Document No." = field("No.");
                }
            }
        }

        area(Processing)
        {
            group(Posting)
            {
                Image = Post;
                Caption = 'Posting';

                action("P&ost")
                {
                    Caption = 'P&ost';
                    ApplicationArea = All;
                    Image = PostDocument;
                    RunObject = codeunit SeminarPostYesNo;
                }
            }

            action("Dimensions")
            {
                ApplicationArea = All;
                Caption = 'Dimensions', comment = 'NLB="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Dimensions;
                ShortcutKey = 'Shift+ctrl+d';
                trigger OnAction()
                begin
                    Rec.showDocDim;
                end;
            }
        }
    }
}
