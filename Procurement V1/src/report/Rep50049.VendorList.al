report 50049 "Vendor List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/layouts/Vendor List.rdlc';

    dataset
    {
        dataitem(Vendor; 23)
        {
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(CompanyInfo_Address; CompanyInfo.Address)
            {
            }
            column(CompanyInfo_Address2; CompanyInfo."Address 2")
            {
            }
            column(pic; CompanyInfo.Picture)
            {
            }
            column(CompanyInfo_City; CompanyInfo.City)
            {
            }
            column(CompanyInfo_Phone; CompanyInfo."Phone No.")
            {
            }
            column(CompanyInfo_Fax; CompanyInfo."Fax No.")
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(CompanyInfo_Email; CompanyInfo."E-Mail")
            {
            }
            column(CompanyInfo_Web; CompanyInfo."Home Page")
            {
            }
            column(Number; Number)
            {
            }
            column(No_Vendor; Vendor."No.")
            {
            }
            column(Name_Vendor; Vendor.Name)
            {
            }
            column(SearchName_Vendor; Vendor."Search Name")
            {
            }
            column(Name2_Vendor; Vendor."Name 2")
            {
            }
            column(Address_Vendor; Vendor.Address)
            {
            }
            column(Address2_Vendor; Vendor."Address 2")
            {
            }
            column(City_Vendor; Vendor.City)
            {
            }
            column(Contact_Vendor; Vendor.Contact)
            {
            }
            column(PhoneNo_Vendor; Vendor."Phone No.")
            {
            }
            column(EMail_Vendor; Vendor."E-Mail")
            {
            }
            column(BankCode_Vendor; Vendor."Bank Code")
            {
            }
            column(BankName_Vendor; Vendor."Bank Name")
            {
            }
            column(BankBranchCode_Vendor; Vendor."Bank Branch Code")
            {
            }
            column(BankBranchName_Vendor; Vendor."Bank Branch Name")
            {
            }
            column(BankAccountName_Vendor; Vendor."Bank Account Name")
            {
            }
            column(BankAccountNo_Vendor; Vendor."Bank Account No.")
            {
            }
            column(MPESAPaybillAccountNo_Vendor; Vendor."MPESA/Paybill Account No.")
            {
            }
            column(CreatedBy_Vendor; Vendor."Created By")
            {
            }
            column(VendorCreationDate_Vendor; Vendor."Vendor Creation Date")
            {
            }
            column(VATRegistered_Vendor; Vendor."VAT Registered")
            {
            }
            column(VATRegistrationNos_Vendor; Vendor."VAT Registration Nos.")
            {
            }
            column(DateofIncorporation_Vendor; Vendor."Date of Incorporation")
            {
            }
            column(IncorporationCertificateNo_Vendor; Vendor."Incorporation Certificate No.")
            {
            }
            column(AGPO_Vendor; Vendor.AGPO)
            {
            }
            column(Building_Vendor; Vendor.Building)
            {
            }
            column(CountyCode_Vendor; Vendor."County Code")
            {
            }
            column(CountyName_Vendor; Vendor."County Name")
            {
            }
            column(Street_Vendor; Vendor.Street)
            {
            }
            column(SupplierCategoryCode_Vendor; Vendor."Supplier Category Code")
            {
            }
            column(Contacts_Vendor; Vendor.Contacts)
            {
            }
            dataitem("Approval Entry"; 454)
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = WHERE(Status = CONST(Approved));
                column(SequenceNo; "Approval Entry"."Sequence No.")
                {
                }
                column(LastDateTimeModified; "Approval Entry"."Last Date-Time Modified")
                {
                }
                column(ApproverID; "Approval Entry"."Approver ID")
                {
                }
                column(ApproverID_ApprovalEntry; "Approval Entry"."Approver ID")
                {
                }
                column(SenderID; "Approval Entry"."Sender ID")
                {
                }
                dataitem(Employee; 5200)
                {
                    DataItemLink = "User ID" = FIELD("Approver ID");
                    column(EmployeeFirstName; Employee."First Name")
                    {
                    }
                    column(EmployeeMiddleName; Employee."Middle Name")
                    {
                    }
                    column(EmployeeLastName; Employee."Last Name")
                    {
                    }
                    column(EmployeeSignature; Employee."Employee Signature")
                    {
                    }
                }
            }

            trigger OnAfterGetRecord()
            begin
                Number := Number + 1;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture)
    end;

    var
        CompanyInfo: Record 79;
        Number: Integer;
}

