

page 50790 "Finace Role Center"
{
    Caption = 'Accountant', Comment = 'Use same translation as ''Profile Description'' (if applicable)';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part(Control76; "Headline RC Accountant")
            {
                ApplicationArea = Basic, Suite;
            }
            part(Control99; "Finance Performance")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            part(Control1902304208; "Accountant Activities")
            {
                ApplicationArea = Basic, Suite;
            }
            part("Intercompany Activities"; "Intercompany Activities")
            {
                ApplicationArea = Intercompany;
            }
            part("User Tasks Activities"; "User Tasks Activities")
            {
                ApplicationArea = Suite;
            }
            part("Emails"; "Email Activities")
            {
                ApplicationArea = Basic, Suite;
            }
            part(ApprovalsActivities; "Approvals Activities")
            {
                ApplicationArea = Suite;
            }
            part(Control123; "Team Member Activities")
            {
                ApplicationArea = Suite;
            }
            part(Control1907692008; "My Accounts")
            {
                ApplicationArea = Basic, Suite;
            }
            part(Control103; "Trailing Sales Orders Chart")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            part(Control106; "My Job Queue")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            part(Control9; "Help And Chart Wrapper")
            {
                ApplicationArea = Basic, Suite;
            }
            part(Control100; "Cash Flow Forecast Chart")
            {
                ApplicationArea = Basic, Suite;
            }
            part(Control108; "Report Inbox Part")
            {
                AccessByPermission = TableData "Report Inbox" = IMD;
                ApplicationArea = Basic, Suite;
            }
            part(PowerBIEmbeddedReportPart; "Power BI Embedded Report Part")
            {
                ApplicationArea = Basic, Suite;
            }
            systempart(Control1901377608; MyNotes)
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
        area(reporting)
        {
            group("G/L Reports")
            {
                Caption = 'G/L Reports';
                action("&G/L Trial Balance")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&G/L Trial Balance';
                    Image = "Report";
                    RunObject = Report "Trial Balance";
                    ToolTip = 'View, print, or send a report that shows the balances for the general ledger accounts, including the debits and credits. You can use this report to ensure accurate accounting practices.';
                }
                action("&Bank Detail Trial Balance")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Bank Detail Trial Balance';
                    Image = "Report";
                    RunObject = Report "Bank Acc. - Detail Trial Bal.";
                    ToolTip = 'View, print, or send a report that shows a detailed trial balance for selected bank accounts. You can use the report at the close of an accounting period or fiscal year.';
                }
                action("&Account Schedule")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Account Schedule';
                    Image = "Report";
                    RunObject = Report "Account Schedule";
                    ToolTip = 'Open an account schedule to analyze figures in general ledger accounts or to compare general ledger entries with general ledger budget entries.';
                }
                action("Bu&dget")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bu&dget';
                    Image = "Report";
                    RunObject = Report Budget;
                    ToolTip = 'View or edit estimated amounts for a range of accounting periods.';
                }
                action("Trial Bala&nce/Budget")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Trial Bala&nce/Budget';
                    Image = "Report";
                    RunObject = Report "Trial Balance/Budget";
                    ToolTip = 'View a trial balance in comparison to a budget. You can choose to see a trial balance for selected dimensions. You can use the report at the close of an accounting period or fiscal year.';
                }
                action("Trial Balance by &Period")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Trial Balance by &Period';
                    Image = "Report";
                    RunObject = Report "Trial Balance by Period";
                    ToolTip = 'Show the opening balance by general ledger account, the movements in the selected period of month, quarter, or year, and the resulting closing balance.';
                }
                action("&Fiscal Year Balance")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Fiscal Year Balance';
                    Image = "Report";
                    RunObject = Report "Fiscal Year Balance";
                    ToolTip = 'View, print, or send a report that shows balance sheet movements for selected periods. The report shows the closing balance by the end of the previous fiscal year for the selected ledger accounts. It also shows the fiscal year until this date, the fiscal year by the end of the selected period, and the balance by the end of the selected period, excluding the closing entries. The report can be used at the close of an accounting period or fiscal year.';
                }
                action("Balance Comp. - Prev. Y&ear")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Balance Comp. - Prev. Y&ear';
                    Image = "Report";
                    RunObject = Report "Balance Comp. - Prev. Year";
                    ToolTip = 'View a report that shows your company''s assets, liabilities, and equity compared to the previous year.';
                }
                action("&Closing Trial Balance")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Closing Trial Balance';
                    Image = "Report";
                    RunObject = Report "Closing Trial Balance";
                    ToolTip = 'View, print, or send a report that shows this year''s and last year''s figures as an ordinary trial balance. The closing of the income statement accounts is posted at the end of a fiscal year. The report can be used in connection with closing a fiscal year.';
                }
                action("Dimensions - Total")
                {
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions - Total';
                    Image = "Report";
                    RunObject = Report "Dimensions - Total";
                    ToolTip = 'View how dimensions or dimension sets are used on entries based on total amounts over a specified period and for a specified analysis view.';
                }
            }
            group("Cash Flow")
            {
                Caption = 'Cash Flow';
                action("Cash Flow Date List")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cash Flow Date List';
                    Image = "Report";
                    RunObject = Report "Cash Flow Date List";
                    ToolTip = 'View forecast entries for a period of time that you specify. The registered cash flow forecast entries are organized by source types, such as receivables, sales orders, payables, and purchase orders. You specify the number of periods and their length.';
                }
            }
            group("Customers and Vendors")
            {
                Caption = 'Customers and Vendors';
                action("Aged Accounts &Receivable")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Aged Accounts &Receivable';
                    Image = "Report";
                    RunObject = Report "Aged Accounts Receivable";
                    ToolTip = 'View an overview of when your receivables from customers are due or overdue (divided into four periods). You must specify the date you want aging calculated from and the length of the period that each column will contain data for.';
                }
                action("Aged Accounts Pa&yable")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Aged Accounts Pa&yable';
                    Image = "Report";
                    RunObject = Report "Aged Accounts Payable";
                    ToolTip = 'View an overview of when your payables to vendors are due or overdue (divided into four periods). You must specify the date you want aging calculated from and the length of the period that each column will contain data for.';
                }
                action("Reconcile Cus&t. and Vend. Accs")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Reconcile Cus&t. and Vend. Accs';
                    Image = "Report";
                    RunObject = Report "Reconcile Cust. and Vend. Accs";
                    ToolTip = 'View if a certain general ledger account reconciles the balance on a certain date for the corresponding posting group. The report shows the accounts that are included in the reconciliation with the general ledger balance and the customer or the vendor ledger balance for each account and shows any differences between the general ledger balance and the customer or vendor ledger balance.';
                }
            }
            group("VAT Reports")
            {
                Caption = 'VAT Reports';
                action("&VAT Registration No. Check")
                {
                    ApplicationArea = VAT;
                    Caption = '&VAT Registration No. Check';
                    Image = "Report";
                    RunObject = Report "VAT Registration No. Check";
                    ToolTip = 'Use an EU VAT number validation service to validated the VAT number of a business partner.';
                }
                action("VAT E&xceptions")
                {
                    ApplicationArea = VAT;
                    Caption = 'VAT E&xceptions';
                    Image = "Report";
                    RunObject = Report "VAT Exceptions";
                    ToolTip = 'View the VAT entries that were posted and placed in a general ledger register in connection with a VAT difference. The report is used to document adjustments made to VAT amounts that were calculated for use in internal or external auditing.';
                }
                action("VAT &Statement")
                {
                    ApplicationArea = VAT;
                    Caption = 'VAT &Statement';
                    Image = "Report";
                    RunObject = Report "VAT Statement";
                    ToolTip = 'View a statement of posted VAT and calculate the duty liable to the customs authorities for the selected period.';
                }
                action("VAT - VIES Declaration Tax Aut&h")
                {
                    ApplicationArea = BasicEU;
                    Caption = 'VAT - VIES Declaration Tax Aut&h';
                    Image = "Report";
                    RunObject = Report "VAT- VIES Declaration Tax Auth";
                    ToolTip = 'View information to the customs and tax authorities for sales to other EU countries/regions. If the information must be printed to a file, you can use the VAT- VIES Declaration Disk report.';
                }
                action("VAT - VIES Declaration Dis&k")
                {
                    ApplicationArea = BasicEU;
                    Caption = 'VAT - VIES Declaration Dis&k';
                    Image = "Report";
                    RunObject = Report "VAT- VIES Declaration Disk";
                    ToolTip = 'Report your sales to other EU countries or regions to the customs and tax authorities. If the information must be printed out on a printer, you can use the VAT- VIES Declaration Tax Auth report. The information is shown in the same format as in the declaration list from the customs and tax authorities.';
                }
                action("EC Sales &List")
                {
                    ApplicationArea = BasicEU;
                    Caption = 'EC Sales &List';
                    Image = "Report";
                    RunObject = Report "EC Sales List";
                    ToolTip = 'Calculate VAT amounts from sales, and submit the amounts to a tax authority.';
                }
            }
