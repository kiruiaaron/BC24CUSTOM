page 50550 "Appraisal Targets"
{
    Caption = 'Performance Activities';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50288;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Criteria code"; Rec."Criteria code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Target Code"; Rec."Target Code")
                {
                    ApplicationArea = All;
                }
                field("Performance Targets"; Rec."Performance Targets")
                {
                    ApplicationArea = All;
                }
                field("Targeted Score"; Rec."Targeted Score")
                {
                    ApplicationArea = All;
                }
            }
            part("Appraisal Performance Standards"; 50548)
            {
                Caption = 'Appraisal Performance Standards';
                SubPageLink = "Header No" = FIELD("Header No"),
                              "Criteria code" = FIELD("Criteria code"),
                              "Target Code" = FIELD("Target Code");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Target Notes")
            {
                Image = OpportunitiesList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 50549;
                RunPageLink = "Header No" = FIELD("Header No");/* ,
                              "Criteria code" = FIELD("Criteria code"),
                              "Target Code" = FIELD("Target Code"); */
                ApplicationArea = All;
            }
            action(ImportGoals)
            {
                Caption = 'Import Activities';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    /*    CLEAR(ImportAppraisalActivities);
                       ImportAppraisalActivities.SetKPICode("Header No", "Criteria code");
                       ImportAppraisalActivities.RUN; */
                end;
            }
            action(ImportStandard)
            {
                Caption = 'Import Standards';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    /*  CLEAR(ImportAppraisalStandards);
                     ImportAppraisalStandards.SetKPICode("Header No", "Criteria code");
                     ImportAppraisalStandards.RUN; */
                end;
            }
        }
    }

    var
        HeaderNoCopy: Code[10];
        KpiCodeCopy: Integer;
        CriteriaCodeCopy: Integer;
    /* AppraisalGoalsImportImpExp: XMLport 50060;
    ImportAppraisalActivities: XMLport 50063;
    ImportAppraisalStandards: XMLport 50064; */
}

