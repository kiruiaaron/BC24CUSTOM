table 51603 "Creative Scheduler"
{
    DrillDownPageID = "Creative Schedule";
    LookupPageID = "Creative Schedule";

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Job; Text[250])
        {
        }
        field(3; Deliverables; Text[250])
        {
        }
        field(4; "Type of Job"; Text[250])
        {
        }
        field(5; Brief; BLOB)
        {
        }
        field(6; Status; Option)
        {
            OptionCaption = 'Pending,in Progress,Completed,Reverted,Accepted';
            OptionMembers = Pending,"in Progress",Completed,Reverted,Accepted;

            trigger OnValidate()
            var
                //  SMTPMail: Codeunit "SMTP Mail";
                //   SMTPMailSetup: Record "SMTP Mail Setup";
                UserSetup: Record "User Setup";
            begin
                /*  
            
                if Status = Status::Completed then begin
                    if Confirm('Would you like to notify the lead person?', false) then begin
                        UserSetup.Reset;
                        UserSetup.Get("Creative Lead Person");
                        if UserSetup."E-Mail" <> '' then begin
                            SMTPMailSetup.Get;
                            //    SMTPMail.CreateMessage('True Blaq', SMTPMailSetup."Email Sender Address", UserSetup."E-Mail", 'Schedule Marked as Completed','A task that had been scheduled has been marked as completed', TRUE);
                            SMTPMail.Send;
                        end;
                    end else
                        Error('Please confirm sending notification to move the schedule to completed');
                end; */
                if (Status = Status::Accepted) or (Status = Status::Reverted) then begin
                    if UserId <> "Creative Lead Person" then
                        Error('Only the lead person can accept the work');

                    if (Status = Status::Reverted) then begin
                        Rec."Schedule Sent" := false;
                        Modify();
                    end;

                end;
            end;
        }
        field(7; Timeline; Text[10])
        {
        }
        field(8; "Creative Deliverable Date"; Date)
        {

            trigger OnValidate()
            begin
                if "Brief Date" <> 0D then begin
                    dateDiffrence := "Creative Deliverable Date" - "Brief Date";
                    if dateDiffrence < 3 then
                        Priority := Priority::High;
                    if (dateDiffrence < 8) and (dateDiffrence > 2) then
                        Priority := Priority::Normal;
                    if dateDiffrence > 7 then
                        Priority := Priority::Low;
                end;
            end;
        }
        field(9; Priority; Option)
        {
            OptionCaption = 'Low,Normal,High';
            OptionMembers = Low,Normal,High;
        }
        field(10; "Creative Lead Person"; Code[50])
        {
            TableRelation = "User Setup";
        }
        field(12; "Brief Date"; Date)
        {

            trigger OnValidate()
            begin
                if "Creative Deliverable Date" <> 0D then begin
                    dateDiffrence := "Creative Deliverable Date" - "Brief Date";
                    if dateDiffrence < 3 then
                        Priority := Priority::High;
                    if (dateDiffrence < 8) and (dateDiffrence > 2) then
                        Priority := Priority::Normal;
                    if dateDiffrence > 7 then
                        Priority := Priority::Low;
                end;
            end;
        }
        field(13; Contact; Code[20])
        {
            TableRelation = Contact."No.";

            trigger OnValidate()
            begin
                ContactRec.Reset;
                ContactRec.SetRange(ContactRec."No.", Contact);
                if ContactRec.FindSet then
                    "Contact Name" := ContactRec.Name;
            end;
        }
        field(14; "Contact Name"; Text[30])
        {
        }
        field(29; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                DimensionValue.Reset;
                DimensionValue.SetRange(Code, Rec."Shortcut Dimension 1 Code");
                if DimensionValue.FindSet then
                    "Department Name" := DimensionValue.Name;
            end;
        }
        field(30; "Department Name"; Text[250])
        {
        }
        field(31; "Brief Sent"; Boolean)
        {
        }
        field(32; "Schedule Sent"; Boolean)
        {
        }
        field(33; "Start Date"; DateTime)
        {

            trigger OnValidate()
            begin
                TestField("Lead Creative");
                MarketingSetup.Get;
                if (DT2Time("Start Date") > MarketingSetup."Closing Time") or (DT2Time("Start Date") < MarketingSetup."Opening Time") then
                    Error('Please specify a valid working time withing %1 and %2', MarketingSetup."Opening Time", MarketingSetup."Closing Time");

                CreativeScheduler.Reset;
                CreativeScheduler.SetRange("Lead Creative", Rec."Lead Creative");
                if CreativeScheduler.FindSet then begin
                    repeat
                        if CreativeScheduler.Code <> Rec.Code then begin
                            if (CreativeScheduler."Start Date" < Rec."Start Date") and (CreativeScheduler."End Date" > Rec."Start Date") then begin
                                if (Confirm('You have another task running within the same time. Run concurrently?', true)) then begin
                                end else begin
                                    Error('Please choose a different starting time');
                                end;
                            end;
                        end;
                    until CreativeScheduler.Next = 0;
                end;
            end;
        }
        field(34; "End Date"; DateTime)
        {

            trigger OnValidate()
            begin
                TestField("Lead Creative");
                MarketingSetup.Get;
                if (DT2Time("End Date") > MarketingSetup."Closing Time") or (DT2Time("End Date") < MarketingSetup."Opening Time") then
                    Error('Please specify a valid working time withing %1 and %2', MarketingSetup."Opening Time", MarketingSetup."Closing Time");
            end;
        }
        field(35; "Lead Creative"; Code[50])
        {
            TableRelation = "User Setup";
        }
        field(36; "Created By"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(37; "Date Created"; Date)
        {
            Editable = false;
        }
        field(38; "Time Created"; Time)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        MarketingSetup.Get;
        if MarketingSetup.FindSet then
            NoSeriesMgt.InitSeries(MarketingSetup."Creative Brief No", MarketingSetup."Creative Brief No", Today, Code, noSeries);

        //Added on 27/06/19

        "Created By" := UserId;
        "Date Created" := Today;
        "Time Created" := Time;
    end;

    var
        DimensionValue: Record "Dimension Value";
        ContactRec: Record Contact;
        MarketingSetup: Record "Marketing Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        noSeries: Code[10];
        dateDiffrence: Integer;
        CreativeScheduler: Record "Creative Scheduler";
}

