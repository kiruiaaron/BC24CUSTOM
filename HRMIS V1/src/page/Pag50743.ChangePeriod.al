page 50743 ChangePeriod
{

    layout
    {
        area(content)
        {
            field(StartDate; StartDate)
            {
                Caption = 'Start Date';
                ApplicationArea = All;
            }
            field(EndDate; EndDate)
            {
                Caption = 'End Date';
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF StartDate = 0D THEN
            ERROR('StartDate is empty!');
        IF EndDate = 0D THEN
            ERROR('End Date is empty!');
    end;

    var
        StartDate: Date;
        EndDate: Date;

    procedure GetDates(var BeginDate: Date; var PeriodEndDate: Date)
    begin
        BeginDate := StartDate;
        PeriodEndDate := EndDate
    end;
}

