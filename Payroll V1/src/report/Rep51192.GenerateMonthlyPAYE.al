report 51192 "Generate Monthly PAYE"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Payroll Header"; 51159)
        {
            DataItemTableView = SORTING("Payroll ID", "Employee No.");
            RequestFilterFields = "Payroll ID";

            trigger OnAfterGetRecord()
            var
                lvEmployee: Record 5200;
                lvPayrollLines: Record 51160;
                lvInsuranceAmt: Decimal;
                lvRentRecoveryAmt: Decimal;
                EmployeeHousing: Integer;
            begin
                lvEmployee.GET("Payroll Header"."Employee no.");
                lvRentRecoveryAmt := 0;
                lvInsuranceAmt := 0;
                //PayrollSetup.TESTFIELD("Insurance Relief ED");
                //cmm 120813 Calculate insurance and rent recovery amt
                lvPayrollLines.RESET;
                lvPayrollLines.SETCURRENTKEY("Payroll ID", "Employee No.", "ED Code", "Posting Date");
                lvPayrollLines.SETRANGE("Payroll ID", "Payroll Header"."Payroll ID");
                lvPayrollLines.SETRANGE("Employee No.", "Payroll Header"."Employee no.");
                lvPayrollLines.SETFILTER("ED Code", PayrollSetup."Insurance Relief ED");
                lvPayrollLines.CALCSUMS("Amount (LCY)");
                lvInsuranceAmt := ABS(lvPayrollLines."Amount (LCY)");

                IF PayrollSetup."Rent Recovery ED" <> '' THEN BEGIN
                    lvPayrollLines.RESET;
                    lvPayrollLines.SETCURRENTKEY("Payroll ID", "Employee No.", "ED Code", "Posting Date");
                    lvPayrollLines.SETRANGE("Payroll ID", "Payroll Header"."Payroll ID");
                    lvPayrollLines.SETRANGE("Employee No.", "Payroll Header"."Employee no.");
                    lvPayrollLines.SETFILTER("ED Code", PayrollSetup."Rent Recovery ED");
                    lvPayrollLines.CALCSUMS("Amount (LCY)");
                    lvRentRecoveryAmt := ABS(lvPayrollLines."Amount (LCY)");
                END;
                //end cmm
                EmployeeHousing := lvEmployee."Housing For Employee";
                gvTempExcelBuffer.NewRow;
                gvTempExcelBuffer.AddColumn(lvEmployee.PIN, FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Text);
                gvTempExcelBuffer.AddColumn(UPPERCASE(lvEmployee.FullName), FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Text);
                gvTempExcelBuffer.AddColumn("Payroll Header"."A (LCY)", FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Number);
                gvTempExcelBuffer.AddColumn("Payroll Header"."B (LCY)", FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Number);
                gvTempExcelBuffer.AddColumn(EmployeeHousing, FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Number);
                gvTempExcelBuffer.AddColumn(lvEmployee."Value of Quarters", FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Number);
                gvTempExcelBuffer.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Number);
                gvTempExcelBuffer.AddColumn(lvRentRecoveryAmt, FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Number);
                gvTempExcelBuffer.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Number);
                gvTempExcelBuffer.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Number);
                gvTempExcelBuffer.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Number);
                gvTempExcelBuffer.AddColumn("Payroll Header"."E2 (LCY)", FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Number);
                gvTempExcelBuffer.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Number);
                gvTempExcelBuffer.AddColumn("Payroll Header"."F (LCY)", FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Number);
                gvTempExcelBuffer.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Number);
                gvTempExcelBuffer.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Number);
                gvTempExcelBuffer.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Number);
                gvTempExcelBuffer.AddColumn("Payroll Header"."K (LCY)", FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Number);
                gvTempExcelBuffer.AddColumn(lvInsuranceAmt, FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Number);
                gvTempExcelBuffer.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Number);
            end;

            trigger OnPostDataItem()
            begin
                //     gvTempExcelBuffer.C(STRSUBSTNO('PAYE- %1', "Payroll Header"."Payroll ID"), "Payroll Header"."Payroll ID");
                gvTempExcelBuffer.WriteSheet("Payroll Header"."Payroll Code", COMPANYNAME, USERID);
                gvTempExcelBuffer.CloseBook;
                gvTempExcelBuffer.OpenExcel;
                //gvTempExcelBuffer.UpdateBookStream;
            end;

            trigger OnPreDataItem()
            begin
                IF "Payroll Header".GETFILTER("Payroll Header"."Payroll ID") = '' THEN
                    ERROR('You must specify Payroll ID filter');
                gsSegmentPayrollData;
                PayrollSetup.GET(gvAllowedPayrolls."Payroll Code");
                "Payroll Header".SETRANGE("Payroll Header"."Payroll Code", gvAllowedPayrolls."Payroll Code");
                gvTempExcelBuffer.AddColumn('Employee''s PIN', FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Text);
                gvTempExcelBuffer.AddColumn('Employee''s NAME', FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Text);
                gvTempExcelBuffer.AddColumn('Cash pay Kshs', FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Text);
                gvTempExcelBuffer.AddColumn('Benefits Non cash Kshs', FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Text);
                gvTempExcelBuffer.AddColumn(Text0001, FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Text);
                gvTempExcelBuffer.AddColumn('Value of Quarters Kshs', FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Text);
                gvTempExcelBuffer.AddColumn('Computed value of Quarters', FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Text);
                gvTempExcelBuffer.AddColumn('Rent Recovered from Employee', FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Text);
                gvTempExcelBuffer.AddColumn('Net Value Of Housing', FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Text);
                gvTempExcelBuffer.AddColumn('Total Gross pay C+D+E Kshs', FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Text);
                gvTempExcelBuffer.AddColumn('Defined Contribution Benefit Calculation Kshs 30%OF C', FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Text);
                gvTempExcelBuffer.AddColumn('Defined Contribution Benefit Calculation Kshs Actual Cont', FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Text);
                gvTempExcelBuffer.AddColumn('Defined Contribution Benefit Calculation Kshs Legal Limit', FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Text);
                gvTempExcelBuffer.AddColumn('Owner Occupied Interest or HOSP Kshs', FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Text);
                gvTempExcelBuffer.AddColumn('Defined Contribution & owner occupier Interest or HOSP Kshs', FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Text);
                gvTempExcelBuffer.AddColumn('Chargeable pay (F-H) Kshs', FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Text);
                gvTempExcelBuffer.AddColumn('Tax Charged Kshs', FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Text);
                gvTempExcelBuffer.AddColumn('Monthly Relief + Insurance Relief Kshs', FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Text);
                gvTempExcelBuffer.AddColumn('Insurance Relief', FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Text);
                gvTempExcelBuffer.AddColumn('P.A.Y.E TAX Kshs', FALSE, '', FALSE, FALSE, FALSE, '', gvTempExcelBuffer."Cell Type"::Text);
            end;
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
        Text0001: Label 'Housing 0-Not housed 1-Employer owned house 2-Employer rented house or 3-Agricultural farm';
        gvTempExcelBuffer: Record 370 temporary;
        gvAllowedPayrolls: Record 51182;
        PayrollSetup: Record 51165;

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

