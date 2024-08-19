table 50278 "Board Papes & Minutes"
{

    fields
    {
        field(1; "Entry No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Created by"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(12; Quarter; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'QTR 1,QTR 2,QTR 3,QTR 4';
            OptionMembers = "QTR 1","QTR 2","QTR 3","QTR 4";
        }
        field(13; "Board Committee"; Code[50])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Interview Committee Dep Header" WHERE("field 81" = CONST(3));
        }
        field(14; "Document Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(15; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Minutes,Papers';
            OptionMembers = Minutes,Papers;
        }
        field(16; Date; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Recommendations 1"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Recommendations 2"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Recommendations 3"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        HumanResourcesSetupRec: Record 5218;
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

