page 50606 "Employee Appraisal Targets"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50288;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Criteria code"; Rec."Criteria code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Target Code"; Rec."Target Code")
                {
                    ApplicationArea = All;
                }
                field("Performance Targets"; Rec."Performance Targets")
                {
                    ApplicationArea = All;
                }
                field("Targeted Score"; Rec."Targeted Score")
                {
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                }
            }
            part(sbpg; 50610)
            {
                SubPageLink = "Header No" = FIELD("Header No"),
                              "Criteria code" = FIELD("Criteria code"),
                              "Target Code" = FIELD("Target Code");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }
}

