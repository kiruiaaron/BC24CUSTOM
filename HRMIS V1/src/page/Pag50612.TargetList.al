page 50612 "Target List"
{
    CardPageID = "Targets  Card";
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50281;
    SourceTableView = WHERE("Appraisal Stage" = CONST(Organization));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Organization';
                    ApplicationArea = All;
                }
                field("Appraisal Period"; Rec."Appraisal Period")
                {
                    Caption = 'Target period';
                    ApplicationArea = All;
                }
                field("Job Grade"; Rec."Job Grade")
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field("Evaluation Period Start"; Rec."Evaluation Period Start")
                {
                    Caption = 'Target Start Period';
                    ApplicationArea = All;
                }
                field("Evaluation Period End"; Rec."Evaluation Period End")
                {
                    Caption = 'Target End Period';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

