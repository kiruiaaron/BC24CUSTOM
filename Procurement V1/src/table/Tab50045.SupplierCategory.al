table 50045 "Supplier Category"
{

    fields
    {
        field(11; "Document Number"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Supplier Category"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Category";

            trigger OnValidate()
            begin
                ItemCategory.RESET;
                ItemCategory.SETRANGE(ItemCategory.Code, "Supplier Category");
                IF ItemCategory.FINDFIRST THEN BEGIN
                    "Category Description" := ItemCategory.Description;
                END;
            end;
        }
        field(13; "Category Description"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document Number", "Supplier Category")
        {
        }
    }

    fieldgroups
    {
    }

    var
        ItemCategory: Record 5722;
}

