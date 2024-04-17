report 50104 Revenues
{
    ApplicationArea = All;
    Caption = 'Revenues';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/TotalRevenue.rdlc';
    dataset
    {
        dataitem(SeminarRegistrationHeader; SeminarRegistrationHeader)
        {
            //DataItemTableView = where(Posted = filter(true));
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

            column(Posted; Posted)
            {
            }
            column(PostingDate; "Posting Date")
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
            column(Status; Status)
            {
            }
            column(Total_Amount; "Total Amount")
            {

            }
            column(Number_of_Lines; "Number of Lines")
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
