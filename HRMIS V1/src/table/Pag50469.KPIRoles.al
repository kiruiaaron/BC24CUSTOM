namespace HRMISV.HRMISV;

page 50469 "KPI Roles"
{
    ApplicationArea = All;
    Caption = 'KPI Roles';
    PageType = List;
    SourceTable = "KPI Roles";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
            }
        }
    }
}
