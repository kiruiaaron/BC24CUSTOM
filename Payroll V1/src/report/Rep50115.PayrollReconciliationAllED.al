report 50115 "Payroll Reconciliation-All ED"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/Payroll Reconciliation-All ED.rdlc';

    dataset
    {
        dataitem(Periods; Periods)
        {
            DataItemTableView = SORTING("Start Date") WHERE(Status = FILTER(Open | Posted));
            RequestFilterFields = "Period ID";
            column(COMPANYNAME; CompanyName)
            {
            }
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(CompanyInfo_Address; CompanyInfo.Address)
            {
            }
            column(CompanyInfo_Address2; CompanyInfo."Address 2")
            {
            }
            column(pic; CompanyInfo.Picture)
            {
            }
            column(CompanyInfo_City; CompanyInfo.City)
            {
            }
            column(CompanyInfo_Phone; CompanyInfo."Phone No.")
            {
            }
            column(CompanyInfo_Fax; CompanyInfo."Fax No.")
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(CompanyInfo_Email; CompanyInfo."E-Mail")
            {
            }
            column(CompanyInfo_Web; CompanyInfo."Home Page")
            {
            }
            column(TitleText; TitleText)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(USERID; UserId)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(DESCRIPTIONCaption; DESCRIPTIONCaptionLbl)
            {
            }
            column(ED_CODECaption; ED_CODECaptionLbl)
            {
            }
            column(PayrollCode; PAYROLL_CODE)
            {
            }
            column(AMOUNT_KSHSCaption; AMOUNT_KSHSCaptionLbl)
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
            dataitem("ED Definitions"; "ED Definitions")
            {
                DataItemTableView = WHERE("ED Code" = FILTER(<> '14000' & <> '16000' & <> '32000' & <> '33000' & <> '50500'));
                RequestFilterFields = "ED Code";
                column(Amount; Amount)
                {
                }
                column(Name; Name)
                {
                }
                column(ED_Definitions__ED_Code_; "ED Code")
                {
                }
                column(RTCAmount; RTCAmount)
                {
                }
                column(TotalNetPay; TotalNetPay)
                {
                }
                column(TOTAL_NET_PAYCaption; TOTAL_NET_PAYCaptionLbl)
                {
                }
                column(PreviousAmt; PreviousAmt)
                {
                }
                column(Variance; Variance)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Name := "ED Definitions".Description;
                    Lines.SetRange("ED Code", "ED Definitions"."ED Code");
                    Lines.CalcSums(Amount);
                    Amount := Lines.Amount;

                    //Previous month
                    GPrevPeriodEndDate := Periods."Start Date" - 1;
                    GPrevMonth := Date2DMY(GPrevPeriodEndDate, 2);
                    GPrevPeriodYear := Date2DMY(GPrevPeriodEndDate, 3);
                    GPeriodText := Format(GPrevMonth) + '-' + Format(GPrevPeriodYear);
                    Period.SetRange("Period ID", GPeriodText);
                    Period.SetFilter("Payroll Code", Periods."Payroll Code");
                    if Period.FindFirst then
                        GPrevPeriod := Period."Period ID";

                    Lines2.SetCurrentKey("Payroll ID", "ED Code", "Payroll Code");
                    Lines2.SetRange("Payroll ID", Period."Period ID");
                    Lines2.SetRange("Payroll Code", gvAllowedPayrolls."Payroll Code");
                    Lines2.SetRange("ED Code", "ED Definitions"."ED Code");
                    Lines2.CalcSums(Amount);
                    PreviousAmt := Lines2.Amount;

                    if ((Amount = 0) and (PreviousAmt = 0)) and (SkipZeroAmountEDs) then CurrReport.Skip;
                    Variance := Amount - PreviousAmt;
                    /*
                    //Calculate Total Net Pay
                    IF "Calculation Group" = "Calculation Group"::Payments THEN BEGIN
                      TotalNetPay := TotalNetPay + Amount ;
                       RTCAmount:=-Amount
                    END ELSE  BEGIN
                    IF "Calculation Group" = "Calculation Group"::Deduction THEN
                      TotalNetPay := TotalNetPay - Amount;
                       RTCAmount:=Amount;
                    END;
                    
                    IF "Calculation Group" = "Calculation Group"::Payments THEN Amount:=-Amount;
                    */

                end;

                trigger OnPreDataItem()
                begin
                    if ((gvAllowedPayrolls."Payroll Code" = 'ABMCASUAL') or (gvAllowedPayrolls."Payroll Code" = 'ABMRREAL') or
                      (gvAllowedPayrolls."Payroll Code" = 'ABMJNR') or (gvAllowedPayrolls."Payroll Code" = 'ABMSUP')) then
                        SetRange("Payroll Code", 'ABMCASUAL');
                    if ((gvAllowedPayrolls."Payroll Code" = 'ABMMGT') or (gvAllowedPayrolls."Payroll Code" = 'ABMEXEC')) then
                        SetRange("Payroll Code", 'ABMMGT');
                    if ((gvAllowedPayrolls."Payroll Code" = 'CEKLSUP') or (gvAllowedPayrolls."Payroll Code" = 'CEKLJNR')) then
                        SetRange("Payroll Code", 'CEKLSUP');
                    if (gvAllowedPayrolls."Payroll Code" = 'CEKLMGT') then
                        SetRange("Payroll Code", 'CEKLMGT');
                    if (gvAllowedPayrolls."Payroll Code" = 'CETZ') then
                        SetRange("Payroll Code", 'CETZ');
                    if (gvAllowedPayrolls."Payroll Code" = 'CETZMGT') then
                        SetRange("Payroll Code", 'CETZMGT');
                    if ((gvAllowedPayrolls."Payroll Code" = 'JNR') or (gvAllowedPayrolls."Payroll Code" = 'MGT') or
                    (gvAllowedPayrolls."Payroll Code" = 'TEMP')) then
                        SetRange("Payroll Code", 'JNR');
                    Lines.SetCurrentKey("Payroll ID", "ED Code", "Payroll Code");
                    Lines.SetRange("Payroll ID", Periods."Period ID");
                    Lines.SetRange("Payroll Code", gvAllowedPayrolls."Payroll Code");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                TitleText := 'E/D Reconciliation for ' + Periods.Description;
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Payroll Code", gvAllowedPayrolls."Payroll Code");
                if Periods.GetFilter(Periods."Period ID") = '' then Error('Specify the Period ID');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Control1102754001)
                {
                    ShowCaption = false;
                    field("Skip Zero Amount ED's"; SkipZeroAmountEDs)
                    {
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
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture)
    end;

    var
        Period: Record Periods;
        Lines: Record "Payroll Lines";
        TestCalc: Codeunit "Payroll Posting";
        Name: Text[92];
        TitleText: Text[60];
        PeriodCode: Code[10];
        Amount: Decimal;
        TotalNetPay: Decimal;
        SkipZeroAmountEDs: Boolean;
        gvAllowedPayrolls: Record "Allowed Payrolls";
        RTCAmount: Decimal;
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        DESCRIPTIONCaptionLbl: Label 'DESCRIPTION';
        ED_CODECaptionLbl: Label 'ED CODE';
        AMOUNT_KSHSCaptionLbl: Label 'Earnings';
        TOTAL_NET_PAYCaptionLbl: Label 'TOTAL NET PAY';
        PreviousAmt: Decimal;
        Variance: Decimal;
        Lines2: Record "Payroll Lines";
        GPrevMonth: Integer;
        GPrevPeriodYear: Integer;
        GPrevPeriod: Code[10];
        GPrevPeriodEndDate: Date;
        GPeriodText: Text[30];
        gvPeriodIDFilter: Code[100];
        gvEmployeeNoFilter: Code[100];
        CompanyInfo: Record "Company Information";
        PAYROLL_CODE: Label 'PAYROLL CODE';

    procedure gsSegmentPayrollData()
    var
        lvAllowedPayrolls: Record "Allowed Payrolls";
        lvPayrollUtilities: Codeunit "Payroll Posting";
        UsrID: Code[10];
        UsrID2: Code[10];
        StringLen: Integer;
        lvActiveSession: Record "Active Session";
    begin

        lvActiveSession.Reset;
        lvActiveSession.SetRange("Server Instance ID", ServiceInstanceId);
        lvActiveSession.SetRange("Session ID", SessionId);
        lvActiveSession.FindFirst;


        gvAllowedPayrolls.SetRange("User ID", lvActiveSession."User ID");
        gvAllowedPayrolls.SetRange("Last Active Payroll", true);
        if not gvAllowedPayrolls.FindFirst then
            Error('You are not allowed access to this payroll dataset.');
    end;

    procedure sSetParameters(pPeriodIDFilter: Code[10]; pEmployeeNoFilter: Code[10])
    begin
        //skm080307 this function sets global parameters for filtering the payslip when e-mailing
        gvPeriodIDFilter := pPeriodIDFilter;
        gvEmployeeNoFilter := pEmployeeNoFilter;
    end;
}

