page 50126 MySeminars
{
    Caption = 'My Seminars';
    SourceTable = MySeminar;
    PageType = ListPart;

    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("Seminar No."; Rec."Seminar No.")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        GetSeminar();
                    end;
                }
                field("Seminar Name"; seminar."Name")
                {
                    StyleExpr = StyExp;
                    ApplicationArea = all;
                }
                field("Seminar Stage"; seminar."Seminar registartion Status")
                {
                    ApplicationArea = all;
                }
                field("Total Bookings"; seminar."Total Booking")
                {
                    ApplicationArea = all;
                }
                field("Seminar Price"; seminar."Seminar Price")
                {
                    ApplicationArea = all;
                }

            }

        }
    }
    actions
    {
        area(Processing)
        {
            action(Open)
            {
                ApplicationArea = All;
                Caption = 'Open', comment = 'NLB=""';
                image = Edit;
                ShortcutKey = 'return';
                trigger OnAction()
                begin
                    openSeminarCard();
                end;
            }
        }
    }

    var
        seminar: record Seminar;

    trigger OnOpenPage()
    begin
        rec.SetRange("User ID", UserId);
    end;

    trigger OnAfterGetRecord()
    begin
        GetSeminar();
        case seminar."Seminar registartion Status" of
            SeminarRegStatus::Planning:
                StyExp := 'Standard';
            SeminarRegStatus::Closed:
                StyExp := 'Ambiguous';
            SeminarRegStatus::Cancelled:
                StyExp := 'Unfavorable';
            SeminarRegStatus::Registration:
                StyExp := 'Favorable';
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(seminar);
    end;

    local procedure GetSeminar()
    begin
        Clear(seminar);
        seminar.Get(rec."Seminar No.");
    end;

    local procedure openSeminarCard()
    begin
        if seminar.get(rec."Seminar No.") then
            page.Run(Page::"Seminar card", seminar);
    end;

    var
        StyExp: Text[20];
        SeminarRegStatus: Enum SeminarRegistrationStatus;
}