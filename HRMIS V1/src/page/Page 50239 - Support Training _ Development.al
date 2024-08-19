page 50239 "Support Training & Development"
{
    PageType = ListPart;
    SourceTable = 50143;

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
                field("Appraisal No."; Rec."Appraisal No.")
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
                field("Area of Development"; Rec."Area of Development")
                {
                    ApplicationArea = All;
                }
                field("Agreed Improv Action plan"; Rec."Agreed Improv Action plan")
                {
                    ApplicationArea = All;
                }
                field(Resposibility; Rec.Resposibility)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Appraisal Period"; Rec."Appraisal Period")
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

