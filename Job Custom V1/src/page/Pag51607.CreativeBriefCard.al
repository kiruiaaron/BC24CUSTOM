page 51607 "Creative Brief Card"
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
                field("Creative Lead Person"; Rec."Creative Lead Person")
                {
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
                    Caption = 'Expectations';
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
                field(Deliverables; Rec.Deliverables)
                {
                }
                field("Brief Date"; Rec."Brief Date")
                {
                }
                field("Creative Deliverable Date"; Rec."Creative Deliverable Date")
                {
                    Caption = 'Proposed Deliverable Date';
                }
                field(Contact; Rec.Contact)
                {
                    Caption = 'Client Contact';
                }
                field("Contact Name"; Rec."Contact Name")
                {
                }
                field(Priority; Rec.Priority)
                {
                }
                field("Created By"; Rec."Created By")
                {
                    Editable = false;
                }
                field("Date Created"; Rec."Date Created")
                {
                    Editable = false;
                }
                field("Time Created"; Rec."Time Created")
                {
                    Editable = false;
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
                action("Send Notification")
                {
                    Image = Email;
                    Promoted = true;

                    trigger OnAction()
                    var
                        email: Text;
                    begin

                        Employee.Reset;
                        //  /   Employee.SetRange("Notify Creative", true);
                        if Employee.FindSet then begin
                            repeat
                                email := Employee."Company E-Mail";
                            //   SMTPMailSetup.Reset;
                            //  SMTPMailSetup.Get;
                            // to be      SMTPMail.CreateMessage('TRUEBLAQ',SMTPMailSetup."Email Sender Address",email,'Customer Onboarding' ,'Dear '+Employee.FullName+',<br/>You have a job to schedule' ,TRUE);
                            //SMTPMail.Send;
                            until Employee.Next = 0;
                        end;

                        Rec."Brief Sent" := true;
                        Rec.Modify;
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
        /*   SMTPMail: Codeunit "SMTP Mail";
          SMTPMailSetup: Record "SMTP Mail Setup"; */
        Employee: Record Employee;
}

