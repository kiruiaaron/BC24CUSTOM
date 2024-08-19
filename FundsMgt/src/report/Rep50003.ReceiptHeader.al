report 50003 "Receipt Header"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/layouts/Receipt Header.rdlc';

    dataset
    {
        dataitem("Receipt Header"; 50004)
        {
            column(No; "No.")
            {
            }
            column(Date; "Posting Date")
            {
            }
            column(Department; "Global Dimension 1 Code")
            {
            }
            column(CostCenter; "Global Dimension 2 Code")
            {
            }
            column(RHAmount; "Amount Received")
            {
            }
            column(RHAmountLCY; "Receipt Line".Amount)
            {
            }
            column(RHDescription; "Received From")
            {
            }
            column(RHDesc; Description)
            {
            }
            column(Payee; "On Behalf of")
            {
            }
            column(CName; CompanyInformation.Name)
            {
            }
            column(CAddress; CompanyInformation.Address)
            {
            }
            column(CAddress2; CompanyInformation."Address 2")
            {
            }
            column(CImage; CompanyInformation.Picture)
            {
            }
            column(CFax; CompanyInformation."Fax No.")
            {
            }
            column(CTel; CompanyInformation."Phone No.")
            {
            }
            column(TotalAmount; TotalAmount)
            {
            }
            column(TotalAmountText; TotalAmountText[1])
            {
            }
            column(USERID_Control1102755012; USERID)
            {
            }
            column(Names; Names)
            {
            }
            dataitem("Receipt Line"; 50005)
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(TType; "Receipt Line"."Receipt Code")
                {
                }
                column(Description; Description)
                {
                }
                column(Amount; Amount)
                {
                }
                column(AmountLCY; "Amount(LCY)")
                {
                }
                column(PayMode; "Receipt Line"."Document Type")
                {
                }
                column(ChequeNo; "Receipt Header"."Reference No.")
                {
                }
            }
            dataitem(Employee; 5200)
            {
                DataItemLink = "User ID" = FIELD("User ID");
                column(No_Employee; Employee."No.")
                {
                }
                column(FirstName_Employee; Employee."First Name")
                {
                }
                column(MiddleName_Employee; Employee."Middle Name")
                {
                }
                column(LastName_Employee; Employee."Last Name")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                CALCFIELDS("Receipt Header"."Line Amount");
                EnglishLanguageCode := 1033;
                CheckReport.InitTextVariable();
                CheckReport.FormatNoText(TotalAmountText, ("Receipt Header"."Line Amount"), "Receipt Header"."Currency Code");



                HREmployees.RESET;
                HREmployees.SETRANGE(HREmployees."User ID", "Receipt Header"."User ID");
                IF HREmployees.FINDFIRST THEN BEGIN
                    Names := HREmployees."First Name";
                END;
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
        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS(CompanyInformation.Picture);
    end;

    var
        CompanyInformation: Record 79;
        CheckReport: Report Check;
        TotalLegalFee: Decimal;
        TotalMembershipFee: Decimal;
        TotalAmount: Decimal;
        TotalInvestment: Decimal;
        TotalAmountText: array[2] of Text[80];
        TotalInvestmentText: array[2] of Text[80];
        Percentage: Decimal;
        Interest: Decimal;
        InterestText: array[2] of Text;
        user: Record 2000000120;
        userid: Text;
        EnglishLanguageCode: Integer;
        Names: Text;
        HREmployees: Record 5200;
}

