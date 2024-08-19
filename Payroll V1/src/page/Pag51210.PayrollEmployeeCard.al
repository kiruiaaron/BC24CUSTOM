page 51210 "Payroll Employee Card"
{
    Caption = 'Employee Card';
    PageType = Card;
    SourceTable = 5200;
    SourceTableView = SORTING("No.")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    Importance = Promoted;
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        IF Rec.AssistEdit() THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Job Title"; Rec."Job Title")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("First Name"; Rec."First Name")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    Caption = 'Second Name';
                    ApplicationArea = All;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = All;
                }
                field(Address; Rec.Address)
                {
                    Caption = 'Postal Address';
                    ApplicationArea = All;
                }
                field("Address 2"; Rec."Address 2")
                {
                    Caption = 'Physical Address';
                    ApplicationArea = All;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = All;
                }
                field("Payroll Code"; Rec."Payroll Code")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Calculation Scheme"; Rec."Calculation Scheme")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("Employee Type"; Rec."Employee Type")
                {
                    ApplicationArea = All;
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("Phone No.2"; Rec."Phone No.")
                {
                    ApplicationArea = All;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("Company E-Mail"; Rec."Company E-Mail")
                {
                    ApplicationArea = All;
                }
            }
            group(Administration)
            {
                Caption = 'Administration';
                field("Employment Date"; Rec."Employment Date")
                {
                    Importance = Promoted;
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("Emplymt. Contract Code"; Rec."Emplymt. Contract Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
                field("Inactive Date"; Rec."Inactive Date")
                {
                    ApplicationArea = All;
                }
                field("Cause of Inactivity Code"; Rec."Cause of Inactivity Code")
                {
                    ApplicationArea = All;
                }
                field("Termination Date"; Rec."Termination Date")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        // GetDurations;
                    end;
                }
                field("Grounds for Term. Code"; Rec."Grounds for Term. Code")
                {
                    ApplicationArea = All;
                }
            }
            group(Personal)
            {
                Caption = 'Personal';
                field("Birth Date"; Rec."Birth Date")
                {
                    Importance = Promoted;
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        /*GetDurations;
                        GetServiceDurations;*/

                    end;
                }
                field(Age; Rec.Age)
                {
                    ApplicationArea = All;
                }
                field(Service; Rec.Service)
                {
                    ApplicationArea = All;
                }
                field("Active Service Years"; Rec."Active Service Years")
                {
                    ApplicationArea = All;
                }
            }
            group(Payroll)
            {
                Caption = 'Payroll';
                Visible = true;
                field("Salary Scale"; Rec."Salary Scale")
                {
                    ApplicationArea = All;
                }
                field("Scale Step"; Rec."Scale Step")
                {
                    ApplicationArea = All;
                }
                field("Posting Group"; Rec."Posting Group")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field(PIN; Rec.PIN)
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("National ID"; Rec."National ID")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("NSSF No."; Rec."NSSF No.")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("NHIF No."; Rec."NHIF No.")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Mode of Payment"; Rec."Mode of Payment")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Bank Account No"; Rec."Bank Account No")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Basic Pay"; Rec."Basic Pay")
                {
                    ApplicationArea = All;
                }
                field("Fixed Pay"; Rec."Fixed Pay")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Laptrust No"; Rec."Laptrust No")
                {
                    ApplicationArea = All;
                }
                field(Sanlam; Rec.Sanlam)
                {
                    ApplicationArea = All;
                }
                field(Liberty; Rec.Liberty)
                {
                    ApplicationArea = All;
                }
                field(HELB; Rec.HELB)
                {
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
        area(navigation)
        {
            group("E&mployee")
            {
                Caption = 'E&mployee';
                Image = Employee;
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Human Resource Comment Sheet";
                    RunPageLink = "Table Name" = CONST(Employee),
                                  "No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(5200),
                                  "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    ApplicationArea = All;
                }
                action("&Picture")
                {
                    Caption = '&Picture';
                    Image = Picture;
                    RunObject = Page "Employee Picture";
                    RunPageLink = "No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("&Alternative Addresses")
                {
                    Caption = '&Alternative Addresses';
                    Image = Addresses;
                    RunObject = Page "Alternative Address List";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("&Relatives")
                {
                    Caption = '&Relatives';
                    Image = Relatives;
                    RunObject = Page "Employee Relatives";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Mi&sc. Article Information")
                {
                    Caption = 'Mi&sc. Article Information';
                    Image = Filed;
                    RunObject = Page "Misc. Article Information";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("&Confidential Information")
                {
                    Caption = '&Confidential Information';
                    Image = Lock;
                    RunObject = Page "Confidential Information";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = All;
                }

                action("A&bsences")
                {
                    Caption = 'A&bsences';
                    Image = Absence;
                    RunObject = Page "Employee Absences";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = All;
                }
                separator(sep3)
                {
                }
                action("Absences by Ca&tegories")
                {
                    Caption = 'Absences by Ca&tegories';
                    Image = AbsenceCategory;
                    RunObject = Page "Empl. Absences by Categories";
                    RunPageLink = "No." = FIELD("No."),
                                  "Employee No. Filter" = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Misc. Articles &Overview")
                {
                    Caption = 'Misc. Articles &Overview';
                    Image = FiledOverview;
                    RunObject = Page "Misc. Articles Overview";
                    ApplicationArea = All;
                }
                action("Co&nfidential Info. Overview")
                {
                    Caption = 'Co&nfidential Info. Overview';
                    Image = ConfidentialOverview;
                    RunObject = Page "Confidential Info. Overview";
                    ApplicationArea = All;
                }
                separator(sep1)
                {
                }
                action("Online Map")
                {
                    Caption = 'Online Map';
                    Image = Map;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.DisplayMap;
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        MapPointVisible := TRUE;
    end;

    trigger OnOpenPage()
    var
        MapMgt: Codeunit 802;
    begin
        gsSegmentPayrollData;

        IF NOT MapMgt.TestSetup THEN
            MapPointVisible := FALSE;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        /*IF "Phone No." = ''
        THEN
        ERROR('Please insert a value into the Phone No. field');//Mesh
        IF "Employment Date" = 0D
        THEN
        ERROR('Please insert a value into the Employment Date field');//Mesh
        
        IF "NSSF No." = ''
        THEN
        ERROR('Please insert a value into the NSSF No field');//Mesh
        
        IF "NHIF No." = ''
        THEN
        ERROR('Please insert a value into the NHIF No. field');//Mesh
        
        IF "National ID" = ''
        THEN
        ERROR('Please insert a value into the National ID field');//Mesh
        
        IF PIN = ''
        THEN
        ERROR('Please insert a value into the KRA PIN No field');//Mesh
        
        IF "Mode of Payment" = ''
        THEN
        ERROR('Please insert a value into the Mode of Payment field');*///Mesh

    end;

    var
        [InDataSet]
        MapPointVisible: Boolean;

    local procedure gsSegmentPayrollData()
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
            Rec.SETRANGE("Payroll Code", lvAllowedPayrolls."Payroll Code")
        ELSE
            ERROR('You are not allowed access to this payroll dataset.');
        Rec.FILTERGROUP(100);
    end;
}

