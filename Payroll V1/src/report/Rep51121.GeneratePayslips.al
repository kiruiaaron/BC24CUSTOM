report 51121 "Generate Payslips"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/Generate Payslips.rdlc';

    dataset
    {
        dataitem(Periods; 51151)
        {
            DataItemTableView = SORTING("Start Date")
                                ORDER(Ascending)
                                WHERE(Status = FILTER(Open | Posted));
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
            column(CompInfoPicture; CompInfo.Picture)
            {
            }
            dataitem(Employee; 5200)
            {
                DataItemTableView = SORTING("No.");
                RequestFilterFields = "No.", "Period Filter";
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
                column(Employee_Employee__Global_Dimension_1_Code_Caption; FIELDCAPTION("Global Dimension 1 Code"))
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
                dataitem("Payslip Group"; 51173)
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
                    dataitem("Payslip Lines"; 51174)
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
                        dataitem("Payroll Lines"; 51160)
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
                            begin

                                EDDefRec.GET("Payroll Lines"."ED Code");

                                IF EDDefRec.Cumulative THEN BEGIN
                                    EmployeeRec.GET(Employee."No.");
                                    EmployeeRec.SETRANGE("ED Code Filter", EDDefRec."ED Code");
                                    EndDate := Periods."End Date";
                                    EmployeeRec.SETFILTER("Date Filter", FORMAT(DMY2DATE(1, 1, 1900)) + '..' + FORMAT(EndDate));
                                    EmployeeRec.CALCFIELDS("Amount To Date (LCY)");
                                    CumilativeDec := EmployeeRec."Amount To Date (LCY)";
                                END ELSE
                                    CumilativeDec := 0;

                                CASE EDDefRec."Calculation Group" OF
                                    //skm300507EDDefRec."Calculation Group"::None:
                                    //  "Payroll Lines"."Amount (LCY)" := 0;
                                    EDDefRec."Calculation Group"::Deduction:
                                        BEGIN
                                            IF "Payslip Lines".Negative THEN
                                                "Payroll Lines"."Amount (LCY)" := -"Payroll Lines"."Amount (LCY)"
                                            ELSE
                                                "Payroll Lines"."Amount (LCY)" := "Payroll Lines"."Amount (LCY)";
                                        END;
                                END;

                                TotalAmountDec := TotalAmountDec + "Payroll Lines"."Amount (LCY)";
                            end;

                            trigger OnPreDataItem()
                            begin


                                SETRANGE("Employee No.", Employee."No.");
                                SETRANGE("Payroll ID", Periods."Period ID");
                                SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            IF "Payslip Lines"."Line Type" = 1 THEN BEGIN
                                CASE "Payslip Lines".P9 OF
                                    "Payslip Lines".P9::A:
                                        "Payslip Lines".Amount := HeaderRec."A (LCY)";
                                    "Payslip Lines".P9::B:
                                        "Payslip Lines".Amount := HeaderRec."B (LCY)";
                                    "Payslip Lines".P9::C:
                                        "Payslip Lines".Amount := HeaderRec."C (LCY)";
                                    "Payslip Lines".P9::D:
                                        "Payslip Lines".Amount := HeaderRec."D (LCY)";
                                    "Payslip Lines".P9::E1:
                                        "Payslip Lines".Amount := HeaderRec."E1 (LCY)";
                                    "Payslip Lines".P9::E2:
                                        "Payslip Lines".Amount := HeaderRec."E2 (LCY)";
                                    "Payslip Lines".P9::E3:
                                        "Payslip Lines".Amount := HeaderRec."E3 (LCY)";
                                    "Payslip Lines".P9::F:
                                        "Payslip Lines".Amount := HeaderRec."F (LCY)";
                                    "Payslip Lines".P9::G:
                                        "Payslip Lines".Amount := HeaderRec."G (LCY)";
                                    "Payslip Lines".P9::H:
                                        "Payslip Lines".Amount := HeaderRec."H (LCY)";
                                    "Payslip Lines".P9::J:
                                        "Payslip Lines".Amount := HeaderRec."J (LCY)";
                                    "Payslip Lines".P9::K:
                                        "Payslip Lines".Amount := HeaderRec."K (LCY)";
                                    "Payslip Lines".P9::L:
                                        "Payslip Lines".Amount := HeaderRec."L (LCY)";
                                    "Payslip Lines".P9::M:
                                        "Payslip Lines".Amount := HeaderRec."M (LCY)";
                                END;
                            END;

                            IF "Payslip Lines"."Line Type" = "Payslip Lines"."Line Type"::P9 THEN
                                IsPayslipLineP9 := TRUE
                            ELSE
                                IsPayslipLineP9 := FALSE;
                        end;

                        trigger OnPreDataItem()
                        begin
                            SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        TotalText := 'TOTAL ' + "Payslip Group"."Heading Text";
                        TotalAmountDec := 0;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                    end;
                }
                dataitem(Integer; 2000000026)
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
                    EmpBank := '';

                    IF HeaderRec.GET(Periods."Period ID", Employee."No.") THEN BEGIN
                        HeaderRec.CALCFIELDS("Total Payable (LCY)", "Total Deduction (LCY)", "Total Rounding Pmts (LCY)", "Total Rounding Ded (LCY)");
                        NetPaydec := HeaderRec."Total Payable (LCY)" + HeaderRec."Total Rounding Pmts (LCY)" - (HeaderRec."Total Deduction (LCY)" +
                                     HeaderRec."Total Rounding Ded (LCY)");
                    END ELSE
                        CurrReport.SKIP;

                    EmploNameText := Employee.FullName;

                    Employee.TESTFIELD("Mode of Payment");
                    gvModeofPayment.GET("Mode of Payment");
                    IF gvModeofPayment.Description <> '' THEN
                        NetPayText := 'Net Pay - ' + gvModeofPayment.Description
                    ELSE
                        NetPayText := 'Net Pay - By ' + gvModeofPayment.Code;

                    IF Employee."Bank Code" <> '' THEN
                        IF EmplankAccount.GET(Employee."Bank Code") THEN BEGIN
                            EmpBank := EmplankAccount.Name;
                            AccountNo := Employee."Bank Account No";
                            EmpBankBranch := EmplankAccount.Branch;
                        END;

                    SETFILTER("ED Code Filter", PayrollSetupRec."NSSF ED Code");
                    CALCFIELDS("Membership No.");
                    gvNssfNo := "NSSF No.";
                    SETFILTER("ED Code Filter", PayrollSetupRec."PAYE ED Code");
                    CALCFIELDS("Membership No.");
                    gvPinNo := PIN;
                    SETFILTER("ED Code Filter", PayrollSetupRec."NHIF ED Code");
                    CALCFIELDS("Membership No.");
                    gvNhifNo := "NHIF No.";

                    //AMI 140907 OC023 show Payroll code in the Payslip
                    IF Employee."Calculation Scheme" <> '' THEN BEGIN
                        CalculationHeader.GET(Employee."Calculation Scheme");
                        gvPayrollCode := CalculationHeader."Payroll Code";
                    END;
                end;

                trigger OnPostDataItem()
                begin
                    //AMI 140907 OC023 show Payroll code in the Payslip
                    gvPayrollCode := '';
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");

                    //skm070307 payslip e-mailing
                    IF gvEmployeeNoFilter <> '' THEN SETRANGE("No.", gvEmployeeNoFilter);
                end;
            }

            trigger OnAfterGetRecord()
            var
                lvEmployee: Record 5200;
                // lvDocumentLog: Record 51116;
                lvEntryNo: Integer;
            begin
                /*
                MonthText := Periods.Description;
                //wtm 20110516 function for bulk emailing
                IF SaveinPDF THEN
                    Saveas := Saveas::Pdf;
                IF gvDocumentSetup.GET(gvDocumentSetup."Document Type"::Payslips) THEN
                    IF gvEmployeeNoFilter <> '' THEN
                        lvEmployee.SETFILTER("No.", gvEmployeeNoFilter);
                IF lvEmployee.FINDFIRST THEN
                    REPEAT
                        CLEAR(rptpayslip);

                        rptpayslip.sSetParameters(gvPeriodIDFilter, gvEmployeeNoFilter);
                        rptpayslip.USEREQUESTPAGE := FALSE;

                        IF gvDocumentSetup."Document Folder" <> '' THEN
                            fpath := gvDocumentSetup."Document Folder"
                        ELSE
                            fpath := TEMPORARYPATH + '\';

                        IF ISSERVICETIER THEN BEGIN
                          IF Saveas = Saveas ::Pdf THEN
                            fpath:=fpath +lvEmployee."No."+ '.pdf';
                          {ELSE IF Saveas = Saveas ::Excel THEN
                            fpath:=fpath +lvEmployee."No."+ '.Xls'}
                          {ELSE IF Saveas = Saveas ::Html THEN
                            fpath:=fpath +lvEmployee."No."+ '.html'
                          ELSE IF Saveas = Saveas ::" " THEN
                            fpath:=fpath +lvEmployee."No."+ '.html'}
                        END;*/ //ELSE BEGIN
                               /*IF Saveas = Saveas ::Pdf THEN

                                 ERROR('You Cannot Save in PDF in Classic Client')

                               //  fpath:=fpath +lvEmployee."No."+ '.pdf'
                               ELSE
                                 fpath:=fpath +lvEmployee."No."+ '.html';
                               END;

                        IF EXISTS(fpath) THEN ERASE(fpath);
                        IF ISSERVICETIER THEN BEGIN
                            IF ReportIDVal = 0 THEN BEGIN
                                IF Saveas = Saveas::Pdf THEN
                                    REPORT.SAVEASPDF(ReportIDVal, fpath, Periods);
                            END;
                        END;
                        */
                               /*ELSE IF Saveas = Saveas :: Excel THEN
                                REPORT.SAVEASEXCEL(ReportIDVal,fpath,Periods)*/
                               /*ELSE IF Saveas = Saveas :: Html THEN
                                 REPORT.SAVEASHTML(ReportIDVal,fpath,Periods)

                               ELSE IF Saveas = Saveas :: " " THEN
                                 REPORT.SAVEASHTML(ReportIDVal,fpath,Periods)*/

                /*END ELSE BEGIN
                  IF Saveas = Saveas :: Pdf THEN
                    REPORT.SAVEASPDF(ReportIDVal,fpath,Periods)
                  ELSE IF Saveas = Saveas :: Excel THEN
                    REPORT.SAVEASEXCEL(ReportIDVal,fpath,Periods)
                  {ELSE IF Saveas = Saveas :: Html THEN
                    REPORT.SAVEASHTML(ReportIDVal,fpath,Periods)
                  ELSE IF Saveas = Saveas :: " " THEN
                    REPORT.SAVEASHTML(ReportIDVal,fpath,Periods)}
                END;*/
                /*END ELSE BEGIN
                  IF ReportIDVal > 0 THEN BEGIN
                    IF Saveas = Saveas ::Pdf THEN
                      REPORT.SAVEASPDF(ReportIDVal,fpath,Periods);

                    {ELSE
                     REPORT.SAVEASHTML(ReportIDVal,fpath,Periods)}
                  END ELSE BEGIN
                    IF Saveas = Saveas ::Pdf THEN
                      REPORT.SAVEASPDF(ReportIDVal,fpath,Periods)
                    {ELSE
                      REPORT.SAVEASHTML(ReportIDVal,fpath,Periods);}
                  END;
                END;



                //First get the entry No
                IF EXISTS(fpath) THEN BEGIN
                IF lvDocumentLog.FINDLAST THEN
                    lvEntryNo := lvDocumentLog."Entry No" + 1
                ELSE
                    lvEntryNo := 1;

                lvDocumentLog.INIT;
                lvDocumentLog."Entry No" := lvEntryNo;
                lvDocumentLog."Account Type" := lvDocumentLog."Account Type"::Employee;
                lvDocumentLog."Account No." := lvEmployee."No.";
                lvDocumentLog.Document.IMPORT(fpath);
                lvDocumentLog."E-mailed To" := lvEmployee."E-Mail";
                lvDocumentLog.DateTime := CURRENTDATETIME;
                lvDocumentLog."Document Type" := lvDocumentLog."Document Type"::Payslips;
                IF ISSERVICETIER THEN
                    lvDocumentLog."File Extension" := 'pdf'
                ELSE BEGIN
                    IF Saveas = Saveas::Pdf THEN
                        lvDocumentLog."File Extension" := 'pdf'
                    /*ELSE
                      lvDocumentLog."File Extension":= 'html'
                END;
                lvDocumentLog."Document No" := lvEmployee."No.";
                lvDocumentLog.Send := TRUE;
                lvDocumentLog.INSERT;
                COMMIT;
            END;
                    UNTIL lvEmployee.NEXT = 0;


                MESSAGE('Report Generation Completed!');
                //Exit quitely in style
                ERROR('');
                //wtm
*/
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");

                //skm070307 payslip e-mailing
                IF gvPeriodIDFilter <> '' THEN SETRANGE("Period ID", gvPeriodIDFilter);
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

    trigger OnPostReport()
    var
        lvEmployee: Record 5200;
        // lvDocumentLog: Record 51116;
        lvEntryNo: Integer;
    begin
    end;

    trigger OnPreReport()
    begin
        gsSegmentPayrollData;
        PayrollSetupRec.GET(gvAllowedPayrolls."Payroll Code");
        CompanyNameText := PayrollSetupRec."Employer Name";
        PeriodRec.SETCURRENTKEY("Start Date");
        PeriodRec.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
        PeriodRec.FIND('-');


        gvPeriodIDFilter := Employee.GETFILTER("Period Filter");
    end;

    var
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
        PeriodRec: Record 51151;
        EmployeeRec: Record 5200;
        PayrollSetupRec: Record 51165;
        HeaderRec: Record 51159;
        EDDefRec: Record 51158;
        TotalText: Text[60];
        NetPayText: Text[60];
        MonthText: Text[60];
        EmploNameText: Text[100];
        CompanyNameText: Text[100];
        TotalAmountDec: Decimal;
        NetPaydec: Decimal;
        CumilativeDec: Decimal;
        EmplankAccount: Record 51152;
        EmpBank: Text[30];
        AccountNo: Text[30];
        EmpBankBranch: Text[30];
        gvNhifNo: Code[20];
        gvNssfNo: Code[20];
        gvPinNo: Code[20];
        EndDate: Date;
        gvAllowedPayrolls: Record 51182;
        gvModeofPayment: Record 51187;
        gvPeriodIDFilter: Code[100];
        gvEmployeeNoFilter: Code[100];
        CalculationHeader: Record 51153;
        gvPayrollCode: Text[30];
        IsPayslipLineP9: Boolean;
        PayslipFooter: Text[100];
        CompInfo: Record 79;
        CompanyInfo2: Record 79;
        ReportIDVal: Integer;
        Saveas: Option " ",Pdf,Excel,Html;
        SaveinPDF: Boolean;
        [InDataSet]
        LogInteractionEnable: Boolean;
        LogInteraction: Boolean;
        ShowInternalInfo: Boolean;
        gvEmployeeFilter: Text[30];
        gvHeaderRec: Record 51159;
        rptpayslip: Report 51150;
        gvemployee: Record 5200;
        tempemployee: Record 5200;
        Period: Record 51151;
        lvEmployee: Record 5200;
        fpath: Text[250];
        // gvDocumentSetup: Record 51117;
        fPath1: Text[250];

    procedure sSetParameters(pPeriodIDFilter: Code[10]; pEmployeeNoFilter: Code[10])
    begin
        //skm080307 this function sets global parameters for filtering the payslip when e-mailing
        gvPeriodIDFilter := pPeriodIDFilter;
        gvEmployeeNoFilter := pEmployeeNoFilter;
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

