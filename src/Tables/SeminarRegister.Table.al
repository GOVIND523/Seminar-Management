// SME1.00 - 2024-04-17 - Govind
//   Chapter 3 - Lab 2
//     - Seminar Register Table created

table 50111 SeminarRegister
{
    Caption = 'Seminar Register';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(2; "From Entry No."; Integer)
        {
            Caption = 'From Entry No.';
            DataClassification = CustomerContent;
            TableRelation = SeminarLedgerEntry;
        }
        field(3; "To Entry No."; Integer)
        {
            Caption = 'To Entry No.';
            DataClassification = CustomerContent;
            TableRelation = SeminarLedgerEntry;
        }
        field(4; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            DataClassification = CustomerContent;
        }
        field(5; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            DataClassification = CustomerContent;
            TableRelation = "Source Code";
        }
        field(6; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;
            TableRelation = User;
        }
        field(7; "Journal Batch Name"; Code[20])
        {
            Caption = 'Journal Batch Name';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Index02; "Creation Date") { }
        key(Index03; "Source Code", "Journal Batch Name", "Creation Date") { }
    }

}