table 50104 "HR  Online Applicant"
{

    fields
    {
        field(1;"Email Address";Text[100])
        {
        }
        field(2;Surname;Text[50])
        {
        }
        field(3;Firstname;Text[50])
        {
        }
        field(4;Middlename;Text[50])
        {
        }
        field(5;Gender;Option)
        {
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
        field(6;"Date of Birth";Date)
        {
        }
        field(7;Age;Text[250])
        {
        }
        field(8;Address;Code[100])
        {
        }
        field(9;Address2;Code[100])
        {
        }
        field(10;"Post Code";Code[20])
        {
        }
        field(11;City;Code[50])
        {
        }
        field(12;County;Code[50])
        {
        }
        field(13;"County Name";Text[100])
        {
        }
        field(14;SubCounty;Code[50])
        {
        }
        field(15;"SubCounty Name";Text[100])
        {
        }
        field(16;Country;Code[50])
        {
        }
        field(17;"Home Phone No.";Code[20])
        {
        }
        field(18;"Mobile Phone No.";Code[20])
        {
        }
        field(19;"Birth Certificate No.";Code[20])
        {
        }
        field(20;"National ID No.";Code[20])
        {
        }
        field(21;"Passport No.";Code[20])
        {
        }
        field(22;"Driving Licence No.";Code[20])
        {
        }
        field(23;"Marital Status";Option)
        {
            OptionCaption = ' ,Single,Married';
            OptionMembers = " ",Single,Married;
        }
        field(24;Citizenship;Code[50])
        {
        }
        field(25;Religion;Code[50])
        {
        }
        field(26;"Other Citizenship";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(28;"Person With Disability";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'No,Yes';
            OptionMembers = No,Yes;
        }
        field(29;"Ethnic Group";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Lookup Values".Code WHERE (Option=CONST(Ethnicity));
        }
        field(32;"Huduma No.";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(71;"Profile Updated";Boolean)
        {
        }
        field(99;"User ID";Code[50])
        {
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(100;"No. Series";Code[20])
        {
        }
        field(102;"Incoming Document Entry No.";Integer)
        {
            Caption = 'Incoming Document Entry No.';
        }
        field(52137048;PasswordResetToken;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(52137049;PasswordResetTokenExpiry;DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(52137050;"Portal Password";Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(52137051;"Default Portal Password";Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Email Address")
        {
        }
    }

    fieldgroups
    {
    }
}

