page 51602 "Converted Brand Ambassadors"
{
    CardPageID = "Brand Ambassador Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Resource;
    SourceTableView = WHERE("Resource Type" = FILTER("Brand Ambassador"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field(Gender; Rec.Gender)
                {
                }
                field("Region Code"; Rec."Region Code")
                {
                }
                field("Region Name"; Rec."Region Name")
                {
                }
                field("Phone Number"; Rec."Phone Number")
                {
                }
                field("Id Number"; Rec."Id Number")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin

    end;


    var
        Employee: Record Employee;
}

