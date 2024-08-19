report 51173 "Yearly Earnings/Deductions Sch"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/Yearly EarningsDeductions Sch.rdlc';

    dataset
    {
        dataitem(Periods; 51151)
        {
            DataItemTableView = SORTING("Start Date")
                                ORDER(Ascending);
            RequestFilterFields = "Period Year";
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
            dataitem("Payroll Lines"; 51160)
            {
                DataItemLink = "Payroll ID" = FIELD("Period ID");
                DataItemTableView = SORTING("Payroll ID", "Employee No.", "ED Code")
                                    ORDER(Ascending);
                column(USERID; USERID)
                {
                }
                column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
                {
                }
                column(COMPANYNAME; COMPANYNAME)
                {
                }
                column(TitleText; TitleText)
                {
                }
                column(Payroll_Lines_Amount; Amount)
                {
                }
                column(Payroll_Lines__Employee_No__; "Employee No.")
                {
                }
                column(Payroll_Lines_Amount_Control11; Amount)
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
                column(Payroll_Lines_Amount_Control1; Amount)
                {
                }
                column(Payroll_Lines_Amount_Control31; Amount)
                {
                }
                column(CurrReport_PAGENO; CurrReport.PAGENO)
                {
                }
                column(Sub_Total_B_FCaption; Sub_Total_B_FCaptionLbl)
                {
                }
                column(AmountCaption; AmountCaptionLbl)
                {
                }
                column(NameCaption; NameCaptionLbl)
                {
                }
                column(No_Caption; No_CaptionLbl)
                {
                }
                column(Payroll_Lines__Employee_No__Caption; Payroll_Lines__Employee_No__CaptionLbl)
                {
                }
                column(Payroll_Lines_Amount_Control11Caption; FIELDCAPTION(Amount))
                {
                }
                column(NameCaption_Control3; NameCaption_Control3Lbl)
                {
                }
                column(Payroll_Lines_RateCaption; FIELDCAPTION(Rate))
                {
                }
                column(Payroll_Lines_QuantityCaption; FIELDCAPTION(Quantity))
                {
                }
                column(Payroll_Lines_Amount_Control1Caption; Payroll_Lines_Amount_Control1CaptionLbl)
                {
                }
                column(Sub_Total_C_FCaption; Sub_Total_C_FCaptionLbl)
                {
                }
                column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                {
                }
                column(Payroll_Lines_Entry_No_; "Entry No.")
                {
                }
                column(Payroll_Lines_Payroll_ID; "Payroll ID")
                {
                }

                trigger OnPreDataItem()
                begin
                    SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                    SETRANGE("ED Code", EDCode);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //IF NOT TestCalc.TestCalculated("Period ID") THEN
                // ERROR('Not all Payrolls are calculated for period %1.',"Period ID"); //080611 SNG Commented out

                TitleText := EDDef.Description + ' List for ' + Description;
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
        IF ACTION::LookupOK = PAGE.RUNMODAL(PAGE::"ED Definitions List", EDDef) THEN
            EDCode := EDDef."ED Code"
        ELSE
            ERROR('No E/D was selected');

        gsSegmentPayrollData;
    end;

    var
        Employee: Record 5200;
        EDDef: Record 51158;
        TestCalc: Codeunit 51152;
        Name: Text[92];
        TitleText: Text[100];
        EDCode: Code[20];
        gvAllowedPayrolls: Record 51182;
        Sub_Total_B_FCaptionLbl: Label 'Sub Total B/F';
        AmountCaptionLbl: Label 'Amount';
        NameCaptionLbl: Label 'Name';
        No_CaptionLbl: Label 'No.';
        Payroll_Lines__Employee_No__CaptionLbl: Label 'No.';
        NameCaption_Control3Lbl: Label 'Name';
        Payroll_Lines_Amount_Control1CaptionLbl: Label 'Total Amount';
        Sub_Total_C_FCaptionLbl: Label 'Sub Total C/F';
        CurrReport_PAGENOCaptionLbl: Label 'Page';

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

