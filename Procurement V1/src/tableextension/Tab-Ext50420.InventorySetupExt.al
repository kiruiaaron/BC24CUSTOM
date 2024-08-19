tableextension 50420 "Inventory Setup Ext" extends "Inventory Setup"
{
    fields
    {
        // Add changes to table fields here
        field(52136925; "Stores Requisition Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Sysre NextGen Addon - Specifies the Stores Requisition No. Series';
            TableRelation = "No. Series";
        }
        field(52136983; "Item Journal Template"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '//Sysre NextGen Addon';
            TableRelation = "Item Journal Template".Name;
        }
        field(52136984; "Item Journal Batch"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '//Sysre NextGen Addon';
            TableRelation = "Item Journal Batch".Name WHERE("Journal Template Name" = FIELD("Item Journal Template"));
        }
    }

    var
        myInt: Integer;
}