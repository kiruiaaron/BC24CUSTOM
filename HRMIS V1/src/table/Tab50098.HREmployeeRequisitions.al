table 50098 "HR Employee Requisitions"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Job No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Jobs"."No." WHERE(Status = CONST(Released),
                                                 "Vacant Positions" = FILTER(> 0),
                                                 Active = CONST(true));

            trigger OnValidate()
            begin
                "Job Title" := '';
                "Job Grade" := '';
                "Global Dimension 1 Code" := '';
                "Global Dimension 2 Code" := '';
                "Maximum Positions" := 0;
                "Vacant Positions" := 0;
                IF HRJob.GET("Job No.") THEN BEGIN
                    HRJob.CALCFIELDS("Occupied Positions");
                    IF HRJob."Maximum Positions" = HRJob."Occupied Positions" THEN BEGIN
                        ERROR(NoVacantPositions, HRJob."Job Title");
                    END ELSE BEGIN
                        "Job Title" := HRJob."Job Title";
                        "Job Grade" := HRJob."Job Grade";
                        "Global Dimension 1 Code" := HRJob."Global Dimension 1 Code";
                        "Global Dimension 2 Code" := HRJob."Global Dimension 2 Code";
                        "Shortcut Dimension 3 Code" := HRJob."Shortcut Dimension 3 Code";
                        "Maximum Positions" := HRJob."Maximum Positions";
                        "Vacant Positions" := HRJob."Maximum Positions" - HRJob."Occupied Positions";
                        "Requested Employees" := HRJob."Vacant Positions";
                    END;
                END;
            end;
        }
        field(3; "Job Title"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "Emp. Requisition Description"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Job Grade"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "HR Job Lookup Value".Code WHERE(Option = CONST("Job Grade"));
        }
        field(6; "Maximum Positions"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; "Occupied Positions"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Vacant Positions"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; "Requested Employees"; Integer)
        {
            DataClassification = ToBeClassified;
            MinValue = 0;

            trigger OnValidate()
            begin
                TESTFIELD("Job No.");
                IF "Requested Employees" > "Vacant Positions" THEN
                    ERROR(RequestedEmployeesError, "Job Title", "Vacant Positions");
            end;
        }
        field(10; "Closing Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD("Job No.");
                IF "Closing Date" < CALCDATE('+1D', TODAY) THEN
                    ERROR(ClosingDateError, CALCDATE('+1D', TODAY));
            end;
        }
        field(11; "Requisition Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Internal,Internal/External';
            OptionMembers = " ",Internal,"Internal/External";
        }
        field(12; "Emplymt. Contract Code"; Code[10])
        {
            Caption = 'Emplymt. Contract Code';
            DataClassification = ToBeClassified;
            TableRelation = "Employment Contract";
        }
        field(13; "Reason for Requisition"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Interview Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Interview Time"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Interview Location"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Purchase Requisition Created"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Purchase Requisition No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(49; Description; Text[100])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Description := UPPERCASE(Description);
            end;
        }
        field(50; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(51; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(52; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(53; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(54; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(55; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(56; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(57; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(58; "Responsibility Center"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center".Code;
        }
        field(59; "Job Advert Published"; Boolean)
        {
            Caption = 'Job Advertisment Published';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(69; "Job Advert Dropped"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70; Status; Option)
        {
            DataClassification = ToBeClassified;
            Editable = true;
            OptionCaption = 'Open,Pending Approval,Approved,Rejected,Closed';
            OptionMembers = Open,"Pending Approval",Released,Rejected,Closed;

            trigger OnValidate()
            begin
                IF Rec.Status = Rec.Status::Released THEN
                    "Requisition Approved" := TRUE;
                REC.MODIFY;
            end;
        }
        field(71; "Requisition Approved"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(72; "Mandatory Docs. Required"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(99; "User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(100; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(102; "Incoming Document Entry No."; Integer)
        {
            Caption = 'Incoming Document Entry No.';
            DataClassification = ToBeClassified;
        }
        field(103; Comments; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(104; "Regret Email Sent"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(105; "Created By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(106; "Employee No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(107; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(108; "Desired Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(109; "Employee To Be Replaced"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                // EmployeeRec.GET("Employee To Be Replaced");
                // "Employee Name":=EmployeeRec.FullName;
            end;
        }
        field(110; "Employee Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(111; "HOD No."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                // EmployeeRec.GET("HOD No.");
                // "HOD Name":=EmployeeRec.FullName;
            end;
        }
        field(112; "HOD Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(113; "HR Manager No."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                // EmployeeRec.GET("HR Manager No.");
                // "HR Manager Name":=EmployeeRec.FullName;
            end;
        }
        field(114; "HR Manager Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(115; "MD/FD/GM No."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                // EmployeeRec.GET("MD/FD/GM No.");
                // "MD/FD/GM Name":=EmployeeRec.FullName;
            end;
        }
        field(116; "MD/FD/GM Name"; Text[100])
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
        fieldgroup(DropDown; "No.", "Job No.", "Job Title")
        {
        }
    }

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Employee Requisition Nos.");
            //NoSeriesMgt.InitSeries(HRSetup."Employee Requisition Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;
        "User ID" := USERID;
        "Document Date" := TODAY;
    end;

    var
        HRSetup: Record 5218;
        NoSeriesMgt: Codeunit 396;
        HRJob: Record 50093;
        HREmployeeRequisition: Record 50098;
        RequestedEmployeesError: Label 'The Requested Employee(s) cannot be more than the vacant position(s) in the %1 Job, the number of vacant positions is %2';
        NoVacantPositions: Label 'No Vacant Position(s) Exist for Job Title %1';
        ClosingDateError: Label 'The Closing Date cannot be Less than %1';
        EmployeeRec: Record 5200;
}

