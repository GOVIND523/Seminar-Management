codeunit 50107 Approvalmgt
{
    trigger OnRun()
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendSemListForApproval(var Seminar: Record SeminarRegistrationHeader)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelSemListForApproval(var Seminar: Record SeminarRegistrationHeader)
    begin
    end;

    procedure CheckSemListApprovalsWorkflowEnable(var SeminarList: Record SeminarRegistrationHeader): Boolean
    begin
        if not isSeminarListWorkflowEnabled(SeminarList) then Error(NoWorkflowEnabledError);
        exit(true);
    end;

    procedure isSeminarListWorkflowEnabled(var SeminarList: Record SeminarRegistrationHeader): Boolean
    begin
        if SeminarList."Seminar registartion Status" <> SeminarList."Approval Status"::Open then exit(false);

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', true, true)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef;
    var ApprovalEntryArgument: Record "Approval Entry";
    WorkflowStepInstance: Record "Workflow Step Instance")

    var
        SemList: Record SeminarRegistrationHeader;

    begin
        case RecRef.Number of
            Database::SeminarRegistrationHeader:
                begin
                    RecRef.SetTable(SemList);
                    ApprovalEntryArgument."Document No." := SemList."No.";
                end;

        end;
    end;

    var
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowEventHandlingCust: Codeunit WorkflowEventExt;
        NoWorkflowEnabledError: TextConst ENU = 'No Workflow for this record type is enabled';
}



