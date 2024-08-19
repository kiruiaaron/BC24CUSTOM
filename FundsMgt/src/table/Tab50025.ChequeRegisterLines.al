table 50025 "Cheque Register Lines"
{

    fields
    {
        field(10; "Line No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(11; "Document No.";
        Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Leaf no"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Cheque No."; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Payee No"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(16; Payee; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "PV No"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "PV Description"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "PV Prepared By"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(20; Status; Option)
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Pending Approval,Approved,Rejected,Posted,Reversed';
            OptionMembers = Open,"Pending Approval",Approved,Rejected,Posted,Reversed;
        }
        field(21; "Cheque Cancelled"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Cancelled By"; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(23; "Bank  Account No."; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Assigned to PV"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "PV Posted with Cheque"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Cheque No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        ChequeRegister.RESET;
        ChequeRegister.SETRANGE(ChequeRegister."No.", "Document No.");
        IF ChequeRegister.FINDFIRST THEN BEGIN
            "Document Date" := ChequeRegister."Document Date"
        END;
    end;

    var
        ChequeRegister: Record 50024;
}

