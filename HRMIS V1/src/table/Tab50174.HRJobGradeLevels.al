table 50174 "HR Job Grade Levels"
{

    fields
    {
        field(10; "Job Grade"; Code[30])
        {
            TableRelation = "HR Job Lookup Value".Code WHERE(Option = CONST("Job Grade"));
        }
        field(11; "Job Grade Level"; Code[20])
        {
            TableRelation = "HR Job Lookup Value".Code WHERE(Option = CONST("Job Grade Level"));
        }
        field(12; "Basic Pay Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                JobGradeLevels.RESET;
                JobGradeLevels.SETRANGE("Job Grade", "Job Grade");
                JobGradeLevels.SETRANGE("Job Grade Level", "Job Grade Level");
                JobGradeLevels.SETRANGE(Sequence, Sequence);
                IF JobGradeLevels.FINDFIRST THEN BEGIN
                    LevelSequence := JobGradeLevels.Sequence - 1;
                    JobGradeLevels2.RESET;
                    JobGradeLevels2.SETRANGE("Job Grade", JobGradeLevels."Job Grade");
                    JobGradeLevels2.SETRANGE(Sequence, LevelSequence);
                    IF JobGradeLevels2.FINDFIRST THEN BEGIN
                        "Basic Pay Difference" := JobGradeLevels."Basic Pay Amount" - JobGradeLevels2."Basic Pay Amount";
                    END;
                END;
            end;
        }
        field(13; "Basic Pay Difference"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Allowance Code"; Code[30])
        {
            //  TableRelation = "Hr Appraisal Academic/Prof Qua"."Appraisal Code";
        }
        field(21; "Allowance Description"; Text[100])
        {
            Editable = false;
        }
        field(22; "Allowance Amount"; Decimal)
        {
        }
        field(30; "Allowance Setup"; Boolean)
        {
        }
        field(50; Sequence; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Job Grade", "Job Grade Level")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Job Grade", "Job Grade Level", "Basic Pay Amount")
        {
        }
    }

    var
        Error0001: Label 'The Allowance Code Exists under this Job Grade';
        Error0002: Label 'Job Grade Level exists under this Job Gade';
        JobGradeLevels: Record "HR Job Grade Levels";
        LevelSequence: Integer;
        JobGradeLevels2: Record "HR Job Grade Levels";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

