page 51617 "Deployment Planner Card"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Deployment Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code"; Rec.Code)
                {
                    Editable = false;
                }
                field("Supervisor Code"; Rec."Supervisor Code")
                {
                    Editable = true;
                }
                field("Supervisor Name"; Rec."Supervisor Name")
                {
                }
                field("Supervisor UserID"; Rec."Supervisor UserID")
                {
                }
                field(Region; Rec.Region)
                {
                    Editable = true;
                }
                field(Project; Rec.Project)
                {
                    Editable = true;
                }
                field("Project Name"; Rec."Project Name")
                {
                    Editable = false;
                }
                field("B A Category"; Rec."B A Category")
                {
                    Editable = false;
                }
                field("B A Category Name"; Rec."B A Category Name")
                {
                    Editable = false;
                }
                field("Contract Type"; Rec."Contract Type")
                {
                    Visible = true;
                }
                field("Task No"; Rec."Task No")
                {
                    Editable = false;
                    Visible = true;
                }
                field("Task Description"; Rec."Task Description")
                {
                    Editable = false;
                    Visible = true;
                }
                field("Quoted Resources"; Rec."Quoted Resources")
                {
                    Visible = true;
                }
                field("Quoted No. of Days"; Rec."Quoted No. of Days")
                {
                    Visible = true;
                }
                field("Total Quoted Quantity"; Rec."Total Quoted Quantity")
                {
                }
                field(Date; Rec.Date)
                {
                    Editable = false;
                }
                field("Total Actual No of Days"; Rec."Total Actual No of Days")
                {
                }
                field("Total Actual Amount"; Rec."Total Actual Amount")
                {
                }
                field("Resources to assign"; Rec."Resources to assign")
                {
                    Caption = 'Resources to deploy';
                }
                field("Resources Already Deployed"; Rec."Resources Already Deployed")
                {
                }
                field("No of Deployment with similar"; Rec."No of Deployment with similar")
                {
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                }
                field("Work Dates"; Rec."Work Dates")
                {
                    Visible = false;
                }
                field("No. of Brand Ambassadors"; Rec."No. of Brand Ambassadors")
                {
                }
                field("No. of Team Leaders"; Rec."No. of Team Leaders")
                {
                }
                field(Released; Rec.Released)
                {
                    Visible = false;
                }
                field("Work Start Date"; Rec."Work Start Date")
                {
                }
                field("Work End Date"; Rec."Work End Date")
                {
                }
                field("Created By"; Rec."Created By")
                {
                    Editable = false;
                }
                field("Date Created"; Rec."Date Created")
                {
                    Editable = false;
                }
                field("Time Created"; Rec."Time Created")
                {
                    Editable = false;
                }
            }
            part(Control13; "Deployment Lines")
            {
                SubPageLink = "Deployment Header" = FIELD(Code);
            }
        }
    }

    actions
    {
        area(creation)
        {
            group(Action14)
            {
                action("Create Payment Voucher")
                {
                    Caption = 'Create Payment Schedule';
                    Image = Post;
                    Promoted = true;
                    Visible = false;

                    trigger OnAction()
                    var
                        DeploymentLines: Record "Deployment Lines";
                        lineNo: Integer;
                    begin
                        /*
                        TESTFIELD(Rec.Released, TRUE);
                        TESTFIELD(Rec.Status, Rec.Status::approved);
                        
                        lineNo:= 0;
                        DeploymentLines.RESET;
                        DeploymentLines.SETRANGE(DeploymentLines."Deployment Header", Code);
                        DeploymentLines.SETRANGE(Transfered, FALSE);
                        IF DeploymentLines.FINDSET THEN BEGIN
                          REPEAT
                            lineNo:= lineNo+1000;
                            IF Payments."No." = '' THEN BEGIN
                            Payments.INIT;
                            Payments.Date:= TODAY;
                            Payments."No.":= '';
                            Payments.VALIDATE("No.");
                            Payments."Document Type":= Payments."Document Type"::"Payment Voucher";
                            Payments."Payment Type":= Payments."Payment Type"::"Payment Voucher";
                            IF Payments.INSERT(TRUE) THEN BEGIN
                              MESSAGE('Payment schedule %1 was successfully created', Payments."No.");
                              END;
                              END;
                              //insert lines
                              PVLines.INIT;
                              PVLines.No:= Payments."No.";
                              PVLines."Line No":= lineNo;
                              PVLines."Account Type":= PVLines."Account Type"::Vendor;
                              PVLines."Account No":= "B A Category";
                              PVLines.VALIDATE("Account No");
                              PVLines."B A Code":= DeploymentLines."B A Code";
                              PVLines.VALIDATE("B A Code");
                              PVLines."No of Days":= DeploymentLines."Actual Days Worked";
                              PVLines.VALIDATE("No of Days");
                              PVLines.INSERT(TRUE);
                        
                        
                              //update bank account details
                              VendorBankAccount.INIT;
                              VendorBankAccount."Vendor No.":= "B A Category";
                              VendorBankAccount.Code:= DeploymentLines."B A Code";
                              VendorBankAccount.Name:= DeploymentLines."B A Name";
                        
                              Resource.RESET;
                              Resource.SETRANGE("No.",DeploymentLines."B A Code");
                              IF Resource.FINDSET THEN
                              BEGIN
                                VendorBankAccount."Phone No.":= Resource."Phone Number";
                        
                              END;
                              VendorBankAccount.INSERT(TRUE);
                              DeploymentLines.Transfered:= TRUE;
                              DeploymentLines.MODIFY(TRUE);
                        
                               MESSAGE('in%1',"B A Category",DeploymentLines."B A Code");
                        
                            UNTIL DeploymentLines.NEXT = 0;
                            END ELSE BEGIN
                              ERROR('No deployment lines were found');
                              END;
                              */

                    end;
                }
                action(SendApprovalRequest)
                {
                    Caption = 'Send A&pproval Request';
                    Enabled = true;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = New;

                    trigger OnAction()
                    begin
                        Rec.TestField("Work Start Date");
                        Rec.TestField("Work End Date");
                        Rec.TestField(Region);

                        Rec.CalcFields("No of Deployment with similar", "Total Actual Amount");
                        if REc."No of Deployment with similar" > 0 then
                            Rec.TestField("Resources to assign");
                        Rec.TestField("Total Actual Amount");

                        /*IF ApprovalsMgmt.CheckJobsApprovalsWorkflowEnabled(Rec) THEN
                          ApprovalsMgmt.OnSendJobsForApproval(Rec);
                          */
                        ///Status:=Status::approved;

                        //check if the venue/outlet has been filled in the lines

                        DeploymentLines.Reset;
                        DeploymentLines.SetRange("Deployment Header", Rec.Code);
                        if DeploymentLines.FindSet then begin
                            repeat
                                DeploymentLines.TestField("ID Number");
                                DeploymentLines.TestField("Phone Number");
                                DeploymentLines.TestField("Venue/Outlet");
                                DeploymentLines.TestField("B A Code");
                                DeploymentLines.TestField("Actual Amount");
                                DeploymentLines.TestField("Actual Days Worked");
                                DeploymentLines.TestField("Daily Rate");
                            until DeploymentLines.Next = 0;

                        end;
                        /*
                        //
                        DeploymentLines1.RESET;
                        DeploymentLines1.SETRANGE("Deployment Header",Code);
                        IF DeploymentLines1.FINDSET THEN
                        BEGIN
                          REPEAT
                            ERROR('The mobile number has been assigned to another ID number %1',DeploymentLines1."Phone Number");
                          UNTIL DeploymentLines1.NEXT=0;
                        END;
                        //
                        */

                        //IF "Resources Already Deployed">"Total Quoted Quantity" THEN
                        //ERROR('You have already exhausted all the quoted resources, quoted resources=%1 Resources already deployed=%2',"Quoted Resources","Resources Already Deployed" );

                        /*IF ApprovalsMgmt.CheckDeploymentApprovalsWorkflowEnabled(Rec) THEN
                          ApprovalsMgmt.OnSendDeploymentForApproval(Rec);
                        */ // to be

                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = true;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = New;

                    trigger OnAction()
                    begin

                        // to be ApprovalsMgmt.OnCancelDeploymentApprovalRequest(Rec);
                    end;
                }
                action("Batch Assignment")
                {
                    Image = PaymentJournal;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        Rec.TestField(Project);
                        Resource.Reset;
                        Resource.SetRange("Project Code", Rec.Project);
                        if Resource.FindSet then begin
                            repeat
                                DeploymentLines.Init;

                            until Resource.Next = 0;
                        end;
                    end;
                }
            }
            action("Notify the Project Manager")
            {
                Image = SendConfirmation;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                    /*                     if Confirm('Are you sure you want to notify the project manager about the deployment?') = true then begin
                                            ProjectRec.Reset;
                                            ProjectRec.SetRange("No.",Rec.Project);
                                            if ProjectRec.FindSet then begin

                                                Employees1.Reset;
                                                Employees1.SetRange("User ID", ProjectRec."Project Manager");
                                                if Employees1.Find('-') then begin
                                                    Email2 := Employees1."Company E-Mail";
                                                end;
                                            end;

                                            //  Deployment.RESET;
                                            //Deployment.SETRANGE(Project)


                                            jobplanninglines.Reset;
                                            jobplanninglines.SetRange("Job No.", Project);
                                            jobplanninglines.SetRange("Job Task No.", "Task No");
                                            if jobplanninglines.FindSet then begin
                                                CalcFields("Total Number of Days");
                                                jobplanninglines."Planned Quantity" := "Total Number of Days";
                                                jobplanninglines.Modify;

                                            end;





                                            Employee2.Reset;
                                            Employee2.SetRange("User ID", UserId);
                                            if Employee2.Find('-') then begin
                                                Email := Employee2."Company E-Mail";
                                                Name := Employee2."First Name" + ' ' + Employee2."Middle Name" + ' ' + Employee2."Last Name";
                                            end;

                                            Body := 'Kindly login to the ERP System and requistion for deployment No. ' + Code + ' from ' + Name + ' for the project no ' + Project + ' ' + "Project Name" + '.';

                                            SMTP.CreateMessage('TRUEBLAQ ERP', Email, Email2, 'Deployment Notification', Body, true);
                                            SMTP.AddCC(Email);
                                            SMTP.Send();

                                            Message('Deployment notification sent, successfully.');
                                        end;*/
                end;

            }
            action(Print)
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.SetRange(Code, Rec.Code);
                    REPORT.Run(50003, true, true, Rec);
                end;
            }
            action("Import Data")
            {
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.TestField(Code);
                    BAImports.FilterGroup(2);
                    BAImports.SetRange("Deployment Code", Rec.Code);
                    BAImports.FilterGroup(0);
                    PAGE.RunModal(56109, BAImports);
                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Deployment := true;
    end;

    var
        Resource: Record Resource;
        DeploymentLines: Record "Deployment Lines";
        Employees1: Record Employee;
        Employee2: Record Employee;
        ProjectRec: Record Job;
        Body: Text[250];
        Email: Text[250];
        Email2: Text[250];
        //SMTP: Codeunit "SMTP Mail";
        Name: Text[100];
        jobplanninglines: Record "Job Planning Line";
        Deployment: Record "Deployment Header";
        VendorBankAccount: Record "Vendor Bank Account";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        BAImports: Record "BA Deploymet Import";
        DeploymentLines1: Record "Deployment Lines";
}

