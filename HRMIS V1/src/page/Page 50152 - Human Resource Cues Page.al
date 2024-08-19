page 50152 "Human Resource Cues Page"
{
    PageType = CardPart;
    SourceTable = 50092;

    layout
    {
        area(content)
        {
            cuegroup("HR Jobs")
            {
                field("HR Jobs Open"; Rec."HR Jobs Open")
                {
                    DrillDownPageID = "HR Jobs List";

                    ApplicationArea = All;
                }
                field("HR Jobs Pending Approval"; Rec."HR Jobs Pending Approval")
                {
                    DrillDownPageID = "HR Jobs List";

                    ApplicationArea = All;
                }
                field("HR Jobs Approved"; Rec."HR Jobs Approved")
                {
                    DrillDownPageID = "Approved HR Jobs";

                    ApplicationArea = All;
                }
            }
            cuegroup("Employee Requisitions")
            {
                field("Employee Requisition Open"; Rec."Employee Requisition Open")
                {
                    DrillDownPageID = "Employee Requisitions";

                    ApplicationArea = All;
                }
                field("Employee Requisition Pending"; Rec."Employee Requisition Pending")
                {
                    DrillDownPageID = "Employee Requisitions";

                    ApplicationArea = All;
                }
                field("Employee Requisition Approved"; Rec."Employee Requisition Approved")
                {
                    DrillDownPageID = "Employee Requisitions";

                    ApplicationArea = All;
                }
            }
            cuegroup("HR Leave")
            {
                field("Leave Allocation Open"; Rec."Leave Allocation Open")
                {
                    DrillDownPageID = "Leave Allocations";

                    ApplicationArea = All;
                }
                field("Leave Alloc. Pending Approval"; Rec."Leave Alloc. Pending Approval")
                {
                    DrillDownPageID = "Leave Allocations";

                    ApplicationArea = All;
                }
                field("Leave Alloc. Appproved"; Rec."Leave Alloc. Appproved")
                {
                    DrillDownPageID = "Leave Allocations";

                    ApplicationArea = All;
                }
                field("Leave Planner Open"; Rec."Leave Planner Open")
                {
                    DrillDownPageID = "Leave Planner List";

                    ApplicationArea = All;
                }
                field("Leave Planner Pending Approval"; Rec."Leave Planner Pending Approval")
                {
                    DrillDownPageID = "Leave Planner List";

                    ApplicationArea = All;
                }
                field("Leave Planner Approved"; Rec."Leave Planner Approved")
                {
                    DrillDownPageID = "Leave Planner List";

                    ApplicationArea = All;
                }
                field("Leave Applications Open"; Rec."Leave Applications Open")
                {
                    DrillDownPageID = "Leave Applications";

                    ApplicationArea = All;
                }
                field("Leave Application Pending"; Rec."Leave Application Pending")
                {
                    DrillDownPageID = "Leave Applications";

                    ApplicationArea = All;
                }
                field("Leave Applications Approved"; Rec."Leave Applications Approved")
                {
                    DrillDownPageID = "Leave Applications";

                    ApplicationArea = All;
                }
                field("Leave Reimbursement Open"; Rec."Leave Reimbursement Open")
                {
                    DrillDownPageID = "Leave Reimbursements";

                    ApplicationArea = All;
                }
                field("Leave Reimbursement Pending"; Rec."Leave Reimbursement Pending")
                {
                    DrillDownPageID = "Leave Reimbursements";

                    ApplicationArea = All;
                }
                field("Leave Reimbursement Approved"; Rec."Leave Reimbursement Approved")
                {
                    DrillDownPageID = "Leave Reimbursements";

                    ApplicationArea = All;
                }
                field("Leave CarryOver Open"; Rec."Leave CarryOver Open")
                {
                    DrillDownPageID = "Leave Carryovers";

                    ApplicationArea = All;
                }
                field("Leave CarryOver Pending Apprv."; Rec."Leave CarryOver Pending Apprv.")
                {
                    DrillDownPageID = "Leave Carryovers";

                    ApplicationArea = All;
                }
                field("Leave CarryOver Approved"; Rec."Leave CarryOver Approved")
                {
                    DrillDownPageID = "Leave Carryovers";

                    ApplicationArea = All;
                }



            }
            cuegroup("HR Appraisal")
            {

            }
            cuegroup("HR Staff Loans")
            {
                field("Loan Products Open"; Rec."Loan Products Open")
                {
                    ApplicationArea = All;
                }


            }
            cuegroup("HR Training")
            {

                field("Training Needs Pending"; Rec."Training Needs Pending")
                {
                    DrillDownPageID = "Training Needs";

                    ApplicationArea = All;
                }
                field("Training Needs Approved"; Rec."Training Needs Approved")
                {
                    DrillDownPageID = "Training Needs";

                    ApplicationArea = All;
                }
                field("Training Group App. Open"; Rec."Training Group App. Open")
                {
                    DrillDownPageID = "Training Groups";

                    ApplicationArea = All;
                }
                field("Training Group App. Pending"; Rec."Training Group App. Pending")
                {
                    DrillDownPageID = "Training Groups";

                    ApplicationArea = All;
                }
                field("Training Group App. Apprvd."; Rec."Training Group App. Apprvd.")
                {
                    DrillDownPageID = "Training Groups";

                    ApplicationArea = All;
                }
                field("Training Applications Open"; Rec."Training Applications Open")
                {
                    DrillDownPageID = "Training Applications";

                    ApplicationArea = All;
                }
                field("Training Application Pending"; Rec."Training Application Pending")
                {
                    DrillDownPageID = "Training Applications";

                    ApplicationArea = All;
                }
                field("Training Applications Approved"; Rec."Training Applications Approved")
                {
                    DrillDownPageID = "Training Applications";

                    ApplicationArea = All;
                }
                field("Training Evaluation Open"; Rec."Training Evaluation Open")
                {
                    DrillDownPageID = "Training Evaluation List";

                    ApplicationArea = All;
                }
                field("Training Evaluation Pending"; Rec."Training Evaluation Pending")
                {
                    DrillDownPageID = "Training Evaluation List";

                    ApplicationArea = All;
                }
                field("Training Evaluation Approved"; Rec."Training Evaluation Approved")
                {
                    DrillDownPageID = "Training Evaluation List";

                    ApplicationArea = All;
                }
            }
            cuegroup("HR Detail Update")
            {

            }
        }
    }

    actions
    {
    }
}

