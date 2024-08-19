report 51162 "Salary scales"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/Salary scales.rdlc';

    dataset
    {
        dataitem(DataItem7515; 51177)
        {
            DataItemTableView = SORTING(Code);
            RequestFilterFields = "Code";
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(USERID; USERID)
            {
            }
            column(Salary_Scale_Code; Code)
            {
            }
            column(Salary_Scale_Description; Description)
            {
            }
            column(Salary_ScaleCaption; Salary_ScaleCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            dataitem(DataItem6896; 51170)
            {
                DataItemLink = Scale = FIELD(Code);
                DataItemTableView = SORTING(Code, Scale);
                column(Salary_Scale_Step_Code; Code)
                {
                }
                column(Salary_Scale_Step_Description; Description)
                {
                }
                column(Salary_Scale_Step_Amount; Amount)
                {
                }
                column(Salary_Scale_Step_Scale; Scale)
                {
                }

                trigger OnPreDataItem()
                begin
                    SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                end;
            }

            trigger OnPreDataItem()
            begin
                SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                LastFieldNo := FIELDNO(Code);
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
    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        gvAllowedPayrolls: Record 51182;
        Salary_ScaleCaptionLbl: Label 'Salary Scale';
        CurrReport_PAGENOCaptionLbl: Label 'Page';

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

