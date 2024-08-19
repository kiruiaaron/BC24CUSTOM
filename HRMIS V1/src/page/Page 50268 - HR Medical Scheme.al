page 50268 "HR Medical Scheme"
{
    CardPageID = "HR Medical Scheme Card";
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50154;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Medical Scheme Description"; Rec."Medical Scheme Description")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field(Provider; Rec.Provider)
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Provider Name"; Rec."Provider Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

