page 51165 "Lookup Table Lines"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 51163;

    layout
    {
        area(content)
        {
            repeater(r)
            {
                field("Table ID"; Rec."Table ID")
                {
                    ApplicationArea = All;
                }
                field("Lower Amount (LCY)"; Rec."Lower Amount (LCY)")
                {
                    Visible = "Lower Amount (LCY)Visible";
                    ApplicationArea = All;
                }
                field("Upper Amount (LCY)"; Rec."Upper Amount (LCY)")
                {
                    Visible = "Upper Amount (LCY)Visible";
                    ApplicationArea = All;
                }
                field(Month; Rec.Month)
                {
                    Visible = MonthVisible;
                    ApplicationArea = All;
                }
                field("Extract Amount (LCY)"; Rec."Extract Amount (LCY)")
                {
                    Visible = "Extract Amount (LCY)Visible";
                    ApplicationArea = All;
                }
                field(Percent; Rec.Percent)
                {
                    Visible = PercentVisible;
                    ApplicationArea = All;
                }
                field(Deduct; Rec."Relief Amount")
                {
                    Caption = 'Deduct';
                    ApplicationArea = All;
                }
                field("Cumulate (LCY)"; Rec."Cumulate (LCY)")
                {
                    Visible = "Cumulate (LCY)Visible";
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnClosePage()
    begin
        UpdatePercent;
    end;

    trigger OnInit()
    begin
        "Cumulate (LCY)Visible" := TRUE;
        "Upper Amount (LCY)Visible" := TRUE;
        PercentVisible := TRUE;
        "Extract Amount (LCY)Visible" := TRUE;
        "Lower Amount (LCY)Visible" := TRUE;
        MonthVisible := TRUE;
    end;

    trigger OnOpenPage()
    begin
        LookUpHeader.GET(Rec."Table ID");
        CASE LookUpHeader.Type OF
            LookUpHeader.Type::Percentage:
                BEGIN
                    MonthVisible := FALSE;
                    "Lower Amount (LCY)Visible" := TRUE;
                    "Extract Amount (LCY)Visible" := FALSE;
                    PercentVisible := TRUE;
                    "Upper Amount (LCY)Visible" := TRUE;
                    "Cumulate (LCY)Visible" := TRUE;
                END;
            LookUpHeader.Type::"Extract Amount":
                BEGIN
                    "Lower Amount (LCY)Visible" := TRUE;
                    MonthVisible := FALSE;
                    "Extract Amount (LCY)Visible" := TRUE;
                    PercentVisible := FALSE;
                    "Upper Amount (LCY)Visible" := TRUE;
                    "Cumulate (LCY)Visible" := FALSE;
                END;
            LookUpHeader.Type::Month:
                BEGIN
                    "Lower Amount (LCY)Visible" := FALSE;
                    "Extract Amount (LCY)Visible" := TRUE;
                    MonthVisible := TRUE;
                    PercentVisible := FALSE;
                    "Upper Amount (LCY)Visible" := FALSE;
                    "Cumulate (LCY)Visible" := FALSE;

                END;
        END;
    end;

    var
        LookUpHeader: Record 51162;
        [InDataSet]
        MonthVisible: Boolean;
        [InDataSet]
        "Lower Amount (LCY)Visible": Boolean;
        [InDataSet]
        "Extract Amount (LCY)Visible": Boolean;
        [InDataSet]
        PercentVisible: Boolean;
        [InDataSet]
        "Upper Amount (LCY)Visible": Boolean;
        [InDataSet]
        "Cumulate (LCY)Visible": Boolean;

    procedure UpdatePercent()
    begin
        LookUpHeader.GET(Rec."Table ID");
        IF LookUpHeader.Type = LookUpHeader.Type::Percentage THEN BEGIN
            Rec.SETRANGE("Table ID", LookUpHeader."Table ID");
            Rec.FIND('-');
            REPEAT
                Rec.VALIDATE(Percent);
                Rec.MODIFY;
            UNTIL Rec.NEXT = 0;
        END;
    end;
}

