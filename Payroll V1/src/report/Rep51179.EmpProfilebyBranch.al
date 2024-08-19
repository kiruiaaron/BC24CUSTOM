report 51179 "Emp Profile by Branch"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/Emp Profile by Branch.rdlc';

    dataset
    {
        dataitem(Employee; 5200)
        {
            DataItemTableView = SORTING("Global Dimension 1 Code")
                                ORDER(Ascending);
            RequestFilterFields = "Global Dimension 1 Code";
            column(PageTxt_________FORMAT_CurrReport_PAGENO_; PageTxt + ' ' + FORMAT(CurrReport.PAGENO))
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(PRINTED_ON_________FORMAT__TODAY_; 'PRINTED ON' + ' ' + FORMAT(TODAY))
            {
            }
            column(PRINTED_BY_________FORMAT_USERID_; 'PRINTED BY' + ' ' + FORMAT(USERID))
            {
            }
            column(PRINTED_AT_________FORMAT_TIME_; 'PRINTED AT' + ' ' + FORMAT(TIME))
            {
            }
            column(Employee_Employee__Global_Dimension_1_Code_; Employee."Global Dimension 1 Code")
            {
            }
            column(DeptName; DeptName)
            {
            }
            column(Employee_Employee__Global_Dimension_1_Code__Control1101951009; Employee."Global Dimension 1 Code")
            {
            }
            column(Employee__No__; "No.")
            {
            }
            column(First_Name__________Middle_Name_; "First Name" + ' ' + "Middle Name")
            {
            }
            column(Employee__Last_Name_; "Last Name")
            {
            }
            column(NO__OF_EMPLOYEES____________FORMAT_EmpCount_; 'NO. OF EMPLOYEES         ' + FORMAT(EmpCount))
            {
            }
            column(MitarbeiterCaption; MitarbeiterCaptionLbl)
            {
            }
            column(Employee_Employee__Global_Dimension_1_Code__Control1101951009Caption; FIELDCAPTION("Global Dimension 1 Code"))
            {
            }
            column(Employee__No__Caption; FIELDCAPTION("No."))
            {
            }
            column(Other_NamesCaption; Other_NamesCaptionLbl)
            {
            }
            column(SurNameCaption; SurNameCaptionLbl)
            {
            }
            column(Employee_Employee__Global_Dimension_1_Code_Caption; FIELDCAPTION("Global Dimension 1 Code"))
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF "Termination Date" <> 0D THEN BEGIN
                    IF "Termination Date" <= LastTermDate THEN
                        CurrReport.SKIP
                    ELSE
                        EmpCount := EmpCount + 1
                END ELSE
                    EmpCount := EmpCount + 1
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                LastFieldNo := FIELDNO("Global Dimension 1 Code");
                EmpCount := 0;
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
                    field(LastTermDate; LastTermDate)
                    {
                        Caption = 'Print Termination Date After';
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
        IF LastTermDate = 0D THEN ERROR('You must Specify Last Termination Date on the options Tab');
        gsSegmentPayrollData
    end;

    var
        PageTxt: Label 'Page';
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        EmpCount: Integer;
        DeptRec: Record 349;
        DeptName: Text[30];
        LastTermDate: Date;
        gvAllowedPayrolls: Record 51182;
        MitarbeiterCaptionLbl: Label 'EMPLOYEE PROFILE BY DEPARTMENT';
        Other_NamesCaptionLbl: Label 'Other Names';
        SurNameCaptionLbl: Label 'SurName';

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

