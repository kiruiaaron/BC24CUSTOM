namespace HRMISV.HRMISV;

page 50363 "Area of Grievance"
{
    ApplicationArea = All;
    Caption = 'Area of Grievance';
    PageType = List;
    SourceTable = "Areas of Grieavance";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Grievance Code"; Rec."Grievance Code")
                {
                    ApplicationArea = All;
                }
                field("Grievance Description"; Rec."Grievance Description")
                {
                    ApplicationArea = All;
                }


            }
        }
    }
}
