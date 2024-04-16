report 50101 RegParticipants
{
    ApplicationArea = All;
    Caption = 'RegParticipants';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Participants.rdlc';
    dataset
    {
        dataitem(PostedSeminarRegHeader; SeminarRegistrationHeader)
        {
            RequestFilterFields = "No.", "Seminar No.";

            column(InstructorName; "Instructor Name")
            {
            }
            column(SeminarName; "Seminar Name")
            {
            }
            column(No_; "No.")
            {

            }
            column(Seminar_No_; "Seminar No.")
            {

            }
            column(Starting_Date; "Starting Date")
            {

            }
            column(Duration; Duration)
            {

            }
            column(RoomName; "Room Name")
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

            dataitem(PostedSeminarRegLine; SeminarRegistrationLine)
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.") order(ascending);

                column(Bill_to_Customer_No_; "Bill-to Customer No.")
                {

                }
                column(Participant_Contact_No_; "Participant Contact No.")
                {

                }
                column(Participant_Name; "Participant Name")
                {

                }

                trigger OnAfterGetRecord()
                begin
                    CompanyInfo.Get;
                    CompanyInfo.CalcFields(Picture);
                end;

                trigger OnPreDataItem()
                var
                    myInt: Integer;
                begin
                    If ("Participant Name" = '') then
                        exit;
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
        NoPrinted: Codeunit SeminarRegPrinted;


}
