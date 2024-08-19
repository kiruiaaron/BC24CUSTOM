table 50140 "Departmental Appraisal Lines"
{

    fields
    {
        field(1; "Appraisal No"; Code[30])
        {
            TableRelation = "HR Employee Appraisal Header";
        }
        field(2; "Appraisal Period"; Code[20])
        {
            TableRelation = "HR Calendar Period".Code;
        }
        field(3; "Appraisal Objective"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Appraisal Objective".Code WHERE(Code = FIELD("Appraisal Objective"),
                                                                 "Deparment Code" = CONST());

            trigger OnValidate()
            begin
                "Objective Weight" := 0;
                AppraisalTargetOutputs.RESET;
                AppraisalTargetOutputs.SETRANGE(Code, "Appraisal Objective");
                IF AppraisalTargetOutputs.FINDFIRST THEN
                    "Objective Weight" := AppraisalTargetOutputs."Objective Weight";
            end;
        }
        field(4; "Organization Activity Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Organization Appraisal Lines"."Activity Code" WHERE("Appraisal Period" = FIELD("Appraisal Period"),
                                                                                 "Appraisal Objective" = FIELD("Appraisal Objective"),
                                                                                 "Activity Option" = CONST("Cascade-Down"));

            trigger OnValidate()
            begin
                OrganizationAppraisalLines.RESET;
                OrganizationAppraisalLines.SETRANGE(OrganizationAppraisalLines."Activity Code", "Organization Activity Code");
                OrganizationAppraisalLines.SETRANGE(OrganizationAppraisalLines."Appraisal Objective", "Appraisal Objective");
                IF OrganizationAppraisalLines.FINDFIRST THEN BEGIN
                    "Organization Activity Descrp" := OrganizationAppraisalLines."Activity Description";
                    "Parameter Type" := OrganizationAppraisalLines."Parameter Type";
                END;
            end;
        }
        field(5; "Activity Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Appraisal KPI"."Activity Code" WHERE("Appraissal Objective" = FIELD("Appraisal Objective"));

            trigger OnValidate()
            var
                HRAppraisalKPIRec: Record 50144;
            begin
                //HumanResourcesSetup.GET;
                //"Activity Code":=NoSeriesManagement.GetNextNo(HumanResourcesSetup."Appraisal Activity Code Nos",0D,TRUE);
                HRAppraisalKPIRec.RESET;
                HRAppraisalKPIRec.SETRANGE("Activity Code", "Activity Code");
                IF HRAppraisalKPIRec.FINDFIRST THEN
                    "Activity Description" := HRAppraisalKPIRec.Description;
            end;
        }
        field(6; "Activity Description"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Activity option"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Final-Level,Cascade-Down';
            OptionMembers = " ","Final-Level","Cascade-Down";

            trigger OnValidate()
            begin
                TESTFIELD("Activity option");
            end;
        }
        field(16; "Activity Weight"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TotalActivityWeight := 0;
                EmployeeAppraisalLines.RESET;
                EmployeeAppraisalLines.SETRANGE(EmployeeAppraisalLines."Appraisal No", "Appraisal No");
                EmployeeAppraisalLines.SETRANGE(EmployeeAppraisalLines."Appraisal Objective", "Appraisal Objective");
                IF EmployeeAppraisalLines.FINDSET THEN BEGIN
                    REPEAT
                        TotalActivityWeight := TotalActivityWeight + EmployeeAppraisalLines."Activity Weight";
                    UNTIL EmployeeAppraisalLines.NEXT = 0;
                END;
                TotalActivityWeight := TotalActivityWeight + "Activity Weight" - xRec."Activity Weight";
                IF TotalActivityWeight > 100 THEN
                    ERROR(Txt_001);
            end;
        }
        field(19; "Target Value"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Parameter Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Time-Based,Value Based';
            OptionMembers = " ","Time-Based","Value Based";
        }
        field(21; "Target Output (KPIS)"; Text[150])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(22; "Objective Weight"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Actual Output Description"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Actual Value"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Results := 0;
                IF "Parameter Type" = "Parameter Type"::"Time-Based" THEN BEGIN
                    IF "Actual Value" > 0 THEN
                        Results := "Target Value" / "Actual Value" * 3;

                    IF Results > 1 THEN
                        "Self Assessment Rating" := GetMinimumActualValueandTargetValue(Results, "Global Dimension 1 Code", "Appraisal Objective", "Appraisal Score Type")
                    ELSE
                        "Self Assessment Rating" := 1;
                END ELSE BEGIN
                    Results := "Actual Value" / "Target Value" * 3;

                    IF Results > 1 THEN
                        "Self Assessment Rating" := GetMinimumActualValueandTargetValue(Results, "Global Dimension 1 Code", "Appraisal Objective", "Appraisal Score Type")
                    ELSE
                        "Self Assessment Rating" := 1;
                END;

                "Self Assessment Weighted Rat." := "Activity Weight" / 100 * "Objective Weight" / 100 * "Self Assessment Rating";
            end;
        }
        field(25; "Appraisal Score Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Core,"Non-Core";
        }
        field(30; "Self Assessment Rating"; Decimal)
        {
            Editable = false;
        }
        field(31; "Self Assessment Weighted Rat."; Decimal)
        {
            Caption = 'Self Assessment Weighted Rat.';
            Editable = false;
        }
        field(32; "Actual agreed Value"; Decimal)
        {
            DecimalPlaces = 0 : 0;

            trigger OnValidate()
            begin
                Results := 0;
                IF "Parameter Type" = "Parameter Type"::"Time-Based" THEN BEGIN
                    IF "Actual agreed Value" > 0 THEN
                        Results := "Target Value" / "Actual agreed Value" * 3;

                    IF Results > 1 THEN
                        "Agreed Rating with Supervisor" := GetMinimumActualValueandTargetValue(Results, "Global Dimension 1 Code", "Appraisal Objective", "Appraisal Score Type")
                    ELSE
                        "Agreed Rating with Supervisor" := 1;
                END ELSE BEGIN
                    Results := "Actual agreed Value" / "Target Value" * 3;

                    IF Results > 1 THEN BEGIN
                        "Agreed Rating with Supervisor" := GetMinimumActualValueandTargetValue(Results, "Global Dimension 1 Code", "Appraisal Objective", "Appraisal Score Type");
                        REC.MODIFY;
                    END ELSE BEGIN
                        "Agreed Rating with Supervisor" := 1;
                        REC.MODIFY;
                    END;
                END;
                "Weighted Rat. With Supervisor" := "Activity Weight" / 100 * "Objective Weight" / 100 * "Agreed Rating with Supervisor";
            end;
        }
        field(33; "Agreed Rating with Supervisor"; Decimal)
        {
            Caption = 'Agreed Rating with Supervisor';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(34; "Weighted Rat. With Supervisor"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(35; "Moderated Value"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Results := 0;
                IF "Parameter Type" = "Parameter Type"::"Time-Based" THEN BEGIN
                    IF "Moderated Value" > 0 THEN
                        Results := "Target Value" / "Moderated Value" * 3;

                    IF Results > 1 THEN
                        "Moderated Assessment Rating" := GetMinimumActualValueandTargetValue(Results, "Global Dimension 1 Code", "Appraisal Objective", "Appraisal Score Type")
                    ELSE
                        "Moderated Assessment Rating" := 1;
                END ELSE BEGIN
                    Results := "Moderated Value" / "Target Value" * 3;

                    IF Results > 1 THEN
                        "Moderated Assessment Rating" := GetMinimumActualValueandTargetValue(Results, "Global Dimension 1 Code", "Appraisal Objective", "Appraisal Score Type")
                    ELSE
                        "Moderated Assessment Rating" := 1;
                END;
                "Weighted Rat. Moderated Value" := "Activity Weight" / 100 * "Objective Weight" / 100 * "Moderated Assessment Rating";
            end;
        }
        field(36; "Moderated Assessment Rating"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(37; "Weighted Rat. Moderated Value"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(38; "Base Unit of Measure"; Code[20])
        {
            Caption = 'Base Unit of Measure';
            DataClassification = ToBeClassified;
            TableRelation = "HR Lookup Values".Code WHERE(Option = CONST("Unit of Measure"));
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                UnitOfMeasure: Record 204;
            begin
            end;
        }
        field(40; "Organization Activity Descrp"; Text[150])
        {
            Caption = 'Organization Activity Description';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(48; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(51; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard));
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
        key(Key1; "Appraisal No", "Appraisal Objective", "Organization Activity Code", "Activity Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Appraisal Objective", "Organization Activity Code", "Activity Code", "Activity Description")
        {
        }
    }

    trigger OnInsert()
    begin
        AppraisalHeader.RESET;
        AppraisalHeader.SETRANGE("No.", "Appraisal No");
        IF AppraisalHeader.FINDFIRST THEN BEGIN
            "Global Dimension 1 Code" := AppraisalHeader."Global Dimension 1 Code";
            "Global Dimension 2 Code" := AppraisalHeader."Global Dimension 2 Code";
            "Shortcut Dimension 3 Code" := AppraisalHeader."Shortcut Dimension 3 Code";
            "Shortcut Dimension 4 Code" := AppraisalHeader."Shortcut Dimension 4 Code";
            "Shortcut Dimension 5 Code" := AppraisalHeader."Shortcut Dimension 5 Code";
            "Shortcut Dimension 6 Code" := AppraisalHeader."Shortcut Dimension 6 Code";
        END;
    end;

    var
        AppraisalCodes: Record 50144;
        AppraisalHeader: Record 50138;
        AppraisalTargetOutputs: Record 50147;
        EmployeeAppraisalLines: Record 50140;
        Results: Decimal;
        TotalActivityWeight: Decimal;
        Txt_001: Label 'The Activity weight should not exceed 100%! Please check';
        OrganizationAppraisalLines: Record 50139;
        HumanResourcesSetup: Record 5218;
        NoSeriesManagement: Codeunit NoSeriesManagement;

    procedure maxRating() maxRating: Decimal
    begin
    end;

    procedure GetMinimumActualValueandTargetValue(Results: Decimal; DepartmentCode: Code[20]; ObjectiveCode: Code[20]; Type: Option " ",Core,"Non-Core") MinimumValue: Decimal
    var
        HumanResourcesSetup: Record 5218;
        HRAppraisalObjective: Record 50147;
    begin
        HumanResourcesSetup.GET;
        IF Type = Type::Core THEN BEGIN
            IF Results < HumanResourcesSetup."Appraisal Max score (Core)" THEN
                MinimumValue := Results
            ELSE
                MinimumValue := HumanResourcesSetup."Appraisal Max score (Core)";
        END ELSE BEGIN
            IF Type = Type::"Non-Core" THEN BEGIN
                IF Results < HumanResourcesSetup."Appraisal Max Score(None Core)" THEN
                    MinimumValue := Results
                ELSE
                    MinimumValue := HumanResourcesSetup."Appraisal Max Score(None Core)";
            END;
        END;
    end;

    [Scope('Cloud')]
    procedure AssistEdit(): Boolean
    begin
        HumanResourcesSetup.GET;
        HumanResourcesSetup.TESTFIELD("Employee Nos.");
        IF NoSeriesManagement.SelectSeries(HumanResourcesSetup."Appraisal Activity Code Nos", xRec."No. Series", "No. Series") THEN BEGIN
            NoSeriesManagement.SetSeries("Activity Code");
            EXIT(TRUE);
        END;
    end;
}

