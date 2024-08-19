codeunit 51154 "Table Code Transferred-Payroll"
{


    trigger OnRun()
    begin
    end;

    var
        Text001: Label 'Replace existing attachment?';
        Text002: Label 'You have canceled the import process.';
        Text006: Label 'Import Attachment';
        Text007: Label 'All Files (*.*)|*.*';
        Text008: Label 'Error during copying file.';
        gvCurrExchRate: Record 330;
        gvPayrollUtilities: Codeunit 51152;
        ObjectType2: Option TableData,"Table","Report","Codeunit","XMLPort",Menusuite,"Page";

    procedure PayrollEntryCalcAmount(var prPayrollEntry: Record 51161)
    begin
        prPayrollEntry.VALIDATE(Amount, prPayrollEntry.Rate * prPayrollEntry.Quantity);
        prPayrollEntry.SetHeaderFalse;
    end;

    procedure PayrollEntrySetHeaderFalse(var prPayrollEntry: Record 51161)
    var
        Header: Record 51159;
    begin
        IF Header.GET(prPayrollEntry."Payroll ID", prPayrollEntry."Employee No.") THEN BEGIN
            IF Header.Calculated = TRUE THEN BEGIN
                Header.Calculated := FALSE;
                Header.MODIFY;
            END;
        END;
    end;

    procedure PayrollEntryShowDimensions(var prPayrollEntry: Record 51161)
    var
        PayrollDim: Record 51184;
        PayrollDimensions: Page 51199;
    begin
        prPayrollEntry.TESTFIELD("Entry No.");
        prPayrollEntry.TESTFIELD("ED Code");
        prPayrollEntry.TESTFIELD("Payroll ID");
        prPayrollEntry.TESTFIELD("Employee No.");
        prPayrollEntry.TESTFIELD("Payroll Code");

        PayrollDim.SETRANGE("Table ID", DATABASE::"Payroll Entry");
        PayrollDim.SETRANGE("Payroll ID", prPayrollEntry."Payroll ID");
        PayrollDim.SETRANGE("Employee No", prPayrollEntry."Employee No.");
        PayrollDim.SETRANGE("ED Code", prPayrollEntry."ED Code");
        PayrollDim.SETRANGE("Payroll Code", prPayrollEntry."Payroll Code");
        PayrollDim.SETRANGE("Entry No", prPayrollEntry."Entry No.");
        PayrollDimensions.SETTABLEVIEW(PayrollDim);
        PayrollDimensions.RUNMODAL;
    end;

    procedure PayrollEntryEDCodeValidate(var prPayrollEntry: Record 51161; var xprPayrollEntry: Record 51161)
    var
        EDCodeRec: Record 51158;
        Employee: Record 5200;
        CalcSchemes: Record 51154;
        lvPayrollHdr: Record 51159;
        lvRoundDirection: Text[1];
        PayrollSetupRec: Record 51165;
        LineRate: Decimal;
        PayrollUtilities: Codeunit 51152;
        Periods: Record 51151;
    begin
        IF EDCodeRec.GET(prPayrollEntry."ED Code") THEN BEGIN
            prPayrollEntry.Text := EDCodeRec.Description;
            prPayrollEntry."Copy to next" := EDCodeRec."Copy to next";
            prPayrollEntry."Reset Amount" := EDCodeRec."Reset Amount";
            prPayrollEntry.Absence := EDCodeRec.Absence;
        END;

        IF prPayrollEntry."Employee No." <> '' THEN BEGIN
            Employee.GET(prPayrollEntry."Employee No.");
            CalcSchemes.SETRANGE("Scheme ID", Employee."Calculation Scheme");
            CalcSchemes.SETCURRENTKEY("Payroll Entry");
            CalcSchemes.SETRANGE("Payroll Entry", EDCodeRec."ED Code");

            IF NOT CalcSchemes.FIND('-') THEN
                IF NOT EDCodeRec."System Created" THEN
                    ERROR('The ED Code %1 does not exits in the Calculation Scheme %2', EDCodeRec."ED Code", Employee."Calculation Scheme");

            //Direct Overtime Entry
            IF EDCodeRec.GET(prPayrollEntry."ED Code") THEN
                IF EDCodeRec."Overtime ED" THEN BEGIN
                    PayrollSetupRec.GET(prPayrollEntry."Payroll Code");
                    CASE PayrollSetupRec."Hourly Rate Rounding" OF
                        PayrollSetupRec."Hourly Rate Rounding"::None:
                            lvRoundDirection := '=';
                        PayrollSetupRec."Hourly Rate Rounding"::Up:
                            lvRoundDirection := '>';
                        PayrollSetupRec."Hourly Rate Rounding"::Down:
                            lvRoundDirection := '<';
                        PayrollSetupRec."Hourly Rate Rounding"::Nearest:
                            lvRoundDirection := '=';
                    END;

                    lvPayrollHdr.GET(prPayrollEntry."Payroll ID", prPayrollEntry."Employee No.");
                    lvPayrollHdr.TESTFIELD("Hour Rate");
                    LineRate := ROUND(EDCodeRec."Overtime ED Weight" * lvPayrollHdr."Hour Rate",
                      PayrollSetupRec."Hourly Rounding Precision", lvRoundDirection);
                    prPayrollEntry.VALIDATE(Rate, LineRate);
                    //MODIFY;
                END;
            //Direct Overtime Entry
        END;

        IF prPayrollEntry.Absence THEN BEGIN
            PayrollSetupRec.GET(prPayrollEntry."Payroll Code");
            CASE PayrollSetupRec."Hourly Rate Rounding" OF
                PayrollSetupRec."Hourly Rate Rounding"::None:
                    lvRoundDirection := '=';
                PayrollSetupRec."Hourly Rate Rounding"::Up:
                    lvRoundDirection := '>';
                PayrollSetupRec."Hourly Rate Rounding"::Down:
                    lvRoundDirection := '<';
                PayrollSetupRec."Hourly Rate Rounding"::Nearest:
                    lvRoundDirection := '=';
            END;
            lvPayrollHdr.GET(prPayrollEntry."Payroll ID", prPayrollEntry."Employee No.");
            Periods.GET(lvPayrollHdr."Payroll ID", lvPayrollHdr."Payroll Month", lvPayrollHdr."Payroll Year", prPayrollEntry."Payroll Code");
            LineRate := ROUND(lvPayrollHdr."Basic Pay" / Periods.Hours,
                     PayrollSetupRec."Hourly Rounding Precision", lvRoundDirection);
            prPayrollEntry.VALIDATE(Rate, LineRate);
        END;

        //skm310506 Advanced Dimensions
        IF (xprPayrollEntry."ED Code" <> prPayrollEntry."ED Code") AND (prPayrollEntry."Employee No." <> '') THEN BEGIN
            PayrollUtilities.sDeleteDefaultEDDims(prPayrollEntry);
            PayrollUtilities.sGetDefaultEDDims(prPayrollEntry);
        END;
    end;

    procedure LookupTableLinesCalcCum(var prLookupTableLine: Record 51163; var TableLinesRec: Record 51163)
    var
        TableLines: Record 51163;
    begin
        IF prLookupTableLine.Percent <> 0 THEN BEGIN
            TableLines.COPY(TableLinesRec);
            TableLines.SETRANGE("Table ID", TableLinesRec."Table ID");
            IF TableLines.FIND('<') THEN
                prLookupTableLine."Cumulate (LCY)" := TableLines."Cumulate (LCY)" + (((prLookupTableLine."Upper Amount (LCY)" -
                prLookupTableLine."Lower Amount (LCY)") * prLookupTableLine.Percent) / 100)
            ELSE
                prLookupTableLine."Cumulate (LCY)" := (((prLookupTableLine."Upper Amount (LCY)" - prLookupTableLine."Lower Amount (LCY)") * prLookupTableLine.Percent) / 100)
        END;
    end;

    procedure LookupTableLinesCalcCumEthiopia(var prLookupTableLine: Record 51163; var TableLinesRec: Record 51163)
    var
        TableLines: Record 51163;
    begin
        IF prLookupTableLine.Percent <> 0 THEN BEGIN
            TableLines.COPY(TableLinesRec);
            TableLines.SETRANGE("Table ID", TableLinesRec."Table ID");
            IF TableLines.FIND('<') THEN
                prLookupTableLine."Cumulate (LCY)" := (TableLines."Cumulate (LCY)" +
                                 (((prLookupTableLine."Upper Amount (LCY)" - prLookupTableLine."Lower Amount (LCY)") * prLookupTableLine.Percent) / 100)) -
                                 prLookupTableLine."Relief Amount"
            ELSE
                prLookupTableLine."Cumulate (LCY)" := ((((prLookupTableLine."Upper Amount (LCY)" - prLookupTableLine."Lower Amount (LCY)") * prLookupTableLine.Percent) / 100))
                                  - prLookupTableLine."Relief Amount"
        END;
    end;

    procedure PaySetupImport(var prPayrollSetup: Record 51165)
    begin
        prPayrollSetup.CALCFIELDS("KRA Tax Logo");
        IF prPayrollSetup."KRA Tax Logo".HASVALUE THEN BEGIN
            IF NOT CONFIRM(Text001, FALSE) THEN
                EXIT;
            prPayrollSetup.RemoveAttachment(FALSE);
        END;

        IF NOT prPayrollSetup.ImportAttachment('', FALSE, FALSE) THEN
            ERROR(Text002);
    end;

    procedure PaySetupImportAttachment(var prPayrollSetup: Record 51165; ImportFromFile: Text[260]; IsTemporary: Boolean; IsInherited: Boolean): Boolean
    var
        FileName: Text[260];
        AttachmentManagement: Codeunit 5052;
        ClientFileName: Text[260];
        NewAttachmentNo: Integer;
        //  BLOBRef: Record 99008535;
        RBAutoMgt: Codeunit 419;
        ServerFileName: Text[260];
    begin
        IF IsTemporary THEN BEGIN
            //  FileName := RBAutoMgt.BLOBImport(BLOBRef, ImportFromFile);
            //RBAutoMgt.BLOBImport(BLOBRef,ImportFromFile,ImportFromFile = '' );
            IF FileName <> '' THEN BEGIN
                //  prPayrollSetup."KRA Tax Logo" := BLOBRef.Blob;
                prPayrollSetup."File Extension" := COPYSTR(UPPERCASE(RBAutoMgt.GetExtension(FileName)), 1, 250);
                EXIT(TRUE);
            END ELSE
                EXIT(FALSE);
        END;
        ClientFileName := '';

        FileName := ImportFromFile;

        //FileName := RBAutoMgt.BLOBImport(BLOBRef, FileName);
        IF FileName = '' THEN
            EXIT(FALSE);
        //     prPayrollSetup."KRA Tax Logo" := BLOBRef.Blob;
        prPayrollSetup."File Extension" := COPYSTR(UPPERCASE(RBAutoMgt.GetExtension(FileName)), 1, 250);
        IF prPayrollSetup.MODIFY THEN;
        EXIT(TRUE);
    end;

    procedure PaySetupExportAttachment(var prPayrollSetup: Record 51165; ExportToFile: Text[1024]): Boolean
    var
        //    BLOBRef: Record 99008535;
        RBAutoMgt: Codeunit 419;
        FileName: Text[1024];
        FileFilter: Text[260];
        ClientFileName: Text[1024];
        FileMgt: Codeunit 419;
    begin
        ClientFileName := '';
        prPayrollSetup.CALCFIELDS("KRA Tax Logo");
        IF prPayrollSetup."KRA Tax Logo".HASVALUE THEN BEGIN
            //    BLOBRef.Blob := prPayrollSetup."KRA Tax Logo";
            IF ExportToFile = '' THEN BEGIN
                FileName := 'Default.' + prPayrollSetup."File Extension";
                //  ExportToFile := FileMgt.BLOBExport(BLOBRef, FileName, TRUE);
            END ELSE BEGIN
                // If a filename is provided, the file will be treated as temp file.
                //    ExportToFile := FileMgt.BLOBExport(BLOBRef, ExportToFile, FALSE);
            END;
            EXIT(TRUE);
        END ELSE
            EXIT(FALSE)
    end;

    procedure PaySetupRemoveAttachment(var prPayrollSetup: Record 51165; Prompt: Boolean)
    begin
        IF prPayrollSetup."KRA Tax Logo".HASVALUE = FALSE THEN
            ERROR('No attachment is attached.');
        IF Prompt = TRUE THEN
            IF NOT CONFIRM('Remove attachment?') THEN EXIT;
        CLEAR(prPayrollSetup."KRA Tax Logo");
        prPayrollSetup."File Extension" := '';
        IF prPayrollSetup.MODIFY THEN;
        IF Prompt = TRUE THEN MESSAGE('Attachment removed');
    end;

    procedure PaySetupDeleteFile(FileName: Text[260]): Boolean
    var
        I: Integer;
    begin
        IF FileName = '' THEN
            EXIT(FALSE);

        /*  IF ISSERVICETIER THEN
             EXIT(TRUE);

         IF NOT exist(FileName) THEN
             EXIT(TRUE);
         File.Exists('')
         REPEAT
             SLEEP(250);
             I := I + 1;
         UNTIL (File.Erase(FileName)) OR (I = 25);
         EXIT(NOT File.Exists(FileName)); */
    end;

    procedure RecurLoanScheduleDebtService(Principal: Decimal; Interest: Decimal; PayPeriods: Integer): Decimal
    var
        PeriodInterest: Decimal;
    begin
        PeriodInterest := Interest / 12 / 100;
        EXIT(PeriodInterest / (1 - POWER((1 + PeriodInterest), -PayPeriods)) * Principal);
    end;

    procedure LoanAdvancesCreateLoan(var prLoanAdvances: Record 51171)
    var
        PeriodRec: Record 51151;
    begin
        IF prLoanAdvances."Start Period" = '' THEN
            ERROR('Start Period must be specified');

        IF prLoanAdvances."Loan Types" = '' THEN
            ERROR('Loan Type must be specified');

        PeriodRec.SETRANGE(Status, 0, 1);
        PeriodRec.SETRANGE("Payroll Code", prLoanAdvances."Payroll Code");
        PeriodRec.GET(prLoanAdvances."Start Period", prLoanAdvances."Period Month", prLoanAdvances."Period Year", prLoanAdvances."Payroll Code");
        IF PeriodRec.Status = PeriodRec.Status::Posted THEN
            ERROR('Start Period selected is posted');

        IF prLoanAdvances.Principal <= 0 THEN
            ERROR('Principal must be higher than zero');

        IF prLoanAdvances."Paid to Employee" THEN
            ERROR('Loan is paid');

        CASE prLoanAdvances.Type OF
            prLoanAdvances.Type::Annuity:
                prLoanAdvances.CreateAnnuityLoan();
            prLoanAdvances.Type::Serial:
                prLoanAdvances.CreateSerialLoan();
            prLoanAdvances.Type::Advance:
                prLoanAdvances.CreateAdvance();
        END;

        prLoanAdvances.Created := TRUE;
        prLoanAdvances.MODIFY;
    end;

    procedure LoanAdvancesCreateAdvance(var prLoanAdvances: Record 51171)
    var
        LoanEntryRec: Record 51172;
    begin
        LoanEntryRec.SETRANGE("Loan ID", prLoanAdvances.LID);
        LoanEntryRec.SETRANGE(Employee, prLoanAdvances.Employee);
        LoanEntryRec.DELETEALL;

        LoanEntryRec."No." := 1;
        LoanEntryRec."Loan ID" := prLoanAdvances.LID;
        LoanEntryRec.Employee := prLoanAdvances.Employee;
        LoanEntryRec.Period := prLoanAdvances."Start Period";
        LoanEntryRec.Interest := 0;
        LoanEntryRec.Repayment := prLoanAdvances.Principal;
        LoanEntryRec."Repayment (LCY)" := prLoanAdvances."Principal (LCY)";
        LoanEntryRec."Transfered To Payroll" := FALSE;
        LoanEntryRec."Remaining Debt" := 0;
        LoanEntryRec.INSERT(TRUE);

        prLoanAdvances.Installments := 1;
        prLoanAdvances."Interest Rate" := 0;
        prLoanAdvances."Installment Amount" := prLoanAdvances.Principal;
        prLoanAdvances."Installment Amount (LCY)" := prLoanAdvances."Principal (LCY)";
        prLoanAdvances.Created := TRUE;
        prLoanAdvances.Create := FALSE;
        prLoanAdvances.MODIFY;
    end;

    procedure LoanAdvancesCreateSerialLoan(var prLoanAdvances: Record 51171)
    var
        LoanEntryRec: Record 51172;
        Periodrec: Record 51151;
        LoanTypeRec: Record 51178;
        LoopEndBool: Boolean;
        LineNoInt: Integer;
        PeriodCode: Code[10];
        InterestAmountDec: Decimal;
        RemainingPrincipalAmountDec: Decimal;
        RepaymentAmountDec: Decimal;
        RoundPrecisionDec: Decimal;
        RoundDirectionCode: Code[10];
    begin
        LoanEntryRec.SETRANGE("Loan ID", prLoanAdvances.LID);
        LoanEntryRec.SETRANGE(Employee, prLoanAdvances.Employee);
        LoanEntryRec.DELETEALL;

        IF prLoanAdvances.Installments <= 0 THEN
            ERROR('Instalments must be specified');

        LoopEndBool := FALSE;

        LineNoInt := 0;
        Periodrec.SETCURRENTKEY("Start Date");
        Periodrec.SETRANGE("Payroll Code", prLoanAdvances."Payroll Code");
        Periodrec.GET(prLoanAdvances."Start Period", prLoanAdvances."Period Month", prLoanAdvances."Period Year", prLoanAdvances."Payroll Code");

        LoanTypeRec.GET(prLoanAdvances."Loan Types");

        CASE LoanTypeRec.Rounding OF
            LoanTypeRec.Rounding::Nearest:
                RoundDirectionCode := '=';
            LoanTypeRec.Rounding::Down:
                RoundDirectionCode := '<';
            LoanTypeRec.Rounding::Up:
                RoundDirectionCode := '>';
        END;

        RoundPrecisionDec := LoanTypeRec."Rounding Precision";
        RemainingPrincipalAmountDec := prLoanAdvances.Principal;
        RepaymentAmountDec := ROUND(prLoanAdvances.Principal / prLoanAdvances.Installments, RoundPrecisionDec, RoundDirectionCode);


        REPEAT
            IF LineNoInt <> 0 THEN
                IF Periodrec.FIND('>') THEN;
            PeriodCode := Periodrec."Period ID";

            LineNoInt := LineNoInt + 1;

            InterestAmountDec := ROUND(RemainingPrincipalAmountDec / 12 / 100 * prLoanAdvances."Interest Rate", RoundPrecisionDec, RoundDirectionCode);
            LoanEntryRec."No." := LineNoInt;
            LoanEntryRec."Loan ID" := prLoanAdvances.LID;
            LoanEntryRec.Employee := prLoanAdvances.Employee;
            LoanEntryRec.Period := PeriodCode;
            LoanEntryRec.Interest := InterestAmountDec;
            LoanEntryRec."Interest (LCY)" :=
            // ROUND(InterestAmountDec * "Currency Factor", RoundPrecisionDec, RoundDirectionCode);
            ROUND(gvCurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, prLoanAdvances."Currency Code", InterestAmountDec, prLoanAdvances."Currency Factor"),
            RoundPrecisionDec, RoundDirectionCode);//MESH

            LoanEntryRec."Calc Benefit Interest" := prLoanAdvances."Calculate Interest Benefit";

            IF LineNoInt = prLoanAdvances.Installments THEN BEGIN
                LoanEntryRec.Repayment := RemainingPrincipalAmountDec;
                LoanEntryRec."Repayment (LCY)" :=
                //  ROUND(RemainingPrincipalAmountDec * "Currency Factor", RoundPrecisionDec, RoundDirectionCode);
                ROUND(gvCurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, prLoanAdvances."Currency Code", RemainingPrincipalAmountDec, prLoanAdvances."Currency Factor"),
                RoundPrecisionDec, RoundDirectionCode);//MESH

                LoanEntryRec."Remaining Debt" := 0;
                LoanEntryRec."Remaining Debt (LCY)" := 0;
            END ELSE BEGIN
                LoanEntryRec.Repayment := prLoanAdvances."Installment Amount";
                LoanEntryRec."Repayment (LCY)" := prLoanAdvances."Installment Amount (LCY)";
                RemainingPrincipalAmountDec := RemainingPrincipalAmountDec - prLoanAdvances."Installment Amount";
                LoanEntryRec."Remaining Debt" := RemainingPrincipalAmountDec;
                LoanEntryRec."Remaining Debt (LCY)" :=
                //  ROUND(RemainingPrincipalAmountDec * "Currency Factor", RoundPrecisionDec, RoundDirectionCode);
                ROUND(gvCurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, prLoanAdvances."Currency Code", RemainingPrincipalAmountDec, prLoanAdvances."Currency Factor"),
                RoundPrecisionDec, RoundDirectionCode);//MESH

            END;

            LoanEntryRec.INSERT(TRUE);
        UNTIL LineNoInt = prLoanAdvances.Installments;

        prLoanAdvances.Created := TRUE;
        prLoanAdvances.Create := FALSE;
        prLoanAdvances.MODIFY;
    end;

    procedure LoanAdvancesCreateAnnuityLoan(var prLoanAdvances: Record 51171)
    var
        LoanEntryRec: Record 51172;
        Periodrec: Record 51151;
        LoanTypeRec: Record 51178;
        LoopEndBool: Boolean;
        LineNoInt: Integer;
        PeriodCode: Code[10];
        InterestAmountDec: Decimal;
        RemainingPrincipalAmountDec: Decimal;
        RepaymentAmountDec: Decimal;
        RoundPrecisionDec: Decimal;
        RoundDirectionCode: Code[10];
    begin
        LoanEntryRec.SETRANGE("Loan ID", prLoanAdvances.LID);
        LoanEntryRec.SETRANGE(Employee, prLoanAdvances.Employee);
        LoanEntryRec.DELETEALL;

        IF prLoanAdvances."Installment Amount" <= 0 THEN
            ERROR('Instalment Amount must be specified');
        IF prLoanAdvances."Installment Amount" > prLoanAdvances.Principal THEN
            ERROR('Instalment Amount is higher than Principal');

        LoopEndBool := FALSE;

        LineNoInt := 0;
        Periodrec.SETCURRENTKEY("Start Date");
        Periodrec.SETRANGE("Payroll Code", prLoanAdvances."Payroll Code");
        Periodrec.GET(prLoanAdvances."Start Period", prLoanAdvances."Period Month", prLoanAdvances."Period Year", prLoanAdvances."Payroll Code");

        LoanTypeRec.GET(prLoanAdvances."Loan Types");

        CASE LoanTypeRec.Rounding OF
            LoanTypeRec.Rounding::Nearest:
                RoundDirectionCode := '=';
            LoanTypeRec.Rounding::Down:
                RoundDirectionCode := '<';
            LoanTypeRec.Rounding::Up:
                RoundDirectionCode := '>';
        END;

        RoundPrecisionDec := LoanTypeRec."Rounding Precision";
        RemainingPrincipalAmountDec := prLoanAdvances.Principal;

        REPEAT
            InterestAmountDec := ROUND(RemainingPrincipalAmountDec / 100 / 12 * prLoanAdvances."Interest Rate", RoundPrecisionDec, '<');
            IF InterestAmountDec >= prLoanAdvances."Installment Amount" THEN
                ERROR('This Loan is not possible because\the the instalment Amount must\be higher than %1', InterestAmountDec);

            IF LineNoInt <> 0 THEN
                Periodrec.FIND('>');
            PeriodCode := Periodrec."Period ID";

            LineNoInt := LineNoInt + 1;

            LoanEntryRec."No." := LineNoInt;
            LoanEntryRec."Loan ID" := prLoanAdvances.LID;
            LoanEntryRec.Employee := prLoanAdvances.Employee;
            LoanEntryRec.Period := PeriodCode;
            LoanEntryRec.Interest := InterestAmountDec;
            LoanEntryRec."Interest (LCY)" :=
            //  ROUND(InterestAmountDec * "Currency Factor", RoundPrecisionDec, '<');
            ROUND(gvCurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, prLoanAdvances."Currency Code", InterestAmountDec, prLoanAdvances."Currency Factor"),
              RoundPrecisionDec, '<');//MESH

            LoanEntryRec."Calc Benefit Interest" := prLoanAdvances."Calculate Interest Benefit";

            IF (prLoanAdvances."Installment Amount" - InterestAmountDec) >= RemainingPrincipalAmountDec THEN BEGIN
                LoanEntryRec.Repayment := RemainingPrincipalAmountDec;
                LoanEntryRec."Repayment (LCY)" :=
                //  ROUND(RemainingPrincipalAmountDec * "Currency Factor", RoundPrecisionDec, '<');
                ROUND(gvCurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, prLoanAdvances."Currency Code", RemainingPrincipalAmountDec, prLoanAdvances."Currency Factor"),
                RoundPrecisionDec, '<');//MESH

                LoanEntryRec."Remaining Debt" := 0;
                LoanEntryRec."Remaining Debt (LCY)" := 0;
                LoopEndBool := TRUE;
            END ELSE BEGIN
                LoanEntryRec.Repayment := prLoanAdvances."Installment Amount";
                LoanEntryRec."Repayment (LCY)" := prLoanAdvances."Installment Amount (LCY)";
                RemainingPrincipalAmountDec := RemainingPrincipalAmountDec - prLoanAdvances."Installment Amount";
                LoanEntryRec."Remaining Debt" := RemainingPrincipalAmountDec;

                LoanEntryRec."Remaining Debt (LCY)" :=
                //  ROUND(RemainingPrincipalAmountDec * "Currency Factor", RoundPrecisionDec, '<');
                ROUND(gvCurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, prLoanAdvances."Currency Code", RemainingPrincipalAmountDec, prLoanAdvances."Currency Factor"),
                RoundPrecisionDec, '<');//MESH

            END;

            LoanEntryRec."Transfered To Payroll" := FALSE;
            LoanEntryRec.INSERT(TRUE);

            prLoanAdvances.Installments := LineNoInt;
            prLoanAdvances.MODIFY;
        UNTIL LoopEndBool;

        prLoanAdvances.Created := TRUE;
        prLoanAdvances.Create := FALSE;
        prLoanAdvances.MODIFY;
    end;

    procedure LoanAdvancesPayLoan(var prLoanAdvances: Record 51171)
    var
        GenJnlLine: Record 81;
        Loansetup: Record 51165;
        LoanTypeRec: Record 51178;
        LoanPaymentRec: Record 51179;
        EmployeeRec: Record 5200;
        PeriodRec: Record 51151;
        HeaderRec: Record 51159;
        TemplateName: Code[10];
        BatchName: Code[10];
        LineNo: Integer;
    begin
        IF prLoanAdvances."Paid to Employee" THEN ERROR('The Loan is allready paid');
        IF NOT prLoanAdvances.Created THEN ERROR('The Loan is not Created');

        PeriodRec.SETRANGE("Payroll Code", prLoanAdvances."Payroll Code");
        PeriodRec.GET(prLoanAdvances."Start Period", prLoanAdvances."Period Month", prLoanAdvances."Period Year", prLoanAdvances."Payroll Code");
        IF PeriodRec.Status = PeriodRec.Status::Posted THEN ERROR('Start Period selected is posted');

        LoanTypeRec.GET(prLoanAdvances."Loan Types");

        IF LoanTypeRec."Finance Source" = LoanTypeRec."Finance Source"::Company THEN BEGIN
            prLoanAdvances.TESTFIELD("Payments Method");
            LoanPaymentRec.GET(prLoanAdvances."Payments Method");
            LoanPaymentRec.TESTFIELD("Account No.");

            EmployeeRec.GET(prLoanAdvances.Employee);

            Loansetup.GET(prLoanAdvances."Payroll Code");
            Loansetup.TESTFIELD("Loan Template");
            Loansetup.TESTFIELD("Loan Payments Batch");

            TemplateName := Loansetup."Loan Template";
            BatchName := Loansetup."Loan Payments Batch";

            GenJnlLine.SETRANGE("Journal Template Name", TemplateName);
            GenJnlLine.SETRANGE("Journal Batch Name", BatchName);
            IF GenJnlLine.FIND('+') THEN
                LineNo := GenJnlLine."Line No."
            ELSE
                LineNo := 0;

            LineNo := LineNo + 10000;
            GenJnlLine."Journal Batch Name" := BatchName;
            GenJnlLine."Journal Template Name" := TemplateName;
            GenJnlLine."Line No." := LineNo;
            GenJnlLine."Document No." := STRSUBSTNO('%1', prLoanAdvances.LID);
            GenJnlLine.VALIDATE("Posting Date", WORKDATE);

            CASE LoanTypeRec."Loan Accounts Type" OF
                LoanTypeRec."Loan Accounts Type"::"G/L Account":
                    BEGIN
                        LoanTypeRec.TESTFIELD("Loan Account");
                        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                        GenJnlLine.VALIDATE("Account No.", LoanTypeRec."Loan Account");
                    END;

                LoanTypeRec."Loan Accounts Type"::Customer:
                    BEGIN
                        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
                        GenJnlLine.VALIDATE("Account No.", gvPayrollUtilities.fGetEmplyeeLoanAccount(EmployeeRec, LoanTypeRec));
                    END;

                LoanTypeRec."Loan Accounts Type"::Vendor:
                    BEGIN
                        LoanTypeRec.TESTFIELD("Loan Account");
                        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
                        GenJnlLine.VALIDATE("Account No.", LoanTypeRec."Loan Account");
                    END;
            END; //Case

            GenJnlLine.Description := STRSUBSTNO('Payment of Loan %1', prLoanAdvances."Loan ID");
            GenJnlLine.VALIDATE(Amount, prLoanAdvances.Principal);

            IF LoanPaymentRec."Account Type" = LoanPaymentRec."Account Type"::"G/L Account" THEN
                GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account")
            ELSE
                GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account");
            GenJnlLine.VALIDATE("Bal. Account No.", LoanPaymentRec."Account No.");

            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", EmployeeRec."Global Dimension 1 Code");
            GenJnlLine.VALIDATE("Shortcut Dimension 2 Code", EmployeeRec."Global Dimension 2 Code");
            GenJnlLine.UpdateLineBalance;
            GenJnlLine.INSERT;
        END;

        prLoanAdvances."Paid to Employee" := TRUE;
        prLoanAdvances.Pay := FALSE;

        prLoanAdvances.MODIFY;

        IF HeaderRec.GET(prLoanAdvances."Start Period", prLoanAdvances.Employee) THEN BEGIN
            IF HeaderRec.Calculated THEN BEGIN
                HeaderRec.Calculated := FALSE;
                HeaderRec.MODIFY;
            END;
        END;
    end;

    procedure LoanAdvancesDebtService(Principal: Decimal; Interest: Decimal; PayPeriods: Integer): Decimal
    var
        PeriodInterest: Decimal;
    begin
        PeriodInterest := Interest / 12 / 100;
        EXIT(PeriodInterest / (1 - POWER((1 + PeriodInterest), -PayPeriods)) * Principal);
    end;

    procedure LoanAdvancesCreateLoanfromSchedule(var prLoanAdvances: Record 51171)
    var
        PeriodRec: Record 51151;
        lvLoansSchedule: Record 51169;
        lvEmp: Record 5200;
    begin
        lvLoansSchedule.SETRANGE(Skip, FALSE);
        IF NOT lvLoansSchedule.FIND('-') THEN ERROR('No valid Recurring Loan Schedule line found.');

        PeriodRec.SETCURRENTKEY("Start Date");
        PeriodRec.SETRANGE(Status, PeriodRec.Status::Open);
        PeriodRec.SETRANGE("Payroll Code", prLoanAdvances."Payroll Code");
        IF NOT PeriodRec.FIND('+') THEN ERROR('No Open payroll period was found.');

        REPEAT
            lvLoansSchedule.TESTFIELD(Employee);
            lvLoansSchedule.TESTFIELD("Loan Types");
            IF lvLoansSchedule.Type <> lvLoansSchedule.Type::Advance THEN lvLoansSchedule.TESTFIELD("Interest Rate");
            lvLoansSchedule.TESTFIELD(Principal);
            lvLoansSchedule.TESTFIELD(Installments);
            lvLoansSchedule.TESTFIELD("Payments Method");

            prLoanAdvances.INIT;
            prLoanAdvances.LID := 0;
            prLoanAdvances.VALIDATE(Employee, lvLoansSchedule.Employee);
            lvEmp.GET(lvLoansSchedule.Employee);
            prLoanAdvances."First Name" := lvEmp."First Name";
            prLoanAdvances."Last Name" := lvEmp."Last Name";
            prLoanAdvances.VALIDATE("Loan Types", lvLoansSchedule."Loan Types");
            prLoanAdvances.VALIDATE("Interest Rate", lvLoansSchedule."Interest Rate");
            prLoanAdvances.VALIDATE(Principal, lvLoansSchedule.Principal);
            prLoanAdvances."Start Period" := PeriodRec."Period ID";
            prLoanAdvances."Period Month" := PeriodRec."Period Month";
            prLoanAdvances."Period Year" := PeriodRec."Period Year";
            prLoanAdvances.VALIDATE(Installments, lvLoansSchedule.Installments);
            prLoanAdvances."Payments Method" := lvLoansSchedule."Payments Method";
            prLoanAdvances."Type Text" := prLoanAdvances.Description;
            prLoanAdvances.INSERT(TRUE);
            COMMIT;

            CASE prLoanAdvances.Type OF
                prLoanAdvances.Type::Annuity:
                    prLoanAdvances.CreateAnnuityLoan();
                prLoanAdvances.Type::Serial:
                    prLoanAdvances.CreateSerialLoan();
                prLoanAdvances.Type::Advance:
                    prLoanAdvances.CreateAdvance();
            END;
        UNTIL lvLoansSchedule.NEXT = 0;
    end;

    procedure LoanAdvancesPayoffLoan(var prLoanEntry: Record 51172; LoanEntry: Record 51172; PayOffCode: Code[20])
    var
        LoanEntryRecTmp: Record 51172 temporary;
        LoanPaymentRec: Record 51179;
        Loansetup: Record 51165;
        LoansRec: Record 51171;
        LoanTypeRec: Record 51178;
        GenJnlLine: Record 81;
        GenJnlBatch: Record 232;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        LineNo: Integer;
        TemplateName: Code[20];
        BatchName: Code[20];
        gvPayrollUtilities: Codeunit 51152;
    begin
        LoanEntryRecTmp.COPY(prLoanEntry);
        LoanEntryRecTmp.Interest := 0;
        LoanEntryRecTmp.Repayment := prLoanEntry."Remaining Debt" + prLoanEntry.Repayment;
        LoanEntryRecTmp."Transfered To Payroll" := TRUE;
        LoanEntryRecTmp."Remaining Debt" := 0;
        LoanEntryRecTmp.Posted := TRUE;
        LoanEntryRecTmp.INSERT;


        LoanEntry.SETFILTER("No.", '>=%1', LoanEntryRecTmp."No.");

        LoanEntry.DELETEALL;

        LoanEntry.COPY(LoanEntryRecTmp);
        LoanEntry.INSERT;

        LoanEntry.GET(LoanEntryRecTmp."No.", LoanEntryRecTmp."Loan ID");

        LoanPaymentRec.GET(PayOffCode);
        LoanPaymentRec.TESTFIELD("Account No.");

        Loansetup.GET;
        Loansetup.TESTFIELD("Loan Template");
        Loansetup.TESTFIELD("Loan Payments Batch");

        LoansRec.GET(prLoanEntry."Loan ID", prLoanEntry.Employee);

        IF NOT LoansRec."Paid to Employee" THEN
            ERROR('The Loan is not paid out to Employee');

        LoanTypeRec.GET(LoansRec."Loan Types");

        TemplateName := Loansetup."Loan Template";
        BatchName := Loansetup."Loan Payments Batch";

        GenJnlLine.SETRANGE("Journal Template Name", TemplateName);
        GenJnlLine.SETRANGE("Journal Batch Name", BatchName);
        IF GenJnlLine.FIND('+') THEN
            LineNo := GenJnlLine."Line No."
        ELSE
            LineNo := 0;

        LineNo := LineNo + 10000;
        GenJnlLine.Amount := -LoanEntry.Repayment;
        GenJnlLine.VALIDATE(Amount);
        GenJnlLine."Journal Batch Name" := BatchName;
        GenJnlLine."Journal Template Name" := TemplateName;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        GenJnlLine."Account No." := LoanTypeRec."Loan Account";
        GenJnlLine."Posting Date" := WORKDATE;
        GenJnlLine.Description := 'Pay off Loan';
        IF LoanPaymentRec."Account Type" = LoanPaymentRec."Account Type"::"G/L Account" THEN
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account"
        ELSE
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
        GenJnlLine."Bal. Account No." := LoanPaymentRec."Account No.";
        GenJnlLine."Shortcut Dimension 1 Code" := '';
        GenJnlLine."Shortcut Dimension 2 Code" := '';

        GenJnlBatch.GET(TemplateName, BatchName);
        IF GenJnlBatch."No. Series" <> '' THEN BEGIN
            // CLEAR(NoSeriesMgt);
            //GenJnlLine."Document No." := NoSeriesMgt.TryGetNextNo(GenJnlBatch."No. Series", GenJnlLine."Posting Date");
        END;
        GenJnlLine.UpdateLineBalance;
        GenJnlLine.INSERT;
    end;

    procedure PayrollAllocationMatrixAllocatedValidate(var prPayrollExpAllocatedMatrix: Record 51188)
    var
        lvAllocatedTotal: Record 51188;
        lvStartDate: Date;
        lvEndDate: Date;
    begin
        lvAllocatedTotal.SETCURRENTKEY("Employee No", "ED Code");
        lvAllocatedTotal.SETRANGE("Employee No", prPayrollExpAllocatedMatrix."Employee No");
        lvAllocatedTotal.SETRANGE("ED Code", prPayrollExpAllocatedMatrix."ED Code");
        //cmm VSF PAY 1 Make date to get the allocations for the month
        lvStartDate := CALCDATE('-CM', prPayrollExpAllocatedMatrix."Posting Date");
        lvEndDate := CALCDATE('CM', prPayrollExpAllocatedMatrix."Posting Date");
        //end cmm

        lvAllocatedTotal.SETRANGE("Posting Date", lvStartDate, lvEndDate);

        lvAllocatedTotal.SETFILTER(lvAllocatedTotal."Entry No", '<>%1', prPayrollExpAllocatedMatrix."Entry No");
        lvAllocatedTotal.CALCSUMS(Allocated);
        IF (lvAllocatedTotal.Allocated + prPayrollExpAllocatedMatrix.Allocated) > 100 THEN
            ERROR('Total allocation for %1 ED %2 can not exceed 100 Percent', prPayrollExpAllocatedMatrix."Employee No", prPayrollExpAllocatedMatrix."ED Code")
    end;

    procedure gsSetActivePayroll()
    var
        lvAllowedPayrolls: Record 51182;
        lfrmSelectPayroll: Page 51197;
        lvAllowedPayrolsCount: Integer;
        lvPayrollUtilities: Codeunit 51152;
        lvActiveSession: Record 2000000110;
    begin
        //skm210409 Revised to make it Windows Logins aware

        //skm110506 this function selects the payroll the current user will have access to
        //called by Code Unit 1-CompanyOpen function
        //clear previous setting
        lvActiveSession.RESET;
        lvActiveSession.SETRANGE("Server Instance ID", SERVICEINSTANCEID);
        lvActiveSession.SETRANGE("Session ID", SESSIONID);
        lvActiveSession.FINDFIRST;

        lvAllowedPayrolls.SETRANGE("User ID", lvActiveSession."User ID");
        lvAllowedPayrolls.SETRANGE("Last Active Payroll", TRUE);
        IF lvAllowedPayrolls.FINDFIRST THEN lvAllowedPayrolls.MODIFYALL("Last Active Payroll", FALSE);
        COMMIT;
        //mesh
        /*lvAllowedPayrolls.RESET;
        lvAllowedPayrolls.SETRANGE("User ID", USERID);
        
        lvAllowedPayrolls.SETRANGE("Valid to Date", 0D);
        lvAllowedPayrolls.FINDFIRST;
        lvAllowedPayrolsCount := lvAllowedPayrolls.COUNT;
        CASE lvAllowedPayrolsCount OF
          1: BEGIN //allowed access to one payroll, set it
            lvAllowedPayrolls.FIND('-');
            lvAllowedPayrolls."Last Active Payroll" := TRUE;
            lvAllowedPayrolls.MODIFY;
            EXIT;
          END;
        
          ELSE IF lvAllowedPayrolsCount > 1 THEN BEGIN //allowed access to multiple payrolls, prompt for selection
            lfrmSelectPayroll.CAPTION := 'Select Payroll';
            lfrmSelectPayroll.SETTABLEVIEW(lvAllowedPayrolls);
            lfrmSelectPayroll.LOOKUPMODE := TRUE;
            IF lfrmSelectPayroll.RUNMODAL = ACTION::LookupOK THEN BEGIN
              lfrmSelectPayroll.GETRECORD(lvAllowedPayrolls);
              lvAllowedPayrolls."Last Active Payroll" := TRUE;
              lvAllowedPayrolls.MODIFY
            END;
            EXIT;
          END
        END;*/ //mesh

        lvAllowedPayrolls.RESET;
        lvAllowedPayrolls.SETRANGE("User ID", USERID);
        lvAllowedPayrolls.SETFILTER("Valid to Date", '%1|>=%1', 0D, TODAY);
        lvAllowedPayrolsCount := lvAllowedPayrolls.COUNT;
        CASE lvAllowedPayrolsCount OF
            0:
                EXIT;
            1:
                BEGIN //allowed access to one payroll, set it
                    lvAllowedPayrolls.FIND('-');
                    lvAllowedPayrolls."Last Active Payroll" := TRUE;
                    lvAllowedPayrolls.MODIFY
                END;

            ELSE
                IF lvAllowedPayrolsCount > 1 THEN BEGIN //allowed access to multiple payrolls, prompt for selection
                    lfrmSelectPayroll.CAPTION := 'Select Payroll';
                    lfrmSelectPayroll.SETTABLEVIEW(lvAllowedPayrolls);
                    lfrmSelectPayroll.LOOKUPMODE := TRUE;
                    IF lfrmSelectPayroll.RUNMODAL = ACTION::LookupOK THEN BEGIN
                        lfrmSelectPayroll.GETRECORD(lvAllowedPayrolls);
                        lvAllowedPayrolls."Last Active Payroll" := TRUE;//mesh
                        lvAllowedPayrolls.MODIFY
                    END
                END
        END;

    end;

    procedure "==="()
    begin
    end;

    procedure CheckLicencePermission(prObjectType: Option TableData,"Table","Report","Codeunit","XMLPort",Menusuite,"Page"; prObjectID: Integer) IsAllowed: Boolean
    var
    //   lvPermissionRange: Record 2000000044;
    begin
        /*   //prObjectType has options:TableData,Table,Report,Codeunit,XMLPort,Menusuite,Page....
          //Permission Range table has options:TableData,Table,Blank,Report,Blank,Codeunit,XMLPort,Menusuite,Page,Query,System,FieldNumber
          CASE prObjectType OF
              prObjectType::TableData, prObjectType::Table:
                  lvPermissionRange.SETRANGE("Object Type", prObjectType);
              prObjectType::Report:
                  lvPermissionRange.SETRANGE("Object Type", prObjectType + 1);
              prObjectType::Codeunit, prObjectType::XMLPort, prObjectType::Menusuite, prObjectType::Page:
                  lvPermissionRange.SETRANGE("Object Type", prObjectType + 2);
          END;
          lvPermissionRange.SETFILTER(From, '<=%1', prObjectID);
          lvPermissionRange.SETFILTER(lvPermissionRange."To", '>=%1', prObjectID);
          IF (lvPermissionRange.FINDFIRST) AND (lvPermissionRange."Execute Permission" = lvPermissionRange."Execute Permission"::Yes) THEN
              EXIT(TRUE)
          ELSE
              EXIT(FALSE); */
    end;

    procedure Checkthirdrule(EmployeeNo: Code[20]; DeductionAmount: Decimal)
    var
        PayrollLines: Record 51160;
        TotalIncome: Decimal;
        TotalDeduction: Decimal;
        PayrollPeriod: Code[20];
        PayrollPeriodrec: Record 51151;
        Employee: Record 5200;
    begin
        Employee.GET(EmployeeNo);
        PayrollPeriodrec.RESET;
        PayrollPeriodrec.SETCURRENTKEY("Start Date");
        PayrollPeriodrec.SETRANGE("Payroll Code", Employee."Payroll Code");
        PayrollPeriodrec.SETRANGE(Status, PayrollPeriodrec.Status::Posted);
        IF PayrollPeriodrec.FINDLAST THEN
            PayrollPeriod := PayrollPeriodrec."Period ID";

        PayrollLines.RESET;
        PayrollLines.SETRANGE("Employee No.", EmployeeNo);
        PayrollLines.SETRANGE("Payroll ID", PayrollPeriod);
        PayrollLines.SETRANGE("Calculation Group", PayrollLines."Calculation Group"::Payments);
        IF PayrollLines.FINDFIRST THEN
            REPEAT
                TotalIncome := TotalIncome + PayrollLines.Amount;
            UNTIL PayrollLines.NEXT = 0;

        PayrollLines.RESET;
        PayrollLines.SETRANGE("Employee No.", EmployeeNo);
        PayrollLines.SETRANGE("Payroll ID", PayrollPeriod);
        PayrollLines.SETRANGE("Calculation Group", PayrollLines."Calculation Group"::Deduction);
        IF PayrollLines.FINDFIRST THEN
            REPEAT
                TotalDeduction := TotalDeduction + PayrollLines.Amount;
            UNTIL PayrollLines.NEXT = 0;

        //check 1/3 rule


        IF (TotalIncome * 1 / 3) > (TotalIncome - TotalDeduction - DeductionAmount) THEN
            ERROR('You cannot enter  this  amount  because your deduction will exceed a third Rule');
    end;
}

