table 50021 "Budget Allocation Line"
{

    fields
    {
        field(1; "Line No."; BigInteger)
        {
            AutoIncrement = true;
        }
        field(2; "Document No.";
        Code[20])
        {
            TableRelation = "Budget Allocation Header"."No.";
        }
        field(3; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";
        }
        field(5; Date; Date)
        {
        }
        field(6; Amount; Decimal)
        {
        }
        field(49; Description; Text[250])
        {
            Caption = 'Description';
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
                TestStatusOpen(FALSE);
            end;
        }
        field(51; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            //  Field52136925=FIELD("Global Dimension 1 Code"));

            trigger OnValidate()
            begin
                TestStatusOpen(FALSE);
            end;
        }
        field(52; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
            //Field52136925=FIELD("Global Dimension 1 Code"));

            trigger OnValidate()
            begin
                TestStatusOpen(FALSE);
            end;
        }
        field(53; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
            // Field52136925=FIELD("Global Dimension 1 Code"));

            trigger OnValidate()
            begin
                TestStatusOpen(FALSE);
            end;
        }
        field(54; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                         "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
            //  Field52136925=FIELD("Global Dimension 1 Code"));

            trigger OnValidate()
            begin
                TestStatusOpen(FALSE);
            end;
        }
        field(55; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
            //Field52136925=FIELD("Global Dimension 1 Code"));

            trigger OnValidate()
            begin
                TestStatusOpen(FALSE);
            end;
        }
        field(56; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
            //Field52136925=FIELD("Global Dimension 1 Code"));

            trigger OnValidate()
            begin
                TestStatusOpen(FALSE);
            end;
        }
        field(57; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
            //   Field52136925=FIELD("Global Dimension 1 Code"));

            trigger OnValidate()
            begin
                TestStatusOpen(FALSE);
            end;
        }
        field(70; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Open,Pending Approval,Released,Rejected,Posted,Reversed';
            OptionMembers = Open,"Pending Approval",Released,Rejected,Posted,Reversed;
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
        field(99; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
    }

    keys
    {
        key(Key1; "Line No.", "Document No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        BudgetAllocationHeader: Record 50020;

    local procedure TestStatusOpen(AllowApproverEdit: Boolean)
    var
        ApprovalEntry: Record 454;
    begin
        BudgetAllocationHeader.RESET;
        BudgetAllocationHeader.GET("Document No.");
        IF AllowApproverEdit THEN BEGIN
            ApprovalEntry.RESET;
            ApprovalEntry.SETRANGE(ApprovalEntry."Document No.", BudgetAllocationHeader."No.");
            ApprovalEntry.SETRANGE(ApprovalEntry.Status, ApprovalEntry.Status::Open);
            ApprovalEntry.SETRANGE(ApprovalEntry."Approver ID", USERID);
            IF NOT ApprovalEntry.FINDFIRST THEN BEGIN
                BudgetAllocationHeader.TESTFIELD(BudgetAllocationHeader.Status, BudgetAllocationHeader.Status::Open);
            END;
        END ELSE BEGIN
            BudgetAllocationHeader.TESTFIELD(BudgetAllocationHeader.Status, BudgetAllocationHeader.Status::Open);
        END;
    end;
}

