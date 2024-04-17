page 50120 "Posted Reg List"
{
    ApplicationArea = All;
    Caption = 'Posted Reg List';
    PageType = List;
    SourceTable = SeminarRegistrationHeader;
    SourceTableView = where(Posted = filter(true));
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = false;
    PromotedActionCategories = 'New,Process,Report,Request Approval,Approvals,';
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
                field(Status; Rec.Status)
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
                    Promoted = true;
                    RunObject = codeunit SeminarPostYesNo;
                }

            }
        }


    }
}
