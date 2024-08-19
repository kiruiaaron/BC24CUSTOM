/// <summary>
/// TableExtension Employee Ext (ID 50264) extends Record Employee.
/// </summary>
tableextension 50266 "Payroll Employee Ext" extends Employee
{
    fields
    {
        // Add changes to table fields here

        field(50009; "Calculation Scheme"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = true;
            TableRelation = "Calculation Header";
        }
        field(50010; "Mode of Payment"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Mode of Payment";
        }
        field(50011; "Bank Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Employee Bank Account";

            trigger OnValidate()
            var
                rEmpBankAccount: Record 51152;
            begin
                //IGS The code below was commented out.. dont know why, so i uncommented it
                rEmpBankAccount.GET("Bank Code");
                "Bank Branch Code" := rEmpBankAccount."Bank Branch Code";
                //IGS END
            end;
        }

        field(50013; "ED Code Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "ED Definitions"."ED Code";
        }
        field(50014; "Period Filter"; Code[10])
        {
            FieldClass = FlowFilter;
            TableRelation = Periods."Period ID";
        }
        field(50015; Amount; Decimal)
        {
            CalcFormula = Sum("Payroll Lines".Amount WHERE("Employee No." = FIELD("No."),
                                                           "Payroll ID" = FIELD("Period Filter"),
                                                           "ED Code" = FIELD("ED Code Filter"),
                                                           "Calculation Group" = FIELD("Calculation Group Filter"),
                                                            "Currency Code" = FIELD("Currency Filter"),
                                                            "Posting Date" = FIELD("Date Filter")));
            FieldClass = FlowField;
        }
        field(50016; "Calculation Group Filter"; Option)
        {
            FieldClass = FlowFilter;
            OptionMembers = "None",Payments,"Benefit non Cash",Deduction;
            TableRelation = "ED Definitions"."Calculation Group";
        }

        field(50018; "Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = true;
            TableRelation = "Employee Posting Groups";
        }
        field(50019; "Salary Scale"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salary Scale";
        }
        field(50020; "Scale Step"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salary Scale Step".Code WHERE(Scale = FIELD("Salary Scale"));
        }
        field(50021; Paystation; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Paystation;
        }
        field(50022; "Fixed Pay"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50023; "Basic Pay"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = true;
            OptionMembers = " ","None","Fixed",Scale;
        }
        field(50024; "Hourly Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50025; "Daily Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50026; "Amount To Date"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Payroll Lines".Amount WHERE("Employee No." = FIELD("No."),
                                                           "ED Code" = FIELD("ED Code Filter"),
                                                           "Calculation Group" = FIELD("Calculation Group Filter"),
                                                            "Posting Date" = FIELD(UPPERLIMIT("Date Filter")),
                                                            "Currency Code" = FIELD("Currency Filter")));

        }
        field(50027; "Payroll Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = true;
            TableRelation = Payroll;

            trigger OnValidate()
            begin
                //ERROR('Manual Edits not allowed.');
            end;
        }
        field(50028; "Membership No."; Code[20])
        {
            // CalcFormula = Lookup("Membership Numbers"."Membership Number" WHERE ("Employee No."=FIELD("No."),
            //"ED Code" =FIELD("ED Code Filter")));
            FieldClass = Normal;
        }
        field(50029; "Amount (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Payroll Lines"."Amount (LCY)" WHERE("Employee No." = FIELD("No."),
                                                                   "Payroll ID" = FIELD("Period Filter"),
                                                                   "ED Code" = FIELD("ED Code Filter"),
                                                                   "Calculation Group" = FIELD("Calculation Group Filter"),
                                                                    "Posting Date" = FIELD("Date Filter")));

        }
        field(50030; "Amount To Date (LCY)"; Decimal)
        {
            CalcFormula = Sum("Payroll Lines"."Amount (LCY)" WHERE("Employee No." = FIELD("No."),
                                                                   "ED Code" = FIELD("ED Code Filter"),
                                                                   "Calculation Group" = FIELD("Calculation Group Filter"),
                                                                    "Posting Date" = FIELD(UPPERLIMIT("Date Filter"))));
            FieldClass = FlowField;
        }
        /*  field(50031; "Currency Filter"; Code[10])
         {
             FieldClass = FlowFilter;
         } */
        field(50032; "Basic Pay Currency"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency;
        }
        field(50033; "Housing For Employee"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'used in PAYE monthly generation';
            OptionCaption = 'Not Housed,Employer Owned,Employer Rented,Agricultural farm';
            OptionMembers = "Not Housed","Employer Owned","Employer Rented","Agricultural farm";
            TableRelation = Currency;
        }
        field(50034; "Value of Quarters"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'used in PAYE monthly generation';
        }


        field(50217; "No of Days"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Fixed Pay" := "No of Days" * "Daily Rate";
            end;
        }

    }

    var
        HumanResSetup: Record 5218;
        Res: Record 156;
        PostCode: Record 225;
        AlternativeAddr: Record 5201;
        EmployeeQualification: Record 5203;
        Relative: Record 5205;
        EmployeeAbsence: Record 5207;
        MiscArticleInformation: Record 5214;
        ConfidentialInformation: Record 5216;
        HumanResComment: Record 5208;
        SalespersonPurchaser: Record 13;
        //  NoSeriesMgt: Codeunit NoSeriesManagement;
        EmployeeResUpdate: Codeunit 5200;
        EmployeeSalespersonUpdate: Codeunit 5201;
        //DimMgt: Codeunit 408;
        Text000: Label 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
        BlockedEmplForJnrlErr: Label 'You cannot create this document because employee %1 is blocked due to privacy.', Comment = '%1 = employee no.';
        BlockedEmplForJnrlPostingErr: Label 'You cannot post this document because employee %1 is blocked due to privacy.', Comment = '%1 = employee no.';
        EmployeeLinkedToResourceErr: Label 'You cannot link multiple employees to the same resource. Employee %1 is already linked to that resource.', Comment = '%1 = employee no.';
        HRJob: Record 50093;
        // BankCodes: Record 50000;
        // BankBranches: Record 50001;
        Employee: Record 5200;
        //UserMgt: Codeunit 418;

        //Dates: Codeunit 50043;
        ErrorVaccantPositions: Label 'The Vacant Position(s) cannot exceed the Maximum Position(s) to be occupied for this Job.';
        gvResource: Record 156;
        gvLicensePermission: Record 2000000043;
        DAge: Text[250];
        DService: Text[250];
        PayrollSetup: Record 51165;
}