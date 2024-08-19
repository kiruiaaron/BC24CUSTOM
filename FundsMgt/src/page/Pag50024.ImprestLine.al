page 50024 "Imprest Line"
{
    PageType = ListPart;
    SourceTable = 50009;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Imprest Code"; Rec."Imprest Code")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec."From City" := '';
                        Rec."To City" := '';

                        CityCodes.RESET;
                        CityCodes.SETRANGE(CityCodes."Cluster Code", Rec.City);
                        IF CityCodes.FINDFIRST THEN BEGIN
                            AllowanceMatrix.RESET;
                            AllowanceMatrix.SETRANGE(AllowanceMatrix."Job Group", Rec."HR Job Grade");
                            AllowanceMatrix.SETRANGE(AllowanceMatrix."Allowance Code", Rec."Imprest Code");
                            AllowanceMatrix.SETRANGE(AllowanceMatrix."Cluster Code", CityCodes."Cluster Code");
                            IF AllowanceMatrix.FINDFIRST THEN BEGIN
                                Rec."Gross Amount" := AllowanceMatrix.Amount;
                                Rec."Gross Amount(LCY)" := Rec."Gross Amount";
                            END;
                        END;
                    end;
                }
                field("HR Job Grade"; Rec."HR Job Grade")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Unit Amount"; Rec."Unit Amount")
                {
                    ApplicationArea = All;
                }
                field("Gross Amount"; Rec."Gross Amount")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Tax Amount"; Rec."Tax Amount")
                {
                    ApplicationArea = All;
                }
                field("Net Amount"; Rec."Net Amount")
                {
                    ApplicationArea = All;
                }
                field("Gross Amount(LCY)"; Rec."Gross Amount(LCY)")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the field name';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    var
        AllowanceMatrix: Record 50032;
        FromToEditable: Boolean;
        CityEditable: Boolean;
        CityCodes: Record "Cluster Codes";
        ImprestLine: Record 50009;
        Error001: Label 'Destination Town is Similar to Depature Town';
        Error002: Label 'Imprest exist on this activity day';
}

