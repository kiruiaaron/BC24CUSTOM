report 50042 "Purchase Order-New"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/layouts/Purchase Order-New.rdlc';

    dataset
    {
        dataitem("Purchase Header"; 38)
        {
            PrintOnlyIfDetail = false;
            RequestFilterFields = "No.";
            column(PaytoVendorNo_PurchaseHeader; "Purchase Header"."Pay-to Vendor No.")
            {
            }
            column(PaytoName_PurchaseHeader; "Purchase Header"."Pay-to Name")
            {
            }
            column(PaytoName2_PurchaseHeader; "Purchase Header"."Pay-to Name 2")
            {
            }
            column(PaytoAddress_PurchaseHeader; "Purchase Header"."Pay-to Address")
            {
            }
            column(PaytoAddress2_PurchaseHeader; "Purchase Header"."Pay-to Address 2")
            {
            }
            column(PaytoCity_PurchaseHeader; "Purchase Header"."Pay-to City")
            {
            }
            column(ShiptoCode_PurchaseHeader; "Purchase Header"."Ship-to Code")
            {
            }
            column(ShiptoName_PurchaseHeader; "Purchase Header"."Ship-to Name")
            {
            }
            column(ShiptoName2_PurchaseHeader; "Purchase Header"."Ship-to Name 2")
            {
            }
            column(ShiptoAddress_PurchaseHeader; "Purchase Header"."Ship-to Address")
            {
            }
            column(ShiptoAddress2_PurchaseHeader; "Purchase Header"."Ship-to Address 2")
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
            column(ExpectedReceiptDate_PurchaseHeader; "Purchase Header"."Expected Receipt Date")
            {
            }
            column(PostingDate_PurchaseHeader; "Purchase Header"."Posting Date")
            {
            }
            column(No_PurchaseHeader; "Purchase Header"."No.")
            {
            }
            column(CopyText; CopyText)
            {
            }
            column(PaymentTermsCode_PurchaseHeader; "Purchase Header"."Payment Terms Code")
            {
            }
            column(CurrencyCode_PurchaseHeader; "Purchase Header"."Currency Code")
            {
            }
            column(Amount_PurchaseHeader; "Purchase Header".Amount)
            {
            }
            column(AmountIncludingVAT_PurchaseHeader; "Purchase Header"."Amount Including VAT")
            {
            }
            column(TotalDiscountAmount; PurchLines."Line Discount Amount")
            {
            }
            column(NumberText; NumberText[1])
            {
            }
            column(NoPrinted; "Purchase Header"."No. Printed")
            {
            }
            column(LPOText; LPOText)
            {
            }
            column(DeptName; DeptName)
            {
            }
            column(CampusName; CampusName)
            {
            }
            column(LNo; LNo)
            {
            }
            dataitem("Purchase Line"; 39)
            {
                DataItemLink = "Document Type" = FIELD("Document Type"),
                               "Document No." = FIELD("No.");
                column(LineNo_PurchaseLine; "Purchase Line"."Line No.")
                {
                }
                column(LineAmount_PurchaseLine; "Purchase Line"."Line Amount")
                {
                }
                column(DirectUnitCost_PurchaseLine; "Purchase Line"."Direct Unit Cost")
                {
                }
                column(Quantity_PurchaseLine; "Purchase Line".Quantity)
                {
                }
                column(No_PurchaseLine; "Purchase Line"."No.")
                {
                }
                column(Description_PurchaseLine; "Purchase Line".Description)
                {
                }
                column(Remarks_PurchaseLine; "Purchase Line".Remarks)
                {
                }
                column(UnitofMeasure_PurchaseLine; "Purchase Line"."Unit of Measure")
                {
                }
                column(LineDiscount_PurchaseLine; "Purchase Line"."Line Discount %")
                {
                }
                column(LineDiscountAmount_PurchaseLine; "Purchase Line"."Line Discount Amount")
                {
                }
                column(VAT; "Purchase Line"."VAT %")
                {
                }
                column(LocationCode; "Purchase Line"."Location Code")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    LNo := LNo + 1;
                end;
            }
            dataitem("Approval Entry"; 454)
            {
                DataItemLink = "Document No." = FIELD("No."),
                               "Document Type" = FIELD("Document Type");
                DataItemTableView = WHERE(Status = CONST(Approved));
                column(SequenceNo_ApprovalEntry; "Approval Entry"."Sequence No.")
                {
                }
                column(ApproverID_ApprovalEntry; "Approval Entry"."Approver ID")
                {
                }
                column(LastDateTimeModified_ApprovalEntry; "Approval Entry"."Last Date-Time Modified")
                {
                }
                column(SenderID_ApprovalEntry; "Approval Entry"."Sender ID")
                {
                }
                column(DateTimeSentforApproval_ApprovalEntry; "Approval Entry"."Date-Time Sent for Approval")
                {
                }
                dataitem(Employee; 5200)
                {
                    DataItemLink = "User ID" = FIELD("Approver ID");
                    column(EmployeeFirstName; Employee."First Name")
                    {
                    }
                    column(EmployeeMiddleName; Employee."Middle Name")
                    {
                    }
                    column(EmployeeLastName; Employee."Last Name")
                    {
                    }
                    column(EmployeeSignature; Employee."Employee Signature")
                    {
                    }
                }
            }

            trigger OnAfterGetRecord()
            begin

                DimVal.RESET;
                DimVal.SETRANGE(DimVal.Code, "Purchase Header"."Shortcut Dimension 1 Code");
                IF DimVal.FINDFIRST THEN
                    CampusName := DimVal.Name;
                DimVal.RESET;
                DimVal.SETRANGE(DimVal.Code, "Purchase Header"."Shortcut Dimension 2 Code");
                IF DimVal.FINDFIRST THEN
                    DeptName := DimVal.Name;

                PurchLines.RESET;
                PurchLines.SETRANGE("Document Type", "Document Type");
                PurchLines.SETRANGE("Document No.", "No.");
                PurchLines.CALCSUMS("Line Discount Amount");
                CALCFIELDS("Amount Including VAT");
                //Amount into words
                CheckReport.InitTextVariable;
                CheckReport.FormatNoText(NumberText, "Amount Including VAT", '');

                IF "No. Printed" = 0 THEN
                    LPOText := 'Suppliers copy'
                ELSE
                    IF "No. Printed" = 1 THEN
                        LPOText := 'Accounts copy'
                    ELSE
                        IF "No. Printed" = 2 THEN
                            LPOText := 'Store copy'
                        ELSE
                            IF "No. Printed" = 3 THEN LPOText := 'Files copy';

                GenLedgerSetup.GET;
                IF "Currency Code" = '' THEN "Currency Code" := GenLedgerSetup."LCY Code";
            end;

            trigger OnPostDataItem()
            begin
                /*IF CurrReport.PREVIEW=FALSE THEN
                  BEGIN
                    "No. Printed":="No. Printed" + 1;
                    MODIFY;
                END*/

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

