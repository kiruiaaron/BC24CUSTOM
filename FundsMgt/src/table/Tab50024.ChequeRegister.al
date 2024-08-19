table 50024 "Cheque Register"
{

    fields
    {
        field(10; "No."; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(11; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(12; "Bank Account"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account";

            trigger OnValidate()
            begin
                "Bank Account Name" := '';
                "Last Cheque No." := '';

                IF BankAccount.GET("Bank Account") THEN
                    BankAccount.TESTFIELD(BankAccount."Last Check No.");
                "Bank Account Name" := BankAccount.Name;
                "Last Cheque No." := BankAccount."Last Check No.";
            end;
        }
        field(13; "Bank Account Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "Last Cheque No."; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(15; "Cheque Book Number"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "No of Leaves"; Integer)
        {
            CalcFormula = Count("Cheque Register Lines" WHERE("Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                /*"Cheque Number From":='';
                "Cheque Number To.":='';
                
                ChequeRegisterLines.RESET;
                ChequeRegisterLines.SETRANGE(ChequeRegisterLines."Document No.","No.");
                IF ChequeRegisterLines.FINDSET THEN BEGIN
                  ChequeRegisterLines.DELETEALL;
                END;
                
                
                
                EVALUATE(Leaves,"Last Cheque No.");
                
                "Cheque Number From":=INCSTR("Last Cheque No.");
                EVALUATE(Leaves,"Cheque Number From");
                //MESSAGE(FORMAT(Leaves));
                LastLeafNumber:=Leaves+"No of Leaves";
                //MESSAGE(FORMAT(LastLeafNumber));
                "Cheque Number To.":=FORMAT(LastLeafNumber);
                
                EVALUATE("Cheque Number To.", DELCHR(FORMAT("Cheque Number To."),'<=>',','));
                //MESSAGE("Cheque Number To.");
                
                
                
                IncrNo:="Cheque Number From";
                
                WHILE IncrNo<="Cheque Number To." DO BEGIN
                
                ChequeRegisterLines.INIT;
                ChequeRegisterLines."Document No.":="No.";
                ChequeRegisterLines."Cheque No.":=IncrNo;
                ChequeRegisterLines."Bank  Account No.":="Bank Account";
                ChequeRegisterLines.INSERT;
                
                IncrNo:=INCSTR(IncrNo);
                END;
                */

            end;
        }
        field(17; "Cheque Number From"; Code[10])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ChequeRegisterLines.RESET;
                ChequeRegisterLines.SETRANGE(ChequeRegisterLines."Document No.", "No.");
                IF ChequeRegisterLines.FINDSET THEN BEGIN
                    ChequeRegisterLines.DELETEALL;
                END;
            end;
        }
        field(18; "Cheque Number To."; Code[10])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD("Cheque Number From");
            end;
        }
        field(30; "Created By"; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(31; "No. Series"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(32; Status; Option)
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Approved,Rejected,Posted,Reversed';
            OptionMembers = Open,"Pending Approval",Approved,Rejected,Posted,Reversed;

            trigger OnValidate()
            begin
                ChequeRegisterLines.RESET;
                ChequeRegisterLines.SETRANGE(ChequeRegisterLines."Document No.", "No.");
                IF ChequeRegisterLines.FINDSET THEN BEGIN
                    REPEAT
                        ChequeRegisterLines.Status := Rec.Status;
                        ChequeRegisterLines.MODIFY;
                    UNTIL ChequeRegisterLines.NEXT = 0;
                END;
            end;
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
        IF "No." = '' THEN BEGIN
            FundsSetup.GET;
            FundsSetup.TESTFIELD(FundsSetup."Imprest Surrender Nos.");
            NoSeriesMgt.InitSeries(FundsSetup."Imprest Surrender Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;

        "Document Date" := TODAY;
        "Created By" := USERID;
    end;

    var
        FundsSetup: Record 50031;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ChequeRegisterLines: Record 50025;
        BankAccount: Record 270;
        Leaves: Decimal;
        IncrNo: Code[30];
        LastLeafNumber: Decimal;
}

