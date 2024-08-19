page 51608 "Creative Scheduler"
{
    CardPageID = "Creative Scheduler Card";
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Creative Scheduler";
    SourceTableView = WHERE("Brief Sent" = CONST(true),
                            "Schedule Sent" = CONST(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    Editable = false;
                }
                field(Job; Rec.Job)
                {
                    Editable = false;
                }
                field(Deliverables; Rec.Deliverables)
                {
                    Editable = false;
                }
                field("Type of Job"; Rec."Type of Job")
                {
                    Editable = false;
                }
                field(objText; objText)
                {
                    Caption = 'Brief';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        Rec.CalcFields(Brief);
                        Rec.Brief.CreateInStream(ObjInstr);
                        Obj.Read(ObjInstr);

                        if objText <> Format(Obj) then begin
                            Clear(Rec.Brief);
                            Clear(Obj);
                            Obj.AddText(objText);
                            Rec.Brief.CreateOutStream(ObjOutStr);
                            Obj.Write(ObjOutStr);
                            //MODIFY;
                        end;
                    end;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
                field(Timeline; Rec.Timeline)
                {
                }
                field("Creative Deliverable Date"; Rec."Creative Deliverable Date")
                {
                }
                field(Priority; Rec.Priority)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields(Brief);
        Rec.Brief.CreateInStream(ObjInstr);
        Obj.Read(ObjInstr);
        objText := Format(Obj);
    end;

    var
        Obj: BigText;
        ObjInstr: InStream;
        ObjOutStr: OutStream;
        objText: Text;
}

