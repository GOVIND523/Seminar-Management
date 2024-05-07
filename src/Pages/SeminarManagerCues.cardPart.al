// SME1.00 - 2024-04-16 - Govind
//   Chapter 4 - Lab 1
//     - Added seminar cue table 

page 50119 "Seminar Manager Activities"
{
    ApplicationArea = All;
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Seminar Cue";

    layout
    {
        area(content)
        {
            cuegroup("Seminars ")
            {
                field("Seminars"; Rec."Total Seminars")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the Seminars';
                    DrillDownPageId = "Seminar List";
                }
                field("Cancelled Seminars"; Rec."Cancelled Seminars")
                {
                    Style = Unfavorable;
                    StyleExpr = true;
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Cancelled Seminars.';
                    DrillDownPageId = "Seminar List";
                }
            }
            cuegroup("Seminar Registrations")
            {
                field("Total Registrations"; Rec."Total Registrations")
                {
                    ApplicationArea = Basic, Suite;
                    Style = Favorable;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Total Registrations.';
                    DrillDownPageId = SeminarRegistrationList;
                }
                field("Open Seminars Registrations"; Rec."Open Seminars Registrations")
                {
                    ToolTip = 'Specifies the value of the Open Seminars Registrations';
                    DrillDownPageId = SeminarRegistrationList;
                }
                field("Planned Seminars"; Rec."Planned Seminars")
                {
                    Style = Ambiguous;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Planned Seminars.';
                    DrillDownPageId = SeminarRegistrationList;
                }

            }
            cuegroup(Posting)
            {
                field("Closed Seminar Registartions"; Rec."Closed Seminar Registartions")
                {
                    Style = Subordinate;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Closed Seminar Registartions.';
                    DrillDownPageId = PostedSeminarRegList;
                }

                actions
                {
                    action("Add New Seminar")
                    {
                        ApplicationArea = all;
                        RunObject = page "Seminar card";
                        RunPageMode = Create;
                        Image = TileNew;
                    }
                    action("Seminar Registartion")
                    {
                        ApplicationArea = all;
                        Visible = true;
                        RunObject = page SeminarRegistration;
                        RunPageMode = Create;
                        Image = TileNew;
                    }

                }
            }
        }

    }
    var
        CancelledStyleExpr: Boolean;

    trigger OnOpenPage();
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert(true);
        end;
    end;



}
