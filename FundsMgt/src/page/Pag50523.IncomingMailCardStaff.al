page 50523 "Incoming Mail Card Staff"
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
                field("MD Comments/Instructions"; Rec."MD Comments/Instructions")
                {
                    Editable = false;
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Forwarded For action To"; Rec."Forwarded For action To")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Action Comments"; Rec."Action Comments")
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
                //FileManagementUpload: Codeunit 50027;
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
                //FileManagementUpload: Codeunit 50027;
                begin
                    //  FileManagementUpload.DownloadFile("Document Path");
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Mail Direction" := Rec."Mail Direction"::Incoming;
    end;
}

