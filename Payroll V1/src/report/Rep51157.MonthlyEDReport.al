report 51157 "Monthly ED Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/Monthly ED Report.rdlc';

    dataset
    {
        dataitem("Payroll Lines"; 51160)
        {
            DataItemTableView = SORTING("Payroll ID", "Global Dimension 1 Code", "Global Dimension 2 Code")
                                ORDER(Ascending);
            column(USERID; USERID)
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(TitleText; TitleText)
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(Employee_No__; 'Employee No.')
            {
            }
            column(Employee_Name_; 'Employee Name')
            {
            }
            column(Payroll_Lines__Amount__LCY__; "Amount (LCY)")
            {
            }
            column(gvBranch; gvBranch)
            {
            }
            column(gvDepartment; gvDepartment)
            {
            }
            column(Payroll_Lines__Employee_No__; "Employee No.")
            {
            }
            column(Payroll_Lines__Amount__LCY___Control11; "Amount (LCY)")
            {
            }
            column(Name; Name)
            {
            }
            column(Payroll_Lines_Quantity; Quantity)
            {
            }
            column(Payroll_Lines_Rate; Rate)
            {
            }
            column(NationalID; NationalID)
            {
            }
            column(Payroll_Lines__Amount__LCY___Control1000000007; "Amount (LCY)")
            {
            }
            column(Payroll_Lines__Amount__LCY___Control31; "Amount (LCY)")
            {
            }
            column(TotalAmount; TotalAmount)
            {
            }
            column(Totalhours; Totalhours)
            {
            }
            column(EmpCount; EmpCount)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(QtyCaption; QtyCaptionLbl)
            {
            }
            column(RateCaption; RateCaptionLbl)
            {
            }
            column(Amount__LCY_Caption; Amount__LCY_CaptionLbl)
            {
            }
            column(ID_No_Caption; ID_No_CaptionLbl)
            {
            }
            column(Payroll_Lines__Amount__LCY__Caption; Payroll_Lines__Amount__LCY__CaptionLbl)
            {
            }
            column(Payroll_Lines__Amount__LCY___Control31Caption; Payroll_Lines__Amount__LCY___Control31CaptionLbl)
            {
            }
            column(TotalAmountCaption; TotalAmountCaptionLbl)
            {
            }
            column(EmpCountCaption; EmpCountCaptionLbl)
            {
            }
            column(Payroll_Lines_Entry_No_; "Entry No.")
            {
            }
            column(Payroll_Lines_Global_Dimension_1_Code; "Global Dimension 1 Code")
            {
            }
            column(Payroll_Lines_Global_Dimension_2_Code; "Global Dimension 2 Code")
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF PrevEmpID = "Employee No." THEN CurrReport.SKIP;//SNG 080611 To stop employee details from being fetched more than once

                TotalAmount += "Amount (LCY)";
                Totalhours += Quantity;
                EmpCount += 1;

                Employee.GET("Employee No.");
                NationalID := Employee."National ID";
                Name := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";

                PrevEmpID := "Employee No.";
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE("Payroll ID", PeriodCode);
                SETRANGE("ED Code", EDCode);
                SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                CurrReport.CREATETOTALS(Quantity, "Amount (LCY)");
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

    trigger OnInitReport()
    begin

        IF NOT ISSERVICETIER THEN BEGIN
            IF ACTION::LookupOK = PAGE.RUNMODAL(PAGE::"Period Look Up", Period) THEN
                PeriodCode := Period."Period ID"
            ELSE
                ERROR('No period was selected');

            IF ACTION::LookupOK = PAGE.RUNMODAL(PAGE::"ED Definitions", EDDef) THEN
                EDCode := EDDef."ED Code"
            ELSE
                ERROR('No E/D was selected');
        END;

        IF ISSERVICETIER THEN BEGIN
            IF ACTION::LookupOK = PAGE.RUNMODAL(PAGE::"Period Look Up", Period) THEN
                PeriodCode := Period."Period ID"
            ELSE
                ERROR('No period was selected');

            IF ACTION::LookupOK = PAGE.RUNMODAL(PAGE::"ED Definitions", EDDef) THEN
                EDCode := EDDef."ED Code"
            ELSE
                ERROR('No E/D was selected');
        END;

        TitleText := EDDef.Description + ' List for ' + Period.Description;
    end;

    trigger OnPreReport()
    begin
        gsSegmentPayrollData;
        EmpCount := 0;
    end;

    var
        Employee: Record 5200;
        Period: Record 51151;
        EDDef: Record 51158;
        TestCalc: Codeunit 51152;
        Name: Text[250];
        TitleText: Text[100];
        EDCode: Code[20];
        PeriodCode: Code[10];
        TotalAmount: Decimal;
        Totalhours: Decimal;
        EmpCount: Integer;
        NationalID: Code[10];
        gvAllowedPayrolls: Record 51182;
        gvBranch: Text[30];
        gvDepartment: Text[30];
        gvDimValues: Record 349;
        PrevEmpID: Code[20];
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        QtyCaptionLbl: Label 'Qty';
        RateCaptionLbl: Label 'Rate';
        Amount__LCY_CaptionLbl: Label 'Amount (LCY)';
        ID_No_CaptionLbl: Label 'ID No.';
        Payroll_Lines__Amount__LCY__CaptionLbl: Label 'Continued...';
        Payroll_Lines__Amount__LCY___Control31CaptionLbl: Label 'Continued...';
        TotalAmountCaptionLbl: Label 'Total Amount LCY';
        EmpCountCaptionLbl: Label 'No. of Employees';
        EmployeeName: Text[250];

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

