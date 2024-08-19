/// <summary>
/// Table Employee Leave Type (ID 50133).
/// </summary>
table 50133 "Employee Leave Type"
{

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            TableRelation = Employee;
        }
        field(2; "Leave Type"; Code[50])
        {
            TableRelation = "HR Leave Types".Code;

            trigger OnValidate()
            begin
                Description := '';
                IF HRLeaveType.GET("Leave Type") THEN
                    Description := HRLeaveType.Description;

                IF "Leave Type" <> '' THEN BEGIN
                    HRLeavePeriod.RESET;
                    HRLeavePeriod.SETRANGE(HRLeavePeriod.Closed, FALSE);
                    IF HRLeavePeriod.FINDLAST THEN BEGIN
                        "Current Period" := HRLeavePeriod.Code;
                    END;
                END ELSE BEGIN
                    ERROR('Please setup leave period');
                END;
            end;
        }
        field(3; Description; Text[100])
        {
            Editable = false;
        }
        field(4; "Allocation Days"; Decimal)
        {
            Editable = false;
        }
        field(5; "Leave Balance"; Decimal)
        {

            /*  FieldClass = FlowField;
             CalcFormula = Sum("HR Leave Ledger Entries".Days WHERE("Employee No.""=FIELD("Employee No."),
                                                                     "Leave Type"=FIELD("Leave Type"),
                                                                     "Leave Period"=FIELD("Current Period")));
             Editable = false; */

        }
        field(10; "Current Period"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Leave Type")
        // key(Key1; "Employee No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        HRLeaveType: Record 50134;
        HRLeavePeriod: Record 50135;
}

