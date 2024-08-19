/// <summary>
/// Table HR Online Referee Details (ID 50103).
/// </summary>
table 50103 "HR Online Referee Details"
{

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; "Employee No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;
        }
        field(3; Surname; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Firstname; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Middlename; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Personal E-Mail Address"; Text[30])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
        field(7; "Postal Address"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Post Code"; Code[20])
        {
            /*
            Caption = 'Post Code';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Country/Region Code" = CONST(code)) "Post Code"
            ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                PostCode.LookupPostCode("Applicant E-mail", "Post Code", County, field(50000;
                "Fleet Manager Support E-Mail";
                Text[50])
                */
        }
        field(50001; "PWD Age"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Permanet Age"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(52136720; "Managing Agent"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(52136923; "Company Data Directory Path"; Text[250])
        {
            DataClassification = ToBeClassified;
            Description = 'Sysre';
        }
        field(52136924; "NSSF No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Sysre';
        }
        field(52136925; "NHIF No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Sysre';
        }
        field(52136926; "Telephone No."; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Sysre';
            ExtendedDatatype = PhoneNo;
        }
        field(52136927; "Company PIN"; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(9; "Residential Address"; Code[80])
        {
            Caption = 'Residential Address';
            DataClassification = ToBeClassified;
        }
        field(10; "Referee Category"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Professional,Personal';
            OptionMembers = " ",Professional,Personal;
        }
        field(11; Verified; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Applicant E-mail"; Text[100])
        {
            Caption = 'City';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code".City
            ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                PostCode.LookupPostCode("Applicant E-mail", "Post Code", County, "Country/Region Code");
            end;

            trigger OnValidate()
            begin
                PostCode.ValidateCity("Applicant E-mail", "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(13; County; Text[30])
        {
            Caption = 'County';
            DataClassification = ToBeClassified;
        }
        field(14; "Mobile No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Country/Region Code"; Code[20])
        {
            Caption = 'Country/Region Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                PostCode.CheckClearPostCodeCityCounty("Applicant E-mail", "Post Code", County, "Country/Region Code", xRec."Country/Region Code");
            end;
        }
    }

    keys
    {
        key(Key1; "Line No.", "Employee No.", "Applicant E-mail")
        {
        }
    }

    fieldgroups
    {
    }

    var
        PostCode: Record 225;
}

