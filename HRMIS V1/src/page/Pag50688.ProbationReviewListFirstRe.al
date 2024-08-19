page 50688 "Probation Review List-First Re"
{
    Caption = 'Probation Review List-First Review';
    CardPageID = "Probation Review Card-First Re";
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50328;
    SourceTableView = WHERE("Review Stage" = FILTER("3-Month Review"));

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
                field("Document Date"; Rec."Document Date")
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
                field(Grade; Rec.Grade)
                {
                    ApplicationArea = All;
                }
                field("Department/Section"; Rec."Department/Section")
                {
                    ApplicationArea = All;
                }
                field("Department Name"; Rec."Department Name")
                {
                    ApplicationArea = All;
                }
                field("Post Start Date"; Rec."Post Start Date")
                {
                    ApplicationArea = All;
                }
                field("Line Manager"; Rec."Line Manager")
                {
                    ApplicationArea = All;
                }
                field("Line Manager Name"; Rec."Line Manager Name")
                {
                    ApplicationArea = All;
                }
                field("Review Stage"; Rec."Review Stage")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}

