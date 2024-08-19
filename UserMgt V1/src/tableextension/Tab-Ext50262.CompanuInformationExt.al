/// <summary>
/// TableExtension Companu Information Ext (ID 50262) extends Record Company Information.
/// </summary>
tableextension 50262 "Companu Information Ext" extends "Company Information"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Fleet Manager Support E-Mail"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "PWD Age"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Permanet Age"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(52136720; "Managing Agent"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(52136923; "Company Data Directory Path"; Text[250])
        {
            DataClassification = ToBeClassified;
            Description = 'Sysre';
        }
        field(52136924; "NSSF No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Sysre';
        }
        field(52136925; "NHIF No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Sysre';
        }
        field(52136926; "Telephone No."; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Sysre';
            ExtendedDatatype = PhoneNo;
        }
        field(52136927; "Company PIN"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}