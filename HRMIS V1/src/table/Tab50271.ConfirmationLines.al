table 50271 "Confirmation Lines"
{

    fields
    {
        field(1; "Confirmation Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            //   TableRelation = "Confirmation header";
        }
        field(2; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; Factors; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Maximum Rating"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; Rating; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF Rating > "Maximum Rating" THEN
                    ERROR('Rating cannot Exceed Maximum Rating');
            end;
        }
        field(15; Comments; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Confirmation Code", "Line No")
        {
        }
    }

    fieldgroups
    {
    }
}

