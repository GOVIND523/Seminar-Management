report 50105 "Summary Report"
{
    ApplicationArea = All;
    Caption = 'Summary Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/SummaryReport.rdlc';
    dataset
    {
        dataitem(SeminarRegistrationHeader; SeminarRegistrationHeader)
        {
            column(ApprovalStatus; "Approval Status")
            {
            }
            column(Comment; Comment)
            {
            }
            column(DocumentDate; "Document Date")
            {
            }
            column(Duration; "Duration")
            {
            }
            column(EndTime; "End Time")
            {
            }
            column(GenProdPostingGroup; "Gen. Prod. Posting Group")
            {
            }
            column(InstructorName; "Instructor Name")
            {
            }
            column(InstructorResourceNo; "Instructor Resource No.")
            {
            }
            column(LineDiscount; "Line Discount")
            {
            }
            column(MaximumParticipants; "Maximum Participants")
            {
            }
            column(MinimumParticipants; "Minimum Participants")
            {
            }
            column(No; "No.")
            {
            }
            column(NoSeries; "No. Series")
            {
            }
            column(No_Printed; No_Printed)
            {
            }
            column(NumberofLines; "Number of Lines")
            {
            }
            column(Posted; Posted)
            {
            }
            column(PostingDate; "Posting Date")
            {
            }
            column(PostingNo; "Posting No.")
            {
            }
            column(PostingNoSeries; "Posting No. Series")
            {
            }
            column(ReasonCode; "Reason Code")
            {
            }
            column(RoomAddress; "Room Address")
            {
            }
            column(RoomAddress2; "Room Address 2")
            {
            }
            column(RoomCity; "Room City")
            {
            }
            column(RoomCountryRegCode; "Room Country/Reg. Code")
            {
            }
            column(RoomCounty; "Room County")
            {
            }
            column(RoomName; "Room Name")
            {
            }
            column(RoomPostCode; "Room Post Code")
            {
            }
            column(RoomResourceNo; "Room Resource No.")
            {
            }
            column(SeminarName; "Seminar Name")
            {
            }
            column(SeminarNo; "Seminar No.")
            {
            }
            column(SeminarPrice; "Seminar Price")
            {
            }
            column(StartingDate; "Starting Date")
            {
            }
            column(Status; "Seminar registartion Status")
            {
            }
            column(SystemCreatedAt; SystemCreatedAt)
            {
            }
            column(SystemCreatedBy; SystemCreatedBy)
            {
            }
            column(SystemId; SystemId)
            {
            }
            column(SystemModifiedAt; SystemModifiedAt)
            {
            }
            column(SystemModifiedBy; SystemModifiedBy)
            {
            }
            column(TotalAmount; "Total Amount")
            {
            }
            column(VATProdPostingGroup; "VAT Prod. Posting Group")
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(Address_1; CompanyInfo.Address)
            {
            }
            column(Address_2; CompanyInfo."Address 2")
            {
            }
            column(City; CompanyInfo.City)
            {
            }
            column(Phone_No; CompanyInfo."Phone No.")
            {
            }
            column(Phone_No2; CompanyInfo."Phone No. 2")
            {
            }
            // column(Homepage; CompanyInfo."Home Page")
            // {

            // }
            column(Post_Code; CompanyInfo."Post Code")
            {

            }
            column(Name; CompanyInfo.Name)
            {

            }
            trigger OnAfterGetRecord()
            begin
                CompanyInfo.Get;
                CompanyInfo.CalcFields(Picture);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    var
        CompanyInfo: Record "Company Information";
}
