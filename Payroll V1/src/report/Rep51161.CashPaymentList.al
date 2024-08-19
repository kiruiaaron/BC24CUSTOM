report 51161 "Cash Payment List"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/Cash Payment List.rdlc';

    dataset
    {
        dataitem(Periods; 51151)
        {
            DataItemTableView = SORTING("Start Date")
                                WHERE(Status = FILTER(Open | Posted));
            RequestFilterFields = "Period ID";
            column(TitleText; TitleText)
            {
            }
            column(Periods_Status; Status)
            {
            }
            column(Period_Status_Caption; Period_Status_CaptionLbl)
            {
            }
            column(Periods_Period_ID; "Period ID")
            {
            }
            column(Periods_Period_Month; "Period Month")
            {
            }
            column(Periods_Period_Year; "Period Year")
            {
            }
            column(Periods_Payroll_Code; "Payroll Code")
            {
            }
            dataitem(Employee; 5200)
            {
                CalcFields = Amount;
                DataItemTableView = SORTING("Mode of Payment")
                                    ORDER(Ascending);
                PrintOnlyIfDetail = false;
                RequestFilterFields = "Mode of Payment";
                column(CurrReport_PAGENO; CurrReport.PAGENO)
                {
                }
                column(Employee_Paystation; Paystation)
                {
                }
                column(Employee__No__; "No.")
                {
                }
                column(Employee_Name; Name)
                {
                }
                column(Employee_Amount; Amount)
                {
                }
                column(SHS10002; SHS10002)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS5002; SHS5002)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS2002; SHS2002)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS1002; SHS1002)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS502; SHS502)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS202; SHS202)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS102; SHS102)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS52; SHS52)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS12; SHS12)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS052; SHS052)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS012; SHS012)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(Employee_Amount_Control1101951018; Amount)
                {
                }
                column(Total_for_____FORMAT__EmpCount_____________Employees_; 'Total for : ' + FORMAT(EmpCount) + ' ' + ' Employees')
                {
                }
                column(SHS012_Control1101951017; SHS012)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS10002_Control1101951019; SHS10002)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS5002_Control1101951020; SHS5002)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS2002_Control1101951021; SHS2002)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS1002_Control1101951022; SHS1002)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS502_Control1101951023; SHS502)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS202_Control1101951024; SHS202)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS102_Control1101951025; SHS102)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS52_Control1101951026; SHS52)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS12_Control1101951027; SHS12)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS052_Control1101951028; SHS052)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(Employee_Amount_Control1101951004; Amount)
                {
                }
                column(Total_for_____FORMAT__EmpCount________Paystation_____Employees_; 'Total for : ' + FORMAT(EmpCount) + ' ' + Paystation + ' Employees')
                {
                }
                column(SHS012_Control1101951029; SHS012)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS10002_Control1101951030; SHS10002)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS5002_Control1101951031; SHS5002)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS2002_Control1101951032; SHS2002)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS1002_Control1101951033; SHS1002)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS502_Control1101951034; SHS502)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS202_Control1101951035; SHS202)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS102_Control1101951036; SHS102)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS52_Control1101951037; SHS52)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS12_Control1101951038; SHS12)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS052_Control1101951039; SHS052)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(Employee_Amount_Control16; Amount)
                {
                }
                column(SHS012_Control1101951040; SHS012)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS10002_Control1101951041; SHS10002)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS5002_Control1101951042; SHS5002)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS2002_Control1101951043; SHS2002)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS1002_Control1101951044; SHS1002)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS502_Control1101951045; SHS502)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS202_Control1101951046; SHS202)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS102_Control1101951047; SHS102)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS52_Control1101951048; SHS52)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS12_Control1101951049; SHS12)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SHS052_Control1101951050; SHS052)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(Grand_Total_for_____FORMAT_EmpCount______Employees_; 'Grand Total for : ' + FORMAT(EmpCount) + ' Employees')
                {
                }
                column(Employee_NameCaption; Employee_NameCaptionLbl)
                {
                }
                column(Employee_AmountCaption; Employee_AmountCaptionLbl)
                {
                }
                column(Employee__No__Caption; FIELDCAPTION("No."))
                {
                }
                column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                {
                }
                column(SignatureCaption; SignatureCaptionLbl)
                {
                }
                column(SHS_1000Caption; SHS_1000CaptionLbl)
                {
                }
                column(SHS_500Caption; SHS_500CaptionLbl)
                {
                }
                column(SHS_200Caption; SHS_200CaptionLbl)
                {
                }
                column(SHS_100Caption; SHS_100CaptionLbl)
                {
                }
                column(SHS_50Caption; SHS_50CaptionLbl)
                {
                }
                column(SHS_20Caption; SHS_20CaptionLbl)
                {
                }
                column(SHS_10Caption; SHS_10CaptionLbl)
                {
                }
                column(SHS_5Caption; SHS_5CaptionLbl)
                {
                }
                column(SHS_1Caption; SHS_1CaptionLbl)
                {
                }
                column(V50_CENTSCaption; V50_CENTSCaptionLbl)
                {
                }
                column(V10_CENTSCaption; V10_CENTSCaptionLbl)
                {
                }
                column(EmptyStringCaption; EmptyStringCaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Name := Employee.FullName;

                    IF Header.GET(Periods."Period ID", Employee."No.") THEN BEGIN
                        Header.CALCFIELDS("Total Payable (LCY)", "Total Deduction (LCY)", "Total Rounding Pmts (LCY)", "Total Rounding Ded (LCY)");
                        Amount := Header."Total Payable (LCY)" + Header."Total Rounding Pmts (LCY)" - (Header."Total Deduction (LCY)" +
                          Header."Total Rounding Ded (LCY)");
                        TotalAmount := TotalAmount + Amount;

                        IF Amount > 0 THEN
                            CountCoin(Amount)
                        ELSE
                            CurrReport.SKIP
                    END ELSE
                        CurrReport.SKIP;

                    EmpCount := EmpCount + 1;
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                    SETRANGE(Employee."Mode of Payment", ModeOfPayment);
                    CurrReport.CREATETOTALS(Amount, SHS10002, SHS5002, SHS2002, SHS1002, SHS502, SHS202, SHS102, SHS52, SHS12);
                    CurrReport.CREATETOTALS(SHS052, SHS012, EmpCount);
                    EmpCount := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                TotalAmount := 0;
                TitleText := 'Cash Payment List for ' + Periods.Description;
            end;

            trigger OnPreDataItem()
            begin
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
        //SNG 080611 Enable user to dynamicaly select the Mode of Payment
        MESSAGE('Select The Cash Payment Option');
        IF ACTION::LookupOK = PAGE.RUNMODAL(PAGE::"Mode of Payment", gvPayment) THEN
            ModeOfPayment := gvPayment.Code
        ELSE
            ERROR('Please Select a mode of payment');
    end;

    trigger OnPreReport()
    begin
        gsSegmentPayrollData
    end;

    var
        Header: Record 51159;
        Name: Text[60];
        Amount: Decimal;
        TotalAmount: Decimal;
        TitleText: Text[90];
        SHS10002: Decimal;
        SHS5002: Decimal;
        SHS2002: Decimal;
        SHS1002: Decimal;
        SHS502: Decimal;
        SHS202: Decimal;
        SHS102: Decimal;
        SHS52: Decimal;
        SHS12: Decimal;
        SHS052: Decimal;
        SHS012: Decimal;
        SHS1000: Decimal;
        SHS500: Decimal;
        SHS200: Decimal;
        SHS100: Decimal;
        SHS50: Decimal;
        SHS20: Decimal;
        SHS10: Decimal;
        SHS5: Decimal;
        SHS1: Decimal;
        SHS05: Decimal;
        SHS01: Decimal;
        EmpCount: Decimal;
        gvAllowedPayrolls: Record 51182;
        gvPayment: Record 51187;
        ModeOfPayment: Code[20];
        Period_Status_CaptionLbl: Label 'Period Status:';
        Employee_NameCaptionLbl: Label 'Name';
        Employee_AmountCaptionLbl: Label 'Amount';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        SignatureCaptionLbl: Label 'Signature';
        SHS_1000CaptionLbl: Label 'SHS 1000';
        SHS_500CaptionLbl: Label 'SHS 500';
        SHS_200CaptionLbl: Label 'SHS 200';
        SHS_100CaptionLbl: Label 'SHS 100';
        SHS_50CaptionLbl: Label 'SHS 50';
        SHS_20CaptionLbl: Label 'SHS 20';
        SHS_10CaptionLbl: Label 'SHS 10';
        SHS_5CaptionLbl: Label 'SHS 5';
        SHS_1CaptionLbl: Label 'SHS 1';
        V50_CENTSCaptionLbl: Label '50 CENTS';
        V10_CENTSCaptionLbl: Label '10 CENTS';
        EmptyStringCaptionLbl: Label '.............................................';

    procedure CountCoin(DecAmount: Decimal)
    var
        IntAmount: Integer;
        RestAmount: Integer;
        Amount2: Decimal;
    begin
        Amount2 := DecAmount * 100;
        IntAmount := ROUND(Amount2, 10, '<');

        SHS10002 := IntAmount DIV 100000;
        SHS1000 := SHS1000 + IntAmount DIV 100000;
        RestAmount := IntAmount MOD 100000;

        SHS5002 := RestAmount DIV 50000;
        SHS500 := SHS500 + RestAmount DIV 50000;
        RestAmount := RestAmount MOD 50000;

        SHS2002 := RestAmount DIV 20000;
        SHS200 := SHS200 + RestAmount DIV 20000;
        RestAmount := RestAmount MOD 20000;

        SHS1002 := RestAmount DIV 10000;
        SHS100 := SHS100 + RestAmount DIV 10000;
        RestAmount := RestAmount MOD 10000;

        SHS502 := RestAmount DIV 5000;
        SHS50 := SHS50 + RestAmount DIV 5000;
        RestAmount := RestAmount MOD 5000;

        SHS202 := RestAmount DIV 2000;
        SHS20 := SHS20 + RestAmount DIV 2000;
        RestAmount := RestAmount MOD 2000;

        SHS102 := RestAmount DIV 1000;
        SHS10 := SHS10 + RestAmount DIV 1000;
        RestAmount := RestAmount MOD 1000;

        SHS52 := RestAmount DIV 500;
        SHS5 := SHS5 + RestAmount DIV 500;
        RestAmount := RestAmount MOD 500;

        SHS12 := RestAmount DIV 100;
        SHS1 := SHS1 + RestAmount DIV 100;
        RestAmount := RestAmount MOD 100;

        SHS052 := 0;
        //SHS052 := RestAmount DIV 50;
        SHS05 := SHS05 + RestAmount DIV 50;
        RestAmount := RestAmount MOD 50;

        SHS012 := 0;
        //SHS012 := RestAmount DIV 10;
        SHS01 := SHS01 + RestAmount DIV 10;
        RestAmount := RestAmount MOD 10;
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

