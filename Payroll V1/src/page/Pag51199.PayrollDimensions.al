namespace PayrollV.PayrollV;

page 51199 "Payroll Dimensions"
{
    ApplicationArea = All;
    Caption = 'Payroll Dimensions';
    PageType = List;
    SourceTable = "Payroll Dimension";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Dimension Code"; Rec."Dimension Code")
                {
                    ToolTip = 'Specifies the value of the Dimension Code field.', Comment = '%';
                }
                field("Dimension Value Code"; Rec."Dimension Value Code")
                {
                    ToolTip = 'Specifies the value of the Dimension Value Code field.', Comment = '%';
                }
                field("ED Code"; Rec."ED Code")
                {
                    ToolTip = 'Specifies the value of the ED Code field.', Comment = '%';
                }
                field("Employee No"; Rec."Employee No")
                {
                    ToolTip = 'Specifies the value of the Employee No field.', Comment = '%';
                }
                field("Payroll Code"; Rec."Payroll Code")
                {
                    ToolTip = 'Specifies the value of the Payroll Code field.', Comment = '%';
                }
                field("Payroll ID"; Rec."Payroll ID")
                {
                    ToolTip = 'Specifies the value of the Payroll ID field.', Comment = '%';
                }
            }
        }
    }
}
