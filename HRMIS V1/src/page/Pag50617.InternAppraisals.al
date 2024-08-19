page 50617 "Intern Appraisals"
{
    CardPageID = "Intern Appraisal Card";
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50281;
    SourceTableView = WHERE("Appraisal Stage" = FILTER(Internship));

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
                    Caption = 'Intern No';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Caption = 'Intern Name';
                    ApplicationArea = All;
                }
                field("Appraisal Period"; Rec."Appraisal Period")
                {
                    Caption = 'Appraisal period';
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
                    Caption = 'Appraisal Start Period';
                    ApplicationArea = All;
                }
                field("Evaluation Period End"; Rec."Evaluation Period End")
                {
                    Caption = 'Appraisal End Period';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

