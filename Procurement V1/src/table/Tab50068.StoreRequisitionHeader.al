table 50068 "Store Requisition Header"
{
    DrillDownPageID = 50372;
    LookupPageID = 50372;

    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;
        }
        field(2; "Document Date"; Date)
        {
        }
        field(3; "Posting Date"; Date)
        {
        }
        field(4; "Location Code"; Code[10])
        {
            TableRelation = Location;
        }
        field(5; "Required Date"; Date)
        {
        }
        field(6; "Requester ID"; Code[50])
        {
            Caption = 'Requester ID';
            Editable = false;

            trigger OnLookup()
            var
                LoginMgt: Codeunit 418;
            begin
            end;

            trigger OnValidate()
            var
                LoginMgt: Codeunit 418;
            begin
            end;
        }
        field(10; Amount; Decimal)
        {
            CalcFormula = Sum("Store Requisition Line"."Line Amount" WHERE("Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(49; Description; Text[150])
        {
        }
        field(50; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(51; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
            //Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(52; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard),
                                                         Blocked = CONST(false));
            //Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(53; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard),
                                                        Blocked = CONST(false));
            //Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(54; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          "Dimension Value Type" = CONST(Standard),
                                                           Blocked = CONST(false));
            //Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(55; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard),
                                                           Blocked = CONST(false));
            //Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(56; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard),
                                                           Blocked = CONST(false));
            //Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(57; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
            //Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(58; "Responsibility Center"; Code[20])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center".Code;
        }
        field(70; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Approved,Rejected,Posted';
            OptionMembers = Open,"Pending Approval",Approved,Rejected,Posted;

            trigger OnValidate()
            begin
                StoreRequisitionLine.RESET;
                StoreRequisitionLine.SETRANGE(StoreRequisitionLine."Document No.", "No.");
                IF StoreRequisitionLine.FINDSET THEN BEGIN
                    REPEAT
                        StoreRequisitionLine.Status := Status;
                        StoreRequisitionLine.MODIFY;
                    UNTIL StoreRequisitionLine.NEXT = 0;
                END;
            end;
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
        field(99; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = "User Setup"."User ID";

            trigger OnValidate()
            begin
                /*  UserSetup.RESET;
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
                 END;*/
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
            Caption = 'Incoming Document Entry No.';
        }
        field(103; "Return to store"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(104; "Store Requistion No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Store Requisition Header"."No." WHERE(Status = CONST(Posted),
                                                                 "Return to store" = CONST(false));
        }
        field(52137023; "Employee No."; Code[20])
        {
            Editable = false;
            TableRelation = Employee."No.";
        }
        field(52137024; "Cancellation comments"; Text[100])
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
        IF Status <> Status::Open THEN
            ERROR(Text002)
    end;

    trigger OnInsert()
    begin
        IF ("No." = '') AND ("Return to store" = FALSE) THEN BEGIN
            InventorySetup.GET();
            InventorySetup.TESTFIELD(InventorySetup."Stores Requisition Nos.");
            NoSeriesMgt.InitSeries(InventorySetup."Stores Requisition Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;

        //added on 11/10/2020
        IF ("No." = '') AND ("Return to store" = TRUE) THEN BEGIN
            InventorySetup.GET();
            InventorySetup.TESTFIELD(InventorySetup."Stores Requisition Nos.");
            NoSeriesMgt.InitSeries(InventorySetup."Stores Requisition Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;
        //end

        "Document Date" := TODAY;
        "Posting Date" := TODAY;
        "Requester ID" := USERID;
        "User ID" := USERID;
        VALIDATE("User ID");
        "User ID" := UserId;
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        InventorySetup: Record 313;
        Text001: Label 'Your identification is set up to process from %1 %2 only.';
        StoreRequisitionLine: Record 50069;
        Employee: Record 5200;
        Text002: Label 'You Cannot DELETE an already released Requisition';
        UserSetup: Record 5200;
}

