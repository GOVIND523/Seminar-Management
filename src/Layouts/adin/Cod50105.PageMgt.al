codeunit 50105 PageMgt
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", OnAfterGetPageID, '', true, true)]
    local procedure OnAfterGetPageID(RecordRef: RecordRef; var PageID: Integer)
    begin
        If PageID = 0 then
            PageID := GetconditionalCardPAgeId(RecordRef);

    end;

    local procedure GetconditionalCardPAgeId(RecordRef: RecordRef): Integer
    var
        myInt: Integer;
    begin
        case
            RecordRef.Number of
            Database::SeminarRegistrationHeader:
                exit(page::SeminarRegistration);
        end
    end;
}
