// SME1.00 - 2024-04-16 - Govind
//   Chapter 4 - Lab 1
//     - Added seminar cue table 

table 50113 "Seminar Cue"
{

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            Caption = 'Primary Key';
            DataClassification = ToBeClassified;
        }

        field(2; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }

        field(3; "User ID Filter"; Code[50])
        {
            Caption = 'User ID Filter';
            FieldClass = FlowFilter;
        }

        field(8; "Planned Seminars"; Integer)
        {
            Caption = 'Planned Seminars';
            CalcFormula = count(Seminar where("Seminar registartion Status" = const(Planning)));
            FieldClass = FlowField;
        }

        field(7; "Open Seminars Registrations"; Integer)
        {
            Caption = 'Open Seminars Registrations';
            CalcFormula = count(Seminar where("Seminar registartion Status" = const(Registration)));
            FieldClass = FlowField;
        }

        field(6; "Closed Seminar Registartions"; Integer)
        {
            Caption = 'Closed Seminar Registartions';
            CalcFormula = count(Seminar where("Seminar registartion Status" = const(Closed)));
            FieldClass = FlowField;
        }

        field(4; "Cancelled Seminars"; Integer)
        {
            Caption = 'Cancelled Seminars';
            CalcFormula = count(Seminar where("Seminar registartion Status" = const(Cancelled)));
            FieldClass = FlowField;

        }

        field(5; "Total Seminars"; Integer)
        {
            Caption = 'Total Seminars';
            CalcFormula = count(seminar);
            FieldClass = FlowField;
        }

        field(9; "Total Registrations"; Integer)
        {
            Caption = 'Total Registartions';
            CalcFormula = count(SeminarRegistrationHeader);
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }
}