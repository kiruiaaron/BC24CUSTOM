report 52214 "Staff Employee Requisition"
{
    RDLCLayout = './src/layouts/Staff Employee Requisition.rdlc';
    WordLayout = './src/layouts/Staff Employee Requisition.docx';
    DefaultLayout = Word;

    dataset
    {
        dataitem("HR Employee Requisitions"; 50098)
        {
            column(CompanyInformationRec_Picture; CompanyInformationRec.Picture)
            {
            }
            column(No_HREmployeeRequisitions; "HR Employee Requisitions"."No.")
            {
            }
            column(JobNo_HREmployeeRequisitions; "HR Employee Requisitions"."Job No.")
            {
            }
            column(JobTitle_HREmployeeRequisitions; "HR Employee Requisitions"."Job Title")
            {
            }
            column(EmpRequisitionDescription_HREmployeeRequisitions; "HR Employee Requisitions"."Emp. Requisition Description")
            {
            }
            column(JobGrade_HREmployeeRequisitions; "HR Employee Requisitions"."Job Grade")
            {
            }
            column(MaximumPositions_HREmployeeRequisitions; "HR Employee Requisitions"."Maximum Positions")
            {
            }
            column(OccupiedPositions_HREmployeeRequisitions; "HR Employee Requisitions"."Occupied Positions")
            {
            }
            column(VacantPositions_HREmployeeRequisitions; "HR Employee Requisitions"."Vacant Positions")
            {
            }
            column(RequestedEmployees_HREmployeeRequisitions; "HR Employee Requisitions"."Requested Employees")
            {
            }
            column(ClosingDate_HREmployeeRequisitions; FORMAT("HR Employee Requisitions"."Closing Date", 0, '<Day,2> <Month Text> <Year4>'))
            {
            }
            column(RequisitionType_HREmployeeRequisitions; "HR Employee Requisitions"."Requisition Type")
            {
            }
            column(EmplymtContractCode_HREmployeeRequisitions; "HR Employee Requisitions"."Emplymt. Contract Code")
            {
            }
            column(ReasonforRequisition_HREmployeeRequisitions; "HR Employee Requisitions"."Reason for Requisition")
            {
            }
            column(InterviewDate_HREmployeeRequisitions; FORMAT("HR Employee Requisitions"."Interview Date", 0, '<Day,2> <Month Text> <Year4>'))
            {
            }
            column(InterviewTime_HREmployeeRequisitions; "HR Employee Requisitions"."Interview Time")
            {
            }
            column(InterviewLocation_HREmployeeRequisitions; "HR Employee Requisitions"."Interview Location")
            {
            }
            column(PurchaseRequisitionCreated_HREmployeeRequisitions; "HR Employee Requisitions"."Purchase Requisition Created")
            {
            }
            column(PurchaseRequisitionNo_HREmployeeRequisitions; "HR Employee Requisitions"."Purchase Requisition No.")
            {
            }
            column(Description_HREmployeeRequisitions; "HR Employee Requisitions".Description)
            {
            }
            column(GlobalDimension1Code_HREmployeeRequisitions; "HR Employee Requisitions"."Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code_HREmployeeRequisitions; "HR Employee Requisitions"."Global Dimension 2 Code")
            {
            }
            column(ShortcutDimension3Code_HREmployeeRequisitions; "HR Employee Requisitions"."Shortcut Dimension 3 Code")
            {
            }
            column(ShortcutDimension4Code_HREmployeeRequisitions; "HR Employee Requisitions"."Shortcut Dimension 4 Code")
            {
            }
            column(ShortcutDimension5Code_HREmployeeRequisitions; "HR Employee Requisitions"."Shortcut Dimension 5 Code")
            {
            }
            column(ShortcutDimension6Code_HREmployeeRequisitions; "HR Employee Requisitions"."Shortcut Dimension 6 Code")
            {
            }
            column(ShortcutDimension7Code_HREmployeeRequisitions; "HR Employee Requisitions"."Shortcut Dimension 7 Code")
            {
            }
            column(ShortcutDimension8Code_HREmployeeRequisitions; "HR Employee Requisitions"."Shortcut Dimension 8 Code")
            {
            }
            column(ResponsibilityCenter_HREmployeeRequisitions; "HR Employee Requisitions"."Responsibility Center")
            {
            }
            column(JobAdvertPublished_HREmployeeRequisitions; "HR Employee Requisitions"."Job Advert Published")
            {
            }
            column(JobAdvertDropped_HREmployeeRequisitions; "HR Employee Requisitions"."Job Advert Dropped")
            {
            }
            column(Status_HREmployeeRequisitions; "HR Employee Requisitions".Status)
            {
            }
            column(RequisitionApproved_HREmployeeRequisitions; "HR Employee Requisitions"."Requisition Approved")
            {
            }
            column(MandatoryDocsRequired_HREmployeeRequisitions; "HR Employee Requisitions"."Mandatory Docs. Required")
            {
            }
            column(UserID_HREmployeeRequisitions; "HR Employee Requisitions"."User ID")
            {
            }
            column(NoSeries_HREmployeeRequisitions; "HR Employee Requisitions"."No. Series")
            {
            }
            column(IncomingDocumentEntryNo_HREmployeeRequisitions; "HR Employee Requisitions"."Incoming Document Entry No.")
            {
            }
            column(Comments_HREmployeeRequisitions; "HR Employee Requisitions".Comments)
            {
            }
            column(RegretEmailSent_HREmployeeRequisitions; "HR Employee Requisitions"."Regret Email Sent")
            {
            }
            column(CreatedBy_HREmployeeRequisitions; "HR Employee Requisitions"."Created By")
            {
            }
            column(EmployeeNo_HREmployeeRequisitions; "HR Employee Requisitions"."Employee No")
            {
            }
            column(DocumentDate_HREmployeeRequisitions; FORMAT("HR Employee Requisitions"."Document Date", 0, '<Day,2> <Month Text> <Year4>'))
            {
            }
            column(DesiredStartDate_HREmployeeRequisitions; FORMAT("HR Employee Requisitions"."Desired Start Date", 0, '<Day,2> <Month Text> <Year4>'))
            {
            }
            column(EmployeeToBeReplaced_HREmployeeRequisitions; "HR Employee Requisitions"."Employee To Be Replaced")
            {
            }
            column(EmployeeName_HREmployeeRequisitions; "HR Employee Requisitions"."Employee Name")
            {
            }
            column(HODNo_HREmployeeRequisitions; "HR Employee Requisitions"."HOD No.")
            {
            }
            column(HODName_HREmployeeRequisitions; "HR Employee Requisitions"."HOD Name")
            {
            }
            column(HRManagerNo_HREmployeeRequisitions; "HR Employee Requisitions"."HR Manager No.")
            {
            }
            column(HRManagerName_HREmployeeRequisitions; "HR Employee Requisitions"."HR Manager Name")
            {
            }
            column(MDFDGMNo_HREmployeeRequisitions; "HR Employee Requisitions"."MD/FD/GM No.")
            {
            }
            column(MDFDGMName_HREmployeeRequisitions; "HR Employee Requisitions"."MD/FD/GM Name")
            {
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
        CompanyInformationRec.GET;
        CompanyInformationRec.CALCFIELDS(Picture);
    end;

    var
        CompanyInformationRec: Record 79;
}

