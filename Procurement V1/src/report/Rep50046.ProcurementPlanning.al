report 50046 "Procurement Planning"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/layouts/Procurement Planning.rdlc';

    dataset
    {
        dataitem("Procurement Planning Header"; 50063)
        {
            column(No_ProcurementPlanningHeader; "Procurement Planning Header"."No.")
            {
            }
            column(Name_ProcurementPlanningHeader; "Procurement Planning Header".Name)
            {
            }
            column(FinancialYear_ProcurementPlanningHeader; "Procurement Planning Header"."Financial Year")
            {
            }
            column(DocumentDate_ProcurementPlanningHeader; "Procurement Planning Header"."Document Date")
            {
            }
            column(Budget_ProcurementPlanningHeader; "Procurement Planning Header".Budget)
            {
            }
            column(BudgetDescription_ProcurementPlanningHeader; "Procurement Planning Header"."Budget Description")
            {
            }
            column(UserID_ProcurementPlanningHeader; "Procurement Planning Header"."User ID")
            {
            }
            column(NoSeries_ProcurementPlanningHeader; "Procurement Planning Header"."No. Series")
            {
            }
            column(GlobalDimension1Code_ProcurementPlanningHeader; "Procurement Planning Header"."Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code_ProcurementPlanningHeader; "Procurement Planning Header"."Global Dimension 2 Code")
            {
            }
            column(ShortcutDimension3Code_ProcurementPlanningHeader; "Procurement Planning Header"."Shortcut Dimension 3 Code")
            {
            }
            column(ShortcutDimension4Code_ProcurementPlanningHeader; "Procurement Planning Header"."Shortcut Dimension 4 Code")
            {
            }
            column(ShortcutDimension5Code_ProcurementPlanningHeader; "Procurement Planning Header"."Shortcut Dimension 5 Code")
            {
            }
            column(ShortcutDimension6Code_ProcurementPlanningHeader; "Procurement Planning Header"."Shortcut Dimension 6 Code")
            {
            }
            column(ShortcutDimension7Code_ProcurementPlanningHeader; "Procurement Planning Header"."Shortcut Dimension 7 Code")
            {
            }
            column(ShortcutDimension8Code_ProcurementPlanningHeader; "Procurement Planning Header"."Shortcut Dimension 8 Code")
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
            dataitem("Procurement Planning Line"; 50064)
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(LN; LN)
                {
                }
                column(DocumentNo_ProcurementPlanningLine; "Procurement Planning Line"."Document No.")
                {
                }
                column(LineNo_ProcurementPlanningLine; "Procurement Planning Line"."Line No.")
                {
                }
                column(Type_ProcurementPlanningLine; "Procurement Planning Line".Type)
                {
                }
                column(No_ProcurementPlanningLine; "Procurement Planning Line"."No.")
                {
                }
                column(Description_ProcurementPlanningLine; "Procurement Planning Line".Description)
                {
                }
                column(Description2_ProcurementPlanningLine; "Procurement Planning Line"."Description 2")
                {
                }
                column(UnitofMeasure_ProcurementPlanningLine; "Procurement Planning Line"."Unit of Measure")
                {
                }
                column(Quantity_ProcurementPlanningLine; "Procurement Planning Line".Quantity)
                {
                }
                column(ProcurementMethod_ProcurementPlanningLine; "Procurement Planning Line"."Procurement Method")
                {
                }
                column(SourceofFunds_ProcurementPlanningLine; "Procurement Planning Line"."Source of Funds")
                {
                }
                column(Estimatedcost_ProcurementPlanningLine; "Procurement Planning Line"."Estimated cost")
                {
                }
                column(TimeProcess_ProcurementPlanningLine; "Procurement Planning Line"."Time Process")
                {
                }
                column(InviteAdvertiseTender_ProcurementPlanningLine; "Procurement Planning Line"."Invite/Advertise Tender")
                {
                }
                column(OpenTenderDate_ProcurementPlanningLine; "Procurement Planning Line"."Open Tender Date")
                {
                }
                column(EvaluateTenderDate_ProcurementPlanningLine; "Procurement Planning Line"."Evaluate Tender Date")
                {
                }
                column(CommitteeAwardApprovalDate_ProcurementPlanningLine; "Procurement Planning Line"."Committee Award Approval Date")
                {
                }
                column(NotificationofAwardDate_ProcurementPlanningLine; "Procurement Planning Line"."Notification of Award Date")
                {
                }
                column(ContractSigningDate_ProcurementPlanningLine; "Procurement Planning Line"."Contract Signing Date")
                {
                }
                column(TotaltimetoContractsign_ProcurementPlanningLine; "Procurement Planning Line"."Total time to Contract sign")
                {
                }
                column(TimeofCompletionofContract_ProcurementPlanningLine; "Procurement Planning Line"."Time of Completion of Contract")
                {
                }
                column(OpenTenderDays_ProcurementPlanningLine; "Procurement Planning Line"."Open Tender Days")
                {
                }
                column(EvaluateTenderDays_ProcurementPlanningLine; "Procurement Planning Line"."Evaluate Tender Days")
                {
                }
                column(CommitteeAwardApprovalDays_ProcurementPlanningLine; "Procurement Planning Line"."Committee Award Approval Days")
                {
                }
                column(NotificationofAwardDays_ProcurementPlanningLine; "Procurement Planning Line"."Notification of Award Days")
                {
                }
                column(ContractSigningDays_ProcurementPlanningLine; "Procurement Planning Line"."Contract Signing Days")
                {
                }
                column(GlobalDimension1Code_ProcurementPlanningLine; "Procurement Planning Line"."Global Dimension 1 Code")
                {
                }
                column(GlobalDimension2Code_ProcurementPlanningLine; "Procurement Planning Line"."Global Dimension 2 Code")
                {
                }
                column(ShortcutDimension3Code_ProcurementPlanningLine; "Procurement Planning Line"."Shortcut Dimension 3 Code")
                {
                }
                column(ShortcutDimension4Code_ProcurementPlanningLine; "Procurement Planning Line"."Shortcut Dimension 4 Code")
                {
                }
                column(ShortcutDimension5Code_ProcurementPlanningLine; "Procurement Planning Line"."Shortcut Dimension 5 Code")
                {
                }
                column(ShortcutDimension6Code_ProcurementPlanningLine; "Procurement Planning Line"."Shortcut Dimension 6 Code")
                {
                }
                column(ShortcutDimension7Code_ProcurementPlanningLine; "Procurement Planning Line"."Shortcut Dimension 7 Code")
                {
                }
                column(ShortcutDimension8Code_ProcurementPlanningLine; "Procurement Planning Line"."Shortcut Dimension 8 Code")
                {
                }
                column(ResponsibilityCenter_ProcurementPlanningLine; "Procurement Planning Line"."Responsibility Center")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    LN := LN + 1;
                end;
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
        LN: Integer;
}

