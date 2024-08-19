page 50521 "Incoming Mail Card ES"
{
    PageType = Card;
    SourceTable = 50263;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field("Sender Details"; Rec."Sender Details")
                {
                    ApplicationArea = All;
                }
                field(Subject; Rec.Subject)
                {
                    ApplicationArea = All;
                }
                field("Letter Description"; Rec."Letter Description")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Import Attachment")
            {
                Image = ImportLog;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                //  //FileManagementUpload: Codeunit 50027;
                begin
                    // FileManagementUpload.UploadFile_CompMailDoc(Rec);
                end;
            }
            action("View Attachment")
            {
                Image = ExportAttachment;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                //  //FileManagementUpload: Codeunit 50027;
                begin
                    //    FileManagementUpload.DownloadFile("Document Path");
                end;
            }
            action("Forward to MD")
            {
                Image = MoveUp;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF NOT CONFIRM('Are you Sure you want to forward to MD for action?') THEN
                        EXIT;
                    Rec.Stage := Rec.Stage::MD;
                    Rec.MODIFY;
                    MESSAGE('Forwarded Successful');
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Mail Direction" := Rec."Mail Direction"::Incoming;
    end;
}

