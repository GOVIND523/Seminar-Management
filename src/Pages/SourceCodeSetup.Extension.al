// SME1.00 - 2024-04-17 - Govind
//   Chapter 3 - Lab 2
//     - Source Code Setup page extended

pageextension 50117 SourceCodeSetupExt extends "Source Code Setup"
{
    layout
    {
        addlast(content)
        {
            group("Seminar Management")
            {
                Caption = 'Seminar Management';
                field(Seminar; Rec.Seminar)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}


