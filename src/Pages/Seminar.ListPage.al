// SME1.00 - 2024-04-16 - Govind
//   Chapter 2 - Lab 3
//     - Seminar List Page created
//     - Adding comments action

page 50102 "Seminar List"
{
    ApplicationArea = All;
    Caption = 'Seminar List';
    PageType = List;
    SourceTable = Seminar;
    UsageCategory = Lists;
    CardPageId = "Seminar card";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("Seminar registartion Status"; Rec."Seminar registartion Status")
                {
                    ApplicationArea = all;
                    ToolTip = 'Seminar registration status';
                }
                field("Seminar Price"; Rec."Seminar Price")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Seminar Price field.';
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Gen. Prod. Posting Group field.';
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the VAT Prod. Posting Group field.';
                }
            }
        }

        area(FactBoxes)
        {
            systempart(RecordLinks; Links)
            {
                ApplicationArea = all;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("&statistics")
            {
                ApplicationArea = all;
                Caption = 'Statistics';
                image = Statistics;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = page "SeminarStatictics";
                RunPageLink = "No." = field("No.");
            }
        }
        area(Navigation)
        {
            group(Related)
            {
                Image = Documents;
                action("Co&mments")
                {
                    ApplicationArea = All;
                    Caption = 'Comments', comment = 'NLB="Comments"';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Comment;
                    RunObject = page "Comment Sheet";
                    RunPageLink = "Table Name" = const(Seminar), "No." = field("No.");
                }
                action("&Registartions")
                {
                    Caption = '&Registrations';
                    Image = Timesheet;
                    RunObject = Page SeminarRegistrationList;
                    RunPageLink = "Seminar No." = field("No.");
                }
                action(LedgerEntries)
                {
                    Caption = 'Ledger Entries';
                    image = WarrantyLedger;
                    ShortcutKey = 'Ctrl + f7';
                    RunObject = page SeminarLedgerEntries;
                    RunPageLink = "Seminar No." = field("No.");
                }
            }

            group("Import/Export")
            {
                Image = ImportExport;
                action(Import)
                {
                    ApplicationArea = All;
                    Caption = 'Import';
                    Image = Import;
                    trigger OnAction()
                    begin
                        Xmlport.Run(50101, true, true);
                    end;
                }
                action(Export)
                {
                    ApplicationArea = All;
                    Caption = 'Export';
                    Image = Export;
                    trigger OnAction()
                    begin
                        Xmlport.Run(50101, true, false);
                    end;
                }
            }

            group(Dimensions)
            {
                Image = Dimensions;
                action("Dimensions-Single")
                {
                    ApplicationArea = All;
                    Caption = 'Dimensions-Single';
                    Image = Dimensions;
                    ShortcutKey = 'Shift+ctrl+d';
                    RunObject = page "Default Dimensions";
                    RunPageLink = "Table ID" = const(50102), "No." = field("No.");
                }
                action("Dimension-Multiple")
                {
                    ApplicationArea = all;
                    Caption = 'Dimension-Multiple';
                    Image = DimensionSets;
                    ShortcutKey = 'Shift+ctrl+d';
                    // RunObject = page "Default Dimensions-Multiple";
                    // RunPageLink = "Table ID" = const(50102), "No." = field("No.");


                    // trigger OnAction()
                    // begin
                    //     CurrPage.SetSelectionFilter(Seminar);
                    //     DefaulttDimMul.SetMultiSeminar(seminar);
                    //     DefaulttDimMul.RunModal();
                    // end;
                }
            }
        }
    }
}