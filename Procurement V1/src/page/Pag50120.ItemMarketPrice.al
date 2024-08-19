page 50120 "Item Market Price"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50072;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Market Price"; Rec."Market Price")
                {
                    ApplicationArea = All;
                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = All;
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = All;
                }
                field(Current; Rec.Current)
                {
                    ApplicationArea = All;
                }
                field(Archived; Rec.Archived)
                {
                    ApplicationArea = All;
                }
                field("Adjusted By"; Rec."Adjusted By")
                {
                    ApplicationArea = All;
                }
                field("Archived By"; Rec."Archived By")
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
            action("Validate Current Price")
            {
                Image = AddToHome;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    /*ItemMarketPrice2.RESET;
                    ItemMarketPrice2.SETRANGE(ItemMarketPrice2.Archived,TRUE);
                    IF ItemMarketPrice2.FINDFIRST THEN BEGIN
                        ItemMarketPrice.RESET;
                        ItemMarketPrice.SETRANGE(ItemMarketPrice.Archived,FALSE);
                        IF ItemMarketPrice.FINDFIRST THEN BEGIN
                          ItemMarketPrice.Archived:=TRUE;
                          ItemMarketPrice."To Date":=TODAY;
                          ItemMarketPrice.MODIFY;
                        END;
                    
                        ItemMarketPrice.RESET;
                        ItemMarketPrice.SETRANGE(ItemMarketPrice.Archived,FALSE);
                        IF ItemMarketPrice.FINDLAST THEN BEGIN
                          ItemMarketPrice.Current:=TRUE;
                          ItemMarketPrice.MODIFY;
                          ItemStock.RESET;
                          ItemStock.SETRANGE(ItemStock."No.",ItemMarketPrice.Item);
                          IF ItemStock.FINDFIRST THEN BEGIN
                            ItemStock."Market Price":=ItemMarketPrice."Market Price";
                            ItemStock.MODIFY;
                          END;
                         END;
                        END ELSE BEGIN
                          ItemMarketPrice.RESET;
                          ItemMarketPrice.SETRANGE(ItemMarketPrice.Archived,FALSE);
                          IF ItemMarketPrice.FINDLAST THEN BEGIN
                          ItemMarketPrice.Current:=TRUE;
                          ItemMarketPrice.MODIFY;
                          ItemStock.RESET;
                          ItemStock.SETRANGE(ItemStock."No.",ItemMarketPrice.Item);
                          IF ItemStock.FINDFIRST THEN BEGIN
                            ItemStock."Market Price":=ItemMarketPrice."Market Price";
                            ItemStock.MODIFY;
                          END;
                      END;
                    END;
                    */
                    ItemMarketPrice.RESET;
                    ItemMarketPrice.SETRANGE(ItemMarketPrice.Item, Rec.Item);
                    ItemMarketPrice.SETRANGE(ItemMarketPrice.Archived, FALSE);
                    IF ItemMarketPrice.FINDFIRST THEN BEGIN
                        ItemMarketPrice.TESTFIELD(ItemMarketPrice."Market Price");
                        ItemMarketPrice.Current := TRUE;
                        ItemMarketPrice.MODIFY;
                        ItemStock.RESET;
                        ItemStock.SETRANGE(ItemStock."No.", ItemMarketPrice.Item);
                        IF ItemStock.FINDFIRST THEN BEGIN
                            ItemStock."Market Price" := ItemMarketPrice."Market Price";
                            ItemStock.MODIFY;
                        END;
                    END;

                    MESSAGE('Market Price adjusted accordingly');
                    CurrPage.CLOSE;

                end;
            }
            action("Archive Price")
            {
                Image = AutoReserve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF Rec.Archived = TRUE THEN
                        ERROR('Price already archived.');


                    Rec.Archived := TRUE;
                    Rec."To Date" := TODAY;
                    Rec."Archived By" := USERID;
                    Rec.MODIFY;
                    MESSAGE('Price sucessfuly archived!');

                    CurrPage.CLOSE;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        IF Rec.Archived = TRUE THEN
            CurrPage.EDITABLE(FALSE);
    end;

    var
        ItemMarketPrice: Record 50072;
        ItemStock: Record 27;
        ItemMarketPrice2: Record 50072;
}