#if not CLEAN22
            group(Action60)
            {
                Caption = 'Intrastat';
                ObsoleteState = Pending;
                ObsoleteTag = '22.0';
                ObsoleteReason = 'Intrastat related functionalities are moved to Intrastat extensions.';
                action("&Intrastat - Checklist")
                {
                    ApplicationArea = BasicEU;
                    Caption = '&Intrastat - Checklist';
                    Image = "Report";
                    RunObject = Report "Intrastat - Checklist";
                    ToolTip = 'View a checklist that you can use to find possible errors before printing and also as documentation for what is printed. You can use the report to check the Intrastat journal before you use the Intrastat - Make Disk Tax Auth batch job.';
                    ObsoleteState = Pending;
                    ObsoleteTag = '22.0';
                    ObsoleteReason = 'Intrastat related functionalities are moved to Intrastat extensions.';
                }
                action("Intrastat - For&m")
                {
                    ApplicationArea = BasicEU;
                    Caption = 'Intrastat - For&m';
                    Image = "Report";
                    RunObject = Report "Intrastat - Form";
                    ToolTip = 'View all the information that must be transferred to the printed Intrastat form.';
                    ObsoleteState = Pending;
                    ObsoleteTag = '22.0';
                    ObsoleteReason = 'Intrastat related functionalities are moved to Intrastat extensions.';
                }
            }
