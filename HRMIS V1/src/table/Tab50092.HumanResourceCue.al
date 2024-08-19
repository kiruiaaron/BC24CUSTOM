table 50092 "Human Resource Cue"
{
    Caption = 'Human Resource Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(20; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(21; "User ID Filter"; Code[50])
        {
            Caption = 'User ID Filter';
            FieldClass = FlowFilter;
        }

        field(52137202; "HR Jobs Open"; Integer)
        {
            CalcFormula = Count("HR Jobs" WHERE(Status = CONST(Open)));
            FieldClass = FlowField;
        }
        field(52137203; "HR Jobs Pending Approval"; Integer)
        {
            CalcFormula = Count("HR Jobs" WHERE(Status = CONST("Pending Approval")));
            FieldClass = FlowField;
        }
        field(52137204; "HR Jobs Approved"; Integer)
        {
            CalcFormula = Count("HR Jobs" WHERE(Status = CONST(Released)));
            FieldClass = FlowField;
        }
        field(52137205; "Employee Requisition Open"; Integer)
        {
            CalcFormula = Count("HR Employee Requisitions" WHERE(Status = CONST(Open)));
            Caption = 'Employee Requisition Open';
            FieldClass = FlowField;
        }
        field(52137206; "Employee Requisition Pending"; Integer)
        {
            CalcFormula = Count("HR Employee Requisitions" WHERE(Status = CONST("Pending Approval")));
            Caption = 'Employee Requisition Pending Approval';
            FieldClass = FlowField;
        }
        field(52137207; "Employee Requisition Approved"; Integer)
        {
            CalcFormula = Count("HR Employee Requisitions" WHERE(Status = CONST(Released)));
            Caption = 'Employee Requisitions Approved';
            FieldClass = FlowField;
        }
        field(52137208; "Leave Allocation Open"; Integer)
        {
            CalcFormula = Count("HR Leave Allocation Header" WHERE(Status = CONST(Open)));
            Caption = 'Leave Allocations Open';
            FieldClass = FlowField;
        }
        field(52137209; "Leave Alloc. Pending Approval"; Integer)
        {
            CalcFormula = Count("HR Leave Allocation Header" WHERE(Status = CONST("Pending Approval")));
            FieldClass = FlowField;
        }
        field(52137210; "Leave Alloc. Appproved"; Integer)
        {
            CalcFormula = Count("HR Leave Allocation Header" WHERE(Status = CONST(Released)));
            FieldClass = FlowField;
        }
        field(52137211; "Leave Planner Open"; Integer)
        {
            //CalcFormula = Count("HR Leave Planner Header" WHERE(sta = CONST(Open)));
            FieldClass = Normal;
        }
        field(52137212; "Leave Planner Pending Approval"; Integer)
        {
            CalcFormula = Count("HR Leave Planner Header" WHERE(Status = CONST("Pending Approval")));
            FieldClass = FlowField;
        }
        field(52137213; "Leave Planner Approved"; Integer)
        {
            CalcFormula = Count("HR Leave Planner Header" WHERE(Status = CONST(Released)));
            FieldClass = FlowField;
        }
        field(52137214; "Leave Applications Open"; Integer)
        {

            /*             CalcFormula = Count("HR Leave Application" WHERE(Status = CONST(Open)));
                        FieldClass = FlowField; */
        }
        field(52137215; "Leave Application Pending"; Integer)
        {
            /*             CalcFormula = Count("HR Leave Application" WHERE(Status = CONST("Pending Approval")));
                        Caption = 'Leave Applications Pending Approval';
                        FieldClass = FlowField; */
        }
        field(52137216; "Leave Applications Approved"; Integer)
        {
            /*             CalcFormula = Count("HR Leave Application" WHERE(Status = CONST(Released)));
                        Caption = 'Leave Applications Approved';
                        FieldClass = FlowField; */
        }
        field(52137217; "Leave Reimbursement Open"; Integer)
        {
            CalcFormula = Count("HR Leave Reimbursement" WHERE(Status = CONST(Open)));
            FieldClass = FlowField;
        }
        field(52137218; "Leave Reimbursement Pending"; Integer)
        {
            CalcFormula = Count("HR Leave Reimbursement" WHERE(Status = CONST("Pending Approval")));
            Caption = 'Leave Reimbursement Pending Approval';
            FieldClass = FlowField;
        }
        field(52137219; "Leave Reimbursement Approved"; Integer)
        {
            CalcFormula = Count("HR Leave Reimbursement" WHERE(Status = CONST(Released)));
            FieldClass = FlowField;
        }
        field(52137220; "Leave CarryOver Open"; Integer)
        {
            CalcFormula = Count("HR Leave Carryover" WHERE(Status = CONST(Open)));
            FieldClass = FlowField;
        }
        field(52137221; "Leave CarryOver Pending Apprv."; Integer)
        {
            CalcFormula = Count("HR Leave Reimbursement" WHERE(Status = CONST("Pending Approval")));
            Caption = 'Leave CarryOver Pending Approval';
            FieldClass = FlowField;
        }
        field(52137222; "Leave CarryOver Approved"; Integer)
        {
            CalcFormula = Count("HR Leave Reimbursement" WHERE(Status = CONST(Released)));
            FieldClass = FlowField;
        }
        /* field(52137223; "Leave Allowance Open"; Integer)
        {
            CalcFormula = Count("Leave Allowance Request" WHERE(Status = CONST(Open)));
            FieldClass = FlowField;
        }
        field(52137224; "Leave Allowance Pending Apprv."; Integer)
        {
            CalcFormula = Count("Leave Allowance Request" WHERE(Status = CONST("Pending Approval")));
            Caption = 'Leave Allowance Pending Approval';
            FieldClass = FlowField;
        }
        field(52137225; "Leave Allownace Approved"; Integer)
        {
            CalcFormula = Count("Leave Allowance Request" WHERE(Status = CONST(Approved)));
            FieldClass = FlowField;
        } */
        field(52137226; "Employee Appraisal Open"; Integer)
        {
            CalcFormula = Count("HR Employee Appraisal Header" WHERE(Status = CONST(Open)));
            FieldClass = FlowField;
        }
        field(52137227; "Employee Appraisal Pending App"; Integer)
        {
            CalcFormula = Count("HR Employee Appraisal Header" WHERE(Status = CONST("Pending Approval")));
            Caption = 'Employee Appraisal Pending Approval';
            FieldClass = FlowField;
        }
        field(52137228; "Employee Appraisal Approved"; Integer)
        {
            CalcFormula = Count("HR Employee Appraisal Header" WHERE(Status = CONST(Released)));
            FieldClass = FlowField;
        }
        field(52137229; "Loan Products Open"; Integer)
        {

        }













        field(52137242; "Training Needs Pending"; Integer)
        {
            CalcFormula = Count("HR Training Needs Header" WHERE(Status = CONST("Pending Approval")));
            Caption = 'Training Needs Applications Pending Approval';
            FieldClass = FlowField;
        }
        field(52137243; "Training Needs Approved"; Integer)
        {
            CalcFormula = Count("HR Training Needs Header" WHERE(Status = CONST(Approved)));
            Caption = 'Training Needs Applications Approved';
            FieldClass = FlowField;
        }
        field(52137244; "Training Group App. Open"; Integer)
        {
            CalcFormula = Count("HR Training Group" WHERE(Status = CONST(Open)));
            Caption = 'Training Group Application Open';
            FieldClass = FlowField;
        }
        field(52137245; "Training Group App. Pending"; Integer)
        {
            CalcFormula = Count("HR Training Group" WHERE(Status = CONST("Pending Approval")));
            Caption = 'Training Group Application Pending Approval';
            FieldClass = FlowField;
        }
        field(52137246; "Training Group App. Apprvd."; Integer)
        {
            CalcFormula = Count("HR Training Group" WHERE(Status = CONST(Approved)));
            Caption = 'Training Group Applications Apprvoved';
            FieldClass = FlowField;
        }
        field(52137247; "Training Applications Open"; Integer)
        {
            CalcFormula = Count("HR Training Applications" WHERE(Status = CONST(Open)));
            Caption = 'Training Applications Open';
            FieldClass = FlowField;
        }
        field(52137248; "Training Application Pending"; Integer)
        {
            CalcFormula = Count("HR Training Applications" WHERE(Status = CONST("Pending Approval")));
            Caption = 'Training Application Pending Approval';
            FieldClass = FlowField;
        }
        field(52137249; "Training Applications Approved"; Integer)
        {
            CalcFormula = Count("HR Training Applications" WHERE(Status = CONST(Approved)));
            Caption = 'Training Applications Approved';
            FieldClass = FlowField;
        }
        field(52137250; "Training Evaluation Open"; Integer)
        {
            CalcFormula = Count("Training Evaluation" WHERE(Status = CONST("Pending Approval")));
            Caption = 'Training Evaluation Open';
            FieldClass = FlowField;
        }
        field(52137251; "Training Evaluation Pending"; Integer)
        {
            CalcFormula = Count("Training Evaluation" WHERE(Status = CONST(Approved)));
            Caption = 'Training Evaluation Pending Approval';
            FieldClass = FlowField;
        }
        field(52137252; "Training Evaluation Approved"; Integer)
        {
            CalcFormula = Count("Training Evaluation" WHERE(Status = CONST(Approved)));
            Caption = 'Training Evaluation Approved';
            FieldClass = FlowField;
        }
        /* field(52137253; "Detail Update Open"; Integer)
        {
            CalcFormula = Count("HR Employee Detail Update" WHERE(Status = CONST(Open)));
            Caption = 'Employee Detail Up-date Open';
            FieldClass = FlowField;
        }
        field(52137254; "Detail Update Pending"; Integer)
        {
            CalcFormula = Count("HR Employee Detail Update" WHERE(Status = CONST("Pending Approval")));
            Caption = 'Employee Detail Update Pending Approval';
            FieldClass = FlowField;
        }
        field(52137255; "Detail Update Approved"; Integer)
        {
            CalcFormula = Count("HR Employee Detail Update" WHERE(Status = CONST(Approved)));
            Caption = 'Employee Detail Update Approved';
            FieldClass = FlowField;
        } */
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}

