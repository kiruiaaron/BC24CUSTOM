table 50066 "Procurement Upload Documents"
{

    fields
    {
        field(1;"Code";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Document Code";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Document Description";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Document Mandatory";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(5;Type;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Vendor,LPO,RFQ,Tender';
            OptionMembers = " ",Vendor,LPO,RFQ,Tender;
        }
        field(6;"Tender Stage";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Tender Preparation,Tender Opening,Tender Evaluation,Closed';
            OptionMembers = "Tender Preparation","Tender Opening","Tender Evaluation";
        }
        field(20;"Document Attached";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(21;"Local File URL";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(22;"SharePoint URL";Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Code","Document Code")
        {
        }
    }

    fieldgroups
    {
    }
}

