table 50010 "Imprest Surrender Header"
{
    Caption = 'Imprest Surrender Header';
    DrillDownPageID = 50398;
    LookupPageID = 50398;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Document Type';
            Editable = false;
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund,Receipt,Funds Transfer,Imprest,Imprest Surrender';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund,Receipt,"Funds Transfer",Imprest,"Imprest Surrender";
        }
        field(3; "Document Date"; Date)
        {
            Caption = 'Document Date';
            Editable = false;
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);
            end;
        }
        field(5; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);

                "Employee Name" := '';
                IF Employee.GET("Employee No.") THEN BEGIN
                    "Employee Name" := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                END;
            end;
        }
        field(6; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(7; "Imprest No."; Code[20])
        {
            Caption = 'Imprest No.';
            TableRelation = "Imprest Header"."No." WHERE("Employee No." = FIELD("Employee No."),
                                                        Posted = CONST(true),
                                                        "Surrender status" = FILTER("Not Surrendered"));

            trigger OnValidate()
            begin
                //TestStatusOpen(TRUE);

                TESTFIELD("Employee No.");
                //Reset Imprest Surrender
                ImprestSurrenderLine.RESET;
                ImprestSurrenderLine.SETRANGE(ImprestSurrenderLine."Document No.", "No.");
                IF ImprestSurrenderLine.FINDSET THEN BEGIN
                    ImprestSurrenderLine.DELETEALL;
                END;

                "Imprest Date" := 0D;
                "Global Dimension 1 Code" := '';
                "Global Dimension 2 Code" := '';
                "Shortcut Dimension 3 Code" := '';
                "Shortcut Dimension 4 Code" := '';
                "Shortcut Dimension 5 Code" := '';
                "Shortcut Dimension 6 Code" := '';
                "Shortcut Dimension 7 Code" := '';
                "Shortcut Dimension 8 Code" := '';
                "Responsibility Center" := '';
                //End Reset Imprest Surrender

                COMMIT;

                IF "Imprest No." <> '' THEN BEGIN
                    IF ImprestHeader.GET("Imprest No.") THEN BEGIN
                        "Imprest Date" := ImprestHeader."Posting Date";
                        "Currency Code" := ImprestHeader."Currency Code";
                        "Global Dimension 1 Code" := ImprestHeader."Global Dimension 1 Code";
                        "Global Dimension 2 Code" := ImprestHeader."Global Dimension 2 Code";
                        "Shortcut Dimension 3 Code" := ImprestHeader."Shortcut Dimension 3 Code";
                        "Shortcut Dimension 4 Code" := ImprestHeader."Shortcut Dimension 4 Code";
                        "Shortcut Dimension 5 Code" := ImprestHeader."Shortcut Dimension 5 Code";
                        "Shortcut Dimension 6 Code" := ImprestHeader."Shortcut Dimension 6 Code";
                        "Shortcut Dimension 7 Code" := ImprestHeader."Shortcut Dimension 7 Code";
                        "Shortcut Dimension 8 Code" := ImprestHeader."Shortcut Dimension 8 Code";
                        "Responsibility Center" := ImprestHeader."Responsibility Center";
                        Type := ImprestHeader.Type;

                        ImprestLine.RESET;
                        ImprestLine.SETRANGE(ImprestLine."Document No.", ImprestHeader."No.");
                        ImprestLine.SETFILTER(ImprestLine."Gross Amount", '>%1', 0);
                        IF ImprestLine.FINDSET THEN BEGIN
                            REPEAT
                                ImprestSurrenderLine.RESET;
                                ImprestSurrenderLine."Line No." := 0;
                                ImprestSurrenderLine."Document No." := "No.";
                                ImprestSurrenderLine."Document Type" := ImprestSurrenderLine."Document Type"::"Imprest Surrender";
                                ImprestSurrenderLine."Imprest Code" := ImprestLine."Imprest Code";
                                ImprestSurrenderLine."Imprest Code Description" := ImprestLine."Imprest Code Description";
                                ImprestSurrenderLine."Account Type" := ImprestLine."Account Type";
                                ImprestSurrenderLine."Account No." := ImprestLine."Account No.";
                                ImprestSurrenderLine."Account Name" := ImprestLine."Account Name";
                                ImprestSurrenderLine."Posting Group" := ImprestLine."Posting Group";
                                ImprestSurrenderLine.Description := ImprestLine.Description;
                                ImprestSurrenderLine."Currency Code" := ImprestLine."Currency Code";
                                ImprestSurrenderLine."Gross Amount" := ImprestLine."Gross Amount";
                                ImprestSurrenderLine."Gross Amount(LCY)" := ImprestLine."Gross Amount(LCY)";
                                ImprestSurrenderLine."Actual Spent" := ImprestLine."Net Amount";
                                ImprestSurrenderLine."Actual Spent(LCY)" := ImprestLine."Net Amount";
                                ImprestSurrenderLine."Paid Amount" := ImprestLine."Net Amount";
                                ImprestSurrenderLine."Tax Amount" := ImprestLine."Tax Amount";
                                ImprestSurrenderLine."Global Dimension 1 Code" := ImprestLine."Global Dimension 1 Code";
                                ImprestSurrenderLine."Global Dimension 2 Code" := ImprestLine."Global Dimension 2 Code";
                                ImprestSurrenderLine."Shortcut Dimension 3 Code" := ImprestLine."Shortcut Dimension 3 Code";
                                ImprestSurrenderLine."Shortcut Dimension 4 Code" := ImprestLine."Shortcut Dimension 4 Code";
                                ImprestSurrenderLine."Shortcut Dimension 5 Code" := ImprestLine."Shortcut Dimension 5 Code";
                                ImprestSurrenderLine."Shortcut Dimension 6 Code" := ImprestLine."Shortcut Dimension 6 Code";
                                ImprestSurrenderLine."Shortcut Dimension 7 Code" := ImprestLine."Shortcut Dimension 7 Code";
                                ImprestSurrenderLine."Shortcut Dimension 8 Code" := ImprestLine."Shortcut Dimension 8 Code";
                                ImprestSurrenderLine."Responsibility Center" := ImprestLine."Responsibility Center";
                                ImprestSurrenderLine."FA Depreciation Book" := ImprestLine."FA Depreciation Book";
                                ImprestSurrenderLine.INSERT;
                            UNTIL ImprestLine.NEXT = 0;
                        END;
                    END;
                END;
            end;
        }
        field(8; "Imprest Date"; Date)
        {
            Caption = 'Imprest Date';
        }
        field(15; "On Behalf Of"; Text[100])
        {
            Caption = 'On Behalf Of';
        }
        field(16; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                TESTFIELD("Imprest No.");
                TESTFIELD("Posting Date");
            end;
        }
        field(17; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
        }
        field(18; Amount; Decimal)
        {
            CalcFormula = Sum("Imprest Surrender Line"."Paid Amount" WHERE("Document No." = FIELD("No.")));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; "Amount(LCY)"; Decimal)
        {
            CalcFormula = Sum("Imprest Surrender Line"."Gross Amount(LCY)" WHERE("Document No." = FIELD("No.")));
            Caption = 'Amount(LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "Actual Spent"; Decimal)
        {
            CalcFormula = Sum("Imprest Surrender Line"."Actual Spent" WHERE("Document No." = FIELD("No.")));
            Caption = 'Actual Spent';
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; "Actual Spent(LCY)"; Decimal)
        {
            CalcFormula = Sum("Imprest Surrender Line"."Actual Spent(LCY)" WHERE("Document No." = FIELD("No.")));
            Caption = 'Actual Spent(LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; "Cash Receipt Amount"; Decimal)
        {
            CalcFormula = Sum("Imprest Surrender Line"."Cash Receipt" WHERE("Document No." = FIELD("No.")));
            Caption = 'Cash Receipt Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(23; "Cash Receipt Amount(LCY)"; Decimal)
        {
            CalcFormula = Sum("Imprest Surrender Line"."Cash Receipt(LCY)" WHERE("Document No." = FIELD("No.")));
            Caption = 'Cash Receipt Amount(LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(24; Difference; Decimal)
        {
            CalcFormula = Sum("Imprest Surrender Line".Difference WHERE("Document No." = FIELD("No.")));
            Caption = 'Difference';
            FieldClass = FlowField;
        }
        field(25; "Difference(LCY)"; Decimal)
        {
            CalcFormula = Sum("Imprest Surrender Line"."Difference(LCY)" WHERE("Document No." = FIELD("No.")));
            Caption = 'Difference(LCY)';
            FieldClass = FlowField;
        }
        field(49; Description; Text[250])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);

                Description := UPPERCASE(Description);
            end;
        }
        field(50; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                //TestStatusOpen(TRUE);
                //Delete the previous dimensions
                "Global Dimension 2 Code" := '';
                "Shortcut Dimension 3 Code" := '';
                "Shortcut Dimension 4 Code" := '';
                "Shortcut Dimension 5 Code" := '';
                "Shortcut Dimension 6 Code" := '';
                "Shortcut Dimension 7 Code" := '';
                "Shortcut Dimension 8 Code" := '';
                ImprestSurrenderLine.RESET;
                ImprestSurrenderLine.SETRANGE(ImprestSurrenderLine."Document No.", "No.");
                IF ImprestSurrenderLine.FINDSET THEN BEGIN
                    REPEAT
                        ImprestSurrenderLine."Global Dimension 2 Code" := '';
                        ImprestSurrenderLine."Shortcut Dimension 3 Code" := '';
                        ImprestSurrenderLine."Shortcut Dimension 4 Code" := '';
                        ImprestSurrenderLine."Shortcut Dimension 5 Code" := '';
                        ImprestSurrenderLine."Shortcut Dimension 6 Code" := '';
                        ImprestSurrenderLine."Shortcut Dimension 7 Code" := '';
                        ImprestSurrenderLine."Shortcut Dimension 8 Code" := '';
                        ImprestSurrenderLine.MODIFY;
                    UNTIL ImprestSurrenderLine.NEXT = 0;
                END;
                //End delete the previous dimensions

                ImprestSurrenderLine.RESET;
                ImprestSurrenderLine.SETRANGE(ImprestSurrenderLine."Document No.", "No.");
                IF ImprestSurrenderLine.FINDSET THEN BEGIN
                    REPEAT
                        ImprestSurrenderLine."Global Dimension 1 Code" := "Global Dimension 1 Code";
                        ImprestSurrenderLine.MODIFY;
                    UNTIL ImprestSurrenderLine.NEXT = 0;
                END;
            end;
        }
        field(51; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                //TestStatusOpen(TRUE);
            end;
        }
        field(52; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                //TestStatusOpen(TRUE);
            end;
        }
        field(53; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);
            end;
        }
        field(54; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);
            end;
        }
        field(55; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);
            end;
        }
        field(56; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);
            end;
        }
        field(57; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);
            end;
        }
        field(58; "Responsibility Center"; Code[20])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center".Code;

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);
            end;
        }
        field(70; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Open,Pending Approval,Released,Rejected,Posted,Reversed';
            OptionMembers = Open,"Pending Approval",Released,Rejected,Posted,Reversed;

            trigger OnValidate()
            begin
                ImprestSurrenderLine.RESET;
                ImprestSurrenderLine.SETRANGE(ImprestSurrenderLine."Document No.", "No.");
                IF ImprestSurrenderLine.FINDSET THEN BEGIN
                    REPEAT
                        ImprestSurrenderLine.Status := Rec.Status;
                        ImprestSurrenderLine.MODIFY;
                    UNTIL ImprestSurrenderLine.NEXT = 0;
                END;
            end;
        }
        field(71; Posted; Boolean)
        {
            Caption = 'Posted';
            Editable = false;
        }
        field(72; "Posted By"; Code[50])
        {
            Caption = 'Posted By';
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(73; "Date Posted"; Date)
        {
            Caption = 'Date Posted';
            Editable = false;
        }
        field(74; "Time Posted"; Time)
        {
            Caption = 'Time Posted';
            Editable = false;
        }
        field(75; Reversed; Boolean)
        {
            Caption = 'Reversed';
            Editable = false;
        }
        field(76; "Reversed By"; Code[50])
        {
            Caption = 'Reversed By';
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(77; "Reversal Date"; Date)
        {
            Caption = 'Reversal Date';
            Editable = false;
        }
        field(78; "Reversal Time"; Time)
        {
            Caption = 'Reversal Time';
            Editable = false;
        }
        field(80; "Reversal Posting Date"; Date)
        {
        }
        field(99; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = "User Setup"."User ID";

            trigger OnValidate()
            begin
                UserSetup.RESET;
                UserSetup.SETRANGE(UserSetup."User ID", "User ID");
                IF UserSetup.FINDFIRST THEN BEGIN
                    UserSetup.TESTFIELD(UserSetup."Global Dimension 1 Code");
                    UserSetup.TESTFIELD(UserSetup."Global Dimension 2 Code");
                    "Global Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
                    "Shortcut Dimension 3 Code" := UserSetup."Shortcut Dimension 3 Code";
                    "Shortcut Dimension 4 Code" := UserSetup."Shortcut Dimension 4 Code";
                    "Shortcut Dimension 5 Code" := UserSetup."Shortcut Dimension 5 Code";
                    "Shortcut Dimension 6 Code" := UserSetup."Shortcut Dimension 6 Code";
                    "Shortcut Dimension 7 Code" := UserSetup."Shortcut Dimension 7 Code";
                    "Shortcut Dimension 8 Code" := UserSetup."Shortcut Dimension 8 Code";
                END;
            end;
        }
        field(100; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
        }
        field(101; "No. Printed"; Integer)
        {
            Caption = 'No. Printed';
        }
        field(102; "Incoming Document Entry No."; Integer)
        {
        }
        field(103; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Imprest,Petty Cash,Board Allowances,Subsistence';
            OptionMembers = " ",Imprest,"Petty Cash","Board Allowances",Subsistence;
        }
        field(104; "Document Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(105; "Created by"; Code[20])
        {
            DataClassification = ToBeClassified;
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

    trigger OnDelete()
    begin
        //TESTFIELD(Status,Status::Open);
        ImprestSurrenderLine.RESET;
        ImprestSurrenderLine.SETRANGE("Document No.", "No.");
        IF ImprestSurrenderLine.FINDSET THEN
            ImprestSurrenderLine.DELETEALL;
    end;

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            FundsSetup.GET;
            FundsSetup.TESTFIELD(FundsSetup."Imprest Surrender Nos.");
            NoSeriesMgt.InitSeries(FundsSetup."Imprest Surrender Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;
        "Document Type" := "Document Type"::"Imprest Surrender";
        "Document Date" := TODAY;
        "User ID" := USERID;
        VALIDATE("User ID");
    end;

    trigger OnModify()
    begin
        //TESTFIELD(Status,Status::Open);
    end;

    trigger OnRename()
    begin
        //TESTFIELD(Status,Status::Open);
    end;

    var
        FundsSetup: Record 50031;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        "G/LAccount": Record 15;
        BankAccount: Record 270;
        Customer: Record 18;
        Vendor: Record 23;
        FixedAsset: Record 5600;
        ICPartner: Record 413;
        Employee: Record 5200;
        ImprestHeader: Record 50008;
        ImprestLine: Record 50009;
        ImprestSurrenderHeader: Record 50010;
        ImprestSurrenderLine: Record 50011;
        CurrExchRate: Record 330;
        OnlyDeleteOpenDocument: Label 'You can only delete an Open Payment Document. The current status is %1';
        UserSetup: Record 5200;

    local procedure TestStatusOpen(AllowApproverEdit: Boolean)
    var
        ApprovalEntry: Record 454;
    begin
        ImprestSurrenderHeader.GET("No.");
        IF AllowApproverEdit THEN BEGIN
            ApprovalEntry.RESET;
            ApprovalEntry.SETRANGE(ApprovalEntry."Document No.", ImprestSurrenderHeader."No.");
            ApprovalEntry.SETRANGE(ApprovalEntry.Status, ApprovalEntry.Status::Open);
            ApprovalEntry.SETRANGE(ApprovalEntry."Approver ID", USERID);
            IF NOT ApprovalEntry.FINDFIRST THEN BEGIN
                ImprestSurrenderHeader.TESTFIELD(Status, ImprestSurrenderHeader.Status::Open);
            END;
        END ELSE BEGIN
            ImprestSurrenderHeader.TESTFIELD(Status, ImprestSurrenderHeader.Status::Open);
        END;
    end;
}

