table 50207 "Leave Allowance Request"
{

    fields
    {
        field(1;"No.";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Document Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Employe No.";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Employee Name";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Payroll Period";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(10;Status;Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionMembers = Open,"Pending Approval",Approved;

            trigger OnValidate()
            begin
                IF Status=Status::Approved THEN BEGIN
                //  PayrollManagement.CreatePayrollLeaveAllowance(Rec);
                  MESSAGE(LeaveAllowanceMessage,"Payroll Period");
                END;
            end;
        }
    }

    keys
    {
        key(Key1;"No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        LeaveAllowanceMessage: Label 'Leave allownce has sucessfully been Appoved and will be factored in for the payroll period %1';
}

