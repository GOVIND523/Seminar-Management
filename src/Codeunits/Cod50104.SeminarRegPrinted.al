codeunit 50104 SeminarRegPrinted
{
    TableNo = SeminarRegistrationHeader;
    Permissions = TableData SeminarRegistrationHeader = rm;

    trigger OnRun()
    begin
        OnBeforeOnRun(Rec, SuppressCommit);
        Rec.Find();
        Rec.No_Printed := Rec.No_Printed + 1;
        OnBeforeModify(Rec);
        Rec.Modify();
        if not SuppressCommit then
            Commit();
        OnAfterOnRun(Rec);
    end;

    var
        SuppressCommit: Boolean;

    procedure SetSuppressCommit(NewSuppressCommit: Boolean)
    begin
        SuppressCommit := NewSuppressCommit;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnRun(var SeminarRegHeader: Record "SeminarRegistrationHeader")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeModify(var SeminarRegHeader: Record "SeminarRegistrationHeader")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnRun(var SeminarRegHeader: Record "SeminarRegistrationHeader"; var SuppressCommit: Boolean)
    begin
    end;




}
