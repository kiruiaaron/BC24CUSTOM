page 52223 "Payroll Rolecentre"
{
    Caption = 'Payroll Role Centre';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part(Control139; "HeadLine Rolecentre")
            {
                ApplicationArea = Basic, Suite;
            }
            part("Payroll Officer Activities"; "Payroll Officer Activities")
            {
                ApplicationArea = Basic, Suite;

            }
        }
    }

    actions
    {
        area(sections)
        {
            group("Payroll Employees")
            {
                Caption = 'Payroll Employees';
                action(Employees)
                {
                    Caption = 'Employees';
                    RunObject = Page "Payroll Employee List";
                }
                /*   action("Terminated Employees")
                  {
                      Caption = 'Terminated Employees';
                      RunObject = Page "Terminated Employee List";
                  } */
            }
            group("Payroll Processing")
            {
                Caption = 'Payroll Processing';
                action("Payroll Header List")
                {
                    Caption = 'Payroll Header List';
                    RunObject = Page "Payroll Header List";
                }
                action("Loans/Advances")
                {
                    Caption = 'Loans/Advances';
                    RunObject = Page "Loans/Advances";
                }
            }
            group("Salary Advance")
            {
                Caption = 'Salary Advance';
                Image = Receivables;
                action("Salary Advance Applications")
                {
                    Caption = 'Salary Advance Applications';
                    Promoted = false;
                    RunObject = Page "Salary Advance Applications";
                }
                action("Salary Advance Pending Approval")
                {
                    Caption = 'Salary Advance Pending Approval';
                    RunObject = Page "Salary Advance Pending Approvl";
                }
                action("Salary Advance Approved")
                {
                    Caption = 'Salary Advance Approved';
                    RunObject = Page "Salary Advance Approved";
                }
            }
            group("Employee Management")
            {
                Caption = 'Employee Management';
                action(Action62)
                {
                    Caption = 'Employees';
                    RunObject = Page "Payroll Employee List";
                }
                /* action("Inactive Employees")
                {
                    Caption = 'Inactive Employees';
                    RunObject = Page "Inactive Employees";
                } */
            }
        }
        area(processing)
        {
            group(Setups)
            {
                Caption = 'Setups';
                action(Payrolls)
                {
                    Caption = 'Payrolls';
                    Image = TaskList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page Payroll;
                }
                action("Payroll Year")
                {
                    Caption = 'Payroll Year';
                    Image = Period;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = Page "Payroll Year";
                }
                action("Payroll Definitions")
                {
                    Caption = 'Payroll Definitions';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = Page "ED Definitions";
                }
                action("Calculation Header")
                {
                    Caption = 'Calculation Header';
                    Image = CalculateCost;
                    Promoted = true;
                    RunObject = Page "Calculation Header";
                }
                action("Payroll Setups")
                {
                    Caption = 'Payroll Setups';
                    Image = Setup;
                    Promoted = true;
                    RunObject = Page "Payroll Setups";
                }
                action("Payroll Posting Setup")
                {
                    Caption = 'Payroll Posting Setup';
                    Image = CashFlowSetup;
                    Promoted = true;
                    RunObject = Page "Payroll Posting Setup";
                }
                action("Payroll Definition Posting Group")
                {
                    Caption = 'Payroll Definition Posting Group';
                    Image = Group;
                    Promoted = true;
                    RunObject = Page "ED Posting Group";
                }
                action("Payslip Group")
                {
                    Caption = 'Payslip Group';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = Page "Payslip Group";
                }
                action("Master Roll Group")
                {
                    Caption = 'Master Roll Group';
                    Image = SetupList;
                    Promoted = true;
                    RunObject = Page "Master Roll Group";
                }
                action("Loan types")
                {
                    Caption = 'Loan types';
                    Image = Category;
                    Promoted = true;
                    RunObject = Page "Loan types";
                }
                action("Mode of Payment")
                {
                    Caption = 'Mode of Payment';
                    Image = Category;
                    Promoted = true;
                    RunObject = Page "Mode of Payment";
                }
                action("Lookup Tables")
                {
                    Caption = 'Lookup Tables';
                    Image = "Table";
                    Promoted = true;
                    RunObject = Page "Lookup Table Header";
                }
                action("Allowed Payrolls")
                {
                    Caption = 'Allowed Payrolls';
                    Image = SetupColumns;
                    Promoted = true;
                    RunObject = Page "Allowed Payrolls";
                }
            }
            group("Periodic Activities")
            {
                Caption = 'Periodic Activities';
                action("General Journal")
                {
                    Caption = 'General Journal';
                    Image = GLJournal;
                    RunObject = Page "General Journal";
                }
                action("Open Period")
                {
                    Caption = 'Open Period';
                    Image = OpenJournal;
                    Promoted = false;
                    RunObject = Codeunit "Open Period";
                }
                action("Calculate All Payrolls")
                {
                    Caption = 'Calculate All Payrolls';
                    Image = Calculate;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit "Calculate All Payrolls";
                }
                action("Close Payroll & Generate Journal Entries")
                {
                    Caption = 'Close Payroll & Generate Journal Entries';
                    Image = Close;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit "Payroll Posting";
                }
                action("Generate & Email Payslips")
                {
                    Caption = 'Generate & Email Payslips';
                    Image = Email;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Report SendPayslips;
                }
                /*    action("Generate & Send  P9")
                   {
                       Caption = 'Generate & Send  P9';
                       Image = SendMail;
                       Promoted = true;
                       PromotedCategory = Process;
                       RunObject = Report "Send P9";
                   } */
            }
        }
        area(reporting)
        {
            group("Monthly General Reports")
            {
                Caption = 'Monthly General Reports';
                action("Master Roll Report")
                {
                    Caption = 'Master Roll Report';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Master Roll Report";
                }
                action("ED Totals Per Period")
                {
                    Caption = 'ED Totals Per Period';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "ED Totals Per Period";
                }
                action("Bank Payment List")
                {
                    Caption = 'Bank Payment List';
                    Image = Payment;
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Bank Payment List";
                }
                action("ED Report")
                {
                    Caption = 'ED Report';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "ED Report";
                }
                action("Company Payslip")
                {
                    Caption = 'Company Payslip';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Company Payslip";
                }
                action("Pension Report")
                {
                    Caption = 'Pension Report';
                    Image = Excel;
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Pension Report";
                }
                action("Payroll Reconciliation-All ED")
                {
                    Caption = 'Payroll Reconciliation-All ED';
                    Image = CompareCost;
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Payroll Reconciliation-All ED";
                }
                action("Payroll Reconciliation-Per ED")
                {
                    Caption = 'Payroll Reconciliation-Per ED';
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Payroll Reconciliation-Per ED";
                }
            }
            group("Monthly Statutory Reports")
            {
                Caption = 'Monthly Statutory Reports';
                action("NSSF Report")
                {
                    Caption = 'NSSF Report';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "NSSF Report";
                }
                action("NHIF Report")
                {
                    Caption = 'NHIF Report';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "NHIF Report";
                }
                action("PAYE Report")
                {
                    Caption = 'PAYE Report';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "PAYE Report1";
                }
            }
            group(Action47)
            {
                action("P9A Report")
                {
                    Caption = 'P9A Report';
                    Image = TaxDetail;
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "P9A Report";
                }
                action(P10A)
                {
                    Caption = 'P10A';
                    Image = TaxPayment;
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report P10A;
                }
                action(P10)
                {
                    Caption = 'P10';
                    Image = TaxDetail;
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report P10;
                }
                action(P10D)
                {
                    Caption = 'P10D';
                    Image = TaxDetail;
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report P10D;
                }
                action(Action52)
                {
                }
                action(Action53)
                {
                }
            }
        }
    }
}

