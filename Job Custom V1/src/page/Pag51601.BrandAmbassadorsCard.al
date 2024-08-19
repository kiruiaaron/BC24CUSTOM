page 51601 "Brand Ambassadors Card"
{
    DeleteAllowed = true;
    Editable = true;
    PageType = Card;
    SourceTable = "Brand Ambassadors";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("code"; Rec.code)
                {
                    Editable = false;
                }
                field("First Name"; Rec."First Name")
                {
                    Editable = editable;
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    Editable = editable;
                }
                field("Last Name"; Rec."Last Name")
                {
                    Editable = editable;
                }
                field("Id Number"; Rec."Id Number")
                {
                    Editable = editable;
                }
                field("B A Category"; Rec."B A Category")
                {
                    Visible = false;
                }
                field("Price Per Day"; Rec."Price Per Day")
                {
                    Editable = false;
                    Visible = false;
                }
                field("B A Category Name"; Rec."B A Category Name")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Height; Rec.Height)
                {
                }
                field(Gender; Rec.Gender)
                {
                }
                field(Weight; Rec.Weight)
                {
                }
                field("Body Size"; Rec."Body Size")
                {
                }
                field(Complexion; Rec.Complexion)
                {
                }
                field(Project; Rec.Project)
                {
                    Visible = false;
                }
                field("Project Name"; Rec."Project Name")
                {
                    Editable = false;
                    Visible = false;
                }
                field(objText; objText)
                {
                    Caption = 'Comments';
                    Editable = editable;
                    MultiLine = true;

                    trigger OnValidate()
                    begin
                        Rec.CalcFields(Comments);
                        Rec.Comments.CreateInStream(ObjInstr);
                        Obj.Read(ObjInstr);

                        if objText <> Format(Obj) then begin
                            Clear(Rec.Comments);
                            Clear(Obj);
                            Obj.AddText(objText);
                            Rec.Comments.CreateOutStream(ObjOutStr);
                            Obj.Write(ObjOutStr);
                            //MODIFY;
                        end;
                    end;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    Enabled = false;
                    Visible = false;
                }
                field("Region Code"; Rec."Region Code")
                {
                }
                field("Region Name"; Rec."Region Name")
                {
                    Editable = false;
                }
                field("Created By"; Rec."Created By")
                {
                    Editable = false;
                }
                field("Created On"; Rec."Created On")
                {
                    Editable = false;
                }
            }
            group(Communication)
            {
                field("Phone Number"; Rec."Phone Number")
                {
                    Editable = editable;
                }
                field("Email Address"; Rec."Email Address")
                {
                    Editable = editable;
                }
                field("Physical Address"; Rec."Physical Address")
                {
                    Editable = editable;
                }
            }
            group("Bank Details")
            {
                field("Bank Code"; Rec."Bank Code")
                {
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    Editable = false;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    Editable = false;
                }
                field("Account Number"; Rec."Account Number")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group(Action13)
            {
                action("Create Resource")
                {
                    Caption = 'Recruit Brand Ambassadors';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Category10;

                    trigger OnAction()
                    begin
                        //TESTFIELD(Status, Status::Approved);
                        //TESTFIELD("B A Category");
                        Rec.TestField("Id Number");
                        Rec.TestField("Phone Number");
                        //MESSAGE('%1',"Phone Number");
                        //BrandAmbassadors.TESTFIELD("B A Category");
                        //Resource.RESET;
                        //Resource.SETRANGE(Resource."Phone Number","Phone Number");
                        //IF Resource.FINDFIRST() THEN
                        //ERROR('The phone number: %1 is already being used by: %2',"Phone Number",Resource.Name);
                        Resource.Init;
                        Resource.Name := Rec."First Name" + ' ' + Rec."Middle Name" + ' ' + Rec."Last Name";
                        Resource.Validate(Name);
                        Resource."Unit Cost" := Rec."Price Per Day";
                        Resource."Id Number" := Rec."Id Number";
                        Resource."Phone Number" := Rec."Phone Number";
                        Resource."Email Address" := Rec."Email Address";
                        Resource."Physical Address" := Rec."Physical Address";
                        Resource."Bank Code" := Rec."Bank Code";
                        Resource."Bank Name" := Rec."Bank Name";
                        Resource."Branch Code" := Rec."Branch Code";
                        Resource."Account Number" := Rec."Account Number";
                        Resource."Branch Name" := Rec."Branch Name";
                        Resource."B A Category" := Rec."B A Category";
                        Resource."B A Category Name" := Rec."B A Category Name";
                        Resource.Height := Rec.Height;
                        Resource."Body Size" := Rec."Body Size";
                        Resource.Complexion := Rec.Complexion;
                        //Resource.Brand:= Project;
                        Resource."Project Code" := Rec.Project;
                        Resource.Validate("Project Code");
                        Resource.Weight := Rec.Weight;
                        Resource.Gender := Rec.Gender;
                        Resource."Region Code" := Rec."Region Code";
                        Resource.Validate("Region Code");
                        Resource."Resource Type" := Resource."Resource Type"::"Brand Ambassador";
                        if Resource.Insert(true) then begin
                            Rec.converted := true;
                            Rec.Modify(true);
                            //create bank
                            /*VendorBankAccount.INIT;
                            VendorBankAccount."Vendor No.":= "B A Category";
                            VendorBankAccount.Code:= Resource."No.";
                            VendorBankAccount."Bank Account No.":= "Account Number";
                            VendorBankAccount."Bank Code":= "Bank Code";
                            VendorBankAccount."Bank Name":= "Bank Name";
                            VendorBankAccount."Branch Code":= "Branch Code";
                            VendorBankAccount."Branch Name":= "Branch Name";
                            VendorBankAccount.INSERT(TRUE);
                            */


                        end;
                        Message('Resource was successfully created');

                    end;
                }
                action("Send Approval Request")
                {
                    Image = Approve;
                    Promoted = true;

                    trigger OnAction()
                    begin
                        Rec.Status := Rec.Status::Approved;
                        Rec.Modify;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        editable := true;
        if Rec.Status <> Rec.Status::Open then
            editable := false;

        Rec.CalcFields(Comments);
        Rec.Comments.CreateInStream(ObjInstr);
        Obj.Read(ObjInstr);
        objText := Format(Obj);
    end;

    var
        objText: Text;
        Resource: Record Resource;
        editable: Boolean;
        Obj: BigText;
        ObjInstr: InStream;
        ObjOutStr: OutStream;
        EmployeeBankAccountX: Record "Employee Bank AccountX";
        VendorBankAccount: Record "Vendor Bank Account";
}

