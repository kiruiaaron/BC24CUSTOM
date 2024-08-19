page 51604 "Creative Schedule"
{
    CardPageID = "Creative Schedule Card";
    PageType = List;
    SourceTable = "Creative Scheduler";
    SourceTableView = WHERE("Brief Sent" = CONST(true),
                            "Schedule Sent" = CONST(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                }
                field(Job; Rec.Job)
                {
                }
                field(Deliverables; Rec.Deliverables)
                {
                }
                field("Type of Job"; Rec."Type of Job")
                {
                }
                field(objText; objText)
                {
                    Caption = 'Brief';

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
                field("Creative Lead Person"; Rec."Creative Lead Person")
                {
                }
                field("Brief Date"; Rec."Brief Date")
                {
                }
                field(Contact; Rec.Contact)
                {
                }
                field("Contact Name"; Rec."Contact Name")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Department Name"; Rec."Department Name")
                {
                    Editable = false;
                }
                field("Start Date"; Rec."Start Date")
                {
                }
                field("End Date"; Rec."End Date")
                {
                }
                field("Lead Creative"; Rec."Lead Creative")
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

