page 51616 "Deployment Lines"
{
    PageType = ListPart;
    SourceTable = "Deployment Lines";
    SourceTableView = SORTING("B A Team Leader", "Team Leader")
                      ORDER(Descending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Deployment Header"; Rec."Deployment Header")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = teamLeader;
                }
                field("B A Code"; Rec."B A Code")
                {
                    Editable = true;
                    Style = Strong;
                    StyleExpr = teamLeader;
                }
                field("B A Name"; Rec."B A Name")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = teamLeader;
                }
                field("Phone Number"; Rec."Phone Number")
                {
                    Editable = false;
                }
                field("ID Number"; Rec."ID Number")
                {
                    Editable = true;
                    Visible = true;
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    Style = Strong;
                    StyleExpr = teamLeader;
                    Visible = false;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    Style = Strong;
                    StyleExpr = teamLeader;
                    Visible = false;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    Style = Strong;
                    StyleExpr = teamLeader;
                    Visible = false;
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    Style = Strong;
                    StyleExpr = teamLeader;
                    Visible = false;
                }
                field("Account Number"; Rec."Account Number")
                {
                    Style = Strong;
                    StyleExpr = teamLeader;
                    Visible = false;
                }
                field("Actual Days Worked"; Rec."Actual Days Worked")
                {
                }
                field("Daily Rate"; Rec."Daily Rate")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = teamLeader;
                }
                field(Amount; Rec.Amount)
                {
                    Visible = false;
                }
                field("Actual Amount"; Rec."Actual Amount")
                {
                    Editable = false;
                }
                field("Venue/Outlet"; Rec."Venue/Outlet")
                {
                    Style = Standard;
                    StyleExpr = teamLeader;
                }
                field("Subcontract Type"; Rec."Subcontract Type")
                {
                    Visible = false;
                }
                field("Vendor No"; Rec."Vendor No")
                {
                    Editable = false;
                    Style = Standard;
                    StyleExpr = teamLeader;
                    Visible = false;
                }
                field(Project; Rec.Project)
                {
                    Visible = false;
                }
                field("Task No"; Rec."Task No")
                {
                    Visible = false;
                }
                field("Task Description"; Rec."Task Description")
                {
                    Visible = false;
                }
                field("Quoted Quantity"; Rec."Quoted Quantity")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Quoted No. of Days"; Rec."Quoted No. of Days")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Quoted Total Amount"; Rec."Quoted Total Amount")
                {
                    Caption = '<Quoted Total Quantity>';
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        if DeploymentHeader.Get(Rec."Deployment Header") then begin
            daysEditable := DeploymentHeader.Status = DeploymentHeader.Status::open;
            actualWorked := DeploymentHeader.Status = DeploymentHeader.Status::approved;
        end;
        teamLeader := Rec."Team Leader";
    end;

    var
        daysEditable: Boolean;
        DeploymentHeader: Record "Deployment Header";
        actualWorked: Boolean;
        teamLeader: Boolean;
}

