// SME1.00 - 2024-04-24 - Govind
//   Chapter 6 - Lab 1
//     - Created seminar regsiatrtion printed codeunit 

codeunit 50121 "Seminar Registartion Printed"
{
    TableNo = SeminarRegistrationHeader;

    trigger OnRun()
    begin
        rec.find;
        rec.No_Printed := Rec.No_Printed + 1;
        rec.Modify();
        Commit();
    end;
}
 