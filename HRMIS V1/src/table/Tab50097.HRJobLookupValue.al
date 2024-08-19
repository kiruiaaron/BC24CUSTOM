table 50097 "HR Job Lookup Value"
{
    Caption = 'HR Job Lookup Value';

    fields
    {
        field(1;Option;Option)
        {
            Caption = 'Option';
            OptionCaption = 'Qualification,Requirement,Responsibility,Job Grade,Checklist Item,Other Certifications,Job Grade Level';
            OptionMembers = Qualification,Requirement,Responsibility,"Job Grade","Checklist Item","Other Certifications","Job Grade Level";
        }
        field(2;"Code";Code[50])
        {
            Caption = 'Code';
        }
        field(3;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(4;Blocked;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Required Stage";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Employee Creation,Interview Approval,Training Evaluation,Employee Requisition';
            OptionMembers = " ","Employee Creation","Interview Approval","Training Evaluation","Employee Requisition";
        }
        field(6;"Local Url";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(7;"Share Point Url";Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;Option,"Code")
        {
        }
    }

    fieldgroups
    {
    }
}

