/// <summary>
/// Table Employee Bank Account (ID 51152).
/// </summary>
table 51152 "Employee Bank Account"
{
    DataCaptionFields = "No.", Name;


    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; Name; Text[200])
        {
        }
        field(3; Branch; Text[50])
        {
        }
        field(4; Address; Text[30])
        {
        }
        field(5; "Address 2"; Text[30])
        {
        }
        field(6; City; Text[30])
        {
        }
        field(7; Contact; Text[30])
        {
        }
        field(8; "Phone No."; Text[30])
        {
        }
        field(9; "Fax No."; Text[30])
        {
        }
        field(10; "Post Code"; Code[20])
        {
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(11; County; Text[30])
        {
        }
        field(12; "KBA Code"; Text[30])
        {
            Numeric = true;
        }
        field(13; "Bank Branch Code"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "KBA Code")
        {
        }
        key(Key3; Name)
        {
        }
        key(Key4; Branch)
        {
        }
        key(Key5; City)
        {
        }
    }

    fieldgroups
    {
    }

    var
        PostCode: Record "Post Code";
}

