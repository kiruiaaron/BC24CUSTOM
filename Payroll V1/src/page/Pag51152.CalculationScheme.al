page 51152 "Calculation Scheme"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 51154;

    layout
    {
        area(content)
        {
            repeater(r1)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("Scheme ID"; Rec."Scheme ID")
                {
                    TableRelation = "Calculation Header"."Scheme ID";
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Visible = DescriptionVisible;
                    ApplicationArea = All;
                }
            }
            group(Input1)
            {
                Caption = 'Input';
                field(Input; Rec.Input)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        InputOnAfterValidate;
                    end;
                }
                field("Payroll Entry"; Rec."Payroll Entry")
                {
                    ApplicationArea = All;
                }
                field("Caculation Line"; Rec."Caculation Line")
                {
                    ApplicationArea = All;
                }
                field(Round; Rec.Round)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        RoundOnAfterValidate;
                    end;
                }
                field("Round Precision"; Rec."Round Precision")
                {
                    ApplicationArea = All;
                }
                field(Calculation; Rec.Calculation)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CalculationOnAfterValidate;
                    end;
                }
                field("Compute To"; Rec."Compute To")
                {
                    Caption = 'Calculate to';
                    Lookup = true;
                    ApplicationArea = All;
                }
                field(Number; Rec.Number)
                {
                    Caption = 'Divide/Multiply';
                    ApplicationArea = All;
                }
                field(LookUp; Rec.LookUp)
                {
                    ApplicationArea = All;
                }
                field("Factor of"; Rec."Factor of")
                {
                    Caption = 'Factor of';
                    ApplicationArea = All;
                }
                field(Percent; Rec.Percent)
                {
                    ApplicationArea = All;
                }
                field("Payroll Lines"; Rec."Payroll Lines")
                {
                    ApplicationArea = All;
                }
                field(P9A; Rec.P9A)
                {
                    Caption = 'P9A Column';
                    ApplicationArea = All;
                }
            }
            group(Indicators)
            {
                Caption = 'Indicators';
                field("Total Earnings (B4 SAPP)"; Rec."Total Earnings (B4 SAPP)")
                {
                    Caption = 'Total Eearnings B4 Pension, Special Allowances and Payments';
                    ToolTip = 'Total Earnings Before Special Allowances, Special Payments and Pension i.e. Total Gross Pay (P9 Column D) less (Special Allowances + Special Payments + Pension)';
                    ApplicationArea = All;
                }
                field("Chargeable Pay (B4 SAP)"; Rec."Chargeable Pay (B4 SAP)")
                {
                    ApplicationArea = All;
                }
                field("Special Allowance"; Rec."Special Allowance")
                {
                    ToolTip = 'Indicates a tax free allowance to be inserted by the system from Special Allowances setup table';
                    ApplicationArea = All;
                }
                field("Special Payment"; Rec."Special Payment")
                {
                    ApplicationArea = All;
                }
                field("Chargeable Pay"; Rec."Chargeable Pay")
                {
                    ApplicationArea = All;
                }
                field("PAYE Lookup Line"; Rec."PAYE Lookup Line")
                {
                    ApplicationArea = All;
                }
                field("Annualize TAX"; Rec."Annualize TAX")
                {
                    ApplicationArea = All;
                }
                field("Annualize Relief"; Rec."Annualize Relief")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        "Caculation LineVisible" := TRUE;
        "Payroll EntryVisible" := TRUE;
        "Round PrecisionVisible" := TRUE;
        LookUpVisible := TRUE;
        NumberVisible := TRUE;
        PercentVisible := TRUE;
        "Factor ofVisible" := TRUE;
        "Compute ToVisible" := TRUE;
        DescriptionVisible := TRUE;
        Rec."Payroll Code" := 'GENERAL';
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Payroll Code" := Pcode;
        Rec.SetUpNewLine(xRec, BelowxRec);
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        gsSegmentPayrollData; //skm150506
        DescriptionVisible := TRUE;
        OnActivateForm;
    end;

    var
        [InDataSet]
        DescriptionVisible: Boolean;
        [InDataSet]
        "Compute ToVisible": Boolean;
        [InDataSet]
        "Factor ofVisible": Boolean;
        [InDataSet]
        PercentVisible: Boolean;
        [InDataSet]
        NumberVisible: Boolean;
        [InDataSet]
        LookUpVisible: Boolean;
        [InDataSet]
        "Round PrecisionVisible": Boolean;
        [InDataSet]
        "Payroll EntryVisible": Boolean;
        [InDataSet]
        "Caculation LineVisible": Boolean;
        lvActiveSession: Record 2000000110;
        Pcode: Code[20];

    procedure ShowCalcFields()
    begin

        "Compute ToVisible" := FALSE;
        "Factor ofVisible" := FALSE;
        PercentVisible := FALSE;
        NumberVisible := FALSE;
        LookUpVisible := FALSE;

        CASE Rec.Calculation OF
            Rec.Calculation::Add, Rec.Calculation::Substract:
                "Compute ToVisible" := TRUE;

            Rec.Calculation::Divide, Rec.Calculation::Multiply:
                BEGIN
                    "Compute ToVisible" := TRUE;
                    NumberVisible := TRUE;
                END;

            Rec.Calculation::Percent:
                BEGIN
                    "Compute ToVisible" := TRUE;
                    PercentVisible := TRUE;
                END;

            Rec.Calculation::Highest, Rec.Calculation::Lowest:
                BEGIN
                    "Compute ToVisible" := TRUE;
                    "Factor ofVisible" := TRUE;
                END;

            Rec.Calculation::"Look Up":
                BEGIN
                    "Compute ToVisible" := TRUE;
                    LookUpVisible := TRUE;
                END;
        END;

        CASE Rec.Round OF
            Rec.Round::Down, Rec.Round::Up, Rec.Round::Nearest:
                "Round PrecisionVisible" := TRUE;
            ELSE
                "Round PrecisionVisible" := FALSE;
        END;

        CASE Rec.Input OF
            Rec.Input::"Payroll Entry":
                BEGIN
                    "Payroll EntryVisible" := TRUE;
                    "Caculation LineVisible" := FALSE;
                END;

            Rec.Input::"Calculation Line":
                BEGIN
                    "Caculation LineVisible" := TRUE;
                    "Payroll EntryVisible" := FALSE;
                END;

            ELSE BEGIN
                "Payroll EntryVisible" := FALSE;
                "Caculation LineVisible" := FALSE;
            END;
        END;
    end;

    local procedure CalculationOnAfterValidate()
    begin
        ShowCalcFields;
    end;

    local procedure RoundOnAfterValidate()
    begin
        ShowCalcFields;
    end;

    local procedure InputOnAfterValidate()
    begin
        ShowCalcFields;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        ShowCalcFields;
    end;

    local procedure OnActivateForm()
    begin
        ShowCalcFields;
    end;

    local procedure CalculationOnInputChange(var Text: Text[1024])
    begin
        ShowCalcFields;
    end;

    local procedure RoundOnInputChange(var Text: Text[1024])
    begin
        ShowCalcFields;
    end;

    local procedure InputOnInputChange(var Text: Text[1024])
    begin
        ShowCalcFields;
    end;

    procedure gsSegmentPayrollData()
    var
        lvAllowedPayrolls: Record 51182;
        lvPayrollUtilities: Codeunit 51152;
        UsrID: Code[10];
        UsrID2: Code[10];
        StringLen: Integer;
        lvActiveSession: Record 2000000110;
    begin
        /*lvSession.SETRANGE("My Session", TRUE);
        lvSession.FINDFIRST; //fire error in absence of a login
        IF lvSession."Login Type" = lvSession."Login Type"::Database THEN
          lvAllowedPayrolls.SETRANGE("User ID", USERID)
        ELSE*/

        lvActiveSession.RESET;
        lvActiveSession.SETRANGE("Server Instance ID", SERVICEINSTANCEID);
        lvActiveSession.SETRANGE("Session ID", SESSIONID);
        lvActiveSession.FINDFIRST;


        lvAllowedPayrolls.SETRANGE("User ID", lvActiveSession."User ID");
        lvAllowedPayrolls.SETRANGE("Last Active Payroll", TRUE);
        IF lvAllowedPayrolls.FINDFIRST THEN
            Rec.SETRANGE("Payroll Code", lvAllowedPayrolls."Payroll Code")
        ELSE
            ERROR('You are not allowed access to this payroll dataset.');
        Rec.FILTERGROUP(100);
        Pcode := lvAllowedPayrolls."Payroll Code";

    end;
}

