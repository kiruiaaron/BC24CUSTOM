page 51626 "Contract Type Prices"
{
    PageType = List;
    SourceTable = "Purchase Price";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                    Caption = 'Contract Type';
                }
                field("Project Code"; Rec."Project Code")
                {
                }
                field("Project Name"; Rec."Project Name")
                {
                }
                field("Task No"; Rec."Task No")
                {
                }
                field("Task Description"; Rec."Task Description")
                {
                }
                field("Quoted Daily Rate"; Rec."Quoted Daily Rate")
                {
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                }
                field("Currency Code"; Rec."Currency Code")
                {
                }
                field("Starting Date"; Rec."Starting Date")
                {
                }
                field("Ending Date"; Rec."Ending Date")
                {
                }
                field("Minimum Quantity"; Rec."Minimum Quantity")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Contract := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Contract := true;
    end;
}

