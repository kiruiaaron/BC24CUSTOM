page 51161 "ED Definitions List"
{
    Editable = false;
    PageType = Card;
    SourceTable = 51158;

    layout
    {
        area(content)
        {
            repeater(r)
            {
                field("ED Code"; Rec."ED Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Payroll Code"; Rec."Payroll Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(ED)
            {
                Caption = 'ED';
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(39012009),
                                  "No." = FIELD("ED Code");
                    ShortCutKey = 'Shift+Ctrl+D';
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        "Debit/CreditVisible" := TRUE;
        "Global Dimension 2 CodeVisible" := TRUE;
        "Global Dimension 1 CodeVisible" := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        OnActivateForm;
        gsSegmentPayrollData;
    end;

    var
        [InDataSet]
        "ED Posting GroupVisible": Boolean;
        [InDataSet]
        "Account NoVisible": Boolean;
        [InDataSet]
        "Global Dimension 1 CodeVisible": Boolean;
        [InDataSet]
        "Global Dimension 2 CodeVisible": Boolean;
        [InDataSet]
        "Debit/CreditVisible": Boolean;

    procedure ShowFields()
    begin


        "ED Posting GroupVisible" := FALSE;
        "Account NoVisible" := FALSE;
        "Global Dimension 1 CodeVisible" := FALSE;
        "Global Dimension 2 CodeVisible" := FALSE;
        "Debit/CreditVisible" := FALSE;

        CASE Rec."Posting type" OF
            Rec."Posting type"::"G/L Account":
                "ED Posting GroupVisible" := TRUE;
            Rec."Posting type"::Direct:
                BEGIN
                    "Account NoVisible" := TRUE;
                    "Global Dimension 1 CodeVisible" := TRUE;
                    "Global Dimension 2 CodeVisible" := TRUE;
                    "Debit/CreditVisible" := TRUE;
                END;
            Rec."Posting type"::Customer:
                BEGIN
                    "Account NoVisible" := TRUE;
                    "Global Dimension 1 CodeVisible" := TRUE;
                    "Global Dimension 2 CodeVisible" := TRUE;
                    "Debit/CreditVisible" := TRUE;
                END;
            Rec."Posting type"::Vendor:
                BEGIN
                    "Account NoVisible" := TRUE;
                    "Global Dimension 1 CodeVisible" := TRUE;
                    "Global Dimension 2 CodeVisible" := TRUE;
                    "Debit/CreditVisible" := TRUE;
                END;
        END;
    end;

    local procedure PostingtypeOnAfterValidate()
    begin
        ShowFields;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        ShowFields;
    end;

    local procedure OnActivateForm()
    begin
        ShowFields;
    end;

    local procedure PostingtypeOnInputChange(var Text: Text[1024])
    begin
        ShowFields;
    end;

    local procedure gsSegmentPayrollData()
    var
        lvAllowedPayrolls: Record 51182;
        lvPayrollUtilities: Codeunit 51152;
        UsrID: Code[10];
        UsrID2: Code[10];
        StringLen: Integer;
        lvActiveSession: Record 2000000110;
    begin
        /*lvActiveSession.RESET;
        lvActiveSession.SETRANGE("Server Instance ID",SERVICEINSTANCEID);
        lvActiveSession.SETRANGE("Session ID",SESSIONID);
        lvActiveSession.FINDFIRST;
        
        
        lvAllowedPayrolls.SETRANGE("User ID", lvActiveSession."User ID");
        lvAllowedPayrolls.SETRANGE("Last Active Payroll", TRUE);
        IF lvAllowedPayrolls.FINDFIRST THEN
         Rec. SETRANGE("Payroll Code", lvAllowedPayrolls."Payroll Code")
        ELSE
          ERROR('You are not allowed access to this payroll dataset.');
        FILTERGROUP(100);*/

    end;
}

