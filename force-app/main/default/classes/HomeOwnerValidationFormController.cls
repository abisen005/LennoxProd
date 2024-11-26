/*
* @ Purpose      : This class is used to update FTL_Program_Form__c record from lightning cmp.                   
* @ CreatedDate  : 4/4/2019
*/
public class HomeOwnerValidationFormController {
    
    /* 
    * @Purpose      : this function used to get FTL_Program_Form__c record.
    * @Parameter    : String strRecordId. 
    * @Returntype   : Response.
    */
    @AuraEnabled
    public static Response getOnloadPageData(String strRecordId){
        try{
            if(String.isNotBlank(strRecordId)){
                List<FTL_Program_Form__c> programFormList = [SELECT Id, Nominee_Name__c, Nominee_Street_Address__c, Nominee_City__c, 
                                                             Nominee_State__c, Nominee_Zip_Code__c, Nominee_Phone_Number__c,
                                                             Installation_falls_in_5_7_hour_window__c, Is_it_a_gas_furnace__c,
                                                             Complete_ductwork_system_in_place__c, Which_model_of_furnace_to_use__c,
                                                             Other_Furnace__c, LP_Kit_needed__c, Other_materials_supplies_needed__c,
                                                             Optional_Other_house_yard_work__c, Installation_Date__c
                                                             FROM FTL_Program_Form__c 
                                                             WHERE Id =: strRecordId];
                
                if(programFormList != null && !programFormList.isEmpty()){
                    return new Response(true, programFormList[0], '');
                }
                else{
                    return new Response(false, null, 'Record Not Found.');
                }
            }
            else{
                return new Response(false, null, 'Record Id Not Found.');
            }
        }
        catch(Exception ex){
            return new Response(false, null, ex.getMessage());
        }
        
    }
    
    /* 
    * @Purpose      : this function used to update FTL_Program_Form__c record.
    * @Parameter    : FTL_Program_Form__c programStatus. 
    * @Returntype   : Response.
    */
    @AuraEnabled
    public static Response updateProgramStatusRecord(FTL_Program_Form__c programStatus){
        try{
            if(programStatus != null){
                
                Update programStatus;
                return new Response(true, programStatus, '');
            }
            return new Response(false, null, 'Program Status Record not found.');
        }
        catch(Exception ex){
            return new Response(false, null, ex.getMessage());
        }
        
    }
    
    public class Response{
        @AuraEnabled
        public string msg;
        @AuraEnabled
        public boolean isSuccess;
        @AuraEnabled
        public object data;
        
        public Response(boolean isSuccess, object data, string msg){
            this.isSuccess = isSuccess;
            this.data = data;
            this.msg = msg;
        }
    }
}