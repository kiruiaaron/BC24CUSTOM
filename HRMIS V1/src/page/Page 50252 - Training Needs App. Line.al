page 50252 "Training Needs App. Line"
{
    PageType = ListPart;
    SourceTable = 50158;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Development Needs"; Rec."Development Needs")
                {
                    ApplicationArea = All;
                }
                field("Intervention Required"; Rec."Intervention Required")
                {
                    ApplicationArea = All;
                }
                field(Objectives; Rec.Objectives)
                {
                    ApplicationArea = All;
                }
                field("Proposed Training Provider"; Rec."Proposed Training Provider")
                {
                    ApplicationArea = All;

                }
                field("Training Location & Venue"; Rec."Training Location & Venue")
                {
                    ApplicationArea = All;
                }
                field("Calendar Year"; Rec."Calendar Year")
                {
                    ApplicationArea = All;
                }
                field("Proposed Period"; Rec."Proposed Period")
                {
                    ApplicationArea = All;
                }
                field("Training Scheduled Date"; Rec."Training Scheduled Date")
                {
                    ApplicationArea = All;
                }
                field("Training Scheduled Date To"; Rec."Training Scheduled Date To")
                {
                    ApplicationArea = All;
                }
                field("Estimated Cost"; Rec."Estimated Cost")
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
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

