table 51184 "Payroll Dimension"
{
    Permissions = TableData 51159 = rm;

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            NotBlank = true;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Table));
        }
        field(2; "Payroll ID"; Code[10])
        {
            NotBlank = true;
            TableRelation = Periods."Period ID";
        }
        field(3; "Employee No"; Code[20])
        {
            TableRelation = Employee;
            ValidateTableRelation = false;
        }
        field(4; "Entry No"; Integer)
        {
        }
        field(5; "ED Code"; Code[20])
        {
            TableRelation = "ED Definitions";

            trigger OnLookup()
            var
                EDCodeRec: Record 51158;
                Employee: Record 5200;
                CalcSchemes: Record 51154;
            begin
            end;

            trigger OnValidate()
            var
                EDCodeRec: Record 51158;
                Employee: Record 5200;
                CalcSchemes: Record 51154;
                lvPayrollHdr: Record 51159;
                lvRoundDirection: Text[1];
            begin
            end;
        }
        field(6; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
            NotBlank = true;
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                //Block Change of dimensions for system created lines as the change will be overwritten by
                //calculate payroll function
                IF "ED Code" <> '' THEN BEGIN
                    gvEDDefinition.GET("ED Code");
                    IF gvEDDefinition."System Created" THEN
                        ERROR('Manual assignment of dimensions to system created EDs is not allowed.');
                END;
                //block end

                IF NOT DimMgt.CheckDim("Dimension Code") THEN ERROR(DimMgt.GetDimErr);
            end;
        }
        field(7; "Dimension Value Code"; Code[20])
        {
            Caption = 'Dimension Value Code';
            NotBlank = true;
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FIELD("Dimension Code"));

            trigger OnValidate()
            begin
                IF NOT DimMgt.CheckDimValue("Dimension Code", "Dimension Value Code") THEN ERROR(DimMgt.GetDimErr);
            end;
        }
        field(8; "Payroll Code"; Code[10])
        {
            Editable = false;
            NotBlank = true;
            TableRelation = Payroll;
        }
    }

    keys
    {
        key(Key1; "Table ID", "Payroll ID", "Employee No", "Entry No", "ED Code", "Dimension Code", "Payroll Code")
        {
        }
        key(Key2; "Table ID", "Payroll ID", "Employee No", "Entry No", "ED Code", "Dimension Code", "Dimension Value Code", "Payroll Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        /*//Block deletione of dimensions for system created lines as the change will be overwritten by
        //calculate payroll function
        IF "ED Code" <> '' THEN BEGIN
          gvEDDefinition.GET("ED Code");
          IF gvEDDefinition."System Created" THEN
            ERROR('Deletion of dimensions assigned to system created EDs is not allowed.');
        END;
        //block end
        
        IF "Table ID" IN [DATABASE::"Payroll Header", DATABASE::"Payroll Entry"] THEN BEGIN
          gvPayrollHdr.GET("Payroll ID", "Employee No");
          gvPayrollHdr.Calculated := FALSE;
          gvPayrollHdr.MODIFY
        END;
        */

    end;

    trigger OnInsert()
    begin
        Rec.TESTFIELD("Dimension Value Code");

        IF "Table ID" IN [DATABASE::"Payroll Header", DATABASE::"Payroll Entry"] THEN BEGIN
            gvPayrollHdr.GET("Payroll ID", "Employee No");
            gvPayrollHdr.Calculated := FALSE;
            gvPayrollHdr.MODIFY
        END;
    end;

    trigger OnRename()
    begin
        ERROR(Text000, TABLECAPTION);
    end;

    var
        Text000: Label 'You can not rename a %1.';
        Text001: Label 'You have changed a dimension.\\';
        Text002: Label 'Do you want to update the lines?';
        Text003: Label 'You may have changed a dimension.\\Do you want to update the lines?';
        DimMgt: Codeunit DimensionManagement;
        gvEDDefinition: Record 51158;
        gvPayrollHdr: Record 51159;
}

