codeunit 50106 CApprovals
{
    trigger OnRun()
    begin
    end;

    var
        WorkflowManagement: Codeunit "Workflow Management";
        UnsupportedRecordTypeErr: label 'Record type %1 is not supported by this workflow response.', Comment = 'Record type Customer is not supported by this workflow response.';
        NoWorkflowEnabledErr: label 'This record is not supported by related approval workflow.';
        //Seminar Registration
        OnSendSeminarApprovalRequestTxt: label 'Approval of a Seminar is requested';
        RunWorkflowOnSendSeminarListForApprovalCode: label 'RUNWORKFLOWONSENDSEMINARLISTFORAPPROVAL';
        OnCancelSeminarApprovalRequestTxt: label 'An Approval of a Seminar is canceled';
        RunWorkflowOnCancelSemForApprovalCode: label 'RUNWORKFLOWONCANCELSEMINARFORAPPROVAL';


    procedure CheckApprovalsWorkflowEnabled(var Variant: Variant): Boolean
    var
        RecRef: RecordRef;
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            Database::SeminarRegistrationHeader:
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendSeminarListForApprovalCode));
            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end;
    end;

    procedure CheckApprovalsWorkflowEnabledCode(var Variant: Variant; CheckApprovalsWorkflowTxt: Text): Boolean
    var
        RecRef: RecordRef;
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        if not WorkflowManagement.CanExecuteWorkflow(Variant, CheckApprovalsWorkflowTxt) then
            Error(NoWorkflowEnabledErr);
        exit(true);
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelDocApprovalRequest(var Variant: Variant)
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure AddWorkflowEventsToLibrary()
    var
        WorkFlowEventHandling: Codeunit "Workflow Event Handling";
    begin

        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendSeminarListForApprovalCode, Database::SeminarRegistrationHeader, OnSendSeminarApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelSemForApprovalCode, Database::SeminarRegistrationHeader, OnCancelSeminarApprovalRequestTxt, 0, false);

    end;

    local procedure RunWorkflowOnSendApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CApprovals", 'OnSendDocForApproval', '', false, false)]
    procedure RunWorkflowOnSendApprovalRequest(var Variant: Variant)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            Database::SeminarRegistrationHeader:
                WorkflowManagement.HandleEvent(RunWorkflowOnSendSeminarListForApprovalCode, Variant);

            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CApprovals", 'OnCancelDocApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelApprovalRequest(var Variant: Variant)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            Database::SeminarRegistrationHeader:
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelSemForApprovalCode, Variant);
            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end;

    end;

    procedure ReOpen(var RecRef: RecordRef; Handled: Boolean)
    var
        Variant: Variant;
        SemReg: Record SeminarRegistrationHeader;
    begin
        case RecRef.Number of
            Database::SeminarRegistrationHeader:
                begin
                    RecRef.SetTable(SemReg);
                    SemReg.Validate(Status, SemReg.Status::Open);
                    SemReg.Modify;
                    Variant := SemReg;
                    Handled := true;
                end;
            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end

    end;

    procedure Release(RecRef: RecordRef; var Handled: Boolean)
    var
        Variant: Variant;
        SemReg: Record SeminarRegistrationHeader;
    begin
        case RecRef.Number of
            Database::SeminarRegistrationHeader:
                begin
                    RecRef.SetTable(SemReg);
                    SemReg.Validate(Status, SemReg.Status::Approved);
                    SemReg.Modify;
                    Variant := SemReg;
                end;
            else
                Handled := false;
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end

    end;

    procedure SetStatusToPending(RecRef: RecordRef; var Variant: Variant; IsHandled: Boolean)
    var
        SemReg: Record "SeminarRegistrationHeader";
    begin
        RecRef.GetTable(Variant);

        case RecRef.Number of
            Database::"SeminarRegistrationHeader":
                begin
                    RecRef.SetTable(SemReg);
                    SemReg.Validate(Status, SemReg.Status::"Pending");
                    SemReg.Modify;
                    Variant := SemReg;
                    IsHandled := true;
                end;

            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);

        end;

    end;

    [IntegrationEvent(false, false)]
    procedure OnSendDocForApproval(var Variant: Variant)
    begin
    end;


    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', false, false)]
    local procedure OnBeforeDrillDown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        SemReg: record "SeminarRegistrationHeader";

    begin
        case DocumentAttachment."Table ID" of

            DATABASE::"SeminarRegistrationHeader":
                begin
                    RecRef.Open(DATABASE::"SeminarRegistrationHeader");
                    if SemReg.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(SemReg);
                end;
        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Approval Entry", 'OnBeforeMarkAllWhereUserisApproverOrSender', '', false, false)]
    local procedure MarkAllWhereUserIsApproverorSender(var ApprovalEntry: Record "Approval Entry"; var IsHandled: Boolean)

    begin
        IsHandled := true;
    end;
}






