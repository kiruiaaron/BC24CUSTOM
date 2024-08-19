/// <summary>
/// TableExtension Employee Ext (ID 50264) extends Record Employee.
/// </summary>
tableextension 50264 "Employee Ext" extends Employee
{
    fields
    {
        // Add changes to table fields here
        field(50001; "Emp Branch Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50002; "Bank Branch Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "National ID"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(50005; "Name of Old Employer"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Address of Old Employer"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "Name of New Employer"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Address of New Employer"; Text[80])
        {
            DataClassification = ToBeClassified;
        }


        field(50012; "Bank Account No"; Code[30])
        {
            DataClassification = ToBeClassified;
            Numeric = true;
        }



        field(50017; Loans; Decimal)
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }


        field(50035; "Employee Grade"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Jobs"."Job Grade";
        }
        field(50036; "Personal ID No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50037; PIN; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50038; "Visa No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50039; "Visa End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50040; "Work Permit No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50041; "Work Permit End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50042; "Total Empl. Factor"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50043; "NSSF No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50044; "NHIF No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50045; "Branch Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50046; "Location Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(50047; "Housing Eligibility"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,House,House Allowance,Both';
            OptionMembers = " ",House,"House Allowance",Both;
        }
        field(50048; Service; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50182; Driver; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50200; Position; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'HR fields';
            TableRelation = "HR Jobs";

            trigger OnValidate()
            var
                //  Jobs: Record 51200;
                HRJob: Record "HR Jobs";

            begin

                HRJob.RESET;
                HRJob.SETRANGE(HRJob."No.", Position);
                IF HRJob.FINDFIRST THEN BEGIN
                    "Job Title" := HRJob."Job Title";
                    "Position Title" := HRJob."Job Title";
                    "Employee Grade" := HRJob."Job Grade";
                END;
            end;
        }
        field(50201; "Position Title"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50202; "Marital Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Single,Married,Separated,Divorced,"Widow(er)",Other;
        }
        field(50203; "Physically Challenged"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = No,Yes;
        }
        field(50204; "Physically Challenged Details"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50205; "Physically Challenged Grade"; Text[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50207; "Physical File No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50208; "Confirmation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50209; "Full Time/Part Time"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Full Time","Part Time",Contract,Internship;
        }
        field(50210; Age; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50211; "Wedding Anniversary"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50212; "Contract End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50213; "Exit Interview Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50214; "Exit Interview Done By"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;
        }
        field(50215; "Allow Re-Employment in Future"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50216; "Probation Expiry Date"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(50218; "Employee Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',CMT,General,Apprentices';
            OptionMembers = ,CMT,General,Apprentices;
        }
        field(50219; Sanlam; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50220; Liberty; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50221; HELB; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50222; "Active Service Years"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50223; Ages; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50224; "Laptrust No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52137023; "Marital Status-d"; Option)
        {
            DataClassification = ToBeClassified;
            Enabled = false;
            OptionCaption = ' ,Single,Married';
            OptionMembers = " ",Single,Married;
        }
        field(52137024; "Birth Certificate No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52137025; "National ID No.-d"; Code[20])
        {
            DataClassification = ToBeClassified;
            Enabled = false;
        }
        field(52137026; "PIN No.-d"; Code[20])
        {
            DataClassification = ToBeClassified;
            Enabled = false;
        }
        field(52137027; "NSSF No.-d"; Code[20])
        {
            DataClassification = ToBeClassified;
            Enabled = false;
        }
        field(52137028; "NHIF No.-d"; Code[20])
        {
            DataClassification = ToBeClassified;
            Enabled = false;
        }

        field(52137030; "Driving Licence No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }




        field(52137036; "Bank Name"; Text[80])
        {
            DataClassification = ToBeClassified;
        }

        field(52137038; "Bank Branch Name"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(52137039; "Contract Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(52137040; Citizenship; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Lookup Values".Code WHERE(Option = CONST(Nationality));
        }
        field(52137041; Religion; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Lookup Values".Code WHERE(Option = CONST(Religion));
        }
        field(52137042; "County Code"; Code[50])
        {
            Caption = 'County of Origin Code';
            DataClassification = ToBeClassified;
            TableRelation = County.Code;
            /*
            var 
            Counties: Record County;
            trigger OnValidate()
            begin
                "County Name":='';
                Counties.RESET;
                Counties.SETRANGE(Counties.Code,"County Code");
                IF Counties.FINDFIRST THEN BEGIN
                  "County Name":=Counties.Name;
                END;
            end;
            */
        }
        field(52137043; "County Name"; Text[100])
        {
            Caption = 'County of Orgin Name';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(52137044; "SubCounty Code"; Code[50])
        {
            Caption = 'SubCounty of Origin Code';
            DataClassification = ToBeClassified;
            TableRelation = "Sub-County"."Sub-County Code" WHERE("County Code" = FIELD("County Code"));
            /*
                        trigger OnValidate()
                        begin
                            "SubCounty Name":='';
                            SubCounty.RESET;
                            SubCounty.SETRANGE(SubCounty."Sub-County Code","SubCounty Code");
                            SubCounty.SETRANGE(SubCounty."County Code","County Code");
                            IF SubCounty.FINDFIRST THEN BEGIN
                              "SubCounty Name":=SubCounty."Sub-County Name";
                            END;
                        end;
                        */
        }
        field(52137045; "SubCounty Name"; Text[100])
        {
            Caption = 'SubCounty of Origin Name';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(52137046; "Leave Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,On Leave';
            OptionMembers = " ","On Leave";
        }
        field(52137047; "Leave Calendar"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Base Calendar";
        }
        field(52137048; PasswordResetToken; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(52137049; PasswordResetTokenExpiry; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(52137050; "Portal Password"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(52137051; "Default Portal Password"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(52137053; "Contract Expiry Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(52137054; "Employee Signature"; Media)
        {
            DataClassification = ToBeClassified;
        }
        field(52137055; "Person Living with Disability"; Option)
        {
            DataClassification = ToBeClassified;
            Enabled = false;
            OptionCaption = 'No,Yes';
            OptionMembers = No,Yes;
        }
        field(52137056; "Ethnic Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Lookup Values".Code WHERE(Option = CONST(Ethnicity));
        }
        field(52137057; "Huduma No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52137058; "HR Salary Notch"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52137059; "Supervisor Job Title"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(52137060; "User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = User."User Name";
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                // UserMgt.LookupUserID("User ID");
            end;

            trigger OnValidate()
            begin
                // UserMgt.ValidateUserID("User ID");
            end;
        }
        field(52137061; "Imprest Posting Group"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Employee Posting Group";
        }
        field(52137062; Department; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value";
        }
        field(52137063; Location; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(52137064; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(52137065; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(52137066; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(52137067; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(52137068; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(52137069; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(52137070; "Driving License Expiry Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(52137072; "Practice Cert No."; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(52137073; "Employement Years of Service"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(52137124; "Date of Leaving"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(52137125; "Supervisor Job No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "HR Jobs"."No.";
        }
        field(52137126; "Termination Grounds"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Resignation,Non-Renewal Of Contract,Dismissal,Retirement,Death,Other';
            OptionMembers = " ",Resignation,"Non-Renewal Of Contract",Dismissal,Retirement,Death,Other;
        }
        field(52137127; "Total Leave Taken"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(52137129; "Leave Period Filter"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52137130; "Allocated Leave Days"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(52137132; "Reason For Leaving"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Resignation,"Non-Renewal Of Contract",Dismissal,Retirement,Deceased,Termination,"Contract Ended",Abscondment,"Appt. Revoked","Contract Termination",Retrenchment,Other;
        }
        field(52137133; "Reason For Leaving (Other)"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(52137134; "On Probation"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(52137140; "Contract Period"; DateFormula)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF FORMAT("Contract Period") = '' THEN BEGIN
                    "Contract Expiry Date" := 0D
                END ELSE BEGIN
                    Rec.TESTFIELD("Contract Start Date");
                    "Contract Expiry Date" := (CALCDATE("Contract Period", "Contract Start Date") - 1);
                END;
            end;
        }
        field(52137141; "Probation Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(52137142; "Probation Period"; DateFormula)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF FORMAT("Probation Period") = '' THEN BEGIN
                    "Probation End date" := 0D
                END ELSE BEGIN
                    Rec.TESTFIELD("Probation Start Date");
                    "Probation End date" := (CALCDATE("Probation Period", "Probation Start Date") - 1);
                END;
            end;
        }
        field(52137143; "Probation End date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            Enabled = false;
        }
        field(52137144; "Reactivation Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(52137145; "Leave Group"; Code[50])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "HR Leave Groups".Code;
        }

        field(52137147; "Full Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(52137171; "Payroll Group Code"; Code[50])
        {
            DataClassification = ToBeClassified;
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
        Counties: Record 50176;
        SubCounty: Record 50177;
        //Dates: Codeunit 50043;
        ErrorVaccantPositions: Label 'The Vacant Position(s) cannot exceed the Maximum Position(s) to be occupied for this Job.';
        gvResource: Record 156;
        gvLicensePermission: Record 2000000043;
        DAge: Text[250];
        DService: Text[250];

}