/**
 * Trigger handler for 
 */
public class OpportunityScoreCardHandler{

	public static void onBeforeInsert(List<Scorecard__c> scoreCardList){
		
		if(scoreCardList != null){
			avoidDuplicateRecords(scoreCardList);
		}
	}
	
	private static void avoidDuplicateRecords(List<Scorecard__c> scoreCardList){
	
		Map<String, Scorecard__c> accountToScoreCardMap = new Map<String, Scorecard__c>();
		
		for(Scorecard__c scoreCard :scoreCardList){
			
			// set fields as per SegmentCalculation
			setObjectFields(scoreCard);
			
			if(scoreCard.Account__c != null){
			
				if(accountToScoreCardMap.containsKey(scoreCard.Account__c)){
					scoreCard.addError('This Dealer already has a Scorecard');
				}else{
					accountToScoreCardMap.put(scoreCard.Account__c, scoreCard);
				}
			}
		}
		
		// get existing scorecard and throw error for duplicate account related opps.corecard
		for(Scorecard__c scoreCard :[SELECT Id, Account__c 
									  FROM Scorecard__c 
									  WHERE Account__c IN : accountToScoreCardMap.keySet()]){
									  
			if(accountToScoreCardMap.containsKey(scoreCard.Account__c)){
				
				Scorecard__c newScoreCard = accountToScoreCardMap.get(scoreCard.Account__c);
				newScoreCard.addError('This Dealer already has a Scorecard');
			}
		}
	}
	
	public static void onBeforeUpdate(List<Scorecard__c> scoreCardList){
		
		if(scoreCardList != null){
			for(Scorecard__c scoreCard :scoreCardList){
				setObjectFields(scoreCard);
			}
		}
	}
	
