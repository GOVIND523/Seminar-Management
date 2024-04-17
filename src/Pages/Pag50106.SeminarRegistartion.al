// SME1.00 - 2024-04-17 - Govind
//   Chapter 3 - Lab 2
//     - Seminar Registartion document page created

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
                field("Document Status"; Rec.Status)
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
                        // Retrieve the selected room code
                        RoomCode := Rec."Room Resource No.";
                        // Retrieve the current seminar registration number
                        SeminarNo := Rec."No.";
                        // Check if the selected room is already chosen in another seminar registration
                        // IsRoomSelected := CheckRoomSelected(RoomCode, SeminarNo);
                        // Show error message if the room is already selected in another registration
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
                action(Approvalss)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;
                    // Promoted = true;
                    // PromotedCategory = Category17;

                    trigger OnAction()
                    var
                        ApprovalEntries: page "Approval Entries";
                        DocType: Enum "Approval Document Type";
                    begin
                        DocType := DocType::" ";
                        ApprovalEntries.SetRecordFilters(Database::SeminarRegistrationHeader, DocType, Rec."No.");
                        ApprovalEntries.Run();

                    end;
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
                    //RunObject = codeunit SeminarPostYesNo;
                    trigger OnAction()
                    var
                        SeminarPost: Codeunit SeminarPost;
                    begin
                        Rec.TestField("Approval Status", Rec."Approval Status"::Approved);
                        if Confirm('Are you sure you want to post') = true then begin

                            SeminarPost.postSeminar(Rec);
                        end;

                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = SendApprovalRequest;

                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    VAR
                        RecRef: RecordRef;
                        VarVariant: Variant;
                        CustomApprovals: Codeunit "CApprovals";
                    begin
                        if not Confirm('Are you sure you want to send Seminar List for approval?') then
                            exit;

                        VarVariant := Rec;
                        IF CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) THEN
                            CustomApprovals.OnSendDocForApproval(VarVariant);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        // RecRef: RecordRef;
                        // ApprovalEntry: Record "Approval Entry";
                        VarVariant: Variant;
                        CustomApprovals: Codeunit "CApprovals";
                    begin
                        Rec.TestField("Approval Status", Rec."Approval Status"::Pending);
                        if not Confirm('Are you sure you want to Cancel this Request for approval?') then
                            exit;
                        VarVariant := Rec;
                        CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                    end;
                }
            }
            group(Approvals)
            {
                Caption = 'Approvals';

                action(Approval)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction()
                    var
                        ApprovalEntries: page "Approval Entries";
                        DocType: Enum "Approval Document Type";
                    begin
                        DocType := DocType::" ";
                        ApprovalEntries.SetRecordFilters(Database::SeminarRegistrationHeader, DocType, Rec."No.");
                        ApprovalEntries.Run();

                    end;
                }
            }
        }
    }

    // local procedure CheckRoomSelected(RoomCode: Code[20]; SeminarNo: Code[20]): Boolean
    // var
    //     ExistingSeminarRegistration: Record PostedSeminarRegHeader;
    //     IsRoomSelected: Boolean;
    // begin
    //     // Query to check if the room is selected in another seminar registration
    //     IsRoomSelected := false;
    //     if ExistingSeminarRegistration.FINDSET then
    //         repeat
    //             // Check if the room is selected in another seminar registration and exclude the current seminar
    //             if (ExistingSeminarRegistration."No." <> SeminarNo) and (ExistingSeminarRegistration."Room Resource No." = RoomCode) then begin
    //                 IsRoomSelected := true;
    //                 break;
    //             end;
    //         until ExistingSeminarRegistration.NEXT = 0;

    //     exit(IsRoomSelected);
    // end;




}
