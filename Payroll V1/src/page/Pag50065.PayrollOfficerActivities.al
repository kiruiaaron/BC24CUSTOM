page 50065 "Payroll Officer Activities"
{
    ApplicationArea = All;
    Caption = 'Payroll Officer Activities';
    PageType = CardPart;
    SourceTable = "Payroll Cue";

    layout
    {
        area(Content)
        {

            cuegroup(Control54)
            {
                Caption = 'Payroll Activities';

                field("Basic Pay"; Rec."Basic Pay")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Basic Pay field.', Comment = '%';
                    DrillDownPageId = "Payroll Lines LookUp";
                }
                field(Commission; Rec.Commission)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Commission field.', Comment = '%';
                    DrillDownPageId = "Payroll Lines LookUp";
                }


                field(NHIF; Rec.NHIF)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the NHIF field.', Comment = '%';
                    DrillDownPageId = "Payroll Lines LookUp";
                }
                field(NSSF; Rec.NSSF)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the NSSF field.', Comment = '%';
                    DrillDownPageId = "Payroll Lines LookUp";
                }
                field(HELB; Rec.HELB)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the HELB field.', Comment = '%';
                    DrillDownPageId = "Payroll Lines LookUp";
                }
                field(HLevy; Rec.HLevy)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the HLevy field.', Comment = '%';
                    DrillDownPageId = "Payroll Lines LookUp";
                }
                field(PAYE; Rec.PAYE)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the PAYE field.', Comment = '%';
                    DrillDownPageId = "Payroll Lines LookUp";
                }
                field("Net Pay"; NetPay)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Net Pay field.', Comment = '%';
                    //DrillDownPageId = "Payroll Lines LookUp";
                }
            }
            cuegroup("HR Activities")
            {
                Caption = 'HR Activities';
                field("Female Employees"; Rec."Female Employees")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Female Employees field.', Comment = '%';
                    DrillDownPageId = "Employee List";
                }
                field("Male Employees"; Rec."Male Employees")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Male Employees field.', Comment = '%';
                    DrillDownPageId = "Employee List";
                }
                field("Active Employees"; Rec."Active Employees")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Active Employees field.', Comment = '%';
                    DrillDownPageId = "Employee List";
                }

                field("Inactive Employees"; Rec."Inactive Employees")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Inactive Employees field.', Comment = '%';
                    DrillDownPageId = "Employee List";
                }


            }

        }
    }
    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
            Commit();
        end;
        PayrollPeriodRec.Reset();
        PayrollPeriodRec.SetRange(Status, PayrollPeriodRec.Status::Open);
        if PayrollPeriodRec.FindLast() then;
        Rec.SetFilter("Period Filter", '%1', PayrollPeriodRec."Period ID");

        GetNetPay();
    end;

    local procedure GetNetPay()
    begin
        TotalPayments := 0;
        PayrollLinesRec.Reset();
        PayrollLinesRec.SetRange("Payroll ID", PayrollPeriodRec."Period ID");
        PayrollLinesRec.SetRange("Calculation Group", PayrollLinesRec."Calculation Group"::Payments);
        if PayrollLinesRec.FindSet() then
            repeat
                TotalPayments += PayrollLinesRec.Amount;
            until PayrollLinesRec.Next() = 0;
        //Deductions
        NetPay := 0;
        TotalDeductions := 0;
        PayrollLinesRec.Reset();
        PayrollLinesRec.SetRange("Payroll ID", PayrollPeriodRec."Period ID");
        PayrollLinesRec.SetRange("Calculation Group", PayrollLinesRec."Calculation Group"::Deduction);
        if PayrollLinesRec.FindSet() then
            repeat
                TotalDeductions += PayrollLinesRec.Amount;
            until PayrollLinesRec.Next() = 0;
        NetPay := TotalPayments - TotalDeductions;

    end;



    var
        O365GettingStartedMgt: codeunit "O365 Getting Started Mgt.";
        PayrollPeriodRec: Record Periods;
        NetPay: Decimal;
        PayrollLinesRec: Record "Payroll Lines";
        TotalPayments: Decimal;
        TotalDeductions: Decimal;
    // UserTours: DotNet UserTours;

}

