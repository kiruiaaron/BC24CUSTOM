table 50248 "Compensation Group Lines"
{

    fields
    {
        field(1; "Group code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Compensation Groups"."Group Code";
        }
        field(2; "ED code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "ED Definitions";

            trigger OnValidate()
            begin
                EDDefinitions.GET("ED code");
                "ED Definition" := EDDefinitions.Description;
            end;
        }
        field(3; "ED Definition"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Group code", "ED code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        EDDefinitions: Record 51158;
}

