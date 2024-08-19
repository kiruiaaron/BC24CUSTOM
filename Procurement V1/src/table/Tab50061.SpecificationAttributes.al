table 50061 "Specification Attributes"
{

    fields
    {
        field(10;"Line No.";Integer)
        {
            AutoIncrement = true;
        }
        field(11;"RFQ No.";Code[20])
        {
        }
        field(12;Specification;Text[150])
        {
        }
        field(13;Requirement;Text[150])
        {
        }
        field(14;No;Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(15;Type;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Purchase Requisition,LPO,Procurement Planning,RFQ';
            OptionMembers = "Purchase Requisition",LPO,"Procurement Planning",RFQ;
        }
        field(16;Item;Code[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Line No.","RFQ No.",Type,Item)
        {
        }
    }

    fieldgroups
    {
    }
}

