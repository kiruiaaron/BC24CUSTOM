page 50192 "HR Employees Prof Body"
{
    Caption = 'HR Employee Professional  Body Membership';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50123;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Professional Body Name"; Rec."Professional Body Name")
                {
                    ApplicationArea = All;
                }
                field("Membership No."; Rec."Membership No.")
                {
                    ApplicationArea = All;
                }
                field("Practising Cert/License No"; Rec."Practising Cert/License No")
                {
                    ApplicationArea = All;
                }
                field("Expiry Date"; Rec."Expiry Date")
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

