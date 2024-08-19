table 50052 "Bid Analysis"
{

    fields
    {
        field(1; "Request for Quotation No.";
        Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Quote No."; Code[20])
        {
        }
        field(4; "Vendor No."; Code[20])
        {
        }
        field(5; "Item No."; Code[20])
        {
        }
        field(6; Description; Text[100])
        {
        }
        field(7; Quantity; Decimal)
        {
        }
        field(8; "Unit Of Measure"; Code[20])
        {
        }
        field(9; Amount; Decimal)
        {
        }
        field(10; "Line Amount"; Decimal)
        {
        }
        field(11; Total; Decimal)
        {
        }
        /*  field(12; "Last Direct Cost"; Decimal)
         {
             CalcFormula = Lookup(Item."Last Direct Cost" WHERE("No.".=FIELD("Item No.")));
             FieldClass = FlowField;
         } */
        field(13; Remarks; Text[50])
        {
        }
        field(70; Status; Option)
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Released,Rejected,Closed';
            OptionMembers = Open,"Pending Approval",Released,Rejected,Closed;

            trigger OnValidate()
            begin
                BidAnalysisLine.RESET;
                BidAnalysisLine.SETRANGE(BidAnalysisLine."Document No.", "Request for Quotation No.");
                IF BidAnalysisLine.FINDSET THEN BEGIN
                    REPEAT
                        BidAnalysisLine.Status := Status;
                        BidAnalysisLine.MODIFY;
                    UNTIL BidAnalysisLine.NEXT = 0;
                END;
            end;
        }
        field(99; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(100; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
        }
        field(101; "No. Printed"; Integer)
        {
            Caption = 'No. Printed';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Request for Quotation No.", "Line No.", "Quote No.", "Vendor No.")
        {
        }
        key(Key2; "Item No.")
        {
        }
        key(Key3; "Vendor No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        PurchLine: Record 39;
        BidAnalysisLine: Record 50054;
}

