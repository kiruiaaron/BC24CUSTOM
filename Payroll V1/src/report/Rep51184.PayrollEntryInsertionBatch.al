report 51184 "Payroll Entry Insertion Batch"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee; 5200)
        {
            DataItemTableView = SORTING("No.");

            trigger OnAfterGetRecord()
            begin
                gvPayrollHdr.GET(gvPeriodID, "No."); //Ensure payroll header exists

                //Check that ED is not already inserted
                gvPayrollEntry.SETCURRENTKEY("Payroll ID", "Employee No.", "ED Code");
                gvPayrollEntry.SETRANGE("Payroll ID", gvPeriodID);
                gvPayrollEntry.SETRANGE("Employee No.", "No.");
                gvPayrollEntry.SETRANGE("ED Code", gvEDCode);
                IF gvPayrollEntry.FINDFIRST THEN CurrReport.SKIP;

                gvPayrollEntry.RESET;
                gvPayrollEntry.INIT;
                gvLastEntryNo += 10;
                gvPayrollEntry."Entry No." := gvLastEntryNo;
                gvPayrollEntry."Payroll ID" := gvPeriodID;
                gvPayrollEntry."Employee No." := "No.";
                gvPayrollEntry.VALIDATE("ED Code", gvEDCode);
                gvPayrollEntry.Date := gvPeriod."Start Date";
                gvPayrollEntry.INSERT(TRUE);
            end;

            trigger OnPreDataItem()
            begin
                SETFILTER("No.", gvEmpNos);
                SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");

                gvPayrollEntry.SETRANGE("ED Code", gvEDCode);
                IF gvPayrollEntry.FINDLAST THEN gvLastEntryNo := gvPayrollEntry."Entry No.";

                gvPeriod.SETRANGE("Period ID", gvPeriodID);
                gvPeriod.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                gvPeriod.FINDFIRST;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Group)
                {
                    field(gvPeriodID; gvPeriodID)
                    {
                        Caption = 'Insert Into Period';
                        TableRelation = Periods."Period ID" WHERE(Status = CONST(Open));
                        ApplicationArea = All;
                    }
                    field(gvEmpNos; gvEmpNos)
                    {
                        Caption = 'For Employees';
                        TableRelation = Employee."No." WHERE(Status = CONST(Active));
                        ApplicationArea = All;
                    }
                    field(gvEDCode; gvEDCode)
                    {
                        Caption = 'ED Code';
                        TableRelation = "ED Definitions"."ED Code" WHERE("System Created" = CONST(False));
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        gsSegmentPayrollData;
        IF (gvPeriodID = '') OR (gvEmpNos = '') OR (gvEDCode = '') THEN
            ERROR('All options on the request form must be filled in.')
    end;

    var
        gvPeriodID: Code[10];
        gvEmpNos: Code[20];
        gvEDCode: Code[20];
        gvPayrollEntry: Record 51161;
        gvPayrollHdr: Record 51159;
        gvAllowedPayrolls: Record 51182;
        gvLastEntryNo: Integer;
        gvPeriod: Record 51151;

    procedure gsSegmentPayrollData()
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


        gvAllowedPayrolls.SETRANGE("User ID", lvActiveSession."User ID");
        gvAllowedPayrolls.SETRANGE("Last Active Payroll", TRUE);
        IF NOT gvAllowedPayrolls.FINDFIRST THEN
            ERROR('You are not allowed access to this payroll dataset.');
    end;
}

