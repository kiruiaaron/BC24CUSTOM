page 50269 "HR Medical Scheme Card"
{
    PageType = Card;
    SourceTable = 50154;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Medical Scheme Description"; Rec."Medical Scheme Description")
                {
                    ApplicationArea = All;
                }
                field(Provider; Rec.Provider)
                {
                    ApplicationArea = All;
                }
                field("Provider Name"; Rec."Provider Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            part("Medical Scheme Members"; 50270)
            {
                Caption = 'Medical Scheme Members';
                SubPageLink = "Scheme No" = FIELD("No.");
                ApplicationArea = All;
            }
            part("Medical Scheme Beneficiaries"; 50271)
            {
                Caption = 'Medical Scheme Beneficiaries';
                SubPageLink = "Scheme No" = FIELD("No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Exit Interview")
            {
                Caption = '&Exit Interview';
                action("Insert Employees")
                {
                    Caption = 'Insert Employees';
                    Image = Hierarchy;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        SchemeNo := '';
                        Scheme.RESET;
                        Scheme.SETRANGE(Scheme."No.", Rec."No.");
                        IF Scheme.FINDFIRST THEN BEGIN
                            SchemeNo := Scheme."No.";
                        END;

                        Members3.RESET;
                        Members3.SETRANGE(Members3."Scheme No", Rec."No.");
                        IF Members3.FINDSET THEN BEGIN
                            Members3.DELETE;
                        END;

                        Employees.RESET;
                        //Employees.SETRANGE(Employees.Age,Employees.Age::"0");//to be reviewed later
                        Employees.SETRANGE(Employees.Status, Employees.Status::Active);
                        IF Employees.FINDSET THEN BEGIN
                            REPEAT
                                LineNo := LineNo + 1;
                                Members.INIT;
                                Members."Line No" := LineNo;
                                Members."Scheme No" := SchemeNo;
                                Members."Employee No" := Employees."No.";
                                Members.VALIDATE(Members."Employee No");
                                Members."Dependant Name" := UPPERCASE(COPYSTR(Employees."First Name" + ' ' + Employees."Middle Name" + ' ' + Employees."Last Name", 1, 249));
                                Members."Cover Option" := Members."Cover Option"::Principal;
                                Members."Date of Birth" := Employees."Birth Date";
                                Members.INSERT;
                            UNTIL Employees.NEXT = 0;
                        END;
                        MESSAGE(MembersMessage);
                    end;
                }
                action("Insert Beneficiaries")
                {
                    Image = BreakRulesList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = All;
                    //  RunObject = Report 50075;

                    trigger OnAction()
                    begin
                        /*SchemeNo:='';
                        Scheme.RESET;
                        Scheme.SETRANGE(Scheme."No.","No.");
                        IF Scheme.FINDFIRST THEN BEGIN
                           SchemeNo:=Scheme."No.";
                          END;
                        
                        Members3.RESET;
                        Members3.SETRANGE(Members3."Scheme No","No.");
                        Members3.SETRANGE(Members3."Cover Option",Members3."Cover Option"::Dependant);
                        IF Members3.FINDSET THEN BEGIN
                          Members3.DELETE;
                          END;
                        
                        Members3.RESET;
                        Members3.SETRANGE(Members3."Scheme No","No.");
                        IF Members3.FINDLAST THEN BEGIN
                          LineNumber:=Members3."Line No";
                          END;
                        
                        Members2.RESET;
                        Members2.SETRANGE(Members2."Scheme No","No.");
                        IF Members2.FINDSET THEN BEGIN
                        REPEAT
                        Relatives.RESET;
                        Relatives.SETRANGE(Relatives."Employee No.",Members2."Employee No");
                        Relatives.SETRANGE(Relatives.Type,Relatives.Type::Relative);
                        IF Relatives.FINDSET THEN BEGIN
                        REPEAT
                        LineNumber:=LineNumber+1;
                        Members.INIT;
                        Members."Line No":=LineNumber;
                        Members."Scheme No":= SchemeNo;
                        Members."Employee No":=Members2."Employee No";
                        Members."Principal No":=Members2."Employee No";
                        Members."Dependant Name":=Relatives.Firstname+''+Relatives.Middlename+''+Relatives.Surname;
                        Members.Relation:=Relatives."Relative Code";
                        Members."Cover Option":=Members2."Cover Option"::Dependant;
                        Members."Date of Birth":=Relatives."Date of Birth";
                        Members.INSERT;
                        UNTIL Relatives.NEXT=0;
                        END;
                        UNTIL Members2.NEXT=0;
                        END;
                        MESSAGE(MembersMessage);*/

                    end;
                }
                action("HR Medical Scheme Report")
                {
                    Image = ResourceRegisters;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Headers.RESET;
                        Headers.SETRANGE(Headers."No.", Rec."No.");
                        IF Headers.FINDFIRST THEN BEGIN
                            //   REPORT.RUNMODAL(REPORT::"HR Medical Scheme Report", TRUE, FALSE, Headers);
                        END;
                    end;
                }
            }
        }
    }

    var
        Relatives: Record 50115;
        Members: Record 50155;
        Scheme: Record 50154;
        Employees: Record 5200;
        SchemeNo: Code[20];
        LineNo: Integer;
        Members2: Record 50155;
        Members3: Record 50155;
        LineNumber: Integer;
        LineNumber2: Integer;
        MembersMessage: Label 'List Updated!';
        Headers: Record 50154;
}

