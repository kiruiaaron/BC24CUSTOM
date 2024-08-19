page 50201 "Inactive Employees-Other Card"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = 5200;
    SourceTableView = WHERE(Age = FILTER(<> 0),
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

                field(Title; Rec.Title)
                {
                    Editable = false;
                    ToolTip = 'Specifies the  Job Title.';
                    ApplicationArea = All;
                }

                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies Global Dimension 1 Code.';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = All;
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the  Employee Status.';
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
                field(County; Rec.County)
                {
                    ToolTip = 'Specifies the County Code.';
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
                    ToolTip = 'Specifies the  Employement Date.';
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
                field("Reason For Leaving"; Rec."Reason For Leaving")
                {
                    ApplicationArea = All;
                }
                field("Reason For Leaving (Other)"; Rec."Reason For Leaving (Other)")
                {
                    ApplicationArea = All;
                }
                field("Grounds for Term. Code"; Rec."Grounds for Term. Code")
                {
                    ToolTip = 'Specifies the Grounds for Term Code.';
                    Visible = false;
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
                /*  RunObject = Page 50261;
                 RunPageLink = "No." = FIELD("No."); */
                ToolTip = 'Specifies the  Employee Training History.';
                ApplicationArea = All;
            }
        }
    }

    var
        AnnualLeaveBalance: Decimal;
        CurrentYear: Integer;
}

