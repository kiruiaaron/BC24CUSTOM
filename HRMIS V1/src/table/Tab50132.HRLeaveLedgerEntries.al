table 50132 "HR Leave Ledger Entries"
{
    DrillDownPageID = 50228;
    LookupPageID = 50228;

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "Document No.";
        Code[20])
        {
        }
        field(3; "Posting Date"; Date)
        {
        }
        field(4; "Entry Type"; Option)
        {
            OptionCaption = ' ,Positive Adjustment,Negative Adjustment,Reimbursement,Carry forward';
            OptionMembers = " ","Positive Adjustment","Negative Adjustment",Reimbursement,"Carry forward";
        }
        field(5; "Employee No."; Code[20])
        {
            TableRelation = Employee."No.";
        }
        field(6; "Leave Type"; Code[50])
        {
            TableRelation = "HR Leave Types".Code;
        }
        field(7; "Leave Period"; Code[20])
        {
            TableRelation = "HR Leave Periods".Code;
        }
        field(8; Days; Decimal)
        {
        }
        field(9; "HR Location"; Code[20])
        {
        }
        field(10; "HR Department"; Code[20])
        {
        }
        field(11; "Leave Start Date"; Date)
        {
        }
        field(12; "Leave End Date"; Date)
        {
        }
        field(49; Description; Text[250])
        {

            trigger OnValidate()
            begin
                Description := UPPERCASE(Description);
            end;
        }
        field(50; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(51; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(52; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(53; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(54; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(55; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(56; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(57; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(58; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center".Code;
        }
        field(99; "User ID"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(100; "No. Series"; Code[20])
        {
        }
        field(101; "Leave Year"; Integer)
        {
        }
        field(102; "Leave Allocation"; Boolean)
        {
        }
        field(103; Days2; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}

