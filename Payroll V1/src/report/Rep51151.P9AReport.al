report 51151 "P9A Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/P9A Report.rdlc';

    dataset
    {
        dataitem(Year; 51150)
        {
            DataItemTableView = SORTING(Year);
            RequestFilterFields = Year;
            column(Year_Year; Year)
            {
            }
            dataitem(Employee; 5200)
            {
                RequestFilterFields = "No.", "Global Dimension 1 Code", "Global Dimension 2 Code", Status, "Statistics Group Code", "Calculation Scheme";
                column(AmountArray_1___1_; AmountArray[1] [1])
                {
                }
                column(AmountArray_1___2_; AmountArray[1] [2])
                {
                }
                column(AmountArray_1___3_; AmountArray[1] [3])
                {
                }
                column(AmountArray_1___4_; AmountArray[1] [4])
                {
                }
                column(AmountArray_1___5_; AmountArray[1] [5])
                {
                }
                column(AmountArray_1___6_; AmountArray[1] [6])
                {
                }
                column(AmountArray_1___7_; AmountArray[1] [7])
                {
                }
                column(AmountArray_1___8_; AmountArray[1] [8])
                {
                }
                column(AmountArray_1___9_; AmountArray[1] [9])
                {
                }
                column(AmountArray_1___10_; AmountArray[1] [10])
                {
                }
                column(AmountArray_1___11_; AmountArray[1] [11])
                {
                }
                column(AmountArray_1___12_; AmountArray[1] [12])
                {
                }
                column(AmountArray_2___1_; AmountArray[2] [1])
                {
                }
                column(AmountArray_2___2_; AmountArray[2] [2])
                {
                }
                column(AmountArray_2___3_; AmountArray[2] [3])
                {
                }
                column(AmountArray_2___4_; AmountArray[2] [4])
                {
                }
                column(AmountArray_2___5_; AmountArray[2] [5])
                {
                }
                column(AmountArray_2___6_; AmountArray[2] [6])
                {
                }
                column(AmountArray_2___7_; AmountArray[2] [7])
                {
                }
                column(AmountArray_2___8_; AmountArray[2] [8])
                {
                }
                column(AmountArray_2___9_; AmountArray[2] [9])
                {
                }
                column(AmountArray_2___10_; AmountArray[2] [10])
                {
                }
                column(AmountArray_2___11_; AmountArray[2] [11])
                {
                }
                column(AmountArray_2___12_; AmountArray[2] [12])
                {
                }
                column(AmountArray_3___1_; AmountArray[3] [1])
                {
                }
                column(AmountArray_3___2_; AmountArray[3] [2])
                {
                }
                column(AmountArray_3___3_; AmountArray[3] [3])
                {
                }
                column(AmountArray_3___4_; AmountArray[3] [4])
                {
                }
                column(AmountArray_3___5_; AmountArray[3] [5])
                {
                }
                column(AmountArray_3___6_; AmountArray[3] [6])
                {
                }
                column(AmountArray_3___7_; AmountArray[3] [7])
                {
                }
                column(AmountArray_3___8_; AmountArray[3] [8])
                {
                }
                column(AmountArray_3___9_; AmountArray[3] [9])
                {
                }
                column(AmountArray_3___10_; AmountArray[3] [10])
                {
                }
                column(AmountArray_3___11_; AmountArray[3] [11])
                {
                }
                column(AmountArray_3___12_; AmountArray[3] [12])
                {
                }
                column(AmountArray_4___1_; AmountArray[4] [1])
                {
                }
                column(AmountArray_4___2_; AmountArray[4] [2])
                {
                }
                column(AmountArray_4___3_; AmountArray[4] [3])
                {
                }
                column(AmountArray_4___4_; AmountArray[4] [4])
                {
                }
                column(AmountArray_4___5_; AmountArray[4] [5])
                {
                }
                column(AmountArray_4___6_; AmountArray[4] [6])
                {
                }
                column(AmountArray_4___7_; AmountArray[4] [7])
                {
                }
                column(AmountArray_4___8_; AmountArray[4] [8])
                {
                }
                column(AmountArray_4___9_; AmountArray[4] [9])
                {
                }
                column(AmountArray_4___10_; AmountArray[4] [10])
                {
                }
                column(AmountArray_4___11_; AmountArray[4] [11])
                {
                }
                column(AmountArray_4___12_; AmountArray[4] [12])
                {
                }
                column(AmountArray_5___7_; AmountArray[5] [7])
                {
                }
                column(AmountArray_5___1_; AmountArray[5] [1])
                {
                }
                column(AmountArray_5___2_; AmountArray[5] [2])
                {
                }
                column(AmountArray_5___3_; AmountArray[5] [3])
                {
                }
                column(AmountArray_5___4_; AmountArray[5] [4])
                {
                }
                column(AmountArray_5___5_; AmountArray[5] [5])
                {
                }
                column(AmountArray_5___6_; AmountArray[5] [6])
                {
                }
                column(AmountArray_5___8_; AmountArray[5] [8])
                {
                }
                column(AmountArray_5___9_; AmountArray[5] [9])
                {
                }
                column(AmountArray_5___10_; AmountArray[5] [10])
                {
                }
                column(AmountArray_5___11_; AmountArray[5] [11])
                {
                }
                column(AmountArray_5___12_; AmountArray[5] [12])
                {
                }
                column(AmountArray_6___1_; AmountArray[6] [1])
                {
                }
                column(AmountArray_6___2_; AmountArray[6] [2])
                {
                }
                column(AmountArray_6___3_; AmountArray[6] [3])
                {
                }
                column(AmountArray_6___4_; AmountArray[6] [4])
                {
                }
                column(AmountArray_6___5_; AmountArray[6] [5])
                {
                }
                column(AmountArray_6___6_; AmountArray[6] [6])
                {
                }
                column(AmountArray_6___7_; AmountArray[6] [7])
                {
                }
                column(AmountArray_6___8_; AmountArray[6] [8])
                {
                }
                column(AmountArray_6___9_; AmountArray[6] [9])
                {
                }
                column(AmountArray_6___10_; AmountArray[6] [10])
                {
                }
                column(AmountArray_6___11_; AmountArray[6] [11])
                {
                }
                column(AmountArray_6___12_; AmountArray[6] [12])
                {
                }
                column(AmountArray_7___1_; AmountArray[7] [1])
                {
                }
                column(AmountArray_7___2_; AmountArray[7] [2])
                {
                }
                column(AmountArray_7___3_; AmountArray[7] [3])
                {
                }
                column(AmountArray_7___4_; AmountArray[7] [4])
                {
                }
                column(AmountArray_7___5_; AmountArray[7] [5])
                {
                }
                column(AmountArray_7___6_; AmountArray[7] [6])
                {
                }
                column(AmountArray_7___7_; AmountArray[7] [7])
                {
                }
                column(AmountArray_7___8_; AmountArray[7] [8])
                {
                }
                column(AmountArray_7___9_; AmountArray[7] [9])
                {
                }
                column(AmountArray_7___10_; AmountArray[7] [10])
                {
                }
                column(AmountArray_7___11_; AmountArray[7] [11])
                {
                }
                column(AmountArray_7___12_; AmountArray[7] [12])
                {
                }
                column(AmountArray_8___1_; AmountArray[8] [1])
                {
                }
                column(AmountArray_8___2_; AmountArray[8] [2])
                {
                }
                column(AmountArray_8___3_; AmountArray[8] [3])
                {
                }
                column(AmountArray_8___4_; AmountArray[8] [4])
                {
                }
                column(AmountArray_8___5_; AmountArray[8] [5])
                {
                }
                column(AmountArray_8___6_; AmountArray[8] [6])
                {
                }
                column(AmountArray_8___7_; AmountArray[8] [7])
                {
                }
                column(AmountArray_8___8_; AmountArray[8] [8])
                {
                }
                column(AmountArray_8___9_; AmountArray[8] [9])
                {
                }
                column(AmountArray_8___10_; AmountArray[8] [10])
                {
                }
                column(AmountArray_8___11_; AmountArray[8] [11])
                {
                }
                column(AmountArray_8___12_; AmountArray[8] [12])
                {
                }
                column(AmountArray_9___1_; AmountArray[9] [1])
                {
                }
                column(AmountArray_9___2_; AmountArray[9] [2])
                {
                }
                column(AmountArray_9___3_; AmountArray[9] [3])
                {
                }
                column(AmountArray_9___4_; AmountArray[9] [4])
                {
                }
                column(AmountArray_9___5_; AmountArray[9] [5])
                {
                }
                column(AmountArray_9___6_; AmountArray[9] [6])
                {
                }
                column(AmountArray_9___7_; AmountArray[9] [7])
                {
                }
                column(AmountArray_9___8_; AmountArray[9] [8])
                {
                }
                column(AmountArray_9___9_; AmountArray[9] [9])
                {
                }
                column(AmountArray_9___10_; AmountArray[9] [10])
                {
                }
                column(AmountArray_9___11_; AmountArray[9] [11])
                {
                }
                column(AmountArray_9___12_; AmountArray[9] [12])
                {
                }
                column(AmountArray_10___1_; AmountArray[10] [1])
                {
                }
                column(AmountArray_10___2_; AmountArray[10] [2])
                {
                }
                column(AmountArray_10___3_; AmountArray[10] [3])
                {
                }
                column(AmountArray_10___4_; AmountArray[10] [4])
                {
                }
                column(AmountArray_10___5_; AmountArray[10] [5])
                {
                }
                column(AmountArray_10___6_; AmountArray[10] [6])
                {
                }
                column(AmountArray_10___7_; AmountArray[10] [7])
                {
                }
                column(AmountArray_10___8_; AmountArray[10] [8])
                {
                }
                column(AmountArray_10___9_; AmountArray[10] [9])
                {
                }
                column(AmountArray_10___10_; AmountArray[10] [10])
                {
                }
                column(AmountArray_10___11_; AmountArray[10] [11])
                {
                }
                column(AmountArray_10___12_; AmountArray[10] [12])
                {
                }
                column(AmountArray_11___1_; AmountArray[11] [1])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(AmountArray_11___2_; AmountArray[11] [2])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(AmountArray_11___3_; AmountArray[11] [3])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(AmountArray_11___4_; AmountArray[11] [4])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(AmountArray_11___5_; AmountArray[11] [5])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(AmountArray_11___6_; AmountArray[11] [6])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(AmountArray_11___7_; AmountArray[11] [7])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(AmountArray_11___8_; AmountArray[11] [8])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(AmountArray_11___9_; AmountArray[11] [9])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(AmountArray_11___10_; AmountArray[11] [10])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(AmountArray_11___11_; AmountArray[11] [11])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(AmountArray_11___12_; AmountArray[11] [12])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(AmountArray_12___1_; AmountArray[12] [1])
                {
                }
                column(AmountArray_12___2_; AmountArray[12] [2])
                {
                }
                column(AmountArray_12___3_; AmountArray[12] [3])
                {
                }
                column(AmountArray_12___4_; AmountArray[12] [4])
                {
                }
                column(AmountArray_12___5_; AmountArray[12] [5])
                {
                }
                column(AmountArray_12___6_; AmountArray[12] [6])
                {
                }
                column(AmountArray_12___7_; AmountArray[12] [7])
                {
                }
                column(AmountArray_12___8_; AmountArray[12] [8])
                {
                }
                column(AmountArray_12___9_; AmountArray[12] [9])
                {
                }
                column(AmountArray_12___10_; AmountArray[12] [10])
                {
                }
                column(AmountArray_12___11_; AmountArray[12] [11])
                {
                }
                column(AmountArray_12___12_; AmountArray[12] [12])
                {
                }
                column(AmountArray_13___1_; AmountArray[13] [1])
                {
                }
                column(AmountArray_13___2_; AmountArray[13] [2])
                {
                }
                column(AmountArray_13___3_; AmountArray[13] [3])
                {
                }
                column(AmountArray_13___4_; AmountArray[13] [4])
                {
                }
                column(AmountArray_13___5_; AmountArray[13] [5])
                {
                }
                column(AmountArray_13___6_; AmountArray[13] [6])
                {
                }
                column(AmountArray_13___7_; AmountArray[13] [7])
                {
                }
                column(AmountArray_13___8_; AmountArray[13] [8])
                {
                }
                column(AmountArray_13___9_; AmountArray[13] [9])
                {
                }
                column(AmountArray_13___10_; AmountArray[13] [10])
                {
                }
                column(AmountArray_13___11_; AmountArray[13] [11])
                {
                }
                column(AmountArray_13___12_; AmountArray[13] [12])
                {
                }
                column(AmountArray_14___1_; AmountArray[14] [1])
                {
                }
                column(AmountArray_14___2_; AmountArray[14] [2])
                {
                }
                column(AmountArray_14___3_; AmountArray[14] [3])
                {
                }
                column(AmountArray_14___4_; AmountArray[14] [4])
                {
                }
                column(AmountArray_14___5_; AmountArray[14] [5])
                {
                }
                column(AmountArray_14___6_; AmountArray[14] [6])
                {
                }
                column(AmountArray_14___7_; AmountArray[14] [7])
                {
                }
                column(AmountArray_14___8_; AmountArray[14] [8])
                {
                }
                column(AmountArray_14___9_; AmountArray[14] [9])
                {
                }
                column(AmountArray_14___10_; AmountArray[14] [10])
                {
                }
                column(AmountArray_14___11_; AmountArray[14] [11])
                {
                }
                column(AmountArray_14___12_; AmountArray[14] [12])
                {
                }
                column(AmountArray_1___13_; AmountArray[1] [13])
                {
                }
                column(AmountArray_2___13_; AmountArray[2] [13])
                {
                }
                column(AmountArray_10___13_; AmountArray[10] [13])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(AmountArray_3___13_; AmountArray[3] [13])
                {
                }
                column(AmountArray_4___13_; AmountArray[4] [13])
                {
                }
                column(AmountArray_5___13_; AmountArray[5] [13])
                {
                }
                column(AmountArray_6___13_; AmountArray[6] [13])
                {
                }
                column(AmountArray_7___13_; AmountArray[7] [13])
                {
                }
                column(AmountArray_8___13_; AmountArray[8] [13])
                {
                }
                column(AmountArray_9___13_; AmountArray[9] [13])
                {
                }
                column(AmountArray_13__13_; AmountArray[13] [13])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(AmountArray_10___13__Control501; AmountArray[10] [13])
                {
                }
                column(AmountArray_11___13_; AmountArray[11] [13])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(AmountArray_12___13_; AmountArray[12] [13])
                {
                }
                column(AmountArray_13___13_; AmountArray[13] [13])
                {
                }
                column(AmountArray_14__13_; AmountArray[14] [13])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(AmountArray_14___13_; AmountArray[14] [13])
                {
                }
                column(Employee_s_____P_I_N_; Employee.PIN)
                {
                }
                column(EmployeeName; EmployeeName)
                {
                }
                column(EmployeeOtherName; EmployeeOtherName)
                {
                }
                column(CompName; CompName)
                {
                }
                column(EmployerPIN; EmployerPIN)
                {
                }
                column(YearText; YearText)
                {
                }
                column(EMPLOYERS_CERTIFICATE_OF_PAYE_AND_TAX_; 'EMPLOYERS CERTIFICATE OF PAYE AND TAX')
                {
                }
                column(NAME_____________CompName; 'NAME:        ' + CompName)
                {
                }
                column(CompanyAddress; CompanyAddress)
                {
                }
                column(SIGNATURE__________________________________________________________; 'SIGNATURE:........................................................')
                {
                }
                column(DATE___STAMP_________________________________________________________________________; 'DATE & STAMP:.......................................................................')
                {
                }
                column(Year_Year_Control1102754000; Year.Year)
                {
                }
                column(Employee__Payroll_Code_; "Payroll Code")
                {
                }
                column(NOVEMBERCaption; NOVEMBERCaptionLbl)
                {
                }
                column(DECEMBERCaption; DECEMBERCaptionLbl)
                {
                }
                column(SEPTEMBERCaption; SEPTEMBERCaptionLbl)
                {
                }
                column(OCTOBERCaption; OCTOBERCaptionLbl)
                {
                }
                column(JULYCaption; JULYCaptionLbl)
                {
                }
                column(AUGUSTCaption; AUGUSTCaptionLbl)
                {
                }
                column(MAYCaption; MAYCaptionLbl)
                {
                }
                column(JUNECaption; JUNECaptionLbl)
                {
                }
                column(MARCHCaption; MARCHCaptionLbl)
                {
                }
                column(APRILCaption; APRILCaptionLbl)
                {
                }
                column(FEBRUARYCaption; FEBRUARYCaptionLbl)
                {
                }
                column(JANUARYCaption; JANUARYCaptionLbl)
                {
                }
                column(V2___a__Caption; V2___a__CaptionLbl)
                {
                }
                column(V1__Use_P9A__Caption; V1__Use_P9A__CaptionLbl)
                {
                }
                column(IMPORTANTCaption; IMPORTANTCaptionLbl)
                {
                }
                column(TOTAL_CHARGEABLE_PAY__COL__H___Kshs_____Caption; TOTAL_CHARGEABLE_PAY__COL__H___Kshs_____CaptionLbl)
                {
                }
                column(To_be_completed_by_employer_at_end_of_yearCaption; To_be_completed_by_employer_at_end_of_yearCaptionLbl)
                {
                }
                column(TOTALSCaption; TOTALSCaptionLbl)
                {
                }
                column(Deductible_interest_in_respect_of_any_month_must_not_exceed_KShs_12_500____Caption; Deductible_interest_in_respect_of_any_month_must_not_exceed_KShs_12_500____CaptionLbl)
                {
                }
                column(a__Caption; a__CaptionLbl)
                {
                }
                column(b__Caption; b__CaptionLbl)
                {
                }
                column(For_all_liable_employees_and_where_director_employee_received_benefits_in_addition_to_cash_emoluments_Caption; For_all_liable_employees_and_where_director_employee_received_benefits_in_addition_to_cash_emoluments_CaptionLbl)
                {
                }
                column(Where_an_employee_is_eligible_to_deduction_on_owner_occupier_interest_Caption; Where_an_employee_is_eligible_to_deduction_on_owner_occupier_interest_CaptionLbl)
                {
                }
                column(ii_Caption; ii_CaptionLbl)
                {
                }
                column(b__Attach__i_Caption; b__Attach__i_CaptionLbl)
                {
                }
                column(TOTAL_TAX__COL__L__KShs_Caption; TOTAL_TAX__COL__L__KShs_CaptionLbl)
                {
                }
                column(DataItem464; DATE_OF_OCCUPATION_OF_HOUSELbl)
                {
                }
                column(DataItem466; L_R__NO__OF_OWNER_OCCUPIED_PROPERTYLbl)
                {
                }
                column(NAMES_OF_FINANCIAL_INSTITUTION_ADVANCING_MORTGAGE_LOANCaption; NAMES_OF_FINANCIAL_INSTITUTION_ADVANCING_MORTGAGE_LOANCaptionLbl)
                {
                }
                column(The_DECLARATION_duly_signed_by_the_employee_to_form_P9A_Caption; The_DECLARATION_duly_signed_by_the_employee_to_form_P9A_CaptionLbl)
                {
                }
                column(DataItem475; Photostat_copy_of_preceding_year_s_certificate_or_confirmation_of)
                {
                }
                column(LCaption; LCaptionLbl)
                {
                }
                column(KCaption; KCaptionLbl)
                {
                }
                column(JCaption; JCaptionLbl)
                {
                }
                column(HCaption; HCaptionLbl)
                {
                }
                column(G__THE_LOWEST__OF_E_ADDED__TO_FCaption; G__THE_LOWEST__OF_E_ADDED__TO_FCaptionLbl)
                {
                }
                column(F_STANDARD_AMOUNT_OF_INTERESTCaption; F_STANDARD_AMOUNT_OF_INTERESTCaptionLbl)
                {
                }
                column(E3__FIXEDCaption; E3__FIXEDCaptionLbl)
                {
                }
                column(ECaption; ECaptionLbl)
                {
                }
                column(E2__ACTUALCaption; E2__ACTUALCaptionLbl)
                {
                }
                column(E1__30_Caption; E1__30_CaptionLbl)
                {
                }
                column(D__Caption; D__CaptionLbl)
                {
                }
                column(OWNER___OCCUPIED__INTERESTCaption; OWNER___OCCUPIED__INTERESTCaptionLbl)
                {
                }
                column(DEFINED_CONTRIBUTION_RETIREMENT_SCHEMECaption; DEFINED_CONTRIBUTION_RETIREMENT_SCHEMECaptionLbl)
                {
                }
                column(TOTAL__GROSS__PAYCaption; TOTAL__GROSS__PAYCaptionLbl)
                {
                }
                column(RETIERMENT__CONTRIBUT___ION____OWNER__OCCUPIED__INTERESTCaption; RETIERMENT__CONTRIBUT___ION____OWNER__OCCUPIED__INTERESTCaptionLbl)
                {
                }
                column(COLUMN___D_G_Caption; COLUMN___D_G_CaptionLbl)
                {
                }
                column(TAX_ON___H_Caption; TAX_ON___H_CaptionLbl)
                {
                }
                column(RELIEF__MONTHLYCaption; RELIEF__MONTHLYCaptionLbl)
                {
                }
                column(P_A_Y_E___TAX__J_K_Caption; P_A_Y_E___TAX__J_K_CaptionLbl)
                {
                }
                column(C__Caption; C__CaptionLbl)
                {
                }
                column(VALUE_OF__QUARTERSCaption; VALUE_OF__QUARTERSCaptionLbl)
                {
                }
                column(B__Caption_Control558; B__Caption_Control558Lbl)
                {
                }
                column(BENEFITS__NON_CASHCaption; BENEFITS__NON_CASHCaptionLbl)
                {
                }
                column(BASIC__SALARYCaption; BASIC__SALARYCaptionLbl)
                {
                }
                column(A__Caption_Control601; A__Caption_Control601Lbl)
                {
                }
                column(MONTHCaption; MONTHCaptionLbl)
                {
                }
                column(EmployeeOtherNameCaption; EmployeeOtherNameCaptionLbl)
                {
                }
                column(Employee_s_____P_I_N_Caption; Employee_s_____P_I_N_CaptionLbl)
                {
                }
                column(EmployeeNameCaption; EmployeeNameCaptionLbl)
                {
                }
                column(CompNameCaption; CompNameCaptionLbl)
                {
                }
                column(EmployerPINCaption; EmployerPINCaptionLbl)
                {
                }
                column(INCOME_TAX_DEPARTMENTCaption; INCOME_TAX_DEPARTMENTCaptionLbl)
                {
                }
                column(KENYA_REVENUE_AUTHORITYCaption; KENYA_REVENUE_AUTHORITYCaptionLbl)
                {
                }
                column(Employee_No_; "No.")
                {
                }
                dataitem("Payroll Header"; 51159)
                {
                    DataItemLink = "Employee no." = FIELD("No.");
                    DataItemTableView = SORTING("Payroll Month")
                                        ORDER(Ascending)
                                        WHERE(Posted = CONST(true));

                    trigger OnPreDataItem()
                    begin
                        SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    DateCommenced := 0D;
                    DateTerminated := 0D;
                    EmployeeName := Employee."Last Name";
                    EmployeeOtherName := Employee."First Name" + ' ' + Employee."Middle Name";
                    Employee.SETRANGE("ED Code Filter", PayrollSetupRec."PAYE ED Code");
                    Employee.CALCFIELDS(Employee."Membership No.");
                    EmployeePIN := Employee.PIN;
                    IF (("Employment Date" >= Year."Start Date") AND ("Employment Date" <= Year."End date")) THEN BEGIN
                        DateCommenced := "Employment Date";
                        IF DateCommenced <> 0D THEN
                            OldEmployer := Employee."Name of Old Employer";
                        OldAddr := Employee."Address of Old Employer";
                    END;
                    IF (("Termination Date" >= Year."Start Date") AND ("Termination Date" <= Year."End date")) THEN BEGIN
                        DateTerminated := "Termination Date";
                        IF DateTerminated <> 0D THEN
                            NewEmployer := Employee."Name of New Employer";
                        NewAddr := Employee."Address of New Employer";
                    END;
                    CLEAR(AmountArray);

                    Header.SETRANGE("Employee no.", Employee."No.");
                    IF Header.FIND('-') THEN BEGIN
                        REPEAT
                            AmountArray[1] [Header."Payroll Month"] := Header."A (LCY)";
                            AmountArray[2] [Header."Payroll Month"] := Header."B (LCY)";
                            AmountArray[3] [Header."Payroll Month"] := Header."C (LCY)";
                            AmountArray[4] [Header."Payroll Month"] := Header."D (LCY)";
                            AmountArray[5] [Header."Payroll Month"] := Header."E1 (LCY)";
                            AmountArray[6] [Header."Payroll Month"] := Header."E2 (LCY)";
                            AmountArray[7] [Header."Payroll Month"] := Header."E3 (LCY)";
                            AmountArray[8] [Header."Payroll Month"] := Header."F (LCY)";
                            AmountArray[9] [Header."Payroll Month"] := Header."G (LCY)";
                            AmountArray[10] [Header."Payroll Month"] := Header."H (LCY)";
                            AmountArray[11] [Header."Payroll Month"] := Header."J (LCY)";
                            AmountArray[12] [Header."Payroll Month"] := Header."K (LCY)";
                            AmountArray[13] [Header."Payroll Month"] := Header."L (LCY)";
                            IF Header."M (LCY)" > 0 THEN BEGIN  //SKM130208 OC-ES037 do not show negative PAYE
                                AmountArray[14] [Header."Payroll Month"] := Header."M (LCY)";
                                AmountArray[14] [13] += Header."M (LCY)"
                            END;

                        UNTIL Header.NEXT = 0;

                        Header.CALCSUMS("A (LCY)", "B (LCY)", "C (LCY)", "D (LCY)", "E1 (LCY)", "E2 (LCY)", "E3 (LCY)", "F (LCY)", "G (LCY)", "H (LCY)", "J (LCY)"
                      ,
                         "K (LCY)", "L (LCY)", "M (LCY)");
                        AmountArray[1] [13] := Header."A (LCY)";
                        AmountArray[2] [13] := Header."B (LCY)";
                        AmountArray[3] [13] := Header."C (LCY)";
                        AmountArray[4] [13] := Header."D (LCY)";
                        AmountArray[5] [13] := Header."E1 (LCY)";
                        AmountArray[6] [13] := Header."E2 (LCY)";
                        AmountArray[7] [13] := Header."E3 (LCY)";
                        AmountArray[8] [13] := Header."F (LCY)";
                        AmountArray[9] [13] := Header."G (LCY)";
                        AmountArray[10] [13] := Header."H (LCY)";
                        AmountArray[11] [13] := Header."J (LCY)";
                        AmountArray[12] [13] := Header."K (LCY)";
                        //SKM130208 OC-ES037 do not show negative PAYE
                        //AmountArray[13][13] := Header."L (LCY)";
                        //SKM END
                        AmountArray[13] [13] := Header."L (LCY)";
                        AmountArray[14] [13] := Header."M (LCY)";
                    END;
                    //skip blank P9s
                    IF ((AmountArray[1] [13] = 0) AND
                     (AmountArray[2] [13] = 0) AND
                     (AmountArray[3] [13] = 0) AND
                     (AmountArray[4] [13] = 0) AND
                     (AmountArray[5] [13] = 0) AND
                     (AmountArray[6] [13] = 0) AND
                     (AmountArray[7] [13] = 0) AND
                     (AmountArray[8] [13] = 0) AND
                     (AmountArray[9] [13] = 0) AND
                     (AmountArray[10] [13] = 0) AND
                     (AmountArray[11] [13] = 0) AND
                     (AmountArray[12] [13] = 0) AND
                     (AmountArray[13] [13] = 0)) THEN
                        CurrReport.SKIP;
                    //END skip blank P9s

                    ComAddr.GET();
                    CompanyAddress := 'ADDRESS:...' + ComAddr.Address + ' ' + ComAddr."Address 2";

                    //  AKK START
                    SETFILTER("ED Code Filter", PayrollSetupRec."NSSF ED Code");
                    CALCFIELDS("Membership No.");
                    gvNssfNo := "Membership No.";
                    SETFILTER("ED Code Filter", PayrollSetupRec."PAYE ED Code");
                    CALCFIELDS("Membership No.");
                    gvPinNo := "Membership No.";
                    SETFILTER("ED Code Filter", PayrollSetupRec."NHIF ED Code");
                    CALCFIELDS("Membership No.");
                    gvNhifNo := "Membership No."
                    // AKK END
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                    YearText := 'INCOME TAX DEDUCTION CARD YEAR ' + FORMAT(Year.Year);

                    PayrollSetupRec.GET(gvAllowedPayrolls."Payroll Code");
                    EmployerPIN := PayrollSetupRec."Employer PIN No.";
                    CompName := PayrollSetupRec."Employer Name";

                    Header.SETCURRENTKEY("Employee no.", "Payroll Year", "Payroll Code");
                    Header.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                    Header.SETRANGE("Payroll Year", Year.Year);

                    OldEmployer := '';
                    OldAddr := '';
                    NewEmployer := '';
                    NewAddr := '';
                end;
            }
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
        gsSegmentPayrollData;
    end;

    var
        PayrollSetupRec: Record 51165;
        Header: Record 51159;
        YearText: Text[60];
        EmployerName: Text[60];
        EmployeeName: Text[60];
        EmployeeOtherName: Text[60];
        EmployerPIN: Code[20];
        AmountArray: array[14, 13] of Decimal;
        CompName: Text[50];
        DateCommenced: Date;
        DateTerminated: Date;
        OldEmployer: Text[80];
        OldAddr: Text[80];
        NewEmployer: Text[80];
        NewAddr: Text[80];
        MonthlyRent: Decimal;
        ComAddr: Record 79;
        CompanyAddress: Text[80];
        EmployeePIN: Code[20];
        gvAllowedPayrolls: Record 51182;
        MembershipNumbers: Record 51175;
        gvNhifNo: Code[20];
        gvNssfNo: Code[20];
        gvPinNo: Code[20];
        NOVEMBERCaptionLbl: Label 'NOVEMBER';
        DECEMBERCaptionLbl: Label 'DECEMBER';
        SEPTEMBERCaptionLbl: Label 'SEPTEMBER';
        OCTOBERCaptionLbl: Label 'OCTOBER';
        JULYCaptionLbl: Label 'JULY';
        AUGUSTCaptionLbl: Label 'AUGUST';
        MAYCaptionLbl: Label 'MAY';
        JUNECaptionLbl: Label 'JUNE';
        MARCHCaptionLbl: Label 'MARCH';
        APRILCaptionLbl: Label 'APRIL';
        FEBRUARYCaptionLbl: Label 'FEBRUARY';
        JANUARYCaptionLbl: Label 'JANUARY';
        V2___a__CaptionLbl: Label '2. (a) ';
        V1__Use_P9A__CaptionLbl: Label '1. Use P9A  ';
        IMPORTANTCaptionLbl: Label 'IMPORTANT';
        TOTAL_CHARGEABLE_PAY__COL__H___Kshs_____CaptionLbl: Label 'TOTAL CHARGEABLE PAY (COL. H)  Kshs.....';
        To_be_completed_by_employer_at_end_of_yearCaptionLbl: Label 'To be completed by employer at end of year';
        TOTALSCaptionLbl: Label 'TOTALS';
        Deductible_interest_in_respect_of_any_month_must_not_exceed_KShs_12_500____CaptionLbl: Label 'Deductible interest in respect of any month must not exceed KShs 12,500/= .';
        a__CaptionLbl: Label '(a) ';
        b__CaptionLbl: Label '(b) ';
        For_all_liable_employees_and_where_director_employee_received_benefits_in_addition_to_cash_emoluments_CaptionLbl: Label 'For all liable employees and where director/employee received\benefits in addition to cash emoluments.';
        Where_an_employee_is_eligible_to_deduction_on_owner_occupier_interest_CaptionLbl: Label 'Where an employee is eligible to deduction on owner occupier interest.';
        ii_CaptionLbl: Label '(ii)';
        b__Attach__i_CaptionLbl: Label '(b) Attach (i)';
        TOTAL_TAX__COL__L__KShs_CaptionLbl: Label 'TOTAL TAX (COL. L) KShs.';
        DATE_OF_OCCUPATION_OF_HOUSELbl: Label 'DATE OF OCCUPATION OF HOUSE:';
        L_R__NO__OF_OWNER_OCCUPIED_PROPERTYLbl: Label 'L.R. NO. OF OWNER OCCUPIED PROPERTY:';
        NAMES_OF_FINANCIAL_INSTITUTION_ADVANCING_MORTGAGE_LOANCaptionLbl: Label 'NAMES OF FINANCIAL INSTITUTION ADVANCING MORTGAGE LOAN';
        The_DECLARATION_duly_signed_by_the_employee_to_form_P9A_CaptionLbl: Label 'The DECLARATION duly signed by the employee to form P9A.';
        Photostat_copy_of_preceding_year_s_certificate_or_confirmation_of: Label 'Photostat copy of preceding year''s certificate or confirmation of\current year''s borrowing if applicable from the financial institution.';
        LCaptionLbl: Label ' L';
        KCaptionLbl: Label ' K';
        JCaptionLbl: Label ' J';
        HCaptionLbl: Label ' H';
        G__THE_LOWEST__OF_E_ADDED__TO_FCaptionLbl: Label ' G\ THE LOWEST\ OF E ADDED\ TO F';
        F_STANDARD_AMOUNT_OF_INTERESTCaptionLbl: Label ' F\STANDARD\AMOUNT OF\INTEREST';
        E3__FIXEDCaptionLbl: Label ' E3\ FIXED';
        ECaptionLbl: Label 'E';
        E2__ACTUALCaptionLbl: Label ' E2\ ACTUAL';
        E1__30_CaptionLbl: Label ' E1\ 30%';
        D__CaptionLbl: Label ' D -';
        OWNER___OCCUPIED__INTERESTCaptionLbl: Label ' OWNER-\ OCCUPIED\ INTEREST';
        DEFINED_CONTRIBUTION_RETIREMENT_SCHEMECaptionLbl: Label 'DEFINED CONTRIBUTION\RETIREMENT SCHEME';
        TOTAL__GROSS__PAYCaptionLbl: Label ' TOTAL\ GROSS\ PAY';
        RETIERMENT__CONTRIBUT___ION____OWNER__OCCUPIED__INTERESTCaptionLbl: Label ' RETIERMENT\ CONTRIBUT-\ ION && OWNER\ OCCUPIED\ INTEREST';
        COLUMN___D_G_CaptionLbl: Label ' COLUMN\ (D-G)';
        TAX_ON___H_CaptionLbl: Label ' TAX ON\ (H)';
        RELIEF__MONTHLYCaptionLbl: Label ' RELIEF\ MONTHLY';
        P_A_Y_E___TAX__J_K_CaptionLbl: Label ' P.A.Y.E.\ TAX\(J-K)';
        C__CaptionLbl: Label ' C -';
        VALUE_OF__QUARTERSCaptionLbl: Label ' VALUE OF\ QUARTERS';
        B__Caption_Control558Lbl: Label ' B -';
        BENEFITS__NON_CASHCaptionLbl: Label ' BENEFITS\ NON CASH';
        BASIC__SALARYCaptionLbl: Label ' BASIC\ SALARY';
        A__Caption_Control601Lbl: Label ' A -';
        MONTHCaptionLbl: Label ' MONTH';
        EmployeeOtherNameCaptionLbl: Label 'Employee''s Other Names';
        Employee_s_____P_I_N_CaptionLbl: Label 'Employee''s     P.I.N.';
        EmployeeNameCaptionLbl: Label 'Employee''s Name';
        CompNameCaptionLbl: Label 'Employers Name';
        EmployerPINCaptionLbl: Label 'Employers     P.I.N.';
        INCOME_TAX_DEPARTMENTCaptionLbl: Label 'INCOME TAX DEPARTMENT';
        KENYA_REVENUE_AUTHORITYCaptionLbl: Label 'KENYA REVENUE AUTHORITY';

    procedure gsSegmentPayrollData()
    var
        lvAllowedPayrolls: Record 51182;
        lvPayrollUtilities: Codeunit 51152;
        UsrID: Code[10];
        UsrID2: Code[10];
        StringLen: Integer;
        lvActiveSession: Record 2000000110;
    begin

        lvActiveSession.RESET;
        lvActiveSession.SETRANGE("Server Instance ID", SERVICEINSTANCEID);
        lvActiveSession.SETRANGE("Session ID", SESSIONID);
        lvActiveSession.FINDFIRST;


        gvAllowedPayrolls.SETRANGE("User ID", lvActiveSession."User ID");
        gvAllowedPayrolls.SETRANGE("Last Active Payroll", TRUE);
        IF NOT gvAllowedPayrolls.FINDFIRST THEN
            ERROR('You are not allowed access to this payroll dataset.');
    end;
}

