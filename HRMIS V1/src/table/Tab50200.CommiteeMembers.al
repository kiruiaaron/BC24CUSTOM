table 50200 "Commitee Members"
{

    fields
    {
        field(1; "Ref No"; Code[50])
        {
            // TableRelation = Table51511303;
        }
        field(2; Commitee; Code[10])
        {
            NotBlank = false;
            //TableRelation = Table51511302;
        }
        field(3; "Employee No"; Code[30])
        {
            NotBlank = true;
            TableRelation = Employee."No." WHERE(Status = CONST(Active));

            trigger OnValidate()
            begin
                IF Empl.GET("Employee No") THEN BEGIN
                    Name := Empl."First Name" + ' ' + Empl."Last Name";
                END;
            end;
        }
        field(4; Name; Text[80])
        {
        }
        field(5; "Appointment No"; Code[20])
        {

            trigger OnValidate()
            begin
                /*
                  IF Appoitment.GET("Appointment No") THEN
                  BEGIN
                   "Appointment No":=Appoitment."Appointment No";
                    Commitee:=Appoitment."Committee ID";
                  END;
                */

            end;
        }
        field(6; Chair; Boolean)
        {
        }
        field(7; Secretary; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Appointment No", "Employee No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Empl: Record 5200;
}

