report 50033 "Purchase Requisition"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/layouts/src/layouts/Purchase Requisition.rdlc';

    dataset
    {
        dataitem("Purchase Requisitions"; 50046)
        {
            column(PRN_No; "Purchase Requisitions"."No.")
            {
            }
            column(Department; "Purchase Requisitions"."Global Dimension 1 Code")
            {
            }
            column(Date; "Purchase Requisitions"."Document Date")
            {
            }
            column(EmployeeNo; "Purchase Requisitions"."No.")
            {
            }
            column(EmployeeName; "Purchase Requisitions"."No.")
            {
            }
            column(CName; CompanyInfo.Name)
            {
            }
            column(CAddress; CompanyInfo.Address)
            {
            }
            column(CCity; CompanyInfo.City)
            {
            }
            column(CPic; CompanyInfo.Picture)
            {
            }
            column(CEmail; CompanyInfo."E-Mail")
            {
            }
            column(CPhone; CompanyInfo."Phone No.")
            {
            }
            column(UserID_PurchaseRequisitionHeader; "Purchase Requisitions"."User ID")
            {
            }
            column(PrintDate; PrintDate)
            {
            }
            column(PrintTime; PrintTime)
            {
            }
            dataitem("Purchase Requisition Line"; 50047)
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(ItemNo; "Purchase Requisition Line"."No.")
                {
                }
                column(Description; "Purchase Requisition Line".Description)
                {
                }
                column(UnitofMeasure; "Purchase Requisition Line"."Unit of Measure")
                {
                }
                column(Quantity; "Purchase Requisition Line".Quantity)
                {
                }
                column(EstimatedUnitCost; "Purchase Requisition Line"."Unit Cost")
                {
                }
                column(EstimatedTotalCost; "Purchase Requisition Line"."Unit Cost" * "Purchase Requisition Line".Quantity)
                {
                }
                column(ActualCost; "Purchase Requisition Line"."Total Cost")
                {
                }
                column(TenderQuotationRef; "Purchase Requisition Line"."Document No.")
                {
                }
                column(RequisitionCode_PurchaseRequisitionLine; "Purchase Requisition Line"."Requisition Code")
                {
                }
                column(RequisitionType_PurchaseRequisitionLine; "Purchase Requisition Line"."Requisition Type")
                {
                }
                column(UnitofMeasure_PurchaseRequisitionLine; "Purchase Requisition Line"."Unit of Measure")
                {
                }
                column(Inventory_PurchaseRequisitionLine; "Purchase Requisition Line".Inventory)
                {
                }
            }
            dataitem("Approval Entry"; 454)
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Sequence No.")
                                    ORDER(Ascending)
                                    WHERE(Status = CONST(Approved));
                column(ApproverID; "Approval Entry"."Approver ID")
                {
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
        CompanyInfo.CALCFIELDS(Picture);
        PrintDate := TODAY;
        PrintTime := TIME;
    end;

    var
        CompanyInfo: Record 79;
        PrintDate: Date;
        PrintTime: Time;
}