	private static void setObjectFields(Scorecard__c scoreCard){		
		
		Double yrs_curr_sup_scr = 0;
		Double past_Len_rel_scr = 0;
		Double dist_to_ware_scr = 10;
		Double part_in_promo_scr = 0;
		Double hVAC_Purch_Scr = 2;
		Double has_Storefront_scr = 0;
		Double step_1_Sum_Scr = 0;
		Double has_exp_chn_rec_scr = 0;
		Double has_Clr_Vsn_Scr = 0;
		Double has_Part_Ment_Scr = 0;
		Double sat_with_Curr_Splr_Scr = 5;
		Double cust_Ldr_Sprt_Scr = 0;
		Double lnx_Val_Prop_Scr = 0;
		Double est_Dec_Ddln_Scr = 0;
		Double step_2_Sum_Scr = 0;
		Double step1_Step2_Sum = 0;
		Double step_2_Rescore_Adj = 0;
		Double adj_LNX_prod_purch_grth_opp_Scr = 2.2;
		
		scoreCard.CALCMkg_Score__c = scoreCard.MkgDlr_Score__c;
		scoreCard.CALCLcl_Score__c = scoreCard.LclDlr_Score__c;
		scoreCard.CALC_Product_Score__c = scoreCard.PrdDlr_Score__c;
		
		
		if(String.isBlank(scoreCard.Years_with_current_supplier__c) || double.valueOf(scoreCard.Years_with_current_supplier__c) <= 2){
			
			yrs_curr_sup_scr = 50;
		}else{
			Double yrs_curr_sup = double.valueOf(scoreCard.Years_with_current_supplier__c);
			
			if (yrs_curr_sup <= 4) {
					yrs_curr_sup_scr = 40;
			}else if (yrs_curr_sup <= 6) {
				yrs_curr_sup_scr = 30;
			}else if (yrs_curr_sup <= 8) {
				yrs_curr_sup_scr = 20;
			}else if (yrs_curr_sup <= 10) {
				yrs_curr_sup_scr = 10;
			}else {
				yrs_curr_sup_scr = 5;
			}
		}
		
		if (String.isNotBlank(scoreCard.Existing_or_past_Lennox_relationship__c) && 
			scoreCard.Existing_or_past_Lennox_relationship__c.equalsIgnoreCase('Yes')) {
				
			Past_Len_rel_scr = 50;
		}
		
		if(scoreCard.Distance_to_the_closest_Lennox_warehouse__c != null){
			if(scoreCard.Distance_to_the_closest_Lennox_warehouse__c <= 10){
				
				dist_to_ware_scr = 100;
			}else if(scoreCard.Distance_to_the_closest_Lennox_warehouse__c <= 15){
				
				dist_to_ware_scr = 80;
			}else if(scoreCard.Distance_to_the_closest_Lennox_warehouse__c <= 20){
				
				dist_to_ware_scr = 60;
			}else if(scoreCard.Distance_to_the_closest_Lennox_warehouse__c <= 25){
				
				dist_to_ware_scr = 40;
			}else if(scoreCard.Distance_to_the_closest_Lennox_warehouse__c <= 30){
				
				dist_to_ware_scr = 20;
			}
		}
		
		if (String.isNotBlank(scoreCard.Would_participate_in_Lennox_promotions__c) && 
			scoreCard.Would_participate_in_Lennox_promotions__c.equalsIgnoreCase('Yes')) {
				
			part_in_promo_scr = 60;
		}
		
		if(scoreCard.Estimated_annual_HVAC_purchases__c == null || scoreCard.Estimated_annual_HVAC_purchases__c <= 249999){
			
			hVAC_Purch_Scr = 1;
		}else if(scoreCard.Estimated_annual_HVAC_purchases__c <= 349999){
			
			hVAC_Purch_Scr = 1.1;
		}else if(scoreCard.Estimated_annual_HVAC_purchases__c <= 499999){
			
			hVAC_Purch_Scr = 1.2;
		}else if(scoreCard.Estimated_annual_HVAC_purchases__c <= 649999){
			
			hVAC_Purch_Scr = 1.4;
		}else if(scoreCard.Estimated_annual_HVAC_purchases__c <= 799999){
			
			hVAC_Purch_Scr = 1.6;
		}else if(scoreCard.Estimated_annual_HVAC_purchases__c <= 949999){
			
			hVAC_Purch_Scr = 1.8;
		}
		
		if (String.isNotBlank(scoreCard.Dealer_has_a_Storefront__c) && 
			scoreCard.Dealer_has_a_Storefront__c.equalsIgnoreCase('Yes')){
			
			has_Storefront_scr = 50;
		}
		
		// Update Step 1 Summary
		step_1_Sum_Scr = (Math.min(500,(((yrs_curr_sup_scr + past_Len_rel_scr + dist_to_ware_scr + part_in_promo_scr) * hVAC_Purch_Scr ) + 
                                                has_Storefront_scr)));
												
		if (step_1_Sum_Scr < 0){
			
			step_1_Sum_Scr = -1*math.roundtolong(math.abs(step_1_Sum_Scr));
		}else {
			step_1_Sum_Scr = math.roundtolong(step_1_Sum_Scr);
		}
		
		if (String.isNotBlank(scoreCard.Dealer_has_experienced_recent_change__c) && 
			scoreCard.Dealer_has_experienced_recent_change__c.equalsIgnoreCase('Yes')) {
				
			has_exp_chn_rec_scr = 70;
		}
		
		if (String.isNotBlank(scoreCard.Dealer_has_Partnership_Mentality__c) && 
			scoreCard.Dealer_has_Partnership_Mentality__c.equalsIgnoreCase('Yes')) {
				
			has_Part_Ment_Scr = 80;
		}
		
		if (String.isNotBlank(scoreCard.Has_a_clear_vision_of_their_goals__c) && 
			scoreCard.Has_a_clear_vision_of_their_goals__c.equalsIgnoreCase('Yes')) {
				
			has_Clr_Vsn_Scr = 100;
		}
		
		if (String.isNotBlank(scoreCard.Satisfied_with_their_current_supplier__c)){
			
			Integer sat_with_Curr_Splr = integer.valueOf(scoreCard.Satisfied_with_their_current_supplier__c);
			if (sat_with_Curr_Splr >= 8){
				
				Sat_with_Curr_Splr_Scr = 50;
			}else if (Sat_with_Curr_Splr >= 7){
				
				Sat_with_Curr_Splr_Scr = 40;
			}else if (sat_with_Curr_Splr >= 5){
				
				sat_with_Curr_Splr_Scr = 30;
			}else if (sat_with_Curr_Splr >= 3){
				
				sat_with_Curr_Splr_Scr = 20;
			}
		}
		
		if (String.isNotBlank(scoreCard.Customer_leadership_support_at_all_level__c) && 
			scoreCard.Customer_leadership_support_at_all_level__c.equalsIgnoreCase('Yes')){
			
			cust_Ldr_Sprt_Scr = 120;
		}
		
		if (String.isNotBlank(scoreCard.Understands_Lennox_value_proposition__c) && 
			scoreCard.Understands_Lennox_value_proposition__c.equalsIgnoreCase('Yes')){
			
			lnx_Val_Prop_Scr = 100;
		}
		
		if (String.isNotBlank(scoreCard.Established_a_decision_deadline__c) && 
			scoreCard.Established_a_decision_deadline__c.equalsIgnoreCase('Yes')){
			
			est_Dec_Ddln_Scr = 100;
		}
		
		// Update Step 2 Summary    
		step_2_Sum_Scr  = has_exp_chn_rec_scr + has_Part_Ment_Scr + has_Clr_Vsn_Scr + sat_with_Curr_Splr_Scr + cust_Ldr_Sprt_Scr + lnx_Val_Prop_Scr + 
						  est_Dec_Ddln_Scr;
		
		// Add Step 1 & Step 2 together 
		scoreCard.Step_1_Step_2_Sum__c = step_1_Sum_Scr + step_2_Sum_Scr;
		
		Double growth_Opp_P_and_S = scoreCard.Growth_opportunity_Parts_Supplies__c != null ?
									scoreCard.Growth_opportunity_Parts_Supplies__c :
									0;
		Double growth_Opp_Res_Rep = scoreCard.Growth_opportunity_Res_Replacement__c != null ?
									scoreCard.Growth_opportunity_Res_Replacement__c :
									0;
		Double growth_Opp_RNC = scoreCard.Growth_opportunity_RNC__c != null ?
									scoreCard.Growth_opportunity_RNC__c :
									0;
		Double growth_Opp_Comm = scoreCard.Growth_opportunity_Commercial__c != null ?
									scoreCard.Growth_opportunity_Commercial__c :
									0;
		Double growth_Opp_IAQ = scoreCard.Growth_opportunity_IAQ__c != null ?
									scoreCard.Growth_opportunity_IAQ__c :
									0;
	
		step_2_Rescore_Adj =  (growth_Opp_P_and_S *0.1) + 
                          (growth_Opp_Res_Rep *0.5) + 
                          (growth_Opp_RNC *0.1) + 
                          (growth_Opp_Comm *0.05) + 
                          (growth_Opp_IAQ *0.25) ;
						  
		Integer cust_invt_prod_Scr = (String.isNotBlank(scoreCard.Does_the_customer_inventory_product__c) && 
									 scoreCard.Does_the_customer_inventory_product__c.equalsIgnoreCase('Yes'))?
									 15 : 0;
		Integer cust_part_Lnx_Stk_Scr = (String.isNotBlank(scoreCard.Will_Cust_participate_in_Stocking_Prgms__c) && 
									 scoreCard.Will_Cust_participate_in_Stocking_Prgms__c.equalsIgnoreCase('Yes')) ?
									 10 : 0;
		
		Integer overall_Rating_Scr = scoreCard.Overall_rating_of_experience_w_Lennox__c != null ?
									 integer.valueOf(scoreCard.Overall_rating_of_experience_w_Lennox__c):
									 -6;
		if(overall_Rating_Scr != -6){
			
			if(Overall_Rating_Scr == 10){
				
				Overall_Rating_Scr = 20;
			}else if(Overall_Rating_Scr >= 7){
				
				Overall_Rating_Scr = 16;
			}else if(Overall_Rating_Scr >= 5){
				
				Overall_Rating_Scr = 12;
			}else if(Overall_Rating_Scr >= 3){
				
				Overall_Rating_Scr = 0;
			}
		}
		
		if(scoreCard.Adjusted_LNX_prods_purch_growth_opportun__c == null || scoreCard.Adjusted_LNX_prods_purch_growth_opportun__c <= 249999){
			
			adj_LNX_prod_purch_grth_opp_Scr = 1;
		}else if(scoreCard.Adjusted_LNX_prods_purch_growth_opportun__c <= 349999){
			
			adj_LNX_prod_purch_grth_opp_Scr = 1.1;
		}else if(scoreCard.Adjusted_LNX_prods_purch_growth_opportun__c <= 499999){
			
			adj_LNX_prod_purch_grth_opp_Scr = 1.2;
		}else if(scoreCard.Adjusted_LNX_prods_purch_growth_opportun__c <= 649999){
			
			adj_LNX_prod_purch_grth_opp_Scr = 1.5;
		}else if(scoreCard.Adjusted_LNX_prods_purch_growth_opportun__c <= 799999){
			
			adj_LNX_prod_purch_grth_opp_Scr = 1.8;
		}else if(scoreCard.Adjusted_LNX_prods_purch_growth_opportun__c <= 949999){
			
			adj_LNX_prod_purch_grth_opp_Scr = 1.9;
		}
		
		Integer crnt_Fin_Stmnt_Scr = String.isNotBlank(scoreCard.Do_we_have_a_current_financial_statement__c) && 
									 scoreCard.Do_we_have_a_current_financial_statement__c.equalsIgnoreCase('Yes') ?
									 15 :
									 0;
		Integer acct_Crnt_with_Lnx_Scr = String.isNotBlank(scoreCard.Is_the_Account_current_with_Lennox__c) && 
									 scoreCard.Is_the_Account_current_with_Lennox__c.equalsIgnoreCase('Yes') ?
									 30 :
									 -15;
		Integer crdt_Line_with_Lnx_Scr = String.isNotBlank(scoreCard.Does_Account_have_credit_line_w_Lennox__c) && 
									 scoreCard.Does_Account_have_credit_line_w_Lennox__c.equalsIgnoreCase('Yes') ?
									 10 :
									 0;
		Double amt_credit_line = scoreCard.What_is_the_amount_of_the_Credit_line__c != null ?
								 scoreCard.What_is_the_amount_of_the_Credit_line__c :
								 0;
		Double credit_Line_spt_prch = scoreCard.Calc_Credit_line_need_to_support_Purchas__c != null ?
								 scoreCard.Calc_Credit_line_need_to_support_Purchas__c :
								 0;
		Integer credit_Line_spt_prch_Scr = amt_credit_line >= credit_Line_spt_prch ?
								 30 :
								 -10;
		Integer cust_Bnk_ln_crdt_Scr = String.isNotBlank(scoreCard.Does_Customer_have_a_bank_line_of_credit__c) && 
									 scoreCard.Does_Customer_have_a_bank_line_of_credit__c.equalsIgnoreCase('Yes') ?
									 5 :
									 0;
		Integer cust_ltr_crdt_Scr = String.isNotBlank(scoreCard.Does_Customer_have_a_letter_of_credit__c) && 
									 scoreCard.Does_Customer_have_a_letter_of_credit__c.equalsIgnoreCase('Yes') ?
									 5 :
									 0;
		Integer prsn_guar_w_prn_Scr = String.isNotBlank(scoreCard.We_have_personal_guarantees_w_principal__c) && 
									 scoreCard.We_have_personal_guarantees_w_principal__c.equalsIgnoreCase('Yes') ?
									 5 :
									 0;
		Double rescore1 = ((Dist_to_ware_scr + 
                     Cust_invt_prod_scr + 
                     Cust_part_Lnx_Stk_Scr +
                     Past_Len_rel_scr +
                     Overall_Rating_Scr + 
                     Yrs_curr_sup_scr +
                     (Growth_Opp_P_and_S* .10) + 
                     (Growth_Opp_Res_Rep * .50) + 
                     (Growth_Opp_RNC * .10) + 
                     (Growth_Opp_Comm * .05) + 
                     (Growth_Opp_IAQ * .25))*
                     Adj_LNX_prod_purch_grth_opp_Scr) +
                     Has_Storefront_scr +
                     Crnt_Fin_Stmnt_Scr +
                     Crdt_Line_with_Lnx_Scr +
                     Acct_Crnt_with_Lnx_Scr +
                     Credit_Line_spt_prch_Scr +
                     Cust_Bnk_ln_crdt_Scr + 
                     Cust_ltr_crdt_Scr +
                     Prsn_guar_w_prn_Scr;
		
		Double sum_Final_adj_scr = Math.min(500,(rescore1)) + step_2_Sum_Scr;
		sum_Final_adj_scr = sum_Final_adj_scr < 0 ? 
							-1*math.roundtolong(math.abs(sum_Final_adj_Scr)):
							math.roundtolong(sum_Final_adj_Scr);
							
		scoreCard.Sum_of_Final_Adjusted_Score__c = sum_Final_adj_Scr;
		
		// Get Adjusted Score (adjusted by Chris)
		Double total_adj_scr_all_steps = step1_Step2_Sum + step_2_Rescore_Adj;
		
		//Compute Initial grade based on step1 + step 2 score
		if (scoreCard.Estimated_annual_HVAC_purchases__c == null || scoreCard.Dealer_has_a_Storefront__c == null || 
		    scoreCard.Distance_to_the_closest_Lennox_warehouse__c == null || 
			scoreCard.Years_with_current_supplier__c == null || scoreCard.Existing_or_past_Lennox_relationship__c == null || 
			scoreCard.Would_participate_in_Lennox_promotions__c == null || scoreCard.Dealer_has_experienced_recent_change__c == null || 
			scoreCard.Has_a_clear_vision_of_their_goals__c == null || scoreCard.Customer_leadership_support_at_all_level__c == null ||
			scoreCard.Dealer_has_Partnership_Mentality__c == null || scoreCard.Satisfied_with_their_current_supplier__c == null || 
			scoreCard.Understands_Lennox_value_proposition__c == null || scoreCard.Established_a_decision_deadline__c == null) {
				
		    scoreCard.Initial_Grade__c = 'No Grade - Incomplete';
		}else if (Step1_Step2_Sum > 900) {
			
		  scoreCard.Initial_Grade__c = 'A';
		}else if (Step1_Step2_Sum >= 750) {
			
		  scoreCard.Initial_Grade__c = 'B';
		}else if (Step1_Step2_Sum >= 650) {
			
		  scoreCard.Initial_Grade__c = 'C';
		}else if (Step1_Step2_Sum >= 550) {
			
		  scoreCard.Initial_Grade__c = 'D';
		}else {
			
		  scoreCard.Initial_Grade__c = 'F';
		}
		
		// Compute Revised Grade based on total adjusted score
		if (scoreCard.Estimated_annual_HVAC_purchases__c == null || scoreCard.Dealer_has_a_Storefront__c == null || 
		    scoreCard.Distance_to_the_closest_Lennox_warehouse__c == null || scoreCard.Years_with_current_supplier__c == null || 
			scoreCard.Existing_or_past_Lennox_relationship__c == null || scoreCard.Would_participate_in_Lennox_promotions__c == null ||
			scoreCard.Dealer_has_experienced_recent_change__c == null || scoreCard.Has_a_clear_vision_of_their_goals__c == null || 
			scoreCard.Customer_leadership_support_at_all_level__c == null || scoreCard.Dealer_has_Partnership_Mentality__c == null || 
			scoreCard.Satisfied_with_their_current_supplier__c == null || scoreCard.Understands_Lennox_value_proposition__c == null ||
			scoreCard.Established_a_decision_deadline__c == null) {
		  
			scoreCard.Scorecard_Grade__c = 'No Grade - Incomplete';
		}
		else if (sum_Final_adj_scr > 900) {
			scoreCard.Scorecard_Grade__c = 'A';
		}
		else if (sum_Final_adj_scr >= 750) {
			scoreCard.Scorecard_Grade__c = 'B';
		}
		else if (sum_Final_adj_scr >= 650) {
			scoreCard.Scorecard_Grade__c = 'C';
		}
		else if (sum_Final_adj_scr >= 550) {
			scoreCard.Scorecard_Grade__c = 'D';
		}else {
			scoreCard.Scorecard_Grade__c = 'F';
		}
		
		// Set the "Update Scoring" field to false"
		scoreCard.Update_Scoring__c = false;
	}
}