report 50106 "Instructor Seminars"
{
    ApplicationArea = All;
    Caption = 'Instructor Seminars';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/instructorseminars.rdlc';
    dataset
    {
        dataitem(SeminarRegistrationHeader; SeminarRegistrationHeader)
        {
            RequestFilterFields = "Instructor Resource No.";
            column(InstructorResourceNo; "Instructor Resource No.")
            {
            }
            column(InstructorName; "Instructor Name")
            {
            }
            column(RoomResourceNo; "Room Resource No.")
            {
            }
            column(RoomName; "Room Name")
            {
            }
            column(SeminarName; "Seminar Name")
            {
            }
            column(SeminarNo; "Seminar No.")
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
            dataitem(Resource; Resource)
            {
                DataItemLink = "No." = field("Instructor Resource No.");
                DataItemTableView = sorting("No.") order(ascending);
                // RequestFilterHeading = "No.";
                column(No_; "No.")
                {

                }
                column(Job_Title; "Job Title")
                {

                }

                trigger OnAfterGetRecord()
                begin
                    CompanyInfo.Get;
                    CompanyInfo.CalcFields(Picture);
                end;
            }
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
