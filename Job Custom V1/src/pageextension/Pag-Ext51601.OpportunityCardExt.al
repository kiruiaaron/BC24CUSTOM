pageextension 51601 "Opportunity Card Ext" extends "Opportunity Card"
{
    actions
    {
        addlast("Oppo&rtunity")
        {
            action(CreatBrief)
            {
                Caption = 'Create Briefs';
                Image = OpportunitiesList;
                RunObject = page "Creative Briefs";
                ApplicationArea = RelationshipMgmt;
            }
        }
    }
}
