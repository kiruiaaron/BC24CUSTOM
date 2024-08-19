page 51606 "Creative Briefs"
{
    CardPageID = "Creative Brief Card";
    PageType = List;
    SourceTable = "Creative Scheduler";
    SourceTableView = WHERE("Brief Sent" = CONST(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                }
                field("Creative Lead Person"; Rec."Creative Lead Person")
                {
                    Caption = 'Creative Lead Person';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Department Name"; Rec."Department Name")
                {
                }
                field(Job; Rec.Job)
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
                field(Deliverables; Rec.Deliverables)
                {
                }
                field("Brief Date"; Rec."Brief Date")
                {
                }
                field("Creative Deliverable Date"; Rec."Creative Deliverable Date")
                {
                    Caption = 'Deadline';
                }
                field(Contact; Rec.Contact)
                {
                }
                field("Contact Name"; Rec."Contact Name")
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

