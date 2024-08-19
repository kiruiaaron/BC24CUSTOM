page 50202 "Employee Department List"
{
    DataCaptionFields = "Code", Decription;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50118;

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
                field("<Description>"; Rec.Decription)
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

