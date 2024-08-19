report 51160 "Bank Payment List"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/Bank Payment List.rdlc';

    dataset
    {
        dataitem(Periods; 51151)
        {
            DataItemTableView = SORTING("Start Date")
                                WHERE(Status = FILTER(Open | Posted));
            RequestFilterFields = "Period ID";
            column(CompName; CompName)
            {
            }
            column(Periods_Description; Description)
            {
            }
            column(Periods_Status; Status)
            {
            }
            column(CompNameCaption; CompNameCaptionLbl)
            {
            }
            column(Periods_DescriptionCaption; Periods_DescriptionCaptionLbl)
            {
            }
            column(Period_StatusCaption; Period_StatusCaptionLbl)
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
                DataItemTableView = SORTING("No.");
                RequestFilterFields = "No.", "Bank Code", "Global Dimension 1 Code", "Shortcut Dimension 3 Code", Status, "Mode of Payment", "Employee Type";
                column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
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
                column(BankName; BankName)
                {
                }
                column(BranchName; BranchName)
                {
                }
                column(Employee__Bank_Account_No__; "Bank Account No")
                {
                }
                column(TotalAmount; TotalAmount)
                {
                }
                column(TotalAmount_Control23; TotalAmount)
                {
                }
                column(Periods_Description_Control25; Periods.Description)
                {
                }
                column(FORMAT_TODAY_0_4__Control28; FORMAT(TODAY, 0, 4))
                {
                }
                column(Number_of_Employees____FORMAT_EmpCount_; 'Number of Employees ' + FORMAT(EmpCount))
                {
                }
                column(Employee_AmountCaption; Employee_AmountCaptionLbl)
                {
                }
                column(Employee_NameCaption; Employee_NameCaptionLbl)
                {
                }
                column(Employee__No__Caption; FIELDCAPTION("No."))
                {
                }
                column(BranchNameCaption; BranchNameCaptionLbl)
                {
                }
                column(BankNameCaption; BankNameCaptionLbl)
                {
                }
                column(Employee__Bank_Account_No__Caption; FIELDCAPTION("Bank Account No"))
                {
                }
                column(TotalAmountCaption; TotalAmountCaptionLbl)
                {
                }
                column(Please_recieve_cheque_number___________________________________________Caption; Please_recieve_cheque_number___________________________________________CaptionLbl)
                {
                }
                column(for_ShsCaption; for_ShsCaptionLbl)
                {
                }
                column(covering_payments_of_salaries_to_the_above_listed_staff_forCaption; covering_payments_of_salaries_to_the_above_listed_staff_forCaptionLbl)
                {
                }
                column(Please_credit_their_accounts_accordingly_Caption; Please_credit_their_accounts_accordingly_CaptionLbl)
                {
                }
                column(Approved_By__Chief_Executive_OfficerCaption; Approved_By__Chief_Executive_OfficerCaptionLbl)
                {
                }
                column(Approved_By__AccountantCaption; Approved_By__AccountantCaptionLbl)
                {
                }
                column(Approved_By__HR___Admin_ManagerCaption; Approved_By__HR___Admin_ManagerCaptionLbl)
                {
                }
                column(Dptm; Employee."Global Dimension 1 Code")
                {
                }
                column(DptmName; DptName)
                {
                }
                column(ApprovedFM; ApprovedFM)
                {
                }
                column(HR_Admin_Manager; HR_Admin_Manager)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    /*DimVal.RESET;
                    DimVal.SETRANGE(Code,Employee."Global Dimension 1 Code");
                    IF DimVal.FIND('-') THEN
                    DptName:=DimVal.Name;*/
                    IF BankTable.GET(Employee."Bank Code") THEN BEGIN //SNG 080611 Make sure employee has bank code setup

                        BankName := BankTable.Name;
                        BranchName := BankTable.Branch;

                        Name := Employee.FullName;

                        IF Header.GET(Periods."Period ID", Employee."No.") THEN BEGIN
                            Header.CALCFIELDS("Total Payable (LCY)", "Total Deduction (LCY)", "Total Rounding Pmts (LCY)", "Total Rounding Ded (LCY)");
                            Amount := Header."Total Payable (LCY)" + Header."Total Rounding Pmts (LCY)" - (Header."Total Deduction (LCY)" +
                              Header."Total Rounding Ded (LCY)");
                            IF Amount < 0 THEN
                                CurrReport.SKIP
                            ELSE
                                TotalAmount := TotalAmount + Amount;
                        END ELSE
                            CurrReport.SKIP;

                        EmpCount := EmpCount + 1;
                    END
                    ELSE
                        ERROR(Employee."First Name" + ' ' + Employee."Middle Name" +
                        '\Employee No. ' + Employee."No." + '\Does not seem to have a bank Code setup');
                    //DimVal.GET(Employee."Global Dimension 1 Code");

                end;

                trigger OnPreDataItem()
                begin
                    EmpCount := 0;
                    SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                    SETRANGE(Employee."Mode of Payment", ModeOfPayment);
                end;
            }

            trigger OnAfterGetRecord()
            begin
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
        //SNG 080611 Enable user to dynamicaly select the Mode of Payment
        MESSAGE('Select The Bank Payment Option ');
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
        BankTable: Record 51152;
        Name: Text[60];
        Amount: Decimal;
        TotalAmount: Decimal;
        Emplo: Record 5200;
        BankName: Text[50];
        BranchName: Text[50];
        PeriodName: Text[50];
        CompName: Text[50];
        EmpCount: Integer;
        gvAllowedPayrolls: Record 51182;
        gvPayment: Record 51187;
        ModeOfPayment: Code[20];
        CompNameCaptionLbl: Label 'Bank Schedule for: ';
        Periods_DescriptionCaptionLbl: Label 'Report Period';
        Period_StatusCaptionLbl: Label 'Period Status';
        Employee_AmountCaptionLbl: Label 'Amount';
        Employee_NameCaptionLbl: Label 'Name';
        BranchNameCaptionLbl: Label 'Branch';
        BankNameCaptionLbl: Label 'Bank';
        TotalAmountCaptionLbl: Label 'Total Amount';
        Please_recieve_cheque_number___________________________________________CaptionLbl: Label 'Please recieve cheque number __________________________________________';
        for_ShsCaptionLbl: Label 'for Shs';
        covering_payments_of_salaries_to_the_above_listed_staff_forCaptionLbl: Label ', covering payments of salaries to the above listed staff for';
        Please_credit_their_accounts_accordingly_CaptionLbl: Label 'Please credit their accounts accordingly.';
        Approved_By__Chief_Executive_OfficerCaptionLbl: Label 'Prepared By: HR Officer';
        Approved_By__AccountantCaptionLbl: Label 'Examined By: Financial Accountant';
        ApprovedFM: Label 'Approved By: Finance Manager';
        Approved_By__HR___Admin_ManagerCaptionLbl: Label 'Authorized By: Managing Director';
        DptName: Text[100];
        DimVal: Record 349;
        HR_Admin_Manager: Label 'Approved By:HR & Admin Manager';

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

