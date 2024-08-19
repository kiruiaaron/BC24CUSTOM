table 50208 "Contract Request Header"
{

    fields
    {
        field(1; "Request No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Procurement,Property,Investment';
            OptionMembers = " ",Procurement,Property,Investment;
        }
        field(6; "Contract Link"; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Description := '';
                TESTFIELD(Type);



                IF Type = Type::Procurement THEN BEGIN
                    TenderHeader.RESET;
                    TenderHeader.SETRANGE(TenderHeader."No.", "Contract Link");
                    IF TenderHeader.FINDFIRST THEN BEGIN
                        Description := TenderHeader."Tender Description";
                        "Contract Subject" := TenderHeader."Supplier Awarded";
                        VALIDATE("Contract Subject");
                    END;
                END;
            end;
        }
        field(10; Description; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Legal Comments"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Contract Subject"; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = IF (Type = FILTER(Procurement)) "Tender Header"."Supplier Awarded" WHERE("No." = FIELD("Contract Link"));

            trigger OnValidate()
            begin
                "Contract Subject Name" := '';
                TESTFIELD(Type);
                TESTFIELD("Contract Link");
                /*
                IF Type=Type::Property THEN BEGIN
                  PropertyLease.RESET;
                  PropertyLease.SETRANGE(PropertyLease."Tenant No.","Contract Subject");
                  IF PropertyLease.FINDFIRST THEN BEGIN
                    "Contract Subject Name":=PropertyLease."Tenant Name"
                  END;
                END;
                */
                IF Type = Type::Procurement THEN BEGIN
                    TenderHeader.RESET;
                    TenderHeader.SETRANGE(TenderHeader."Supplier Awarded", "Contract Subject");
                    IF TenderHeader.FINDFIRST THEN BEGIN
                        "Contract Subject Name" := TenderHeader."Supplier Name"
                    END;
                END;

            end;
        }
        field(13; "Contract Subject Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(20; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Under Legal,Closed';
            OptionMembers = Open,"Under Legal",Closed;
        }
        field(30; "User ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                         "Dimension Value Type" = CONST(Standard));
        }
        field(51; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Global Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                         "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(52; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                         "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(53; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                         "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(54; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                         "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(55; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                         "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(56; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                         "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(57; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                         "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(60; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Request No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        TenderHeader: Record 50055;
}

