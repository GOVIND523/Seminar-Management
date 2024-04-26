// SME1.00 - 2024-04-24 - Govind
//   Chapter 6 - Lab 1
//     - Created registered participants report

report 50101 RegParticipants
{
    ApplicationArea = All;
    Caption = 'Registered Participants';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Participants.rdl';
    dataset
    {
        dataitem(PostedSeminarRegHeader; PostedSeminarRegHeader)
        {
            RequestFilterFields = "No.", "Seminar No.";

            column(InstructorName; "Instructor Name")
            {
                IncludeCaption = true;
            }
            column(SeminarName; "Seminar Name")
            {
                IncludeCaption = true;
            }
            column(Seminar_No_; "Seminar No.")
            {
                IncludeCaption = true;
            }
            column(Starting_Date; "Starting Date")
            {
                IncludeCaption = true;
            }
            column(Duration; Duration)
            {
                IncludeCaption = true;
            }
            column(RoomName; "Room Name")
            {
                IncludeCaption = true;
            }
            column(CompanyName; CompanyInfo.Name)
            { }
            column(CompanyImage; CompanyInfo.Picture)
            { }
            column(Address_1; CompanyInfo.Address)
            {
                IncludeCaption = true;
            }
            column(Address_2; CompanyInfo."Address 2")
            {
                IncludeCaption = true;
            }
            column(City; CompanyInfo.City)
            {
                IncludeCaption = true;
            }
            column(Phone_No; CompanyInfo."Phone No.")
            {
                IncludeCaption = true;
            }
            column(Phone_No2; CompanyInfo."Phone No. 2")
            {
                IncludeCaption = true;
            }
            column(Post_Code; CompanyInfo."Post Code")
            {
                IncludeCaption = true;
            }

            dataitem(Seminar; Seminar)
            {

                DataItemLink = "No." = field("Seminar No.");
                column(Total_Booking; "Total Booking")
                {
                    IncludeCaption = true;
                }
            }
            dataitem(PostedSeminarRegLine; PostedSeminarRegLine)
            {

                DataItemLink = "Document No." = field("No.");
                column(Document_No_; "Document No.")
                {
                    IncludeCaption = true;
                }
                column(Bill_to_Customer_No_; "Bill-to Customer No.")
                {
                    IncludeCaption = true;
                }
                column(Participant_Contact_No_; "Participant Contact No.")
                {
                    IncludeCaption = true;
                }
                column(Participant_Name; "Participant Name")
                {
                    IncludeCaption = true;
                }
            }
            trigger OnAfterGetRecord()
            begin
                CompanyInfo.get();
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
        NoPrinted: Codeunit SeminarRegPrinted;
}
