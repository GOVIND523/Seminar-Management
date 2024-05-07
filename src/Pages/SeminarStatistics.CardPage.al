page 50122 SeminarStatictics
{
    SourceTable = Seminar;
    PageType = Card;
    LinksAllowed = false;
    Editable = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                fixed(Control1000000002)
                {
                    ShowCaption = false;
                    group("This Period")
                    {
                        Caption = 'This Period';
                        field("SeminarDateName[1]"; SeminarDateName[1])
                        {
                            ApplicationArea = all;
                            Caption = 'Seminar Date Name';
                        }
                        field("TotalPrice[1]"; TotalPrice[1])
                        {
                            ApplicationArea = all;

                            Caption = 'Total Price';
                        }
                        field("TotalPriceNotChargeable[1]"; TotalPriceNotChargeable[1])
                        {
                            ApplicationArea = all;
                            Caption = 'Total Price Not Chargeable';
                        }
                        field("TotalPriceChargeable[1]"; TotalPriceChargeable[1])
                        {
                            ApplicationArea = all;
                            Caption = 'Total Price Chargeable';
                        }
                    }
                    group("This Year")
                    {
                        Caption = 'This Year';
                        field("SeminarDateName[2]"; SeminarDateName[2])
                        {
                            ApplicationArea = all;
                            Caption = 'Semianr Date Name';
                        }
                        field("TotalPrice[2]"; TotalPrice[2])
                        {
                            ApplicationArea = all;
                            Caption = 'Total Price';
                        }
                        field("TotalPriceNotChargeable[2]"; TotalPriceNotChargeable[2])
                        {
                            ApplicationArea = all;
                            Caption = 'Total Price Not Chargeable';
                        }
                        field("TotalPriceChargeable[2]"; TotalPriceChargeable[2])
                        {
                            ApplicationArea = all;
                            Caption = 'Total Price Chargeable';
                        }
                    }
                    group("Last Year")
                    {
                        Caption = 'Last Year';
                        field("SeminarDateName[3]"; SeminarDateName[3])
                        {
                            ApplicationArea = all;
                            Caption = 'Seminar Date Name';
                        }
                        field("TotalPrice[3]"; TotalPrice[3])
                        {
                            ApplicationArea = all;
                            Caption = 'Total Price';
                        }
                        field("TotalPriceNotChargeable[3]"; TotalPriceNotChargeable[3])
                        {
                            ApplicationArea = all;
                            Caption = 'Total Price Not Chargeable';
                        }
                        field("TotalPriceChargeable[3]"; TotalPriceChargeable[3])
                        {
                            ApplicationArea = all;
                            Caption = 'Total Price Chargeable';
                        }
                    }
                    group("To Date")
                    {
                        Caption = 'To Date';
                        field("SeminarDateName[4]"; SeminarDateName[4])
                        {
                            ApplicationArea = all;
                            Caption = 'Seminar Date Name';
                        }
                        field("TotalPrice[4]"; TotalPrice[4])
                        {
                            ApplicationArea = all;
                            Caption = 'Total Price';
                        }
                        field("TotalPriceNotChargeable[4]"; TotalPriceNotChargeable[4])
                        {
                            ApplicationArea = all;
                            Caption = 'Total Price Not Chargeable';
                        }
                        field("TotalPriceChargeable[4]"; TotalPriceChargeable[4])
                        {
                            ApplicationArea = all;
                            Caption = 'Total Price Chargeable';
                        }
                    }
                }
            }
        }
    }



    trigger OnAfterGetRecord()
    begin
        Rec.SetRange("No.");

        IF CurrentDate <> WORKDATE THEN BEGIN
            CurrentDate := WORKDATE;
            DateFilterCalc.CreateAccountingPeriodFilter(SeminarDateFilter[1], SeminarDateName[1], CurrentDate, 0);
            DateFilterCalc.CreateFiscalYearFilter(SeminarDateFilter[2], SeminarDateName[2], CurrentDate, 0);
            DateFilterCalc.CreateFiscalYearFilter(SeminarDateFilter[3], SeminarDateName[3], CurrentDate, -1);
        END;

        FOR count := 1 TO 4 DO BEGIN
            Rec.SETFILTER("Date Filter", SeminarDateFilter[count]);
            Rec.CALCFIELDS("Total Price", "Total Price(Not Chargable)", "Total Price(Chargable)");
            TotalPrice[count] := Rec."Total Price";
            TotalPriceNotChargeable[Count] := Rec."Total Price(Not Chargable)";
            TotalPriceChargeable[Count] := Rec."Total Price(Chargable)";
        END;

        Rec.SETRANGE("Date Filter", 0D, CurrentDate)
    end;

    var
        DateFilterCalc: Codeunit "DateFilter-Calc";
        SeminarDateFilter: array[4] of Text[30];
        SeminarDateName: array[4] of Text[30];
        CurrentDate: Date;
        TotalPrice: array[4] of Decimal;
        TotalPriceNotChargeable: array[4] of Decimal;
        TotalPriceChargeable: array[4] of Decimal;
        count: integer;
}