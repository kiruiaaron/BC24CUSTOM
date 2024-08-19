/// <summary>
/// Table HR Medical Scheme (ID 50154).
/// </summary>
table 50154 "HR Medical Scheme"
{

    fields
    {
        field(10; "No."; Code[20])
        {
        }
        field(11; "Employee No."; Code[30])
        {
        }
        field(12; "Employee Name"; Text[100])
        {
        }
        field(13; "Medical Scheme Description"; Text[100])
        {
        }
        field(14; "Family Size"; Code[20])
        {
        }
        field(15; "Cover Option"; Option)
        {
            OptionCaption = ' ,Principal,Dependant';
            OptionMembers = " ",Principal,Dependant;
        }
        field(16; "No Series"; Code[20])
        {
        }
        field(17; Provider; Code[20])
        {
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                IF Vend.GET(Provider) THEN BEGIN
                    "Provider Name" := Vend.Name;
                END;
            end;
        }
        field(18; "Provider Name"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        //GENERATE NEW NUMBER FOR THE DOCUMENT
        IF "No." = '' THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Medical Scheme No.");
            //NoSeriesMgt.InitSeries(HRSetup."Medical Scheme No.", xRec."No Series", 0D, "No.", "No Series");
        END;
    end;

    var
        HREmp: Record 5200;
        HRSetup: Record 5218;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        EmpFullName: Text;
        IntFullName: Text;
        Vend: Record 23;
}

