table 50115 "Seminar Room"
{
    Caption = 'Seminar Room';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Name; Text[30])
        {
            Caption = 'Name';
        }
        field(3; Address; Text[30])
        {
            Caption = 'Address';
        }
        field(4; Address2; Text[30])
        {
            Caption = 'Address2';
        }
        field(5; City; Text[30])
        {
            Caption = 'City';
            TableRelation = IF ("Country Code" = CONST('')) "Post Code".City
            ELSE
            IF ("Country Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country Code"));
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                OnBeforeLookupCity(Rec, PostCode);

                PostCode.LookupPostCode(City, "Post Code", "Room County", "Country Code");

                OnAfterLookupCity(Rec, PostCode);
            end;

            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin
                IsHandled := false;
                OnBeforeValidateCity(Rec, PostCode, CurrFieldNo, IsHandled);
                if not IsHandled then
                    PostCode.ValidateCity(City, "Post Code", "Room County", "Country Code", (CurrFieldNo <> 0) and GuiAllowed);

                OnAfterValidateCity(Rec, xRec);
            end;

        }


        field(6; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = "Post Code";


        }
        field(7; "Country Code"; Code[10])
        {
            Caption = 'Country Code';
            TableRelation = "Country/Region";

        }
        field(8; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
        }
        field(9; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
        }
        field(10; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }
        field(11; Contact; Text[50])
        {
            Caption = 'Contact';
            trigger OnValidate()

            begin
                if Contact.Get("Contact No.") and (Name = '')
                then
                    Name := Contact.Name
            end;
        }
        field(12; Email; Text[80])
        {
            Caption = 'Email';
        }
        field(13; "Home Page"; Text[90])
        {
            Caption = 'Home Page';
        }
        field(14; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
        }
        field(15; Allocation; Decimal)
        {
            Caption = 'Allocation';
            Editable = false;
        }
        field(16; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            TableRelation = Resource where(Type = const(Machine));
            trigger OnValidate()
            begin
                if Resource.Get("Resource No.") and (Name = '')
                 Then
                    Name := Resource.Name;
            end;
        }
        field(17; Comment; Boolean)
        {
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = exist("Comment Line" where("Table Name" = const("G/L Account"), "No." = field("Code")));

        }
        field(18; "Internal/External"; Option)
        {
            Caption = 'Internal/External';
            OptionMembers = Internal,External;
        }
        field(19; "Contact No."; Code[20])
        {
            Caption = 'Contact No.';
            TableRelation = Contact;
        }
        field(20; "Room County"; Text[20])
        {
            Caption = 'Room County';
            DataClassification = CustomerContent;

        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Name, City, "Post Code", "Phone No.")
        {
        }
    }

    trigger OnDelete()
    begin
        CommentLine.Reset();
        CommentLine.SetRange("Table Name", CommentLine."Table Name"::"Seminar Room");
        CommentLine.SetRange("Code", "Code");
        CommentLine.DeleteAll();
    end;

    var
        PostCode: Record "Post Code";
        Resource: Record Resource;
        Contact: Record Contact;
        Seminar: Record "Seminar Room";
        CommentLine: Record "Comment Line";




    [IntegrationEvent(false, false)]
    local procedure OnBeforeLookupCity(var Seminar: Record "Seminar Room"; var PostCodeRec: Record "Post Code")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeLookupPostCode(var Seminar: Record "Seminar Room"; var PostCodeRec: Record "Post Code")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterLookupCity(var Seminar: Record "Seminar Room"; var PostCodeRec: Record "Post Code")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidateCity(var Seminar: Record "Seminar Room"; var PostCodeRec: Record "Post Code"; CurrentFieldNo: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterValidateCity(var Seminar: Record "Seminar Room"; xCustomer: Record "Seminar Room")
    begin
    end;







}
