report 50103 "Create Invoice"
{
    ApplicationArea = All;
    Caption = 'Invoice a Seminar Ledger Record';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem(SeminarLedgerEntry; SeminarLedgerEntry)
        {
            RequestFilterFields = "Bill-to Customer No.", "Posting Date", "Seminar No.";

            column(BilltoCustomerNo; "Bill-to Customer No.")
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(ChargeType; "Charge Type")
            {
            }
            column(ParticipantContactNo; "Participant Contact No.")
            {
            }

            trigger OnAfterGetRecord()
            var
                Customer: Record Customer;

            begin
                if ("Bill-to Customer No.") <> Customer."No." then begin
                    Customer.Get("Bill-to Customer No.");
                    if Customer.Blocked in [Customer.Blocked::All, Customer.Blocked::Invoice] then begin
                        NoOfSalesInvErr += 1;
                    end
                    else begin
                        if SeminarLedgerEntry."Bill-to Customer No." <> SaleHeader."Bill-to Customer No." then begin
                            Window.Update(1, "Bill-to Customer No.");
                            if SaleHeader."No." <> '' then
                                FinalizeSalesInvHeader();
                            InsertSalesInvHeader();
                        end;
                        Window.Update(2, "Seminar Registration No.");
                        case Type of
                            Type::Resource:
                                begin
                                    SalesLine.Type := SalesLine.Type::Resource;
                                    case SeminarJnlLine."Charge Type" of
                                        SeminarJournalChargeType::Instructor:
                                            SalesLine."No." := "Instructor Code";
                                        SeminarJournalChargeType::Participant:
                                            SalesLine."No." := "Instructor Code";
                                        SeminarJournalChargeType::Room:
                                            SalesLine."No." := "Room Code.";
                                    end;
                                end;
                        end;
                    end;
                end;
                SalesLine."Document Type" := SaleHeader."Document Type";
                SalesLine."Document No." := SaleHeader."No.";
                SalesLine."Line No." := NextLineNo;
                SalesLine.Validate("No.");
                Seminar.Get("Seminar No.");
                if (SeminarLedgerEntry.Description <> '') then begin
                    SalesLine.Description := SeminarLedgerEntry.Description;
                end
                else
                    SalesLine.Description := Seminar.Name;
                SalesLine."Unit Price" := "Unit Price";

                if (SaleHeader."Currency Code" <> '') then begin
                    SaleHeader.TESTFIELD("Currency Factor");
                    SalesLine."Unit Price" := ROUND(CurrencyExch.ExchangeAmtLCYToFCY(WORKDATE, SaleHeader."Currency Code", SalesLine."Unit Price", SaleHeader."Currency Factor"));
                end;

                SalesLine.VALIDATE(Quantity, Quantity);
                SalesLine.INSERT;
                NextLineNo := NextLineNo + 10000;
            end;




            trigger OnPostDataItem()
            var
                myInt: Integer;
            begin
                Window.Close();
                if SaleHeader."No." = '' then begin
                    Message(Text007);
                end
                else begin
                    FinalizeSalesInvHeader();
                end;

                if NoOfSalesInvErr = 0 then
                    Message(Text005, NoOfSalesInv)
                else
                    Message(Text006, NoOfSalesInvErr);
            end;


            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                if PostingDateReq = 0D then
                    Error(Text000);
                if DocDateReq = 0D then
                    Error(Text001);
                Window.Open(Text002 + Text003 + Text004);
            end;
        }
    }



    requestpage
    {

        SaveValues = true;
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PostingDateReq; PostingDateReq)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posting Date';
                    }
                    field(DocDateReq; DocDateReq)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Document Date';
                    }
                    field(CalcInvoiceDis; CalcInvoiceDis)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Calc. Inv. Discount';
                        ToolTip = 'Specifies if you want the invoice discount amount to be automatically calculated on the invoices before posting.';

                        trigger OnValidate()
                        var
                            SalesReceivablesSetup: Record "Sales & Receivables Setup";
                        begin
                            SalesReceivablesSetup.Get();
                            SalesReceivablesSetup.TestField("Calc. Inv. Discount", false);
                        end;
                    }
                    field(PostInvoices; PostInvoices)
                    {
                        ToolTip = 'PostInvoice';
                    }
                }

            }

        }
        actions
        {
            area(processing)
            {
            }
        }

        trigger OnOpenPage()
        var
            myInt: Integer;
        begin
            if PostingDateReq = 0D then
                PostingDateReq := WorkDate();
            if DocDateReq = 0D then
                DocDateReq := WorkDate();
            SalesSetup.Get;
            CalcInvoiceDis := SalesSetup."Calc. Inv. Discount";
        end;
    }



    var
        SaleHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesSetup: Record "Sales & Receivables Setup";
        GLSetup: Record "General Ledger Setup";
        Customer: Record Seminar;
        CurrencyExch: Record "Currency Exchange Rate";
        SalesDis: Codeunit "Sales - Calc Discount By Type";
        SalePost: Codeunit "Sales-Post";
        Window: Dialog;
        PostingDateReq: Date;
        DocDateReq: Date;
        CalcInvoiceDis: Boolean;
        PostInvoices: Boolean;
        NextLineNo: Integer;
        NoOfSalesInvErr: Integer;
        NoOfSalesInv: Integer;
        SeminarJnlLine: Record SeminarJournalLine;
        Seminar: Record Seminar;

        Text000: Label 'Please enter the posting Date';
        Text001: Label 'Please enter the document date';
        Text002: Label 'Creating Seminar Invoices...\\ The combination of dimensions used in %1 is blocked. %2';
        Text003: Label 'Customer No. #1##########\';
        Text004: Label 'Registration No. #2##########\';
        Text005: Label 'The number of invoice(s) created is %1';
        Text006: Label 'Not all the invoices are posted. A total of %1 invoices are not posted.';
        Text007: Label 'There is nothing to post';


    local procedure InsertSalesInvHeader()
    var
        myInt: Integer;
    begin
        SaleHeader.init;
        SaleHeader."Document Type" := "Sales Document Type"::Invoice;
        SaleHeader."No." := '';
        SaleHeader.Insert(true);

        SaleHeader.Validate("Sell-to Customer No.", SeminarLedgerEntry."Bill-to Customer No.");
        if (SaleHeader."Bill-to Customer No.") <> (SaleHeader."Sell-to Customer No.") then
            SaleHeader.Validate("Bill-to Customer No.", SeminarLedgerEntry."Bill-to Customer No.");
        SaleHeader.Validate("Posting Date", PostingDateReq);
        SaleHeader.Validate("Document Date", DocDateReq);
        SaleHeader.Validate("Currency Code");
        SaleHeader.modify;
        commit;
        NextLineNo := 10000;
    end;

    local procedure FinalizeSalesInvHeader()
    var
        myInt: Integer;
        SalesHeader: record "Sales Header";
    begin
        if SaleHeader.Find then begin
            if CalcInvoiceDis then
                SalesDis.Run(SalesLine);
            SalesHeader.Get(SaleHeader."Document Type", SaleHeader."No.");
            Commit();
            Clear(SalesDis);
            Clear(SalePost);
            NoOfSalesInv := NoOfSalesInv + 1;
            if PostInvoices then
                Clear(SalePost);
            if not SalePost.Run(SalesHeader) then
                NoOfSalesInvErr := NoOfSalesInvErr + 1;
        end;

    end;
}
