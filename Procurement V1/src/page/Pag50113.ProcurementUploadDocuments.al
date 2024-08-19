page 50113 "Procurement Upload Documents"
{
    PageType = ListPart;
    SourceTable = 50066;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Document Code"; Rec."Document Code")
                {
                    ApplicationArea = All;
                }
                field("Document Description"; Rec."Document Description")
                {
                    ApplicationArea = All;
                }
                field("Document Mandatory"; Rec."Document Mandatory")
                {
                    ApplicationArea = All;
                }
                field("Tender Stage"; Rec."Tender Stage")
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

