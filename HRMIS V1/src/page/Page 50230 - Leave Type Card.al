page 50230 "Leave Type Card"
{
    PageType = Card;
    SourceTable = 50134;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Rec.Code)
                {
                    ToolTip = 'Code';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the description.';
                    ApplicationArea = All;
                }
                field(Gender; Rec.Gender)
                {
                    ToolTip = 'Specifies the Gender.';
                    ApplicationArea = All;
                }
                field(Days; Rec.Days)
                {
                    ToolTip = 'Specifies the Days.';
                    ApplicationArea = All;
                }
                field("Leave Year"; Rec."Leave Year")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Annual Leave"; Rec."Annual Leave")
                {
                    ToolTip = 'Specifies the Annual Leave.';
                    ApplicationArea = All;
                }
                field("Leave Plan Mandatory"; Rec."Leave Plan Mandatory")
                {
                    ToolTip = 'Specifies the Leave Plan.';
                    ApplicationArea = All;
                }
                field("Base Calendar"; Rec."Base Calendar")
                {
                    ToolTip = 'Specifies the Leave Base Calendar.';
                    ApplicationArea = All;
                }
                field("Inclusive of Non Working Days"; Rec."Inclusive of Non Working Days")
                {
                    ToolTip = 'Specifies the Inclusive of Non Working Days.';
                    ApplicationArea = All;
                }
            }
            group("Leave Balance")
            {
                field(Balance; Rec.Balance)
                {
                    ToolTip = 'Specifies the Balance.';
                    ApplicationArea = All;
                }
                field("Max Carry Forward Days"; Rec."Max Carry Forward Days")
                {
                    ToolTip = 'Specifies the Max Carry Forward Days.';
                    ApplicationArea = All;
                }
                field("Amount Per Day"; Rec."Amount Per Day")
                {
                    ToolTip = 'Specifies the Amount per Day.';
                    ApplicationArea = All;
                }
                field("Allow Negative Days"; Rec."Allow Negative Days")
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

