page 50191 "HR Employee Referees"
{
    Caption = 'HR Employee Referees';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50113;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Surname; Rec.Surname)
                {
                    ApplicationArea = All;
                }
                field(Firstname; Rec.Firstname)
                {
                    ApplicationArea = All;
                }
                field(Middlename; Rec.Middlename)
                {
                    ApplicationArea = All;
                }
                field("Mobile No."; Rec."Mobile No.")
                {
                    ApplicationArea = All;
                }
                field("Personal E-Mail Address"; Rec."Personal E-Mail Address")
                {
                    ApplicationArea = All;
                }
                field("Postal Address"; Rec."Postal Address")
                {
                    ApplicationArea = All;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                }
                field("City/Town"; Rec."City/Town")
                {
                    ApplicationArea = All;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("Residential Address"; Rec."Residential Address")
                {
                    ApplicationArea = All;
                }
                field("Referee Category"; Rec."Referee Category")
                {
                    ApplicationArea = All;
                }
                field(Verified; Rec.Verified)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Verify Referee")
            {
                Caption = 'Verify Employee''s Referee';
                Image = ViewCheck;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF CONFIRM(Txt082) = FALSE THEN EXIT;
                    Rec.Verified := TRUE;
                    REC.MODIFY;
                    MESSAGE(Txt083);
                end;
            }
        }
    }

    var
        Txt082: Label 'Are you sure the Referee has been verified?';
        Txt083: Label 'Referee has been verified';
}

