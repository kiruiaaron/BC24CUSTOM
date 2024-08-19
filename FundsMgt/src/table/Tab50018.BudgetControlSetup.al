table 50018 "Budget Control Setup"
{

    fields
    {
        field(1;"Primary Key";Code[10])
        {
        }
        field(2;"Current Budget Code";Code[20])
        {
            TableRelation = "G/L Budget Name".Name;
        }
        field(3;"Current Budget Start Date";Date)
        {
        }
        field(4;"Current Budget End Date";Date)
        {
        }
        field(5;"Budget Dimension 1 Code";Code[20])
        {
            Caption = 'Budget Dimension 1 Code';
            TableRelation = Dimension;
        }
        field(6;"Budget Dimension 2 Code";Code[20])
        {
            Caption = 'Budget Dimension 2 Code';
            TableRelation = Dimension;
        }
        field(7;"Budget Dimension 3 Code";Code[20])
        {
            Caption = 'Budget Dimension 3 Code';
            TableRelation = Dimension;
        }
        field(8;"Budget Dimension 4 Code";Code[20])
        {
            Caption = 'Budget Dimension 4 Code';
            TableRelation = Dimension;
        }
        field(9;"Budget Dimension 5 Code";Code[20])
        {
            Caption = 'Budget Dimension 5 Code';
            TableRelation = Dimension;
        }
        field(10;"Budget Dimension 6 Code";Code[20])
        {
            Caption = 'Budget Dimension 6 Code';
            TableRelation = Dimension;
        }
        field(11;"Analysis View Code";Code[20])
        {
            TableRelation = "Analysis View".Code;
        }
        field(12;"Dimension 1 Code";Code[20])
        {
            Caption = 'Dimension 1 Code';
            TableRelation = Dimension;
        }
        field(13;"Dimension 2 Code";Code[20])
        {
            Caption = 'Dimension 2 Code';
            TableRelation = Dimension;
        }
        field(14;"Dimension 3 Code";Code[20])
        {
            Caption = 'Dimension 3 Code';
            TableRelation = Dimension;
        }
        field(15;"Dimension 4 Code";Code[20])
        {
            Caption = 'Dimension 4 Code';
            TableRelation = Dimension;
        }
        field(16;Mandatory;Boolean)
        {
        }
        field(17;"Allow OverExpenditure";Boolean)
        {
        }
        field(18;"Current Item Budget";Code[10])
        {
            TableRelation = "Item Budget Name".Name;
        }
        field(19;"Budget Check Criteria";Option)
        {
            OptionCaption = 'Current Month,Whole Year';
            OptionMembers = "Current Month","Whole Year";
        }
        field(20;"Actual Source";Option)
        {
            OptionCaption = 'G/L Entry,Analysis View Entry';
            OptionMembers = "G/L Entry","Analysis View Entry";
        }
        field(21;"Partial Budgetary Check";Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}

