page 50055 "Cheque Register List"
{
    CardPageID = "Cheque Register Card";
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50024;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Bank Account"; Rec."Bank Account")
                {
                    ApplicationArea = All;
                }
                field("Bank Account Name"; Rec."Bank Account Name")
                {
                    ApplicationArea = All;
                }
                field("Last Cheque No."; Rec."Last Cheque No.")
                {
                    ApplicationArea = All;
                }
                field("Cheque Book Number"; Rec."Cheque Book Number")
                {
                    ApplicationArea = All;
                }
                field("No of Leaves"; Rec."No of Leaves")
                {
                    ApplicationArea = All;
                }
                field("Cheque Number From"; Rec."Cheque Number From")
                {
                    ApplicationArea = All;
                }
                field("Cheque Number To."; Rec."Cheque Number To.")
                {
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
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

