table 50130 "HR Leave Allocation Header"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;
        }
        field(2; "Document Date"; Date)
        {
            Editable = false;
        }
        field(3; "Posting Date"; Date)
        {
        }
        field(4; "Leave Type"; Code[50])
        {
            TableRelation = "HR Leave Types".Code;

            trigger OnValidate()
            begin
                TESTFIELD("Posting Date");
                IF "Leave Type" <> '' THEN BEGIN
                    HRLeavePeriod.RESET;
                    HRLeavePeriod.SETRANGE(HRLeavePeriod.Closed, FALSE);
                    IF HRLeavePeriod.FINDLAST THEN BEGIN
                        "Leave Period" := HRLeavePeriod.Code;
                    END;
                END ELSE BEGIN
                    ERROR('Please setup leave period');
                END;
                HRLeaveAllocationLine.RESET;
                HRLeaveAllocationLine.SETRANGE(HRLeaveAllocationLine."Leave Allocation No.", "No.");
                IF HRLeaveAllocationLine.FINDSET THEN
                    HRLeaveAllocationLine.DELETEALL;
            end;
        }
        field(5; "Leave Period"; Code[20])
        {
            TableRelation = "HR Leave Periods".Code WHERE(Closed = CONST(false));
        }
        field(49; Description; Text[250])
        {
        }
        field(50; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(51; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(52; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(53; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(54; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(55; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(56; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(57; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(58; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center".Code;
        }
        field(70; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Approved,Rejected,Posted';
            OptionMembers = Open,"Pending Approval",Released,Rejected,Posted;

            trigger OnValidate()
            begin
                HRLeaveAllocationLine.RESET;
                HRLeaveAllocationLine.SETRANGE(HRLeaveAllocationLine."Leave Allocation No.", "No.");
                IF HRLeaveAllocationLine.FINDSET THEN BEGIN
                    REPEAT
                        HRLeaveAllocationLine.Status := Status;
                        HRLeaveAllocationLine.Posted := Posted;
                        HRLeaveAllocationLine."Posted By" := "Posted By";
                        HRLeaveAllocationLine."Date Posted" := "Date Posted";
                        HRLeaveAllocationLine."Time Posted" := "Time Posted";
                        HRLeaveAllocationLine.MODIFY;
                    UNTIL HRLeaveAllocationLine.NEXT = 0;
                END;
            end;
        }
        field(71; Posted; Boolean)
        {
            Editable = false;
        }
        field(72; "Posted By"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(73; "Date Posted"; Date)
        {
            Editable = false;
        }
        field(74; "Time Posted"; Time)
        {
            Editable = false;
        }
        field(99; "User ID"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(100; "No. Series"; Code[20])
        {
        }
        field(102; "Incoming Document Entry No."; Integer)
        {
            Caption = 'Incoming Document Entry No.';
        }
        field(200; "Local URL"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(201; SharePoint; Text[250])
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
        HRLeaveAllocationLine.RESET;
        HRLeaveAllocationLine.SETRANGE(HRLeaveAllocationLine."Leave Allocation No.", "No.");
        IF HRLeaveAllocationLine.FINDSET THEN
            HRLeaveAllocationLine.DELETEALL;
    end;

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Leave Allocation Nos.");
            //NoSeriesMgt.InitSeries(HRSetup."Leave Allocation Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;
        "Document Date" := TODAY;
        "User ID" := USERID;
    end;

    var
        HRSetup: Record 5218;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HRLeavePeriod: Record 50135;
        HRLeaveAllocationLine: Record 50131;
}

