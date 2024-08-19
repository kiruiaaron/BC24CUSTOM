page 51623 "Assignment Card"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Project Assignment Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Assignment Number"; Rec."Assignment Number")
                {
                    Editable = false;
                }
                field(Project; Rec.Project)
                {
                }
                field("Project Name"; Rec."Project Name")
                {
                    Editable = false;
                }
                field("Contract Type"; Rec."Contract Type")
                {
                }
                field("Task No"; Rec."Task No")
                {
                    Editable = false;
                }
                field("Task Description"; Rec."Task Description")
                {
                    Editable = false;
                }
                field("Quoted Resources"; Rec."Quoted Resources")
                {
                }
                field("Quoted No. of Days"; Rec."Quoted No. of Days")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Resources Already Deployed"; Rec."Resources Already Deployed")
                {
                }
                field("Resources to assign"; Rec."Resources to assign")
                {
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    Editable = false;
                    Visible = true;
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Created On"; Rec."Created On")
                {
                    Editable = false;
                }
                field("Created By"; Rec."Created By")
                {
                    Editable = false;
                }
                field("BA Category"; Rec."BA Category")
                {
                    Editable = false;
                }
                field("BA Category Description"; Rec."BA Category Description")
                {
                    Editable = false;
                }
                field("Region Code"; Rec."Region Code")
                {
                    Editable = true;
                }
                field(Week; Rec.Week)
                {
                    Caption = 'Work Dates';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                }
            }
            part(Control10; "Assignment Lines")
            {
                SubPageLink = "Assignment Number" = FIELD("Assignment Number");
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Deploy)
            {
                Image = CreateInteraction;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    //updated on 02/01/2019 to enforce vendor
                    Rec.TestField("BA Category");
                    Rec.TestField("Task No");
                    Rec.TestField("Contract Type");
                    //end
                    AssignmentLines.Reset;
                    AssignmentLines.SetRange("Assignment Number", Rec."Assignment Number");
                    if AssignmentLines.FindSet then begin
                        repeat
                            AssignmentLines.TestField(Select);
                        until AssignmentLines.Next = 0;

                    end;

                    if Confirm('Are you sure you want to deploy the selected?') = true then begin
                        if Rec."Resources Already Deployed" > Rec.Quantity then
                            Error('You have already exhausted all the quoted resources, quoted resources=%1 Resources already deployed=%2', Rec."Quoted Resources", Rec."Resources Already Deployed");
                        AssignmentHeader.Reset;
                        AssignmentHeader.SetRange("Assignment Number", Rec."Assignment Number");
                        if AssignmentHeader.FindSet then begin
                            //INSERT IN THE HEADER

                            CashMgt.Reset;
                            if CashMgt.Find('-') then begin
                                Noseries := CashMgt."Deployment Number Series";
                            end;
                            if Rec."Total Amount" = 0 then
                                Error('Total Amount cannot be zero or empty');

                            DeployementHeader.Init;
                            DeployementHeader.Code := NoSeriesMgt.GetNextNo(Noseries, DeployementHeader.Date, true);
                            DeployementHeader.Date := Today;
                            DeployementHeader."Date Created" := Today;
                            DeployementHeader."Created By" := UserId;
                            DeployementHeader."Time Created" := Time;
                            DeployementHeader."Work Dates" := AssignmentHeader.Week;
                            DeployementHeader.Region := AssignmentHeader."Region Code";
                            DeployementHeader."B A Category" := AssignmentHeader."BA Category";
                            DeployementHeader.Validate(DeployementHeader."B A Category");
                            DeployementHeader."Shortcut Dimension 2 Code" := AssignmentHeader."Shortcut Dimension 2 Code";
                            DeployementHeader.Deployment := true;
                            //updated on 17/01/2018 to add contract type
                            DeployementHeader."Contract Type" := AssignmentHeader."Contract Type";
                            //

                            EmployeeRec.Reset;
                            //to be EmployeeRec.SetRange("User ID", UserId);
                            if EmployeeRec.FindSet then begin
                                //DeployementHeader.Region := EmployeeRec."Region Supervised";
                                DeployementHeader."Supervisor Code" := EmployeeRec."No.";
                                DeployementHeader."Supervisor Name" := EmployeeRec.FullName;
                            end;

                            DeployementHeader.Project := AssignmentHeader.Project;
                            DeployementHeader.Validate(DeployementHeader.Project);
                            DeployementHeader."Task No" := AssignmentHeader."Task No";
                            DeployementHeader.Validate(DeployementHeader."Task No");
                            //added on 15/03/2019
                            DeployementHeader."Quoted No. of Days" := AssignmentHeader."Quoted No. of Days";
                            DeployementHeader."Quoted Resources" := AssignmentHeader."Quoted Resources";
                            DeployementHeader.Insert;


                            //INSERT THE LINES
                            AssignmentLines.Reset;
                            // to be AssignmentLines.SetRange("Assignment Number", "Assignment Number");
                            AssignmentLines.SetRange(Select, true);
                            if AssignmentLines.FindSet then begin
                                repeat
                                    DeploymentLines.Init;
                                    DeploymentLines."Deployment Header" := DeployementHeader.Code;
                                    DeploymentLines."B A Code" := AssignmentLines."BA Code";
                                    DeploymentLines."B A Name" := AssignmentLines."BA Name";
                                    DeploymentLines."Team Leader" := AssignmentLines."Team Leader";
                                    DeploymentLines.Validate(DeploymentLines."Team Leader");
                                    DeploymentLines."Vendor No" := AssignmentHeader."BA Category";
                                    DeploymentLines."Daily Rate" := AssignmentLines."Daily Rate";
                                    DeploymentLines."Phone Number" := AssignmentLines."Phone Number";
                                    DeploymentLines."ID Number" := AssignmentLines."ID Number";
                                    //added on 15/03/2019
                                    DeploymentLines."Quoted No. of Days" := AssignmentHeader."Quoted No. of Days";
                                    DeploymentLines."Actual Days Worked" := DeploymentLines."No of Days";
                                    DeploymentLines."Actual Amount" := DeploymentLines.Amount;
                                    DeploymentLines."Actual Amount" := DeploymentLines."No of Days" * DeploymentLines."Daily Rate";
                                    DeploymentLines.Insert;



                                    //update assignment lines select to false
                                    AssignmentLines.Select := false;
                                    AssignmentLines.Deployed := true;
                                    AssignmentLines.Modify;

                                until AssignmentLines.Next = 0;
                            end;

                            //update the header
                            AssignmentHeader.Deployed := true;
                            AssignmentHeader."Deployed By" := UserId;
                            AssignmentHeader."Date Deployed" := Today;
                            AssignmentHeader."Time Deployed" := Time;
                            AssignmentHeader.Modify;
                        end;
                    end;

                    Commit;
                    if Confirm('Deployment No. ' + DeployementHeader.Code + ' was successfully created.Would you like to open it?', false) then
                        PAGE.RunModal(56037, DeployementHeader);
                end;
            }
            action("Select All")
            {
                Image = SelectEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to deploy the selected?') = true then begin
                        AssignmentHeader.Reset;
                        AssignmentHeader.SetRange("Assignment Number", Rec."Assignment Number");
                        if AssignmentHeader.FindSet then begin
                            AssignmentLines.Reset;
                            AssignmentLines.SetRange("Assignment Number", AssignmentHeader."Assignment Number");
                            if AssignmentLines.FindSet then begin
                                repeat
                                    AssignmentLines.Select := true;
                                    AssignmentLines.Modify;
                                until AssignmentLines.Next = 0;
                            end;
                        end;
                    end;
                end;
            }
            action("UnSelect All")
            {
                Image = DeleteAllBreakpoints;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to unselect?') = true then begin
                        AssignmentHeader.Reset;
                        AssignmentHeader.SetRange("Assignment Number", Rec."Assignment Number");
                        if AssignmentHeader.FindSet then begin
                            AssignmentLines.Reset;
                            AssignmentLines.SetRange("Assignment Number", AssignmentHeader."Assignment Number");
                            AssignmentLines.SetRange(Select, true);
                            if AssignmentLines.FindSet then begin
                                repeat
                                    AssignmentLines.Select := false;
                                    AssignmentLines.Modify;
                                until AssignmentLines.Next = 0;
                            end;
                        end;
                    end;
                end;
            }
        }
    }

    var
        AssignmentLines: Record "Assignment Lines";
        DeployementHeader: Record "Deployment Header";
        DeploymentLines: Record "Deployment Lines";
        AssignmentHeader: Record "Project Assignment Header";
        EmployeeRec: Record Employee;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CashMgt: Record "BA SetUp";
        Noseries: Code[20];
        Deploymentcard: Integer;
}

