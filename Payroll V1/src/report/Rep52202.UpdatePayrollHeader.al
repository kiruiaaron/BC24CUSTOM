report 52202 "Update Payroll Header"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/Update Payroll Header.rdlc';

    dataset
    {
        dataitem(Employee; 5200)
        {
            DataItemTableView = WHERE("Payroll Code" = CONST('MCL2'));
            dataitem("Payroll Header"; 51159)
            {
                DataItemLink = "Employee No." = FIELD("No.");

                trigger OnAfterGetRecord()
                begin
                    "Payroll Header"."Payroll Code" := Employee."Payroll Code";
                    "Payroll Header".MODIFY;
                end;

                trigger OnPreDataItem()
                begin
                    /*
                    lvActiveSession.RESET;
                    lvActiveSession.SETRANGE("Server Instance ID",SERVICEINSTANCEID);
                    lvActiveSession.SETRANGE("Session ID",SESSIONID);
                    lvActiveSession.FINDFIRST;
                    
                    
                    lvAllowedPayrolls.SETRANGE("User ID", lvActiveSession."User ID");
                    lvAllowedPayrolls.SETRANGE("Last Active Payroll", TRUE);
                    IF lvAllowedPayrolls.FINDFIRST THEN
                     Rec. SETRANGE("Payroll Code", lvAllowedPayrolls."Payroll Code")
                    ELSE
                      ERROR('You are not allowed access to this payroll dataset.');
                    Rec.FILTERGROUP(100);
                    */

                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        lvAllowedPayrolls: Record 51182;
        lvPayrollUtilities: Codeunit 51152;
        UsrID: Code[10];
        UsrID2: Code[10];
        StringLen: Integer;
        lvActiveSession: Record 2000000110;
}

