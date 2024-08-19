page 50096 "Closed Req. for Quotation List"
{
    CardPageID = "Request for Quotation Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;

    ModifyAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50049;
    SourceTableView = SORTING("No.")
                      ORDER(Descending)
                      WHERE(Status = CONST(Closed));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Closing Date"; Rec."Closing Date")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    procedure InsertRFQLines()
    var
        Counter: Integer;
        RFQLine: Record 50050;
        RequisitionLine: Page 50084;
    begin
        /*RequisitionLine.LOOKUPMODE(TRUE);
        IF RequisitionList.RUNMODAL = ACTION::LookupOK THEN BEGIN
          RequisitionList.SetSelection(RFQLine);
          Counter :=RFQLine.COUNT;
          IF Counter > 0 THEN BEGIN
            IF RFQLine.FINDSET THEN
              REPEAT
                Lines.INIT;
                Lines.TRANSFERFIELDS(RFQLine);
                Lines."Document Type":="Document Type";
                Lines."Document No.":="No.";
                Lines."Line No.":=0;
                Lines."PRF No":=RFQLine."Document No.";
                Lines."PRF Line No.":=RFQLine."Line No.";
                Lines.INSERT(TRUE);
             UNTIL RFQLine.NEXT = 0;
          END;
        END;*/

    end;
}

