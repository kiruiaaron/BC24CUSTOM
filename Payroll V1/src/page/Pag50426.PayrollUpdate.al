page 50426 "Payroll Update"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50249;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Period Id"; Rec."Period Id")
                {
                    ApplicationArea = All;
                }
                field("Ed Code"; Rec."Ed Code")
                {
                    ApplicationArea = All;
                }
                field("New Amount"; Rec."New Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Update)
            {
                Image = UpdateUnitCost;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //update basic pay
                    //Test Status
                    /*    HREmployeeDetailUpdateRec.RESET;
                       HREmployeeDetailUpdateRec.SETRANGE("No.", Rec."No.");
                       IF HREmployeeDetailUpdateRec.FINDFIRST THEN
                           HREmployeeDetailUpdateRec.TESTFIELD(Status, HREmployeeDetailUpdateRec.Status::Approved); */

                    EmployeeRec.GET(Rec."Employee No.");
                    PayrollSetupRec.GET(EmployeeRec."Payroll Code");
                    REPEAT
                        PayrollEntryRec.RESET;
                        PayrollEntryRec.SETRANGE("ED Code", Rec."Ed Code");
                        PayrollEntryRec.SETRANGE("Payroll ID", Rec."Period Id");
                        IF PayrollEntryRec.FINDFIRST THEN BEGIN

                            PayrollEntryRec.VALIDATE(Amount, Rec."New Amount");

                            entriesUpdated += 1;
                            PayrollEntryRec.MODIFY;
                            IF Rec."Ed Code" = PayrollSetupRec."Basic Pay E/D Code" THEN BEGIN
                                EmployeeRec."Fixed Pay" := Rec."New Amount";
                                EmployeeRec.MODIFY;
                            END;
                        END ELSE BEGIN
                            PayrollEntryRec.INIT;
                            PayrollEntryRec."Payroll ID" := Rec."Period Id";
                            PayrollEntryRec."Employee No." := Rec."Employee No.";
                            PayrollSetupRec.GET(EmployeeRec."Payroll Code");
                            PayrollEntryRec.VALIDATE("ED Code", Rec."Ed Code");
                            PayrollEntryRec.VALIDATE("Currency Code", EmployeeRec."Basic Pay Currency");
                            PayrollEntryRec.VALIDATE(Amount, Rec."New Amount");
                            PayrollEntryRec.Editable := FALSE;
                            PayrollEntryRec."Loan ID" := 0;
                            PayrollEntryRec.VALIDATE(Interest, 0);
                            PayrollEntryRec.VALIDATE(Repayment, 0);
                            PayrollEntryRec.VALIDATE("Remaining Debt", 0);
                            PayrollEntryRec.VALIDATE(Paid, 0);
                            PayrollEntryRec."Loan Entry" := FALSE;
                            PayrollEntryRec."Loan Entry No" := 0;
                            IF Rec."Ed Code" = PayrollSetupRec."Basic Pay E/D Code" THEN BEGIN
                                EmployeeRec."Fixed Pay" := Rec."New Amount";
                                PayrollEntryRec."Basic Pay Entry" := TRUE;
                            END ELSE
                                PayrollEntryRec."Basic Pay Entry" := FALSE;
                            PayrollEntryRec."Time Entry" := TRUE;
                            PayrollEntryRec.INSERT;
                        END;
                    UNTIL Rec.NEXT = 0;
                    MESSAGE('%1 entries updated', entriesUpdated);
                end;
            }
        }
    }

    var
        PayrollSetupRec: Record 51165;
        PayrollEntryRec: Record 51161;
        PayrollPeriodRec: Record 51151;
        EmployeeRec: Record 5200;
        entriesUpdated: Integer;
    //  HREmployeeDetailUpdateRec: Record 50116;
}

