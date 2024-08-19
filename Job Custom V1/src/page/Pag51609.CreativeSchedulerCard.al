page 51609 "Creative Scheduler Card"
{
    PageType = Card;
    SourceTable = "Creative Scheduler";

    layout
    {
        area(content)
        {
            group(General)
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
                    Caption = 'Expectations';
                    Editable = false;
                    MultiLine = true;

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
                field("Creative Deliverable Date"; Rec."Creative Deliverable Date")
                {
                }
                field(Priority; Rec.Priority)
                {
                }
                field("Lead Creative"; Rec."Lead Creative")
                {
                }
                field("Start Date"; Rec."Start Date")
                {
                }
                field("End Date"; Rec."End Date")
                {
                }
                field("Created By"; Rec."Created By")
                {
                }
                field("Date Created"; Rec."Date Created")
                {
                }
                field("Time Created"; Rec."Time Created")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group(Action15)
            {
                action(Schedule)
                {
                    Image = Post;
                    Promoted = true;

                    trigger OnAction()
                    var
                        email: Text;
                    begin
                        Rec.TestField("Creative Lead Person");
                        if UserSetup.Get(Rec."Creative Lead Person") then begin

                            /*  SMTPMailSetup.Reset;
                             SMTPMailSetup.Get; */
                            email := UserSetup."E-Mail";
                            // to be      SMTPMail.CreateMessage('TRUEBLAQ',SMTPMailSetup."Email Sender Address",email,'Task Scheduled' ,'Dear '+"Creative Lead Person"+',<br/>Your task, '+Rec.Job+'  has been scheduled for '+FORMAT(Rec."Start Date")+' to '+FORMAT(Rec."End Date") ,TRUE

                            // SMTPMail.Send;

                            Rec."Schedule Sent" := true;
                            Rec.Modify;
                            Message('Scheduled. The next record has been opened');
                        end;
                    end;
                }
            }
        }
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
        /*  SMTPMail: Codeunit "SMTP Mail";
         SMTPMailSetup: Record "SMTP Mail Setup"; */
        Employee: Record Employee;
        UserSetup: Record "User Setup";
}

