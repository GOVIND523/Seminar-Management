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

        field(4; "Open Registration"; Integer)
        {
            Caption = 'Open Registartions';
            CalcFormula = count(SeminarRegistrationHeader where("Approval Status" = const(Open)));
            FieldClass = FlowField;
        }
        field(5; "Pending Approval Registration"; Integer)
        {
            Caption = 'Pending Approval Registartion';
            CalcFormula = count(SeminarRegistrationHeader where("Approval Status" = const(Pending)));
            FieldClass = FlowField;
        }
        field(6; "Closed Registration"; Integer)
        {
            Caption = 'Closed Registartions';
            CalcFormula = count(SeminarRegistrationHeader where("Approval Status" = const(Approved)));
            FieldClass = FlowField;
        }
        field(7; "Rejected Registration"; Integer)
        {
            Caption = 'Rejected Registrations';
            CalcFormula = count(SeminarRegistrationHeader where("Approval Status" = const(Rejected)));
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