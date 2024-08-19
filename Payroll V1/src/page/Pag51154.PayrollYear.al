page 51154 "Payroll Year"
{
    PageType = List;
    Permissions = TableData 51151 = rimd;
    SourceTable = 51150;

    layout
    {
        area(content)
        {
            repeater(r)
            {
                field(Year; Rec.Year)
                {
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                }
                field("End date"; Rec."End date")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Annual TAX Table"; Rec."Annual TAX Table")
                {
                    ApplicationArea = All;
                }
                field("Annual TAX Relief Table"; Rec."Annual TAX Relief Table")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Init Periods")
            {
                Caption = '&Init Periods';
                Image = ClosePeriod;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 51157;
                RunPageLink = "Period Year" = FIELD(Year);
                ApplicationArea = All;

                trigger OnAction()
                var
                    lvPeriods: Record 51151;
                    lvIndex: Integer;
                begin
                    //skm230409 revised to support multiple payrolls in one db

                    gvPayrollUtilities.sGetActivePayroll(gvAllowedPayrolls);
                    lvPeriods.SETRANGE("Period Year", Rec.Year);
                    lvPeriods.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");

                    IF lvPeriods.FIND('-') THEN ERROR('Payroll period(s) exists for year %1', Rec.Year);

                    FOR lvIndex := 1 TO 12 DO BEGIN
                        lvPeriods.INIT;
                        lvPeriods."Period ID" := STRSUBSTNO('%1-%2', lvIndex, Rec.Year);
                        lvPeriods."Period Month" := lvIndex;
                        lvPeriods."Period Year" := Rec.Year;
                        lvPeriods."Start Date" := DMY2DATE(1, lvIndex, Rec.Year);

                        CASE lvIndex OF
                            1:
                                BEGIN
                                    lvPeriods."End Date" := DMY2DATE(31, lvIndex, Rec.Year);
                                    lvPeriods.Description := STRSUBSTNO('January %1', Rec.Year);
                                END;

                            2:
                                BEGIN
                                    lvPeriods."End Date" := DMY2DATE(28, lvIndex, Rec.Year);
                                    lvPeriods.Description := STRSUBSTNO('February %1', Rec.Year);
                                END;

                            3:
                                BEGIN
                                    lvPeriods."End Date" := DMY2DATE(31, lvIndex, Rec.Year);
                                    lvPeriods.Description := STRSUBSTNO('March %1', Rec.Year);
                                END;

                            4:
                                BEGIN
                                    lvPeriods."End Date" := DMY2DATE(30, lvIndex, Rec.Year);
                                    lvPeriods.Description := STRSUBSTNO('April %1', Rec.Year);
                                END;

                            5:
                                BEGIN
                                    lvPeriods."End Date" := DMY2DATE(31, lvIndex, Rec.Year);
                                    lvPeriods.Description := STRSUBSTNO('May %1', Rec.Year);
                                END;

                            6:
                                BEGIN
                                    lvPeriods."End Date" := DMY2DATE(30, lvIndex, Rec.Year);
                                    lvPeriods.Description := STRSUBSTNO('June %1', Rec.Year);
                                END;

                            7:
                                BEGIN
                                    lvPeriods."End Date" := DMY2DATE(31, lvIndex, Rec.Year);
                                    lvPeriods.Description := STRSUBSTNO('July %1', Rec.Year);
                                END;

                            8:
                                BEGIN
                                    lvPeriods."End Date" := DMY2DATE(31, lvIndex, Rec.Year);
                                    lvPeriods.Description := STRSUBSTNO('August %1', Rec.Year);
                                END;

                            9:
                                BEGIN
                                    lvPeriods."End Date" := DMY2DATE(30, lvIndex, Rec.Year);
                                    lvPeriods.Description := STRSUBSTNO('September %1', Rec.Year);
                                END;

                            10:
                                BEGIN
                                    lvPeriods."End Date" := DMY2DATE(31, lvIndex, Rec.Year);
                                    lvPeriods.Description := STRSUBSTNO('October %1', Rec.Year);
                                END;

                            11:
                                BEGIN
                                    lvPeriods."End Date" := DMY2DATE(30, lvIndex, Rec.Year);
                                    lvPeriods.Description := STRSUBSTNO('November %1', Rec.Year);
                                END;

                            12:
                                BEGIN
                                    lvPeriods."End Date" := DMY2DATE(31, lvIndex, Rec.Year);
                                    lvPeriods.Description := STRSUBSTNO('December %1', Rec.Year);
                                END;
                        END; //Case

                        lvPeriods."Posting Date" := lvPeriods."End Date";
                        lvPeriods."Payroll Code" := gvAllowedPayrolls."Payroll Code";
                        lvPeriods.INSERT;
                    END; //For
                end;
            }
            action("&Periods")
            {
                Caption = '&Periods';
                Image = CreateYear;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 51157;
                RunPageLink = "Period Year" = FIELD(Year);
                ApplicationArea = All;
            }
        }
    }

    trigger OnOpenPage()
    begin

        gsSegmentPayrollData;
    end;

    var
        gvPayrollUtilities: Codeunit 51152;
        gvAllowedPayrolls: Record 51182;

    local procedure gsSegmentPayrollData()
    var
        lvAllowedPayrolls: Record 51182;
        lvPayrollUtilities: Codeunit 51152;
        UsrID: Code[10];
        UsrID2: Code[10];
        StringLen: Integer;
        lvActiveSession: Record 2000000110;
    begin
        lvActiveSession.RESET;
        lvActiveSession.SETRANGE("Server Instance ID", SERVICEINSTANCEID);
        lvActiveSession.SETRANGE("Session ID", SESSIONID);
        lvActiveSession.FINDFIRST;


        lvAllowedPayrolls.SETRANGE("User ID", lvActiveSession."User ID");
        lvAllowedPayrolls.SETRANGE("Last Active Payroll", TRUE);
        /*IF lvAllowedPayrolls.FINDFIRST THEN
         Rec. SETRANGE("Payroll Code", lvAllowedPayrolls."Payroll Code")
        ELSE
          ERROR('You are not allowed access to this payroll dataset.');*/
        Rec.FILTERGROUP(100);

    end;
}

