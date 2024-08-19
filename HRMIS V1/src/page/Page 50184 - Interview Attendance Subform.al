page 50184 "Interview Attendance Subform"
{
    PageType = ListPart;
    SourceTable = 50109;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Interview No."; Rec."Interview No.")
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
                field(Closed; Rec.Closed)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Employee Email"; Rec."Employee Email")
                {
                    ApplicationArea = All;
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        IF Rec.Closed = TRUE THEN
            CurrPage.EDITABLE(FALSE);
    end;

    trigger OnOpenPage()
    begin
        IF Rec.Closed = TRUE THEN
            CurrPage.EDITABLE(FALSE);
    end;
}

