table 50030 "Funds Management Cue"
{
    Caption = 'Funds Manager Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "User Id Filter"; Text[50])
        {
            CalcFormula = Lookup(Session."User ID" WHERE("My Session" = CONST(true)));
            FieldClass = FlowField;
        }
        field(10; "Open Payments"; Integer)
        {
            CalcFormula = Count("Payment Header" WHERE(Status = FILTER(<> Posted),
                                                        "Payment Mode" = CONST(Cheque)));
            Caption = 'Open Payments';
            FieldClass = FlowField;
        }
        field(11; "Payments Pending Approval"; Integer)
        {
            CalcFormula = Count("Payment Header" WHERE(Status = CONST("Pending Approval"),
                                                        "Payment Mode" = CONST(Cheque)));
            Caption = 'Payments Pending Approval';
            FieldClass = FlowField;
        }
        field(12; "Approved Payments"; Integer)
        {
            CalcFormula = Count("Payment Header" WHERE(Status = CONST(Approved),
                                                        "Payment Mode" = CONST(Cheque)));
            Caption = 'Approved Payments';
            FieldClass = FlowField;
        }
        field(13; "Rejected Payments"; Integer)
        {
            CalcFormula = Count("Payment Header" WHERE(Status = CONST(Rejected),
                                                        "Payment Mode" = CONST(Cheque)));
            Caption = 'Rejected Payments';
            FieldClass = FlowField;
        }
        field(14; "Posted Payments"; Integer)
        {
            CalcFormula = Count("Payment Header" WHERE(Status = CONST(Posted),
                                                        "Payment Mode" = CONST(Cheque)));
            Caption = 'Posted Payments';
            FieldClass = FlowField;
        }
        field(15; "Reversed Payments"; Integer)
        {
            CalcFormula = Count("Payment Header" WHERE(Status = CONST(Reversed),
                                                        "Payment Mode" = CONST(Cheque)));
            Caption = 'Reversed Payments';
            FieldClass = FlowField;
        }
        field(16; "Open Cash Payments"; Integer)
        {
            CalcFormula = Count("Payment Header" WHERE(Status = FILTER(<> Posted),
                                                        "Payment Mode" = CONST(Cash)));
            Caption = 'Cash Payments';
            FieldClass = FlowField;
        }
        field(20; "Posted Cash Payments"; Integer)
        {
            CalcFormula = Count("Payment Header" WHERE(Status = CONST(Posted),
                                                        "Payment Mode" = CONST(Cash)));
            Caption = 'Posted Cash Payments';
            FieldClass = FlowField;
        }
        field(21; "Reversed Cash Payments"; Integer)
        {
            CalcFormula = Count("Payment Header" WHERE(Status = CONST(Reversed),
                                                        "Payment Mode" = CONST(Cash)));
            Caption = 'Reversed Cash Payments';
            FieldClass = FlowField;
        }
        field(29; "Payment Codes"; Integer)
        {
            CalcFormula = Count("Funds Transaction Code" WHERE("Transaction Type" = CONST(Payment)));
            Caption = 'Payment Codes';
            FieldClass = FlowField;
        }
        field(30; Receipts; Integer)
        {
            CalcFormula = Count("Receipt Header" WHERE(Status = FILTER(<> Posted)));
            Caption = 'Receipts';
            FieldClass = FlowField;
        }
        field(34; "Posted Receipts"; Integer)
        {
            CalcFormula = Count("Receipt Header" WHERE(Status = CONST(Posted)));
            Caption = 'Posted Receipts';
            FieldClass = FlowField;
        }
        field(39; "Receipt Codes"; Integer)
        {
            CalcFormula = Count("Funds Transaction Code" WHERE("Transaction Type" = CONST(Receipt)));
            Caption = 'Receipt Codes';
            FieldClass = FlowField;
        }
        field(40; Imprests; Integer)
        {
            CalcFormula = Count("Imprest Header" WHERE(Status = FILTER(<> Posted)));
            Caption = 'Imprests';
            FieldClass = FlowField;
        }
        field(44; "Posted Imprests"; Integer)
        {
            CalcFormula = Count("Imprest Header" WHERE(Status = CONST(Posted)));
            Caption = 'Posted Imprests';
            FieldClass = FlowField;
        }
        field(45; "Reversed Imprests"; Integer)
        {
            CalcFormula = Count("Imprest Header" WHERE(Status = CONST(Reversed)));
            Caption = 'Reversed Imprests';
            FieldClass = FlowField;
        }
        field(46; "Imprest Surrenders"; Integer)
        {
            CalcFormula = Count("Imprest Surrender Header" WHERE(Status = FILTER(<> Posted)));
            Caption = 'Imprest Surrenders';
            FieldClass = FlowField;
        }
        field(50; "Posted Imprest Surrenders"; Integer)
        {
            CalcFormula = Count("Imprest Surrender Header" WHERE(Status = CONST(Posted)));
            Caption = 'Posted Imprest Surrenders';
            FieldClass = FlowField;
        }
        field(51; "Reversed Imprest Surrenders"; Integer)
        {
            CalcFormula = Count("Imprest Surrender Header" WHERE(Status = CONST(Reversed)));
            Caption = 'Reversed Imprest Surrenders';
            FieldClass = FlowField;
        }
        field(59; "Imprest Codes"; Integer)
        {
            CalcFormula = Count("Funds Transaction Code" WHERE("Transaction Type" = CONST(Imprest)));
            Caption = 'Imprest Codes';
            FieldClass = FlowField;
        }
        field(60; "Funds Transfer"; Integer)
        {
            CalcFormula = Count("Funds Transfer Header" WHERE(Status = FILTER(<> Posted)));
            Caption = 'Funds Transfer';
            FieldClass = FlowField;
        }
        field(64; "Posted Funds Transfer"; Integer)
        {
            CalcFormula = Count("Funds Transfer Header" WHERE(Status = CONST(Posted)));
            Caption = 'Posted Funds Transfer';
            FieldClass = FlowField;
        }
        field(5000; "Purchase Invoices"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST(Invoice)));
            // "User ID" = FIELD("User Id Filter")));
            FieldClass = FlowField;
        }
        field(5004; "Posted Purchase Invoices"; Integer)
        {
            CalcFormula = Count("Purch. Inv. Header" WHERE("User ID" = FIELD("User Id Filter")));
            FieldClass = FlowField;
        }
        field(5006; "Purchase Cr. Memos"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST("Credit Memo")));
            // "User ID" = FIELD("User Id Filter")));
            FieldClass = FlowField;
        }
        field(5020; "Posted Purchase Cr. Memos"; Integer)
        {
            CalcFormula = Count("Purch. Cr. Memo Hdr." WHERE("User ID" = FIELD("User Id Filter")));
            FieldClass = FlowField;
        }
        field(6000; "Sales Invoices"; Integer)
        {
            CalcFormula = Count("Sales Header" WHERE("Document Type" = CONST(Invoice),
                                                      "Assigned User ID" = FIELD("User Id Filter")));
            FieldClass = FlowField;
        }
        field(6004; "Posted Sales Invoices"; Integer)
        {
            CalcFormula = Count("Sales Invoice Header" WHERE("User ID" = FIELD("User Id Filter")));
            FieldClass = FlowField;
        }
        field(6006; "Sales Cr. Memos"; Integer)
        {
            CalcFormula = Count("Sales Header" WHERE("Document Type" = CONST("Credit Memo"),
                                                      "Assigned User ID" = FIELD("User Id Filter")));
            FieldClass = FlowField;
        }
        field(6020; "Posted Sales Cr. Memos"; Integer)
        {
            CalcFormula = Count("Sales Cr.Memo Header" WHERE("User ID" = FIELD("User Id Filter")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}

