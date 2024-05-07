// SME1.00 - 2024-04-17 - Govind
//   Chapter 4 - Lab 3
//     - PostedSeminarRegHeader table created

table 50107 PostedSeminarRegHeader
{
    Caption = 'Posted Seminar Reg. Header';
    DataClassification = CustomerContent;
    LookupPageId = PostedSeminarRegList;
    DrillDownPageId = PostedSeminarRegList;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(2; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = CustomerContent;
        }
        field(3; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No.';
            DataClassification = CustomerContent;
        }
        field(4; "Seminar Name"; Text[100])
        {
            Caption = 'Seminar Name';
            DataClassification = CustomerContent;
        }
        field(5; "Instructor Resource No."; Code[20])
        {
            Caption = 'Instructor Resource No.';
            DataClassification = CustomerContent;
        }
        field(6; "Instructor Name"; Text[100])
        {
            Caption = 'Instructor Name';
            Editable = false;
        }
        field(7; "Seminar registartion Status"; Enum SeminarRegistrationStatus)
        {
            Caption = 'Seminar registartion Status';
            DataClassification = CustomerContent;
        }
        field(8; Duration; Decimal)
        {
            Caption = 'Duration (Hours)';
            DataClassification = CustomerContent;
        }
        field(9; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
            DataClassification = CustomerContent;
        }
        field(10; "Minimum Participants"; Integer)
        {
            Caption = 'Minimum Participants';
            DataClassification = CustomerContent;
        }
        field(50100; "Total Bookings"; Integer)
        {
            Caption = 'Total Bookings';
        }
        field(50101; "Avaiable Bookings"; Integer)
        {
            Caption = 'Available Bookings';
        }
        field(11; "Room Resource No."; Code[20])
        {
            Caption = 'Room Resource No.';
            DataClassification = CustomerContent;
        }
        field(12; "Room Name"; Text[100])
        {
            Caption = 'Room Name';
            DataClassification = CustomerContent;
        }
        field(13; "Room Address"; Text[50])
        {
            Caption = 'Room Address';
            DataClassification = CustomerContent;
        }
        field(14; "Room Address 2"; Text[50])
        {
            Caption = 'Room Address 2';
            DataClassification = CustomerContent;
        }
        field(15; "Room Post Code"; Code[20])
        {
            Caption = 'Room Post Code';
            DataClassification = CustomerContent;
        }
        field(16; "Room City"; Text[50])
        {
            Caption = 'Room City';
            DataClassification = CustomerContent;
        }
        field(17; "Room Country/Reg. Code"; Code[10])
        {
            Caption = 'Room Country/Reg. Code';
            DataClassification = CustomerContent;
            TableRelation = "Country/Region";
        }
        field(18; "Room County"; Text[30])
        {
            Caption = 'Room County';
            DataClassification = CustomerContent;
        }
        field(19; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
            DataClassification = CustomerContent;
        }
        field(20; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Product Posting Group";
        }
        field(21; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            DataClassification = CustomerContent;
            TableRelation = "VAT Product Posting Group";
        }
        field(22; Comment; Boolean)
        {
            Caption = 'Comment';
            DataClassification = CustomerContent;
        }
        field(23; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(24; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }
        field(25; "Reason Code"; Code[20])
        {
            Caption = 'Reason Code';
            DataClassification = CustomerContent;
            TableRelation = "Reason Code";
        }
        field(26; "No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(27; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
            DataClassification = CustomerContent;
        }
        field(28; "Posting No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(29; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }

        field(40; "Approval Status"; Enum ApprovalStatus)
        {
            Caption = 'Approval Status';
        }
        field(41; No_Printed; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(42; "Total Amount"; Decimal)
        {
            Editable = false;
            DecimalPlaces = 0 : 5;
        }
        field(43; "Line Discount"; Decimal)
        {
            Editable = false;
            DecimalPlaces = 0 : 5;
        }
        field(44; "Number of Lines"; Integer)
        {
            Editable = false;
        }
        field(45; "ToTime"; Time)
        {
            Caption = 'To Time';
            DataClassification = ToBeClassified;
        }

        field(50103; NumberofDays; Integer)
        {
            Caption = 'Number of Days';
            DataClassification = ToBeClassified;
        }
        field(50105; FromTime; Time)
        {
            Caption = 'From Time';
            DataClassification = ToBeClassified;
        }

        field(46; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }

        field(50111; "User ID"; Text[50])
        {
            DataClassification = CustomerContent;
            TableRelation = User;

            trigger OnLookup()
            var
                UserMgt: Codeunit "User Management";
            begin
                UserMgt.DisplayUserInformation("User ID");
            end;
        }
        field(30; "Source Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Source Code";
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Index2; "Room Resource No.")
        {
            SumIndexFields = Duration;
        }
    }

    var
        resource: Record Resource;

}