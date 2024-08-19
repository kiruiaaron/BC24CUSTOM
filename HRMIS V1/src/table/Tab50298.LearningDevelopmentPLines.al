table 50298 "Learning & Development P Lines"
{

    fields
    {
        field(1; "Header code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Learning & Development Plan";
        }
        field(2; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Training Title"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Target Group"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Department; Code[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "1st Quarter"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "2nd Quarter"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "3rd Quarter"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "4th Quarter"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Training Facilitator Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'In House,External';
            OptionMembers = "In House",External;
        }
        field(11; "Training Facilitator"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Priority Level"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Critical,Professional Development,Moderate';
            OptionMembers = " ",Critical,"Professional Development",Moderate;
        }
        field(13; Objectives; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Training Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Skills Improvement,Professional Development,Other Developments';
            OptionMembers = "Skills Improvement","Professional Development","Other Developments";
        }
        field(50; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                DimensionValue.RESET;
                DimensionValue.SETRANGE(Code, "Global Dimension 1 Code");
                IF DimensionValue.FINDFIRST THEN
                    Department := DimensionValue.Name;
            end;
        }
        field(51; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Not Achieved,Achieved';
            OptionMembers = " ","Not Achieved",Achieved;
        }
        field(52; Remarks; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(53; "Training Need No."; Code[20])
        {
            Caption = 'Approved Training Need No.';
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = "HR Training Needs Header"."No." WHERE(Status = CONST(Approved));
        }
    }

    keys
    {
        key(Key1; "Header code", "Line No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        DimensionValue: Record 349;
}

