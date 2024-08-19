page 50153 "Human Resource Profile"
{
    Caption = 'Human Resource Management', Comment = '{Dependency=Match,"ProfileDescription_SHOPSUPERVISOR-FOUNDATION"}';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {


        }
    }

    actions
    {
        area(reporting)
        {
            action("Human Resource Establishment Report")
            {
                ApplicationArea = Manufacturing;
                Caption = 'Human Resource Establishment Report';
                Image = "Report";

                //RunObject = Report 50071;
                ToolTip = 'View Job Positions in the Organization. The report also shows information about Job establishment/positions in the organization.';
            }
        }
        area(embedding)
        {
            action("HR Jobs List")
            {
                Caption = 'HR Jobs List';
                Image = Job;
                RunObject = Page 50154;
                ToolTip = 'Shows HR Job List';
                ApplicationArea = All;
            }
            action("Approved HR Jobs List")
            {
                Image = Job;
                RunObject = Page 50156;
                ApplicationArea = All;
            }
            action("HR Job Grades List")
            {
                Image = GanttChart;
                RunObject = Page 50162;
                ApplicationArea = All;
            }
            action("HR Job Values List")
            {
                Image = GanttChart;
                RunObject = Page 50161;
                ApplicationArea = All;
            }
        }
        area(sections)
        {
            group("HR Jobs Management")
            {
                Caption = 'HR Jobs Management';
                Image = Administration;
                action("Human Resource Jobs List")
                {
                    Caption = 'HR Jobs List';
                    Image = Job;
                    RunObject = Page 50154;
                    ToolTip = 'Shows HR Job List';
                    ApplicationArea = All;
                }
                action("Approved Human Resource Jobs")
                {
                    Image = Job;
                    RunObject = Page 50156;
                    ApplicationArea = All;
                }
                action("Human Resorce Job Grades List")
                {
                    Image = GanttChart;
                    RunObject = Page 50162;
                    ApplicationArea = All;
                }
                action("Human Resource Job Values List")
                {
                    Image = GanttChart;
                    RunObject = Page 50161;
                    ApplicationArea = All;
                }
            }
            group("HR Recruitment Management")
            {
                Caption = 'HR Recruitment Management';
                Image = ProductDesign;
                action("Employee Requisitions")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Employee Requisitions List';
                    Image = ConsumptionJournal;
                    RunObject = Page 50163;
                    ToolTip = 'Employee Requisitions List.';
                }
                action("HR Job Applications List")
                {
                    Caption = 'HR Job Applications List';
                    RunObject = Page 50167;
                    ToolTip = 'HR Job Applications List';
                    ApplicationArea = All;
                }
                action("HR Shortlisted Job Applicants")
                {
                    Caption = 'HR Shortlisted Job Applicants List';
                    RunObject = Page 50177;
                    ToolTip = 'HR Shortlisted Job Applicants List';
                    ApplicationArea = All;
                }
                action("Dept Interview Panel List")
                {
                    Caption = 'Dept Interview Panel List';
                    RunObject = Page 50179;
                    ToolTip = 'Department Interview Panel List';
                    ApplicationArea = All;
                }
                action("Interview Panel List")
                {
                    Caption = 'Interview Panel List';
                    RunObject = Page 50182;
                    ToolTip = 'Interview Panel List';
                    ApplicationArea = All;
                }
                action("Closed Employee Requisitions List")
                {
                    Caption = 'Closed Employee Requisitions List';
                    RunObject = Page 50165;
                    ToolTip = 'Closed Employee Requisitions List';
                    ApplicationArea = All;
                }
                action(" Closed Job Applications List")
                {
                    Caption = 'Closed Job Applications List';
                    RunObject = Page 50169;
                    ToolTip = 'Closed Job Applications List';
                    ApplicationArea = All;
                }
            }
            group("Employee Management")
            {
                Caption = 'Employee Management';
                Image = HumanResources;
                action("HR Employees Permanent List")
                {
                    Caption = 'Human Resource Employees Permanent List';
                    RunObject = Page 50186;
                    ToolTip = 'HR Employees Permanent List';
                    ApplicationArea = All;
                }

                action(" Inactive Employees")
                {
                    Caption = 'Human Resource In-Active Permanent Employees List';
                    RunObject = Page 50198;
                    ApplicationArea = All;
                }
                action("In-Active Employees other")
                {
                    Caption = 'Human Resource In-Active Employees other';
                    RunObject = Page 50200;
                    ApplicationArea = All;
                }
            }
            group("Leave Management")
            {
                Caption = 'Leave Management';
                Image = ExecuteBatch;
                action("Leave Planner List")
                {
                    Caption = 'Human Resource Leave Planner List';
                    RunObject = Page 50205;
                    ToolTip = 'Human Resource Leave Planner List';
                    ApplicationArea = All;
                }
                action("Approved Leave Planner List")
                {
                    Caption = 'Human Resource Approved Leave Planner List';
                    RunObject = Page 50208;
                    ToolTip = 'Human Resource Approved Leave Planner List';
                    ApplicationArea = All;
                }
                action(" Leave Applications")
                {
                    Caption = 'Human Resource Leave Applications List';
                    RunObject = Page 50210;
                    ToolTip = 'Human Resource Leave Applications List';
                    ApplicationArea = All;
                }
                action("Released Leave Applications")
                {
                    Caption = 'Human Resource Approved Leave Applications List';
                    RunObject = Page 50212;
                    ToolTip = 'Human Resource Approved Leave Applications List';
                    ApplicationArea = All;
                }
                action("Posted Leave Applications List")
                {
                    Caption = 'Human Resource Posted Leave Applications List';
                    RunObject = Page 50213;
                    ToolTip = 'Human Resource Posted Leave Applications List';
                    ApplicationArea = All;
                }
                action("Leave Reimbursements List")
                {
                    Caption = 'Human Resource Leave Reimbursements List';
                    RunObject = Page 50215;
                    ToolTip = 'Human Resource Leave Reimbursements List';
                    ApplicationArea = All;
                }
                action("Posted Leave Reimbursements List")
                {
                    Caption = 'Human Posted Leave Reimbursements List';
                    RunObject = Page 50217;
                    ToolTip = 'Human Posted Leave Reimbursements List';
                    ApplicationArea = All;
                }
                action(" Leave Carryovers List")
                {
                    Caption = 'Human Resource Leave Carryover List';
                    RunObject = Page 50219;
                    ToolTip = 'Human Resource Leave Carryover List';
                    ApplicationArea = All;
                }
                action("Posted Leave Carryovers List")
                {
                    Caption = 'Human Resource Posted Leave Carryovers List';
                    RunObject = Page 50221;
                    ToolTip = 'Human Resource Posted Leave Carryovers List';
                    ApplicationArea = All;
                }
                action("Leave Allocations List")
                {
                    Caption = 'Human Resource Leave Allocations List';
                    RunObject = Page 50223;
                    ToolTip = 'Human Resource Leave Allocations List';
                    ApplicationArea = All;
                }
                action("Posted Leave Allocations List")
                {
                    Caption = 'Human Resource Posted Leave Allocations List';
                    RunObject = Page 50226;
                    ToolTip = 'Human Resource Posted Leave Allocations List';
                    ApplicationArea = All;
                }
                action("Leave Types List")
                {
                    Caption = 'Human Resource Leave Types List ';
                    RunObject = Page 50229;
                    ToolTip = 'Human Resource Leave Types List ';
                    ApplicationArea = All;
                }
                action("Leave Periods List")
                {
                    Caption = 'Human Resource Leave Periods List ';
                    RunObject = Page 50231;
                    ToolTip = 'Human Resource Leave Periods List ';
                    ApplicationArea = All;
                }

            }
            group("Training Management")
            {
                Caption = 'Training Management';
                Image = LotInfo;
                action("HR Training Needs List")
                {
                    Caption = 'Human Resource Training Needs List';
                    RunObject = Page 50250;
                    ToolTip = 'Human Resource Training Needs List';
                    ApplicationArea = All;
                }
                action("Proposed Training Needs List")
                {
                    Caption = 'Human Resource Proposed Training Needs List';
                    RunObject = Page 50253;
                    ToolTip = 'Human Resource Proposed Training Needs List';
                    ApplicationArea = All;
                }
                action("HR Approved Training Need List")
                {
                    Caption = 'Human Resorce Approved Training Need List';
                    RunObject = Page 50255;
                    ToolTip = 'Human Resorce Approved Training Need List';
                    ApplicationArea = All;
                }
                action("HR Training Groups List")
                {
                    Caption = 'Human Resorce Training Groups List';
                    RunObject = Page 50258;
                    ToolTip = 'Human Resorce Training Groups List';
                    ApplicationArea = All;
                }
                action("HR Training Applications List")
                {
                    Caption = 'Human Resource Training Applications List';
                    RunObject = Page 50261;
                    ToolTip = 'Human Resource Training Applications List';
                    ApplicationArea = All;
                }
                action("HR Training Evaluation List")
                {
                    Caption = 'Human Resorce Training Evaluation List';
                    RunObject = Page 50267;
                    ToolTip = 'Human Resorce Training Evaluation List';
                    ApplicationArea = All;
                }
            }
            group("Employee Disciplinary Management")
            {
                Caption = 'Employee Disciplinary Management';
                Image = LotInfo;
                action("HR Employee Disciplinary Cases List")
                {
                    Caption = 'Human Resource Disciplinary Cases List';
                    RunObject = Page 50264;
                    ToolTip = 'Human Resource Disciplinary Cases List';
                    ApplicationArea = All;
                }
                action("HR Closed Disciplinary Cases List")
                {
                    Caption = 'Human Resource Closed Disciplinary Cases List';
                    RunObject = Page 50266;
                    ToolTip = 'Human Resource Closed Disciplinary Cases List';
                    ApplicationArea = All;
                }
            }
            group("Employee Payroll Management")
            {
                Caption = 'Employee Payroll Management';
                Image = LotInfo;
            }
            group("Self-Service")
            {
                Caption = 'Self-Service';
                Image = HumanResources;
                ToolTip = 'Manage your time sheets and assignments.';
                /*   action("Purchase Requisition")
                  {
                      RunObject = Page 50082;
                      ApplicationArea = All;
                  } */
                /*   action("Store Requisition")
                  {
                      RunObject = Page 50114;
                      ApplicationArea = All;
                  }
   */
                action("Leave Application")
                {
                    RunObject = Page 50210;
                    ApplicationArea = All;
                }
                action("Leave Reimbursement")
                {
                    RunObject = Page 50215;
                    ApplicationArea = All;
                }
                /*     action("Imprest Request")
                    {
                        RunObject = Page 50022;
                        ApplicationArea = All;
                    } 
                    action("Imprest Surrender")
                    {
                        RunObject = Page 50027;
                        ApplicationArea = All;
                    }
                    action("Fund Claims")
                    {
                        RunObject = Page 50032;
                        ApplicationArea = All;
                    }
                    */
                action("Performance Appraisal")
                {
                    ApplicationArea = All;
                    //      RunObject = Page 50233;
                }
                action("Training Application")
                {
                    RunObject = Page 50261;
                    ApplicationArea = All;
                }
            }
            group(Approvals)
            {
                Caption = 'Approvals';
                Image = Alerts;
                action("Requests To Approve")
                {
                    RunObject = Page 654;
                    ApplicationArea = All;
                }
                action("My Approval Requests")
                {
                    RunObject = Page 662;
                    ApplicationArea = All;
                }


            }
            group("Human Resource Setup")
            {
                Caption = 'Human Resource Setup';
                Image = LotInfo;
                action("HR Employment Contracts")
                {
                    Caption = 'Human Resource Employment Contracts';
                    RunObject = Page 5217;
                    ToolTip = 'Human Resource Employment Contracts';
                    ApplicationArea = All;
                }
                action("HR Employee Department List")
                {
                    Caption = 'Human Resource Employee Department List';
                    RunObject = Page 50202;
                    ToolTip = 'Human Resource Employee Department List';
                    ApplicationArea = All;
                }
                action("HR Lookup Values")
                {
                    Caption = 'Human Resource Lookup Values';
                    RunObject = Page 50185;
                    ApplicationArea = All;
                }
                action("HR Employee Location List")
                {
                    Caption = 'Human Resource Employee Location List';
                    RunObject = Page 50203;
                    ToolTip = 'Human Resource Employee Location List';
                    ApplicationArea = All;
                }
                action("County List")
                {
                    Caption = 'County List';
                    RunObject = Page 50280;
                    ToolTip = 'County List';
                    ApplicationArea = All;
                }
                action("SubCounty List")
                {
                    Caption = 'SubCounty List';
                    RunObject = Page 50281;
                    ToolTip = 'SubCounty List';
                    ApplicationArea = All;
                }
            }
        }
        area(creation)
        {
            action("Page Human Resources Setup")
            {
                Caption = 'Human Resources General Setup';
                Image = "Order";

                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page 5233;
                RunPageMode = Create;
                ToolTip = 'Human Resources General Setup';
                ApplicationArea = All;
            }

            action("Page HR Medical Cover Setup")
            {
                Caption = 'Human Resources Medical Cover Setup';
                Image = "Order";

                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page 50272;
                RunPageMode = Create;
                ToolTip = 'Human Resources Medical Cover Setup';
                ApplicationArea = All;
            }
        }
    }
}

