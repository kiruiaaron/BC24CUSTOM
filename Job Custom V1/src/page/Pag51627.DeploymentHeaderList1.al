page 51627 "Deployment Header List1"
{
    CardPageID = "Deployment Planner Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Deployment Header";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                }
                field("B A Category"; Rec."B A Category")
                {
                }
                field("B A Category Name"; Rec."B A Category Name")
                {
                }
                field(Project; Rec.Project)
                {
                }
                field("Project Name"; Rec."Project Name")
                {
                }
                field("Task No"; Rec."Task No")
                {
                }
                field("Task Description"; Rec."Task Description")
                {
                }
                field(Date; Rec.Date)
                {
                }
                field(Paid; Rec.Paid)
                {
                }
                field(Total; Rec.Total)
                {
                }
                field("Total Number of Days"; Rec."Total Number of Days")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field(Released; Rec.Released)
                {
                }
                field(Region; Rec.Region)
                {
                }
                field("Supervisor Code"; Rec."Supervisor Code")
                {
                }
                field("Supervisor Name"; Rec."Supervisor Name")
                {
                }
                field("Created By"; Rec."Created By")
                {
                }
                field("Date Created"; Rec."Date Created")
                {
                }
                field("Time Created"; Rec."Time Created")
                {
                }
                field("Total Actual No of Days"; Rec."Total Actual No of Days")
                {
                }
                field("Total Actual Amount"; Rec."Total Actual Amount")
                {
                }
                field(Week; Rec.Week)
                {
                }
                field("No. Series"; Rec."No. Series")
                {
                }
                field(Deployment; Rec.Deployment)
                {
                }
                field("Work Dates"; Rec."Work Dates")
                {
                }
                field("Payment Schedule"; Rec."Payment Schedule")
                {
                }
                field("Posted By"; Rec."Posted By")
                {
                }
                field("Date Posted"; Rec."Date Posted")
                {
                }
                field("Time Posted"; Rec."Time Posted")
                {
                }
                field(Posted; Rec.Posted)
                {
                }
                field("External Document No"; Rec."External Document No")
                {
                }
                field("Payment Voucher Created"; Rec."Payment Voucher Created")
                {
                }
                field("No. of Brand Ambassadors"; Rec."No. of Brand Ambassadors")
                {
                }
                field("No. of Team Leaders"; Rec."No. of Team Leaders")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("PV Created"; Rec."PV Created")
                {
                }
                field("PV No"; Rec."PV No")
                {
                }
                field("Date PV Created"; Rec."Date PV Created")
                {
                }
                field("Time PV Created"; Rec."Time PV Created")
                {
                }
                field("PV Created By"; Rec."PV Created By")
                {
                }
                field("Work Start Date"; Rec."Work Start Date")
                {
                }
                field("Work End Date"; Rec."Work End Date")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                }
                field("Contract Type"; Rec."Contract Type")
                {
                }
                field("Resources to assign"; Rec."Resources to assign")
                {
                }
                field("No of Deployment with similar"; Rec."No of Deployment with similar")
                {
                }
            }
        }
    }

    actions
    {
    }
}

