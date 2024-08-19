table 50131 "HR Leave Allocation Line"
{

    fields
    {
        field(1; "Leave Allocation No."; Code[20])
        {
            Editable = false;
            TableRelation = "HR Leave Allocation Header"."No.";
        }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                IF Employee.GET("Employee No.") THEN BEGIN
                    "Employee Name" := Employee."Last Name" + ' ' + Employee."First Name" + ' ' + Employee."Middle Name";
                END ELSE BEGIN
                    "Employee Name" := '';
                END;
            end;
        }
        field(3; "Employee Name"; Text[150])
        {
            Editable = false;
        }
        field(4; "Entry Type"; Option)
        {
            OptionCaption = ' ,Positive Adjustment,Negative Adjustment,Reimbursement,Carry forward';
            OptionMembers = " ","Positive Adjustment","Negative Adjustment",Reimbursement,"Carry forward";
        }
        field(5; "Days Allocated"; Integer)
        {
            MinValue = 0;

            trigger OnValidate()
            begin
                "Days Approved" := "Days Allocated";
            end;
        }
        field(6; "Days Approved"; Integer)
        {
            MinValue = 0;
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
        field(70; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Approved,Rejected,Posted';
            OptionMembers = Open,"Pending Approval",Approved,Rejected,Posted;
        }
        field(71; Posted; Boolean)
        {
            Editable = false;
        }
        field(72; "Posted By"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(73; "Date Posted"; Date)
        {
            Editable = false;
        }
        field(74; "Time Posted"; Time)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Leave Allocation No.", "Employee No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF HRLeaveAllocationHeader.GET("Leave Allocation No.") THEN BEGIN
            Description := HRLeaveAllocationHeader.Description;
            "Global Dimension 1 Code" := HRLeaveAllocationHeader."Global Dimension 1 Code";
            "Global Dimension 2 Code" := HRLeaveAllocationHeader."Global Dimension 2 Code";
            "Shortcut Dimension 3 Code" := HRLeaveAllocationHeader."Shortcut Dimension 3 Code";
            "Shortcut Dimension 4 Code" := HRLeaveAllocationHeader."Shortcut Dimension 4 Code";
            "Shortcut Dimension 5 Code" := HRLeaveAllocationHeader."Shortcut Dimension 5 Code";
            "Shortcut Dimension 6 Code" := HRLeaveAllocationHeader."Shortcut Dimension 6 Code";
            "Shortcut Dimension 7 Code" := HRLeaveAllocationHeader."Shortcut Dimension 7 Code";
            "Shortcut Dimension 8 Code" := HRLeaveAllocationHeader."Shortcut Dimension 8 Code";
            "Responsibility Center" := HRLeaveAllocationHeader."Responsibility Center";
        END ELSE BEGIN
            Description := '';
            "Global Dimension 1 Code" := '';
            "Global Dimension 2 Code" := '';
            "Shortcut Dimension 3 Code" := '';
            "Shortcut Dimension 4 Code" := '';
            "Shortcut Dimension 5 Code" := '';
            "Shortcut Dimension 6 Code" := '';
            "Shortcut Dimension 7 Code" := '';
            "Shortcut Dimension 8 Code" := '';
            "Responsibility Center" := '';
        END;
    end;

    var
        Employee: Record 5200;
        HRLeaveAllocationHeader: Record 50130;
}

