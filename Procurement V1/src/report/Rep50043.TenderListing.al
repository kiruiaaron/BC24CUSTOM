report 50043 "Tender Listing"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/layouts/Tender Listing.rdlc';

    dataset
    {
        dataitem("Tender Header"; 50055)
        {
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
            column(No_TenderHeader; "Tender Header"."No.")
            {
            }
            column(TenderDescription_TenderHeader; "Tender Header"."Tender Description")
            {
            }
            column(TenderType_TenderHeader; "Tender Header"."Tender Type")
            {
            }
            column(TenderSubmissionFrom_TenderHeader; "Tender Header"."Tender Submission (From)")
            {
            }
            column(TenderSubmissionTo_TenderHeader; "Tender Header"."Tender Submission (To)")
            {
            }
            column(TenderStatus_TenderHeader; "Tender Header"."Tender Status")
            {
            }
            column(DocumentDate_TenderHeader; "Tender Header"."Document Date")
            {
            }
            column(UserID_TenderHeader; "Tender Header"."User ID")
            {
            }
            column(TenderClosingDate_TenderHeader; "Tender Header"."Tender Closing Date")
            {
            }
            column(EvaluationDate_TenderHeader; "Tender Header"."Evaluation Date")
            {
            }
            column(AwardDate_TenderHeader; "Tender Header"."Award Date")
            {
            }
            column(SupplierAwarded_TenderHeader; "Tender Header"."Supplier Awarded")
            {
            }
            column(SupplierName_TenderHeader; "Tender Header"."Supplier Name")
            {
            }
            column(NoSeries_TenderHeader; "Tender Header"."No. Series")
            {
            }
            column(PurchaseRequisition_TenderHeader; "Tender Header"."Purchase Requisition")
            {
            }
            column(PurchaseReqDescription_TenderHeader; "Tender Header"."Purchase Req. Description")
            {
            }
            dataitem("Tender Lines"; 50056)
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(LineNo_TenderLines; "Tender Lines"."Line No.")
                {
                }
                column(DocumentNo_TenderLines; "Tender Lines"."Document No.")
                {
                }
                column(SupplierNo_TenderLines; "Tender Lines"."Supplier No.")
                {
                }
                column(SupplierName_TenderLines; "Tender Lines"."Supplier Name")
                {
                }
                column(Remarks_TenderLines; "Tender Lines".Remarks)
                {
                }
            }
            dataitem("Approval Entry"; 454)
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = WHERE(Status = CONST(Approved));
                column(SequenceNo; "Approval Entry"."Sequence No.")
                {
                }
                column(LastDateTimeModified; "Approval Entry"."Last Date-Time Modified")
                {
                }
                column(ApproverID; "Approval Entry"."Approver ID")
                {
                }
                column(ApproverID_ApprovalEntry; "Approval Entry"."Approver ID")
                {
                }
                column(SenderID; "Approval Entry"."Sender ID")
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
        CompanyInfo.CALCFIELDS(Picture)
    end;

    var
        CompanyInfo: Record 79;
}

