table 50008 "Imprest Header"
{
    Caption = 'Imprest Header';
    DrillDownPageID = 50390;
    LookupPageID = 50390;

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
            Editable = true;
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
                //
            end;
        }
        field(5; "Payment Mode"; Option)
        {
            Caption = 'Payment Mode';
            Editable = true;
            OptionCaption = ' ,Cheque,EFT,RTGS,MPESA,Cash';
            OptionMembers = " ",Cheque,EFT,RTGS,MPESA,Cash;

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);
            end;
        }
        field(6; "Payment Type"; Option)
        {
            Caption = '"Payment Type"';
            Editable = false;
            OptionCaption = 'Normal,Petty Cash,Express,Cash Purchase,Mobile';
            OptionMembers = Normal,"Petty Cash",Express,"Cash Purchase",Mobile;

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);
            end;
        }
        field(7; "Bank Account No."; Code[20])
        {
            Caption = 'Bank Account No.';
            TableRelation = "Bank Account"."No.";

            /*   trigger OnValidate()
              begin
                  TestStatusOpen(TRUE);

              BankAccount.RESET;
              BankAccount.SETRANGE("No.","Bank Account No.");
              IF BankAccount.FINDFIRST THEN BEGIN
                    "Bank Account Name":=BankAccount.Name;
              "Currency Code":=BankAccount."Currency Code";
              VALIDATE("Currency Code");
                  END;
              end; */
        }
        field(8; "Bank Account Name"; Text[100])
        {
            Caption = 'Bank Account Name';
            Editable = false;
        }
        field(9; "Bank Account Balance"; Decimal)
        {
            CalcFormula = Sum("Bank Account Ledger Entry".Amount WHERE("Bank Account No." = FIELD("Bank Account No.")));
            Caption = 'Bank Account Balance';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Cheque Type"; Option)
        {
            Caption = 'Cheque Type';
            OptionCaption = ' ,Computer Cheque,Manual Cheque';
            OptionMembers = " ","Computer Cheque","Manual Cheque";

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);
            end;
        }
        field(11; "Reference No."; Code[20])
        {
            Caption = 'Reference No.';

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);

                ImprestHeader.RESET;
                ImprestHeader.SETRANGE(ImprestHeader."Reference No.", "Reference No.");
                IF ImprestHeader.FINDSET THEN BEGIN
                    REPEAT
                        IF ImprestHeader."No." <> "No." THEN
                            ERROR("ErrorUsedReferenceNo.", ImprestHeader."No.");
                    UNTIL ImprestHeader.NEXT = 0;
                END;
            end;
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
                TestStatusOpen(TRUE);

                IF "Currency Code" <> '' THEN BEGIN
                    IF BankAccount.GET("Bank Account No.") THEN BEGIN
                        BankAccount.TESTFIELD(BankAccount."Currency Code", "Currency Code");
                        "Currency Factor" := CurrExchRate.ExchangeRate("Posting Date", "Currency Code");
                    END;
                END ELSE BEGIN
                    IF BankAccount.GET("Bank Account No.") THEN BEGIN
                        BankAccount.TESTFIELD(BankAccount."Currency Code", '');
                    END;
                END;
            end;
        }
        field(17; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
        }
        field(18; Amount; Decimal)
        {
            CalcFormula = Sum("Imprest Line"."Net Amount" WHERE("Document No." = FIELD("No.")));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; "Amount(LCY)"; Decimal)
        {
            CalcFormula = Sum("Imprest Line"."Gross Amount(LCY)" WHERE("Document No." = FIELD("No.")));
            Caption = 'Amount(LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "Imprest Remaining Amount"; Decimal)
        {
            Editable = false;
        }
        field(21; "Imprest Remaining Amount(LCY)"; Decimal)
        {
            Editable = false;
        }
        field(22; "Date From"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Date To"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(24; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Imprest,Petty Cash,Board Allowances,Subsistence,Overtime,Allowances';
            OptionMembers = " ",Imprest,"Petty Cash","Board Allowances",Subsistence,Overtime,Allowances;
        }
        field(40; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);

                "Employee Name" := '';
                "Employee Posting Group" := '';
                IF Employee.GET("Employee No.") THEN BEGIN
                    "Employee Name" := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                    /*     Employee.TESTFIELD(Employee."Imprest Posting Group");
                        "Employee Posting Group" := Employee."Imprest Posting Group";
                        "HR Job Grade" := Employee."Salary Scale"; */
                    "Phone No." := Employee."Mobile Phone No.";
                    "Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
                    //  "Shortcut Dimension 3 Code" := Employee."Shortcut Dimension 3 Code";
                END;
            end;
        }
        field(41; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(42; "Employee Posting Group"; Code[20])
        {
            Editable = false;
            TableRelation = "Employee Posting Group".Code;

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);
            end;
        }
        field(43; Surrendered; Boolean)
        {
            Caption = 'Surrendered';
        }
        field(44; "Imprest Surrender No."; Code[20])
        {
            Caption = 'Imprest Surrender No.';
            Editable = false;
            TableRelation = "Imprest Surrender Header"."No.";
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
                TestStatusOpen(TRUE);
                //Delete the previous dimensions
                //"Global Dimension 2 Code":='';
                //"Shortcut Dimension 3 Code":='';
                "Shortcut Dimension 4 Code" := '';
                "Shortcut Dimension 5 Code" := '';
                "Shortcut Dimension 6 Code" := '';
                "Shortcut Dimension 7 Code" := '';
                "Shortcut Dimension 8 Code" := '';

                ImprestLine.RESET;
                ImprestLine.SETRANGE(ImprestLine."Document No.", "No.");
                IF ImprestLine.FINDSET THEN BEGIN
                    REPEAT
                        // ImprestLine."Global Dimension 2 Code":='';
                        //ImprestLine."Shortcut Dimension 3 Code":='';
                        ImprestLine."Shortcut Dimension 4 Code" := '';
                        ImprestLine."Shortcut Dimension 5 Code" := '';
                        ImprestLine."Shortcut Dimension 6 Code" := '';
                        ImprestLine."Shortcut Dimension 7 Code" := '';
                        ImprestLine."Shortcut Dimension 8 Code" := '';
                        ImprestLine.MODIFY;
                    UNTIL ImprestLine.NEXT = 0;
                END;
                //End delete the previous dimensions

                ImprestLine.RESET;
                ImprestLine.SETRANGE(ImprestLine."Document No.", "No.");
                IF ImprestLine.FINDSET THEN BEGIN
                    REPEAT
                        ImprestLine."Global Dimension 1 Code" := "Global Dimension 1 Code";
                        ImprestLine.MODIFY;
                    UNTIL ImprestLine.NEXT = 0;
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
                TestStatusOpen(TRUE);
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
                TestStatusOpen(TRUE);
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
        }
        field(59; "Surrender status"; Option)
        {
            OptionCaption = 'Not Surrendered,Partially Surrendered,Fully surrendered';
            OptionMembers = "Not Surrendered","Partially Surrendered","Fully surrendered";
        }
        field(70; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Open,Pending Approval,Approved,Rejected,Posted,Reversed';
            OptionMembers = Open,"Pending Approval",Approved,Rejected,Posted,Reversed;
        }
        field(71; Posted; Boolean)
        {
            Caption = 'Posted';
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
        field(103; "Phone No."; Text[30])
        {
            ExtendedDatatype = PhoneNo;
        }
        field(105; "HR Job Grade"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(106; "Paid In Bank"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(107; "Date Paid"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(108; "Document Path"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(109; "Tax  Amount"; Decimal)
        {
            CalcFormula = Sum("Imprest Line"."Tax Amount" WHERE("Document No." = FIELD("No.")));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(110; "Gross Amount"; Decimal)
        {
            CalcFormula = Sum("Imprest Line"."Gross Amount" WHERE("Document No." = FIELD("No.")));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(111; "Cancelation Comments"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(112; Comments; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(113; "Transferred to Payroll"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(114; "Payroll Period"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(115; "Date transferred"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(116; "Transferred By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(500; "Document Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(501; "Created By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(502; "Budget Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(503; "Total Quantity"; Integer)
        {
            CalcFormula = Sum("Imprest Line".Quantity WHERE("Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(504; "Purchase Requisition No"; Code[20])
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
        fieldgroup(DropDown; "No.", "Employee No.", "Employee Name", Description)
        {
        }
    }

    trigger OnDelete()
    begin
        //TESTFIELD(Status,Status::Open);
        ImprestLine.RESET;
        ImprestLine.SETRANGE(ImprestLine."Document No.", "No.");
        IF ImprestLine.FINDSET THEN
            ImprestLine.DELETEALL;
    end;

    trigger OnInsert()
    begin


        IF "No." = '' THEN BEGIN
            IF Type = Type::Subsistence THEN BEGIN
                FundsSetup.GET;
                FundsSetup.TESTFIELD(FundsSetup."Subsistence Nos");
                NoSeriesMgt.InitSeries(FundsSetup."Subsistence Nos", xRec."No. Series", 0D, "No.", "No. Series");

            END
            ELSE
                IF Type = Type::Overtime THEN BEGIN
                    FundsSetup.GET;
                    FundsSetup.TESTFIELD(FundsSetup."Overtime Nos");
                    NoSeriesMgt.InitSeries(FundsSetup."Overtime Nos", xRec."No. Series", 0D, "No.", "No. Series");

                END
                ELSE BEGIN
                    FundsSetup.GET;
                    FundsSetup.TESTFIELD(FundsSetup."Imprest Nos.");
                    NoSeriesMgt.InitSeries(FundsSetup."Imprest Nos.", xRec."No. Series", 0D, "No.", "No. Series");
                END
        END;

        "Document Type" := "Document Type"::Imprest;
        "Document Date" := TODAY;
        "User ID" := USERID;
        "Posting Date" := TODAY;
        VALIDATE("User ID");
    end;

    trigger OnModify()
    begin
        //TESTFIELD(Status,Status::Open);
    end;

    trigger OnRename()
    begin
        Rec.TESTFIELD(Status, Rec.Status::Open);
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
        ImprestHeader: Record 50008;
        ImprestLine: Record 50009;
        CurrExchRate: Record 330;
        Employee: Record 5200;
        "ErrorUsedReferenceNo.": Label 'The Reference Number has been used in Document No:%1';
        HumanResourcesSetup: Record 5218;
        UserSetup: Record 5200;

    local procedure TestStatusOpen(AllowApproverEdit: Boolean)
    var
        ApprovalEntry: Record 454;
    begin
        IF ImprestHeader.GET("No.") THEN BEGIN
            IF AllowApproverEdit THEN BEGIN
                ApprovalEntry.RESET;
                ApprovalEntry.SETRANGE(ApprovalEntry."Document No.", ImprestHeader."No.");
                ApprovalEntry.SETRANGE(ApprovalEntry.Status, ApprovalEntry.Status::Open);
                ApprovalEntry.SETRANGE(ApprovalEntry."Approver ID", USERID);
                IF NOT ApprovalEntry.FINDFIRST THEN BEGIN
                    ImprestHeader.TESTFIELD(Status, ImprestHeader.Status::Open);
                END;
            END ELSE BEGIN
                ImprestHeader.TESTFIELD(Status, ImprestHeader.Status::Open);
            END;
        END;
    end;
}

