table 50053 "Bid Analysis Header"
{

    fields
    {
        field(1; "RFQ No."; Code[20])
        {
            TableRelation = "Request for Quotation Header"."No." WHERE(Status = CONST(Released));

            trigger OnValidate()
            begin
                RFQHeader.RESET;
                RFQHeader.SETRANGE(RFQHeader."No.", "RFQ No.");
                IF RFQHeader.FINDFIRST THEN BEGIN
                    "RFQ Date" := RFQHeader."Closing Date";
                    Description := RFQHeader.Description;
                    "Global Dimension 1 Code" := RFQHeader."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := RFQHeader."Global Dimension 2 Code";
                    "Shortcut Dimension 3 Code" := RFQHeader."Shortcut Dimension 3 Code";
                    "Shortcut Dimension 4 Code" := RFQHeader."Shortcut Dimension 4 Code";
                    "Shortcut Dimension 5 Code" := RFQHeader."Shortcut Dimension 5 Code";
                    "Shortcut Dimension 6 Code" := RFQHeader."Shortcut Dimension 6 Code";
                    "Shortcut Dimension 7 Code" := RFQHeader."Shortcut Dimension 7 Code";
                    "Shortcut Dimension 8 Code" := RFQHeader."Shortcut Dimension 8 Code";
                END;
            end;
        }
        field(2; "Document Date"; Date)
        {
            Editable = false;
        }
        field(10; "RFQ Date"; Date)
        {
            Editable = false;
        }
        field(49; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(50; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
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
        }
        field(52; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(53; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(54; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(55; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(56; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(57; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(58; "Responsibility Center"; Code[20])
        {
            Caption = 'Responsibility Center';
        }
        field(60; "Reason for Selection of Vendor"; Text[250])
        {
        }
        field(70; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Released,Rejected,Closed';
            OptionMembers = Open,"Pending Approval",Released,Rejected,Closed;

            trigger OnValidate()
            begin
                BidAnalysisLine.RESET;
                BidAnalysisLine.SETRANGE(BidAnalysisLine."Document No.", "RFQ No.");
                IF BidAnalysisLine.FINDSET THEN BEGIN
                    REPEAT
                        BidAnalysisLine.Status := Status;
                        BidAnalysisLine.MODIFY;
                    UNTIL BidAnalysisLine.NEXT = 0;
                END;
            end;
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
            Caption = 'Incoming Document Entry No.';
        }
    }

    keys
    {
        key(Key1; "RFQ No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "RFQ No." <> '' THEN BEGIN
            RFQVendors.RESET;
            RFQVendors.SETRANGE(RFQVendors."RFQ Document No.", "RFQ No.");
            IF RFQVendors.FINDSET THEN BEGIN
                REPEAT
                    BidAnalysisLine.INIT;
                    BidAnalysisLine."Line No." := 0;
                    BidAnalysisLine."Document No." := "RFQ No.";
                    BidAnalysisLine."Vendor No." := RFQVendors."Vendor No.";
                    BidAnalysisLine.VALIDATE(BidAnalysisLine."Vendor No.");
                    BidAnalysisLine.INSERT;
                UNTIL RFQVendors.NEXT = 0;
            END;
        END;
        "Document Date" := TODAY;
        "User ID" := USERID;
    end;

    trigger OnRename()
    begin
        BidAnalysisLine.RESET;
        BidAnalysisLine.SETRANGE(BidAnalysisLine."Document No.", xRec."RFQ No.");
        IF BidAnalysisLine.FINDSET THEN BEGIN
            BidAnalysisLine.DELETEALL;
        END;
        COMMIT;

        BidAnalysisLine.RESET;
        IF "RFQ No." <> '' THEN BEGIN
            RFQVendors.RESET;
            RFQVendors.SETRANGE(RFQVendors."RFQ Document No.", "RFQ No.");
            IF RFQVendors.FINDSET THEN BEGIN
                REPEAT
                    BidAnalysisLine.INIT;
                    BidAnalysisLine."Line No." := 0;
                    BidAnalysisLine."Document No." := "RFQ No.";
                    BidAnalysisLine."Vendor No." := RFQVendors."Vendor No.";
                    BidAnalysisLine.VALIDATE(BidAnalysisLine."Vendor No.");
                    BidAnalysisLine.INSERT;
                UNTIL RFQVendors.NEXT = 0;
            END;
        END;
    end;

    var
        RFQHeader: Record 50049;
        RFQVendors: Record 50051;
        BidAnalysisLine: Record 50054;
}

