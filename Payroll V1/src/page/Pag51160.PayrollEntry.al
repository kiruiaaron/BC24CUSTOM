page 51160 "Payroll Entry"
{
    PageType = List;
    Permissions = TableData 51159 = rimd,
                  TableData 51160 = rimd,
                  TableData 51172 = rimd;
    PopulateAllFields = true;
    RefreshOnActivate = true;
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
                    Editable = true;
                    Visible = true;
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    Editable = true;
                    Visible = true;
                    ApplicationArea = All;
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
                field("ED Expiry Date"; Rec."ED Expiry Date")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Text; Rec.Text)
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    Editable = QuantityEditable;
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Rate; REC.Rate)
                {
                    Editable = RateEditable;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Rate (LCY)"; Rec."Rate (LCY)")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Interest; Rec.Interest)
                {
                    Editable = true;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Interest (LCY)"; Rec."Interest (LCY)")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Repayment; Rec.Repayment)
                {
                    Editable = true;
                    Visible = true;
                    ApplicationArea = All;
                }
                field("Repayment (LCY)"; Rec."Repayment (LCY)")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Remaining Debt"; Rec."Remaining Debt")
                {
                    Editable = true;
                    Visible = true;
                    ApplicationArea = All;
                }
                field("Remaining Debt (LCY)"; Rec."Remaining Debt (LCY)")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Paid; Rec.Paid)
                {
                    Editable = true;
                    Visible = true;
                    ApplicationArea = All;
                }
                field("Paid (LCY)"; Rec."Paid (LCY)")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Loan ID"; Rec."Loan ID")
                {
                    Editable = true;
                    Visible = true;
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
                    ApplicationArea = All;
                }
                field("Reset Amount"; Rec."Reset Amount")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Staff Vendor Entry"; Rec."Staff Vendor Entry")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Line)
            {
                Caption = 'Line';
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #39012010. Unsupported part was commented. Please check it.
                        /*CurrPage.PayrollEntries.PAGE.*/
                        ShowDims;

                    end;
                }
                action("Import Payroll")
                {
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = All;
                    //  RunObject = XMLport 50019;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Header.GET(Rec."Payroll ID", Rec."Employee No.");
        IF Header.Calculated = TRUE THEN BEGIN
            Header.Calculated := FALSE;
            Header.MODIFY;
        END;
    end;

    trigger OnInit()
    begin
        /*"Reset AmountEditable" := TRUE;
        "Copy to nextEditable" := TRUE;
        AmountEditable := TRUE;
        RateEditable := TRUE;
        QuantityEditable := TRUE;
        "ED CodeEditable" := TRUE;
        DateEditable := TRUE;*/

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        MaxEntry := MaxEntry + 1;
        Header.GET(Rec."Payroll ID", Rec."Employee No.");
        IF Header.Calculated = TRUE THEN BEGIN
            Header.Calculated := FALSE;
            Header.MODIFY;
        END;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        Header.GET(Rec."Payroll ID", Rec."Employee No.");
        IF Header.Calculated = TRUE THEN BEGIN
            Header.Calculated := FALSE;
            Header.MODIFY;
        END;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Entry No." := MaxEntry + 1;
        Rec.Date := TODAY;
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        Rec.SETCURRENTKEY("Payroll ID", "Employee No.", "ED Code");

        IF Entrys.FIND('+') THEN
            MaxEntry := Entrys."Entry No."
        ELSE
            MaxEntry := 0;
        gsSegmentPayrollData; //skm150506
    end;

    var
        Header: Record 51159;
        Entrys: Record 51161;
        MaxEntry: Integer;
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

    procedure ShowDims()
    begin
        Rec.ShowDimensions;
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

        END ELSE BEGIN
            DateEditable := FALSE;
            "ED CodeEditable" := FALSE;
            QuantityEditable := TRUE;
            RateEditable := TRUE;
            AmountEditable := TRUE;
            "Copy to nextEditable" := FALSE;
            "Reset AmountEditable" := FALSE;
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

