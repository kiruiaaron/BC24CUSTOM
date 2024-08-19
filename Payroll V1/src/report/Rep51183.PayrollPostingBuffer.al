report 51183 "Payroll Posting Buffer"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/Payroll Posting Buffer.rdlc';

    dataset
    {
        dataitem("Payroll Posting Buffer"; 51164)
        {
            DataItemTableView = SORTING("Buffer No");
            RequestFilterFields = "Payroll Code";
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
            column(Payroll_Posting_Buffer__Buffer_No_; "Buffer No")
            {
            }
            column(Payroll_Posting_Buffer__Account_Type_; "Account Type")
            {
            }
            column(Payroll_Posting_Buffer__Account_No_; "Account No")
            {
            }
            column(Payroll_Posting_Buffer__Payroll_Code_; "Payroll Code")
            {
            }
            column(Payroll_Posting_Buffer__ED_Code_; "ED Code")
            {
            }
            column(Payroll_Posting_Buffer_Amount; Amount)
            {
            }
            column(Payroll_Posting_Buffer__Currency_Code_; "Currency Code")
            {
            }
            column(Payroll_Posting_Buffer__Currency_Factor_; "Currency Factor")
            {
            }
            column(Payroll_Posting_Buffer__Amount__LCY__; "Amount (LCY)")
            {
            }
            column(Payroll_Posting_Buffer__Amount__LCY___Control1102754008; "Amount (LCY)")
            {
            }
            column(Payroll_Posting_Buffer__Employee_No_; "Payroll Posting Buffer"."Employee No.")
            {
            }
            column(Payroll_Posting_BufferCaption; Payroll_Posting_BufferCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Payroll_Posting_Buffer__Buffer_No_Caption; FIELDCAPTION("Buffer No"))
            {
            }
            column(Payroll_Posting_Buffer__Account_Type_Caption; FIELDCAPTION("Account Type"))
            {
            }
            column(Payroll_Posting_Buffer__Account_No_Caption; FIELDCAPTION("Account No"))
            {
            }
            column(Payroll_Posting_Buffer__Payroll_Code_Caption; FIELDCAPTION("Payroll Code"))
            {
            }
            column(Payroll_Posting_Buffer__ED_Code_Caption; FIELDCAPTION("ED Code"))
            {
            }
            column(Payroll_Posting_Buffer_AmountCaption; FIELDCAPTION(Amount))
            {
            }
            column(Payroll_Posting_Buffer__Currency_Code_Caption; FIELDCAPTION("Currency Code"))
            {
            }
            column(Payroll_Posting_Buffer__Currency_Factor_Caption; FIELDCAPTION("Currency Factor"))
            {
            }
            column(Payroll_Posting_Buffer__Amount__LCY__Caption; FIELDCAPTION("Amount (LCY)"))
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(GLName; GLName)
            {
            }
            dataitem("Payroll Dimension"; 51184)
            {
                DataItemLink = "Entry No" = FIELD("Buffer No");
                DataItemTableView = SORTING("Table ID", "Payroll ID", "Employee No", "Entry No", "ED Code", "Dimension Code", "Payroll Code")
                                    ORDER(Ascending)
                                    WHERE("Table ID" = FILTER(52021893));
                column(Payroll_Dimension__Dimension_Code_; "Dimension Code")
                {
                }
                column(Payroll_Dimension__Dimension_Value_Code_; "Dimension Value Code")
                {
                }
                column(Payroll_Dimension_Table_ID; "Table ID")
                {
                }
                column(Payroll_Dimension_Payroll_ID; "Payroll ID")
                {
                }
                column(Payroll_Dimension_Employee_No; "Employee No")
                {
                }
                column(Payroll_Dimension_Entry_No; "Entry No")
                {
                }
                column(Payroll_Dimension_ED_Code; "ED Code")
                {
                }
                column(Payroll_Dimension_Payroll_Code; "Payroll Code")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin

                GLName := '';
                IF GL.GET("Payroll Posting Buffer"."Account No") THEN GLName := GL.Name;
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

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        Payroll_Posting_BufferCaptionLbl: Label 'Payroll Posting Buffer';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        TotalCaptionLbl: Label 'Total';
        GLName: Text[50];
        GL: Record 15;
}

