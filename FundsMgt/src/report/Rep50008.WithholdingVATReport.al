report 50008 "Withholding VAT Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/layouts/Withholding VAT Report.rdlc';

    dataset
    {
        dataitem("Payment Line"; 50003)
        {
            DataItemTableView = WHERE("Account Type" = FILTER(Vendor),
                                      Status = FILTER(Posted | "Pending Approval" | Released));
            RequestFilterFields = "Account No.", "Posting Date", "Global Dimension 1 Code";
            column(AppliestoDocType_PaymentLine; "Payment Line"."Applies-to Doc. Type")
            {
            }
            column(AppliestoDocNo_PaymentLine; "Payment Line"."Applies-to Doc. No.")
            {
            }
            column(AppliestoID_PaymentLine; "Payment Line"."Applies-to ID")
            {
            }
            column(Committed_PaymentLine; "Payment Line".Committed)
            {
            }
            column(DocumentNo_PaymentLine; "Payment Line"."Document No.")
            {
            }
            column(AccountNo_PaymentLine; "Payment Line"."Account No.")
            {
            }
            column(AccountName_PaymentLine; "Payment Line"."Account Name")
            {
            }
            column(Description_PaymentLine; "Payment Line".Description)
            {
            }
            column(PostingDate_PaymentLine; "Payment Line"."Posting Date")
            {
            }
            column(NumberText; NumberText[1])
            {
            }
            column(CompanyInfoName; CompanyInfo.Name)
            {
            }
            column(CompanyInfoAddress; CompanyInfo.Address)
            {
            }
            column(CompanyInfoPhone; CompanyInfo."Phone No.")
            {
            }
            column(CompanyInfoPic; CompanyInfo.Picture)
            {
            }
            column(CompanyEmail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyWebPage; CompanyInfo."Home Page")
            {
            }
            column(VATCode_PaymentLine; "Payment Line"."VAT Code")
            {
            }
            column(VATAmount_PaymentLine; "Payment Line"."VAT Amount")
            {
            }
            column(VATAmountLCY_PaymentLine; "Payment Line"."VAT Amount(LCY)")
            {
            }
            column(WithholdingTaxCode_PaymentLine; "Payment Line"."Withholding Tax Code")
            {
            }
            column(WithholdingTaxAmount_PaymentLine; "Payment Line"."Withholding Tax Amount")
            {
            }
            column(WithholdingTaxAmountLCY_PaymentLine; "Payment Line"."Withholding Tax Amount(LCY)")
            {
            }
            column(WithholdingVATCode_PaymentLine; "Payment Line"."Withholding VAT Code")
            {
            }
            column(WithholdingVATAmount_PaymentLine; "Payment Line"."Withholding VAT Amount")
            {
            }
            column(WithholdingVATAmountLCY_PaymentLine; "Payment Line"."Withholding VAT Amount(LCY)")
            {
            }
            column(NetAmount_PaymentLine; "Payment Line"."Net Amount")
            {
            }
            column(PINno; PINno)
            {
            }
            column(InvoiceDate; InvoiceDate)
            {
            }
            column(InvoiceAmt; InvoiceAmt)
            {
            }
            column(ShortcutDimension6Code_PaymentLine; "Payment Line"."Shortcut Dimension 6 Code")
            {
            }
            column(GlobalDimension1Code_PaymentLine; "Payment Line"."Global Dimension 1 Code")
            {
            }
            column(VendorInvoiceNo; VendorInvoiceNo)
            {
            }

            trigger OnAfterGetRecord()
            begin
                PINno := '';
                InvoiceAmt := 0;
                InvoiceDate := 0D;
                VendorInvoiceNo := '';


                Suppliers.RESET;
                IF Suppliers.GET("Account No.") THEN BEGIN
                    PINno := Suppliers."VAT Registration No.";
                END;



                PostedInvoices.RESET;
                IF PostedInvoices.GET("Applies-to Doc. No.") THEN BEGIN
                    PostedInvoices.CALCFIELDS(PostedInvoices.Amount);
                    VendorInvoiceNo := PostedInvoices."Vendor Invoice No.";
                    InvoiceAmt := PostedInvoices.Amount;
                    InvoiceDate := PostedInvoices."Posting Date";
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
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        CheckReport: Report Check;
        NumberText: array[2] of Text[80];
        CompanyInfo: Record 79;
        TotalAmount: Decimal;
        Suppliers: Record 23;
        PostedInvoices: Record 122;
        PINno: Text;
        InvoiceDate: Date;
        InvoiceAmt: Decimal;
        VendorInvoiceNo: Code[30];
        WTVAT: Record 50028;
        WTperct: Code[10];
}

