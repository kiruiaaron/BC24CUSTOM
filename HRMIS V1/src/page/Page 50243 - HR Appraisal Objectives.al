page 50243 "HR Appraisal Objectives"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50147;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Objective Weight"; Rec."Objective Weight")
                {
                    ApplicationArea = All;
                }
                field("Appraisal Period"; Rec."Appraisal Period")
                {
                    ApplicationArea = All;
                }
                field("Deparment Code"; Rec."Deparment Code")
                {
                    ApplicationArea = All;
                }
                field("Appraisal Score Type"; Rec."Appraisal Score Type")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Objective Activities")
            {
                Caption = 'Objective KPI';
                Image = Allocate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 50241;
                RunPageLink = "Appraisal Period" = FIELD("Appraisal Period"),
                              "Appraissal Objective" = FIELD(Code);
                ApplicationArea = All;
            }
        }
    }
}

