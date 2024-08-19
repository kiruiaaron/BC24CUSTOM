table 50203 "User Support Incidences"
{

    fields
    {
        field(1; "Incident Reference"; Code[60])
        {

            trigger OnValidate()
            begin
                IF "Incident Reference" <> xRec."Incident Reference" THEN BEGIN
                    SalesSetup.GET;
                    //  NoSeriesMgt.TestManual(SalesSetup."User Support Inc Nos");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Incident Description"; Text[250])
        {
        }
        field(3; "Incident Date"; Date)
        {
        }
        field(4; "Incident Status"; Option)
        {
            OptionCaption = ',Unresolved,Resolved,Sent to HR Manager,Sent to HOD,Sent Direcor CS,Sent to CEO';
            OptionMembers = ,Unresolved,Resolved,"Sent to HR Manager","Sent to HOD","Sent Direcor CS","Sent to CEO";
        }
        field(5; "No. Series"; Code[60])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(6; "Action taken"; Text[250])
        {
        }
        field(7; "Action Date"; Date)
        {
        }
        field(8; "User Id"; Code[50])
        {
        }
        field(9; "System Support Email Address"; Text[80])
        {
        }
        field(10; "User email Address"; Text[80])
        {
        }
        field(11; Type; Option)
        {
            OptionMembers = ICT,ADM,REGISTRY,"KEYS";
        }
        field(12; "File No"; Code[30])
        {
        }
        field(13; "Incident Time"; Time)
        {
        }
        field(14; "Action Time"; Time)
        {
        }
        field(15; "Employee No"; Code[50])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                IF emp.GET("Employee No") THEN BEGIN
                    "Employee Name" := emp.FullName;
                    "Job Title" := emp."Job Title";
                    Department := emp."Global Dimension 2 Code";

                END;
            end;
        }
        field(16; "Employee Name"; Text[100])
        {
        }
        field(17; Sent; Boolean)
        {
        }
        field(18; "User Informed?"; Boolean)
        {
        }
        field(19; "Work place Controller"; Code[50])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin

                emp.GET("Work place Controller");
                "Work place Controller Name" := emp."First Name" + ' ' + emp."Last Name";
            end;
        }
        field(20; "Work place Controller Name"; Text[100])
        {
        }
        field(21; "Incidence Location"; Code[50])
        {
        }
        field(22; "Incidence Location Name"; Text[100])
        {
        }
        field(23; "Incidence Outcome"; Option)
        {
            OptionCaption = '  ,Dangerous,Serious bodily injury,Work caused illness,Serious electrical incident,Dangerous electrical event,MajorAccident under the OSHA Act';
            OptionMembers = "  ",Dangerous,"Serious bodily injury","Work caused illness","Serious electrical incident","Dangerous electrical event","MajorAccident under the OSHA Act";
        }
        field(24; "Incident Outcome"; Option)
        {
            OptionCaption = '  ,Yes,No';
            OptionMembers = "  ",Yes,No;
        }
        field(25; "Remarks HR"; Text[250])
        {
        }
        field(26; Category; Option)
        {
            OptionCaption = ' ,Incident,Maintenance,Grievance';
            OptionMembers = " ",Incident,Maintenance,Grievance;
        }
        field(27; "Grievance Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Individual,Collective';
            OptionMembers = Individual,Collective;
        }
        field(28; "Job Title"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Supervisor Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(30; Department; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(31; Subject; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Date of Issue First Raised"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(33; "Steps taken"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(34; Outcome; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(35; Comments; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(36; "Grievance About Work"; Boolean)
        {
            Caption = 'Grievance About Work Environment';
            DataClassification = ToBeClassified;
        }
        field(37; "Grievance About HR Manager"; Boolean)
        {
            Caption = 'Grievance About Employee Relations';
            DataClassification = ToBeClassified;
        }
        field(38; "Car No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(39; "No. of Persons Injured"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Abstract Obtained"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(41; "No. of fatalities"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(42; "Recommended Measures"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(43; "Current Stage"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Employee,HOS,HOD,HR,MD';
            OptionMembers = Employee,HOS,HOD,HR,MD;
        }
        field(44; "Next Stage"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Employee,HOS,HOD,HR,MD';
            OptionMembers = Employee,HOS,HOD,HR,MD;

            trigger OnValidate()
            begin
                IF ("Next Stage" < "Current Stage") THEN
                    ERROR('You can only move to the next level');
            end;
        }
        field(50; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Department';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(False));
        }
        field(51; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Station';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(False));
        }
        field(52; "Shortcut Dimension 3 Code"; Code[20])
        {
            Caption = 'Section';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(False));
        }
        field(53; "Supervisor Station"; Code[20])
        {
            Caption = 'Supervisor Station';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(False));
        }
        field(54; "Supervisor Section"; Code[20])
        {
            Caption = 'Supervisor Section';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(False));
        }
        field(55; "Supervisor Department"; Code[20])
        {
            Caption = 'Supervisor Department';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(False));
        }
        field(56; "Document Path"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(59; "HOS Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(60; "HOD Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(61; "HR Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(63; "Supervisor No"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                IF emp.GET("Supervisor No") THEN BEGIN
                    "Supervisor Name" := emp.FullName;
                    "Supervisor Designation" := emp."Job Title";
                    "Supervisor Department" := emp."Global Dimension 2 Code";
                    "Supervisor Section" := emp."Shortcut Dimension 3 Code";
                    "Supervisor Station" := emp."Global Dimension 1 Code";
                END;
            end;
        }
        field(64; "MD Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(65; "References by HOD"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(66; "References by HR"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(67; "References by MD"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(68; Resolved; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(69; Recommendations; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(70; "Resolved by"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(76; "References by HOS"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(77; "Employee Designation"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(78; "Supervisor Designation"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Incident Reference")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin


        IF Category = Category::Incident THEN BEGIN
            HRSetup.GET;
            //  HRSetup.TESTFIELD(HRSetup."HR HOD");
            //NoSeriesMgt.InitSeries(HRSetup."Incident Reference Nos", xRec."No. Series", 0D, "Incident Reference", "No. Series");
        END;
        /*
        IF Category=Category::Maintenance THEN BEGIN
          HRSetup.GET;
          HRSetup.TESTFIELD(HRSetup."Maintenance Req Nos");
          //NoSeriesMgt.InitSeries(HRSetup."Maintenance Req Nos",xRec."No. Series",0D,"Incident Reference","No. Series");
          "Incident Time":=TIME;
        END;
        */
        IF Category = Category::Grievance THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Grievance Nos");
            //NoSeriesMgt.InitSeries(HRSetup."Grievance Nos", xRec."No. Series", 0D, "Incident Reference", "No. Series");
            "Incident Date" := TODAY;
        END;





        CompanyInformation.GET;
        //"System Support Email Address":=CompanyInformation."HR Support Email";
        "User Id" := USERID;
        /*
        IF Users.GET(USERID) THEN
        BEGIN
          //employee name and no and dept
          "Employee No":=Users."Employee No";
          IF emp.GET(Users."Employee No") THEN
            BEGIN
            "Employee Name":=emp."First Name"+' '+emp."Middle Name"+' '+emp."Last Name";
            "Job Title":=emp."Job Title";
            Department:=emp."Global Dimension 2 Code";
            END;
          "User email Address":=Users."E-Mail";
        
          //get supervisor name
        //  IF emp.GET(Users."Immediate Supervisor") THEN
        //    "Supervisor Name":=emp."Last Name"+' '+emp."First Name";
        END;
        */

    end;

    var
        SalesSetup: Record 311;
        CommentLine: Record 97;
        NoSeriesMgt: Codeunit 396;
        CompanyInformation: Record 79;
        Users: Record 91;
        emp: Record 5200;
        HRSetup: Record 5218;
        AreasofGrieavanceRec: Record 50204;
        UserSetupRec: Record 91;
}

