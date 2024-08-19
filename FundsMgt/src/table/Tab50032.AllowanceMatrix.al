table 50032 "Allowance Matrix"
{

    fields
    {
        field(10; "Job Group"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salary Scale";
        }
        field(11; "Allowance Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Funds Transaction Code"."Transaction Code" WHERE("Transaction Type" = CONST(Imprest));
        }
        field(12; "Cluster Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Cluster Codes"."Cluster Code";
        }
        field(14; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15; From; Code[50])
        {
            DataClassification = ToBeClassified;
            //  TableRelation = "Procurement Lookup Values".Code;
        }
        field(16; Tos; Code[50])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Procurement Lookup Values".Code WHERE("Type" = CONST(City));
        }
        field(17; "Allowance Description"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Transport Allowance"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Exempt from Cluster Code"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Job Group", "Allowance Code", "Cluster Code", From, Tos)
        {
        }
    }

    fieldgroups
    {
    }
}

