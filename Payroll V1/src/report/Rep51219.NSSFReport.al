report 51219 "NSSF Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/NSSF Report.rdlc';

    dataset
    {
        dataitem(Periods; 51151)
        {
            DataItemTableView = SORTING("Start Date")
                                WHERE(Status = FILTER(Open | Posted));
            RequestFilterFields = "Period ID";
            column(EmployerName; EmployerName)
            {
            }
            column(TitleText; TitleText)
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
            column(Periods__Period_Month_; "Period Month")
            {
            }
            column(EmployerNo; EmployerNo)
            {
            }
            column(Periods_Description; Description)
            {
            }
            column(TotalAmountArray_2_; TotalAmountArray[2])
            {
            }
            column(TotalAmountArray_1_; TotalAmountArray[1])
            {
            }
            column(TotalAmountArray_3_; TotalAmountArray[3])
            {
            }
            column(Counter; Counter)
            {
            }
            column(TotalCounter; TotalCounter)
            {
            }
            column(Employee_ContributionCaption; Employee_ContributionCaptionLbl)
            {
            }
            column(NameCaption; NameCaptionLbl)
            {
            }
            column(No_Caption; No_CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Employer_ContributionCaption; Employer_ContributionCaptionLbl)
            {
            }
            column(Monthly_TotalCaption; Monthly_TotalCaptionLbl)
            {
            }
            column(Membership_No_Caption; Membership_No_CaptionLbl)
            {
            }
            column(Periods__Period_Month_Caption; Periods__Period_Month_CaptionLbl)
            {
            }
            column(EmployerNoCaption; EmployerNoCaptionLbl)
            {
            }
            column(Periods_DescriptionCaption; Periods_DescriptionCaptionLbl)
            {
            }
            column(RemarksCaption; RemarksCaptionLbl)
            {
            }
            column(TotalsCaption; TotalsCaptionLbl)
            {
            }
            column(CounterCaption; CounterCaptionLbl)
            {
            }
            column(DataItem1102754028; NameCaptionLbl)
            {
            }
            column(DataItem1102754029; SignatureCaptioLbl)
            {
            }
            column(DataItem1102754030; DesignationCaptLbl)
            {
            }
            column(DataItem1102754031; DateCaptionLbl)
            {
            }
            column(DataItem1102754032; DateCaption_ConLbl)
            {
            }
            column(DataItem1102754033; Peeled_ByCaptionLbl)
            {
            }
            column(DataItem1102754034; CheckedCaptionLbl)
            {
            }
            column(DataItem1102754035; DateCaption_000Lbl)
            {
            }
            column(DataItem1102754036; DateCaption_001Lbl)
            {
            }
            column(DataItem1102754037; Received_byCaptLbl)
            {
            }
            column(For_Official_use_onlyCaption; For_Official_use_onlyCaptionLbl)
            {
            }
            column(DataItem1102754039; Checked_byCaptiLbl)
            {
            }
            column(DataItem1102754040; DateCaption_002Lbl)
            {
            }
            column(DataItem1102754041; DateCaption_003Lbl)
            {
            }
            column(DataItem1102754042; PunchedCaptionLbl)
            {
            }
            column(NB_THIS_FORM_IS_INVALID_WITHOUT_THE_OFFICIAL_RUBBER_STAMP_OF_THE_EMPLOYERCaption; NB_THIS_FORM_IS_INVALID_WITHOUT_THE_OFFICIAL_RUBBER_STAMP_OF_THE_EMPLOYERCaptionLbl)
            {
            }
            column(Certified_correct_by_Company_Authorised_Officer_Caption; Certified_correct_by_Company_Authorised_Officer_CaptionLbl)
            {
            }
            column(Periods_Period_ID; "Period ID")
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
                RequestFilterFields = "No.", "Statistics Group Code", "Global Dimension 1 Code", "Global Dimension 2 Code", Status;
                column(Employee_Name; Name)
                {
                }
                column(Surname; Employee."Last Name")
                {
                }
                column(OtherNames; OtherNames)
                {
                }
                column(Employee__No__; "No.")
                {
                }
                column(IDNo; Employee."National ID")
                {
                }
                column(PINNo; Employee.PIN)
                {
                }
                column(NSSFNo; Employee."NSSF No.")
                {
                }
                column(PeriodAmountArray_1_; PeriodAmountArray[1])
                {
                }
                column(PeriodAmountArray_3_; PeriodAmountArray[3])
                {
                }
                column(PeriodAmountArray_2_; PeriodAmountArray[2])
                {
                }
                column(FORMAT_EmployeeRec__Membership_No___; FORMAT(EmployeeRec."NSSF No."))
                {
                }
                column(RtcCounter; RtcCounter)
                {
                }
                column(GrossPay; GrossPay)
                {
                }
                column(Voluntary; Voluntaryt)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CLEAR(PeriodAmountArray);
                    Name := Employee.FullName;

                    EmployeeRec.GET(Employee."No.");
                    EmployeeRec.SETFILTER("Date Filter", '%1..%2', Periods."Start Date", Periods."End Date");
                    EmployeeRec.SETRANGE("ED Code Filter", PayrollSetup."NSSF ED Code");
                    EmployeeRec.CALCFIELDS(Amount, "Membership No.");

                    IF EmployeeRec.Amount <= 0 THEN CurrReport.SKIP;

                    PeriodAmountArray[1] := EmployeeRec.Amount;
                    TotalAmountArray[1] := TotalAmountArray[1] + EmployeeRec.Amount;
                    PeriodAmountArray[3] := PeriodAmountArray[3] + PeriodAmountArray[1];
                    TotalAmountArray[3] := TotalAmountArray[3] + PeriodAmountArray[1];

                    EmployeeRec.SETRANGE("ED Code Filter", PayrollSetup."NSSF Company Contribution");
                    EmployeeRec.CALCFIELDS(Amount);
                    PeriodAmountArray[2] := EmployeeRec.Amount;
                    TotalAmountArray[2] := TotalAmountArray[2] + EmployeeRec.Amount;
                    PeriodAmountArray[3] := PeriodAmountArray[3] + PeriodAmountArray[2];
                    TotalAmountArray[3] := TotalAmountArray[3] + PeriodAmountArray[2];

                    Counter := Counter + 1;
                    RtcCounter += 1;
                    OtherNames := Employee."First Name" + ' ' + Employee."Middle Name";
                    GrossPay := 3335;
                end;

                trigger OnPostDataItem()
                begin
                    TotalCounter := Counter;
                end;

                trigger OnPreDataItem()
                begin
                    //Rec.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");

                    RtcCounter := 0;
                end;
            }
            dataitem(DataItem5444; 2000000026)
            {
                DataItemTableView = SORTING(Number);
                MaxIteration = 1;
            }

            trigger OnAfterGetRecord()
            begin
                TitleText := 'NSSF Contributions for ' + Periods.Description;

                CLEAR(PeriodAmountArray);
                CLEAR(TotalAmountArray);
                Counter := 0;
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");

                //IF Periods.GETFILTER(Periods."Period ID")=''THEN ERROR('Specify the Period ID');
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
        PayrollSetup.GET(gvAllowedPayrolls."Payroll Code");
        EmployerName := PayrollSetup."Employer Name";
        EmployerNo := PayrollSetup."Employer NSSF No.";
    end;

    var
        PayrollSetup: Record 51165;
        PeriodRec: Record 51151;
        EmployeeRec: Record 5200;
        Name: Text[100];
        EmployerNo: Code[20];
        TitleText: Text[60];
        EmployerName: Text[50];
        PeriodAmountArray: array[3] of Decimal;
        TotalAmountArray: array[3] of Decimal;
        Counter: Integer;
        gvAllowedPayrolls: Record 51182;
        TotalCounter: Integer;
        PeriodFilter: Text[150];
        RtcCounter: Integer;
        Employee_ContributionCaptionLbl: Label 'Employee Contribution';
        NameCaptionLbl: Label 'Name';
        No_CaptionLbl: Label 'No.';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Employer_ContributionCaptionLbl: Label 'Employer Contribution';
        Monthly_TotalCaptionLbl: Label 'Monthly Total';
        Membership_No_CaptionLbl: Label 'Membership No.';
        Periods__Period_Month_CaptionLbl: Label 'Batch No.';
        EmployerNoCaptionLbl: Label 'Employer No.';
        Periods_DescriptionCaptionLbl: Label 'Period';
        RemarksCaptionLbl: Label 'Remarks';
        TotalsCaptionLbl: Label 'Totals';
        CounterCaptionLbl: Label 'No of Entries';
        // NameCaptionLbl: Label 'Name...................................................................';
        SignatureCaptioLbl: Label 'Signature.......................................';
        DesignationCaptLbl: Label 'Designation....................................';
        DateCaptionLbl: Label 'Date.............................................';
        DateCaption_ConLbl: Label 'Date.............';
        Peeled_ByCaptionLbl: Label 'Peeled By................';
        CheckedCaptionLbl: Label 'Checked.............';
        DateCaption_000Lbl: Label 'Date..............';
        DateCaption_001Lbl: Label 'Date........................';
        Received_byCaptLbl: Label 'Received by...................................................';
        For_Official_use_onlyCaptionLbl: Label 'For Official use only';
        Checked_byCaptiLbl: Label 'Checked by............';
        DateCaption_002Lbl: Label 'Date...................';
        DateCaption_003Lbl: Label 'Date................';
        PunchedCaptionLbl: Label 'Punched...............................';
        NB_THIS_FORM_IS_INVALID_WITHOUT_THE_OFFICIAL_RUBBER_STAMP_OF_THE_EMPLOYERCaptionLbl: Label 'NB THIS FORM IS INVALID WITHOUT THE OFFICIAL RUBBER STAMP OF THE EMPLOYER';
        Certified_correct_by_Company_Authorised_Officer_CaptionLbl: Label 'Certified correct by Company Authorised Officer.';
        OtherNames: Text[100];
        GrossPay: Decimal;
        Voluntaryt: Decimal;

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

