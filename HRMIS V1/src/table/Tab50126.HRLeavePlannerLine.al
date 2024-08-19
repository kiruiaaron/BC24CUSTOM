table 50126 "HR Leave Planner Line"
{

    fields
    {
        field(1; "Leave Planner No."; Code[20])
        {
            Editable = false;
        }
        field(2; "Start Date"; Date)
        {

            trigger OnValidate()
            begin
                //Check if Its Non Working day
            end;
        }
        field(3; "End Date"; Date)
        {
            Editable = false;

            trigger OnValidate()
            begin
                "No. of Days" := DATE2DMY("End Date", 1) - DATE2DMY("Start Date", 1) + 1;
            end;
        }
        field(4; "Substitute No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                IF Employee.GET("Substitute No.") THEN BEGIN
                    "Substitute Name" := Employee."Last Name" + ' ' + Employee."First Name" + ' ' + Employee."Middle Name";
                END ELSE BEGIN
                    "Substitute Name" := '';
                END;
            end;
        }
        field(5; "Substitute Name"; Text[150])
        {
            Editable = false;
        }
        field(6; "No. of Days"; Integer)
        {

            trigger OnValidate()
            begin
                TESTFIELD("Start Date");
                IF HRLeavePlannerHeader.GET("Leave Planner No.") THEN BEGIN
                    HRLeavePlannerHeader.TESTFIELD(HRLeavePlannerHeader."Employee No.");
                    HRLeavePlannerHeader.TESTFIELD(HRLeavePlannerHeader."Leave Type");
                    HRLeavePlannerHeader.TESTFIELD(HRLeavePlannerHeader."Leave Period");
                    HRLeavePlannerHeader.TESTFIELD(HRLeavePlannerHeader.Description);
                    HRLeavePlannerHeader.TESTFIELD(HRLeavePlannerHeader."Global Dimension 1 Code");
                    Employee.RESET;
                    Employee.SETRANGE("No.", HRLeavePlannerHeader."Employee No.");
                    IF Employee.FINDFIRST THEN
                        BaseCalender.RESET;
                    BaseCalender.SETRANGE(Code, Employee."Leave Calendar");
                    IF BaseCalender.FINDFIRST THEN
                        "End Date" := HRLeaveManagement.CalculateLeaveEndDate(HRLeavePlannerHeader."Leave Type", HRLeavePlannerHeader."Leave Period", "Start Date", "No. of Days", BaseCalender.Code);
                END;
            end;
        }
    }

    keys
    {
        key(Key1; "Leave Planner No.", "Start Date")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Employee: Record Employee;
        HRLeaveManagement: Codeunit "HR Leave Management";
        HRLeavePlannerHeader: Record "HR Leave Planner Header";
        BaseCalender: Record "Base Calendar";

}

