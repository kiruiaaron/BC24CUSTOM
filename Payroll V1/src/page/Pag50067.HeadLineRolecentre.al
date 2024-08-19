namespace StdERP.StdERP;
using System.Visualization;

page 50067 "HeadLine Rolecentre"
{
    ApplicationArea = All;
    Caption = 'HeadLine Rolecentre';
    PageType = HeadlinePart;

    layout
    {
        area(Content)
        {

            group(General)
            {
                ShowCaption = false;
                Visible = UserGreetingVisible;
                field(GreetingText; RCHeadlinesPageCommon.GetGreetingText())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Greeting headline';
                    Editable = false;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        RCHeadlinesPageCommon.HeadlineOnOpenPage(Page::"Headline RC Business Manager");
        DefaultFieldsVisible := RCHeadlinesPageCommon.AreDefaultFieldsVisible();
        UserGreetingVisible := RCHeadlinesPageCommon.IsUserGreetingVisible();
    end;

    var
        RCHeadlinesPageCommon: Codeunit "RC Headlines Page Common";

    var
        WelcomeLbl: Label 'Welcome %1';
        BusinessCentralIsAwesomeLbl: Label '<qualifier>Microsoft Learn</qualifier><payload>Headlines in <emphasize>Business Central</emphasize> are awesome!</payload>';
        Welcome: Text;
        [InDataSet]
        DefaultFieldsVisible: Boolean;
        [InDataSet]
        UserGreetingVisible: Boolean;
}
