table 50151 "HR Asset Transfer Lines"
{

    fields
    {
        field(1; "Document No.";
        Code[20])
        {
        }
        field(2; "Asset No."; Code[20])
        {
            TableRelation = "Fixed Asset"."No.";

            trigger OnValidate()
            begin
                "Asset Tag No." := '';
                "Asset Description" := '';
                "FA Location" := '';
                "Responsible Employee Code" := '';
                "Global Dimension 1 Code" := '';
                "Global Dimension 2 Code" := '';
                "Shortcut Dimension 3 Code" := '';
                "Shortcut Dimension 4 Code" := '';
                "Shortcut Dimension 5 Code" := '';
                "Shortcut Dimension 6 Code" := '';

                FA.RESET;
                FA.SETRANGE(FA."No.", "Asset No.");
                IF FA.FINDFIRST THEN BEGIN
                    // "Asset Tag No.":=FA."FA Tag No.";
                    "Asset Description" := FA.Description;
                    "FA Location" := FA."FA Location Code";
                    "Responsible Employee Code" := FA."Responsible Employee";
                    IF Employees.GET("Responsible Employee Code") THEN
                        "Responsible Employee Name" := Employees."First Name" + ' ' + Employees."Last Name";
                    "Global Dimension 1 Code" := Employees."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := Employees."Global Dimension 2 Code";
                    "Shortcut Dimension 3 Code" := Employees."Shortcut Dimension 3 Code";
                    "Shortcut Dimension 4 Code" := Employees."Shortcut Dimension 4 Code";
                    "Shortcut Dimension 5 Code" := Employees."Shortcut Dimension 5 Code";
                    "Shortcut Dimension 6 Code" := Employees."Shortcut Dimension 6 Code";
                    "Asset Serial No" := FA."Serial No.";

                END;
            end;
        }
        field(3; "Asset Tag No."; Code[50])
        {
        }
        field(4; "Asset Description"; Text[200])
        {
        }
        field(5; "Asset Serial No"; Text[50])
        {
        }
        field(6; "FA Location"; Code[80])
        {
            TableRelation = "FA Location";
        }
        field(7; "New Asset Location"; Text[50])
        {
            TableRelation = "FA Location";
        }
        field(8; "Responsible Employee Code"; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                Employees.RESET;
                IF Employees.GET("Responsible Employee Code") THEN BEGIN
                    "Responsible Employee Name" := Employees."First Name" + ' ' + Employees."Last Name";
                END ELSE BEGIN
                    "Responsible Employee Name" := '';
                END;
            end;
        }
        field(9; "Responsible Employee Name"; Text[50])
        {
        }
        field(10; "New Responsible Employee Code"; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                Employees.RESET;
                IF Employees.GET("New Responsible Employee Code") THEN BEGIN
                    "New Responsible Employee Name" := Employees."First Name" + ' ' + Employees."Last Name";
                    "New Global Dimension 1 Code" := Employees."Global Dimension 1 Code";
                    "New Global Dimension 2 Code" := Employees."Global Dimension 2 Code";
                    "New Shortcut Dimension 3 Code" := Employees."Shortcut Dimension 3 Code";
                    "New Shortcut Dimension 4 Code" := Employees."Shortcut Dimension 4 Code";
                END ELSE BEGIN
                    "New Responsible Employee Name" := '';
                    "New Global Dimension 1 Code" := '';
                    "New Global Dimension 2 Code" := '';
                    "New Shortcut Dimension 3 Code" := '';
                    "New Shortcut Dimension 4 Code" := '';
                END;
            end;
        }
        field(11; "New Responsible Employee Name"; Text[100])
        {
        }
        field(12; "Reason for Transfer"; Text[50])
        {
        }
        field(20; "Global Dimension 1 Code"; Code[50])
        {
            Caption = 'Department code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard));

            trigger OnValidate()
            var
                Dimn: Record 349;
            begin
            end;
        }
        field(21; "New Global Dimension 1 Code"; Code[50])
        {
            Caption = 'New Project Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard));

            trigger OnValidate()
            var
                Dimn: Record 349;
            begin
            end;
        }
        field(22; "Global Dimension 2 Code"; Code[50])
        {
            CaptionClass = '1,1,2';
            Caption = 'Current Department Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            var
                Dimn: Record 349;
            begin
            end;
        }
        field(23; "New Global Dimension 2 Code"; Code[50])
        {
            CaptionClass = '1,1,2';
            Caption = 'New Department Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            var
                Dimn: Record 349;
            begin
            end;
        }
        field(24; "Shortcut Dimension 3 Code"; Code[50])
        {
            Caption = 'Current Station Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate()
            var
                Dimn: Record 349;
            begin
            end;
        }
        field(25; "New Shortcut Dimension 3 Code"; Code[50])
        {
            Caption = 'New Station Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate()
            var
                Dimn: Record 349;
            begin
            end;
        }
        field(26; "Shortcut Dimension 4 Code"; Text[100])
        {
            Caption = 'Current Project Name';
        }
        field(27; "New Shortcut Dimension 4 Code"; Text[100])
        {
            Caption = 'New Project Name';
        }
        field(28; "Shortcut Dimension 5 Code"; Text[100])
        {
            Caption = 'Current Department Name';
        }
        field(29; "New Shortcut Dimension 5 Code"; Text[100])
        {
            Caption = 'New Department Name';
        }
        field(30; "Shortcut Dimension 6 Code"; Text[100])
        {
            Caption = 'Current Station Name';
        }
        field(31; "New Shortcut Dimension 6 Code"; Text[100])
        {
            Caption = 'New Station Name';
        }
    }

    keys
    {
        key(Key1; "Document No.", "Asset No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        HRAssetTransferHeader.RESET;
        HRAssetTransferHeader.SETRANGE(HRAssetTransferHeader."No.", "Document No.");
        IF HRAssetTransferHeader.FINDFIRST THEN BEGIN
            HRAssetTransferHeader.TESTFIELD(HRAssetTransferHeader."Activity Type");
            HRAssetTransferHeader.TESTFIELD(HRAssetTransferHeader."Transfer Reason");
            "Reason for Transfer" := HRAssetTransferHeader."Transfer Reason";
        END;
    end;

    var
        FA: Record 5600;
        Employees: Record 5200;
        DimensionValues: Record 349;
        HRAssetTransferHeader: Record 50150;
}

