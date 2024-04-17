// SME1.00 - 2024-04-17 - Govind
//   Chapter 4 - Lab 2
//     - SeminarJournalChargeType enum created

enum 50106 SeminarJournalChargeType
{
    Extensible = true;

    value(0; Instructor)
    {
        Caption = 'Instructor';
    }
    value(1; Room)
    {
        Caption = 'Room';
    }
    value(2; Participant)
    {
        Caption = 'Participant';
    }
    value(3; Charge)
    {
        Caption = 'Charge';
    }

}
