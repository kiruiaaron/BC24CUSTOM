table 51608 "Item Reservations"
{

    fields
    {
        field(1; "Code"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; Resource; Code[50])
        {
            TableRelation = Resource;

            trigger OnValidate()
            begin
                if Resource12.Get(Resource) then
                    "Resource Name" := Resource12.Name;
            end;
        }
        field(3; "Resource Name"; Text[100])
        {
        }
        field(4; Date; Date)
        {
        }
        field(5; "Start Time"; Time)
        {

            trigger OnValidate()
            begin
                TestField(Resource);
                TestField(Date);
                ItemReservations.Reset;
                ItemReservations.SetRange(ItemReservations.Resource, Rec.Resource);
                ItemReservations.SetRange(ItemReservations.Date, Rec.Date);
                if ItemReservations.FindSet then begin
                    repeat
                        if (ItemReservations."Start Time" <= Rec."Start Time") and (ItemReservations."End Time" > Rec."Start Time") then
                            Error('The selected item has been booked on the selected date and time');
                    until ItemReservations.Next = 0;
                end;
            end;
        }
        field(6; "End Time"; Time)
        {
        }
        field(7; Project; Code[50])
        {
            TableRelation = Job;

            trigger OnValidate()
            begin
                if Job.Get(Project) then
                    "Project Name" := Job.Description;
            end;
        }
        field(8; "Project Name"; Text[200])
        {
        }
        field(9; "Task Line"; Code[100])
        {
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD(Project));

            trigger OnValidate()
            begin
                JobTask.Reset;
                JobTask.SetRange("Job No.", Project);
                JobTask.SetRange("Job Task No.", "Task Line");
                if JobTask.FindSet then
                    "Task name" := JobTask.Description
            end;
        }
        field(10; "Task name"; Text[200])
        {
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

    var
        Resource12: Record Resource;
        Job: Record Job;
        JobTask: Record "Job Task";
        ItemReservations: Record "Item Reservations";
}

