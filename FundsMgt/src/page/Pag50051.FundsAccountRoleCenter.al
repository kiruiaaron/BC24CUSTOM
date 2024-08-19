page 50051 "Funds Account Role Center"
{
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(activities)
            {
                part(sbpg; 50050)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Banks)
            {
                Image = BankAccount;
                RunObject = Page 371;
                ApplicationArea = All;
            }
        }
    }
}

