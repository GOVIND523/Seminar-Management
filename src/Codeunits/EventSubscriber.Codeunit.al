// SME1.00 - 2024-04-24 - Govind
//   Chapter 5 - Lab 1
//     - Seminar EventSubscriber Codeunit created
//     - Added Eventsubscriber for events on navigate 

codeunit 50120 EventSubscriber
{
    [EventSubscriber(ObjectType::Page, Page::Navigate, 'OnAfterNavigateFindRecords', '', true, true)]
    local procedure OnAfterNavFindRecords(var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text)
    var
        navigate: Page Navigate;
    begin
        IF PostedSeminarRegHeader.READPERMISSION() THEN BEGIN
            PostedSeminarRegHeader.RESET();
            PostedSeminarRegHeader.SETFILTER("No.", DocNoFilter);
            PostedSeminarRegHeader.SETFILTER("Posting Date", PostingDateFilter);
            IF PostedSeminarRegHeader.IsEmpty() then
                Message('EMPTY')
            ELSE
                Message('NOT EMPTY');
            navigate.InsertIntoDocEntry(DocumentEntry, DATABASE::PostedSeminarRegHeader, CopyStr(PostedSeminarRegHeader.TABLECAPTION(), 1, 1024), PostedSeminarRegHeader.COUNT());
        END;
        IF SeminarLedgEntry.READPERMISSION() THEN BEGIN
            SeminarLedgEntry.RESET();
            SeminarLedgEntry.SETCURRENTKEY("Document No.", "Posting Date");
            SeminarLedgEntry.SETFILTER("Document No.", DocNoFilter);
            SeminarLedgEntry.SETFILTER("Posting Date", PostingDateFilter);
            IF SeminarLedgEntry.IsEmpty() then
                Message('EMPTY')
            ELSE
                Message('NOT EMPTY');
            navigate.InsertIntoDocEntry(DocumentEntry, DATABASE::SeminarLedgerEntry, CopyStr(SeminarLedgEntry.TABLECAPTION(), 1, 1024), SeminarLedgEntry.COUNT());
        END;
    end;

    [EventSubscriber(ObjectType::Page, Page::Navigate, 'OnAfterNavigateShowRecords', '', true, true)]
    local procedure OnAfterShowRecords(TableID: Integer)
    begin
        case TableID of
            DATABASE::PostedSeminarRegHeader:
                PAGE.RUN(0, PostedSeminarRegHeader);
            DATABASE::SeminarLedgerEntry:
                PAGE.RUN(0, SeminarLedgEntry);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::DimensionManagement, 'OnAfterSetSourceCodeWithVar', '', false, false)]
    local procedure AddSourceCode(TableID: Integer; RecordVar: Variant; var SourceCode: Code[10])
    var
        SourceCodeSetup: Record "Source Code Setup";
    begin
        if TableID = database::Seminar then begin
            SourceCode := SourceCodeSetup.Seminar;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 352, OnAfterUpdateGlobalDimCode, '', false, false)]
    local procedure UpdateSeminarGlobalDimCode(TableID: Integer)
    var
        GlobalDimCodeNo: Integer;
        SeminarNo: Code[20];
        NewDimValue: Code[20];
        Seminar: Record Seminar;
    begin
        if TableID = Database::Seminar then
            if seminar.get(SeminarNo) then begin
                case GlobalDimCodeNo of
                    1:
                        Seminar."Global Dimension Code 1" := NewDimValue;
                    2:
                        Seminar."Global Dimension Code 2" := NewDimValue;
                end;
            end;
    end;

    var
        PostedSeminarRegHeader: Record PostedSeminarRegHeader;
        SeminarLedgEntry: Record SeminarLedgerEntry;
}