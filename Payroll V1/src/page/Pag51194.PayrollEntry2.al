page 51194 "Payroll Entry2"
{
    PageType = ListPart;
    Permissions = TableData 51159 = rimd,
                  TableData 51161 = rimd,
                  TableData 51166 = rimd;
    PopulateAllFields = true;
    SourceTable = 51161;

    layout
    {
        area(content)
        {
            repeater(r)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Payroll ID"; Rec."Payroll ID")
                {
                    Editable = "Payroll IDEditable";
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    Editable = "Employee No.Editable";
                    TableRelation = "Payroll Header"."Employee no.";
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        EmployeeNoOnAfterValidate;
                    end;
                }
                field("ED Code"; Rec."ED Code")
                {
                    Editable = "ED CodeEditable";
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    Editable = DateEditable;
                    ApplicationArea = All;
                }
                field(Text; Rec.Text)
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    Editable = QuantityEditable;
                    ApplicationArea = All;
                }
                field(Rate; Rec.Rate)
                {
                    Editable = RateEditable;
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    Editable = AmountEditable;
                    ApplicationArea = All;
                }
                field(Interest; Rec.Interest)
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Repayment; Rec.Repayment)
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Remaining Debt"; Rec."Remaining Debt")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Paid; Rec.Paid)
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Loan ID"; Rec."Loan ID")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Loan Entry No"; Rec."Loan Entry No")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Copy to next"; Rec."Copy to next")
                {
                    Editable = "Copy to nextEditable";
                    ApplicationArea = All;
                }
                field("Reset Amount"; Rec."Reset Amount")
                {
                    Editable = "Reset AmountEditable";
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        IF (Rec."Payroll ID" <> '') AND (Rec."Employee No." <> '') THEN BEGIN
            Header.GET(Rec."Payroll ID", Rec."Employee No.");
            IF Header.Calculated = TRUE THEN BEGIN
                Header.Calculated := FALSE;
                Header.MODIFY;
            END
        END;
    end;

    trigger OnInit()
    begin
        "Employee No.Editable" := TRUE;
        "Payroll IDEditable" := TRUE;
        "Reset AmountEditable" := TRUE;
        "Copy to nextEditable" := TRUE;
        AmountEditable := TRUE;
        RateEditable := TRUE;
        QuantityEditable := TRUE;
        "ED CodeEditable" := TRUE;
        DateEditable := TRUE;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        IF (Rec."Payroll ID" <> '') AND (Rec."Employee No." <> '') THEN BEGIN
            Header.GET(Rec."Payroll ID", Rec."Employee No.");
            IF Header.Calculated = TRUE THEN BEGIN
                Header.Calculated := FALSE;
                Header.MODIFY;
            END;
        END;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        IF (Rec."Payroll ID" <> '') AND (Rec."Employee No." <> '') THEN BEGIN
            Header.GET(Rec."Payroll ID", Rec."Employee No.");
            IF Header.Calculated = TRUE THEN BEGIN
                Header.Calculated := FALSE;
                Header.MODIFY;
            END
        END;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        IF Entrys.FIND('+') THEN MaxEntry := Entrys."Entry No.";
        MaxEntry := MaxEntry + 1;
        Rec."Entry No." := MaxEntry;
        Rec."Payroll ID" := Entrys."Payroll ID";
        Rec.Date := TODAY;
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        IF Entrys.FIND('+') THEN
            MaxEntry := Entrys."Entry No."
        ELSE
            MaxEntry := 0;

        Rec.SETCURRENTKEY(Rec."Payroll ID", Rec."Employee No.", Rec."ED Code");
        gsSegmentPayrollData;
    end;

    var
        Header: Record 51159;
        Entrys: Record 51161;
        MaxEntry: Integer;
        gvAllowedPayrolls: Record 51182;
        [InDataSet]
        DateEditable: Boolean;
        [InDataSet]
        "ED CodeEditable": Boolean;
        [InDataSet]
        QuantityEditable: Boolean;
        [InDataSet]
        RateEditable: Boolean;
        [InDataSet]
        AmountEditable: Boolean;
        [InDataSet]
        "Copy to nextEditable": Boolean;
        [InDataSet]
        "Reset AmountEditable": Boolean;
        [InDataSet]
        "Payroll IDEditable": Boolean;
        [InDataSet]
        "Employee No.Editable": Boolean;

    local procedure EmployeeNoOnAfterValidate()
    begin
        IF Rec."ED Code" <> '' THEN Rec.VALIDATE("ED Code");
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        IF Editable THEN BEGIN
            DateEditable := TRUE;
            "ED CodeEditable" := TRUE;
            QuantityEditable := TRUE;
            RateEditable := TRUE;
            AmountEditable := TRUE;
            "Copy to nextEditable" := TRUE;
            "Reset AmountEditable" := TRUE;
            "Payroll IDEditable" := TRUE;
            "Employee No.Editable" := TRUE;
        END ELSE BEGIN
            DateEditable := FALSE;
            "ED CodeEditable" := FALSE;
            QuantityEditable := TRUE;
            RateEditable := TRUE;
            AmountEditable := TRUE;
            "Copy to nextEditable" := FALSE;
            "Reset AmountEditable" := FALSE;
            "Payroll IDEditable" := FALSE;
            "Employee No.Editable" := FALSE;
        END;
    end;

    procedure gsSegmentPayrollData()
    var
        lvAllowedPayrolls: Record 51182;
        lvPayrollUtilities: Codeunit 51152;
        UsrID: Code[10];
        UsrID2: Code[10];
        StringLen: Integer;
        lvActiveSession: Record 2000000110;
    begin
        /*lvSession.SETRANGE("My Session", TRUE);
        lvSession.FINDFIRST; //fire error in absence of a login
        IF lvSession."Login Type" = lvSession."Login Type"::Database THEN
          lvAllowedPayrolls.SETRANGE("User ID", USERID)
        ELSE*/

        lvActiveSession.RESET;
        lvActiveSession.SETRANGE("Server Instance ID", SERVICEINSTANCEID);
        lvActiveSession.SETRANGE("Session ID", SESSIONID);
        lvActiveSession.FINDFIRST;


        lvAllowedPayrolls.SETRANGE("User ID", lvActiveSession."User ID");
        lvAllowedPayrolls.SETRANGE("Last Active Payroll", TRUE);
        IF lvAllowedPayrolls.FINDFIRST THEN
            Rec.SETRANGE("Payroll Code", lvAllowedPayrolls."Payroll Code")
        ELSE
            ERROR('You are not allowed access to this payroll dataset.');
        Rec.FILTERGROUP(100);

    end;
}

