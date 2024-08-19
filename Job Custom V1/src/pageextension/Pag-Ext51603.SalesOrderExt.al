pageextension 51603 "Sales Order Ext" extends "Sales Order"
{
    layout
    {
        addafter(Status)
        {
            field("Job Description"; Rec."Job Description")
            {
                ApplicationArea = All;
                Caption = 'Project Description';
            }
            field("Project Type"; Rec."Project Type")
            {
                ApplicationArea = All;
            }
        }
        addafter("Assigned User ID")
        {
            field(Supplementary; Rec.Supplementary)
            {
                ApplicationArea = All;
            }
            field("Agency Fee"; Rec."Agency Fee")
            {
                ApplicationArea = All;
            }
            field("Sub Total amount"; Rec."Sub Total amount")
            {
                ApplicationArea = All;
            }



        }
    }
    actions
    {
        addlast("O&rder")
        {
            action("Create Project")
            {
                Image = Job;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Job: Record Job;
                    SalesLine: Record "Sales Line";
                    JobTask: Record "Job Task";
                begin
                    Rec.TestField("Project Created", false);
                    Job.Init;
                    Job."No." := '';
                    Job.Description := Rec."Job Description";
                    Job.Validate(Description);
                    //ADDED ON 20/09/2018 TO ADD SUPPLIMENTARY JOB
                    Job.Supplimentary := Rec.Supplementary;
                    //added on 22/11/2018
                    Job."PO No" := Rec."External Document No.";
                    //end

                    Job."Bill-to Customer No." := Rec."Sell-to Customer No.";
                    Job.Validate("Bill-to Customer No.");
                    Job."Project Type" := Rec."Project Type";
                    Job."Global Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                    //Job."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                    //MESSAGE('%1',"Shortcut Dimension 2 Code");
                    Job."Sales Order" := Rec."No.";
                    if Job.Insert(true) then begin
                        SalesLine.Reset;
                        SalesLine.SetRange(SalesLine."Document No.", Rec."No.");
                        if SalesLine.FindSet then begin
                            repeat
                                JobTask.Init;
                                JobTask."Job No." := Job."No.";
                                JobTask."Job Task No." := Format(SalesLine."Line No.");
                                JobTask.Quantity := SalesLine.Quantity * SalesLine."No. of Days";
                                //added on 30/11/2018 no of days and qty
                                JobTask."Sales Line No. of Days" := SalesLine."No. of Days";
                                JobTask."Sales Line Qty" := SalesLine.Quantity;
                                JobTask.Description := SalesLine.Description;
                                //added on 5/11/2018 to tick inhouse items and one can reserve them
                                JobTask.Inhouse := SalesLine.Inhouse;
                                //end
                                //added on 05/02/2019 to add purpose
                                JobTask.Purpose := SalesLine.Purpose;
                                //
                                JobTask.Insert(true);
                            /*
                            //insert budget job task lines
                            PlanningLines.INIT;
                            PlanningLines."Job No." := Job."No.";
                            PlanningLines."Job Task No." := FORMAT(SalesLine."Line No.");
                            PlanningLines."Line Type" := PlanningLines."Line Type"::Budget;
                            PlanningLines."Line No." := SalesLine."Line No."+1000;
                            PlanningLines."Line no" := SalesLine."Line No."+1000;
                            IF SalesLine."Management Fee" = TRUE THEN
                            BEGIN
                              PlanningLines.Type := PlanningLines.Type::"G/L Account";
                            END ELSE
                            BEGIN
                              PlanningLines.Type := PlanningLines.Type::Resource;
                            END;
                            PlanningLines."No." := SalesLine."No.";
                            PlanningLines.Description := SalesLine.Description;
                            PlanningLines.Quantity := SalesLine.Quantity;
                            PlanningLines."Unit Cost" := SalesLine."Unit Cost";
                            PlanningLines.VALIDATE(PlanningLines."Unit Cost");
                            PlanningLines."Unit Price" := SalesLine."Unit Price";
                            PlanningLines.VALIDATE(PlanningLines."Unit Price");
                            PlanningLines."Planning Date" := Job."Last Date Modified";
                            PlanningLines."Planned Delivery Date" := Job."Last Date Modified";
                            PlanningLines.INSERT(TRUE);
                            */
                            until SalesLine.Next = 0;
                        end;
                    end;
                    Rec."Project Created" := true;
                    Rec.Modify(true);

                    Rec.TestField("Project Created", true);

                    Job.Reset;
                    Job.SetRange("Sales Order", Rec."No.");
                    if Job.FindSet then begin
                        SalesLine.Reset;
                        SalesLine.SetRange(SalesLine."Document No.", Rec."No.");
                        if SalesLine.FindSet then begin
                            repeat

                                //insert budget job task lines
                                PlanningLines.Init;
                                PlanningLines."Job No." := Job."No.";
                                PlanningLines."Job Task No." := Format(SalesLine."Line No.");
                                PlanningLines."Line Type" := PlanningLines."Line Type"::"Both Budget and Billable";
                                PlanningLines."Line No." := SalesLine."Line No." + 1000;
                                PlanningLines."Line no" := SalesLine."Line No." + 1000;
                                PlanningLines."Schedule Line" := true;
                                PlanningLines."Contract Line" := true;
                                if SalesLine.Type = SalesLine.Type::"G/L Account" then begin
                                    PlanningLines.Type := PlanningLines.Type::"G/L Account";
                                end;
                                if SalesLine.Type = SalesLine.Type::Resource then begin
                                    PlanningLines.Type := PlanningLines.Type::Resource;
                                end;
                                if SalesLine.Type = SalesLine.Type::Item then begin
                                    PlanningLines.Type := PlanningLines.Type::Item;
                                end;
                                PlanningLines."No." := SalesLine."No.";
                                PlanningLines.Validate(PlanningLines."No.");
                                PlanningLines.Description := SalesLine.Description;
                                PlanningLines.Quantity := SalesLine.Quantity * SalesLine."No. of Days";
                                PlanningLines."Unit Cost" := 0;//updated on 19/06/2019 to put cost amount to zer
                                                               //PlanningLines.VALIDATE(PlanningLines."Unit Cost");
                                PlanningLines."Unit Price" := SalesLine."Unit Price";
                                //added on 30/11/2018 no of days and qty
                                PlanningLines."No. of Days" := SalesLine."No. of Days";
                                PlanningLines."Sales Line Qty" := SalesLine.Quantity;
                                PlanningLines.Validate(PlanningLines."Unit Price");
                                //added on 05/02/2019 to add purpose
                                PlanningLines.Purpose := SalesLine.Purpose;
                                //
                                PlanningLines."Planning Date" := Job."Last Date Modified";
                                PlanningLines."Planned Delivery Date" := Job."Last Date Modified";
                                PlanningLines.Insert(true);
                            until SalesLine.Next = 0;
                        end;
                    end;


                    Message('The project was successfully created. (%1)', Job."No.");

                end;
            }
            action("Update Project Budget")
            {
                Image = JobLines;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Job: Record Job;
                    SalesLine: Record "Sales Line";
                    JobTask: Record "Job Task";
                begin
                    //MESSAGE('create project');
                    Rec.TestField("Project Created", true);

                    Job.Reset;
                    Job.SetRange("Sales Order", Rec."No.");
                    if Job.FindSet then begin
                        SalesLine.Reset;
                        SalesLine.SetRange(SalesLine."Document No.", Rec."No.");
                        if SalesLine.FindSet then begin
                            repeat

                                //insert budget job task lines
                                PlanningLines.Init;
                                PlanningLines."Job No." := Job."No.";
                                PlanningLines."Job Task No." := Format(SalesLine."Line No.");
                                PlanningLines."Line Type" := PlanningLines."Line Type"::"Both Budget and Billable";
                                PlanningLines."Line No." := SalesLine."Line No." + 1000;
                                PlanningLines."Line no" := SalesLine."Line No." + 1000;
                                PlanningLines."Schedule Line" := true;
                                PlanningLines."Contract Line" := true;
                                if SalesLine.Type = SalesLine.Type::"G/L Account" then begin
                                    PlanningLines.Type := PlanningLines.Type::"G/L Account";
                                end;
                                if SalesLine.Type = SalesLine.Type::Resource then begin
                                    PlanningLines.Type := PlanningLines.Type::Resource;
                                end;
                                if SalesLine.Type = SalesLine.Type::Item then begin
                                    PlanningLines.Type := PlanningLines.Type::Item;
                                end;
                                PlanningLines."No." := SalesLine."No.";
                                PlanningLines.Validate(PlanningLines."No.");
                                PlanningLines.Description := SalesLine.Description;
                                PlanningLines.Quantity := SalesLine.Quantity * SalesLine."No. of Days";
                                PlanningLines."Unit Cost" := SalesLine."Unit Cost";
                                //PlanningLines.VALIDATE(PlanningLines."Unit Cost");
                                PlanningLines."Unit Price" := SalesLine."Unit Price";
                                //added on 30/11/2018 no of days and qty
                                PlanningLines."No. of Days" := SalesLine."No. of Days";
                                PlanningLines."Sales Line Qty" := SalesLine.Quantity;
                                PlanningLines.Validate(PlanningLines."Unit Price");
                                PlanningLines."Planning Date" := Job."Last Date Modified";
                                PlanningLines."Planned Delivery Date" := Job."Last Date Modified";
                                PlanningLines.Insert(true);
                            until SalesLine.Next = 0;
                        end;
                    end;
                    Message('The budet project was successfully updated. (%1)', Job."No.");
                end;
            }
        }
    }
    var
        PlanningLines: Record "Job Planning Line";
}
