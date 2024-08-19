report 51187 "Arrears Computation"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee; 5200)
        {
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending);

            trigger OnAfterGetRecord()
            begin
                IF Process THEN BEGIN
                    PayrollEntry.RESET;
                    PayrollEntry.SETRANGE(PayrollEntry."ED Code", ArrearsEDCode);
                    PayrollEntry.SETRANGE(PayrollEntry."Payroll ID", ArrearPayM);
                    PayrollEntry.SETFILTER(PayrollEntry."Employee No.", "No.");
                    IF NOT PayrollEntry.FINDFIRST THEN
                        REPEAT
                            InitPayrollEntry.RESET;
                            IF InitPayrollEntry.FINDLAST THEN
                                InitEntryNo := InitPayrollEntry."Entry No.";
                            PayrollEntry.INIT;
                            PayrollEntry."Entry No." := InitEntryNo + 1;
                            PayrollEntry.VALIDATE("ED Code", ArrearsEDCode);
                            PayrollEntry."Payroll ID" := ArrearPayM;
                            PayrollEntry.VALIDATE("Employee No.", "No.");
                            PayrollEntry.VALIDATE(Quantity, NoofMonthsArr);
                            PayrollEntry."Payroll Code" := ActPayrollID;
                            PayrollLine.RESET;
                            PayrollLine.SETRANGE(PayrollLine."Payroll ID", BasePayM);
                            PayrollLine.SETRANGE(PayrollLine."Employee No.", EmpCode);
                            PayrollLine.SETRANGE(PayrollLine."ED Code", EDCode);
                            IF PayrollLine.FINDFIRST THEN BEGIN
                                BaseAmountCal := PayrollLine.Amount;
                            END;
                            IF ArrearPercAmt = ArrearPercAmt::Percentage THEN BEGIN
                                IF ArrearPerc <> 0 THEN
                                    ArrearAmountAdd := (BaseAmountCal / 100) * ArrearPerc;
                            END ELSE
                                IF ArrearPercAmt = ArrearPercAmt::Amount THEN BEGIN
                                    ArrearAmountAdd := BaseAmountCal + ArrearAmt;
                                END;
                            PayrollEntry.VALIDATE(Rate, ArrearAmountAdd);
                            PayrollEntry.Date := TODAY;
                            IF PayrollEntry.INSERT THEN
                                Posted := TRUE;
                        UNTIL PayrollEntry.NEXT = 0 ELSE
                        ERROR(Text001, "No.", ArrearPayM, ArrearsEDCode);
                END ELSE
                    MESSAGE('Arrear Computation Process Stopped');
            end;

            trigger OnPostDataItem()
            begin
                IF Posted THEN
                    MESSAGE('Payroll Entry Lines Updated Sucessfully');
            end;

            trigger OnPreDataItem()
            begin
                IF EDCode = '' THEN
                    ERROR(Text003);
                IF EmpCode = '' THEN
                    ERROR(Text005);
                IF ((BasePayY = 0) OR (BasePayM = '')) THEN
                    ERROR(Text006);
                IF NoofMonthsArr = 0 THEN
                    ERROR(Text002);
                IF ArrearPercAmt = ArrearPercAmt::Percentage THEN
                    IF ArrearPerc = 0 THEN
                        ERROR(Text007);
                IF ArrearPercAmt = ArrearPercAmt::Amount THEN
                    IF ArrearAmt = 0 THEN
                        ERROR(Text008);
                IF ((ArrearPayY = 0) OR (ArrearPayM = '')) THEN
                    ERROR(Text009);
                IF ArrearsEDCode = '' THEN
                    ERROR(Text010);
                Process := CONFIRM(Text004, TRUE);
                SETFILTER("No.", EmpCode);

                gvAllowedPayrolls.RESET;
                gvAllowedPayrolls.SETRANGE(gvAllowedPayrolls."User ID", USERID);
                gvAllowedPayrolls.SETRANGE(gvAllowedPayrolls."Last Active Payroll", TRUE);
                IF gvAllowedPayrolls.FINDFIRST THEN
                    ActPayrollID := gvAllowedPayrolls."Payroll Code";
            end;
        }
    }

    requestpage
    {
        Editable = true;
        InsertAllowed = true;

        layout
        {
            area(content)
            {
                group(Group)
                {
                    field(EmpCode; EmpCode)
                    {
                        Caption = 'Employee Filter';
                        TableRelation = Employee;
                        ApplicationArea = All;
                    }
                    field(EDCode; EDCode)
                    {
                        Caption = 'Base ED Code';
                        TableRelation = "ED Definitions"."ED Code" WHERE("System Created" = FILTER(True));
                        ApplicationArea = All;
                    }
                    field(BasePayY; BasePayY)
                    {
                        Caption = 'Base Payroll Year';
                        TableRelation = Year;
                        ApplicationArea = All;
                    }
                    field(BasePayM; BasePayM)
                    {
                        Caption = 'Base Payroll Month';
                        ApplicationArea = All;
                    }
                    field(NoofMonthsArr; NoofMonthsArr)
                    {
                        Caption = 'No. of Months Arrear Payable';
                        ApplicationArea = All;
                    }
                    field(ArrearPerc; ArrearPerc)
                    {
                        Caption = 'Arears Percentage';
                        ApplicationArea = All;
                    }
                    field(ArrearAmt; ArrearAmt)
                    {
                        Caption = 'Arears Amount';
                        ApplicationArea = All;
                    }
                    field(ArrearPayY; ArrearPayY)
                    {
                        Caption = 'Arrear Payroll Year';
                        TableRelation = Year;
                        ApplicationArea = All;
                    }
                    field(ArrearPayM; ArrearPayM)
                    {
                        Caption = 'Arrear Payroll Month';
                        ApplicationArea = All;
                    }
                    field(ArrearsEDCode; ArrearsEDCode)
                    {
                        Caption = 'Arrears ED Code';
                        TableRelation = "ED Definitions"."ED Code" WHERE("System Created" = FILTER(False));
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                group(Functions)
                {
                    Caption = 'Functions';
                    action("TestComputation ")
                    {
                        ApplicationArea = All;
                    }
                }
            }
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
        EmpRec: Record 5200;
        ECDefin: Record 51158;
        PeriodsRec: Record 51151;
        PayrollEntry: Record 51161;
        InitPayrollEntry: Record 51161;
        PayrollLine: Record 51160;
        EDCode: Code[20];
        ArrearPayM: Code[20];
        BasePayM: Code[20];
        ArrearsEDCode: Code[20];
        BasePayY: Integer;
        ArrearPayY: Integer;
        BaseMonthS: Integer;
        InitEntryNo: Integer;
        NoofMonthsArr: Decimal;
        ArrearPerc: Decimal;
        ArrearAmt: Decimal;
        BaseAmountCal: Decimal;
        ArrearAmountAdd: Decimal;
        ArrearPercAmt: Option Percentage,Amount;
        Text000: Label 'Arrears payable year cannot be less than Base payable Year.';
        Text001: Label 'Arrear entries already exists with Employee No := %1 , Payroll ID := %2 and ED Code := %3';
        Text002: Label 'Enter minimum 1 in No. of Months for Arrear Calculation.';
        Text003: Label 'Enter Base ED Code.';
        TestArrearComp: Report 51188;
        Filters: Text[100];
        EmpCode: Code[20];
        Posted: Boolean;
        Process: Boolean;
        Text004: Label 'Do you want to process arrear computation further?';
        Text005: Label 'Enter the employees no.''s for arrear computation.';
        Text006: Label 'Enter the Base Payment Year or Month upon which the computation has to be done.';
        Text007: Label 'Enter Arrear Percentage.';
        Text008: Label 'Enter Arrear Amount.';
        Text009: Label 'Enter the Arrear Payment Year or Month for which the computation has to be Processed.';
        Text010: Label 'Enter Arrear ED Code for which the Arrear Computation has to be processed.';
        gvAllowedPayrolls: Record 51182;
        MembershipNumbers: Record 51175;
        gvPinNo: Code[20];
        ActPayrollID: Code[20];

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

