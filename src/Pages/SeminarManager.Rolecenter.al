page 50118 "Seminar Manager Role Center"
{
    Caption = 'Seminar Manager';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part(Headline; "Seminar Manager Healine")
            {
                ApplicationArea = all;
            }

            part("Seminar Manager Activities"; "Seminar Manager Activities")
            {
                ApplicationArea = Suite;
            }
            group(Insights)
            {
                part("My Seminars"; MySeminars)
                {
                    ApplicationArea = Suite;
                }
                part("My Customers"; "My Customers")
                {
                    ApplicationArea = Suite;
                }
                systempart(Control1901377608; MyNotes)
                {
                    ApplicationArea = basic, Suite;
                }
                // }
            }
        }
    }
    actions
    {
        area(Embedding)
        {
            action("Seminar Registartions")
            {
                ApplicationArea = all;
                Caption = 'Seminar Registartions';
                RunObject = page SeminarRegistrationList;
            }
            action("Seminars")
            {
                ApplicationArea = All;
                Caption = 'Seminars';
                RunObject = Page "Seminar List";
            }
            action(Intructors)
            {
                ApplicationArea = all;
                Caption = 'Intructors';
                RunObject = page "Resource List";
                RunPageLink = Type = const(Person);
            }
            action(Rooms)
            {
                ApplicationArea = all;
                Caption = 'Rooms';
                RunObject = page "Resource List";
                RunPageLink = Type = const(Machine);
            }
            action("Customers ")
            {
                ApplicationArea = all;
                Caption = 'Customers';
                RunObject = Page "Customer List";
            }
            action("Contacts ")
            {
                ApplicationArea = all;
                Caption = 'Contacts';
                RunObject = Page "Contact List";
            }
        }
        area(Sections)
        {
            group(Seminar)
            {
                Caption = 'Seminars';
                action("Seminar List ")
                {
                    ApplicationArea = All;
                    Caption = 'Seminar list';
                    RunObject = Page "Seminar List";
                }
                action("Seminar Charges ")
                {
                    ApplicationArea = all;
                    Caption = 'Seminar Charges';
                    RunObject = Page SeminarCharges;
                }
            }
            group("Seminar Registrations")
            {
                action("Registartions ")
                {
                    ApplicationArea = all;
                    Caption = 'Registartions';
                    RunObject = page SeminarRegistrationList;
                }
            }
            group(Customers)
            {
                action("Customer ")
                {
                    ApplicationArea = all;
                    Caption = 'Customers';
                    RunObject = Page "Customer List";
                }
            }
            group(Resources)
            {
                action("Resource ")
                {
                    ApplicationArea = all;
                    Caption = 'Resource';
                    RunObject = page "Resource List";
                }
            }
            group("Setup  ")
            {
                action("Setup ")
                {
                    ApplicationArea = all;
                    Caption = 'Seminar Setup';
                    RunObject = page "Seminar Setup";
                }
            }
            group("Posted Seminar  ")
            {
                action("Posted Registrations ")
                {
                    ApplicationArea = all;
                    Caption = 'Posted Registrations';
                    RunObject = Page PostedSeminarRegList;
                }
            }
        }
        area(Creation)
        {
            action("Seminar   ")
            {
                Caption = 'Seminar';
                ApplicationArea = all;
                RunObject = page "Seminar card";
                RunPageMode = Create;
            }

            action("Resource   ")
            {
                Caption = 'Resource';
                ApplicationArea = all;
                RunObject = page "Resource card";
                RunPageMode = Create;
            }
            action("Registration   ")
            {
                Caption = 'Registration';
                ApplicationArea = all;
                RunObject = page SeminarRegistration;
                RunPageMode = Create;
            }
        }
        area(Reporting)
        {
            action("Participants List")
            {
                Caption = 'Participants List';
                ApplicationArea = all;
                runobject = report RegParticipants;
            }
            action("Seminar Invoice")
            {
                Caption = 'Invoice';
                ApplicationArea = all;
                runobject = report "Create Invoice";
            }
            action("Mail Participants List")
            {
                ApplicationArea = All;
                Caption = 'Mail', comment = 'NLB=""';
                RunObject = codeunit SeminarEmail;
            }

        }
    }
}
profile "Seminar Manager"
{
    Caption = 'Seminar Manager';
    RoleCenter = "Seminar Manager Role Center";
}

