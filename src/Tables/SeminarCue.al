table 50113 "Seminar Cue"
{

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
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
            CalcFormula = count(SeminarRegistrationHeader where(Status = const(Open)));
            FieldClass = FlowField;
        }
        field(5; "Pending Approval Registration"; Integer)
        {
            CalcFormula = count(SeminarRegistrationHeader where(Status = const(Pending)));
            FieldClass = FlowField;
        }
        field(6; "Closed Registration"; Integer)
        {
            CalcFormula = count(SeminarRegistrationHeader where(Status = const(Approved)));
            FieldClass = FlowField;
        }
        field(7; "Rejected Registration"; Integer)
        {
            CalcFormula = count(SeminarRegistrationHeader where(Status = const(Rejected)));
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