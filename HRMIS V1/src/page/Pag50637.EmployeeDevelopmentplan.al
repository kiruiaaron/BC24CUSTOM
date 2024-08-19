page 50637 "Employee Development plan"
{
    PageType = Card;
    SourceTable = 50299;

    layout
    {
        area(content)
        {
            group(General)
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
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field(Station; Rec.Station)
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
                field(Section; Rec.Section)
                {
                    ApplicationArea = All;
                }
            }
            part(sbpg; 50639)
            {
                SubPageLink = "Plan No" = FIELD("No.");
                ApplicationArea = All;
            }
            part("My Goals"; 50635)
            {
                Caption = 'My Goals';
                SubPageLink = "Plan No" = FIELD("No.");
                ApplicationArea = All;
            }
            part(Challenges; 50636)
            {
                Caption = 'Challenges';
                SubPageLink = "Plan No" = FIELD("No.");
                ApplicationArea = All;
            }
            part(" Support"; 50640)
            {
                Caption = ' Support';
                SubPageLink = "Plan No" = FIELD("No.");
                ApplicationArea = All;
            }
            group("Remarks & Progress")
            {
                field("Employee Remarks"; Rec."Employee Remarks")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Supervisor Remarks"; Rec."Supervisor Remarks")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field(Progress; Rec.Progress)
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

