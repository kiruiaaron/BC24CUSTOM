page 50528 "Board Papers"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50278;
    SourceTableView = WHERE(Type = CONST(Papers));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No"; Rec."Entry No")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Quarter; Rec.Quarter)
                {
                    ApplicationArea = All;
                }
                field("Board Committee"; Rec."Board Committee")
                {
                    ApplicationArea = All;
                }
                field("Created by"; Rec."Created by")
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
                begin
                    // FileManagementUpload.UploadFile_BoardfilesDoc(Rec);
                end;
            }
            action("View Attachment")
            {
                Image = ExportAttachment;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //  FileManagementUpload.DownloadFile("Document Name");
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Papers
    end;

    var
    //FileManagementUpload: Codeunit 50027;
}

