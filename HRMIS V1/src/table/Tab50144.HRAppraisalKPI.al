table 50144 "HR Appraisal KPI"
{
    Caption = 'HR Appraisal KPI';

    fields
    {
        field(1; "Appraissal Objective"; Code[50])
        {
        }
        field(2; "Activity Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Description; Text[100])
        {
        }
        field(4; "Appraisal Target Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Personal,Job-Specific,Subordinates,Peers,External Sources';
            OptionMembers = " ",Personal,"Job-Specific",Subordinates,Peers,"External Sources";
        }
        field(5; "Actual Output Description"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Appraisal Period"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Calendar Period".Code;
        }
        field(12; "KPI Weight"; Decimal)
        {
            FieldClass = Normal;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                /*TotalKPIWeight:=0;
                HRAppraisalKPI.RESET;
                HRAppraisalKPI.SETRANGE(HRAppraisalKPI."Appraissal Objective","Appraissal Objective");
                IF HRAppraisalKPI.FINDSET THEN BEGIN
                  REPEAT
                    TotalKPIWeight:=TotalKPIWeight+HRAppraisalKPI."KPI Weight";
                  UNTIL HRAppraisalKPI.NEXT=0;
                END;
                MESSAGE(FORMAT(TotalKPIWeight));
                IF TotalKPIWeight > 100 THEN
                  ERROR(Txt_001);*/

            end;
        }
        field(50; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(51; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Global Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(52; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(53; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(54; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(55; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(56; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(57; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          "Dimension Value Type" = CONST(Standard));
        }
    }

    keys
    {
        key(Key1; "Appraissal Objective", "Activity Code", "Appraisal Period")
        {
        }
    }

    fieldgroups
    {
    }

    var
        TotalKPIWeight: Decimal;
        HRAppraisalKPI: Record 50144;
        Txt_001: Label 'The Activity weight should not exceed 100%! Please check';
}

