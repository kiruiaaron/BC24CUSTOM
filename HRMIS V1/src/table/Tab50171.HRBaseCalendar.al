table 50171 "HR Base Calendar"
{
    Caption = 'Base Calendar';
    DataCaptionFields = "Code", Name;
    LookupPageID = 7601;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Name; Text[30])
        {
            Caption = 'Name';
        }
        field(3; "Customized Changes Exist"; Boolean)
        {
            CalcFormula = Exist("Customized Calendar Change" WHERE("Base Calendar Code" = FIELD(Code)));
            Caption = 'Customized Changes Exist';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        CustomizedCalendarChange: Record 7602;
    begin
        CustomizedCalendarChange.SETRANGE("Base Calendar Code", Code);
        IF NOT CustomizedCalendarChange.ISEMPTY THEN
            ERROR(Text001, Code);

        BaseCalendarLine.RESET;
        BaseCalendarLine.SETRANGE("Base Calendar Code", Code);
        BaseCalendarLine.DELETEALL;
    end;

    var
        BaseCalendarLine: Record 7601;
        Text001: Label 'You cannot delete this record. Customized calendar changes exist for calendar code=<%1>.';
}

