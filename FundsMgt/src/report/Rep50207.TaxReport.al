report 50207 "Tax Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/layouts/Tax Report.rdlc';

    dataset
    {
        dataitem(DataItem1; 2000000026)
        {
            DataItemTableView = WHERE(Number = CONST(1));
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyAddress; CompanyInfo.Address)
            {
            }
            column(CompanyAddress2; CompanyInfo."Address 2")
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(CompanyPhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyEmail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyHomePage; CompanyInfo."Home Page")
            {
            }
            column(GeneralPaye; ABS(GeneralPaye))
            {
            }
            column(CMTPaye; ABS(CMTPaye))
            {
            }
            column(BoardTax; ABS(BoardTax))
            {
            }
            column(ImprestTax; ABS(ImprestTax))
            {
            }
            column(GratuityTax; ABS(GratuityTax))
            {
            }
            column(TotalTax; ABS(TotalTax))
            {
            }
            column(CMTTax; ABS(CMTTax))
            {
            }
            column(Periodfilter; PeriodFilter)
            {
            }

            trigger OnAfterGetRecord()
            begin
                //general Tax
                GLEntry.RESET;
                GLEntry.SETFILTER(GLEntry."Document No.", '%1', 'GENERAL' + '*');
                GLEntry.SETFILTER(GLEntry."G/L Account No.", '5610');
                GLEntry.SETRANGE("Posting Date", StartDate, EndDate);
                GLEntry.CALCSUMS(Amount);
                GeneralPaye := GLEntry.Amount;
                //CMT Tax
                GLEntry.RESET;
                GLEntry.SETFILTER(GLEntry."Document No.", '%1', 'CMT' + '*');
                GLEntry.SETFILTER(GLEntry."G/L Account No.", '5610');
                GLEntry.SETRANGE("Posting Date", StartDate, EndDate);
                GLEntry.CALCSUMS(Amount);
                CMTPaye := GLEntry.Amount;
                //Board Tax
                ImprestHeader.RESET;
                //ImprestHeader.SETRANGE(Type,ImprestHeader.Type::"Board Allowances");
                ImprestHeader.SETRANGE("Posting Date", StartDate, EndDate);
                IF ImprestHeader.FINDFIRST THEN
                    REPEAT
                        IF Employee.GET(ImprestHeader."Employee No.") THEN BEGIN
                            IF Employee."Payroll Code" = 'BOARD' THEN BEGIN


                                GLEntry.SETFILTER(GLEntry."Document No.", ImprestHeader."No.");
                                GLEntry.SETFILTER(GLEntry."G/L Account No.", '5610');
                                GLEntry.SETRANGE("Posting Date", StartDate, EndDate);
                                GLEntry.CALCSUMS(Amount);
                                BoardTax := BoardTax + GLEntry.Amount;
                            END ELSE
                                IF Employee."Payroll Code" = 'CMT' THEN BEGIN


                                    GLEntry.SETFILTER(GLEntry."Document No.", ImprestHeader."No.");
                                    GLEntry.SETFILTER(GLEntry."G/L Account No.", '5610');
                                    GLEntry.SETRANGE("Posting Date", StartDate, EndDate);
                                    GLEntry.CALCSUMS(Amount);
                                    CMTTax := CMTTax + GLEntry.Amount;
                                END ELSE BEGIN
                                    GLEntry.SETFILTER(GLEntry."Document No.", ImprestHeader."No.");
                                    GLEntry.SETFILTER(GLEntry."G/L Account No.", '5610');
                                    GLEntry.SETRANGE("Posting Date", StartDate, EndDate);
                                    GLEntry.CALCSUMS(Amount);
                                    ImprestTax := ImprestTax + GLEntry.Amount;

                                END;
                        END;
                    UNTIL ImprestHeader.NEXT = 0;

                //Gratuity Tax
                GLEntry.RESET;
                GLEntry.SETFILTER(GLEntry.Description, '%1', '*' + 'GRATUITY TAX' + '*');
                GLEntry.SETFILTER(GLEntry."G/L Account No.", '5610');
                GLEntry.SETRANGE("Posting Date", StartDate, EndDate);
                GLEntry.CALCSUMS(Amount);
                GratuityTax := GLEntry.Amount;
                TotalTax := GratuityTax + ImprestTax + BoardTax + CMTPaye + GeneralPaye + CMTTax;
            end;

            trigger OnPreDataItem()
            begin
                PeriodFilter := FORMAT(StartDate) + '..' + FORMAT(EndDate);
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
                    field("Start Date"; StartDate)
                    {
                        ApplicationArea = All;
                    }
                    field("End Date"; EndDate)
                    {
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
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        GLEntry: Record 17;
        StartDate: Date;
        EndDate: Date;
        GeneralPaye: Decimal;
        CMTPaye: Decimal;
        CompanyInfo: Record 79;
        ImprestHeader: Record 50008;
        BoardTax: Decimal;
        ImprestTax: Decimal;
        GratuityTax: Decimal;
        TotalTax: Decimal;
        Employee: Record 5200;
        CMTTax: Decimal;
        PeriodFilter: Text;
}

