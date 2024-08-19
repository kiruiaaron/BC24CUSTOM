page 51600 "Brand Ambassadors"
{
    CardPageID = "Brand Ambassadors Card";
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "Brand Ambassadors";
    SourceTableView = WHERE(converted = CONST(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("code"; Rec.code)
                {
                }
                field("First Name"; Rec."First Name")
                {
                }
                field("Middle Name"; Rec."Middle Name")
                {
                }
                field("Last Name"; Rec."Last Name")
                {
                }
                field("Id Number"; Rec."Id Number")
                {
                }
                field("Phone Number"; Rec."Phone Number")
                {
                }
                field("Region Code"; Rec."Region Code")
                {
                }
                field(Gender; Rec.Gender)
                {
                    Visible = true;
                }
                field(Select; Rec.Select)
                {
                }
                field("Email Address"; Rec."Email Address")
                {
                    Visible = false;
                }
                field("Physical Address"; Rec."Physical Address")
                {
                }
                field("Price Per Day"; Rec."Price Per Day")
                {
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    Enabled = false;
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
                action("Create Resource")
                {
                    Caption = 'Recruit Brand Ambassadors';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Category10;

                    trigger OnAction()
                    begin
                        Rec.TestField("Id Number");
                        rec.TestField("Phone Number");
                        //VALIDATE("Id Number");
                        //VALIDATE("Phone Number");
                        BrandAmbassadors.Reset;
                        BrandAmbassadors.SetRange(converted, false);
                        BrandAmbassadors.SetRange(Select, true);
                        //BrandAmbassadors.SETRANGE(Status, BrandAmbassadors.Status::Approved);
                        if BrandAmbassadors.FindSet then begin
                            repeat

                                //BrandAmbassadors.TESTFIELD("B A Category");
                                Resource.Reset;
                                Resource.Init;
                                Resource."Resource Type" := Resource."Resource Type"::"Brand Ambassador";
                                Resource."No." := '';
                                Resource.Name := BrandAmbassadors."First Name" + ' ' + BrandAmbassadors."Middle Name" + ' ' + BrandAmbassadors."Last Name";
                                Resource.Validate(Name);
                                Resource."Unit Cost" := BrandAmbassadors."Price Per Day";
                                Resource."Id Number" := BrandAmbassadors."Id Number";
                                Resource."Phone Number" := BrandAmbassadors."Phone Number";
                                Resource."Email Address" := BrandAmbassadors."Email Address";
                                Resource."Physical Address" := BrandAmbassadors."Physical Address";
                                Resource."Bank Code" := BrandAmbassadors."Bank Code";
                                Resource."Bank Name" := BrandAmbassadors."Bank Name";
                                Resource."Branch Code" := BrandAmbassadors."Branch Code";
                                Resource."Account Number" := BrandAmbassadors."Account Number";
                                Resource."Branch Name" := BrandAmbassadors."Branch Name";
                                Resource."B A Category" := BrandAmbassadors."B A Category";
                                Resource."B A Category Name" := BrandAmbassadors."B A Category Name";
                                Resource.Height := BrandAmbassadors.Height;
                                Resource."Body Size" := BrandAmbassadors."Body Size";
                                Resource.Complexion := BrandAmbassadors.Complexion;
                                Resource.Brand := BrandAmbassadors.Project;
                                Resource.Weight := BrandAmbassadors.Weight;
                                Resource.Gender := BrandAmbassadors.Gender;
                                Resource."Project Code" := BrandAmbassadors.Project;
                                Resource.Validate("Project Code");
                                Resource."Region Code" := BrandAmbassadors."Region Code";

                                Resource.Validate("Region Code");

                                if Resource.Insert(true) then begin


                                    BrandAmbassadors.converted := true;
                                    BrandAmbassadors.Modify(true);
                                    //create bank
                                    VendorBankAccount.Init;
                                    VendorBankAccount."Vendor No." := BrandAmbassadors."B A Category";
                                    VendorBankAccount.Code := Resource."No.";
                                    VendorBankAccount."Bank Account No." := BrandAmbassadors."Account Number";
                                    VendorBankAccount."Bank Code" := BrandAmbassadors."Bank Code";
                                    VendorBankAccount."Bank Name" := BrandAmbassadors."Bank Name";
                                    VendorBankAccount."Branch Code" := BrandAmbassadors."Branch Code";
                                    VendorBankAccount."Branch Name" := BrandAmbassadors."Branch Name";
                                    VendorBankAccount.Insert(true);


                                end;
                            until BrandAmbassadors.Next = 0;
                        end;
                    end;
                }
            }
            action("Select All")
            {
                Image = SelectEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to select all?') = true then begin
                        BrandAmbassadors.Reset;
                        if BrandAmbassadors.FindSet then begin
                            repeat
                                BrandAmbassadors.Select := true;
                                BrandAmbassadors.Modify;
                            until BrandAmbassadors.Next = 0;
                        end;
                    end;
                end;
            }
            action("Un Select All")
            {
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to un select all?') = true then begin
                        BrandAmbassadors.Reset;
                        if BrandAmbassadors.FindSet then begin
                            repeat
                                BrandAmbassadors.Select := false;
                                BrandAmbassadors.Modify;
                            until BrandAmbassadors.Next = 0;
                        end;
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        //ADDED ON 23/11/2018 TO FILTER BY REGION
        Rec.SetRange("Created By", UserId);
    end;

    var
        BrandAmbassadors: Record "Brand Ambassadors";
        Resource: Record Resource;
        VendorBankAccount: Record "Vendor Bank Account";
        Employee: Record Employee;
}