#endif
            group("Cost Accounting")
            {
                Caption = 'Cost Accounting';
                action("Cost Accounting P/L Statement")
                {
                    ApplicationArea = CostAccounting;
                    Caption = 'Cost Accounting P/L Statement';
                    Image = "Report";
                    RunObject = Report "Cost Acctg. Statement";
                    ToolTip = 'View the credit and debit balances per cost type, together with the chart of cost types.';
                }
                action("CA P/L Statement per Period")
                {
                    ApplicationArea = CostAccounting;
                    Caption = 'CA P/L Statement per Period';
                    Image = "Report";
                    RunObject = Report "Cost Acctg. Stmt. per Period";
                    ToolTip = 'View profit and loss for cost types over two periods with the comparison as a percentage.';
                }
                action("CA P/L Statement with Budget")
                {
                    ApplicationArea = CostAccounting;
                    Caption = 'CA P/L Statement with Budget';
                    Image = "Report";
                    RunObject = Report "Cost Acctg. Statement/Budget";
                    ToolTip = 'View a comparison of the balance to the budget figures and calculates the variance and the percent variance in the current accounting period, the accumulated accounting period, and the fiscal year.';
                }
                action("Cost Accounting Analysis")
                {
                    ApplicationArea = CostAccounting;
                    Caption = 'Cost Accounting Analysis';
                    Image = "Report";
                    RunObject = Report "Cost Acctg. Analysis";
                    ToolTip = 'View balances per cost type with columns for seven fields for cost centers and cost objects. It is used as the cost distribution sheet in Cost accounting. The structure of the lines is based on the chart of cost types. You define up to seven cost centers and cost objects that appear as columns in the report.';
                }
            }
        }
        area(embedding)
        {
            action("Chart of Accounts")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Chart of Accounts';
                RunObject = Page "Chart of Accounts";
                ToolTip = 'Open the chart of accounts.';
            }
            action("Bank Accounts")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Bank Accounts';
                Image = BankAccount;
                RunObject = Page "Bank Account List";
                ToolTip = 'View or set up detailed information about your bank account, such as which currency to use, the format of bank files that you import and export as electronic payments, and the numbering of checks.';
            }

            action(Customers)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
                ToolTip = 'View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.';
            }
            action(Vendors)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Vendors';
                Image = Vendor;
                RunObject = Page "Vendor List";
                ToolTip = 'View or edit detailed information for the vendors that you trade with. From each vendor card, you can open related information, such as purchase statistics and ongoing orders, and you can define special prices and line discounts that the vendor grants you if certain conditions are met.';
            }
            action(VendorsBalance)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Balance';
                Image = Balance;
                RunObject = Page "Vendor List";
                RunPageView = where("Balance (LCY)" = filter(<> 0));
                ToolTip = 'View a summary of the bank account balance in different periods.';
            }
            action("Purchase Orders")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Purchase Orders';
                RunObject = Page "Purchase Order List";
                ToolTip = 'Create purchase orders to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase orders dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase orders allow partial receipts, unlike with purchase invoices, and enable drop shipment directly from your vendor to your customer. Purchase orders can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.';
            }
            action(CustomersBalance)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Balance';
                Image = Balance;
                RunObject = Page "Customer List";
                RunPageView = where("Balance (LCY)" = filter(<> 0));
                ToolTip = 'View a summary of the bank account balance in different periods.';
            }
            action("Incoming Documents")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Incoming Documents';
                Image = Documents;
                RunObject = Page "Incoming Documents";
                ToolTip = 'Handle incoming documents, such as vendor invoices in PDF or as image files, that you can manually or automatically convert to document records, such as purchase invoices. The external files that represent incoming documents can be attached at any process stage, including to posted documents and to the resulting vendor, customer, and general ledger entries.';
            }
            action("Purchase Invoices")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Purchase Invoices';
                Image = Invoice;
                RunObject = Page "Purchase Invoices";
                ToolTip = 'Create purchase invoices to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase invoices dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase invoices can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.';
            }
            action("EC Sales List")
            {
                ApplicationArea = VAT;
                Caption = 'EC Sales List';
                RunObject = Page "EC Sales List Reports";
                ToolTip = 'Calculate VAT amounts from sales, and submit the amounts to a tax authority.';
            }
            action("VAT Returns")
            {
                ApplicationArea = VAT;
                Caption = 'VAT Returns';
                RunObject = Page "VAT Report List";
                ToolTip = 'Prepare the VAT Return report so you can submit VAT amounts to a tax authority.';
            }
            action(Budgets)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Budgets';
                RunObject = Page "G/L Budget Names";
                ToolTip = 'View or edit estimated amounts for a range of accounting periods.';
            }
            action("VAT Statements")
            {
                ApplicationArea = VAT;
                Caption = 'VAT Statements';
                Image = VATStatement;
                RunObject = Page "VAT Statement Names";
                ToolTip = 'View a statement of posted VAT amounts, calculate your VAT settlement amount for a certain period, such as a quarter, and prepare to send the settlement to the tax authorities.';
            }
#if not CLEAN22
            action(Intrastat)
            {
                ApplicationArea = BasicEU;
                Caption = 'Intrastat';
                RunObject = Page "Intrastat Jnl. Batches";
                ToolTip = 'Report your trade with other EU countries/regions for Intrastat reporting.';
                ObsoleteState = Pending;
                ObsoleteTag = '22.0';
                ObsoleteReason = 'Intrastat related functionalities are moved to Intrastat extensions.';
            }
