report 51185 "Employee Details Reveiw Func."
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee; 5200)
        {
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin

                IF RenameRec THEN BEGIN
                    RecReff.GETTABLE(Employee);
                    FielRef := RecReff.FIELD(FieldNotoAdjust);
                    IF AdjustmentType = AdjustmentType::"Fixed Value" THEN BEGIN
                        IF "AdjustmentValue(Numeric)" <> 0 THEN
                            FielRef.VALUE := "AdjustmentValue(Numeric)"
                        ELSE
                            IF "AdjustmentValue(Text)" <> '' THEN
                                FielRef.VALUE := "AdjustmentValue(Text)";
                    END ELSE
                        IF AdjustmentType = AdjustmentType::"Fixed Increment" THEN BEGIN
                            IF "AdjustmentValue(Numeric)" <> 0 THEN BEGIN
                                AddValue := FielRef.VALUE;
                                FielRef.VALUE := AddValue + "AdjustmentValue(Numeric)"
                            END;
                        END ELSE
                            IF AdjustmentType = AdjustmentType::Factor THEN BEGIN
                                IF "AdjustmentValue(Numeric)" <> 0 THEN BEGIN
                                    MultValue := FielRef.VALUE;
                                    FielRef.VALUE := MultValue * "AdjustmentValue(Numeric)"
                                END;
                            END;
                    RecReff.MODIFY;
                END ELSE
                    EXIT;
            end;

            trigger OnPostDataItem()
            begin
                IF RenameRec THEN
                    MESSAGE(Text001)
                ELSE
                    MESSAGE(Text002);
            end;

            trigger OnPreDataItem()
            begin
                RenameRec := CONFIRM(Text000, TRUE);
                CLEAR(AddValue);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Group)
                {
                    field(AdjustmentType; AdjustmentType)
                    {
                        Caption = 'Adjustment Type';
                        ApplicationArea = All;
                    }
                    field(FieldNotoAdjust; FieldNotoAdjust)
                    {
                        Caption = 'Field No. Adjust';
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            FieldRec.RESET;
                            FieldRec.SETRANGE(FieldRec.TableNo, DATABASE::Employee);
                            IF AdjustmentType = AdjustmentType::"Fixed Increment" THEN
                                FieldRec.SETFILTER(FieldRec.Type, '%1|%2', FieldRec.Type::Integer, FieldRec.Type::Decimal)
                            ELSE
                                IF AdjustmentType = AdjustmentType::Factor THEN
                                    FieldRec.SETRANGE(FieldRec.Type, FieldRec.Type::Decimal);
                            IF FieldRec.FINDFIRST THEN
                                REPEAT
                                    FieldRec.MARK(TRUE);
                                UNTIL FieldRec.NEXT = 0;
                            FieldRec.MARKEDONLY(TRUE);
                            IF PAGE.RUNMODAL(6218, FieldRec) = ACTION::LookupOK THEN BEGIN
                                FieldNotoAdjust := FieldRec."No.";
                                FieldNametoAdjust := FieldRec.FieldName;

                                //RequestOptionsPage.FieldNametoAdjust.EDITABLE:=FALSE;
                            END;
                            IF ((AdjustmentType = AdjustmentType::"Fixed Increment") OR
                               (AdjustmentType = AdjustmentType::Factor)) THEN BEGIN
                                //  RequestOptionsForm."Adjustment Value (Numeric)".EDITABLE := TRUE;
                                // RequestOptionsForm."Adjustment Value (Text)".EDITABLE := FALSE;
                            END ELSE
                                IF AdjustmentType = AdjustmentType::"Fixed Value" THEN BEGIN
                                    // RequestOptionsForm."Adjustment Value (Numeric)".EDITABLE := TRUE;
                                    // RequestOptionsForm."Adjustment Value (Text)".EDITABLE := TRUE;
                                END;
                        end;
                    }
                    field(FieldNametoAdjust; FieldNametoAdjust)
                    {
                        Caption = 'Field Name to Adjust';
                        ApplicationArea = All;
                    }
                    field(AdjustmentValueNumeric; "AdjustmentValue(Numeric)")
                    {
                        Caption = 'Adjustment Value (numeric)';
                        ApplicationArea = All;
                    }
                    field(AdjustmentValueText; "AdjustmentValue(Text)")
                    {
                        Caption = 'Adjustment Value (Text)';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        gsSegmentPayrollData;
    end;

    var
        FieldNotoAdjust: Integer;
        "AdjustmentValue(Numeric)": Decimal;
        FieldNametoAdjust: Text[250];
        "AdjustmentValue(Text)": Text[250];
        AdjustmentType: Option "Fixed Increment","Fixed Value",Factor;
        FieldRec: Record 2000000041;
        RecReff: RecordRef;
        FielRef: FieldRef;
        RecIS: RecordID;
        Emp: Record 5200;
        RenameRec: Boolean;
        Text000: Label 'Do you want to modify the records?';
        Text001: Label 'Records modified sucessfully';
        Text002: Label 'Did not modify any records';
        gvAllowedPayrolls: Record 51182;
        MembershipNumbers: Record 51175;
        gvPinNo: Code[20];
        ActPayrollID: Code[20];
        AddValue: Decimal;
        MultValue: Decimal;

    procedure gsSegmentPayrollData()
    var
        lvAllowedPayrolls: Record 51182;
        lvPayrollUtilities: Codeunit 51152;
        UsrID: Code[10];
        UsrID2: Code[10];
        StringLen: Integer;
        lvActiveSession: Record 2000000110;
    begin

        lvActiveSession.RESET;
        lvActiveSession.SETRANGE("Server Instance ID", SERVICEINSTANCEID);
        lvActiveSession.SETRANGE("Session ID", SESSIONID);
        lvActiveSession.FINDFIRST;


        gvAllowedPayrolls.SETRANGE("User ID", lvActiveSession."User ID");
        gvAllowedPayrolls.SETRANGE("Last Active Payroll", TRUE);
        IF NOT gvAllowedPayrolls.FINDFIRST THEN
            ERROR('You are not allowed access to this payroll dataset.');
    end;
}

