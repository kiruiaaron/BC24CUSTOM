page 50203 "Employee Location List"
{
    DataCaptionFields = "Code", Description;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50117;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    Caption = 'Code';
                    ApplicationArea = All;
                }
                field("<Description>"; Rec.Description)
                {
                    Caption = 'Description';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

