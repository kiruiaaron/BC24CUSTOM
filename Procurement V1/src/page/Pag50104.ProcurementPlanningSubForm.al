page 50104 "Procurement Planning Sub Form"
{
    PageType = ListPart;
    SourceTable = 50064;

    layout
    {
        area(content)
        {
            repeater(Rep1)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Procurement Method"; Rec."Procurement Method")
                {
                    ApplicationArea = All;
                }
                field("Source of Funds"; Rec."Source of Funds")
                {
                    ApplicationArea = All;
                }
                field("Estimated cost"; Rec."Estimated cost")
                {
                    ApplicationArea = All;
                }
                field("Time Process"; Rec."Time Process")
                {
                    ApplicationArea = All;
                }
                field("Invite/Advertise Tender"; Rec."Invite/Advertise Tender")
                {
                    ApplicationArea = All;
                }
                field("Open Tender Date"; Rec."Open Tender Date")
                {
                    ApplicationArea = All;
                }
                field("Evaluate Tender Days"; Rec."Evaluate Tender Days")
                {
                    ApplicationArea = All;
                }
                field("Evaluate Tender Date"; Rec."Evaluate Tender Date")
                {
                    ApplicationArea = All;
                }
                field("Committee Award Approval Days"; Rec."Committee Award Approval Days")
                {
                    ApplicationArea = All;
                }
                field("Committee Award Approval Date"; Rec."Committee Award Approval Date")
                {
                    ApplicationArea = All;
                }
                field("Notification of Award Days"; Rec."Notification of Award Days")
                {
                    ApplicationArea = All;
                }
                field("Notification of Award Date"; Rec."Notification of Award Date")
                {
                    ApplicationArea = All;
                }
                field("Contract Signing Days"; Rec."Contract Signing Days")
                {
                    ApplicationArea = All;
                }
                field("Contract Signing Date"; Rec."Contract Signing Date")
                {
                    ApplicationArea = All;
                }
                field("Total time to Contract sign"; Rec."Total time to Contract sign")
                {
                    ApplicationArea = All;
                }
                field("Time of Completion of Contract"; Rec."Time of Completion of Contract")
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Specification Attributes")
            {
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 50101;
                RunPageLink = "RFQ No." = FIELD("Document No."),
                              Type = FIELD("Type (Attributes)"),
                              Item = FIELD("No.");
                ApplicationArea = All;
            }
        }
    }
}

