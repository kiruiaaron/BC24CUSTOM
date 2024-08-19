page 50186 Employees
{
    CardPageID = "Employees Card";
    DeleteAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 5200;
    SourceTableView = WHERE(Status = CONST(Active));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the  Employee Number.';
                    ApplicationArea = All;
                }
                field("First Name"; Rec."First Name")
                {
                    ToolTip = 'Specifies First Name';
                    ApplicationArea = All;
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    ToolTip = 'Specifies the Middle Name.';
                    ApplicationArea = All;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ToolTip = 'Specifies last Name';
                    ApplicationArea = All;
                }
                field(Gender; Rec.Gender)
                {
                    ToolTip = 'Specifies the  Gender.';
                    ApplicationArea = All;
                }
                field(Title; Rec.Title)
                {
                    ToolTip = 'Specifies the Job Title';
                    ApplicationArea = All;
                }

                field("HR Salary Notch"; Rec."HR Salary Notch")
                {
                    ApplicationArea = All;
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    ToolTip = 'Specifies Mobile Phone Number.';
                    ApplicationArea = All;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                }
                field("Company E-Mail"; Rec."Company E-Mail")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("National ID No.-d"; Rec."National ID No.-d")
                {
                    ToolTip = 'Specifies the National ID No.';
                    ApplicationArea = All;
                }
                field("PIN No.-d"; Rec."PIN No.-d")
                {
                    ToolTip = 'Specifies the  PIN No.';
                    ApplicationArea = All;
                }
                field("NSSF No.-d"; Rec."NSSF No.-d")
                {
                    ToolTip = 'Specifies the  NSSF No.';
                    ApplicationArea = All;
                }
                field("NHIF No.-d"; Rec."NHIF No.-d")
                {
                    ToolTip = 'Specifies the  NHIF No.';
                    ApplicationArea = All;
                }
                field("Emplymt. Contract Code"; Rec."Emplymt. Contract Code")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the  Employee status.';
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the  User ID that Created the Card';
                    ApplicationArea = All;
                }
                field("On Probation"; Rec."On Probation")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part(sbpg1; 5202)
            {
                ApplicationArea = BasicHR;
                SubPageLink = "No." = FIELD("No.");
            }

            systempart(Links; Links)
            {
                Visible = false;
                ApplicationArea = All;
            }
            systempart(Notes; Notes)
            {
                Visible = true;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Employee Relative")
            {
                Caption = 'Employee Family Details';
                Image = Relatives;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                RunObject = Page "HR Employee Relatives";
                RunPageLink = "Employee No." = FIELD("No."),
                              Type = CONST(Relative);
                ToolTip = 'Specifies Employee Relative.';
                ApplicationArea = All;
            }
            action("Employee Next of Kin")
            {
                Image = Relatives;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                RunObject = Page "HR Employee Next of Kin";
                RunPageLink = "Employee No." = FIELD("No."),
                              Type = CONST("Next Of Kin");
                ToolTip = 'Specifies Employee Next of Kin.';
                ApplicationArea = All;
            }
            action("Employee Beneficiary")
            {
                Image = Relatives;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                RunObject = Page 50570;
                RunPageLink = "Employee No." = FIELD("No."),
                              Type = CONST(Beneficiary);
                ToolTip = 'Specifies Employee Next of Kin.';
                ApplicationArea = All;
            }
            action("Employee Referees")
            {
                Image = ResourceGroup;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                RunObject = Page 50191;
                RunPageLink = "Employee No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("Employee Leave Type")
            {
                Image = Allocations;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunObject = Page "Employee Leave Type";
                RunPageLink = "Employee No." = FIELD("No.");
                ToolTip = 'Specifies the Leave Type.';
                ApplicationArea = All;
            }
            action("Employee Leave Ledger")
            {
                Image = ItemLedger;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunObject = Page 50228;
                RunPageLink = "Employee No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("Job Qualifications")
            {
                Caption = 'Job Qualifications';
                Image = BulletList;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "HR Job Qualifications";

                ToolTip = 'Specifies the Job Qualification Requirements';
                ApplicationArea = All;
            }
            action("Job Requirements")
            {
                Image = BusinessRelation;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "HR Job Requirements";

                ToolTip = 'Specifies the Job General Requirements';
                ApplicationArea = All;
            }
            action("Job Responsibilities")
            {
                Caption = 'Job Responsibilities';
                Image = ResourceSkills;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page 50160;

                ToolTip = 'Specifies the Job Responsibilities';
                ApplicationArea = All;
            }
            action("Salary Notch")
            {
                Image = JobLedger;
                Promoted = true;
                PromotedCategory = Category9;
                PromotedIsBig = true;
                RunObject = Page 50161;
                RunPageLink = Option = CONST("Job Grade Level");
                ApplicationArea = All;
            }
            action("Employee Qualifications")
            {
                Image = BulletList;
                Promoted = true;
                PromotedCategory = Category7;
                PromotedIsBig = true;
                RunObject = Page "Employee Qualifications";
                RunPageLink = "Employee No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("Employee Professional Bodies")
            {
                Image = PostedReceivableVoucher;
                Promoted = true;
                PromotedCategory = Category7;
                PromotedIsBig = true;
                RunObject = Page 50192;
                RunPageLink = "Employee No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("Employee Employement Hist.")
            {
                Caption = 'Employee Employement History';
                Image = InteractionLog;
                Promoted = true;
                PromotedCategory = Category7;
                PromotedIsBig = true;
                RunObject = Page 50193;
                RunPageLink = "Employee No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("Disciplinary Cases")
            {
                Caption = 'Disciplinary Cases';
                Image = DecreaseIndent;
                Promoted = true;
                PromotedCategory = Category8;
                PromotedIsBig = true;
                /*    RunObject = Page 50264;
                   RunPageLink = "Employee No" = FIELD("No."); */
                ApplicationArea = All;
            }
            action("Employee Detail History")
            {
                Image = History;
                Promoted = true;
                PromotedCategory = Category8;
                PromotedIsBig = true;
                RunObject = Page 50196;
                RunPageLink = "Employee No." = FIELD("No.");
                ToolTip = 'Specifies the  Employee Deatil History.';
                ApplicationArea = All;
            }
            action("Employee Training History")
            {
                Image = History;
                Promoted = true;
                PromotedCategory = Category8;
                PromotedIsBig = true;
                /* RunObject = Page 50261;
                RunPageLink = "No." = FIELD("No."); */
                ToolTip = 'Specifies the  Employee Training History.';
                ApplicationArea = All;
            }
        }
    }

    trigger OnOpenPage()
    begin
        //   gsSegmentPayrollData;
    end;

    /* local procedure gsSegmentPayrollData()
    var
        lvAllowedPayrolls: Record 51182;
        lvPayrollUtilities: Codeunit 51152;
        UsrID: Code[10];
        UsrID2: Code[10];
        StringLen: Integer;
        lvActiveSession: Record 2000000110;
    begin
        lvActiveSession.RESET;
        lvActiveSession.SETRANGE("Server Instance ID", SERVICEINSTANCEID);
        lvActiveSession.SETRANGE("Session ID", SESSIONID);
        lvActiveSession.FINDFIRST;


        lvAllowedPayrolls.SETRANGE("User ID", lvActiveSession."User ID");
        lvAllowedPayrolls.SETRANGE("Last Active Payroll", TRUE);
        IF lvAllowedPayrolls.FINDFIRST THEN
            SETRANGE("Payroll Code", lvAllowedPayrolls."Payroll Code")
        ELSE
            ERROR('You are not allowed access to this payroll dataset.');
        FILTERGROUP(100);
    end; */
}

