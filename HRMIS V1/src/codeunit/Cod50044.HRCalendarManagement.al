codeunit 50044 "HR Calendar Management"
{

    trigger OnRun()
    begin
    end;

    var
        Customer: Record 18;
        Vendor: Record 23;
        Location: Record 14;
        CompanyInfo: Record 79;
        ServMgtSetup: Record 5911;
        Shippingagent: Record 5790;
        BaseCalChange: Record 50172;
        CustCalChange: Record 7602;
        TempCustChange: Record 7602 temporary;
        TempCounter: Integer;
        Text001: Label 'Yes';
        Text002: Label 'No';
        Text003: Label 'The expression %1 cannot be negative.';
        OldSourceType: Integer;
        OldSourceCode: Code[20];
        OldAdditionalSourceCode: Code[20];
        OldCalendarCode: Code[10];


    procedure ShowCustomizedCalendar(ForSourcetype: Option Company,Customer,Vendor,Location,"Shipping Agent",Service; ForSourceCode: Code[20]; ForAdditionalSourceCode: Code[20]; ForBaseCalendarCode: Code[10])
    var
        TempCustomizedCalEntry: Record 7603 temporary;
    begin
        TempCustomizedCalEntry.DELETEALL;
        TempCustomizedCalEntry.INIT;
        TempCustomizedCalEntry."Source Type" := ForSourcetype;
        TempCustomizedCalEntry."Source Code" := ForSourceCode;
        TempCustomizedCalEntry."Additional Source Code" := ForAdditionalSourceCode;
        TempCustomizedCalEntry."Base Calendar Code" := ForBaseCalendarCode;
        TempCustomizedCalEntry.INSERT;
        PAGE.RUN(PAGE::"Customized Calendar Entries", TempCustomizedCalEntry);
    end;

    local procedure GetCalendarCode(SourceType: Option Company,Customer,Vendor,Location,"Shipping Agent",Service; SourceCode: Code[20]; AdditionalSourceCode: Code[20]): Code[10]
    begin
        CASE SourceType OF
            SourceType::Company:
                IF CompanyInfo.GET THEN
                    EXIT(CompanyInfo."Base Calendar Code");
            SourceType::Customer:
                IF Customer.GET(SourceCode) THEN
                    EXIT(Customer."Base Calendar Code");
            SourceType::Vendor:
                IF Vendor.GET(SourceCode) THEN
                    EXIT(Vendor."Base Calendar Code");
            SourceType::"Shipping Agent":
                BEGIN
                    IF Shippingagent.GET(SourceCode, AdditionalSourceCode) THEN
                        EXIT(Shippingagent."Base Calendar Code");

                    IF CompanyInfo.GET THEN
                        EXIT(CompanyInfo."Base Calendar Code");
                END;
            SourceType::Location:
                BEGIN
                    IF Location.GET(SourceCode) THEN
                        IF Location."Base Calendar Code" <> '' THEN
                            EXIT(Location."Base Calendar Code");
                    IF CompanyInfo.GET THEN
                        EXIT(CompanyInfo."Base Calendar Code");
                END;
            SourceType::Service:
                IF ServMgtSetup.GET THEN
                    EXIT(ServMgtSetup."Base Calendar Code");
        END;
    end;


    procedure CheckDateStatus(CalendarCode: Code[10]; TargetDate: Date; var Description: Text[50]): Boolean
    begin
        BaseCalChange.RESET;
        BaseCalChange.SETRANGE("Base Calendar Code", CalendarCode);
        IF BaseCalChange.FINDSET THEN
            REPEAT
                CASE BaseCalChange."Recurring System" OF
                    BaseCalChange."Recurring System"::" ":
                        IF TargetDate = BaseCalChange.Date THEN BEGIN
                            Description := BaseCalChange.Description;
                            EXIT(BaseCalChange.Nonworking);
                        END;
                    BaseCalChange."Recurring System"::"Weekly Recurring":
                        IF DATE2DWY(TargetDate, 1) = BaseCalChange.Day THEN BEGIN
                            Description := BaseCalChange.Description;
                            EXIT(BaseCalChange.Nonworking);
                        END;
                    BaseCalChange."Recurring System"::"Annual Recurring":
                        IF (DATE2DMY(TargetDate, 2) = DATE2DMY(BaseCalChange.Date, 2)) AND
                           (DATE2DMY(TargetDate, 1) = DATE2DMY(BaseCalChange.Date, 1))
                        THEN BEGIN
                            Description := BaseCalChange.Description;
                            EXIT(BaseCalChange.Nonworking);
                        END;
                END;
            UNTIL BaseCalChange.NEXT = 0;
        Description := '';
    end;


    procedure CheckCustomizedDateStatus(SourceType: Option Company,Customer,Vendor,Location,"Shipping Agent",Service; SourceCode: Code[20]; AdditionalSourceCode: Code[20]; CalendarCode: Code[10]; TargetDate: Date; var Description: Text[50]): Boolean
    begin
        CombineChanges(SourceType, SourceCode, AdditionalSourceCode, CalendarCode);
        TempCustChange.RESET;
        TempCustChange.SETCURRENTKEY("Entry No.");
        IF TempCustChange.FINDSET THEN
            REPEAT
                CASE TempCustChange."Recurring System" OF
                    TempCustChange."Recurring System"::" ":
                        IF TargetDate = TempCustChange.Date THEN BEGIN
                            Description := TempCustChange.Description;
                            EXIT(TempCustChange.Nonworking);
                        END;
                    TempCustChange."Recurring System"::"Weekly Recurring":
                        IF DATE2DWY(TargetDate, 1) = TempCustChange.Day THEN BEGIN
                            Description := TempCustChange.Description;
                            EXIT(TempCustChange.Nonworking);
                        END;
                    TempCustChange."Recurring System"::"Annual Recurring":
                        IF (DATE2DMY(TargetDate, 2) = DATE2DMY(TempCustChange.Date, 2)) AND
                           (DATE2DMY(TargetDate, 1) = DATE2DMY(TempCustChange.Date, 1))
                        THEN BEGIN
                            Description := TempCustChange.Description;
                            EXIT(TempCustChange.Nonworking);
                        END;
                END;
            UNTIL TempCustChange.NEXT = 0;
        Description := '';
    end;

    local procedure CombineChanges(SourceType: Option Company,Customer,Vendor,Location,"Shipping Agent",Service; SourceCode: Code[20]; AdditionalSourceCode: Code[20]; CalendarCode: Code[10])
    begin
        IF (SourceType = OldSourceType) AND
           (SourceCode = OldSourceCode) AND (AdditionalSourceCode = OldAdditionalSourceCode) AND (CalendarCode = OldCalendarCode)
        THEN
            EXIT;

        TempCustChange.RESET;
        TempCustChange.DELETEALL;

        TempCounter := 0;
        CustCalChange.RESET;
        CustCalChange.SETRANGE("Source Type", SourceType);
        CustCalChange.SETRANGE("Source Code", SourceCode);
        CustCalChange.SETRANGE("Base Calendar Code", CalendarCode);
        CustCalChange.SETRANGE("Additional Source Code", AdditionalSourceCode);
        IF CustCalChange.FINDSET THEN
            REPEAT
                TempCounter := TempCounter + 1;
                TempCustChange.INIT;
                TempCustChange."Source Type" := CustCalChange."Source Type";
                TempCustChange."Source Code" := CustCalChange."Source Code";
                TempCustChange."Base Calendar Code" := CustCalChange."Base Calendar Code";
                TempCustChange."Additional Source Code" := CustCalChange."Additional Source Code";
                TempCustChange.Date := CustCalChange.Date;
                TempCustChange.Description := CustCalChange.Description;
                TempCustChange.Day := CustCalChange.Day;
                TempCustChange.Nonworking := CustCalChange.Nonworking;
                TempCustChange."Recurring System" := CustCalChange."Recurring System";
                TempCustChange."Entry No." := TempCounter;
                TempCustChange.INSERT;
            UNTIL CustCalChange.NEXT = 0;

        BaseCalChange.RESET;
        BaseCalChange.SETRANGE("Base Calendar Code", CalendarCode);
        IF BaseCalChange.FINDSET THEN
            REPEAT
                TempCounter := TempCounter + 1;
                TempCustChange.INIT;
                TempCustChange."Entry No." := TempCounter;
                TempCustChange."Source Type" := SourceType;
                TempCustChange."Source Code" := SourceCode;
                TempCustChange."Base Calendar Code" := BaseCalChange."Base Calendar Code";
                TempCustChange.Date := BaseCalChange.Date;
                TempCustChange.Description := BaseCalChange.Description;
                TempCustChange.Day := BaseCalChange.Day;
                TempCustChange.Nonworking := BaseCalChange.Nonworking;
                TempCustChange."Recurring System" := BaseCalChange."Recurring System";
                TempCustChange.INSERT;
            UNTIL BaseCalChange.NEXT = 0;

        OldSourceType := SourceType;
        OldSourceCode := SourceCode;
        OldAdditionalSourceCode := AdditionalSourceCode;
        OldCalendarCode := CalendarCode;
    end;


    procedure CreateWhereUsedEntries(BaseCalendarCode: Code[10])
    var
        WhereUsedBaseCalendar: Record 7604;
    begin
        WhereUsedBaseCalendar.DELETEALL;
        IF CompanyInfo.GET THEN
            IF CompanyInfo."Base Calendar Code" = BaseCalendarCode THEN BEGIN
                WhereUsedBaseCalendar.INIT;
                WhereUsedBaseCalendar."Base Calendar Code" := BaseCalendarCode;
                WhereUsedBaseCalendar."Source Type" := WhereUsedBaseCalendar."Source Type"::Company;
                WhereUsedBaseCalendar."Source Name" := CompanyInfo.Name;
                WhereUsedBaseCalendar."Customized Changes Exist" :=
                  CustomizedChangesExist(
                    WhereUsedBaseCalendar."Source Type"::Company, '', '', BaseCalendarCode);
                WhereUsedBaseCalendar.INSERT;
            END;

        Customer.RESET;
        Customer.SETRANGE("Base Calendar Code", BaseCalendarCode);
        IF Customer.FINDSET THEN
            REPEAT
                WhereUsedBaseCalendar.INIT;
                WhereUsedBaseCalendar."Base Calendar Code" := BaseCalendarCode;
                WhereUsedBaseCalendar."Source Type" := WhereUsedBaseCalendar."Source Type"::Customer;
                WhereUsedBaseCalendar."Source Code" := Customer."No.";
                WhereUsedBaseCalendar."Source Name" := Customer.Name;
                WhereUsedBaseCalendar."Customized Changes Exist" :=
                  CustomizedChangesExist(
                    WhereUsedBaseCalendar."Source Type"::Customer, Customer."No.", '', BaseCalendarCode);
                WhereUsedBaseCalendar.INSERT;
            UNTIL Customer.NEXT = 0;

        Vendor.RESET;
        Vendor.SETRANGE("Base Calendar Code", BaseCalendarCode);
        IF Vendor.FINDSET THEN
            REPEAT
                WhereUsedBaseCalendar.INIT;
                WhereUsedBaseCalendar."Base Calendar Code" := BaseCalendarCode;
                WhereUsedBaseCalendar."Source Type" := WhereUsedBaseCalendar."Source Type"::Vendor;
                WhereUsedBaseCalendar."Source Code" := Vendor."No.";
                WhereUsedBaseCalendar."Source Name" := Vendor.Name;
                WhereUsedBaseCalendar."Customized Changes Exist" :=
                  CustomizedChangesExist(
                    WhereUsedBaseCalendar."Source Type"::Vendor, Vendor."No.", '', BaseCalendarCode);
                WhereUsedBaseCalendar.INSERT;
            UNTIL Vendor.NEXT = 0;

        Location.RESET;
        Location.SETRANGE("Base Calendar Code", BaseCalendarCode);
        IF Location.FINDSET THEN
            REPEAT
                WhereUsedBaseCalendar.INIT;
                WhereUsedBaseCalendar."Base Calendar Code" := BaseCalendarCode;
                WhereUsedBaseCalendar."Source Type" := WhereUsedBaseCalendar."Source Type"::Location;
                WhereUsedBaseCalendar."Source Code" := Location.Code;
                WhereUsedBaseCalendar."Source Name" := Location.Name;
                WhereUsedBaseCalendar."Customized Changes Exist" :=
                  CustomizedChangesExist(
                    WhereUsedBaseCalendar."Source Type"::Location, Location.Code, '', BaseCalendarCode);
                WhereUsedBaseCalendar.INSERT;
            UNTIL Location.NEXT = 0;

        Shippingagent.RESET;
        Shippingagent.SETRANGE("Base Calendar Code", BaseCalendarCode);
        IF Shippingagent.FINDSET THEN
            REPEAT
                WhereUsedBaseCalendar.INIT;
                WhereUsedBaseCalendar."Base Calendar Code" := BaseCalendarCode;
                WhereUsedBaseCalendar."Source Type" := WhereUsedBaseCalendar."Source Type"::"Shipping Agent";
                WhereUsedBaseCalendar."Source Code" := Shippingagent."Shipping Agent Code";
                WhereUsedBaseCalendar."Additional Source Code" := Shippingagent.Code;
                WhereUsedBaseCalendar."Source Name" := Shippingagent.Description;
                WhereUsedBaseCalendar."Customized Changes Exist" :=
                  CustomizedChangesExist(
                    WhereUsedBaseCalendar."Source Type"::"Shipping Agent", Shippingagent."Shipping Agent Code",
                    Shippingagent.Code, BaseCalendarCode);
                WhereUsedBaseCalendar.INSERT;
            UNTIL Shippingagent.NEXT = 0;

        IF ServMgtSetup.GET THEN
            IF ServMgtSetup."Base Calendar Code" = BaseCalendarCode THEN BEGIN
                WhereUsedBaseCalendar.INIT;
                WhereUsedBaseCalendar."Base Calendar Code" := BaseCalendarCode;
                WhereUsedBaseCalendar."Source Type" := WhereUsedBaseCalendar."Source Type"::Service;
                WhereUsedBaseCalendar."Source Name" := ServMgtSetup.TABLECAPTION;
                WhereUsedBaseCalendar."Customized Changes Exist" :=
                  CustomizedChangesExist(
                    WhereUsedBaseCalendar."Source Type"::Service, '', '', BaseCalendarCode);
                WhereUsedBaseCalendar.INSERT;
            END;

        COMMIT;
    end;


    procedure CustomizedChangesExist(SourceType: Option Company,Customer,Vendor,Location,"Shipping Agent",Service; SourceCode: Code[20]; AdditionalSourceCode: Code[20]; BaseCalendarCode: Code[10]): Boolean
    begin
        CustCalChange.RESET;
        CustCalChange.SETRANGE("Source Type", SourceType);
        CustCalChange.SETRANGE("Source Code", SourceCode);
        CustCalChange.SETRANGE("Additional Source Code", AdditionalSourceCode);
        CustCalChange.SETRANGE("Base Calendar Code", BaseCalendarCode);
        IF CustCalChange.FINDFIRST THEN
            EXIT(TRUE);
    end;


    procedure CustomizedCalendarExistText(SourceType: Option Company,Customer,Vendor,Location,"Shipping Agent",Service; SourceCode: Code[20]; AdditionalSourceCode: Code[20]; BaseCalendarCode: Code[10]): Text[10]
    begin
        IF CustomizedChangesExist(SourceType, SourceCode, AdditionalSourceCode, BaseCalendarCode) THEN
            EXIT(Text001);
        EXIT(Text002);
    end;


    procedure CalcDateBOC(OrgDateExpression: Text[30]; OrgDate: Date; FirstSourceType: Option Company,Customer,Vendor,Location,"Shipping Agent",Service; FirstSourceCode: Code[20]; FirstAddCode: Code[20]; SecondSourceType: Option Company,Customer,Vendor,Location,"Shipping Agent",Service; SecondSourceCode: Code[20]; SecondAddCode: Code[20]; CheckBothCalendars: Boolean): Date
    var
        FirstCalCode: Code[10];
        SecondCalCode: Code[10];
        LoopTerminator: Boolean;
        LoopCounter: Integer;
        NewDate: Date;
        TempDesc: Text[30];
        Nonworking: Boolean;
        Nonworking2: Boolean;
        LoopFactor: Integer;
        CalConvTimeFrame: Integer;
        DateFormula: DateFormula;
        Ok: Boolean;
        NegDateFormula: DateFormula;
    begin
        IF (FirstSourceType = FirstSourceType::"Shipping Agent") AND
           ((FirstSourceCode = '') OR (FirstAddCode = ''))
        THEN BEGIN
            FirstSourceType := FirstSourceType::Company;
            FirstSourceCode := '';
            FirstAddCode := '';
        END;
        IF (SecondSourceType = SecondSourceType::"Shipping Agent") AND
           ((SecondSourceCode = '') OR (SecondAddCode = ''))
        THEN BEGIN
            SecondSourceType := SecondSourceType::Company;
            SecondSourceCode := '';
            SecondAddCode := '';
        END;
        IF (FirstSourceType = FirstSourceType::Location) AND
           (FirstSourceCode = '')
        THEN BEGIN
            FirstSourceType := FirstSourceType::Company;
            FirstSourceCode := '';
        END;
        IF (SecondSourceType = SecondSourceType::Location) AND
           (SecondSourceCode = '')
        THEN BEGIN
            SecondSourceType := SecondSourceType::Company;
            SecondSourceCode := '';
        END;
        IF CompanyInfo.GET THEN
            CalConvTimeFrame := CALCDATE(CompanyInfo."Cal. Convergence Time Frame", WORKDATE) - WORKDATE;

        FirstCalCode := GetCalendarCode(FirstSourceType, FirstSourceCode, FirstAddCode);
        SecondCalCode := GetCalendarCode(SecondSourceType, SecondSourceCode, SecondAddCode);

        IF (OldSourceType = 0) AND (OldSourceCode = '') AND (OldAdditionalSourceCode = '') AND (OldCalendarCode = '') THEN BEGIN
            TempCustChange.RESET;
            TempCustChange.DELETEALL;
        END;

        EVALUATE(DateFormula, OrgDateExpression);
        EVALUATE(NegDateFormula, '<-0D>');

        IF OrgDate = 0D THEN
            OrgDate := WORKDATE;
        IF (CALCDATE(DateFormula, OrgDate) >= OrgDate) AND (DateFormula <> NegDateFormula) THEN
            LoopFactor := 1
        ELSE
            LoopFactor := -1;

        NewDate := OrgDate;
        IF CALCDATE(DateFormula, OrgDate) <> OrgDate THEN
            REPEAT
                NewDate := NewDate + LoopFactor;
                IF CheckBothCalendars AND (FirstCalCode = '') AND (SecondCalCode <> '') THEN
                    Ok := NOT CheckCustomizedDateStatus(
                        SecondSourceType, SecondSourceCode, SecondAddCode, SecondCalCode, NewDate, TempDesc)
                ELSE
                    Ok := NOT CheckCustomizedDateStatus(
                        FirstSourceType, FirstSourceCode, FirstAddCode, FirstCalCode, NewDate, TempDesc);
                IF Ok THEN
                    LoopCounter := LoopCounter + 1;
                IF NewDate >= OrgDate + CalConvTimeFrame THEN
                    LoopCounter := ABS(CALCDATE(DateFormula, OrgDate) - OrgDate);
            UNTIL LoopCounter = ABS(CALCDATE(DateFormula, OrgDate) - OrgDate);

        LoopCounter := 0;
        REPEAT
            LoopCounter := LoopCounter + 1;
            Nonworking :=
              CheckCustomizedDateStatus(
                FirstSourceType, FirstSourceCode, FirstAddCode, FirstCalCode, NewDate, TempDesc);
            Nonworking2 :=
              CheckCustomizedDateStatus(
                SecondSourceType, SecondSourceCode, SecondAddCode, SecondCalCode, NewDate, TempDesc);
            IF Nonworking THEN BEGIN
                NewDate := NewDate + LoopFactor;
            END ELSE BEGIN
                IF NOT CheckBothCalendars THEN
                    EXIT(NewDate);

                IF (Nonworking = FALSE) AND
                   (Nonworking2 = FALSE)
                THEN
                    EXIT(NewDate);

                NewDate := NewDate + LoopFactor;
            END;
            IF LoopCounter >= CalConvTimeFrame THEN
                LoopTerminator := TRUE;
        UNTIL LoopTerminator = TRUE;
        EXIT(NewDate);
    end;


    procedure CalcDateBOC2(OrgDateExpression: Text[30]; OrgDate: Date; FirstSourceType: Option Company,Customer,Vendor,Location,"Shipping Agent",Service; FirstSourceCode: Code[20]; FirstAddCode: Code[20]; SecondSourceType: Option Company,Customer,Vendor,Location,"Shipping Agent",Service; SecondSourceCode: Code[20]; SecondAddCode: Code[20]; CheckBothCalendars: Boolean): Date
    var
        NewOrgDateExpression: Text[30];
    begin
        // Use this procedure to subtract time expression.
        NewOrgDateExpression := ReverseSign(OrgDateExpression);
        EXIT(CalcDateBOC(NewOrgDateExpression, OrgDate, FirstSourceType, FirstSourceCode, FirstAddCode,
            SecondSourceType, SecondSourceCode, SecondAddCode, CheckBothCalendars));
    end;

    local procedure ReverseSign(DateFormulaExpr: Text[30]): Text[30]
    var
        NewDateFormulaExpr: Text[30];
        Formula: DateFormula;
    begin
        EVALUATE(Formula, DateFormulaExpr);
        NewDateFormulaExpr := CONVERTSTR(FORMAT(Formula), '+-', '-+');
        IF NOT (DateFormulaExpr[1] IN ['+', '-']) THEN
            NewDateFormulaExpr := '-' + NewDateFormulaExpr;
        EXIT(NewDateFormulaExpr);
    end;


    procedure CheckDateFormulaPositive(CurrentDateFormula: DateFormula)
    begin
        IF CALCDATE(CurrentDateFormula) < TODAY THEN
            ERROR(Text003, CurrentDateFormula);
    end;


    procedure CalcTimeDelta(EndingTime: Time; StartingTime: Time) Result: Integer
    begin
        Result := EndingTime - StartingTime;
        IF (Result <> 0) AND (EndingTime = 235959T) THEN
            Result += 1000;
    end;


    procedure CalcTimeSubtract(Time: Time; Value: Integer) Result: Time
    begin
        Result := Time - Value;
        IF (Result <> 000000T) AND (Time = 235959T) AND (Value <> 0) THEN
            Result += 1000;
    end;

    procedure DeleteCustomizedBaseCalendarData(SourceType: Option; SourceCode: Code[20])
    var
        CustomizedCalendarChange: Record 7602;
        CustomizedCalendarEntry: Record 7603;
        WhereUsedBaseCalendar: Record 7604;
    begin
        CustomizedCalendarChange.SETRANGE("Source Type", SourceType);
        CustomizedCalendarChange.SETRANGE("Source Code", SourceCode);
        CustomizedCalendarChange.DELETEALL;

        CustomizedCalendarEntry.SETRANGE("Source Type", SourceType);
        CustomizedCalendarEntry.SETRANGE("Source Code", SourceCode);
        CustomizedCalendarEntry.DELETEALL;

        WhereUsedBaseCalendar.SETRANGE("Source Type", SourceType);
        WhereUsedBaseCalendar.SETRANGE("Source Code", SourceCode);
        WhereUsedBaseCalendar.DELETEALL;
    end;

    procedure RenameCustomizedBaseCalendarData(SourceType: Option; SourceCode: Code[20]; xSourceCode: Code[20])
    var
        CustomizedCalendarChange: Record 7602;
        TempCustomizedCalendarChange: Record 7602 temporary;
        CustomizedCalendarEntry: Record 7603;
        TempCustomizedCalendarEntry: Record 7603 temporary;
        WhereUsedBaseCalendar: Record 7604;
        TempWhereUsedBaseCalendar: Record 7604 temporary;
    begin
        CustomizedCalendarChange.SETRANGE("Source Type", SourceType);
        CustomizedCalendarChange.SETRANGE("Source Code", xSourceCode);
        IF CustomizedCalendarChange.FINDSET THEN
            REPEAT
                TempCustomizedCalendarChange := CustomizedCalendarChange;
                TempCustomizedCalendarChange.INSERT;
            UNTIL CustomizedCalendarChange.NEXT = 0;
        IF TempCustomizedCalendarChange.FINDSET THEN
            REPEAT
                CLEAR(CustomizedCalendarChange);
                CustomizedCalendarChange := TempCustomizedCalendarChange;
                CustomizedCalendarChange.RENAME(
                  CustomizedCalendarChange."Source Type",
                  SourceCode,
                  CustomizedCalendarChange."Additional Source Code",
                  CustomizedCalendarChange."Base Calendar Code",
                  CustomizedCalendarChange."Recurring System",
                  CustomizedCalendarChange.Date,
                  CustomizedCalendarChange.Day,
                  CustomizedCalendarChange."Entry No.");
            UNTIL TempCustomizedCalendarChange.NEXT = 0;

        CustomizedCalendarEntry.SETRANGE("Source Type", SourceType);
        CustomizedCalendarEntry.SETRANGE("Source Code", xSourceCode);
        IF CustomizedCalendarEntry.FINDSET(TRUE, TRUE) THEN
            REPEAT
                TempCustomizedCalendarEntry := CustomizedCalendarEntry;
                TempCustomizedCalendarEntry.INSERT;
            UNTIL CustomizedCalendarEntry.NEXT = 0;
        IF TempCustomizedCalendarEntry.FINDSET THEN
            REPEAT
                CLEAR(CustomizedCalendarEntry);
                CustomizedCalendarEntry := TempCustomizedCalendarEntry;
                CustomizedCalendarEntry.RENAME(
                  CustomizedCalendarEntry."Source Type",
                  SourceCode,
                  CustomizedCalendarEntry."Additional Source Code",
                  CustomizedCalendarEntry."Base Calendar Code",
                  CustomizedCalendarEntry.Date);
            UNTIL TempCustomizedCalendarEntry.NEXT = 0;

        WhereUsedBaseCalendar.SETRANGE("Source Type", SourceType);
        WhereUsedBaseCalendar.SETRANGE("Source Code", xSourceCode);
        IF WhereUsedBaseCalendar.FINDSET(TRUE, TRUE) THEN
            REPEAT
                TempWhereUsedBaseCalendar := WhereUsedBaseCalendar;
                TempWhereUsedBaseCalendar.INSERT;
            UNTIL WhereUsedBaseCalendar.NEXT = 0;
        IF TempWhereUsedBaseCalendar.FINDSET(TRUE, TRUE) THEN
            REPEAT
                CLEAR(WhereUsedBaseCalendar);
                WhereUsedBaseCalendar := TempWhereUsedBaseCalendar;
                WhereUsedBaseCalendar.RENAME(
                  WhereUsedBaseCalendar."Base Calendar Code",
                  WhereUsedBaseCalendar."Source Type",
                  SourceCode,
                  WhereUsedBaseCalendar."Source Name");
            UNTIL TempWhereUsedBaseCalendar.NEXT = 0;
    end;

    procedure ReverseDateFormula(var ReversedDateFormula: DateFormula; DateFormula: DateFormula)
    var
        DateFormulaAsText: Text;
        ReversedDateFormulaAsText: Text;
        SummandPositions: array[100] of Integer;
        i: Integer;
        j: Integer;
    begin
        CLEAR(ReversedDateFormula);
        DateFormulaAsText := FORMAT(DateFormula);
        IF DateFormulaAsText = '' THEN
            EXIT;

        IF NOT (COPYSTR(DateFormulaAsText, 1, 1) IN ['+', '-']) THEN
            DateFormulaAsText := '+' + DateFormulaAsText;

        FOR i := 1 TO STRLEN(DateFormulaAsText) DO
            IF DateFormulaAsText[i] IN ['+', '-'] THEN BEGIN
                SummandPositions[j + 1] := i;
                j += 1;
                IF DateFormulaAsText[i] = '+' THEN
                    DateFormulaAsText[i] := '-'
                ELSE
                    DateFormulaAsText[i] := '+';
            END;

        FOR i := j DOWNTO 1 DO BEGIN
            IF i = j THEN
                ReversedDateFormulaAsText := COPYSTR(DateFormulaAsText, SummandPositions[i])
            ELSE
                ReversedDateFormulaAsText :=
                  ReversedDateFormulaAsText + COPYSTR(DateFormulaAsText, SummandPositions[i], SummandPositions[i + 1] - SummandPositions[i]);
        END;

        EVALUATE(ReversedDateFormula, ReversedDateFormulaAsText);
    end;
}

