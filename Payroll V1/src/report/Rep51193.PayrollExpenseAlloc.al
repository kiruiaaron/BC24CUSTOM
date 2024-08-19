report 51193 "Payroll Expense Alloc."
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/Payroll Expense Alloc..rdlc';

    dataset
    {
        dataitem("Payroll Exp Allocation Matrix"; 51188)
        {
            DataItemTableView = SORTING("Employee No", "ED Code", "Posting Date");
            RequestFilterFields = "Employee No", "ED Code";
            column(MonthYear; MonthText + ' ' + FORMAT(Year))
            {
            }
            column(OtherFilters; "Payroll Exp Allocation Matrix".GETFILTERS)
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(PostingDate; "Payroll Exp Allocation Matrix"."Posting Date")
            {
            }
            column(EmployeeNo; "Payroll Exp Allocation Matrix"."Employee No")
            {
                IncludeCaption = true;
            }
            column(EDcode; "Payroll Exp Allocation Matrix"."ED Code")
            {
                IncludeCaption = true;
            }
            column(DimCode1; "Payroll Exp Allocation Matrix"."Dimension Code1")
            {
                IncludeCaption = true;
            }
            column(DimCodeValue1; "Payroll Exp Allocation Matrix"."Dimension Value Code1")
            {
                IncludeCaption = true;
            }
            column(DimCode2; "Payroll Exp Allocation Matrix"."Dimension Code2")
            {
                IncludeCaption = true;
            }
            column(DimCodeValue2; "Payroll Exp Allocation Matrix"."Dimension Value Code2")
            {
                IncludeCaption = true;
            }
            column(DimCode3; "Payroll Exp Allocation Matrix"."Dimension Code3")
            {
                IncludeCaption = true;
            }
            column(DimCodeValue3; "Payroll Exp Allocation Matrix"."Dimension Value Code3")
            {
                IncludeCaption = true;
            }
            column(DimCode4; "Payroll Exp Allocation Matrix"."Dimension Code4")
            {
                IncludeCaption = true;
            }
            column(DimCodeValue4; "Payroll Exp Allocation Matrix"."Dimension Value Code4")
            {
                IncludeCaption = true;
            }
            column(Allocated; "Payroll Exp Allocation Matrix".Allocated)
            {
                IncludeCaption = true;
            }

            trigger OnPreDataItem()
            begin
                "Payroll Exp Allocation Matrix".SETRANGE("Posting Date", StartDate, EndDate);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(Month; Month)
                    {
                        Caption = 'Month';
                        ApplicationArea = All;
                    }
                    field(Year; Year)
                    {
                        BlankZero = true;
                        Caption = 'Year';
                        Width = 4;
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        IF Month = Month::" " THEN ERROR('Month must be selected on request page');
        IF Year = 0 THEN ERROR('Year must be selected on request page');
        StartDate := DMY2DATE(1, Month, Year);
        EndDate := CALCDATE('CM', StartDate);
        MonthText := ' ,January,February,March,April,May,June,July,August,September,October,November,December';
        MonthText := SELECTSTR(Month, MonthText);
    end;

    var
        Month: Option " ",January,February,March,April,May,June,July,August,September,October,November,December;
        Year: Integer;
        StartDate: Date;
        EndDate: Date;
        MonthText: Text[100];
}

