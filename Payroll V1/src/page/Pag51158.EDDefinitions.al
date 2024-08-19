page 51158 "ED Definitions"
{
    PageType = Card;
    SourceTable = 51158;

    layout
    {
        area(content)
        {
            repeater(r)
            {
                field("ED Code"; Rec."ED Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Payroll Code"; Rec."Payroll Code")
                {
                    ApplicationArea = All;
                }
            }
            group(Group)
            {
                field("Payroll Text"; Rec."Payroll Text")
                {
                    Caption = 'Payslip Text';
                    ApplicationArea = All;
                }
                field(Cumulative; Rec.Cumulative)
                {
                    ApplicationArea = All;
                }
                field("Rounding ED"; Rec."Rounding ED")
                {
                    ApplicationArea = All;
                }
                field("Copy to next"; Rec."Copy to next")
                {
                    Caption = 'Copy to next Period';
                    ApplicationArea = All;
                }
                field("Reset Amount"; Rec."Reset Amount")
                {
                    Caption = 'Reset Amount';
                    ApplicationArea = All;
                }
                field("System Created"; Rec."System Created")
                {
                    ApplicationArea = All;
                }
                field("Sum Payroll Entries"; Rec."Sum Payroll Entries")
                {
                    ApplicationArea = All;
                }
                field("Overtime ED"; Rec."Overtime ED")
                {
                    Visible = true;
                    ApplicationArea = All;
                }
                field("Overtime ED Weight"; Rec."Overtime ED Weight")
                {
                    Visible = true;
                    ApplicationArea = All;
                }
                field(Priority; Rec.Priority)
                {
                    ToolTip = 'Useful in case of Negative Net Pay - 0 = Undefined, 1 = Highest, 2 = Second Highest';
                    ApplicationArea = All;
                }
                field("Membership No. Name"; Rec."Membership No. Name")
                {
                    ApplicationArea = All;
                }
                field("Calculation Group"; Rec."Calculation Group")
                {
                    ApplicationArea = All;
                }
                field("Posting type"; Rec."Posting type")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        PostingtypeOnAfterValidate;
                    end;
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = All;
                }
                field("ED Posting Group"; Rec."ED Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Debit/Credit"; Rec."Debit/Credit")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Special Allowance"; Rec."Special Allowance")
                {
                    ApplicationArea = All;
                }
                field("Special Payment"; Rec."Special Payment")
                {
                    ApplicationArea = All;
                }
                field(Absence; Rec.Absence)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(ED)
            {
                Caption = 'ED';
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(39012009),
                                  "No." = FIELD("ED Code");
                    ShortCutKey = 'Shift+Ctrl+D';
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        "Debit/CreditVisible" := TRUE;
        "Global Dimension 2 CodeVisible" := TRUE;
        "Global Dimension 1 CodeVisible" := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        //OnActivateForm;
    end;

    var
        [InDataSet]
        "ED Posting GroupVisible": Boolean;
        [InDataSet]
        "Account NoVisible": Boolean;
        [InDataSet]
        "Global Dimension 1 CodeVisible": Boolean;
        [InDataSet]
        "Global Dimension 2 CodeVisible": Boolean;
        [InDataSet]
        "Debit/CreditVisible": Boolean;

    procedure ShowFields()
    begin


        "ED Posting GroupVisible" := FALSE;
        "Account NoVisible" := FALSE;
        "Global Dimension 1 CodeVisible" := FALSE;
        "Global Dimension 2 CodeVisible" := FALSE;
        "Debit/CreditVisible" := FALSE;

        CASE Rec."Posting type" OF
            Rec."Posting type"::"G/L Account":
                "ED Posting GroupVisible" := TRUE;
            Rec."Posting type"::Direct:
                BEGIN
                    "Account NoVisible" := TRUE;
                    "Global Dimension 1 CodeVisible" := TRUE;
                    "Global Dimension 2 CodeVisible" := TRUE;
                    "Debit/CreditVisible" := TRUE;
                END;
            Rec."Posting type"::Customer:
                BEGIN
                    "Account NoVisible" := TRUE;
                    "Global Dimension 1 CodeVisible" := TRUE;
                    "Global Dimension 2 CodeVisible" := TRUE;
                    "Debit/CreditVisible" := TRUE;
                END;
            Rec."Posting type"::Vendor:
                BEGIN
                    "Account NoVisible" := TRUE;
                    "Global Dimension 1 CodeVisible" := TRUE;
                    "Global Dimension 2 CodeVisible" := TRUE;
                    "Debit/CreditVisible" := TRUE;
                END;
        END;
    end;

    local procedure PostingtypeOnAfterValidate()
    begin
        ShowFields;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        ShowFields;
    end;

    local procedure OnActivateForm()
    begin
        ShowFields;
    end;

    local procedure PostingtypeOnInputChange(var Text: Text[1024])
    begin
        ShowFields;
    end;
}

