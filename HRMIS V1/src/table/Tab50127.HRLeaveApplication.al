/// <summary>
/// Table HR Leave Application (ID 50127).
/// </summary>
table 50127 "HR Leave Application"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Employee No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                Employee.RESET;
                Employee.SETRANGE(Employee."No.", "Employee No.");
                IF Employee.FINDFIRST THEN BEGIN
                    "Employee Name" := Employee."Last Name" + ' ' + Employee."First Name" + ' ' + Employee."Middle Name";
                    "Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
                    Employee.TESTFIELD(Employee."Emplymt. Contract Code");
                    "Emplymt. Contract Code" := Employee."Emplymt. Contract Code";
                    "Leave Group" := Employee."Leave Group";


                    HRLeavePeriod.RESET;
                    HRLeavePeriod.SETRANGE(HRLeavePeriod.Closed, FALSE);
                    IF HRLeavePeriod.FINDFIRST THEN BEGIN
                        "Leave Period" := HRLeavePeriod.Code;
                    END;

                END ELSE BEGIN
                    "Leave Group" := '';
                    "Employee Name" := '';
                    "Emplymt. Contract Code" := '';
                    "Leave Type" := '';
                    "Leave Period" := '';
                END;

                //check for two leave type the same period
                /*HRLeaveApplication.RESET;
                HRLeaveApplication.SETRANGE("Employee No.","Employee No.");
                HRLeaveApplication.SETRANGE(Status,TRUE);
                IF HRLeaveApplication.FINDLAST THEN BEGIN
                  IF HRLeaveApplication."Leave Return Date" > TODAY THEN
                  ERROR(Text_003);;
                END;
                */

            end;
        }
        field(5; "Employee Name"; Text[150])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Leave Type"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Leave Types".Code;

            trigger OnValidate()
            begin
                TESTFIELD("Employee No.");
                Employee.RESET;
                Employee.GET("Employee No.");
                Employee.TESTFIELD("Leave Calendar");
                HRLeaveType.RESET;
                IF HRLeaveType.GET("Leave Type") THEN BEGIN
                    //Check Leave Planner
                    TESTFIELD("Leave Period");
                    IF HRLeaveType."Leave Plan Mandatory" THEN BEGIN
                        HRLeavePlanner.RESET;
                        HRLeavePlanner.SETRANGE(HRLeavePlanner."Employee No.", "Employee No.");
                        HRLeavePlanner.SETRANGE(HRLeavePlanner."Leave Period", "Leave Period");
                        HRLeavePlanner.SETRANGE(HRLeavePlanner."Leave Type", "Leave Type");
                        HRLeavePlanner.SETRANGE(HRLeavePlanner.Status, HRLeavePlanner.Status::Released);
                        IF NOT HRLeavePlanner.FINDFIRST THEN BEGIN
                            ERROR(LeavePlannerMandatory, "Leave Type", "Employee No.", "Leave Period", "Leave Type");
                        END;
                    END;
                END;
                //End Check Leave Planner

                //Calculate Leave Balance
                LeavePeriods.RESET;
                LeavePeriods.SETRANGE(Closed, FALSE);
                IF LeavePeriods.FINDFIRST THEN
                    LeavePeriod := LeavePeriods.Code;

                LeaveLedgerEntries.RESET;
                LeaveLedgerEntries.SETRANGE(LeaveLedgerEntries."Employee No.", "Employee No.");
                LeaveLedgerEntries.SETRANGE(LeaveLedgerEntries."Leave Type", "Leave Type");
                LeaveLedgerEntries.SETRANGE("Leave Period", LeavePeriod);
                LeaveLedgerEntries.CALCSUMS(LeaveLedgerEntries.Days);
                "Leave Balance" := LeaveLedgerEntries.Days;

            end;
        }
        field(7; "Leave Period"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Leave Periods".Code WHERE(Closed = CONST(false));
        }
        field(8; "Leave Balance"; Decimal)
        {
            Caption = 'Leave Balance from Days Allocated';
            Editable = false;
        }
        field(9; "Leave Start Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD("Employee No.");
                TESTFIELD("Leave Type");
                IF "Leave Start Date" < TODAY THEN BEGIN
                    ERROR(LeaveStartDateEarlierthanCurrentDate, TODAY);
                END;
                "Days Applied" := 0;
                VALIDATE("Days Applied");

            end;
        }
        field(10; "Days Applied"; Integer)
        {
            DataClassification = ToBeClassified;
            MinValue = 0;

            trigger OnValidate()
            begin
                //TESTFIELD("Substitute No.");

                IF "Days Applied" > "Leave Balance" THEN
                    ERROR(Text_001);

                "Days Approved" := "Days Applied";
                VALIDATE("Days Approved");
            end;
        }
        field(11; "Days Approved"; Integer)
        {
            DataClassification = ToBeClassified;
            MinValue = 0;

            trigger OnValidate()
            begin
                "Leave End Date" := 0D;
                "Leave Return Date" := 0D;

                Employee.GET("Employee No.");
                BaseCalendarCode := Employee."Leave Calendar";
                IF "Days Approved" <> 0 THEN BEGIN
                    "Leave End Date" := HRLeaveManagement.CalculateLeaveEndDate("Leave Type", "Leave Period", "Leave Start Date", "Days Approved", BaseCalendarCode);
                    "Leave Return Date" := HRLeaveManagement.CalculateLeaveReturnDate("Leave Type", "Leave Period", "Leave End Date", BaseCalendarCode);
                END;


                //ERROR(text1234,FORMAT("Days Applied"));

                /*HRLeaveType.RESET;
                HRLeaveType.SETRANGE(Code,"Leave Type");
                HRLeaveType.SETRANGE("Take as Block",TRUE);
                IF HRLeaveType.FINDFIRST THEN BEGIN
                  IF HRLeaveType.Days <> "Days Applied" THEN
                    ERROR(text1234,FORMAT("Days Applied"));
                   // ERROR(Text_004);
                END;
                */

            end;
        }
        field(12; "Leave End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(13; "Leave Return Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "Substitute No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                "Substitute Name" := '';

                Employee.RESET;
                IF Employee.GET("Substitute No.") THEN BEGIN
                    "Substitute Name" := Employee."Last Name" + ' ' + Employee."First Name" + ' ' + Employee."Middle Name";
                END;

                HRLeaveApplication.RESET;
                HRLeaveApplication.SETRANGE("Employee No.", "Substitute No.");
                HRLeaveApplication.SETRANGE(Posted, TRUE);
                IF HRLeaveApplication.FINDLAST THEN BEGIN
                    IF HRLeaveApplication."Leave Return Date" > TODAY THEN
                        ERROR(Text_002);
                    ;
                END;

            end;
        }
        field(15; "Substitute Name"; Text[150])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(20; "Leave Group"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Leave Groups".Code;
        }
        field(49; "Reason for Leave"; Text[250])
        {
            Caption = 'Employee Comments';
            DataClassification = ToBeClassified;
        }
        field(50; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(51; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(52; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(53; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(54; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(55; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(56; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(57; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(58; "Responsibility Center"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center".Code;
        }
        field(70; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Pending Approval,Approved,Rejected,Posted';
            OptionMembers = Open,"Pending Approval",Released,Rejected,Posted;
        }
        field(71; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(72; "Posted By"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup"."User ID";
        }
        field(73; "Date Posted"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(74; "Time Posted"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(99; "User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "User Setup"."User ID";

            trigger OnValidate()
            var
                HRLeavePlanner: Record "HR Leave Planner Header";
            begin
                Employee.RESET;
                Employee.SETRANGE(Employee."User ID", "User ID");
                IF Employee.FINDFIRST THEN BEGIN
                    "Employee No." := Employee."No.";
                    "Employee Name" := Employee."Last Name" + ' ' + Employee."Middle Name" + ' ' + Employee."First Name";
                    "Emplymt. Contract Code" := Employee."Emplymt. Contract Code";
                END;
            end;
        }
        field(100; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(102; "Incoming Document Entry No."; Integer)
        {
            Caption = 'Incoming Document Entry No.';
            DataClassification = ToBeClassified;
        }
        field(103; "Emplymt. Contract Code"; Code[10])
        {
            Caption = 'Emplymt. Contract Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Employment Contract".Code;
        }
        field(104; "Approved By Name"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(105; "Request Leave Allowance"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(106; "Leave Allowance Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(107; "Details of Examination"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(108; "Date of Exam"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(109; "Supervisor Name"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(110; "E-mail Address"; Text[30])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
        field(111; "Cell Phone Number"; Text[30])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = PhoneNo;
        }
        field(112; "Cumm. Allocated Leave Days"; Decimal)
        {
            /*  FieldClass = FlowField; 
              CalcFormula = Sum("HR Leave Ledger Entries".Days WHERE(Employee."No."=FIELD("Employee No."),
                                                                      "Leave Allocation"=CONST(false),
                                                                      "Leave Period"=FIELD("Leave Period")));
*/
        }
        field(113; "Allocated Days"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("HR Leave Ledger Entries".Days WHERE("Leave Type" = FIELD("Leave Type"),
                                                                                "Employee No." = FIELD("Employee No."),
                                                                                "Leave Allocation" = CONST(true),
                                                                                "Leave Period" = FIELD("Leave Period")));

        }
        field(114; "Leave Days Taken"; Decimal)
        {
            /*   FieldClass = FlowField; 
              CalcFormula = Sum("HR Leave Ledger Entries".Days WHERE ("Leave Type"=FIELD("Leave Type"),
                                                                        "Employee No.""=FIELD("Employee No."),
                                                                        "Leave Allocation"=CONST(true),
                                                                        "Leave Period"=FIELD("Leave Period"),
                                                                        "Entry Type"=FILTER("Negative Adjustment")));
*/
        }
        field(115; "Leave Year"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(116; "Leave Carry Over"; Decimal)
        {
            CalcFormula = Sum("HR Leave Ledger Entries".Days WHERE("Leave Type" = FIELD("Leave Type"),
                                                                                "Employee No." = FIELD("Employee No."),
                                                                                "Leave Allocation" = CONST(false),
                                                                                "Leave Period" = FIELD("Leave Period"),
                                                                                "Entry Type" = FILTER("Carry forward")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Leave Application Nos.");
            //NoSeriesMgt.InitSeries(HRSetup."Leave Application Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;
        "Document Date" := TODAY;
        "User ID" := USERID;
        VALIDATE("User ID");
    end;

    var
        HRSetup: Record 5218;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Employee: Record 5200;
        HRLeaveManagement: Codeunit 50036;
        HRLeavePeriod: Record 50135;
        LeaveStartDateEarlierthanCurrentDate: Label 'The Leave Start Date cannot be earlier than %1';
        ConfirmDaysAppliedMoreThanLeaveBalance: Label 'The Days Applied:%1 are more than the Leave Balance:%2. The Extra %3  Leave Days will be treated as UnPaid Days. Continue?';
        HRLeaveType: Record 50134;
        HRLeavePlanner: Record 50125;
        LeavePlannerMandatory: Label 'Leave Plan is mandatory for Leave Type:%1. Leave Plan is missing for Employee No.:%2  Leave Period:%3 Leave Type:%4';
        BaseCalendarCode: Code[10];
        Text_001: Label 'Leave days applied exceed your current Leave Balance. Please adjust the Leave days you are Applying to proceed';
        AnnualLeaveBalance: Decimal;
        LeaveLedgerEntries: Record 50132;
        LeaveTypes: Record 50134;
        LeavePeriods: Record 50135;
        LeaveYear: Integer;
        AnnualLeaveCode: Code[20];
        CurrentYear: Integer;
        LeaveBalance: Decimal;
        LeavePeriod: Code[20];
        HRLeaveApplication: Record 50127;
        Text_002: Label 'You cannot select substitute approver who is on leave';
        Text_003: Label 'You cannot apply for another leave before another one ends';
        Text_004: Label 'Days applied must be same as the allocated days';
        EmployeeLeaveType: Record 50133;
        text1234: Label 'hapa are %1';
}

