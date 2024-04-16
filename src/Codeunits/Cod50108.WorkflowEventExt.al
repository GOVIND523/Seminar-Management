codeunit 50108 WorkflowEventExt
{
    trigger OnRun()
    begin
    end;

    procedure RunWorkflowOnSendSeminarListForApprovalCode(): code[128]
    var
    begin
        exit(UpperCase('RunWorkflowOnSeminarListForApproval'));
    end;

    procedure RunWorkflowOnCancelSeminarListApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelSeminarListForApproval'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', true, true)]
    local procedure OnAddWorkflowEventPredecessorsToLibrary(EventFunctionName: Code[128])
    begin
        case EventFunctionName of
            RunWorkflowOnCancelSeminarListApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelSeminarListApprovalCode, RunWorkflowOnSendSeminarListForApprovalCode);

            WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode():
                begin

                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendSeminarListForApprovalCode);

                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', true, true)]
    local procedure OnAddWorkflowEventsToLibrary()
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendSeminarListForApprovalCode, Database::SeminarRegistrationHeader, SendSeminarApprovalTxt, 0, false);

    end;

    var
        WorkFlowManagement: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        SendSeminarApprovalTxt: TextConst ENU = 'Approval for Seminar Request is Sent';
        CancelSeminarApprovalTxt: TextConst ENU = 'Approval for Seminar Request is Cancelled';

}