#endif
        }
        area(sections)
        {

            group(Action172)
            {
                Caption = 'Finance';
                Image = Journals;
                ToolTip = 'Collect and make payments, prepare statements, and reconcile bank accounts.';

                action("General Journals")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'General Journals';
                    Image = Journal;
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type" = const(General),
                                        Recurring = const(false));
                    ToolTip = 'Post financial transactions directly to general ledger accounts and other accounts, such as bank, customer, vendor, and employee accounts. Posting with a general journal always creates entries on general ledger accounts. This is true even when, for example, you post a journal line to a customer account, because an entry is posted to a general ledger receivables account through a posting group.';
                }
                action("Recurring General Journals")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Recurring General Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type" = const(General),
                                        Recurring = const(true));
                    ToolTip = 'Define how to post transactions that recur with few or no changes to general ledger, bank, customer, vendor, or fixed asset accounts';
                }
                action(Action170)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Chart of Accounts';
                    RunObject = Page "Chart of Accounts";
                    ToolTip = 'View or organize the general ledger accounts that store your financial data. All values from business transactions or internal adjustments end up in designated G/L accounts. Business Central includes a standard chart of accounts that is ready to support businesses in your country, but you can change the default accounts and add new ones.';
                }
                action("G/L Account Categories")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'G/L Account Categories';
                    RunObject = Page "G/L Account Categories";
                    ToolTip = 'Personalize the structure of your financial statements by mapping general ledger accounts to account categories. You can create category groups by indenting subcategories under them. Each grouping shows a total balance. When you choose the Generate Financial Reports action, the row definitions for the underlying financial reports are updated. The next time you run one of these reports, such as the balance statement, new totals and subentries are added, based on your changes.';
                }
               
                action(Currencies)
                {
                    ApplicationArea = Suite;
                    Caption = 'Currencies';
                    Image = Currency;
                    RunObject = Page Currencies;
                    ToolTip = 'View the different currencies that you trade in or update the exchange rates by getting the latest rates from an external service provider.';
                }

                action(Action14)
                {
                    ApplicationArea = VAT;
                    Caption = 'VAT Statements';
                    RunObject = Page "VAT Statement Names";
                    ToolTip = 'View a statement of posted VAT amounts, calculate your VAT settlement amount for a certain period, such as a quarter, and prepare to send the settlement to the tax authorities.';
                }

                action("Analysis Views")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Analysis Views';
                    RunObject = Page "Analysis View List";
                    ToolTip = 'Analyze amounts in your general ledger by their dimensions using analysis views that you have set up.';
                }
                action("Account Schedules")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Financial Reporting';
                    RunObject = Page "Financial Reports";
                    ToolTip = 'Get insight into the financial data stored in your chart of accounts. Financial reports analyze figures in G/L accounts, and compare general ledger entries with general ledger budget entries. For example, you can view the general ledger entries as percentages of the budget entries. Financial reports provide the data for core financial statements and views, such as the Cash Flow chart.';
                }
                action(Deferrals)
                {
                    ApplicationArea = Suite;
                    Caption = 'Deferrals';
                    RunObject = Page "Deferral Template List";
                    ToolTip = 'Distribute revenues or expenses to the relevant accounting periods instead of the date of posting the transaction. Set up a deferral template for the resource, item, or G/L account that the revenue or expense will be posted for. When you post the related sales or purchase document, the revenue or expense is deferred to the involved accounting periods, according to a deferral schedule that is governed by settings in the deferral template and the posting date.';
                }
                action(Dimensions)
                {
                    ApplicationArea = Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page Dimensions;
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
                }
                action(Partners)
                {
                    ApplicationArea = Intercompany;
                    Caption = 'Partners';
                    RunObject = Page "IC Partner List";
                    ToolTip = 'Set up each company or department within the group of companies as an intercompany partner of type Vendor or Customer. Intercompany partners can then be inserted on regular sales and purchase documents or journal lines that are exchanged through the intercompany inbox/outbox system and posted to agreed accounts in an intercompany chart of accounts.';
                }
                action(Action171)
                {
                    ApplicationArea = Intercompany;
                    Caption = 'IC Chart of Accounts';
                    RunObject = Page "IC Chart of Accounts";
                    ToolTip = 'Manage intercompany transactions within your group of companies in an aligned chart of accounts that uses the same account numbers and settings. In the setup phase, the parent company of the group can create a simplified version of their own chart of accounts and exports it to an XML file that each subsidiary can quickly implement.';
                }
                action(Action173)
                {
                    ApplicationArea = Intercompany;
                    Caption = 'Intercompany Dimensions';
                    RunObject = Page "IC Dimensions";
                    ToolTip = 'Enable companies within a group to exchange transactions with dimensions and to perform financial analysis by dimensions across the group. The parent company of the group can create a simplified version of their own set of dimensions and export them to an XML file that each subsidiary can import into the intercompany Dimensions window and then map them to their own dimensions.';
                }
                action("Accounting Periods")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Accounting Periods';
                    Image = AccountingPeriods;
                    RunObject = Page "Accounting Periods";
                    ToolTip = 'Set up the number of accounting periods, such as 12 monthly periods, within the fiscal year and specify which period is the start of the new fiscal year.';
                }
                action("Number Series")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Number Series';
                    RunObject = Page "No. Series";
                    ToolTip = 'View or edit the number series that are used to organize transactions';
                }
                action("Bank Account Posting Groups")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bank Account Posting Groups';
                    RunObject = Page "Bank Account Posting Groups";
                    ToolTip = 'Set up posting groups, so that payments in and out of each bank account are posted to the specified general ledger account.';
                }
            }
            group(Journals)
            {
                Caption = 'Journals';
                Image = Journals;
                ToolTip = 'Post financial transactions.';
                action(GeneralJournals)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'General Journals';
                    Image = Journal;
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type" = const(General),
                                        Recurring = const(false));
                    ToolTip = 'Post financial transactions directly to general ledger accounts and other accounts, such as bank, customer, vendor, and employee accounts. Posting with a general journal always creates entries on general ledger accounts. This is true even when, for example, you post a journal line to a customer account, because an entry is posted to a general ledger receivables account through a posting group.';
                }
                action("<Action3>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Recurring General Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type" = const(General),
                                        Recurring = const(true));
                    ToolTip = 'Define how to post transactions that recur with few or no changes to general ledger, bank, customer, vendor, or fixed asset accounts';
                }
                action(PurchaseJournals)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Purchase Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type" = const(Purchases),
                                        Recurring = const(false));
                    ToolTip = 'Post any purchase-related transaction directly to a vendor, bank, or general ledger account instead of using dedicated documents. You can post all types of financial purchase transactions, including payments, refunds, and finance charge amounts. Note that you cannot post item quantities with a purchase journal.';
                }
                action(SalesJournals)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type" = const(Sales),
                                        Recurring = const(false));
                    ToolTip = 'Post any sales-related transaction directly to a customer, bank, or general ledger account instead of using dedicated documents. You can post all types of financial sales transactions, including payments, refunds, and finance charge amounts. Note that you cannot post item quantities with a sales journal.';
                }
                action(ICGeneralJournals)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'IC General Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type" = const(Intercompany),
                                        Recurring = const(false));
                    ToolTip = 'Post intercompany transactions. IC general journal lines must contain either an IC partner account or a customer or vendor account that has been assigned an intercompany partner code.';
                }
#if not CLEAN22
                action(Action1102601002)
                {
                    ApplicationArea = BasicEU;
                    Caption = 'Intrastat Journals';
                    Image = "Report";
                    RunObject = Page "Intrastat Jnl. Batches";
                    ToolTip = 'Summarize the value of your purchases and sales with business partners in the EU for statistical purposes and prepare to send it to the relevant authority.';
                    ObsoleteState = Pending;
                    ObsoleteTag = '22.0';
                    ObsoleteReason = 'Intrastat related functionalities are moved to Intrastat extensions.';
                }
