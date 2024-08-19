report 51159 "Check Payment List"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/Check Payment List.rdlc';

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
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(USERID; USERID)
            {
            }
            column(Period_Status_Caption; Period_Status_CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
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
                DataItemTableView = SORTING("No.")
                                    ORDER(Ascending);
                RequestFilterFields = "No.", "Statistics Group Code", "Global Dimension 1 Code", "Global Dimension 2 Code", Status, "Mode of Payment";
                column(Employee__No__; "No.")
                {
                }
                column(Employee_Name; Name)
                {
                }
                column(Employee_Amount; Amount)
                {
                }
                column(TotalAmount; TotalAmount)
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
                column(SignatureCaption; SignatureCaptionLbl)
                {
                }
                column(EmptyStringCaption; EmptyStringCaptionLbl)
                {
                }
                column(TotalAmountCaption; TotalAmountCaptionLbl)
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
                    END ELSE
                        CurrReport.SKIP;
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                    SETRANGE(Employee."Mode of Payment", ModeOfPayment);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                TitleText := '"Cheque Payment" List for ' + Periods.Description;
                TotalAmount := 0;
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                IF Periods.GETFILTER(Periods."Period ID") = '' THEN ERROR('Specify the Period ID');
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
        MESSAGE('Select The "Cheque Payment" Option');
        IF ACTION::LookupOK = PAGE.RUNMODAL(PAGE::"Mode of Payment", gvPayment) THEN
            ModeOfPayment := gvPayment.Code
        ELSE
            ERROR('Please Select a mode of payment');
    end;

    trigger OnPreReport()
    begin
        gsSegmentPayrollData;
    end;

    var
        Header: Record 51159;
        Name: Text[60];
        Amount: Decimal;
        TotalAmount: Decimal;
        TitleText: Text[70];
        gvAllowedPayrolls: Record 51182;
        gvPayment: Record 51187;
        ModeOfPayment: Code[20];
        Period_Status_CaptionLbl: Label 'Period Status:';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Employee_NameCaptionLbl: Label 'Name';
        Employee_AmountCaptionLbl: Label 'Amount';
        SignatureCaptionLbl: Label 'Signature';
        EmptyStringCaptionLbl: Label '__________________________________';
        TotalAmountCaptionLbl: Label 'Total Amount';

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

