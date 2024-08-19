page 51188 "Create Payroll Transfer File"
{
    PageType = Card;

    layout
    {
        area(content)
        {
            group("Tranfer Information")
            {
                Caption = 'Tranfer Information';
                field(gvPeriodCode; gvPeriodCode)
                {
                    Caption = 'Period';
                    Editable = false;
                    Lookup = true;
                    //    LookupPageID = "Journal Voucher";
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        IF ACTION::LookupOK = PAGE.RUNMODAL(0, gvPeriodRec) THEN BEGIN
                            gvPeriodCode := gvPeriodRec."Period ID";
                            gvMonthText := gvPeriodRec.Description;
                        END;
                    end;
                }
                field(gvTransferType; gvTransferType)
                {
                    Caption = 'File type';
                    Editable = false;
                    ApplicationArea = All;
                }
                field(gvValueDate; gvValueDate)
                {
                    Caption = 'Value Date';
                    Editable = false;
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CASE gvTransferType OF
                            gvTransferType::PAYNET:
                                gvFileName := STRSUBSTNO('CITI%1%2.Txt',
                                                        DATE2DMY(gvValueDate, 2),
                                                        COPYSTR(STRSUBSTNO('%1', DATE2DMY(gvValueDate, 3)
                                                                          ),
                                                                3,
                                                                2
                                                               )
                                                      );
                            gvTransferType::FOSO:
                                gvFileName := STRSUBSTNO('NHIF%1%2.Txt',
                                                        DATE2DMY(gvValueDate, 2),
                                                        COPYSTR(STRSUBSTNO('%1', DATE2DMY(gvValueDate, 3)
                                                                          ),
                                                                3,
                                                                2
                                                               )
                                                      );
                        END;
                    end;
                }
                field(gvFileName; gvFileName)
                {
                    Caption = 'File Name (Without Path)';
                    Editable = false;
                    ToolTip = 'Enter File Name without path';
                    ApplicationArea = All;
                }
                field(gvModeofPaymentCode; gvModeofPaymentCode)
                {
                    Caption = 'Mode of Payment';
                    Editable = false;
                    TableRelation = "Mode of Payment";
                    ApplicationArea = All;
                }
                field(gvEDCode; gvEDCode)
                {
                    Caption = 'ED Code';
                    Editable = false;
                    Lookup = true;
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        IF ACTION::LookupOK = PAGE.RUNMODAL(0, gvEDDefns) THEN BEGIN
                            gvEDCode := gvEDDefns."ED Code";
                            EDName := gvEDDefns.Description;
                        END;
                    end;
                }
                field(EDName; EDName)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Make File")
            {
                Caption = 'Make File';
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                var
                    FileExtension: Text[5];
                    PointPosition: Integer;
                begin
                    IF gvPeriodCode = '' THEN ERROR('A Payroll Period must be selected');
                    gvPeriodRec.SETRANGE("Period ID", gvPeriodCode);
                    gvPeriodRec.FIND('-');

                    IF (gvFileName = '') AND (gvTransferType <> gvTransferType::HELB) THEN ERROR('File Name must be entered'); //cmm 080813  HELB File
                    //IF (gvFileName = '') THEN ERROR('File Name must be entered'); //cmm commented

                    gvPayrollSetup.GET(gvAllowedPayrolls."Payroll Code");
                    gvPayrollSetup.TESTFIELD("Payroll Transfer Path");

                    IF (gvModeofPaymentCode = '') AND (gvTransferType <> gvTransferType::HELB) THEN ERROR('Mode of Payment must be specified.');    //cmm 080813  HELB File
                    //IF gvModeofPaymentCode = ''  THEN ERROR('Mode of Payment must be specified.');  //cmm 080813  HELB File   commented

                    IF (gvTransferType <> gvTransferType::HELB) THEN BEGIN //cmm 080813
                        CLEAR(gvTranferFile);
                        //  gvTranferFile.TextMode := TRUE;
                        // gvTranferFile.WRITEMODE := TRUE;
                        //gvTranferFile.QUERYREPLACE := TRUE;   TNG: QUERYREPLACE is obsolete. 20131219
                        //IF Exists(gvPayrollSetup."Payroll Transfer Path" + '\' + gvFileName + '.csv') THEN
                        IF NOT CONFIRM('A file with the same name exists. Do you want to replace it?') THEN
                            EXIT;
                        //  gvTranferFile.Create(gvPayrollSetup."Payroll Transfer Path" + '\' + gvFileName + '.csv');//mesh-+'.'+'CSV'
                        //gvTranferFile.CREATEINSTREAM(NewStream);
                    END;// cmm

                    CASE gvTransferType OF
                    /* gvTransferType::COOP:
                        CreateCOOP;
                    gvTransferType::KCB:
                        CreateKCB;
                    gvTransferType::CITI:
                        CreateLocalCitibanking;
                    gvTransferType::NHIF:
                        CreateNHIF;
                    gvTransferType::NSSF:
                        CreateNSSF;
                    gvTransferType::FOSO:
                        CreateFOSO;
                    gvTransferType::PAYNET:
                        CreatePAYNET;
                    gvTransferType::NBK:
                        CreateNBK;
                    gvTransferType::BBK:
                        CreateBBK;
                    gvTransferType::FINA:
                        CreateFINA;
                    gvTransferType::CFC:
                        CreateCFC;
                    gvTransferType::CFCSFI:
                        CreateCFCSFI;
                    gvTransferType::HELB:
                        CreateHELBFile;
                    gvTransferType::SCB:
                        CreateSCB; */
                    END;

                    IF (gvTransferType <> gvTransferType::HELB) THEN BEGIN  //cmm 080813
                                                                            // gvTranferFile.Close();
                                                                            //MESSAGE('File generation successfully completed.');
                    END; //cmm
                end;
            }
            action("Generate File")
            {
                Caption = 'Generate File';
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                // RunObject = XMLport 50018;
            }
        }
    }

    trigger OnInit()
    var
        lvPayrollUtilities: Codeunit 51152;
    begin
        //IGS make windows logins aware
        gvAllowedPayrolls.SETRANGE("User ID", USERID);
        gvAllowedPayrolls.SETRANGE("Last Active Payroll", TRUE);
        IF gvAllowedPayrolls.FINDFIRST THEN BEGIN
            gvPeriodRec.SETRANGE(Status, gvPeriodRec.Status::Open);
            gvPeriodRec.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
        END ELSE
            ERROR('You are not allowed access to any payroll.');
    end;

    var
        gvPeriodRec: Record 51151;
        gvEmployee: Record 5200;
        gvHeader: Record 51159;
        gvPayrollSetup: Record 51165;
        gvEmployeeBank: Record 51152;
        gvPeriodCode: Code[10];
        gvValueDate: Date;
        gvFileName: Text[30];
        gvTransferType: Option CITI,NHIF,NSSF,PAYNET,FOSO,NBK,BBK,FINA,CFC,CFCSFI,HELB,SCB,COOP,KCB;
        gvTranferFile: File;
        gvNetPayAmount: Decimal;
        gvNegativeCounter: Integer;
        gvFieldCounter: Integer;
        gvMonthText: Text[30];
        gvFullPath: Text[8];
        gvHeaderText: Text[255];
        FooterText: Text[80];
        gvEmpCount: Integer;
        gvTotalNetpay: Decimal;
        gvHeaderDate: Text[30];
        gvAmountToPay: Decimal;
        gvAllowedPayrolls: Record 51182;
        gvModeofPaymentCode: Code[10];
        gvEDCode: Code[20];
        gvEDDefns: Record 51158;
        EDName: Text[30];
        PayrollSetup: Record 51165;
        Name: Text[200];
        ReturnValue: Boolean;
        TempFile: File;
        ToFile: Variant;
        NewStream: InStream;
        sasa: Text[10];

    procedure CreateLocalCitibanking()
    var
        NoofZeros: Integer;
        WithLeadZerosNet: Text[30];
        i: Integer;
        WithLeadZerosEmpBank: Text[50];
        WithLeadZerosCoBank: Text[50];
        EmployerName: Text[50];
        ZeroFilled: Text[50];
        lvEmployeeName: Text[100];
    begin
        /*  gvPayrollSetup.GET(gvAllowedPayrolls."Payroll Code");
         //gvPayrollSetup.TESTFIELD("Bank Account No");

         gvHeaderDate := DELCHR(FORMAT(TODAY), '=', '-');
         gvHeaderDate := INSSTR(gvHeaderDate, '20', 5);
         gvHeaderText := '186' + gvHeaderDate + '01000000        ' + gvPayrollSetup."Employer Name";

         gvEmployee.SETRANGE("Mode of Payment", gvModeofPaymentCode);
         gvEmployee.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");

         IF gvEmployee.FIND('-') THEN BEGIN
          //   gvTranferFile.Write(
             STRSUBSTNO(gvHeaderText));
             REPEAT
                 lvEmployeeName := gvEmployee.FullName;
                 gvEmployee.TESTFIELD("Bank Code");
                 gvEmployee.TESTFIELD("Bank Account No");
                 gvEmployeeBank.GET(gvEmployee."Bank Code");
                 gvEmployeeBank.TESTFIELD("KBA Code");
                 IF gvHeader.GET(gvPeriodCode, gvEmployee."No.") THEN BEGIN
                     gvHeader.CALCFIELDS("Total Payable (LCY)", "Total Deduction (LCY)");
                     gvNetPayAmount := gvHeader."Total Payable (LCY)" - gvHeader."Total Deduction (LCY)";
                     gvNetPayAmount := gvNetPayAmount * 100;
                     IF gvNetPayAmount > 0 THEN BEGIN
                         gvEmpCount := gvEmpCount + 1;
                         gvTotalNetpay := gvTotalNetpay + gvNetPayAmount;
                         WithLeadZerosNet := FORMAT(gvNetPayAmount, 0, 1);
                         WithLeadZerosNet := DELCHR(WithLeadZerosNet, '=', '.');
                         WithLeadZerosNet := DELCHR(WithLeadZerosNet, '=', ',');
                         NoofZeros := 13 - STRLEN(WithLeadZerosNet);
                         FOR i := 1 TO NoofZeros DO WithLeadZerosNet := '0' + WithLeadZerosNet;
                         NoofZeros := 15 - STRLEN(gvEmployee."Bank Account No");
                         WithLeadZerosEmpBank := gvEmployee."Bank Account No";
                         FOR i := 1 TO NoofZeros DO WithLeadZerosEmpBank := '0' + WithLeadZerosEmpBank;
                         NoofZeros := 15 - STRLEN(gvPayrollSetup."Bank Account No");
                         WithLeadZerosCoBank := gvPayrollSetup."Bank Account No";
                         FOR i := 1 TO NoofZeros DO WithLeadZerosCoBank := '0' + WithLeadZerosCoBank;
                         FOR i := 1 TO 15 DO lvEmployeeName := ' ' + lvEmployeeName;
                         lvEmployeeName := FORMAT(lvEmployeeName, 50);
                         EmployerName := FORMAT(gvPayrollSetup."Employer Name", 35);
                         ZeroFilled := '0000000000';

                         gvTranferFile.WRITE(
                           STRSUBSTNO('00') +
                           STRSUBSTNO('58') +
                           STRSUBSTNO(WithLeadZerosNet) +
                           STRSUBSTNO('0') +
                           STRSUBSTNO('01') +
                           STRSUBSTNO(gvEmployee."Bank Branch Code") +
                           STRSUBSTNO(WithLeadZerosCoBank) +
                           STRSUBSTNO(gvEmployeeBank."KBA Code") +
                           STRSUBSTNO(WithLeadZerosEmpBank) +
                           STRSUBSTNO('01') +
                           //skm100506 commented line below, to use Multiple Dim Feature later
                           //STRSUBSTNO(gvEmployee."Emp Branch Code") +
                           'Branch' +
                           STRSUBSTNO(lvEmployeeName) +
                           STRSUBSTNO(EmployerName) +
                           STRSUBSTNO(ZeroFilled));
                     END ELSE BEGIN
                         gvNegativeCounter += 1;
                     END;
                 END;
             UNTIL gvEmployee.NEXT = 0;

             FooterText := '190100000000' + FORMAT(gvEmpCount) + '00000' + FORMAT(gvTotalNetpay);
             gvTranferFile.WRITE(
             STRSUBSTNO(FooterText));
         END; */
    end;

    procedure CreateNHIF()
    var
        lvNHIFNO: Code[10];
        lvEmpNo: Code[20];
        lvEmpID: Text[30];
        lvNHIFAmount: Decimal;
        lvEmployeeName: Text[100];
    begin
        /*         gvTotalNetpay := 0;
                gvEmployee.RESET;
                gvEmployee.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");

                IF gvEmployee.FIND('-') THEN BEGIN
                     gvTranferFile.WRITE('Employer Code,' + gvPayrollSetup."Employer NHIF No.");
                    gvTranferFile.WRITE('Employer Name,' + gvPayrollSetup."Employer Name");
                    gvTranferFile.WRITE('Month of Contribution,' + gvPeriodCode);
                    gvTranferFile.WRITE('');

                    gvHeaderText := 'PERSONAL NO.,' + 'LAST NAME,' + 'FIRST NAMES,' + 'I/D NO.,' + 'NHIF NO.,' + 'AMOUNT';
                    gvTranferFile.WRITE(STRSUBSTNO(gvHeaderText));
                    gvTranferFile.WRITE('');

                    gvEmployee.SETFILTER("ED Code Filter", gvPayrollSetup."NHIF ED Code");
                    gvEmployee.SETFILTER("Period Filter", gvPeriodCode);

                    REPEAT
                        gvEmployee.CALCFIELDS(Amount);
                        lvNHIFAmount := gvEmployee.Amount;
                        gvTotalNetpay += lvNHIFAmount;

                        IF lvNHIFAmount > 0 THEN BEGIN
                            gvEmployee.TESTFIELD("Last Name");
                            gvEmployee.TESTFIELD("First Name");

                            lvEmployeeName := gvEmployee."Last Name" + ',' + gvEmployee."First Name" + ' ' + gvEmployee."Middle Name" + ',';

                            //gvEmployee.TESTFIELD("NHIF No.");
                         IF gvEmployee."NHIF No." = '' THEN
                              ERROR('Enter NHIF Membership No for ED %1, Employee %2', gvPayrollSetup."NHIF ED Code", gvEmployee."No.");
                            lvNHIFNO := gvEmployee."NHIF No." + ',';

                            lvEmpNo := gvEmployee."No." + ',';

                            //gvEmployee.TESTFIELD("National ID");
                            lvEmpID := gvEmployee."National ID" + ',';

                            gvTranferFile.WRITE(
                               STRSUBSTNO(lvEmpNo) +
                               STRSUBSTNO(lvEmployeeName) +
                               STRSUBSTNO(lvEmpID) +
                               STRSUBSTNO(lvNHIFNO) +
                               STRSUBSTNO(FORMAT(lvNHIFAmount)))
                        END
                    UNTIL gvEmployee.NEXT = 0;

                    FooterText := ',,,,Total,' + FORMAT(gvTotalNetpay);
                    gvTranferFile.WRITE(FooterText);
                END;
         */
    end;

    procedure CreateNSSF()
    var
        lvNSSFAmount: Decimal;
        lvEmployeeName: Text[100];
    begin
        /* gvTotalNetpay := 0;
        gvEmployee.RESET;
        gvEmployee.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");

        IF gvEmployee.FIND('-') THEN BEGIN
            gvTranferFile.WRITE('Employer Name,' + gvPayrollSetup."Employer Name");
            gvTranferFile.WRITE('Employer Code,' + gvPayrollSetup."Employer NSSF No.");
            gvTranferFile.WRITE('Address,' + gvPayrollSetup."Employers Address");
            gvTranferFile.WRITE('');

            gvTranferFile.WRITE('Month,' + STRSUBSTNO('%1', gvPeriodRec."Period Month"));
            gvTranferFile.WRITE('Year,' + STRSUBSTNO('%1', gvPeriodRec."Period Year"));
            gvTranferFile.WRITE('');

            gvTranferFile.WRITE('PERSONAL NUMBER,EMPLOYEE''S NAMES,FUND MEMBERSHIP NUMBER,MANANTORY CONTRIBUTIONS (KSHS),' +
              'VOLUNTARY CONTRIBUTIONS (KSHS),TOTAL AMOUNT KSHS,NATIONAL ID NO');
            gvTranferFile.WRITE('');

            gvEmployee.SETFILTER("ED Code Filter", gvPayrollSetup."NSSF ED Code");
            gvEmployee.SETFILTER("Period Filter", gvPeriodCode);

            REPEAT
                gvEmployee.CALCFIELDS(Amount);
                lvNSSFAmount := gvEmployee.Amount;
                gvTotalNetpay += lvNSSFAmount;

                IF lvNSSFAmount > 0 THEN BEGIN
                    lvEmployeeName := gvEmployee.FullName;
                    IF lvEmployeeName = '' THEN ERROR('All employee names are blank for employee number %1', gvEmployee."No.");

                    gvEmployee.TESTFIELD("NSSF No.");
                    IF gvEmployee."NSSF No." = '' THEN
                        ERROR('Enter NSSF Membership No for ED %1, Employee %2', gvPayrollSetup."NSSF ED Code", gvEmployee."No.");

                    gvEmployee.TESTFIELD("National ID");

                    gvTranferFile.WRITE(
                       gvEmployee."No." + ',' +
                       lvEmployeeName + ',' +
                       gvEmployee."NSSF No." + ',' +
                       ',,' +
                       STRSUBSTNO(FORMAT(lvNSSFAmount)) + ',' +
                       gvEmployee."National ID")
                END
            UNTIL gvEmployee.NEXT = 0;

            gvTranferFile.WRITE(',,,,TOTAL CONTRIBUTIONS,' + FORMAT(gvTotalNetpay));
        END; */
    end;

    procedure CreateFOSO()
    var
        WithLeadZerosNet: Text[30];
        lvEmployeeName: Text[30];
        lvEmployeeNo: Code[4];
        NoofZeros: Integer;
        i: Integer;
        lvDeptCode: Code[1];
        lvDeptRec: Record 349;
    begin
        /* gvEmpCount := 0;
        gvEmployee.SETRANGE("Mode of Payment", gvModeofPaymentCode);
        gvEmployee.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");

        IF gvEmployee.FIND('-') THEN BEGIN

            REPEAT
                lvEmployeeName := gvEmployee.FullName;
                IF gvHeader.GET(gvPeriodCode, gvEmployee."No.") THEN BEGIN
                    gvHeader.CALCFIELDS("Total Payable (LCY)", "Total Deduction (LCY)");
                    gvNetPayAmount := gvHeader."Total Payable (LCY)" - gvHeader."Total Deduction (LCY)";
                    IF gvNetPayAmount > 0 THEN BEGIN
                        gvEmpCount := gvEmpCount + 1;
                        gvTotalNetpay := gvTotalNetpay + gvNetPayAmount;
                        WithLeadZerosNet := FORMAT(gvNetPayAmount, 0, '<Precision,2:2><Standard Format,1>');
                        WithLeadZerosNet := DELCHR(WithLeadZerosNet, '=', ',');
                        NoofZeros := 15 - STRLEN(WithLeadZerosNet);
                        FOR i := 1 TO NoofZeros DO BEGIN
                            WithLeadZerosNet := '0' + WithLeadZerosNet;
                        END;

                        lvDeptRec.SETRANGE("Dimension Code", 'DEPARTMENT');
                        IF lvDeptRec.FIND('-') THEN
                            lvEmployeeName := FORMAT(lvEmployeeName, 24);
                        lvEmployeeNo := FORMAT(gvEmployee."No.", 4);

                        gvTranferFile.WRITE(
                        STRSUBSTNO('5-02-') +
                        STRSUBSTNO('01') +
                        STRSUBSTNO('/') +
                        STRSUBSTNO(lvEmployeeNo) +
                        STRSUBSTNO('-00') +
                        STRSUBSTNO(' ') +
                        STRSUBSTNO(lvEmployeeName) +
                        STRSUBSTNO(' ') +
                        STRSUBSTNO(WithLeadZerosNet) +
                        STRSUBSTNO(' '));
                    END ELSE BEGIN
                        gvNegativeCounter := gvNegativeCounter + 1;
                    END;
                END;
            UNTIL gvEmployee.NEXT = 0;
        END; */
    end;

    procedure CreatePAYNET()
    var
        WithLeadZerosNet: Text[30];
        lvEmployeeName: Text[35];
        lvEmployeeNo: Text[9];
        NoofZeros: Integer;
        i: Integer;
        lvDeptCode: Code[1];
        lvDeptRec: Record 349;
        lvCompanyName: Text[30];
        lvCompanyRec: Record 79;
        lvZeroes: Text[130];
        lvEmpBankCode: Text[2];
        lvEmpBankBranch: Text[3];
        lvEmpBankNo: Text[15];
        lvSpaces: Text[15];
        lvCountText: Text[5];
        j: Integer;
    begin
        /*   IF gvValueDate = 0D THEN ERROR('The Value Date must be specified');
          gvPayrollSetup.GET(gvAllowedPayrolls."Payroll Code");

          gvEmployee.SETRANGE("Mode of Payment", gvModeofPaymentCode);
          gvEmployee.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");

          gvEmpCount := 0;
          gvTotalNetpay := 0;

          gvHeaderDate := FORMAT(gvValueDate, 0, '<Closing><Day,2><Month,2><Year4>');
          lvCompanyRec.GET;
          lvCompanyName := FORMAT(lvCompanyRec.Name, 30);

          FOR i := 1 TO 101 DO BEGIN
              lvZeroes := '0' + lvZeroes;
          END;

          //Header Record
          gvTranferFile.WRITE(
                    STRSUBSTNO('186') +
                    STRSUBSTNO(gvHeaderDate) +
                    STRSUBSTNO('01') +
                    STRSUBSTNO('000000') +
                    STRSUBSTNO(gvPayrollSetup."Payroll Company Code") +
                    STRSUBSTNO('01100') +
                    STRSUBSTNO(lvCompanyName) +
                    STRSUBSTNO(lvZeroes));

          //Detail Records
          IF gvEmployee.FIND('-') THEN BEGIN
              REPEAT
                  lvEmployeeName := gvEmployee.FullName;
                  IF gvHeader.GET(gvPeriodCode, gvEmployee."No.") THEN BEGIN
                      gvHeader.CALCFIELDS("Total Payable (LCY)", "Total Deduction (LCY)");
                      gvNetPayAmount := gvHeader."Total Payable (LCY)" - gvHeader."Total Deduction (LCY)";

                      IF gvNetPayAmount > 0 THEN BEGIN
                          gvEmpCount := gvEmpCount + 1;
                          gvTotalNetpay := gvTotalNetpay + gvNetPayAmount;
                          WithLeadZerosNet := FORMAT(gvNetPayAmount, 0, '<Precision,2:2><Standard Format,1>');
                          WithLeadZerosNet := DELCHR(WithLeadZerosNet, '=', ',');
                          WithLeadZerosNet := DELCHR(WithLeadZerosNet, '=', '.');
                          NoofZeros := 13 - STRLEN(WithLeadZerosNet);
                          FOR i := 1 TO NoofZeros DO BEGIN
                              WithLeadZerosNet := '0' + WithLeadZerosNet;
                          END;

                          /* lvBranchRec.GET(gvEmployee."Emp Branch Code");
                           lvBranchCode := lvBranchRec."Branch ID";
                           lvBranchCode := FORMAT(lvBranchCode,2);
                           lvDeptRec.GET(gvEmployee."Department Code");
                           lvDeptCode :=  lvDeptRec."CMC Payroll Code";  


        lvEmployeeName := FORMAT(lvEmployeeName, 35);
        lvEmployeeNo := FORMAT(gvEmployee."No.", 9);
        lvEmpBankCode := FORMAT(gvEmployee."Bank Code", 2);
        lvEmpBankBranch := FORMAT(gvEmployee."Bank Branch Code", 3);
        lvEmpBankNo := FORMAT(gvEmployee."Bank Account No", 15);

        lvSpaces := '';
        FOR i := 1 TO 15 DO BEGIN
            lvSpaces := ' ' + lvSpaces;
        END;

        lvCompanyName := FORMAT(lvCompanyRec.Name, 26);

        gvTranferFile.WRITE(
        STRSUBSTNO('0058') +
        STRSUBSTNO(WithLeadZerosNet) +
        STRSUBSTNO('0') +
        STRSUBSTNO('32') +
        STRSUBSTNO('000') +
        STRSUBSTNO('000000200514408') +
        STRSUBSTNO(lvEmpBankCode) +
        STRSUBSTNO(lvEmpBankBranch) +
        STRSUBSTNO(lvEmpBankNo) +
        STRSUBSTNO('32') +
        STRSUBSTNO('000') +
        STRSUBSTNO(lvSpaces) +
        STRSUBSTNO(lvEmployeeName) +
        STRSUBSTNO(lvCompanyName) +
        STRSUBSTNO(lvEmployeeNo) +
        STRSUBSTNO('0000000000'));
    END ELSE BEGIN
                        gvNegativeCounter := gvNegativeCounter + 1;
                    END;
                END;
            UNTIL gvEmployee.NEXT = 0;

            lvCountText := FORMAT(gvEmpCount, 0);
            NoofZeros := 5 - STRLEN(lvCountText);
            FOR i := 1 TO NoofZeros DO BEGIN
                lvCountText := '0' + lvCountText;
            END;

            WithLeadZerosNet := '';
            WithLeadZerosNet := FORMAT(gvTotalNetpay, 0, '<Precision,2:2><Standard Format,1>');
            WithLeadZerosNet := DELCHR(WithLeadZerosNet, '=', ',');
            WithLeadZerosNet := DELCHR(WithLeadZerosNet, '=', '.');
            NoofZeros := 14 - STRLEN(WithLeadZerosNet);
            FOR i := 1 TO NoofZeros DO BEGIN
                WithLeadZerosNet := '0' + WithLeadZerosNet;
            END;

            lvZeroes := '';
            FOR i := 1 TO 129 DO BEGIN
                lvZeroes := '0' + lvZeroes;
            END;

            //Trailer Record
            gvTranferFile.WRITE(
            STRSUBSTNO('1901') +
            STRSUBSTNO('000000') +
            STRSUBSTNO(lvCountText) +
            STRSUBSTNO(WithLeadZerosNet) +
            STRSUBSTNO(lvZeroes));
        END; */

    end;

    procedure CreateNBK()
    var
        NoofZeros: Integer;
        WithLeadZerosNet: Text[30];
        i: Integer;
        WithLeadZerosEmpBank: Text[50];
        WithLeadZerosCoBank: Text[50];
        EmployerName: Text[50];
        ZeroFilled: Text[50];
        lvEmployeeName: Text[100];
        j: Integer;
    begin
        /*  j := 0;
         gvEmployee.SETRANGE("Mode of Payment", gvModeofPaymentCode);
         gvEmployee.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");

         IF gvEmployee.FIND('-') THEN
             REPEAT
                 j := j + 1;
                 lvEmployeeName := gvEmployee.FullName;
                 CheckNameLength(lvEmployeeName);

                 CheckReferenceLength('KEMSA' + gvEmployee."No.");

                 gvEmployee.TESTFIELD("Bank Code");
                 gvEmployee.TESTFIELD("Bank Account No");
                 CheckAccNoLength(gvEmployee."Bank Account No");

                 gvEmployeeBank.GET(gvEmployee."Bank Code");

                 gvEmployeeBank.TESTFIELD("KBA Code");
                 CheckBankCodeLength(gvEmployeeBank."KBA Code");

                 gvEmployeeBank.TESTFIELD("Bank Branch Code");
                 CheckBranchCodeLength(gvEmployeeBank."Bank Branch Code");

                 IF gvHeader.GET(gvPeriodCode, gvEmployee."No.") THEN BEGIN
                     gvHeader.CALCFIELDS("Total Payable (LCY)", "Total Deduction (LCY)");
                     gvAmountToPay := gvHeader."Total Payable (LCY)" - gvHeader."Total Deduction (LCY)";
                     IF gvAmountToPay > 0 THEN BEGIN
                         gvTranferFile.WRITE(
                         STRSUBSTNO(FORMAT(j)) + ',' +
                         STRSUBSTNO(lvEmployeeName) + ',' +
                         STRSUBSTNO(FORMAT(gvEmployeeBank."KBA Code")) + ',' +
                         STRSUBSTNO(FORMAT(gvEmployee."Bank Branch Code")) + ',' +
                         STRSUBSTNO(FORMAT(gvEmployee."Bank Account No", 13)) + ',' +
                         STRSUBSTNO(FORMAT('KEMSA' + gvEmployee."No.")) + ',' +
                         STRSUBSTNO(FORMAT(gvAmountToPay, 13, 1)));
                     END;
                 END
             UNTIL gvEmployee.NEXT = 0; */
    end;

    procedure CreateBBK()
    var
        lvEmployeeName: Text[100];
        lvNetPayText: Text[30];
    begin
        /*  gvEmployee.SETRANGE("Mode of Payment", gvModeofPaymentCode);
         gvEmployee.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
         IF gvEmployee.FIND('-') THEN
             REPEAT
                 IF gvHeader.GET(gvPeriodCode, gvEmployee."No.") THEN BEGIN
                     IF STRPOS(gvEmployee."No.", ',') > 0 THEN ERROR('Comma not allowed in Emp No %1', gvEmployee."No.");
                     IF STRLEN(gvEmployee."No.") > 15 THEN ERROR('Employee''s No %1 is longer than 15 characters.', gvEmployee."No.");

                     lvEmployeeName := gvEmployee.FullName;
                     IF STRPOS(lvEmployeeName, ',') > 0 THEN ERROR('Comma not allowed in Emp Full Name %1', lvEmployeeName);
                     IF STRLEN(lvEmployeeName) > 30 THEN ERROR('Employee''s Full Name %1 is longer than 30 characters.', lvEmployeeName);

                     gvEmployee.TESTFIELD("Bank Code");
                     IF STRPOS(gvEmployee."Bank Code", ',') > 0 THEN
                         ERROR('Comma not allowed in Bank Code %1 for Emp No %2', gvEmployee."Bank Code", gvEmployee."No.");
                     IF STRLEN(gvEmployee."Bank Code") > 5 THEN
                         ERROR('Emp No %1 Bank Code %2 is longer than 5 characters.', gvEmployee."No.", gvEmployee."Bank Code");

                     gvEmployee.TESTFIELD("Bank Account No");
                     IF STRPOS(gvEmployee."Bank Account No", ',') > 0 THEN
                         ERROR('Comma not allowed in Bank Account No %1 for Emp No %2', gvEmployee."Bank Account No", gvEmployee."No.");
                     IF STRLEN(gvEmployee."Bank Account No") > 13 THEN
                         ERROR('Emp No %1 Bank Account No %2 is longer than 13 characters.', gvEmployee."No.", gvEmployee."Bank Account No");

                     gvHeader.CALCFIELDS("Total Payable (LCY)", "Total Deduction (LCY)");
                     gvNetPayAmount := gvHeader."Total Payable (LCY)" - gvHeader."Total Deduction (LCY)";
                     IF gvNetPayAmount > 0 THEN BEGIN
                         lvNetPayText := STRSUBSTNO('%1', gvNetPayAmount);
                         lvNetPayText := DELCHR(lvNetPayText, '=', ',');
                         IF STRLEN(lvNetPayText) > 12 THEN
                             ERROR('Emp No %1 Net Pay %2 is more than 12 digits.', gvEmployee."No.", lvNetPayText);

                         gvTranferFile.WRITE(
                             gvEmployee."No." + ',' +
                             lvEmployeeName + ',' +
                             gvEmployee."Bank Code" + ',' +
                             gvEmployee."Bank Account No" + ',' +
                             lvNetPayText)
                     END;
                 END;
             UNTIL gvEmployee.NEXT = 0; */
    end;

    procedure CreateFINA()
    var
        lvEmployeeName: Text[100];
        lvNetPayText: Text[30];
        lvEmployeeBank: Record 51152;
        lvCompanyBank: Record 51152;
    begin
        /*   gvPayrollSetup.TESTFIELD("Bank Code");
          gvPayrollSetup.TESTFIELD("Bank Account No");

          lvCompanyBank.GET(gvPayrollSetup."Bank Code");
          lvCompanyBank.TESTFIELD("KBA Code");
          lvCompanyBank.TESTFIELD("Bank Branch Code");
          IF STRLEN(lvCompanyBank."KBA Code") > 2 THEN
              ERROR('Company KBA Bank Code %3 is longer than 2 characters.', lvEmployeeBank."KBA Code");
          IF STRLEN(lvCompanyBank."Bank Branch Code") > 3 THEN
              ERROR('Company KBA Bank Branch Code %3 is longer than 3 characters.', lvCompanyBank."Bank Branch Code");

          gvEmployee.SETRANGE("Mode of Payment", gvModeofPaymentCode);
          gvEmployee.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");

          IF gvEmployee.FIND('-') THEN
              REPEAT
                  IF gvHeader.GET(gvPeriodCode, gvEmployee."No.") THEN BEGIN

                      lvEmployeeName := gvEmployee.FullName;
                      IF STRLEN(lvEmployeeName) > 35 THEN ERROR('Employee''s Full Name %1 is longer than 35 characters.', lvEmployeeName);

                      gvEmployee.TESTFIELD("Bank Code");
                      lvEmployeeBank.GET(gvEmployee."Bank Code");
                      IF STRLEN(lvEmployeeBank."KBA Code") > 2 THEN
                          ERROR('Emp No %1 Bank Code %2 KBA Code %3 is longer than 2 characters.',
                             gvEmployee."No.", gvEmployee."Bank Code", lvEmployeeBank."KBA Code");

                      gvEmployee.TESTFIELD("Bank Account No");
                      IF STRLEN(gvEmployee."Bank Account No") > 15 THEN
                          ERROR('Emp No %1 Bank Account No %2 is longer than 15 characters.', gvEmployee."No.", gvEmployee."Bank Account No");

                      gvHeader.CALCFIELDS("Total Payable (LCY)", "Total Deduction (LCY)");
                      gvNetPayAmount := gvHeader."Total Payable (LCY)" - gvHeader."Total Deduction (LCY)";
                      IF gvNetPayAmount > 0 THEN BEGIN
                          lvNetPayText := STRSUBSTNO('%1', gvNetPayAmount);
                          lvNetPayText := DELCHR(lvNetPayText, '=', ',');
                          IF STRLEN(lvNetPayText) > 13 THEN
                              ERROR('Emp No %1 Net Pay %2 is more than 13 digits.', gvEmployee."No.", lvNetPayText);

                          gvTranferFile.WRITE(
                              PADSTR(lvNetPayText, 13) +
                              PADSTR(lvCompanyBank."KBA Code", 2) +
                              PADSTR(lvCompanyBank."Bank Branch Code", 3) +
                              PADSTR(gvPayrollSetup."Bank Account No", 15) +
                              PADSTR(gvPayrollSetup."Employer Name", 20) +
                              PADSTR(STRSUBSTNO('%1 Salary', gvPeriodRec.Description), 15) +
                              PADSTR(lvEmployeeName, 35) +
                              PADSTR(lvEmployeeBank."KBA Code", 2) +
                              PADSTR(lvEmployeeBank."Bank Branch Code", 3) +
                              PADSTR(gvEmployee."Bank Account No", 15) +
                              PADSTR(STRSUBSTNO('%1', gvValueDate), 10)
                              )
                      END;
                  END;
              UNTIL gvEmployee.NEXT = 0; */
    end;

    procedure CreateCFC()
    var
        lvEmployeeName: Text[100];
        lvNetPayText: Text[30];
    begin
        /*  gvEmployee.SETRANGE("Mode of Payment", gvModeofPaymentCode);
         gvEmployee.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
         //gvEmployee.SETRANGE(SACCO, FALSE);//IGS Oct 2016
         IF gvEmployee.FIND('-') THEN BEGIN
             IF gvEmployee.FINDSET(FALSE) THEN
                 REPEAT
                     IF gvHeader.GET(gvPeriodCode, gvEmployee."No.") THEN BEGIN
                         lvEmployeeName := gvEmployee.FullName;
                         IF STRPOS(lvEmployeeName, ',') > 0 THEN ERROR('Comma not allowed in Emp Full Name %1', lvEmployeeName);
                         IF STRLEN(lvEmployeeName) > 30 THEN ERROR('Employee''s Full Name %1 is longer than 30 characters.', lvEmployeeName);

                         gvEmployee.TESTFIELD("Bank Code");
                         IF STRPOS(gvEmployee."Bank Code", ',') > 0 THEN
                             ERROR('Comma not allowed in Bank Code %1 for Emp No %2', gvEmployee."Bank Code", gvEmployee."No.");
                         IF STRLEN(gvEmployee."Bank Code") > 5 THEN
                             ERROR('Emp No %1 Bank Code %2 is longer than 5 characters.', gvEmployee."No.", gvEmployee."Bank Code");

                         gvEmployee.TESTFIELD("Bank Account No");
                         IF STRPOS(gvEmployee."Bank Account No", ',') > 0 THEN
                             ERROR('Comma not allowed in Bank Account No %1 for Emp No %2', gvEmployee."Bank Account No", gvEmployee."No.");
                         //IF STRLEN(gvEmployee."Bank Account No.") > 13 THEN
                         //  ERROR('Emp No %1 Bank Account No %2 is longer than 13 characters.', gvEmployee."No.", gvEmployee."Bank Account No.");

                         gvHeader.CALCFIELDS("Total Payable (LCY)", "Total Deduction (LCY)");
                         gvNetPayAmount := gvHeader."Total Payable (LCY)" - gvHeader."Total Deduction (LCY)";

                         IF gvNetPayAmount > 0 THEN BEGIN
                             lvNetPayText := STRSUBSTNO('%1', gvNetPayAmount);
                             lvNetPayText := DELCHR(lvNetPayText, '=', ',');
                             IF STRLEN(lvNetPayText) > 12 THEN
                                 ERROR('Emp No %1 Net Pay %2 is more than 12 digits.', gvEmployee."No.", lvNetPayText);

                             gvTranferFile.WRITE(
                                 lvEmployeeName + ',' + gvEmployee."Bank Account No" + ',' + gvEmployee."Bank Code" + ',' +
                                 lvNetPayText + ',' +
                                 FORMAT('Salary ' + gvPeriodCode + ' for ' + gvEmployee."No."))
                         END;
                     END;
                 UNTIL gvEmployee.NEXT = 0;
         END;

         gvNetPayAmount := 0;
         gvEmployee.RESET;
         gvEmployee.SETRANGE("Mode of Payment", gvModeofPaymentCode);
         gvEmployee.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
         //gvEmployee.SETRANGE(SACCO, TRUE);//IGS Oct 2016
         IF gvEmployee.FIND('-') THEN BEGIN
             REPEAT
                 lvEmployeeName := 'SACCO Employees';
                 IF gvHeader.GET(gvPeriodCode, gvEmployee."No.") THEN BEGIN
                     gvHeader.CALCFIELDS("Total Payable (LCY)", "Total Deduction (LCY)");
                     gvNetPayAmount := gvNetPayAmount + (gvHeader."Total Payable (LCY)" - gvHeader."Total Deduction (LCY)");
                 END;
             UNTIL gvEmployee.NEXT = 0;
             IF STRPOS(lvEmployeeName, ',') > 0 THEN ERROR('Comma not allowed in Emp Full Name %1', lvEmployeeName);
             IF STRLEN(lvEmployeeName) > 30 THEN ERROR('Employee''s Full Name %1 is longer than 30 characters.', lvEmployeeName);

             gvEmployee.TESTFIELD("Bank Code");
             IF STRPOS(gvEmployee."Bank Code", ',') > 0 THEN
                 ERROR('Comma not allowed in Bank Code %1 for Emp No %2', gvEmployee."Bank Code", gvEmployee."No.");
             IF STRLEN(gvEmployee."Bank Code") > 5 THEN
                 ERROR('Emp No %1 Bank Code %2 is longer than 5 characters.', gvEmployee."No.", gvEmployee."Bank Code");

             gvEmployee.TESTFIELD("Bank Account No");
             IF STRPOS(gvEmployee."Bank Account No", ',') > 0 THEN
                 ERROR('Comma not allowed in Bank Account No %1 for Emp No %2', gvEmployee."Bank Account No", gvEmployee."No.");
             //IF STRLEN(gvEmployee."Bank Account No.") > 13 THEN
             //  ERROR('Emp No %1 Bank Account No %2 is longer than 13 characters.', gvEmployee."No.", gvEmployee."Bank Account No.");
             IF gvNetPayAmount > 0 THEN BEGIN
                 lvNetPayText := STRSUBSTNO('%1', gvNetPayAmount);
                 lvNetPayText := DELCHR(lvNetPayText, '=', ',');
                 IF STRLEN(lvNetPayText) > 12 THEN
                     ERROR('Emp No %1 Net Pay %2 is more than 12 digits.', gvEmployee."No.", lvNetPayText);

                 gvTranferFile.WRITE(
                     lvEmployeeName + ',' + gvEmployee."Bank Account No" + ',' + gvEmployee."Bank Code" + ',' +
                     lvNetPayText + ',' +
                     FORMAT('Salary ' + gvPeriodCode + ' for SACCO employees'))
             END;
         END; */
    end;

    procedure CheckNameLength(Name: Text[100])
    begin
        IF STRLEN(Name) > 35 THEN
            ERROR('Employee Full Name cannot exceed 35 characters, value is %1 for employee No. %2', Name, gvEmployee."No.");
    end;

    procedure CheckBankCodeLength(BankCode: Code[5])
    begin
        IF STRLEN(BankCode) > 2 THEN
            ERROR('Bank Code cannot exceed 2 characters, value is %1 for employee %2', BankCode, gvEmployee."No.");
    end;

    procedure CheckBranchCodeLength(BranchCode: Code[5])
    begin
        IF STRLEN(BranchCode) > 3 THEN
            ERROR('Bank Branch Code cannot exceed 3 characters, value is %1 for employee %2', BranchCode, gvEmployee."No.");
    end;

    procedure CheckAccNoLength(AccountNo: Code[15])
    begin
        IF STRLEN(AccountNo) > 13 THEN
            ERROR('Employee Bank Account number cannot exceed 13 characters, value is %1 for employee %2', AccountNo, gvEmployee."No.");
    end;

    procedure CheckReferenceLength(Reference: Text[15])
    begin
        IF STRLEN(Reference) > 12 THEN
            ERROR('Reference number cannot exceed 13 characters, value is %1 for employee %2', Reference, gvEmployee."No.");
    end;

    procedure CreateCFCSFI()
    var
        lvEmployeeName: Text[100];
        lvNetPayText: Text[30];
        lvEmployeeBank: Record 51152;
        SortCode: Text[30];
        lvEDAmount: Decimal;
        lvEDAmountText: Text[30];
    begin
        /*  gvEmployee.SETRANGE("Mode of Payment", gvModeofPaymentCode);
         gvEmployee.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");

         IF gvEmployee.FINDSET(FALSE) THEN
             REPEAT
                 IF gvHeader.GET(gvPeriodCode, gvEmployee."No.") THEN BEGIN
                     lvEmployeeName := gvEmployee.FullName;
                     IF STRPOS(lvEmployeeName, ',') > 0 THEN ERROR('Comma not allowed in Emp Full Name %1', lvEmployeeName);
                     IF STRLEN(lvEmployeeName) > 30 THEN ERROR('Employee''s Full Name %1 is longer than 30 characters.', lvEmployeeName);

                     gvEmployee.TESTFIELD("Bank Code");
                     IF STRPOS(gvEmployee."Bank Code", ',') > 0 THEN
                         ERROR('Comma not allowed in Bank Code %1 for Emp No %2', gvEmployee."Bank Code", gvEmployee."No.");

                     IF lvEmployeeBank.GET(gvEmployee."Bank Code") THEN
                         //SortCode := FORMAT(lvEmployeeBank."KBA Code" + lvEmployeeBank."Bank Branch Code");
                         SortCode := FORMAT(gvEmployee."Bank Code");//IGS 2016
                     IF STRLEN(SortCode) > 5 THEN
                         ERROR('Emp No %1''s bank code and branch code combined is longer than 5 characters.', gvEmployee."No.");

                     gvEmployee.TESTFIELD("Bank Account No");
                     IF STRPOS(gvEmployee."Bank Account No", ',') > 0 THEN
                         ERROR('Comma not allowed in Bank Account No %1 for Emp No %2', gvEmployee."Bank Account No", gvEmployee."No.");
                     IF STRLEN(gvEmployee."Bank Account No") > 13 THEN
                         ERROR('Emp No %1 Bank Account No %2 is longer than 13 characters.', gvEmployee."No.", gvEmployee."Bank Account No");

                     IF gvEDCode <> '' THEN BEGIN
                         gvEmployee.SETFILTER("ED Code Filter", gvEDCode);
                         gvEmployee.SETFILTER("Period Filter", gvPeriodCode);
                         gvEmployee.CALCFIELDS(Amount);
                         lvEDAmount := gvEmployee.Amount;
                         IF lvEDAmount > 0 THEN BEGIN
                             lvEDAmountText := STRSUBSTNO('%1', lvEDAmount);
                             lvEDAmountText := DELCHR(lvEDAmountText, '=', ',');
                             IF STRLEN(lvEDAmountText) > 12 THEN
                                 ERROR('Emp No %1 Amount %2 is more than 12 digits.', gvEmployee."No.", lvEDAmountText);

                             gvTranferFile.WRITE(
                                 lvEmployeeName + ',' +
                                 gvEmployee."Bank Account No" + ',' +
                                 SortCode + ',' +
                                 lvEDAmountText + ',' +
                                 gvEmployee."No.");
                         END;
                     END ELSE BEGIN
                         gvHeader.CALCFIELDS("Total Payable (LCY)", "Total Deduction (LCY)");
                         gvNetPayAmount := gvHeader."Total Payable (LCY)" - gvHeader."Total Deduction (LCY)";
                         IF gvNetPayAmount > 0 THEN BEGIN
                             lvNetPayText := STRSUBSTNO('%1', gvNetPayAmount);
                             lvNetPayText := DELCHR(lvNetPayText, '=', ',');
                             IF STRLEN(lvNetPayText) > 12 THEN
                                 ERROR('Emp No %1 Net Pay %2 is more than 12 digits.', gvEmployee."No.", lvNetPayText);

                             IF gvNetPayAmount > 0 THEN
                                 gvTranferFile.WRITE(
                                     lvEmployeeName + ',' +
                                   gvEmployee."Bank Account No" + ',' +
                                   SortCode + ',' +
                                   lvNetPayText + ',' +
                                   gvEmployee."No.");
                         END;
                     END;
                 END
             UNTIL gvEmployee.NEXT = 0; */
    end;

    procedure CreateHELBFile()
    var
        lvPayrollLine: Record 51160;
        lvTempExcelBuffer: Record 370 temporary;
        lvEmployee: Record 5200;
        lvTotalAmount: Decimal;
    begin
        /*   IF gvEDCode = '' THEN ERROR('ED Code must be specified for HELB file');
          lvPayrollLine.SETRANGE("Payroll ID", gvPeriodCode);
          lvPayrollLine.Rec.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
          lvPayrollLine.SETRANGE("ED Code", gvEDCode);
          IF lvPayrollLine.FINDFIRST THEN BEGIN
              PayrollSetup.GET(gvAllowedPayrolls."Payroll Code");
              lvTempExcelBuffer.AddColumn('HELB LOAN MONTHLY REPAYMENT SCHEDULE', FALSE, '', TRUE, FALSE, FALSE, '', lvTempExcelBuffer."Cell Type"::Text);
              lvTempExcelBuffer.NewRow;
              lvTempExcelBuffer.NewRow;
              lvTempExcelBuffer.AddColumn('NAME OF EMPLOYER', FALSE, '', TRUE, FALSE, FALSE, '', lvTempExcelBuffer."Cell Type"::Text);
              lvTempExcelBuffer.AddColumn(PayrollSetup."Employer Name", FALSE, '', TRUE, FALSE, FALSE, '', lvTempExcelBuffer."Cell Type"::Text);
              lvTempExcelBuffer.AddColumn(' ', FALSE, '', TRUE, FALSE, FALSE, '', lvTempExcelBuffer."Cell Type"::Text);
              lvTempExcelBuffer.AddColumn(' ', FALSE, '', TRUE, FALSE, FALSE, '', lvTempExcelBuffer."Cell Type"::Text);
              lvTempExcelBuffer.AddColumn('EMPLOYER PIN NO.', FALSE, '', TRUE, FALSE, FALSE, '', lvTempExcelBuffer."Cell Type"::Text);
              lvTempExcelBuffer.AddColumn(PayrollSetup."Employer PIN No.", FALSE, '', TRUE, FALSE, FALSE, '', lvTempExcelBuffer."Cell Type"::Text);
              lvTempExcelBuffer.NewRow;
              lvTempExcelBuffer.AddColumn('POSTAL ADDRESS', FALSE, '', TRUE, FALSE, FALSE, '', lvTempExcelBuffer."Cell Type"::Text);
              lvTempExcelBuffer.AddColumn(PayrollSetup."Employers Address", FALSE, '', TRUE, FALSE, FALSE, '', lvTempExcelBuffer."Cell Type"::Text);
              lvTempExcelBuffer.AddColumn(' ', FALSE, '', TRUE, FALSE, FALSE, '', lvTempExcelBuffer."Cell Type"::Text);
              lvTempExcelBuffer.AddColumn(' ', FALSE, '', TRUE, FALSE, FALSE, '', lvTempExcelBuffer."Cell Type"::Text);
              lvTempExcelBuffer.AddColumn('EMPLOYER HELB No.', FALSE, '', TRUE, FALSE, FALSE, '', lvTempExcelBuffer."Cell Type"::Text);
              lvTempExcelBuffer.AddColumn(PayrollSetup."Employer HELB No.", FALSE, '', TRUE, FALSE, FALSE, '', lvTempExcelBuffer."Cell Type"::Text);
              lvTempExcelBuffer.NewRow;
              lvTempExcelBuffer.NewRow;
              lvTempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', lvTempExcelBuffer."Cell Type"::Text);
              lvTempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', lvTempExcelBuffer."Cell Type"::Text);
              lvTempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', lvTempExcelBuffer."Cell Type"::Text);
              lvTempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', lvTempExcelBuffer."Cell Type"::Text);
              lvTempExcelBuffer.AddColumn('PAYROLL MONTH', FALSE, '', TRUE, FALSE, FALSE, '', lvTempExcelBuffer."Cell Type"::Text);
              //lvTempExcelBuffer.AddColumn(,FALSE,'',TRUE,FALSE,TRUE,'',lvTempExcelBuffer."Cell Type"::Text);
              lvTempExcelBuffer.NewRow;
              lvTempExcelBuffer.NewRow;
              lvTempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', lvTempExcelBuffer."Cell Type"::Text);
              lvTempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', lvTempExcelBuffer."Cell Type"::Text);
              lvTempExcelBuffer.AddColumn('HELB PAYMENT DETAILS', FALSE, '', TRUE, FALSE, TRUE, '', lvTempExcelBuffer."Cell Type"::Text);
              lvTempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', lvTempExcelBuffer."Cell Type"::Text);
              lvTempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', lvTempExcelBuffer."Cell Type"::Text);
              lvTempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', lvTempExcelBuffer."Cell Type"::Text);
              lvTempExcelBuffer.NewRow;
              lvTempExcelBuffer.AddColumn('S/NO', FALSE, '', TRUE, FALSE, TRUE, '', lvTempExcelBuffer."Cell Type"::Text);
              lvTempExcelBuffer.AddColumn('PAYROLL NO.', FALSE, '', TRUE, FALSE, TRUE, '', lvTempExcelBuffer."Cell Type"::Text);
              lvTempExcelBuffer.AddColumn('NAME OF LOANEE', FALSE, '', TRUE, FALSE, TRUE, '', lvTempExcelBuffer."Cell Type"::Text);
              lvTempExcelBuffer.AddColumn('ID NO.', FALSE, '', TRUE, FALSE, TRUE, '', lvTempExcelBuffer."Cell Type"::Text);
              lvTempExcelBuffer.AddColumn('PIN NO.', FALSE, '', TRUE, FALSE, TRUE, '', lvTempExcelBuffer."Cell Type"::Text);
              lvTempExcelBuffer.AddColumn('AMOUNT DEDUCTED', FALSE, '', TRUE, FALSE, TRUE, '', lvTempExcelBuffer."Cell Type"::Text);
              REPEAT
                  lvTempExcelBuffer.NewRow;
                  lvEmployee.GET(lvPayrollLine."Employee No.");
                  lvTempExcelBuffer.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', lvTempExcelBuffer."Cell Type"::Text);
                  lvTempExcelBuffer.AddColumn(lvPayrollLine."Employee No.", FALSE, '', FALSE, FALSE, FALSE, '', lvTempExcelBuffer."Cell Type"::Text);
                  lvTempExcelBuffer.AddColumn(lvEmployee.FullName, FALSE, '', FALSE, FALSE, FALSE, '', lvTempExcelBuffer."Cell Type"::Text);
                  lvTempExcelBuffer.AddColumn(lvEmployee."National ID", FALSE, '', FALSE, FALSE, FALSE, '', lvTempExcelBuffer."Cell Type"::Text);
                  lvTempExcelBuffer.AddColumn(lvEmployee.PIN, FALSE, '', FALSE, FALSE, FALSE, '', lvTempExcelBuffer."Cell Type"::Text);
                  lvTempExcelBuffer.AddColumn(ABS(lvPayrollLine."Amount (LCY)"), FALSE, '', FALSE, FALSE, FALSE, '', lvTempExcelBuffer."Cell Type"::Number);
                  lvTotalAmount += ABS(lvPayrollLine."Amount (LCY)");
              UNTIL lvPayrollLine.NEXT = 0;
          END;
          lvTempExcelBuffer.NewRow;
          lvTempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', lvTempExcelBuffer."Cell Type"::Text);
          lvTempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', lvTempExcelBuffer."Cell Type"::Text);
          lvTempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', lvTempExcelBuffer."Cell Type"::Text);
          lvTempExcelBuffer.AddColumn('TOTAL DEDUCTIONS (KSHS)', FALSE, '', TRUE, FALSE, FALSE, '', lvTempExcelBuffer."Cell Type"::Text);
          lvTempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', lvTempExcelBuffer."Cell Type"::Text);
          lvTempExcelBuffer.AddColumn(lvTotalAmount, FALSE, '', TRUE, FALSE, FALSE, '', lvTempExcelBuffer."Cell Type"::Number);

          lvTempExcelBuffer.CreateBook(STRSUBSTNO('HELB - %1', gvPeriodCode), gvPeriodCode);
          lvTempExcelBuffer.WriteSheet(gvAllowedPayrolls."Payroll Code", COMPANYNAME, USERID);
          lvTempExcelBuffer.CloseBook;
          lvTempExcelBuffer.OpenExcel;
          //lvTempExcelBuffer.UpdateBookStrea */
    end;

    procedure CreateSCB()
    var
        WithLeadZerosNet: Text[30];
        lvEmployeeName: Text[35];
        lvEmployeeNo: Text[9];
        NoofZeros: Integer;
        i: Integer;
        lvDeptCode: Code[1];
        lvDeptRec: Record 349;
        lvCompanyName: Text[30];
        lvCompanyRec: Record 79;
        lvZeroes: Text[130];
        lvEmpBankCode: Text[2];
        lvEmpBankBranch: Text[3];
        lvEmpBankNo: Text[15];
        lvSpaces: Text[15];
        lvCountText: Text[5];
        j: Integer;
    begin
        /*  IF gvValueDate = 0D THEN ERROR('The Value Date must be specified');
         gvPayrollSetup.GET(gvAllowedPayrolls."Payroll Code");

         gvEmployee.SETRANGE("Mode of Payment", gvModeofPaymentCode);
         gvEmployee.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
         //gvEmployee.SETRANGE(SACCO, FALSE);//IGS Oct 2016
         gvEmpCount := 0;
         gvTotalNetpay := 0;

         gvHeaderDate := FORMAT(gvValueDate, 0, '<Closing><Day,2>/<Month,2>/<Year4>');
         lvCompanyRec.GET;
         lvCompanyName := FORMAT(lvCompanyRec.Name, 30);

         FOR i := 1 TO 101 DO BEGIN
             lvZeroes := '0' + lvZeroes;
         END;

         //Header Record
         gvTranferFile.WRITE(
                   'H,P');

         //Detail Records
         IF gvEmployee.FIND('-') THEN BEGIN
             REPEAT
                 lvEmployeeName := gvEmployee.FullName;
                 IF gvHeader.GET(gvPeriodCode, gvEmployee."No.") THEN BEGIN
                     gvHeader.CALCFIELDS("Total Payable (LCY)", "Total Deduction (LCY)");
                     gvNetPayAmount := gvHeader."Total Payable (LCY)" - gvHeader."Total Deduction (LCY)";

                     IF gvNetPayAmount > 0 THEN BEGIN
                         gvEmpCount := gvEmpCount + 1;
                         gvTotalNetpay := gvTotalNetpay + gvNetPayAmount;
                         WithLeadZerosNet := FORMAT(gvNetPayAmount, 0, '<Precision,2:2><Standard Format,1>');
                         WithLeadZerosNet := DELCHR(WithLeadZerosNet, '=', ',');
                         WithLeadZerosNet := DELCHR(WithLeadZerosNet, '=', '.');
                         NoofZeros := 13 - STRLEN(WithLeadZerosNet);
                         FOR i := 1 TO NoofZeros DO BEGIN
                             WithLeadZerosNet := '0' + WithLeadZerosNet;
                         END;

                         /* lvBranchRec.GET(gvEmployee."Emp Branch Code");
                          lvBranchCode := lvBranchRec."Branch ID";
                          lvBranchCode := FORMAT(lvBranchCode,2);
                          lvDeptRec.GET(gvEmployee."Department Code");
                          lvDeptCode :=  lvDeptRec."CMC Payroll Code";  


                         lvEmployeeName := FORMAT(lvEmployeeName, 35);
                         lvEmployeeNo := FORMAT(gvEmployee."No.", 9);
                         lvEmpBankCode := FORMAT(gvEmployee."Bank Code", 2);
                         lvEmpBankBranch := COPYSTR(gvEmployee."Bank Code", 3, 3);
                         lvEmpBankNo := FORMAT(gvEmployee."Bank Account No", 15);

                         lvSpaces := '';
                         FOR i := 1 TO 15 DO BEGIN
                             lvSpaces := ' ' + lvSpaces;
                         END;

                         lvCompanyName := FORMAT(lvCompanyRec.Name, 26);
                         //gvNetPayAmount:=DELCHR(FORMAT(gvNetPayAmount),'=',',');//IGS Sep 2016
                         gvTranferFile.WRITE(
                         STRSUBSTNO('P,PAY, BA,,') +
                         STRSUBSTNO(DELCHR(lvEmployeeNo, '<>', ' ')) +
                         STRSUBSTNO(',,KE,NBO,0106023681600,') +
                         STRSUBSTNO(gvHeaderDate) +
                         STRSUBSTNO(',') +
                         STRSUBSTNO(DELCHR(lvEmployeeName, '<>', ' ')) +
                         STRSUBSTNO(',') +
                         STRSUBSTNO(',,,,') +
                         STRSUBSTNO(lvEmpBankCode) +
                         STRSUBSTNO(',,') +
                         STRSUBSTNO(lvEmpBankBranch) +
                         STRSUBSTNO(',,') +
                         STRSUBSTNO(DELCHR(lvEmpBankNo, '<>', ' ')) +
                         STRSUBSTNO(',,,,,,,,,,,,,,,,,,') +
                         STRSUBSTNO('KES') +
                         STRSUBSTNO(',') +
                         FORMAT(DELCHR(FORMAT(gvNetPayAmount), '=', ',')) +
                         STRSUBSTNO(',,,,,,,,,,,,,,,,,,,,,,') +
                         STRSUBSTNO('SCBLKENXXXX,,'));

                     END ELSE BEGIN
                         gvNegativeCounter := gvNegativeCounter + 1;
                     END;
                 END;
             UNTIL gvEmployee.NEXT = 0;
             /*
                       lvCountText:= FORMAT(gvEmpCount,0);
                       NoofZeros := 5 - STRLEN(lvCountText);
                       FOR i := 1 TO NoofZeros  DO
                       BEGIN
                       lvCountText := '0' + lvCountText;
                       END;

             //IGS Oct 2016
             gvNetPayAmount := 0;
             gvEmployee.SETRANGE("Mode of Payment", gvModeofPaymentCode);
             gvEmployee.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
             //gvEmployee.SETRANGE(SACCO, TRUE);//IGS Oct 2016
             IF gvEmployee.FIND('-') THEN BEGIN
                 REPEAT
                     lvEmployeeName := 'SACCO Employees';
                     IF gvHeader.GET(gvPeriodCode, gvEmployee."No.") THEN BEGIN
                         gvHeader.CALCFIELDS("Total Payable (LCY)", "Total Deduction (LCY)");
                         gvNetPayAmount := gvNetPayAmount + (gvHeader."Total Payable (LCY)" - gvHeader."Total Deduction (LCY)");
                     END;
                 UNTIL gvEmployee.NEXT = 0;

                 IF gvNetPayAmount > 0 THEN BEGIN
                     gvEmpCount := gvEmpCount + 1;
                     gvTotalNetpay := gvTotalNetpay + gvNetPayAmount;
                     WithLeadZerosNet := FORMAT(gvNetPayAmount, 0, '<Precision,2:2><Standard Format,1>');
                     WithLeadZerosNet := DELCHR(WithLeadZerosNet, '=', ',');
                     WithLeadZerosNet := DELCHR(WithLeadZerosNet, '=', '.');
                     NoofZeros := 13 - STRLEN(WithLeadZerosNet);
                     FOR i := 1 TO NoofZeros DO BEGIN
                         WithLeadZerosNet := '0' + WithLeadZerosNet;
                     END;

                     /* lvBranchRec.GET(gvEmployee."Emp Branch Code");
                      lvBranchCode := lvBranchRec."Branch ID";
                      lvBranchCode := FORMAT(lvBranchCode,2);
                      lvDeptRec.GET(gvEmployee."Department Code");
                      lvDeptCode :=  lvDeptRec."CMC Payroll Code"; 


                     lvEmployeeName := FORMAT(lvEmployeeName, 35);
                     lvEmployeeNo := FORMAT(9999, 9);//IGS Oct 2016
                     lvEmpBankCode := FORMAT(gvEmployee."Bank Code", 2);
                     lvEmpBankBranch := COPYSTR(gvEmployee."Bank Code", 3, 3);
                     lvEmpBankNo := FORMAT(gvEmployee."Bank Account No", 15);

                     lvSpaces := '';
                     FOR i := 1 TO 15 DO BEGIN
                         lvSpaces := ' ' + lvSpaces;
                     END;

                     lvCompanyName := FORMAT(lvCompanyRec.Name, 26);
                     //gvNetPayAmount:=DELCHR(FORMAT(gvNetPayAmount),'=',',');//IGS Sep 2016
                     gvTranferFile.WRITE(
                     STRSUBSTNO('P,PAY, BA,,') +
                     STRSUBSTNO(DELCHR(lvEmployeeNo, '<>', ' ')) +
                     STRSUBSTNO(',,KE,NBO,0106023681600,') +
                     STRSUBSTNO(gvHeaderDate) +
                     STRSUBSTNO(',') +
                     STRSUBSTNO(DELCHR(lvEmployeeName, '<>', ' ')) +
                     STRSUBSTNO(',') +
                     STRSUBSTNO(',,,,') +
                     STRSUBSTNO(lvEmpBankCode) +
                     STRSUBSTNO(',,') +
                     STRSUBSTNO(lvEmpBankBranch) +
                     STRSUBSTNO(',,') +
                     STRSUBSTNO(DELCHR(lvEmpBankNo, '<>', ' ')) +
                     STRSUBSTNO(',,,,,,,,,,,,,,,,,,') +
                     STRSUBSTNO('KES') +
                     STRSUBSTNO(',') +
                     FORMAT(DELCHR(FORMAT(gvNetPayAmount), '=', ',')) +
                     STRSUBSTNO(',,,,,,,,,,,,,,,,,,,,,,') +
                     STRSUBSTNO('SCBLKENXXXX,,'));

                 END ELSE BEGIN
                     gvNegativeCounter := gvNegativeCounter + 1;
                 END;
             END;
             //IGS OCT 2016
             lvCountText := FORMAT(gvEmpCount, 0);
             NoofZeros := 5 - STRLEN(lvCountText);
             FOR i := 1 TO NoofZeros DO BEGIN
                 lvCountText := '0' + lvCountText;
             END;

             WithLeadZerosNet := '';
             WithLeadZerosNet := FORMAT(gvTotalNetpay, 0, '<Precision,2:2><Standard Format,1>');
             WithLeadZerosNet := DELCHR(WithLeadZerosNet, '=', ',');
             WithLeadZerosNet := DELCHR(WithLeadZerosNet, '=', '.');
             NoofZeros := 14 - STRLEN(WithLeadZerosNet);
             FOR i := 1 TO NoofZeros DO BEGIN
                 WithLeadZerosNet := '0' + WithLeadZerosNet;
             END;

             lvZeroes := '';
             FOR i := 1 TO 129 DO BEGIN
                 lvZeroes := '0' + lvZeroes;
             END;

             //Trailer Record
             //gvTotalNetpay:=DELCHR(gvTotalNetpay,'=',',');//IGS Sep 2016
             gvTranferFile.WRITE(
             STRSUBSTNO('T,') +
             STRSUBSTNO(lvCountText) +
             STRSUBSTNO(',') +
             FORMAT(DELCHR(FORMAT(gvTotalNetpay), '=', ',')) +
             STRSUBSTNO(''));
         END;
  */
    end;

    procedure CreateCOOP()
    var
        lvEmployeeName: Text[100];
        lvNetPayText: Text[30];
        DRAccount: Text[30];
        Pmenthod: Text[50];
        Swift: Text[30];
        Curr: Text[30];
        Date: Date;
        ChargeBy: Text[30];
        DealN: Text[30];
        lvEmployeeNo: Code[20];
        lvBankCode: Code[20];
        lvBankAccoNo: Code[20];
    begin
        /*   gvEmployee.SETRANGE("Mode of Payment", gvModeofPaymentCode);//mesh
          gvEmployee.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
          IF gvEmployee.FIND('-') THEN
              gvHeaderText := 'Employee No.,' + 'Employee Name,' + 'Bank Code,' + 'Bank Account No.,' + 'Net Pay,' + 'Payment Method,' + 'DR Account,' + 'Swift,' + 'Details,' + 'Currency,' + 'Date,' +
               'Charge By,' + 'Deal No';

          gvTranferFile.WRITE(STRSUBSTNO(gvHeaderText));

          REPEAT
              IF gvHeader.GET(gvPeriodCode, gvEmployee."No.") THEN BEGIN
                  IF STRPOS(gvEmployee."No.", ',') > 0 THEN ERROR('Comma not allowed in Emp No %1', gvEmployee."No.");
                  IF STRLEN(gvEmployee."No.") > 15 THEN ERROR('Employee''s No %1 is longer than 15 characters.', gvEmployee."No.");
                  lvEmployeeNo := gvEmployee."No.";

                  IF STRPOS(lvEmployeeName, ',') > 0 THEN ERROR('Comma not allowed in Emp Full Name %1', lvEmployeeName);
                  IF STRLEN(lvEmployeeName) > 30 THEN ERROR('Employee''s Full Name %1 is longer than 30 characters.', lvEmployeeName);
                  lvEmployeeName := gvEmployee.FullName;

                  gvEmployee.TESTFIELD("Bank Code");
                  IF STRPOS(gvEmployee."Bank Code", ',') > 0 THEN
                      ERROR('Comma not allowed in Bank Code %1 for Emp No %2', gvEmployee."Bank Code", gvEmployee."No.");
                  IF STRLEN(gvEmployee."Bank Code") > 5 THEN
                      ERROR('Emp No %1 Bank Code %2 is longer than 5 characters.', gvEmployee."No.", gvEmployee."Bank Code");
                  lvBankCode := gvEmployee."Bank Code";

                  gvEmployee.TESTFIELD("Bank Account No");
                  IF STRPOS(gvEmployee."Bank Account No", ',') > 0 THEN
                      ERROR('Comma not allowed in Bank Account No %1 for Emp No %2', gvEmployee."Bank Account No", gvEmployee."No.");
                  IF STRLEN(gvEmployee."Bank Account No") > 15 THEN
                      ERROR('Emp No %1 Bank Account No %2 is longer than 13 characters.', gvEmployee."No.", gvEmployee."Bank Account No");
                  lvBankAccoNo := gvEmployee."Bank Account No";

                  gvHeader.CALCFIELDS("Total Payable (LCY)", "Total Deduction (LCY)");
                  gvNetPayAmount := gvHeader."Total Payable (LCY)" - gvHeader."Total Deduction (LCY)";
                  IF gvNetPayAmount > 0 THEN BEGIN
                      lvNetPayText := STRSUBSTNO('%1', gvNetPayAmount);
                      lvNetPayText := DELCHR(lvNetPayText, '=', ',');
                      IF STRLEN(lvNetPayText) > 12 THEN
                          ERROR('Emp No %1 Net Pay %2 is more than 12 digits.', gvEmployee."No.", lvNetPayText);
                      //gvTranferFile.CREATETEMPFILE();//mesh
                      sasa := '';
                      gvTranferFile.WRITE(
                          gvEmployee."No." + ',' +//''''
                          lvEmployeeName + ',' +
                          gvEmployee."Bank Code" + ',' +
                          gvEmployee."Bank Account No" + ',' +
                          lvNetPayText + ',' +
                          'corporate salary transfer' + ',' +
                          '01136087648600' + ',' +//sai
                          ',' +
                          gvFileName + ',' +
                          'KES' + ',' +
                          ',' +
                          'BEN' + ',' +
                          ' ')
                  END;//CreateCOOP-sasa
              END;

          UNTIL gvEmployee.NEXT = 0;
          gvTranferFile.CREATEINSTREAM(NewStream);
          //ToFile:='SampleFile.txt';
          ToFile := gvFileName + '.' + 'txt';
          //ToFile:=gvFileName+'.xlsx';
          // Transfer the content from the temporary file on the NAV server to a
          // file on the RoleTailored client.
          ReturnValue := DOWNLOADFROMSTREAM(
            NewStream,
            'Save File to RoleTailored Client',
            '',
            'Text File *.txt| *.txt',
            //'Text File*.csv|*.csv',
            ToFile);
          //ToFile);
          // Close the temporary file and delete it from NAV server.
          //TempFile.CLOSE();
          // Post a message indicating that the file is saved on the client.
          MESSAGE(FORMAT(ToFile)); */
    end;

    procedure CreateKCB()
    var
        lvEmployeeName: Text[100];
        lvNetPayText: Text[30];
        LvDebitAcc: Code[15];
        BranchBIC: Code[10];
        EmpBank: Record 51152;
        BankName: Text[100];
        Branch: Text[100];
        SortCode: Code[10];
    begin
        /*  gvEmployee.SETRANGE("Mode of Payment", gvModeofPaymentCode);
         gvEmployee.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
         IF gvEmployee.FIND('-') THEN
             gvHeaderText := 'Debit/From Account,' + 'Your Branch BIC/SORT Code,' + 'Beneficiary Name,' + 'Bank,' + 'Branch,' + 'BIC/SORT Code (Mpesa 99999),' + 'Account No./ Phone Number,' + 'Net Pay/Amount,';
         gvTranferFile.WRITE(STRSUBSTNO(gvHeaderText));
         //gvTranferFile.WRITE('');
         REPEAT
             IF gvHeader.GET(gvPeriodCode, gvEmployee."No.") THEN BEGIN
                 LvDebitAcc := '1224944313';
                 IF STRPOS(LvDebitAcc, ',') > 0 THEN ERROR('Comma not Debit/From Account %1', LvDebitAcc);
                 IF STRLEN(LvDebitAcc) > 15 THEN ERROR('Debit/From Account %1 is longer than 15 characters.', LvDebitAcc);

                 BranchBIC := '01259';
                 IF STRPOS(BranchBIC, ',') > 0 THEN ERROR('Comma not Your Branch BIC/SORT Code %1', BranchBIC);
                 IF STRLEN(BranchBIC) > 10 THEN ERROR('Your Branch BIC/SORT Code %1 is longer tha 15 characters.', BranchBIC);

                 IF STRPOS(gvEmployee."No.", ',') > 0 THEN ERROR('Comma not allowed in Emp No %1', gvEmployee."No.");
                 IF STRLEN(gvEmployee."No.") > 15 THEN ERROR('Employee''s No %1 is longer than 15 characters.', gvEmployee."No.");

                 lvEmployeeName := gvEmployee."First Name" + ' ' + gvEmployee."Middle Name" + ' ' + gvEmployee."Last Name";
                 IF STRPOS(lvEmployeeName, ',') > 0 THEN ERROR('Comma not allowed in Emp Full Name %1', lvEmployeeName);
                 IF STRLEN(lvEmployeeName) > 30 THEN ERROR('Employee''s Full Name %1 is longer than 30 characters.', lvEmployeeName);
                 gvEmployee.TESTFIELD("Bank Code");
                 EmpBank.SETRANGE("No.", gvEmployee."Bank Code");
                 IF EmpBank.FIND('-') THEN
                     BankName := EmpBank.Name;
                 Branch := EmpBank.Branch;
                 SortCode := EmpBank."KBA Code";

                 IF STRPOS(BankName, ',') > 0 THEN ERROR('Comma not allowed in Bank %1', BankName);
                 IF STRLEN(BankName) > 100 THEN ERROR('Bank Name %1 is longer than 100 characters.', BankName);

                 IF STRPOS(Branch, ',') > 0 THEN ERROR('Comma not allowed in Branch %1', Branch);
                 IF STRLEN(Branch) > 100 THEN ERROR('Branch Name %1 is longer than 100 characters.', Branch);

                 IF STRPOS(SortCode, ',') > 0 THEN ERROR('Comma not allowed in BIC/SORT Code (Mpesa 99999) %1', SortCode);
                 IF STRLEN(SortCode) > 10 THEN ERROR('BIC/SORT Code (Mpesa 99999) %1 is longer than 10 characters.', SortCode);

                 gvEmployee.TESTFIELD("Bank Code");
                 IF STRPOS(gvEmployee."Bank Code", ',') > 0 THEN
                     ERROR('Comma not allowed in Bank Code %1 for Emp No %2', gvEmployee."Bank Code", gvEmployee."No.");
                 IF STRLEN(gvEmployee."Bank Code") > 5 THEN
                     ERROR('Emp No %1 Bank Code %2 is longer than 5 characters.', gvEmployee."No.", gvEmployee."Bank Code");

                 gvEmployee.TESTFIELD("Bank Account No");
                 IF STRPOS(gvEmployee."Bank Account No", ',') > 0 THEN
                     ERROR('Comma not allowed in Account No./ Phone Number %1 for Emp No %2', gvEmployee."Bank Account No", gvEmployee."No.");
                 IF STRLEN(gvEmployee."Bank Account No") > 15 THEN
                     ERROR('Emp No %1 Account No./ Phone Number %2 is longer than 15 characters.', gvEmployee."No.", gvEmployee."Bank Account No");

                 gvHeader.CALCFIELDS("Total Payable (LCY)", "Total Deduction (LCY)");
                 gvNetPayAmount := gvHeader."Total Payable (LCY)" - gvHeader."Total Deduction (LCY)";
                 IF gvNetPayAmount > 0 THEN BEGIN
                     lvNetPayText := STRSUBSTNO('%1', gvNetPayAmount);
                     lvNetPayText := DELCHR(lvNetPayText, '=', ',');
                     IF STRLEN(lvNetPayText) > 12 THEN
                         ERROR('Emp No %1 Net Pay %2 is more than 12 digits.', gvEmployee."No.", lvNetPayText);
                     gvTranferFile.WRITE(
                         LvDebitAcc + ',' +
                         BranchBIC + ',' +
                         lvEmployeeName + ',' +
                         BankName + ',' +
                         Branch + ',' +
                         SortCode + ',' +
                         gvEmployee."Bank Account No" + ',' +
                         lvNetPayText)
                 END;
             END;
         UNTIL gvEmployee.NEXT = 0; */
    end;
}

