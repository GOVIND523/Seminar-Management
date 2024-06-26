// SME1.00 - 2024-04-17 - Govind
//   Chapter 4 - Lab 3
//     - PostedSeminarReg documentpage created 

// SME1.00 - 2024-04-17 - Govind
//   Chapter 3 - Lab 2
//     - Seminar Ledger Entry table created

// SME1.00 - 2024-04-24 - Govind
//   Chapter 5 - Lab 1
//     - Added navigate action 

page 50112 PostedSeminarRegistration
{
    Caption = 'Posted Seminar Registration';
    PageType = Document;
    SourceTable = PostedSeminarRegHeader;
    Editable = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                // add tooltips from here

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
                field("Instructor Code."; Rec."Room Resource No.")
                {
                    ApplicationArea = All;
                }
                field("Instructor Name"; Rec."Instructor Name")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
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
                field("Minimum Participants"; Rec."Minimum Participants")
                {
                    ApplicationArea = All;
                }
                field("Maximum Participants"; Rec."Maximum Participants")
                {
                    ApplicationArea = All;
                }
            }
            part(SeminarRegistrationLines; PostedSeminarRegSubform)
            {
                SubPageLink = "Document No." = field("No.");
                ApplicationArea = All;
            }

            group("Seminar Room")
            {
                field("Room Resource No."; Rec."Room Resource No.")
                {
                    ApplicationArea = All;
                }
                field("Room Name"; Rec."Room Name")
                {
                    ApplicationArea = All;
                }
                field("Room Address"; Rec."Room Address")
                {
                    ApplicationArea = All;
                }
                field("Room Address 2"; Rec."Room Address 2")
                {
                    ApplicationArea = All;
                }
                field("Room Post Code"; Rec."Room Post Code")
                {
                    ApplicationArea = All;
                }
                field("Room City"; Rec."Room City")
                {
                    ApplicationArea = All;
                }
                field("Room Country/Reg. Code"; Rec."Room Country/Reg. Code")
                {
                    ApplicationArea = All;
                }
                field("Room County"; Rec."Room County")
                {
                    ApplicationArea = All;
                }
            }
            group(Invoicing)
            {
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Seminar Price"; Rec."Seminar Price")
                {
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
                field("Line Discount"; Rec."Line Discount")
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
            part(CustomerDetails; "Customer Details FactBox")
            {
                ApplicationArea = All;
                Provider = SeminarRegistrationLines;
                SubPageLink = "No." = field("Bill-to Customer No.");
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
        area(Processing)
        {
            action("&Navigate")
            {
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Navigate.SetDoc(Rec."Posting Date", Rec."No.");
                    Navigate.Run();
                end;
            }


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

            //     action("Print report")
            //     {
            //         ApplicationArea = Basic;
            //         Image = Print;
            //         Promoted = true;

            //         trigger OnAction()
            //         begin
            //             Rec.SetRange("No.", Rec."No.");
            //             Report.Run(50000, true, true, Rec);
            //         end;
            //     }
            //     action("Print Certificate")
            //     {
            //         ApplicationArea = Basic;
            //         Image = Print;
            //         Promoted = true;

            //         trigger OnAction()
            //         begin
            //             Rec.SetRange("No.", Rec."No.");
            //             Report.Run(50005, true, true, Rec);
            //         end;
            //     }
            //     action("Send Email")
            //     {
            //         ApplicationArea = Basic, Suite;
            //         Caption = 'Send Email';
            //         Image = Email;
            //         ToolTip = 'Send email to this customer.';

            //         trigger OnAction()
            //         var
            //             SeminarPost: Codeunit SeminarPost;
            //             Email: Codeunit EmailNotification;
            //             SemLine: Record SeminarRegistrationLine;

            //         begin
            //             Email.SendEmailWithAttachment(Rec);
            //         end;
        }
    }

    var
        Navigate: Page Navigate;
}