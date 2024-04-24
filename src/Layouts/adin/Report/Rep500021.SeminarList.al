report 50107 SeminarList
{
    ApplicationArea = All;
    Caption = 'SeminarList';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/SeminarList.rdlc';

    dataset
    {
        dataitem(seminar; seminar)
        {
            RequestFilterFields = "No.";
            column(No; "No.")
            {
            }
            column(SeminarPrice; "Seminar Price")
            {
            }
            column(MinimumParticipants; "Minimum Participants")
            {
            }
            column(MaximumParticipants; "Maximum Participants")
            {
            }
            column(Seminar_Duration; "Seminar Duration")
            {

            }
            column(Name; Name)
            {
            }
            column(CompanyName; CompanyName)
            {

            }
            column(Picture; CompanyInfo.Picture)
            {

            }
            column(Email; CompanyInfo."E-Mail")
            {

            }
            column(Address; CompanyInfo.Address)
            {

            }
            column(Address2; CompanyInfo."Address 2")
            {

            }
            trigger OnPreDataItem()
            var
                myInt: Integer;
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