#endif
                action(PostedGeneralJournals)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted General Journals';
                    RunObject = Page "Posted General Journal";
                    ToolTip = 'Open the list of posted general journal lines.';
                }
            }
            group("Cash Management")
            {
                Caption = 'Cash Management';
                ToolTip = 'Process incoming and outgoing payments. Set up bank accounts and service connections for electronic banking.  ';




                action(CashReceiptJournals)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cash Receipt Journals';
                    Image = Journals;
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type" = const("Cash Receipts"),
                                        Recurring = const(false));
                    ToolTip = 'Register received payments by manually applying them to the related customer, vendor, or bank ledger entries. Then, post the payments to G/L accounts and thereby close the related ledger entries.';
                }
                action(PaymentJournals)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Payment Journals';
                    Image = Journals;
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type" = const(Payments),
                                        Recurring = const(false));
                    ToolTip = 'Register payments to vendors. A payment journal is a type of general journal that is used to post outgoing payment transactions to G/L, bank, customer, vendor, employee, and fixed assets accounts. The Suggest Vendor Payments functions automatically fills the journal with payments that are due. When payments are posted, you can export the payments to a bank file for upload to your bank if your system is set up for electronic banking. You can also issue computer checks from the payment journal.';
                }
                action(Action164)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bank Accounts';
                    Image = BankAccount;
                    RunObject = Page "Bank Account List";
                    ToolTip = 'View or set up detailed information about your bank account, such as which currency to use, the format of bank files that you import and export as electronic payments, and the numbering of checks.';
                }


                action("Bank Acc. Statements")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bank Acc. Statements';
                    Image = BankAccountStatement;
                    RunObject = Page "Bank Account Statement List";
                    ToolTip = 'View statements for selected bank accounts. For each bank transaction, the report shows a description, an applied amount, a statement amount, and other information.';
                }
                action("Payment Terms")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Payment Terms';
                    Image = Payment;
                    RunObject = Page "Payment Terms";
                    ToolTip = 'Set up the payment terms that you select from customer cards or sales documents to define when the customer must pay, such as within 14 days.';
                }
                action("Cash Flow Forecasts")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cash Flow Forecasts';
                    RunObject = Page "Cash Flow Forecast List";
                    ToolTip = 'Combine various financial data sources to find out when a cash surplus or deficit might happen or whether you should pay down debt, or borrow to meet upcoming expenses.';
                }
                action("Chart of Cash Flow Accounts")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Chart of Cash Flow Accounts';
                    RunObject = Page "Chart of Cash Flow Accounts";
                    ToolTip = 'View a chart contain a graphical representation of one or more cash flow accounts and one or more cash flow setups for the included general ledger, purchase, sales, services, or fixed assets accounts.';
                }
                action("Cash Flow Manual Revenues")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cash Flow Manual Revenues';
                    RunObject = Page "Cash Flow Manual Revenues";
                    ToolTip = 'Record manual revenues, such as rental income, interest from financial assets, or new private capital to be used in cash flow forecasting.';
                }
                action("Cash Flow Manual Expenses")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cash Flow Manual Expenses';
                    RunObject = Page "Cash Flow Manual Expenses";
                    ToolTip = 'Record manual expenses, such as salaries, interest on credit, or planned investments to be used in cash flow forecasting.';
                }
                action(BankAccountReconciliations)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bank Account Reconciliations';
                    Image = BankAccountRec;
                    RunObject = Page "Bank Acc. Reconciliation List";
                    ToolTip = 'Reconcile bank accounts in your system with bank statements received from your bank.';
                }
            }
            group("Funds Management")
            {
                Caption = 'Funds Management';
                action("Payment Vouchers")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'New Payment Vouchers';
                    Image = Payment;
                    RunObject = page "Payment List";
                }
                action("Payment Vouchers Pend")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Pending Payment Vouchers';
                    Image = Payment;
                    RunObject = page "Pending Approval Payment List";
                }
                action("Payment Vouchers Approved")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Approved Payment Vouchers';
                    Image = Payment;
                    RunObject = page "Approved Payment List";
                }
                action(Receipts)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Receipts';
                    Image = Receipt;
                    RunObject = page "Receipt List";
                }
                action("New Journal Voucher")
                {
                    RunObject = page "Journal Voucher List";
                    Caption = 'Journal Vouchers-Open';
                    Image = Journal;
                    ApplicationArea = Basic, Suite;
                }
                action("Pending Journal Voucher")
                {
                    Caption = 'Journal Vouchers Pending Approval';
                    RunObject = page "Journal Vouchers Pend.Approval";
                    ApplicationArea = Basic, Suite;
                    Image = Journal;

                }
                action(ApprovedJv)
                {
                    Caption = 'Journal Vouchers-Approved';
                    RunObject = page "Journal Vouchers Approved";
                    ApplicationArea = Basic, Suite;
                    Image = Journal;
                }
                action(FundTransferList)
                {
                    Caption = 'Fund Transfer-Open';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "Funds Transfer List";
                    Image = TransferFunds;
                }
                action(FundTransferListPend)
                {
                    Caption = 'Fund Transfers-Pending';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "Funds Transfer List Pend";
                    Image = TransferFunds;
                }
                action(FundTransferListAppr)
                {
                    Caption = 'Fund Transfer-Approved';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "Funds Transfer List Approved";
                    Image = TransferFunds;
                }
                action(ImprestListOpen)
                {
                    Caption = 'Imprests-Open';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "Imprest List";
                    Image = Loaners;

                }
                action(ImprestListPend)
                {
                    Caption = 'Imprests-Pending Approval';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "pending Approval Imprest List";
                    Image = Loaners;
                }
                action(ImprestListApproved)
                {
                    Caption = 'Imprests-Approved';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "Approved Imprest List";
                    Image = Loaners;
                }
                action(ImprestSurrOpen)
                {
                    Caption = 'Imprests Surrender-Open';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "Imprest Surrender List";
                    Image = Loaners;
                }
                action(ImprestSurrPend)
                {
                    Caption = 'Imprests Surrender-Pending';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "Imprest Surrender List -Pendin";
                    Image = Loaners;
                }
                action(ImprestSurrApproved)
                {
                    Caption = 'Imprests Surrender-Approved';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "Imprest Surrender List -Approv";
                    Image = Loaners;
                }
                action(PettyCashOpen)
                {
                    Caption = 'Petty Cash-Open';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "Petty Cash list";
                    Image = CashFlow;
                }
                action(PettyCashPend)
                {
                    Caption = 'Petty Cash-Pending';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "Pending Approv Petty Cash List";
                    Image = CashFlow;
                }
                action(PettyCashApproved)
                {
                    Caption = 'Petty Cash-Approved';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "Approved Petty Cash List";
                    Image = CashFlow;
                }
                action(PettyCashSurrenderOpen)
                {
                    Caption = 'Petty Cash Surrender-Open';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "Petty Cash Surrender List";
                    Image = CashFlow;
                }
                action(PettyCashSurrenderpend)
                {
                    Caption = 'Petty Cash Surrender-Pending';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "Petty Cash Surrender List Pend";
                    Image = CashFlow;
                }
                action(PettyCashSurrenderAppr)
                {
                    Caption = 'Petty Cash Surrender-Approved';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "Petty Cash Surrender List Pend";
                    Image = CashFlow;
                }
                action(FundClaimOpen)
                {
                    Caption = 'Fund Claim-Open';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "Funds Claim List";
                    Image = PostedPayableVoucher;
                }
                action(FundClaimPend)
                {
                    Caption = 'Fund Claim-Pending';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "Funds Claim List Pend";
                    Image = PostedPayableVoucher;
                }
                action(FundClaimApproved)
                {
                    Caption = 'Fund Claim-Approved';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "Funds Claim List Approved";
                    Image = PostedPayableVoucher;
                }


            }
            group(Action84)
            {
                Caption = 'Funds Management Setups';

                action("Receipt Codes")
                {
                    Caption = 'Receipt Codes';
                    RunObject = page "Receipt Codes";
                    ApplicationArea = Basic, Suite;
                }
                action("Payment Codes")
                {
                    Caption = 'Payment Codes';
                    RunObject = page "Payment Codes";
                    ApplicationArea = Basic, Suite;
                }
                action("Imprest Codes")
                {
                    Caption = 'Imprest Codes';
                    RunObject = page "Imprest Codes";
                    ApplicationArea = Basic, Suite;
                }
                action("Funds Tax Codes")
                {
                    Caption = 'Funds Tax Codes';
                    RunObject = page "Funds Tax Codes";
                    ApplicationArea = Basic, Suite;
                }
                action("Budget Control Setup")
                {
                    Caption = 'Budget Control Setup';
                    RunObject = page "Budget Control Setup";
                    ApplicationArea = Basic, Suite;
                }
                 action("Fund Setup")
                {
                    ApplicationArea = Suite;
                    Caption = 'Funds General Setup';
                    Image = SetupColumns;
                    RunObject = Page "Funds General Setup";
                }
                action("Funds User Setup")
                {

                    ApplicationArea = Suite;
                    Caption = 'Funds User Setup';
                    RunObject = page "Funds User Setup";
                    Image = UserSetup;

                }
                           }
            group(Action16)
            {
                Caption = 'Fixed Assets';
                Image = FixedAssets;
                ToolTip = 'Manage depreciation and insurance of your fixed assets.';
                action(Action17)
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Fixed Assets';
                    RunObject = Page "Fixed Asset List";
                    ToolTip = 'Manage periodic depreciation of your machinery or machines, keep track of your maintenance costs, manage insurance policies related to fixed assets, and monitor fixed asset statistics.';
                }
                action("Fixed Assets G/L Journals")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Fixed Assets G/L Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type" = const(Assets),
                                        Recurring = const(false));
                    ToolTip = 'Post fixed asset transactions, such as acquisition and depreciation, in integration with the general ledger. The FA G/L Journal is a general journal, which is integrated into the general ledger.';
                }
                action("Fixed Assets Journals")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Fixed Assets Journals';
                    RunObject = Page "FA Journal Batches";
                    RunPageView = where(Recurring = const(false));
                    ToolTip = 'Post fixed asset transactions, such as acquisition and depreciation book without integration to the general ledger.';
                }
                action("Fixed Assets Reclass. Journals")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Fixed Assets Reclass. Journals';
                    RunObject = Page "FA Reclass. Journal Batches";
                    ToolTip = 'Transfer, split, or combine fixed assets by preparing reclassification entries to be posted in the fixed asset journal.';
                }
                action(Insurance)
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Insurance';
                    RunObject = Page "Insurance List";
                    ToolTip = 'Manage insurance policies for fixed assets and monitor insurance coverage.';
                }
                action("Insurance Journals")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Insurance Journals';
                    RunObject = Page "Insurance Journal Batches";
                    ToolTip = 'Post entries to the insurance coverage ledger.';
                }
                action("Recurring Fixed Asset Journals")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Recurring Fixed Asset Journals';
                    RunObject = Page "FA Journal Batches";
                    RunPageView = where(Recurring = const(true));
                    ToolTip = 'Post recurring fixed asset transactions, such as acquisition and depreciation book without integration to the general ledger.';
                }
            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                ToolTip = 'View the posting history for sales, shipments, and inventory.,Payments,Imprests,claims';
                action("Posted Payment Vouchers")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Payment Vouchers';
                    Image = PostedPayableVoucher;
                    RunObject = Page "Posted Payment List";
                    ToolTip = 'Open the list of posted Payment Vouchers.';
                }
                action("Posted Journal Vouchers")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Journal Vouchers';
                    Image = Journals;
                    RunObject = Page "Journal Vouchers Posted";
                    ToolTip = 'Open the list of Journal Payment Vouchers.';
                }
                action("Posted Imprest List")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Imprest List';
                    Image = PostedMemo;
                    RunObject = Page "Posted Imprest List";
                    ToolTip = 'Open the list of Posted Imprest List.';
                }
                action("Posted Imprest Surr List")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Imprest Surrender List';
                    Image = PostedMemo;
                    RunObject = Page "Posted Imprest Surrender List";
                    ToolTip = 'Open the list of Posted Imprest Surrender List.';
                }
                action("Posted Petty Cash List")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Petty Cash List';
                    Image = PostedMemo;
                    RunObject = Page "Posted Petty Cash List";
                    ToolTip = 'Open the list of Posted Petty Cash List.';
                }
                action("Posted Fund Claim List")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Fund Claim List';
                    Image = PostedMemo;
                    RunObject = Page "Posted Fund Claim Card";
                    ToolTip = 'Open the list of Posted Petty Cash List.';
                }
                action("Posted Sales Invoices")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Sales Invoices';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Invoices";
                    ToolTip = 'Open the list of posted sales invoices.';
                }
                action("Posted Sales Credit Memos")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Sales Credit Memos';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Credit Memos";
                    ToolTip = 'Open the list of posted sales credit memos.';
                }
                action("Posted Purchase Invoices")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Purchase Invoices';
                    RunObject = Page "Posted Purchase Invoices";
                    ToolTip = 'Open the list of posted purchase invoices.';
                }
                action("Posted Purchase Credit Memos")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Purchase Credit Memos';
                    RunObject = Page "Posted Purchase Credit Memos";
                    ToolTip = 'Open the list of posted purchase credit memos.';
                }
                action("Issued Reminders")
                {
                    ApplicationArea = Suite;
                    Caption = 'Issued Reminders';
                    Image = OrderReminder;
                    RunObject = Page "Issued Reminder List";
                    ToolTip = 'Open the list of issued reminders.';
                }

                action("G/L Registers")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'G/L Registers';
                    Image = GLRegisters;
                    RunObject = Page "G/L Registers";
                    ToolTip = 'View auditing details for all general ledger entries. Every time an entry is posted, a register is created in which you can see the first and last number of its entries in order to document when entries were posted.';
                }

            }
        }
        area(creation)
        {
            action("Sales &Credit Memo")
            {
                AccessByPermission = TableData "Sales Header" = IMD;
                ApplicationArea = Basic, Suite;
                Caption = 'Sales &Credit Memo';
                RunObject = Page "Sales Credit Memo";
                RunPageMode = Create;
                ToolTip = 'Create a new sales credit memo to revert a posted sales invoice.';
            }
            action("P&urchase Credit Memo")
            {
                AccessByPermission = TableData "Purchase Header" = IMD;
                ApplicationArea = Basic, Suite;
                Caption = 'P&urchase Credit Memo';
                RunObject = Page "Purchase Credit Memo";
                RunPageMode = Create;
                ToolTip = 'Create a new purchase credit memo so you can manage returned items to a vendor.';
            }
            action("G/L Journal Entry")
            {
                AccessByPermission = TableData "G/L Entry" = IMD;
                ApplicationArea = Basic, Suite;
                Caption = 'G/L Journal Entry';
                RunObject = Page "General Journal";
                ToolTip = 'Prepare to post any transaction to the company books.';
            }
            action("Payment Journal Entry")
            {
                AccessByPermission = TableData "Gen. Journal Batch" = IMD;
                ApplicationArea = Basic, Suite;
                Caption = 'Payment Journal Entry';
                RunObject = Page "Payment Journal";
                ToolTip = 'Pay your vendors by filling the payment journal automatically according to payments due, and potentially export all payment to your bank for automatic processing.';
            }
            action(Action1020012)
            {
                AccessByPermission = TableData "Gen. Journal Template" = IMD;
                ApplicationArea = Basic, Suite;
                Caption = 'Bank Deposit';
                RunObject = Codeunit "Open Deposit Page";
                RunPageMode = Create;
                ToolTip = 'Create a new bank deposit. ';
            }
        }
        area(processing)
        {
            group(Payments)
            {
                Caption = 'Payments';
                action("Cas&h Receipt Journal")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cas&h Receipt Journal';
                    Image = CashReceiptJournal;
                    RunObject = Page "Cash Receipt Journal";
                    ToolTip = 'Apply received payments to the related non-posted sales documents.';
                }
                action("Pa&yment Journal")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Pa&yment Journal';
                    Image = PaymentJournal;
                    RunObject = Page "Payment Journal";
                    ToolTip = 'Make payments to vendors.';
                }
            }
            group(Analysis)
            {
                Caption = 'Analysis';
                action("Analysis &Views")
                {
                    ApplicationArea = Dimensions;
                    Caption = 'Analysis &Views';
                    Image = AnalysisView;
                    RunObject = Page "Analysis View List";
                    ToolTip = 'Analyze amounts in your general ledger by their dimensions using analysis views that you have set up.';
                }
            }
            group(Tasks)
            {
                Caption = 'Tasks';
                action("Calculate Deprec&iation")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Calculate Deprec&iation';
                    Ellipsis = true;
                    Image = CalculateDepreciation;
                    RunObject = Report "Calculate Depreciation";
                    ToolTip = 'Calculate depreciation according to the conditions that you define. If the fixed assets that are included in the batch job are integrated with the general ledger (defined in the depreciation book that is used in the batch job), the resulting entries are transferred to the fixed assets general ledger journal. Otherwise, the batch job transfers the entries to the fixed asset journal. You can then post the journal or adjust the entries before posting, if necessary.';
                }
                action("Import Co&nsolidation from Database")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Import Co&nsolidation from Database';
                    Ellipsis = true;
                    Image = ImportDatabase;
                    RunObject = Report "Import Consolidation from DB";
                    ToolTip = 'Import entries from the business units that will be included in a consolidation. You can use the batch job if the business unit comes from the same database in Business Central as the consolidated company.';
                }
                action("Bank Account R&econciliation")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bank Account R&econciliation';
                    Image = BankAccountRec;
                    RunObject = Page "Bank Acc. Reconciliation";
                    ToolTip = 'View the entries and the balance on your bank accounts against a statement from the bank.';
                }
                action("Payment Reconciliation Journals")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Payment Reconciliation Journals';
                    Image = ApplyEntries;
                    RunObject = Page "Pmt. Reconciliation Journals";
                    RunPageMode = View;
                    ToolTip = 'Reconcile unpaid documents automatically with their related bank transactions by importing a bank statement feed or file. In the payment reconciliation journal, incoming or outgoing payments on your bank are automatically, or semi-automatically, applied to their related open customer or vendor ledger entries. Any open bank account ledger entries related to the applied customer or vendor ledger entries will be closed when you choose the Post Payments and Reconcile Bank Account action. This means that the bank account is automatically reconciled for payments that you post with the journal.';
                }
                action("Adjust E&xchange Rates")
                {
                    ApplicationArea = Suite;
                    Caption = 'Adjust E&xchange Rates';
                    Ellipsis = true;
                    Image = AdjustExchangeRates;
                    RunObject = Codeunit "Exch. Rate Adjmt. Run Handler";
                    ToolTip = 'Adjust general ledger, customer, vendor, and bank account entries to reflect a more updated balance if the exchange rate has changed since the entries were posted.';
                }
                action("P&ost Inventory Cost to G/L")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'P&ost Inventory Cost to G/L';
                    Image = PostInventoryToGL;
                    RunObject = Report "Post Inventory Cost to G/L";
                    ToolTip = 'Record the quantity and value changes to the inventory in the item ledger entries and the value entries when you post inventory transactions, such as sales shipments or purchase receipts.';
                }
