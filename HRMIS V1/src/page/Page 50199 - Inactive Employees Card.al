page 50199 "Inactive Employees Card"
{
    PageType = Card;
    SourceTable = Employee;
    SourceTableView = WHERE("Emplymt. Contract Code" = CONST('PERMANENT'),
                            Status = FILTER(<> Active));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the  Employee No.';
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        Rec.AssistEdit;
                    end;
                }
                field("First Name"; Rec."First Name")
                {
                    ToolTip = 'Specifies the  first Name.';
                    ApplicationArea = All;
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    ToolTip = 'Specifies the middle Name.';
                    ApplicationArea = All;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ToolTip = 'Specifies the last Name';
                    ApplicationArea = All;
                }
                field(Gender; Rec.Gender)
                {
                    ToolTip = 'Specifies the Gender';
                    ApplicationArea = All;
                }

                field("Marital Status-d"; Rec."Marital Status-d")
                {
                    ToolTip = 'Specifies the Marital Status';
                    ApplicationArea = All;
                }
                field("Person Living with Disability"; Rec."Person Living with Disability")
                {
                    ApplicationArea = All;
                }
                field(Citizenship; Rec.Citizenship)
                {
                    ApplicationArea = All;
                }
                field("Ethnic Group"; Rec."Ethnic Group")
                {
                    ApplicationArea = All;
                }
                field(Religion; Rec.Religion)
                {
                    ApplicationArea = All;
                }

                field("Job Title"; Rec."Job Title")
                {
                    ApplicationArea = All;
                }

                field("Supervisor Job No."; Rec."Supervisor Job No.")
                {
                    ApplicationArea = All;
                }
                field("Supervisor Job Title"; Rec."Supervisor Job Title")
                {
                    ApplicationArea = All;
                }
                field("Emplymt. Contract Code"; Rec."Emplymt. Contract Code")
                {
                    ApplicationArea = All;
                }
                field("On Probation"; Rec."On Probation")
                {
                    ApplicationArea = All;
                }
                field("HR Salary Notch"; Rec."HR Salary Notch")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies Global Dimension 1 Code.';
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Employment Years of Service"; Rec."Employement Years of Service")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the  Employee Status.';
                    ApplicationArea = All;
                }
                field("Cause of Inactivity Code"; Rec."Cause of Inactivity Code")
                {
                    Visible = CauseOfInactivityVisible;
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the  User ID that created the Employee Card.';
                    ApplicationArea = All;
                }
                field(AnnualLeaveBalance; AnnualLeaveBalance)
                {
                    Caption = 'AnnuaL Leave Balance';
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            group("Important Numbers")
            {
                field("National ID No.-d"; Rec."National ID No.-d")
                {
                    ToolTip = 'Specifies the  ID No.';
                    ApplicationArea = All;
                }
                field("Huduma No."; Rec."Huduma No.")
                {
                    ApplicationArea = All;
                }

                field("PIN No.-d"; Rec."PIN No.-d")
                {
                    ToolTip = 'Specifies the Pin No.';
                    ApplicationArea = All;
                }
                field("NSSF No.-d"; Rec."NSSF No.-d")
                {
                    ToolTip = 'Specifies the  NSSF No.';
                    ApplicationArea = All;
                }
                field("NHIF No.-d"; Rec."NHIF No.-d")
                {
                    ToolTip = 'Specifies the NHIF No.';
                    ApplicationArea = All;
                }
                field("Driving Licence No."; Rec."Driving Licence No.")
                {
                    ToolTip = 'Specifies the  Driving Licence No.';
                    ApplicationArea = All;
                }
            }
            group("Contact Information")
            {
                field("Phone No."; Rec."Phone No.")
                {
                    ToolTip = 'Specifies the  Phone No.';
                    ApplicationArea = All;
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    ToolTip = 'The Mobile Phone No';
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
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the  Address.';
                    ApplicationArea = All;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ToolTip = 'Specifies the Address 2.';
                    ApplicationArea = All;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ToolTip = 'Specifies the Post Code.';
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ToolTip = 'Specifies the  Country Region Code.';
                    ApplicationArea = All;
                }
                field("County Code"; Rec."County Code")
                {
                    ApplicationArea = All;
                }
                field("County Name"; Rec."County Name")
                {
                    ToolTip = 'Specifies the County Name.';
                    ApplicationArea = All;
                }
                field("SubCounty Code"; Rec."SubCounty Code")
                {
                    ToolTip = 'Specifies the  Subcounty Code.';
                    ApplicationArea = All;
                }
                field("SubCounty Name"; Rec."SubCounty Name")
                {
                    ToolTip = 'Specifies the  SubCounty Name.';
                    ApplicationArea = All;
                }
            }
            group("Bank Information")
            {

                field("Bank Name"; Rec."Bank Name")
                {
                    Editable = false;
                    ToolTip = 'Specifies the Bank Name.';
                    ApplicationArea = All;
                }

                field("Bank Branch Name"; Rec."Bank Branch Name")
                {
                    Caption = 'Bank Branch Name';
                    Editable = false;
                    ToolTip = 'Specifies Bank Branch Name.';
                    ApplicationArea = All;
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    Caption = 'Bank Account No.';
                    ToolTip = 'Specifies the Bank Account Number.';
                    ApplicationArea = All;
                }
            }
            group("Important Dates")
            {
                field("Employment Date"; Rec."Employment Date")
                {
                    ApplicationArea = All;
                }
                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                }
                field("Contract Period"; Rec."Contract Period")
                {
                    ApplicationArea = All;
                }
                field("Contract Expiry Date"; Rec."Contract Expiry Date")
                {
                    ApplicationArea = All;
                }
                field("Probation Start Date"; Rec."Probation Start Date")
                {
                    ApplicationArea = All;
                }
                field("Probation Period"; Rec."Probation Period")
                {
                    ApplicationArea = All;
                }
                field("Probation End date"; Rec."Probation End date")
                {
                    ApplicationArea = All;
                }
                field("Birth Date"; Rec."Birth Date")
                {
                    ToolTip = 'Specifies the  Birth date.';
                    ApplicationArea = All;
                }
                field("Driving License Expiry Date"; Rec."Driving License Expiry Date")
                {
                    ApplicationArea = All;
                }
            }
            group("Leave Details")
            {
                field("Leave Group"; Rec."Leave Group")
                {
                    ApplicationArea = All;
                }
                field("Leave Calendar"; Rec."Leave Calendar")
                {
                    ApplicationArea = All;
                }
                field("Leave Status"; Rec."Leave Status")
                {
                    ToolTip = 'Specifies the  leave Status.';
                    ApplicationArea = All;
                }
            }
            group(Posting)
            {
                field("Imprest Posting Group"; Rec."Imprest Posting Group")
                {
                    ToolTip = 'Specifies the  leave Status.';
                    ApplicationArea = All;
                }
                field("Employee Posting Group"; Rec."Employee Posting Group")
                {
                    ApplicationArea = All;
                }
            }
            group(Separation)
            {
                field("Termination Date"; Rec."Termination Date")
                {
                    Caption = 'Date of Separation';
                    ToolTip = 'Specifies the termination date.';
                    ApplicationArea = All;
                }
                field("Grounds for Term. Code"; Rec."Grounds for Term. Code")
                {
                    ApplicationArea = All;
                }
                field("Reason For Leaving (Other)"; Rec."Reason For Leaving (Other)")
                {
                    ApplicationArea = All;
                }
                field("Inactive Date"; Rec."Inactive Date")
                {
                    ApplicationArea = All;
                }
            }
            group("Web Portal")
            {
                field("Default Portal Password"; Rec."Default Portal Password")
                {
                    ToolTip = 'Specifies the  default Portal Password.';
                    ApplicationArea = All;
                }
                field("Portal Password"; Rec."Portal Password")
                {
                    ToolTip = 'Specifies the  Portal Password.';
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {

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
                ToolTip = 'Specifies the  Employees Relatives.';
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
                ToolTip = 'Specifies the Employee Next of Kin.';
                ApplicationArea = All;
            }
            action("Employee Referees")
            {
                Image = ResourceGroup;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                RunObject = Page "HR Employee Referees";
                RunPageLink = "Employee No." = field("No.");
                ApplicationArea = All;
                // "Employee No." = FIELD("No.");                ApplicationArea = All;

            }
            action("Employee Leave Type")
            {
                Image = Allocations;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunObject = Page 50232;
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
            action("Job Requirements")
            {
                Image = BusinessRelation;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "HR Job Requirements";
                RunPageLink = "Job No." = FIELD(Position);
                ToolTip = 'Specifies the Job General Requirements';
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
                RunPageLink = "Job No." = FIELD(Position);
                ToolTip = 'Specifies the Job Qualification Requirements';
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
                RunPageLink = "Job No." = FIELD(Position);
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
                ApplicationArea = All;
                //   RunObject = Page "Employee Qualifications";
                //  RunPageLink = "Employee No." = FIELD("No.");
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
            action("Confirm Employee")
            {
                Image = Confirm;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //Confirm verification of Employee Referees
                    HREmployeeRefereeDetails.RESET;
                    HREmployeeRefereeDetails.SETRANGE("Employee No.", Rec."No.");
                    IF HREmployeeRefereeDetails.FINDFIRST THEN
                        HREmployeeRefereeDetails.TESTFIELD(HREmployeeRefereeDetails.Verified, TRUE);

                    IF CONFIRM(Txt_001) = FALSE THEN EXIT;
                    Rec."On Probation" := FALSE;
                    REC.MODIFY;
                    MESSAGE(Txt_002);
                end;
            }
            action("Disciplinary Cases")
            {
                Caption = 'Disciplinary Cases';
                Image = DecreaseIndent;
                Promoted = true;
                PromotedCategory = Category8;
                PromotedIsBig = true;
                /*   RunObject = Page 50264;
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
                /*  RunObject = Page 50261;
                 RunPageLink = "No." = FIELD("No."); */
                ToolTip = 'Specifies the  Employee Training History.';
                ApplicationArea = All;
            }
            action("Print Letter of Appointment")
            {
                Caption = 'Print Letter of Appointment';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.SETRANGE("No.", Rec."No.");
                    // ReportSelections.Print(ReportSelections.Usage::"Letter of Appointment", Rec, 0);
                end;
            }
            action("Ledger E&ntries")
            {
                ApplicationArea = BasicHR;
                Caption = 'Ledger E&ntries';
                Image = VendorLedger;
                Promoted = true;
                PromotedCategory = Category5;
                RunObject = Page 5237;
                RunPageLink = "Employee No." = FIELD("No.");
                RunPageView = SORTING("Employee No.")
                              ORDER(Descending);
                ShortCutKey = 'Ctrl+F7';
                ToolTip = 'View the history of transactions that have been posted for the selected record.';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        "`": Integer;
    begin
        //Calculate Leave Balance
        CLEAR(AnnualLeaveBalance);
        LeaveTypes.RESET;
        LeaveTypes.SETRANGE("Annual Leave", TRUE);
        IF LeaveTypes.FINDFIRST THEN
            AnnualLeaveCode := LeaveTypes.Code;

        LeavePeriods.RESET;
        LeavePeriods.SETRANGE(Closed, TRUE);
        IF LeavePeriods.FINDFIRST THEN
            LeaveYear := LeavePeriods."Leave Year";

        CurrentYear := DATE2DMY(TODAY, 3);
        LeaveLedgerEntries.RESET;
        LeaveLedgerEntries.SETRANGE(LeaveLedgerEntries."Employee No.", Rec."No.");
        LeaveLedgerEntries.SETRANGE(LeaveLedgerEntries."Leave Type", AnnualLeaveCode);
        LeaveLedgerEntries.SETRANGE("Leave Year", LeaveYear);
        LeaveLedgerEntries.CALCSUMS(LeaveLedgerEntries.Days);
        AnnualLeaveBalance := LeaveLedgerEntries.Days;

        //Calculate Age
        IF Rec."Employment Date" <> 0D THEN
            Rec."Employement Years of Service" := Dates.DetermineAge_Years(Rec."Employment Date", TODAY);
    end;

    var
        AnnualLeaveBalance: Decimal;
        CurrentYear: Integer;
        CauseOfInactivityVisible: Boolean;
        Dates: Codeunit 50043;
        Employee: Record 5200;
        EmployeeNo: Code[10];
        HREmployeeRefereeDetails: Record 50113;
        Txt_001: Label 'Are you sure you want to Confirm Employee?';
        Txt_002: Label 'Employee %1 has been confirmed.';
        ReportSelections: Record 77;
        LeaveLedgerEntries: Record 50132;
        LeaveTypes: Record 50134;
        LeavePeriods: Record 50135;
        LeaveYear: Integer;
        AnnualLeaveCode: Code[20];
}

