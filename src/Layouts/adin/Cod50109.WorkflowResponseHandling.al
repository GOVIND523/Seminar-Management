codeunit 50109 WorkflowResponseHandling
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', true, true)]

    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        CustomApproval: Codeunit "CApprovals";
    begin
        CustomApproval.ReOpen(RecRef, true);
        Handled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', true, true)]
    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        CustomApproval: Codeunit "CApprovals";
    begin
        CustomApproval.Release(RecRef, Handled);
        Handled := true;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', true, true)]
    local procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var iSHandled: Boolean)
    var
        CustomApproval: Codeunit "CApprovals";
    begin

        CustomApproval.SetStatusToPending(RecRef, Variant, true);
        iSHandled := true;
    end;
}














