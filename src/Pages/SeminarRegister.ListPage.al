// SME1.00 - 2024-04-17 - Govind
//   Chapter 4 - Lab 3
//     - SeminarRegister listpage created

page 50116 SeminarRegister
{
    Editable = false;
    ApplicationArea = All;
    Caption = 'Seminar Registers';
    PageType = List;
    SourceTable = SeminarRegister;
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = All;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ApplicationArea = All;
                }
                field("From Entry No."; Rec."From Entry No.")
                {
                    ApplicationArea = All;
                }
                field("To Entry No."; Rec."To Entry No.")
                {
                    ApplicationArea = All;
                }
            }
        }

        area(FactBoxes)
        {
            systempart(Links; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            group(Register)
            {
                Image = Register;
                action("Seminar Ledger")
                {
                    ApplicationArea = All;
                    Image = WarrantyLedger;
                    RunObject = codeunit SeminarRegShowLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                }
            }
        }
    }

}
