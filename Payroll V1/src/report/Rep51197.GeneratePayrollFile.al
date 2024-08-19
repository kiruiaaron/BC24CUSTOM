report 51197 "Generate Payroll File"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Payroll Header"; 51159)
        {
            RequestFilterFields = "Payroll ID";

            trigger OnAfterGetRecord()
            begin

                Employee.GET("Payroll Header"."Employee no.");
                ExcelBuffer.NewRow;
                "Payroll Header".CALCFIELDS("Payroll Header"."Total Payable (LCY)", "Payroll Header"."Total Deduction (LCY)");
                Netpay := FORMAT("Payroll Header"."Total Payable (LCY)" - "Payroll Header"."Total Deduction (LCY)");

                Periods.RESET;
                Periods.SETRANGE("Period ID", "Payroll Header"."Payroll ID");
                IF Periods.FINDFIRST THEN;
                ExcelBuffer.AddColumn(Employee."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Employee."Full Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Employee."Bank Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Employee."Bank Account No", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Netpay, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('corporate salary transfer ', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('01136087648600', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Periods.Description + ' Salary', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('KES', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('BEN', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
            end;

            trigger OnPostDataItem()
            begin


                "Payroll Header".CALCFIELDS("Payroll Header"."Total Payable (LCY)", "Payroll Header"."Total Deduction (LCY)");
            end;

            trigger OnPreDataItem()
            begin
                IF "Payroll Header".GETFILTER("Payroll Header"."Payroll ID") = '' THEN
                    ERROR('Please input payroll filter');
                SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
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
        gsSegmentPayrollData;
    end;

    trigger OnPostReport()
    begin
        CreateExcelWorkbook
    end;

    trigger OnPreReport()
    begin
        MakeExcelheader
    end;

    var
        ExcelBuffer: Record 370 temporary;
        i: Integer;
        Filename: Text;
        SheetName: Text;
        ReportHeader: Text;
        Company: Text;
        user: Text;
        Window: Dialog;
        Employee: Record 5200;
        Netpay: Text;
        Periods: Record 51151;
        gvAllowedPayrolls: Record 51182;

    local procedure MakeExcelheader()
    begin
        ExcelBuffer.AddColumn('REF', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('NAME', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Bankcode', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Account', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Amount', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('PAYMENT METHOD ', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('DR ACCOUNT', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('SWIFT', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('DETAILS', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('CURRENCY', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('DATE', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('CHARGE BY', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('DEAL NO', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
    end;

    local procedure CreateExcelWorkbook()
    begin

        //  Filename := TEMPORARYPATH + '\NAKSWTBULK.xlsx';
        SheetName := 'CB201610';
        ReportHeader := '';
        Company := '';
        user := '';
        //  ExcelBuffer.CreateBook(Filename, SheetName, '', '', '');
    end;

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

