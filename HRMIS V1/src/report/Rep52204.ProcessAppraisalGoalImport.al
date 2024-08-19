report 52204 "Process Appraisal Goal Import"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/layouts/Process Appraisal Goal Import.rdlc';

    dataset
    {
        dataitem(Employee; 5200)
        {
            //DataItemTableView = WHERE("No." = CONST(003));

            trigger OnAfterGetRecord()
            begin
                ok := FALSE;
                AppraisalStandardImportRec.RESET;
                AppraisalStandardImportRec.SETRANGE("Employee No", Employee."No.");
                AppraisalStandardImportRec.SETRANGE(Processed, FALSE);
                IF AppraisalStandardImportRec.FINDFIRST THEN BEGIN
                    EmployeeAppraisalHeaderRec.INIT;
                    EmployeeAppraisalHeaderRec."Appraisal Stage" := EmployeeAppraisalHeaderRec."Appraisal Stage"::"Target Setting";
                    EmployeeAppraisalHeaderRec.VALIDATE("Employee No.", Employee."No.");
                    EmployeeAppraisalHeaderRec.INSERT(TRUE);
                    REPEAT
                        //Insert KPIs
                        AppraisalKPIRec.INIT;
                        AppraisalKPIRec."Header No" := EmployeeAppraisalHeaderRec."No.";
                        AppraisalKPIRec."Criteria code" := AppraisalStandardImportRec."KPI Code";
                        AppraisalKPIRec."Performance Criteria" := AppraisalStandardImportRec."KPI Description";
                        IF NOT AppraisalKPIRec.GET(EmployeeAppraisalHeaderRec."No.", AppraisalStandardImportRec."KPI Code") THEN BEGIN
                            AppraisalKPIRec.INSERT;
                            ok := TRUE;
                        END;

                        //Insert Targets/activities
                        AppraisalTargetRec.INIT;
                        AppraisalTargetRec."Header No" := EmployeeAppraisalHeaderRec."No.";
                        AppraisalTargetRec."Criteria code" := AppraisalStandardImportRec."KPI Code";
                        AppraisalTargetRec."Target Code" := AppraisalStandardImportRec."Activity Code";
                        AppraisalTargetRec."Performance Targets" := AppraisalStandardImportRec."Activity Description";
                        IF NOT AppraisalTargetRec.GET(EmployeeAppraisalHeaderRec."No.", AppraisalStandardImportRec."KPI Code",
                          AppraisalStandardImportRec."Activity Code") THEN BEGIN

                            AppraisalTargetRec.INSERT;
                            ok := TRUE;
                        END;

                        //Insert the standards
                        AppraisalIndicatorsRec.INIT;
                        AppraisalIndicatorsRec."Header No" := EmployeeAppraisalHeaderRec."No.";
                        AppraisalIndicatorsRec."Criteria code" := AppraisalStandardImportRec."KPI Code";
                        AppraisalIndicatorsRec."Target Code" := AppraisalStandardImportRec."Activity Code";
                        AppraisalIndicatorsRec."Indicator Code" := AppraisalStandardImportRec."Standard Code";
                        AppraisalIndicatorsRec."Specific Indicator" := AppraisalStandardImportRec."Standard Description";
                        AppraisalIndicatorsRec."Target Date" := AppraisalStandardImportRec."Target Date";
                        AppraisalIndicatorsRec."Targeted Score" := AppraisalStandardImportRec."Target Score";
                        IF NOT AppraisalIndicatorsRec.GET(EmployeeAppraisalHeaderRec."No.", AppraisalStandardImportRec."KPI Code",
                          AppraisalStandardImportRec."Activity Code", AppraisalStandardImportRec."Standard Code") THEN BEGIN
                            AppraisalIndicatorsRec.INSERT;
                            ok := TRUE;
                        END;

                        AppraisalStandardImportRec.Processed := ok;
                        AppraisalStandardImportRec.MODIFY;
                        CountProcessed += 1;
                    UNTIL AppraisalStandardImportRec.NEXT = 0;

                END;
            end;

            trigger OnPostDataItem()
            begin
                MESSAGE('%1 records processed', CountProcessed);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        AppraisalStandardImportRec: Record 50324;
        AppraisalStandardImportRecCopy: Record 50324;
        EmployeeAppraisalHeaderRec: Record 50281;
        AppraisalKPIRec: Record 50285;
        AppraisalTargetRec: Record 50288;
        AppraisalIndicatorsRec: Record 50283;
        HRCalendarPeriodRec: Record 50145;
        AppraisalKPIRecCopy: Record 50285;
        AppraisalTargetRecCopy: Record 50288;
        ok: Boolean;
        CountProcessed: Integer;
}

