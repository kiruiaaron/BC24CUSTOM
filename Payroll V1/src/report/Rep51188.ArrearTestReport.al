report 51188 "Arrear Test Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/Arrear Test Report.rdlc';

    dataset
    {
        dataitem(Employee; 5200)
        {
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending);
            column(Employee__No__; "No.")
            {
            }
            column(ArrearEDCode1; ArrearEDCode1)
            {
            }
            column(ArrearPayID1; ArrearPayID1)
            {
            }
            column(NoofMonths1; NoofMonths1)
            {
            }
            column(ArrearAmountAdd_; ArrearAmountAdd)
            {
            }
            column(NoofMonths1_ArrearAmountAdd_; NoofMonths1 * ArrearAmountAdd)
            {
            }
            column(Test_Report_for_Arrear_ComputationCaption; Test_Report_for_Arrear_ComputationCaptionLbl)
            {
            }
            column(Employee_No_Caption; Employee_No_CaptionLbl)
            {
            }
            column(ED_CodeCaption; ED_CodeCaptionLbl)
            {
            }
            column(Payroll_ID_CodeCaption; Payroll_ID_CodeCaptionLbl)
            {
            }
            column(QuantityCaption; QuantityCaptionLbl)
            {
            }
            column(RateCaption; RateCaptionLbl)
            {
            }
            column(AmountCaption; AmountCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin

                PayrollLine.RESET;
                PayrollLine.SETRANGE(PayrollLine."Payroll ID", BasePayM1);
                PayrollLine.SETRANGE(PayrollLine."Employee No.", "No.");
                PayrollLine.SETRANGE(PayrollLine."ED Code", NormalEDCode1);
                IF PayrollLine.FINDFIRST THEN BEGIN
                    BaseAmountCal := PayrollLine.Amount;
                END;
                IF ArrearPerc1 <> 0 THEN
                    ArrearAmountAdd := (BaseAmountCal / 100) * ArrearPerc1
                ELSE
                    IF ArrearAmt1 <> 0 THEN
                        ArrearAmountAdd := BaseAmountCal + ArrearAmt1;
            end;

            trigger OnPreDataItem()
            begin
                SETFILTER("No.", EmpCode1);
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

    trigger OnPreReport()
    begin
        gsSegmentPayrollData;
    end;

    var
        ArrearEDCode1: Code[20];
        ArrearPayID1: Code[20];
        BaseAmountCal: Decimal;
        ArrearAmountAdd: Decimal;
        NoofMonths1: Decimal;
        I: Integer;
        PayrollLine: Record 51160;
        BasePayM1: Code[20];
        NormalEDCode1: Code[20];
        ArrearAmt1: Decimal;
        ArrearPerc1: Decimal;
        EmpCode1: Code[20];
        gvAllowedPayrolls: Record 51182;
        MembershipNumbers: Record 51175;
        gvPinNo: Code[20];
        Test_Report_for_Arrear_ComputationCaptionLbl: Label 'Test Report for Arrear Computation';
        Employee_No_CaptionLbl: Label 'Employee No.';
        ED_CodeCaptionLbl: Label 'ED Code';
        Payroll_ID_CodeCaptionLbl: Label 'Payroll ID Code';
        QuantityCaptionLbl: Label 'Quantity';
        RateCaptionLbl: Label 'Rate';
        AmountCaptionLbl: Label 'Amount';

    procedure ArrearsInflow(ArrearEDCode: Code[20]; ArrearPayID: Code[20]; EmpRec: Record 5200; EmpCode: Code[20]; BasePayM: Code[20]; NormalEDCode: Code[20]; NoofMonths: Decimal; ArrearPerc: Decimal; ArrearAmt: Decimal; Filters: Text[100])
    begin
        EmpCode1 := EmpCode;
        Filters := EmpRec.GETFILTER("No.");
        ArrearEDCode1 := ArrearEDCode;
        ArrearPayID1 := ArrearPayID;
        NoofMonths1 := NoofMonths;
        BasePayM1 := BasePayM;
        NormalEDCode1 := NormalEDCode;
        ArrearPerc1 := ArrearPerc;
        ArrearAmt1 := ArrearAmt;
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