#if not CLEAN22
                action("Intrastat &Journal")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Intrastat &Journal';
                    Image = Journal;
                    RunObject = Page "Intrastat Jnl. Batches";
                    ToolTip = 'Summarize the value of your purchases and sales with business partners in the EU for statistical purposes and prepare to send it to the relevant authority.';
                    ObsoleteState = Pending;
                    ObsoleteTag = '22.0';
                    ObsoleteReason = 'Intrastat related functionalities are moved to Intrastat extensions.';
                }
#endif
                action("Calc. and Pos&t VAT Settlement")
                {
                    ApplicationArea = VAT;
                    Caption = 'Calc. and Pos&t VAT Settlement';
                    Image = SettleOpenTransactions;
                    RunObject = Report "Calc. and Post VAT Settlement";
                    ToolTip = 'Close open VAT entries and transfers purchase and sales VAT amounts to the VAT settlement account. For every VAT posting group, the batch job finds all the VAT entries in the VAT Entry table that are included in the filters in the definition window.';
                }
            }
            group(Create)
            {
                Caption = 'Create';
                action("C&reate Reminders")
                {
                    ApplicationArea = Suite;
                    Caption = 'C&reate Reminders';
                    Ellipsis = true;
                    Image = CreateReminders;
                    RunObject = Report "Create Reminders";
                    ToolTip = 'Create reminders for one or more customers with overdue payments.';
                }
                action("Create Finance Charge &Memos")
                {
                    ApplicationArea = Suite;
                    Caption = 'Create Finance Charge &Memos';
                    Ellipsis = true;
                    Image = CreateFinanceChargememo;
                    RunObject = Report "Create Finance Charge Memos";
                    ToolTip = 'Create finance charge memos for one or more customers with overdue payments.';
                }
            }
            group(Reports)
            {
                Caption = 'Reports';
                group("Financial Statements")
                {
                    Caption = 'Financial Statements';
                    Image = ReferenceData;
                    action("Balance Sheet")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Balance Sheet';
                        Image = "Report";
                        RunObject = Report "Balance Sheet";
                        ToolTip = 'View a report that shows your company''s assets, liabilities, and equity.';
                    }
                    action("Income Statement")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Income Statement';
                        Image = "Report";
                        RunObject = Report "Income Statement";
                        ToolTip = 'View a report that shows your company''s income and expenses.';
                    }
                    action("Statement of Cash Flows")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Statement of Cash Flows';
                        Image = "Report";
                        RunObject = Report "Statement of Cashflows";
                        ToolTip = 'View a financial statement that shows how changes in balance sheet accounts and income affect the company''s cash holdings, displayed for operating, investing, and financing activities respectively.';
                    }
                    action("Statement of Retained Earnings")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Statement of Retained Earnings';
                        Image = "Report";
                        RunObject = Report "Retained Earnings Statement";
                        ToolTip = 'View a report that shows your company''s changes in retained earnings for a specified period by reconciling the beginning and ending retained earnings for the period, using information such as net income from the other financial statements.';
                    }
                }
                group("Excel Reports")
                {
                    Caption = 'Excel Reports';
                    Image = Excel;
                    action(ExcelTemplatesBalanceSheet)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Balance Sheet';
                        Image = "Report";
                        RunObject = Codeunit "Run Template Balance Sheet";
                        ToolTip = 'Open a spreadsheet that shows your company''s assets, liabilities, and equity.';
                    }
                    action(ExcelTemplateIncomeStmt)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Income Statement';
                        Image = "Report";
                        RunObject = Codeunit "Run Template Income Stmt.";
                        ToolTip = 'Open a spreadsheet that shows your company''s income and expenses.';
                    }
                    action(ExcelTemplateCashFlowStmt)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Cash Flow Statement';
                        Image = "Report";
                        RunObject = Codeunit "Run Template CashFlow Stmt.";
                        ToolTip = 'Open a spreadsheet that shows how changes in balance sheet accounts and income affect the company''s cash holdings.';
                    }
                    action(ExcelTemplateRetainedEarn)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Retained Earnings Statement';
                        Image = "Report";
                        RunObject = Codeunit "Run Template Retained Earn.";
                        ToolTip = 'Open a spreadsheet that shows your company''s changes in retained earnings based on net income from the other financial statements.';
                    }
                    action(ExcelTemplateTrialBalance)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Trial Balance';
                        Image = "Report";
                        RunObject = Codeunit "Run Template Trial Balance";
                        ToolTip = 'Open a spreadsheet that shows a summary trial balance by account.';
                    }
                    action(ExcelTemplateAgedAccPay)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Aged Accounts Payable';
                        Image = "Report";
                        RunObject = Codeunit "Run Template Aged Acc. Pay.";
                        ToolTip = 'Open a spreadsheet that shows a list of aged remaining balances for each vendor by period.';
                    }
                    action(ExcelTemplateAgedAccRec)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Aged Accounts Receivable';
                        Image = "Report";
                        RunObject = Codeunit "Run Template Aged Acc. Rec.";
                        ToolTip = 'Open a spreadsheet that shows when customer payments are due or overdue by period.';
                    }
                }
                action("Run Consolidation")
                {
                    ApplicationArea = Suite;
                    Caption = 'Run Consolidation';
                    Ellipsis = true;
                    Image = ImportDatabase;
                    RunObject = Report "Import Consolidation from DB";
                    ToolTip = 'Run the Consolidation report.';
                }
            }
            group(History)
            {
                Caption = 'History';
                action("Navi&gate")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Find entries...';
                    Image = Navigate;
                    RunObject = Page Navigate;
                    ShortCutKey = 'Ctrl+Alt+Q';
                    ToolTip = 'Find entries and documents that exist for the document number and posting date on the selected document. (Formerly this action was named Navigate.)';
                }
            }
        }
    }
}
