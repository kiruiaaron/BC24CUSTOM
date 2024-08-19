report 51146 "Company Payslip"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/CompanyPayslip.rdlc';

    dataset
    {
        dataitem(Periods; Periods)
        {
            DataItemTableView = SORTING("Start Date") ORDER(Ascending) WHERE(Status = FILTER(Open | Posted));
            RequestFilterFields = "Period ID";
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
            dataitem(Employee; Employee)
            {
                DataItemTableView = SORTING("No.");
                RequestFilterFields = "No.", "Global Dimension 1 Code", "Shortcut Dimension 3 Code";
                column(Branch_Code_from_multiple_dim__; 'Branch Code from multiple dim?')
                {
                }
                column(Employee__Job_Title_; "Job Title")
                {
                }
                column(Employee__No__; "No.")
                {
                }
                column(MonthText; MonthText)
                {
                }
                column(EmploNameText; EmploNameText)
                {
                }
                column(CompanyNameText; CompanyNameText)
                {
                }
                column(Employee_Employee__Global_Dimension_1_Code_; Employee."Global Dimension 1 Code")
                {
                }
                column(gvPinNo; gvPinNo)
                {
                }
                column(gvNhifNo; gvNhifNo)
                {
                }
                column(gvNssfNo; gvNssfNo)
                {
                }
                column(EmpBank; EmpBank)
                {
                }
                column(AccountNo; AccountNo)
                {
                }
                column(EmpBankBranch; EmpBankBranch)
                {
                }
                column(gvPayrollCode; gvPayrollCode)
                {
                }
                column(Employee_Employee__Global_Dimension_2_Code_; Employee."Global Dimension 2 Code")
                {
                }
                column(AmountCaption; AmountCaptionLbl)
                {
                }
                column(Rate__RepaymentCaption; Rate__RepaymentCaptionLbl)
                {
                }
                column(Quantity__InterestCaption; Quantity__InterestCaptionLbl)
                {
                }
                column(Branch_Caption; Branch_CaptionLbl)
                {
                }
                column(Employee__Job_Title_Caption; Employee__Job_Title_CaptionLbl)
                {
                }
                column(Employee__No__Caption; Employee__No__CaptionLbl)
                {
                }
                column(Payslip_for_Caption; Payslip_for_CaptionLbl)
                {
                }
                column(EmploNameTextCaption; EmploNameTextCaptionLbl)
                {
                }
                column(Employee_Employee__Global_Dimension_1_Code_Caption; FieldCaption("Global Dimension 1 Code"))
                {
                }
                column(Cumulative_Contribution___Total_Principal__To_DateCaption; Cumulative_Contribution___Total_Principal__To_DateCaptionLbl)
                {
                }
                column(Outstanding_Principal_to_DateCaption; Outstanding_Principal_to_DateCaptionLbl)
                {
                }
                column(gvPinNoCaption; gvPinNoCaptionLbl)
                {
                }
                column(gvNhifNoCaption; gvNhifNoCaptionLbl)
                {
                }
                column(gvNssfNoCaption; gvNssfNoCaptionLbl)
                {
                }
                column(Bank_Caption; Bank_CaptionLbl)
                {
                }
                column(Account_No_Caption; Account_No_CaptionLbl)
                {
                }
                column(Branch_Caption_Control1000000002; Branch_Caption_Control1000000002Lbl)
                {
                }
                column(Payroll_CodeCaption; Payroll_CodeCaptionLbl)
                {
                }
                column(Dept_CodeCaption; Dept_CodeCaptionLbl)
                {
                }
                column(Payslip_Footer; PayslipFooter)
                {
                }
                column(DiptName; DiptName)
                {
                }
                dataitem("Payslip Group"; "Payslip Group")
                {
                    DataItemTableView = SORTING(Code);
                    column(Payslip_Group__Heading_Text_; "Heading Text")
                    {
                    }
                    column(TotalText; TotalText)
                    {
                    }
                    column(TotalAmountDec; TotalAmountDec)
                    {
                    }
                    column(Payslip_Group_Code; Code)
                    {
                    }
                    column(PaySlipGroupIncludeTotal; "Payslip Group"."Include Total For Group")
                    {
                    }
                    dataitem("Payslip Lines"; "Payslip Lines")
                    {
                        DataItemLink = "Payslip Group" = FIELD(Code);
                        DataItemTableView = SORTING("Line No.", "Payslip Group");
                        column(IsPayslipLineP9; IsPayslipLineP9)
                        {
                        }
                        column(Payslip_Lines__P9_Text_; "P9 Text")
                        {
                        }
                        column(Payslip_Lines_Amount; Amount)
                        {
                        }
                        column(Payslip_Lines_Line_No_; "Line No.")
                        {
                        }
                        column(Payslip_Lines_Payslip_Group; "Payslip Group")
                        {
                        }
                        column(Payslip_Lines_Payroll_Code; "Payroll Code")
                        {
                        }
                        column(Payslip_Lines_E_D_Code; "E/D Code")
                        {
                        }
                        dataitem("Payroll Lines"; "Payroll Lines")
                        {
                            DataItemLink = "ED Code" = FIELD("E/D Code");
                            DataItemTableView = SORTING("Entry No.");
                            column(PayrollLineLoanEntry; "Payroll Lines"."Loan Entry")
                            {
                            }
                            column(Payroll_Lines_Text; Text)
                            {
                            }
                            column(Payroll_Lines__Amount__LCY__; "Amount (LCY)")
                            {
                            }
                            column(Payroll_Lines__Rate__LCY__; "Rate (LCY)")
                            {
                            }
                            column(Payroll_Lines_Quantity; Quantity)
                            {
                            }
                            column(CumilativeDec; CumilativeDec)
                            {
                            }
                            column(Payroll_Lines_Text_Control13; Text)
                            {
                            }
                            column(Payroll_Lines__Amount__LCY___Control14; "Amount (LCY)")
                            {
                            }
                            column(Payroll_Lines__Interest__LCY__; "Interest (LCY)")
                            {
                            }
                            column(Payroll_Lines__Repayment__LCY__; "Repayment (LCY)")
                            {
                            }
                            column(Payroll_Lines__Remaining_Debt__LCY__; "Remaining Debt (LCY)")
                            {
                            }
                            column(Payroll_Lines__Paid__LCY__; "Paid (LCY)")
                            {
                            }
                            column(Payroll_Lines_Entry_No_; "Entry No.")
                            {
                            }
                            column(Payroll_Lines_ED_Code; "ED Code")
                            {
                            }

                            trigger OnAfterGetRecord()
                            var
                                lvPayrollLines: Record "Payroll Lines";
                                i: Integer;
                            begin
                                EDDefRec.Get("Payroll Lines"."ED Code");
                                "Payroll Lines".Text := "Payroll Lines"."ED Code" + ': ' + "Payroll Lines".Text;
                                //IGS AUG 2018
                                //MESH
                                /*IF (EDDefRec.Cumulative {AND NOT EDDefRec.Reducing}) THEN BEGIN
                                  //EmployeeRec.GET(Employee."No.");
                                  EmployeeRec.SETRANGE("ED Code Filter",EDDefRec."ED Code");
                                  EndDate := Periods."End Date";
                                 EmployeeRec.SETFILTER("Date Filter", FORMAT(DMY2DATE(1,1,1900)) + '..' + FORMAT(EndDate));
                                  EmployeeRec.CALCFIELDS("Amount To Date (LCY)");
                                  CumilativeDec := EmployeeRec."Amount To Date (LCY)";
                                END ELSE
                                  CumilativeDec := 0;
                                
                                
                                IF (EDDefRec.Cumulative {AND EDDefRec.Reducing}) THEN BEGIN
                                  //lvPayrollLines.SETFILTER("Employee No.",Employee."No.");
                                  lvPayrollLines.SETFILTER("ED Code",EDDefRec."ED Code");
                                  i:=1;
                                  IF lvPayrollLines.FINDFIRST THEN REPEAT
                                    IF i=1 THEN CumilativeDec:=lvPayrollLines.Amount ELSE
                                    CumilativeDec:=CumilativeDec-lvPayrollLines.Amount;
                                    i:=i+1;
                                  UNTIL lvPayrollLines.NEXT=0;
                                END;// ELSE
                                  //CumilativeDec := 0;
                                  //MESH
                                  */
                                //IGS AUG 2018 END
                                case EDDefRec."Calculation Group" of
                                    EDDefRec."Calculation Group"::None:
                                        if "Payroll Lines"."ED Code" = 'GROSS PAYE' then begin
                                            "Payroll Lines"."Amount (LCY)" := "Payroll Lines"."Amount (LCY)";
                                            if "Payroll Lines"."Amount (LCY)" < 2400 then
                                                "Payroll Lines"."Amount (LCY)" := 2400;
                                        end else
                                            //"Payroll Lines"."Amount (LCY)" := -"Payroll Lines"."Amount (LCY)"
                                            "Payroll Lines"."Amount (LCY)" := -"Payroll Lines"."Amount (LCY)";
                                    EDDefRec."Calculation Group"::Deduction:
                                        begin
                                            if "Payslip Lines".Negative then
                                                "Payroll Lines"."Amount (LCY)" := -"Payroll Lines"."Amount (LCY)"
                                            else
                                                "Payroll Lines"."Amount (LCY)" := "Payroll Lines"."Amount (LCY)";
                                        end;
                                end;

                                TotalAmountDec := TotalAmountDec + "Payroll Lines"."Amount (LCY)";

                            end;

                            trigger OnPreDataItem()
                            begin
                                //SETRANGE("Employee No.",Employee."No.");
                                SetRange("Payroll ID", Periods."Period ID");
                                SetRange("Payroll Code", gvAllowedPayrolls."Payroll Code");
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if P9Levels = 1 then HdrRec.SetFilter("Payroll ID", Periods."Period ID");
                            HdrRec.SetFilter(HdrRec."Payroll Code", Employee."Payroll Code");
                            if HdrRec.FindFirst then
                                repeat
                                    if "Payslip Lines"."Line Type" = 1 then begin
                                        case "Payslip Lines".P9 of
                                            "Payslip Lines".P9::A:
                                                "Payslip Lines".Amount += HdrRec."A (LCY)";
                                            "Payslip Lines".P9::B:
                                                "Payslip Lines".Amount += HdrRec."B (LCY)";
                                            "Payslip Lines".P9::C:
                                                "Payslip Lines".Amount += HdrRec."C (LCY)";
                                            "Payslip Lines".P9::D:
                                                "Payslip Lines".Amount += HdrRec."D (LCY)";
                                            "Payslip Lines".P9::E1:
                                                "Payslip Lines".Amount += HdrRec."E1 (LCY)";
                                            "Payslip Lines".P9::E2:
                                                "Payslip Lines".Amount += HdrRec."E2 (LCY)";
                                            "Payslip Lines".P9::E3:
                                                "Payslip Lines".Amount += HdrRec."E3 (LCY)";
                                            "Payslip Lines".P9::F:
                                                "Payslip Lines".Amount += HdrRec."F (LCY)";
                                            "Payslip Lines".P9::G:
                                                "Payslip Lines".Amount += HdrRec."G (LCY)";
                                            "Payslip Lines".P9::H:
                                                "Payslip Lines".Amount += HdrRec."H (LCY)";
                                            "Payslip Lines".P9::J:
                                                "Payslip Lines".Amount += HdrRec."J (LCY)";
                                            "Payslip Lines".P9::K:
                                                "Payslip Lines".Amount += HdrRec."K (LCY)";
                                            "Payslip Lines".P9::L:
                                                "Payslip Lines".Amount += HdrRec."L (LCY)";
                                            "Payslip Lines".P9::M:
                                                "Payslip Lines".Amount += HdrRec."M (LCY)";
                                        end;
                                    end;

                                    if "Payslip Lines"."Line Type" = "Payslip Lines"."Line Type"::P9 then
                                        IsPayslipLineP9 := true
                                    else
                                        IsPayslipLineP9 := false;

                                    if IsPayslipLineP9 then if "P9 Text" <> '' then "P9 Text" := Format("P9 Text", 50);
                                //"P9 Text":=DELCHR(("Payslip Lines"."E/D Code"+': '+"P9 Text"),'<',':::::::');
                                until HdrRec.Next = 0;
                            P9Levels := P9Levels + 1;
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetRange("Payroll Code", gvAllowedPayrolls."Payroll Code");
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        TotalText := 'TOTAL ' + "Payslip Group"."Heading Text";
                        TotalAmountDec := 0;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange("Payroll Code", gvAllowedPayrolls."Payroll Code");
                    end;
                }
                dataitem("Integer"; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    MaxIteration = 1;
                    column(NetPayText; NetPayText)
                    {
                    }
                    column(NetPaydec; NetPaydec)
                    {
                    }
                    column(Integer_Number; Number)
                    {
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    Counts := Counts + 1;
                    if Counts > 1 then CurrReport.Skip;
                    //IGS AUG 2018

                    EmpBank := '';

                    HeaderRec.SetFilter("Payroll ID", Periods."Period ID");
                    HeaderRec.SetFilter("Payroll Code", Employee."Payroll Code");
                    if HeaderRec.FindFirst then
                        repeat
                            HeaderRec.CalcFields("Total Payable (LCY)", "Total Deduction (LCY)", "Total Rounding Pmts (LCY)", "Total Rounding Ded (LCY)");
                            NetPaydec := NetPaydec + (HeaderRec."Total Payable (LCY)" + HeaderRec."Total Rounding Pmts (LCY)" - (HeaderRec."Total Deduction (LCY)" +
                                         HeaderRec."Total Rounding Ded (LCY)"));
                        until HeaderRec.Next = 0;

                    EmploNameText := Employee.FullName;

                    Employee.TestField("Mode of Payment");
                    gvModeofPayment.Get("Mode of Payment");
                    //IF gvModeofPayment.Description <> '' THEN
                    NetPayText := 'Net Pay ';
                    //ELSE
                    //  NetPayText := 'Net Pay - By ' + gvModeofPayment.Code;

                    if Employee."Bank Code" <> '' then
                        if EmplankAccount.Get(Employee."Bank Code") then begin
                            EmpBank := EmplankAccount.Name;
                            AccountNo := Employee."Bank Account No";
                            EmpBankBranch := EmplankAccount.Branch;
                        end;

                    SetFilter("ED Code Filter", PayrollSetupRec."NSSF ED Code");
                    CalcFields("Membership No.");
                    gvNssfNo := "NSSF No.";
                    SetFilter("ED Code Filter", PayrollSetupRec."PAYE ED Code");
                    CalcFields("Membership No.");
                    gvPinNo := PIN;
                    SetFilter("ED Code Filter", PayrollSetupRec."NHIF ED Code");
                    CalcFields("Membership No.");
                    gvNhifNo := "NHIF No.";

                    //AMI 140907 OC023 show Payroll code in the Payslip
                    if Employee."Calculation Scheme" <> '' then begin
                        CalculationHeader.Get(Employee."Calculation Scheme");
                        gvPayrollCode := CalculationHeader."Payroll Code";
                    end;
                    /*DimVal.RESET;
                    DimVal.SETRANGE(Code,Employee."Global Dimension 1 Code");
                    IF DimVal.FIND('-') THEN
                      DiptName:=DimVal.Name;*/

                end;

                trigger OnPostDataItem()
                begin
                    //AMI 140907 OC023 show Payroll code in the Payslip
                    gvPayrollCode := '';
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Payroll Code", gvAllowedPayrolls."Payroll Code");

                    //skm070307 payslip e-mailing
                    //IF gvEmployeeNoFilter <> '' THEN SETRANGE("No.", gvEmployeeNoFilter);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                MonthText := Periods.Description;
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Payroll Code", gvAllowedPayrolls."Payroll Code");

                //skm070307 payslip e-mailing
                if gvPeriodIDFilter <> '' then SetRange("Period ID", gvPeriodIDFilter);
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
        PayrollSetupRec.Get(gvAllowedPayrolls."Payroll Code");
        CompanyNameText := PayrollSetupRec."Employer Name";
        PayslipFooter := PayrollSetupRec."Payslip Message Footer";//IGS 2016
        PeriodRec.SetCurrentKey("Start Date");
        PeriodRec.SetRange("Payroll Code", gvAllowedPayrolls."Payroll Code");
        PeriodRec.Find('-');
        gvPeriodIDFilter := Employee.GetFilter("Period Filter");//IGS APR2018
        //gvEmployeeNoFilter:=Employee.GETFILTER("No.");//IGS APR2018
        P9Levels := 1;
    end;

    var
        PeriodRec: Record Periods;
        EmployeeRec: Record Employee;
        PayrollSetupRec: Record "Payroll Setups";
        HeaderRec: Record "Payroll Header";
        EDDefRec: Record "ED Definitions";
        TotalText: Text[60];
        NetPayText: Text[60];
        MonthText: Text[60];
        EmploNameText: Text[100];
        CompanyNameText: Text[100];
        TotalAmountDec: Decimal;
        NetPaydec: Decimal;
        CumilativeDec: Decimal;
        EmplankAccount: Record "Employee Bank Account";
        EmpBank: Text[30];
        AccountNo: Text[30];
        EmpBankBranch: Text[30];
        gvNhifNo: Code[20];
        gvNssfNo: Code[20];
        gvPinNo: Code[20];
        EndDate: Date;
        gvAllowedPayrolls: Record "Allowed Payrolls";
        gvModeofPayment: Record "Mode of Payment";
        gvPeriodIDFilter: Code[100];
        gvEmployeeNoFilter: Code[100];
        CalculationHeader: Record "Calculation Header";
        gvPayrollCode: Text[30];
        AmountCaptionLbl: Label 'Amount';
        Rate__RepaymentCaptionLbl: Label 'Rate/\Repayment';
        Quantity__InterestCaptionLbl: Label 'Quantity/\Interest';
        Branch_CaptionLbl: Label 'Branch:';
        Employee__Job_Title_CaptionLbl: Label 'Job Title :';
        Employee__No__CaptionLbl: Label 'Personnel No. :';
        Payslip_for_CaptionLbl: Label 'Payslip for:';
        EmploNameTextCaptionLbl: Label 'Employee Name :';
        Cumulative_Contribution___Total_Principal__To_DateCaptionLbl: Label 'Cumulative\Contribution /\Total Principal\ To Date';
        Outstanding_Principal_to_DateCaptionLbl: Label 'Outstanding\Principal to\Date';
        gvPinNoCaptionLbl: Label 'PIN Code';
        gvNhifNoCaptionLbl: Label 'NHIF No';
        gvNssfNoCaptionLbl: Label 'NSSF No';
        Bank_CaptionLbl: Label 'Bank:';
        Account_No_CaptionLbl: Label 'Account No.';
        Branch_Caption_Control1000000002Lbl: Label 'Branch:';
        Payroll_CodeCaptionLbl: Label 'Payroll Code';
        Dept_CodeCaptionLbl: Label 'Dept Code';
        IsPayslipLineP9: Boolean;
        PayslipFooter: Text[100];
        Counts: Integer;
        HdrRec: Record "Payroll Header";
        P9Levels: Integer;
        DimVal: Record "Dimension Value";
        DiptName: Text[100];

    [Scope('Internal')]
    procedure sSetParameters(pPeriodIDFilter: Code[10]; pEmployeeNoFilter: Code[10])
    begin
        //skm080307 this function sets global parameters for filtering the payslip when e-mailing
        gvPeriodIDFilter := pPeriodIDFilter;
        gvEmployeeNoFilter := pEmployeeNoFilter;
    end;

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
}

