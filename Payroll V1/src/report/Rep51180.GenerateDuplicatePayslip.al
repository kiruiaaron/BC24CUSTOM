report 51180 "Generate Duplicate Payslip"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Periods; 51151)
        {
            DataItemTableView = SORTING("Start Date")
                                ORDER(Ascending)
                                WHERE(Status = FILTER(Open | Posted));
            RequestFilterFields = "Period ID";
            dataitem(Employee; 5200)
            {
                DataItemTableView = SORTING("No.")
                                    ORDER(Ascending);
                RequestFilterFields = "No.", "Membership No.";
                dataitem("Payslip Group"; 51173)
                {
                    DataItemTableView = SORTING(Code);
                    dataitem("Payslip Lines"; 51174)
                    {
                        DataItemLink = "Payslip Group" = FIELD(Code);
                        DataItemTableView = SORTING("Line No.", "Payslip Group");
                        dataitem("Payroll Lines"; 51160)
                        {
                            DataItemLink = "ED Code" = FIELD("E/D Code");
                            DataItemTableView = SORTING("Payroll ID", "Employee No.")
                                                ORDER(Ascending);

                            trigger OnAfterGetRecord()
                            begin
                                EDDefRec.GET("ED Code");
                                IF EDDefRec.Cumulative THEN BEGIN
                                    EmployeeRec.GET(Employee."No.");
                                    EmployeeRec.SETRANGE("ED Code Filter", "ED Code");
                                    EmployeeRec.SETFILTER("Date Filter", '%1..%2', PeriodRec."Start Date", Periods."End Date");
                                    EmployeeRec.CALCFIELDS("Amount To Date");
                                    CumilativeDec := EmployeeRec."Amount To Date";
                                END ELSE
                                    CumilativeDec := 0;

                                CASE EDDefRec."Calculation Group" OF
                                    EDDefRec."Calculation Group"::None://None
                                                                       /*IF "Payroll Lines"."ED Code"='TAXRELEIF' THEN
                                                                         "Payslip Lines".Amount:="Payroll Lines".Amount*-1
                                                                       ELSE*/
                                        "Payroll Lines".Amount := "Payroll Lines".Amount;
                                    EDDefRec."Calculation Group"::Deduction:
                                        IF "Payslip Lines".Negative THEN
                                            "Payroll Lines".Amount := -"Payroll Lines".Amount
                                        ELSE
                                            "Payroll Lines".Amount := "Payroll Lines".Amount;
                                END;

                                TotalAmountDec := TotalAmountDec + "Payroll Lines".Amount;
                                TotalLine := FALSE;

                                // cmm 070813 from sections
                                IF ("Loan Entry") AND (Amount <> 0) THEN AddModifyTriplicateRec(Text, Amount);
                                //end cmm

                            end;

                            trigger OnPreDataItem()
                            begin
                                SETRANGE("Employee No.", Employee."No.");
                                SETRANGE("Payroll ID", Periods."Period ID");
                                SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                            end;
                        }

                        trigger OnAfterGetRecord()
                        var
                            lvPayrollLines: Record 51160;
                            enddate: Date;
                        begin
                            IF "Line Type" = "Line Type"::P9 THEN BEGIN
                                CASE P9 OF
                                    P9::A:
                                        Amount := HeaderRec."A (LCY)";
                                    P9::B:
                                        Amount := HeaderRec."B (LCY)";
                                    P9::C:
                                        Amount := HeaderRec."C (LCY)";
                                    P9::D:
                                        Amount := HeaderRec."D (LCY)";
                                    P9::E1:
                                        Amount := HeaderRec."E1 (LCY)";
                                    P9::E2:
                                        Amount := HeaderRec."E2 (LCY)";
                                    P9::E3:
                                        Amount := HeaderRec."E3 (LCY)";
                                    P9::F:
                                        Amount := HeaderRec."F (LCY)";
                                    P9::G:
                                        Amount := HeaderRec."G (LCY)";
                                    P9::H:
                                        Amount := HeaderRec."H (LCY)";
                                    P9::J:
                                        Amount := HeaderRec."J (LCY)";
                                    P9::K:
                                        Amount := HeaderRec."K (LCY)";
                                    P9::L:
                                        Amount := HeaderRec."L (LCY)";
                                    P9::M:
                                        Amount := HeaderRec."M (LCY)";
                                END;
                                P9Amount := Amount;
                                AddModifyTriplicateRec("P9 Text", P9Amount);
                            END;

                            //Sum all Payroll lines for the same ED.
                            gvAmount := 0;
                            gvRate := 0;
                            gvCumilative := 0;
                            EDText := '';
                            gvQuantity := 0;
                            IF "Payslip Lines"."Line Type" = "Payslip Lines"."Line Type"::"E/D code" THEN BEGIN

                                lvPayrollLines.SETRANGE("Employee No.", Employee."No.");
                                lvPayrollLines.SETRANGE("Payroll ID", Periods."Period ID");
                                //lvPayrollLines.Rec.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                                lvPayrollLines.SETRANGE("Loan Entry", FALSE);
                                lvPayrollLines.SETRANGE("ED Code", "Payslip Lines"."E/D Code");

                                IF lvPayrollLines.FIND('-') THEN BEGIN
                                    EDText := lvPayrollLines.Text;
                                    gvRate := lvPayrollLines.Rate;

                                    EDDefRec.GET("Payslip Lines"."E/D Code");

                                    IF EDDefRec.Cumulative THEN BEGIN
                                        EmployeeRec.GET(Employee."No.");
                                        EmployeeRec.SETRANGE("ED Code Filter", EDDefRec."ED Code");
                                        enddate := Periods."End Date";
                                        EmployeeRec.SETFILTER("Date Filter", FORMAT(DMY2DATE(1, 1, 1900)) + '..' + FORMAT(enddate));
                                        EmployeeRec.CALCFIELDS("Amount To Date (LCY)");
                                        gvCumilative := EmployeeRec."Amount To Date (LCY)";
                                    END ELSE
                                        gvCumilative := 0;
                                END;

                                IF lvPayrollLines.FIND('-') THEN
                                    REPEAT
                                        gvQuantity := gvQuantity + lvPayrollLines.Quantity;
                                        gvAmount := gvAmount + lvPayrollLines.Amount;
                                    UNTIL lvPayrollLines.NEXT = 0;

                            END;

                            //cmm 070813 from sections
                            IF gvAmount <> 0 THEN AddModifyTriplicateRec(EDText, gvAmount);
                            IF ("Line Type" = 0) AND (Amount <> 0) THEN AddModifyTriplicateRec("P9 Text", Amount);
                            //end cmm
                        end;

                        trigger OnPostDataItem()
                        var
                            lvPayslipGroup: Record 51173;
                        begin
                            //cmm 070813 from sections
                            TotalLine := TRUE;
                            lvPayslipGroup.RESET;
                            lvPayslipGroup.SETRANGE("Payroll Code", "Payslip Lines"."Payroll Code");
                            lvPayslipGroup.SETRANGE(Code, "Payslip Lines"."Payslip Group");
                            IF (lvPayslipGroup."Include Total For Group") AND (TotalAmountDec <> 0) THEN AddModifyTriplicateRec(TotalText, TotalAmountDec);
                            TotalLine := FALSE;
                            //end cmm
                        end;

                        trigger OnPreDataItem()
                        begin
                            SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        TotalText := 'TOTAL ' + "Heading Text";
                        TotalAmountDec := 0;

                        //cmm 070813 from sections
                        BlankLine := '-------------------------------------------------------------------------------------------------------------';
                        AddModifyTriplicateRec(BlankLine, 0);
                        AddModifyTriplicateRec("Heading Text", 0);
                        //end cmm
                    end;

                    trigger OnPreDataItem()
                    begin
                        SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                    end;
                }
                dataitem(DataItem5444; 2000000026)
                {
                    DataItemTableView = SORTING(Number);
                    MaxIteration = 1;

                    trigger OnAfterGetRecord()
                    begin
                        TotalLine := TRUE;
                        IF NetPaydec > 0 THEN BEGIN
                            AddModifyTriplicateRec('--------------', 0);
                            AddModifyTriplicateRec('Net Pay ', NetPaydec);
                            AddModifyTriplicateRec(NetPayText, 0);
                            AddModifyTriplicateRec('--------------', 0);
                        END ELSE BEGIN
                            AddModifyTriplicateRec('--------------', 0);
                            AddModifyTriplicateRec('Over Drawn ', NetPaydec);
                            AddModifyTriplicateRec('--------------', 0);
                        END;
                        TotalLine := FALSE;
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    blnOK: Boolean;
                    Steps: Integer;
                begin
                    IF HeaderRec.GET(Periods."Period ID", "No.") THEN BEGIN
                        HeaderRec.CALCFIELDS("Total Payable (LCY)", "Total Deduction (LCY)", "Total Rounding Pmts (LCY)", "Total Rounding Ded (LCY)");
                        NetPaydec := HeaderRec."Total Payable (LCY)" + HeaderRec."Total Rounding Pmts (LCY)" - (HeaderRec."Total Deduction (LCY)" +
                                     HeaderRec."Total Rounding Ded (LCY)");
                    END ELSE
                        CurrReport.SKIP;

                    Window.UPDATE(2, "No.");
                    EmploNameText := FullName;

                    BankText := '';
                    AccountText := '';
                    //AA No payments into bank for AAFH
                    /*
                    IF "Bank Code" <> '' THEN BEGIN
                      EmpBank.GET("Bank Code");
                      BankText := UPPERCASE(EmpBank.Name);
                      AccountText := "Bank Account No.";
                      NetPayText := 'PAID INTO BANK';
                    END ELSE BEGIN
                    */
                    gvModeofPayment.GET(Employee."Mode of Payment");
                    BankText := Employee."Mode of Payment";
                    AccountText := '';
                    IF gvModeofPayment.Description <> '' THEN
                        NetPayText := gvModeofPayment.Description
                    ELSE
                        NetPayText := gvModeofPayment.Code;
                    //END;

                    //cmm 070813 from Sections

                    PayslipLineNoCounter := 0; //Reset individual payslip lines counter

                    //choose payslip set and current payslip in set
                    IF PayslipNoInSet = 2 THEN BEGIN
                        PayslipNoInSet := 1;
                        LargestLineNoInSet := 0;
                        LargestSetNo := LargestSetNo + 1
                    END ELSE
                        PayslipNoInSet := PayslipNoInSet + 1;

                    //Move to first line in payslip set
                    IF LargestSetNo > 1 THEN BEGIN
                        TriplicatePayslipRec.RESET;
                        TriplicatePayslipRec.SETRANGE("Payslip Set", LargestSetNo);
                        TriplicatePayslipRec.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                        blnOK := TriplicatePayslipRec.FIND('-');
                        blnOnFirstLineInSet := TRUE
                    END ELSE
                        IF PayslipNoInSet > 1 THEN BEGIN
                            blnOK := TriplicatePayslipRec.FIND('-');
                            blnOnFirstLineInSet := TRUE
                        END

                    //end cmm

                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                MonthText := Description;
                Window.UPDATE(1, "Period ID");
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                Window.OPEN('Processing\' +
                            'Period   #1#########\' +
                            'Employee #2#########');
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
    begin
        Window.CLOSE;
    end;

    trigger OnPreReport()
    begin
        gsSegmentPayrollData;
        PayrollSetupRec.GET(gvAllowedPayrolls."Payroll Code");

        //TriplicatePayslipRec.Rec.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
        TriplicatePayslipRec.DELETEALL;
        LargestLineNoInSet := 0;
        LargestSetNo := 1;
        PayslipNoInSet := 0;

        CompanyNameText := PayrollSetupRec."Employer Name";
        PeriodRec.SETCURRENTKEY("Start Date");
        PeriodRec.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
        PeriodRec.FIND('-');
    end;

    var
        blnOnFirstLineInSet: Boolean;
        TriplicatePayslipRec: Record 51183;
        PayslipLineNoCounter: Integer;
        LargestLineNoInSet: Integer;
        PayslipNoInSet: Integer;
        LargestSetNo: Integer;
        PeriodRec: Record 51151;
        EmployeeRec: Record 5200;
        PayrollSetupRec: Record 51165;
        HeaderRec: Record 51159;
        EDDefRec: Record 51158;
        TotalText: Text[60];
        BlankLine: Text[250];
        NetPayText: Text[60];
        BankText: Text[200];
        AccountText: Text[30];
        MonthText: Text[60];
        EmploNameText: Text[100];
        CompanyNameText: Text[100];
        TotalAmountDec: Decimal;
        NetPaydec: Decimal;
        CumilativeDec: Decimal;
        Window: Dialog;
        P9Amount: Decimal;
        EmpBank: Record 51152;
        TotalLine: Boolean;
        gvAllowedPayrolls: Record 51182;
        gvModeofPayment: Record 51187;
        gvAmount: Decimal;
        EDText: Text[100];
        gvQuantity: Decimal;
        gvCumilative: Decimal;
        gvRate: Decimal;

    procedure AddModifyTriplicateRec(parDescription: Text[250]; parAmnt: Decimal)
    var
        BankRec: Record 51152;
    begin
        CASE PayslipNoInSet OF
            1:
                BEGIN
                    PayslipLineNoCounter := PayslipLineNoCounter + 1;
                    LargestLineNoInSet := LargestLineNoInSet + 1;

                    TriplicatePayslipRec.INIT;
                    TriplicatePayslipRec.Rate1 := "Payroll Lines".Rate;
                    TriplicatePayslipRec.Qty1 := "Payroll Lines".Quantity;
                    TriplicatePayslipRec.Cumm1 := CumilativeDec;
                    TriplicatePayslipRec.Bal1 := 0;
                    TriplicatePayslipRec."Payslip Set" := LargestSetNo;
                    TriplicatePayslipRec."Line No" := PayslipLineNoCounter;
                    TriplicatePayslipRec.Employee1 := Employee."No.";
                    TriplicatePayslipRec."Period Name1" := Periods.Description;
                    TriplicatePayslipRec.Description1 := parDescription;
                    TriplicatePayslipRec.Amount1 := parAmnt;
                    TriplicatePayslipRec.Period := Periods."Period ID";
                    TriplicatePayslipRec.Title1 := Employee."Job Title";
                    TriplicatePayslipRec.Department1 := Employee."Global Dimension 1 Code";
                    IF BankRec.GET(Employee."Bank Code") THEN BEGIN
                        TriplicatePayslipRec.Bank1 := BankRec.Name;
                        TriplicatePayslipRec.Branch1 := BankRec.Branch;
                        TriplicatePayslipRec.Account1 := Employee."Bank Account No";
                    END ELSE
                        TriplicatePayslipRec.Bank1 := BankText;

                    Employee.SETFILTER("ED Code Filter", PayrollSetupRec."PAYE ED Code");
                    Employee.CALCFIELDS("Membership No.");
                    TriplicatePayslipRec.PIN1 := Employee.PIN;

                    Employee.SETFILTER("ED Code Filter", PayrollSetupRec."NHIF ED Code");
                    Employee.CALCFIELDS("Membership No.");
                    TriplicatePayslipRec.NHIF1 := Employee.PIN;

                    Employee.SETFILTER("ED Code Filter", PayrollSetupRec."NSSF ED Code");
                    Employee.CALCFIELDS("Membership No.");
                    TriplicatePayslipRec.NSSF1 := Employee.PIN;

                    IF "Payroll Lines"."Loan Entry" THEN BEGIN
                        TriplicatePayslipRec.Rate1 := "Payroll Lines".Repayment;
                        TriplicatePayslipRec.Qty1 := "Payroll Lines".Interest;
                        TriplicatePayslipRec.Cumm1 := "Payroll Lines"."Remaining Debt";
                    END;

                    //Don't print amounts if its a blank line or heading
                    IF (parAmnt = 0) OR TotalLine THEN BEGIN
                        TriplicatePayslipRec.Rate1 := 0;
                        TriplicatePayslipRec.Qty1 := 0;
                        TriplicatePayslipRec.Cumm1 := 0;
                        TriplicatePayslipRec.Bal1 := 0;
                    END;

                    TriplicatePayslipRec."Payroll Code" := gvAllowedPayrolls."Payroll Code";
                    TriplicatePayslipRec.INSERT;
                END;

            2:
                BEGIN
                    PayslipLineNoCounter := PayslipLineNoCounter + 1;

                    IF PayslipLineNoCounter > LargestLineNoInSet THEN BEGIN
                        TriplicatePayslipRec.INIT;
                        TriplicatePayslipRec."Payslip Set" := LargestSetNo;
                        TriplicatePayslipRec."Line No" := PayslipLineNoCounter;
                        TriplicatePayslipRec.Period := Periods."Period ID";
                    END;

                    IF blnOnFirstLineInSet THEN
                        blnOnFirstLineInSet := FALSE
                    ELSE
                        IF PayslipLineNoCounter <= LargestLineNoInSet THEN
                            TriplicatePayslipRec.NEXT;
                    TriplicatePayslipRec.Rate2 := "Payroll Lines".Rate;
                    TriplicatePayslipRec.Qty2 := "Payroll Lines".Quantity;
                    TriplicatePayslipRec.Cumm2 := CumilativeDec;
                    TriplicatePayslipRec.Bal2 := 0;
                    TriplicatePayslipRec.Employee2 := Employee."No.";
                    TriplicatePayslipRec."Period Name2" := Periods.Description;
                    TriplicatePayslipRec.Description2 := parDescription;
                    TriplicatePayslipRec.Amount2 := parAmnt;
                    TriplicatePayslipRec.Title2 := Employee."Job Title";
                    TriplicatePayslipRec.Department1 := Employee."Global Dimension 1 Code";
                    IF BankRec.GET(Employee."Bank Code") THEN BEGIN
                        TriplicatePayslipRec.Bank2 := BankRec.Name;
                        TriplicatePayslipRec.Branch2 := BankRec.Branch;
                        TriplicatePayslipRec.Account2 := Employee."Bank Account No";
                    END ELSE
                        TriplicatePayslipRec.Bank2 := BankText;

                    Employee.SETFILTER("ED Code Filter", PayrollSetupRec."PAYE ED Code");
                    Employee.CALCFIELDS("Membership No.");
                    TriplicatePayslipRec.PIN2 := Employee."Membership No.";

                    Employee.SETFILTER("ED Code Filter", PayrollSetupRec."NHIF ED Code");
                    Employee.CALCFIELDS("Membership No.");
                    TriplicatePayslipRec.NHIF2 := Employee."Membership No.";

                    Employee.SETFILTER("ED Code Filter", PayrollSetupRec."NSSF ED Code");
                    Employee.CALCFIELDS("Membership No.");
                    TriplicatePayslipRec.NSSF2 := Employee."Membership No.";

                    IF "Payroll Lines"."Loan Entry" THEN BEGIN
                        TriplicatePayslipRec.Rate2 := "Payroll Lines".Repayment;
                        TriplicatePayslipRec.Qty2 := "Payroll Lines".Interest;
                        TriplicatePayslipRec.Cumm2 := "Payroll Lines"."Remaining Debt";
                    END;

                    //Don't print amounts if its a blank line or heading
                    IF (parAmnt = 0) OR TotalLine THEN BEGIN
                        TriplicatePayslipRec.Rate2 := 0;
                        TriplicatePayslipRec.Qty2 := 0;
                        TriplicatePayslipRec.Cumm2 := 0;
                        TriplicatePayslipRec.Bal2 := 0;
                    END;

                    IF PayslipLineNoCounter > LargestLineNoInSet THEN BEGIN
                        TriplicatePayslipRec.INSERT;
                        LargestLineNoInSet := LargestLineNoInSet + 1;
                    END ELSE
                        TriplicatePayslipRec.MODIFY
                END;

        END; //Case

        TotalLine := TRUE;
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

