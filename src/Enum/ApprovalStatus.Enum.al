// SME1.00 - 2024-04-16 - Govind
//   Chapter 3 - Lab 1
//     - Added ApprovalStatus Enum object for aprroval options

enum 50102 ApprovalStatus
{
    Extensible = true;

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; Pending)
    {
        Caption = 'Pending';
    }
    value(2; Approved)
    {
        Caption = 'Approved';
    }
    value(3; Rejected)
    {
        Caption = 'Rejected';
    }
}
