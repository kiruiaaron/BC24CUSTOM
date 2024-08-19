report 51171 "Loans / Advances"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/Loans  Advances.rdlc';

    dataset
    {
        dataitem("Loans/Advances"; 51171)
        {
            DataItemTableView = SORTING("Loan ID")
                                WHERE("Paid to Employee" = CONST(True));
            RequestFilterFields = "Loan ID", Employee, Type, "Loan Types";
            column(EmployerName; EmployerName)
            {
            }
            column(USERID; USERID)
            {
            }
            column(TitleText; TitleText)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(Loans_Advances__First_Name_; "First Name")
            {
            }
            column(Loans_Advances__Last_Name_; "Last Name")
            {
            }
            column(Loans_Advances__Interest_Rate_; "Interest Rate")
            {
            }
            column(Loans_Advances_Principal; Principal)
            {
            }
            column(Loans_Advances__Remaining_Debt_; "Remaining Debt")
            {
            }
            column(Loans_Advances_Repaid; Repaid)
            {
            }
            column(Loans_Advances__Interest_Paid_; "Interest Paid")
            {
            }
            column(Loans_Advances_Installments; Installments)
            {
            }
            column(Loans_Advances__Installment_Amount_; "Installment Amount")
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Loans_Advances__First_Name_Caption; FIELDCAPTION("First Name"))
            {
            }
            column(Loans_Advances__Last_Name_Caption; FIELDCAPTION("Last Name"))
            {
            }
            column(Loans_Advances__Interest_Rate_Caption; FIELDCAPTION("Interest Rate"))
            {
            }
            column(Loans_Advances_PrincipalCaption; FIELDCAPTION(Principal))
            {
            }
            column(Loans_Advances__Remaining_Debt_Caption; FIELDCAPTION("Remaining Debt"))
            {
            }
            column(Loans_Advances_RepaidCaption; FIELDCAPTION(Repaid))
            {
            }
            column(Loans_Advances__Interest_Paid_Caption; FIELDCAPTION("Interest Paid"))
            {
            }
            column(Loans_Advances_InstallmentsCaption; FIELDCAPTION(Installments))
            {
            }
            column(Loans_Advances__Installment_Amount_Caption; FIELDCAPTION("Installment Amount"))
            {
            }
            column(Loans_Advances_ID; "Loan ID")
            {
            }

            trigger OnPreDataItem()
            begin
                SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                IF NOT gvShowWrittenOff THEN   //SNG 080611 allow user to view Written off and Cleared loans
                    SETRANGE("Loans/Advances".Cleared, FALSE);
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
                    field(gvShowWrittenOff; gvShowWrittenOff)
                    {
                        Caption = 'Show Written Off Loans / Cleared Loans';
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
        PayrollSetup.GET(gvAllowedPayrolls."Payroll Code");
        EmployerName := PayrollSetup."Employer Name";

        PeriodRec.SETCURRENTKEY("Start Date");
        PeriodRec.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
        PeriodRec.FIND('-');

        TitleText := 'Summary of Loans';
    end;

    var
        PayrollSetup: Record 51165;
        PeriodRec: Record 51151;
        EmployeeRec: Record 5200;
        Name: Text[100];
        TitleText: Text[60];
        EmployerName: Text[50];
        PeriodAmount: Decimal;
        TotalAmountArray: array[4] of Decimal;
        gvAllowedPayrolls: Record 51182;
        gvShowWrittenOff: Boolean;
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

