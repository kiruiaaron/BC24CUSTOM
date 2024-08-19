table 50314 "WIBA & GPA Claims"
{

    fields
    {
        field(1; "Claim No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                //TestStatusOpen(TRUE);

                "Employee Name" := '';

                IF Employee.GET("Employee No.") THEN BEGIN
                    "Employee Name" := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";

                END;
            end;
        }
        field(41; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(42; "Accident Details"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(43; Description; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(44; "Accident Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(45; "Document Path"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(46; "Claim Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(47; "No. Series"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Claim No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Claim No" = '' THEN BEGIN

            HRSetup.GET;
            //  HRSetup.TESTFIELD(HRSetup."EHS Claims Nos");
            // //NoSeriesMgt.InitSeries(HRSetup."EHS Claims Nos",xRec."No. Series",0D,"Claim No","No. Series");


        END;
    end;

    var
        Employee: Record 5200;
        HRSetup: Record 5218;
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

