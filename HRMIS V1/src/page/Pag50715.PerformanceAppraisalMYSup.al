page 50715 "Performance Appraisal-MY Sup"
{
    Caption = 'Performance Appraisal-MY Supervisor';
    CardPageID = "Appraisal Card-MY Sup";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50281;
    SourceTableView = WHERE("Appraisal Stage" = CONST("Mid Year Evaluation Sup"));

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
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Appraisal Period"; Rec."Appraisal Period")
                {
                    Caption = 'Contract period';
                    ApplicationArea = All;
                }
                field("Job Grade"; Rec."Job Grade")
                {
                    ApplicationArea = All;
                }
                field(Designation; Rec.Designation)
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field("Evaluation Period Start"; Rec."Evaluation Period Start")
                {
                    Caption = 'Contract Start Period';
                    ApplicationArea = All;
                }
                field("Evaluation Period End"; Rec."Evaluation Period End")
                {
                    Caption = 'Contract End Period';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

