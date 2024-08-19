report 50040 "Request for Quatation Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/layouts/Request for Quatation Report.rdlc';

    dataset
    {
        dataitem("Request for Quotation Vendors"; 50051)
        {
            column(VendorNo_RequestforQuotationVendors; "Request for Quotation Vendors"."Vendor No.")
            {
            }
            column(VendorName_RequestforQuotationVendors; "Request for Quotation Vendors"."Vendor Name")
            {
            }
            dataitem("Request for Quotation Header"; 50049)
            {
                DataItemLink = "No." = FIELD("RFQ Document No.");
                RequestFilterFields = "No.";
                column(No_RequestforQuotationHeader; "Request for Quotation Header"."No.")
                {
                }
                column(DocumentDate_RequestforQuotationHeader; "Request for Quotation Header"."Document Date")
                {
                }
                column(IssueDate_RequestforQuotationHeader; "Request for Quotation Header"."Issue Date")
                {
                }
                column(ClosingDate_RequestforQuotationHeader; "Request for Quotation Header"."Closing Date")
                {
                }
                column(CurrencyCode_RequestforQuotationHeader; "Request for Quotation Header"."Currency Code")
                {
                }
                column(CurrencyFactor_RequestforQuotationHeader; "Request for Quotation Header"."Currency Factor")
                {
                }
                column(Amount_RequestforQuotationHeader; "Request for Quotation Header".Amount)
                {
                }
                column(AmountLCY_RequestforQuotationHeader; "Request for Quotation Header"."Amount(LCY)")
                {
                }
                column(Description_RequestforQuotationHeader; "Request for Quotation Header".Description)
                {
                }
                column(EditinOutlookClient_RequestforQuotationHeader; "Request for Quotation Header"."Edit in Outlook Client")
                {
                }
                column(AGPOCertificate; "Request for Quotation Header"."AGPO Certificate")
                {
                }
                column(BusinessRegistrationCert; "Request for Quotation Header"."Business Registration Cert.")
                {
                }
                column(TaxComplianceCert; "Request for Quotation Header"."Tax Compliance Cert.")
                {
                }
                column(ConfidentialBusQuestionnaire; "Request for Quotation Header"."Confidential Bus.Questionnaire")
                {
                }
                column(Time_RequestforQuotationHeader; "Request for Quotation Header".Time)
                {
                }
                dataitem("Request for Quotation Line"; 50050)
                {
                    DataItemLink = "Document No." = FIELD("No.");
                    PrintOnlyIfDetail = false;
                    column(No_RequestforQuotationLine; "Request for Quotation Line"."No.")
                    {
                    }
                    column(Name_RequestforQuotationLine; "Request for Quotation Line".Name)
                    {
                    }
                    column(Type_RequestforQuotationLine; "Request for Quotation Line".Type)
                    {
                    }
                    column(Quantity_RequestforQuotationLine; "Request for Quotation Line".Quantity)
                    {
                    }
                    column(Description_RequestforQuotationLine; "Request for Quotation Line".Description)
                    {
                    }
                    column(CompanyInfo_Name; CompanyInfo.Name)
                    {
                    }
                    column(CompanyInfo_Address; CompanyInfo.Address)
                    {
                    }
                    column(CompanyInfo_Address2; CompanyInfo."Address 2")
                    {
                    }
                    column(pic; CompanyInfo.Picture)
                    {
                    }
                    column(CompanyInfo_City; CompanyInfo.City)
                    {
                    }
                    column(CompanyInfo_Phone; CompanyInfo."Phone No.")
                    {
                    }
                    column(CompanyInfo_Fax; CompanyInfo."Fax No.")
                    {
                    }
                    column(CompanyInfo_Picture; CompanyInfo.Picture)
                    {
                    }
                    column(CompanyInfo_Email; CompanyInfo."E-Mail")
                    {
                    }
                    column(CompanyInfo_Web; CompanyInfo."Home Page")
                    {
                    }
                }
                dataitem(DataItem6; 50061)
                {
                    DataItemLink = "RFQ No." = FIELD("No.");
                    column(LNO; LNo)
                    {
                    }
                    column(Specification_RFQSpecificationTable; Specification)
                    {
                    }
                    column(Requirement_RFQSpecificationTable; Requirement)
                    {
                    }
                    column(LineNo_RFQSpecificationTable; "Line No.")
                    {
                    }
                    column(RFQNo_RFQSpecificationTable; "RFQ No.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        LNo := LNo + 1;
                    end;
                }
                dataitem("Procurement Requirements"; 50043)
                {
                    DataItemLink = "Document No." = FIELD("No.");
                    column(DocumentNo_ProcurementRequirements; "Procurement Requirements"."Document No.")
                    {
                    }
                    column(LineNo_ProcurementRequirements; "Procurement Requirements"."Line No.")
                    {
                    }
                    column(Description_ProcurementRequirements; "Procurement Requirements".Description)
                    {
                    }
                }
            }
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
        PurchaseOrderCaption = 'Purchase Order';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture)
    end;

    var
        CompanyInfo: Record 79;
        CopyText: Text;
        PurchLines: Record 39;
        NumberText: array[2] of Text[120];
        CheckReport: Report Check;
        LPOText: Text;
        GenLedgerSetup: Record 98;
        DimVal: Record 349;
        CampusName: Text;
        DeptName: Text;
        LNo: Integer;
        Employees: Record 5200;
}

