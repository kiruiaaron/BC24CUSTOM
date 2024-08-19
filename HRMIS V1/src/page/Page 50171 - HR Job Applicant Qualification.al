page 50171 "HR Job Applicant Qualification"
{
    Caption = 'Job Applicant Academic Qualifications';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50167;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Qualification Code"; Rec."Qualification Code")
                {
                    ToolTip = 'Specifies Qualification Code.';
                    ApplicationArea = All;
                }
                field("Qualification Name"; Rec."Qualification Name")
                {
                    ToolTip = 'Specifies the  description.';
                    ApplicationArea = All;
                }
                field("Document Attached"; Rec."Document Attached")
                {
                    ToolTip = 'Specifies the  document attached.';
                    ApplicationArea = All;
                }
                field("Joining Date"; Rec."Joining Date")
                {
                    ApplicationArea = All;
                }
                field("Completion Date"; Rec."Completion Date")
                {
                    ApplicationArea = All;
                }
                field(Award; Rec.Award)
                {
                    ApplicationArea = All;
                }
                field("Award Date"; Rec."Award Date")
                {
                    ApplicationArea = All;
                }
                field("Institution Name"; Rec."Institution Name")
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

