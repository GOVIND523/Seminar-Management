// SME1.00 - 2024-04-16 - Govind
//   Chapter 3 - Lab 1
//     - Added SeminarRegistartionStatus Enum object created

enum 50103 SeminarRegistrationStatus
{
    Extensible = true;

    value(0; Planning)
    {
        Caption = 'Planning';
    }
    value(1; Registration)
    {
        Caption = 'Registration';
    }
    value(2; Closed)
    {
        Caption = 'Closed';
    }
    value(3; Cancelled)
    {
        Caption = 'Cancelled';
    }
}
