report 51156 "ED Totals Per Period"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/ED Totals Per Period.rdlc';

    dataset
    {
        dataitem(Periods; 51151)
        {
            DataItemTableView = SORTING("Start Date")
                                WHERE(Status = FILTER(Open | Posted));
            RequestFilterFields = "Period ID";
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(CompPicture; CompInfo.Picture)
            {
            }
            column(TitleText; TitleText)
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(USERID; USERID)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
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
            dataitem("ED Definitions"; 51158)
            {
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
                column(Amount1; Amount1)
                {
                }
                column(Amount2; Amount2)
                {
                }
                column(TotalNetPay; TotalNetPay)
                {
                }
                column(TOTAL_NET_PAYCaption; TOTAL_NET_PAYCaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Name := "ED Definitions".Description;
                    Lines.SETRANGE("ED Code", "ED Definitions"."ED Code");
                    IF Lines.FIND('-') THEN
                        Paycode := Lines."Payroll Code";
                    Lines.CALCSUMS(Amount);
                    Amount := Lines.Amount;

                    IF (Amount = 0) AND (SkipZeroAmountEDs) THEN CurrReport.SKIP;
                    //Separating EDs
                    IF "Calculation Group" = "Calculation Group"::None THEN CurrReport.SKIP;

                    //IF Paycode='GENERAL' THEN
                    IF "ED Definitions"."Calculation Group" = "ED Definitions"."Calculation Group"::Payments THEN BEGIN
                        Amount1 := Amount;

                    END ELSE BEGIN
                        //IF Paycode='CMT' THEN
                        IF "ED Definitions"."Calculation Group" = "ED Definitions"."Calculation Group"::Deduction THEN
                            Amount2 := -Amount;

                    END;
                    //Calculate Total Net Pay
                    IF "Calculation Group" = "Calculation Group"::Payments THEN BEGIN
                        TotalNetPay := TotalNetPay + Amount;
                        RTCAmount := -Amount
                    END ELSE BEGIN
                        IF "Calculation Group" = "Calculation Group"::Deduction THEN
                            TotalNetPay := TotalNetPay - Amount;
                        RTCAmount := Amount;
                    END;

                    IF "Calculation Group" = "Calculation Group"::Payments THEN Amount := -Amount;
                end;

                trigger OnPreDataItem()
                begin
                    Lines.SETCURRENTKEY("Payroll ID", "ED Code", "Payroll Code");
                    Lines.SETRANGE("Payroll ID", Periods."Period ID");
                    //Lines.Rec.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                TitleText := 'E/D Totals for ' + Periods.Description;
                CompInfo.GET;
                CompInfo.CALCFIELDS(Picture);
            end;

            trigger OnPreDataItem()
            begin
                //Rec.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                IF Periods.GETFILTER(Periods."Period ID") = '' THEN ERROR('Specify the Period ID');
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
                    field("Skip Zero Amount ED's"; SkipZeroAmountEDs)
                    {
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
        //gsSegmentPayrollData
    end;

    var
        Period: Record 51151;
        Lines: Record 51160;
        TestCalc: Codeunit 51152;
        Name: Text[92];
        TitleText: Text[60];
        PeriodCode: Code[10];
        Amount: Decimal;
        TotalNetPay: Decimal;
        SkipZeroAmountEDs: Boolean;
        gvAllowedPayrolls: Record 51182;
        RTCAmount: Decimal;
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        DESCRIPTIONCaptionLbl: Label 'DESCRIPTION';
        ED_CODECaptionLbl: Label 'ED CODE';
        AMOUNT_KSHSCaptionLbl: Label 'Earnings';
        TOTAL_NET_PAYCaptionLbl: Label 'TOTAL NET PAY';
        Amount1: Decimal;
        Amount2: Decimal;
        CompInfo: Record 79;
        EDPgroup: Record 51156;
        Paycode: Code[20];

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

