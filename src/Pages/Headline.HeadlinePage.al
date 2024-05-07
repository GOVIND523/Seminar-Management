page 50124 "Seminar Manager Healine"
{
    Caption = 'Headline';
    PageType = HeadlinePart;
    RefreshOnActivate = true;
    layout
    {
        area(content)
        {
            field(GreetingText; GreetingText)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Greeting headline';
                Editable = false;
            }
            field(SeminarCount; Text001)
            {
                ApplicationArea = all;
                Editable = false;
                DrillDown = true;
                trigger OnDrillDown()
                begin
                    page.Run(50102);
                end;
            }
            field(RegCount; Text002)
            {
                ApplicationArea = all;
                Editable = false;
                DrillDown = true;
                DrillDownPageId = SeminarRegistrationList;
                trigger OnDrillDown()
                begin
                    page.Run(50108);
                end;
            }
            field(Revenue; text003)
            {
                ApplicationArea = all;
                Editable = false;
                DrillDown = true;
                DrillDownPageId = SeminarLedgerEntries;
                trigger OnDrillDown()
                begin
                    page.Run(50114);
                end;
            }
        }
    }

    trigger OnInit()
    begin
        GreetingText := StrSubstNo(GreetingLabel, UserId);
        Text001 := StrSubstNo(Labe001, Seminar.Count);
        Text002 := StrSubstNo(Labe002, SeminarReg.Count);
        amount := TotalRevenue();
        Text003 := StrSubstNo(Labe003, amount);

    end;

    var
        GreetingLabel: Label '<qualifier>Seminar Management</qualifier><payload>Hello!! <emphasize>%1</emphasize></payload>';
        GreetingText: Text[100];
        Labe001: Label '<qualifier>Seminars</qualifier><payload>Total seminars were added  <emphasize>%1</emphasize></payload>';
        Labe002: Label '<qualifier>Seminar Registrations</qualifier><payload>Total seminar registartions created <emphasize>%1</emphasize></payload>';
        Labe003: Label '<qualifier>Seminar Earnings</qualifier><payload>Total Revenue from seminars <emphasize>%1</emphasize></payload>';

        Text001: Text[1001];
        Text002: Text[1001];
        Text003: Text[1001];
        amount: decimal;
        SeminarReg: Record SeminarRegistrationHeader;
        Seminar: Record Seminar;
        SeminarLed: Record SeminarLedgerEntry;

    local procedure totalrevenue(): Decimal
    begin
        amount := 0;
        if SeminarLed.FindFirst then
            repeat
                amount := amount + SeminarLed."Total Price";
            until SeminarLed.Next = 0;
        exit(amount);
    end;
}