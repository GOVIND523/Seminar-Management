page 50118 "Seminar Manager Role Center"
{
    Caption = 'Seminar Manager';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part(Control18; "Headline RC Serv. Dispatcher")
            {
                ApplicationArea = Basic, Suite;
            }
            part(Control1904652008; "Service Dispatcher Activities")
            {
                ApplicationArea = Service;
            }
            part(Name; "Seminar Details")
            {
                ApplicationArea = Suite;
            }
            part("User Tasks Activities"; "User Tasks Activities")
            {
                ApplicationArea = Suite;
            }
            part("Emails"; "Email Activities")
            {
                ApplicationArea = Basic, Suite;
            }
            part(ApprovalsActivities; "Approvals Activities")
            {
                ApplicationArea = Suite;
            }
            part(PowerBIEmbeddedReportPart; "Power BI Embedded Report Part")
            {
                AccessByPermission = TableData "Power BI Context Settings" = I;
                ApplicationArea = Basic, Suite;
            }
            part(Control1907692008; "My Customers")
            {
                ApplicationArea = Basic, Suite;
            }
            part(Control1905989608; "My Time Sheets")
            {
                ApplicationArea = Basic, Suite;
            }
            part(Control31; "Report Inbox Part")
            {
                ApplicationArea = Service;
                Visible = false;
            }

            systempart(Control1901377608; MyNotes)
            {
                ApplicationArea = Service;
            }
        }
    }

    actions
    {
        area(reporting)
        {
            group(Seminar)
            {
                Caption = 'Seminar';
                action("Seminar Ta&sks")
                {
                    ApplicationArea = All;
                    Caption = 'Seminar Ta&sks';
                    Image = ServiceTasks;
                    // RunObject = Report "Service Tasks";
                    ToolTip = 'View participants List.';
                }
                action("Seminar Registration")
                {
                    ApplicationArea = Service;
                    Caption = 'Seminar Registration';
                    Image = "Report";
                    // RunObject = Report "Service Items Out of Warranty";
                    ToolTip = 'Report';
                }
            }

        }
        area(embedding)
        {
            action(Seminars)
            {
                ApplicationArea = All;
                Caption = 'Seminar List';
                Image = Loaners;
                RunObject = Page "Seminar List";
                ToolTip = 'View Seminar list';
            }
            action(Customers)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
                ToolTip = 'View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.';
            }
            action("Rooms")
            {
                ApplicationArea = Service;
                Caption = 'Rooms List';
                Image = MachineCenter;
                RunObject = Page "Resource List";
                RunPageView = where(Type = const(Machine));
                ToolTip = 'View the list of Rooms ';
            }
            action(Instructors)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Trainers';
                Image = Customer;
                RunObject = Page "Resource List";
                RunPageView = where(Type = Const(Person));
                ToolTip = 'View or edit detailed information for the Instructors';
            }
            action("Ongoing Seminar Registration")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Ongoing Seminar Registration';
                RunObject = Page SeminarRegistration;
                RunPageView = WHERE("Seminar registartion Status" = CONST(Registration));
                ToolTip = 'Post item transactions directly to the item ledger to adjust inventory in connection with purchases, sales, and positive or negative adjustments without using documents. You can save sets of item journal lines as standard journals so that you can perform recurring postings quickly. A condensed version of the item journal function exists on item cards for quick adjustment of an items inventory quantity.';
            }
            action("Closed Seminar Registration")
            {
                ApplicationArea = Planning;
                Caption = 'Closed Seminar Registration';
                RunObject = Page SeminarRegistrationList;
                RunPageView = WHERE("Seminar registartion Status" = CONST(Closed));
                ToolTip = 'Calculate a supply plan to fulfill item demand with purchases or transfers.';
            }
            action("Registration Awaiting Approval")
            {
                ApplicationArea = Planning;
                Caption = 'Registration Awaiting Approval';
                RunObject = Page SeminarRegistrationList;
                RunPageView = WHERE("Approval Status" = const(Pending));
                ToolTip = 'Calculate a supply plan to fulfill item demand with purchases or transfers.';
            }
            action("Approved Seminar Registration")
            {
                ApplicationArea = Planning;
                Caption = 'Approved Seminar Registration';
                RunObject = Page SeminarRegistrationList;
                RunPageView = WHERE("Approval Status" = const(Approved));
                ToolTip = 'Calculate a supply plan to fulfill item demand with purchases or transfers.';
            }
        }
        area(sections)
        {
            group("Seminar Management")
            {
                Caption = 'Seminar Management';
                action("Seminar Quotes")
                {
                    ApplicationArea = All;
                    Caption = 'Seminar Quotes';
                    // RunObject = Page ;
                    ToolTip = 'View the list of ongoing service Seminar quotes.';
                }
                action("Seminar Invoices")
                {
                    ApplicationArea = Service;
                    Caption = 'Seminar Orders';
                    Image = Document;
                    // RunObject = Page "Service Orders";
                    ToolTip = 'Open the list of ongoing service orders.';
                }


            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("Posted Seminar Registration")
                {
                    ApplicationArea = Service;
                    Caption = 'Posted Seminar Registration';
                    Image = PostedShipment;
                    RunObject = Page PostedSeminarRegList;
                    ToolTip = 'Open the list of posted seminar Registration.';
                }
                action("Posted Seminar Invoices")
                {
                    ApplicationArea = Service;
                    Caption = 'Posted Seminar Invoices';
                    Image = PostedServiceOrder;
                    RunObject = Page "Posted Sales Invoice";
                    ToolTip = 'Open the list of posted seminar invoices.';
                }
                action("Posted Seminar Credit Memos")
                {
                    ApplicationArea = Service;
                    Caption = 'Posted Seminar Credit Memos';
                    // RunObject = Page "Posted Service Credit Memos";
                    ToolTip = 'Open the list of posted seminar credit memos.';
                }
            }
        }
        area(creation)
        {
            action("Seminar Invoice")
            {
                ApplicationArea = Service;
                Caption = 'Seminar Invoice';
                Image = AgreementQuote;
                RunObject = Page "Service Contract Quote";
                RunPageMode = Create;
                ToolTip = 'Create a new quote to perform service on a customer''s item.';
            }
            // action("Service &Contract")
            // {
            //     ApplicationArea = Service;
            //     Caption = 'Service &Contract';
            //     Image = Agreement;
            //     Promoted = false;
            //     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
            //     //PromotedCategory = Process;
            //     RunObject = Page "Service Contract";
            //     RunPageMode = Create;
            //     ToolTip = 'Create a new service contract.';
            // }
            // action("Service Q&uote")
            // {
            //     ApplicationArea = Service;
            //     Caption = 'Service Q&uote';
            //     Image = Quote;
            //     Promoted = false;
            //     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
            //     //PromotedCategory = Process;
            //     RunObject = Page "Service Quote";
            //     RunPageMode = Create;
            //     ToolTip = 'Create a new service quote.';
            // }
            // action("Service &Order")
            // {
            //     ApplicationArea = Service;
            //     Caption = 'Service &Order';
            //     Image = Document;
            //     Promoted = false;
            //     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
            //     //PromotedCategory = Process;
            //     RunObject = Page "Service Order";
            //     RunPageMode = Create;
            //     ToolTip = 'Create a new service order to perform service on a customer''s item.';
            // }
            action("Seminar Or&der")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Seminar Booking';
                Image = Document;
                RunObject = Page "Sales Order";
                RunPageMode = Create;
                ToolTip = 'Create a new sales order for items or services that require partial posting or order confirmation.';
            }
            group(Reports)
            {
                Caption = 'Reports';
                group("Seminar Reports")
                {
                    Caption = 'Seminar reports';
                    Image = ReferenceData;
                    action("Participant List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Participants List';
                        Image = "Report";
                        RunObject = Report RegParticipants;
                        ToolTip = 'View Participants report ';
                    }
                    action("SeminarList")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Seminar List';
                        Image = "Report";
                        RunObject = Report SeminarList;
                        ToolTip = 'View a report that shows your company''s income and expenses.';
                    }
                    action("SeminarSummary")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Seminar Registration summary';
                        Image = "Report";
                        RunObject = Report "Summary Report";
                        ToolTip = 'View a report that shows your company''s income and expenses.';
                    }
                    action("Revenue")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Revenue';
                        Image = "Report";
                        RunObject = Report Revenues;
                        ToolTip = 'View a report that shows your company''s income and expenses.';
                    }
                    action("Instructor Seminars")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Instructor Seminars';
                        Image = "Report";
                        RunObject = Report "Instructor Seminars";
                        ToolTip = 'View a report that shows your company''s income and expenses.';
                    }
                }

            }
        }
    }

}

profile "Seminar Manager"
{
    Caption = 'Seminar Manager';
    RoleCenter = "Seminar Manager Role Center";
}

