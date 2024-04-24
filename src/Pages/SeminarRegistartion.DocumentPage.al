// SME1.00 - 2024-04-17 - Govind
//   Chapter 3 - Lab 2
//     - Seminar Registartion document page created

// SME1.00 - 2024-04-18 - Govind
//   Chapter 4 - Lab 5
//     - Added posting action

page 50105 SeminarRegistration
{
    Caption = 'Seminar Registration';
    PageType = Document;
    SourceTable = SeminarRegistrationHeader;
    SourceTableView = where(Posted = filter(false));
    RefreshOnActivate = true;
    PromotedActionCategories = 'New,Process,Report,Request Approval,Approvals,';

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Identifes a seminar registartion uniquely.';
                    ApplicationArea = All;
                    AssistEdit = true;

                    trigger OnAssistEdit()
                    begin
                        If Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ToolTip = 'Specifies the seminar starting date.';
                    ApplicationArea = All;

                }
                field("Seminar No."; Rec."Seminar No.")
                {
                    ToolTip = 'Specifies the number of the seminar unique for each seminar.';
                    ApplicationArea = All;
                }
                field("Seminar Name"; Rec."Seminar Name")
                {
                    ToolTip = 'Secifies the name of seminar.';
                    ApplicationArea = All;
                }
                field("Instructor Code"; Rec."Instructor Resource No.")
                {
                    ToolTip = 'Secifies the Instructor Code of seminar.';
                    ApplicationArea = All;
                }
                field("Instructor Name"; Rec."Instructor Name")
                {
                    ToolTip = 'Secifies the Instructor Name of seminar.';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Secifies the Posting Date of seminar.';
                    ApplicationArea = All;
                }

                //add tooltips from here 

                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Document Status"; Rec."Seminar registartion Status")
                {
                    ApplicationArea = All;
                }
                field(Approval_Status; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Duration; Rec.Duration)
                {
                    ApplicationArea = All;
                }
                field("Minimum Participants"; Rec."Minimum Participants")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Maximum Participants"; Rec."Maximum Participants")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("End Time"; Rec."End Time")
                {
                    ApplicationArea = All;
                }
            }
            part(SeminarRegistrationLines; SeminarRegistrationSubform)
            {
                SubPageLink = "Document No." = field("No.");
                ApplicationArea = All;
            }
            group("Seminar Room")
            {
                field("Room Code"; Rec."Room Resource No.")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        SeminarRegistrationHeader: Record "SeminarRegistrationHeader";
                        ExistingSeminarRegistration: Record PostedSeminarRegHeader;
                        RoomCode: Code[20];
                        SeminarNo: Code[20];
                        IsRoomSelected: Boolean;
                    begin
                        RoomCode := Rec."Room Resource No.";
                        SeminarNo := Rec."No.";
                        if IsRoomSelected then begin
                            Error('The selected room is already chosen in another seminar registration.');
                            Rec."Room Resource No." := '';
                        end;
                    end;

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
                field("Number of Lines"; Rec."Number of Lines")
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
            group(Posting)
            {
                Image = Post;
                Caption = 'Posting';

                action("Post")
                {
                    Caption = 'Post';
                    ApplicationArea = All;
                    Image = PostDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = codeunit SeminarPostYesNo;
                    trigger OnAction()
                    begin
                        CurrPage.Close();
                    end;
                }
            }
            action("Comments")
            {
                ApplicationArea = All;
                Caption = 'Co&mments';
                Image = Comment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page SeminarCommentSheet;
                RunPageLink = "No." = field("No.");
                RunPageView = where("Document Type" = const("Seminar Registration"));
            }
            action("&Charges")
            {
                ApplicationArea = All;
                Caption = '&Charges';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Cost;
                RunObject = page SeminarCharges;
                RunPageLink = "Document No." = field("No.");
            }


        }
    }
}
