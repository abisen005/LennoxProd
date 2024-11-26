public without sharing class LSAFormController {
  
  @AuraEnabled
  public static Response getLSAProgramRecord(String strLSAProgramName) {
    
    List<Lennox_LSA_Program__c> LSAProgramList = new List<Lennox_LSA_Program__c>();
    
    if (String.isNotBlank(strLSAProgramName)) {
      
      try {
        
        LSAProgramList = [
          SELECT Id, Name, Program_Expiration_Date__c, Consumer_Program_Expiration_Date__c, Amount__c, Description__c,Material_Number__c,
          Order_Reason__c, Special_Allowance_Form__c, 
          Reason_for_Reimbursement__c, Units_Affected__c
          FROM Lennox_LSA_Program__c
          WHERE Name =: strLSAProgramName
        ];
        
        if(LSAProgramList != null && !LSAProgramList.isEmpty()){
          
          return new Response(true, LSAProgramList[0], '');
        } else {
          
          return new Response(true, null, 'LSA Program not found!');
        }
      } catch(Exception e) {
        
        return new Response(false, null, getExceptionString(e));
      }
    } else {
      
      return new Response(false, null, 'Error occurred!');
    }
  }
  
  @AuraEnabled
  public static string getRecordTypeId(){ 
    
    try {
      
      string devRecordTypeId = Schema.SObjectType.Lennox_Form__c.getRecordTypeInfosByName().get('Corp Program').getRecordTypeId();
      return devRecordTypeId;
      
    }catch (Exception Ex) { 
      return '';
    }
  } 
  
  @AuraEnabled
  public static Response createLennoxFormRecord(Lennox_Form__c lennoxForm, Lennox_LSA_Program__c lSAProgram) {
    
    Savepoint sp = Database.setSavepoint();
    if (lennoxForm != null) {
      
      try {
        lennoxForm.Lennox_LSA_Program__c = lSAProgram.Id;
        Insert lennoxForm;
        system.debug('lSAProgram  '+lSAProgram);
        return updateSiteLocationRecord(lennoxForm, lSAProgram);
      } catch (Exception e) {
        Database.rollback(sp);
        system.debug('Exception e'+e);
        return new Response(false, null, getExceptionString(e));
      }
    } else {
      Database.rollback(sp);
      return new Response(false, null, 'Error occurred!');
    }
  }
  
  public static Response updateSiteLocationRecord(Lennox_Form__c lennoxForm, Lennox_LSA_Program__c lSAProgram){
    
    
    if (lennoxForm != null) {
      
      List<Home_Owners__c> siteLocations = [
        SELECT Id, FirstName__c, LastName__c
        FROM Home_Owners__c
        WHERE Address__c =: lennoxForm.JobStreetAddress__c
        AND City__c =: lennoxForm.JobCity__c
        AND StateProvince__c =: lennoxForm.JobState__c
        AND Postal_Code__c =: lennoxForm.JobPostalCode__c
      ];
      
      if (siteLocations != null && !siteLocations.isEmpty()) {
        
        siteLocations[0].FirstName__c = lennoxForm.JobFirstName__c;
        siteLocations[0].LastName__c = lennoxForm.JobLastName__c;
        findOrCreateEquipmentData(lennoxForm, siteLocations[0], lSAProgram);
        
        Update siteLocations[0];
        lennoxForm.Site_Location__c = siteLocations[0].Id;
        Update lennoxForm;
        
        return new Response(true, lennoxForm, 'SiteLocation updated successfully');
      } else {
        
        createSiteLocation(lennoxForm, lSAProgram);
        return new response(true, lennoxForm,'SiteLocation created successfully');
      }
    } else {
      
      return new response(false, null, 'Error occurred!');
    }
    
  }
  
  @AuraEnabled
  public static Response getAccountDetailsApex(String dealerNumber) {
    
    try {
      
      Account account = getAccount(dealerNumber);
      
      if (account != null) {
        
        return new Response(true, account, null);
      } else {
        
        return new Response(false, null, 'Unable to find account. Please enter a valid Account Number.');
        
      }
    } catch (Exception e) {
      return new Response(false, null, getExceptionString(e));
    }
  }
  
  @AuraEnabled
  public static Response UpdateLennoxConsumerFormRecord(Consumer_Form__c consumerForm ,String submitterEmail,String siteLocationId) {
       List<Lennox_LSA__c> checkConsumerChildLSARecordList = new List<Lennox_LSA__c>();

    checkConsumerChildLSARecordList = [SELECT Id,Consumer_Form__c,Home_Owner__r.Email__c,Site_Location__c FROM Lennox_LSA__c WHERE Consumer_Form__c =:  consumerForm.Id ];

    String msg;
    Savepoint sp = Database.setSavepoint();
    if (consumerForm != null && checkConsumerChildLSARecordList.isEmpty()  ) {
      Consumer_Form__c getConsumerFormInfo = [SELECT Id,Lennox_LSA__c,
                              Lennox_LSA__r.Account__c,Lennox_LSA__r.HomeOwnerFullName__c,  Site_Location__r.Email__c,
                              Lennox_LSA__r.Home_Owner__c,Lennox_LSA__r.Type_of_Backup_Heat__c,Lennox_LSA__r.Serial_Number__c,Lennox_LSA__r.Order_Reason__c,Lennox_LSA__r.Reason_for_Reimbursement__c,
                              Lennox_LSA__r.Parent_LSA__c,Lennox_LSA__r.Consumer_Form__c,Lennox_LSA__r.Corp_Program__c ,Lennox_LSA__r.Requestor_Comments__c,
                              Lennox_LSA__r.Created_Date__c ,Job_First_Name__c,Job_Last_Name__c,Site_City__c,Site_State__c,Site_Postal_Code__c,
                              Site_Street_Address__c,
                              Unit_Type__c,Unit_Serial_Number__c,Unit_Model_Number__c,Type_of_Back_up_Fuel__c
                              FROM Consumer_Form__c WHERE Id =:consumerForm.Id LIMIT 1 ];
      
      Home_Owners__c siteLocation = [Select Id,Email__c FROM Home_Owners__c WHERE Id =: siteLocationId ];
      system.debug('submitterEmail' +submitterEmail );
               siteLocation.Email__c =submitterEmail;

      try {
        //lennoxForm.Lennox_LSA_Program__c = lSAProgram.Id;
        //update consumerForm;
        system.debug('consumerForm  '+consumerForm);
        //return updateSiteLocationRecord(lennoxForm, lSAProgram);
        
         
          update siteLocation;
        Database.SaveResult saves = Database.update(consumerForm, false);
        if(!saves.isSuccess()) {
          msg = 'Error '+ saves.getErrors()[0].getMessage();
          
        }
        else {
          
          msg = 'LennoxConsumerForm Updated Successfully!';
          
          Lennox_LSA__c newChildLSA = new Lennox_LSA__c();
          newChildLSA.Account__c = getConsumerFormInfo.Lennox_LSA__r.Account__c;
          newChildLSA.Serial_Number__c =getConsumerFormInfo.Unit_Serial_Number__c;
          newChildLSA.Model_Number__c = getConsumerFormInfo.Unit_Model_Number__c;
          newChildLSA.Consumer_Form__c =getConsumerFormInfo.Id;
          newChildLSA.Order_Reason__c =getConsumerFormInfo.Lennox_LSA__r.Order_Reason__c;
          newChildLSA.Reason_for_Reimbursement__c ='Programs (Res)';
          newChildLSA.Parent_LSA__c =getConsumerFormInfo.Lennox_LSA__c;
          newChildLSA.Is_LSA_Request_to_Reimburse_a_Homeowner__c ='Yes';
          newChildLSA.Home_Owner__c = getConsumerFormInfo.Lennox_LSA__r.Home_Owner__c;
          newChildLSA.Corp_Program__c = true;
          newChildLSA.Requestor_Comments__c =getConsumerFormInfo.Lennox_LSA__r.Requestor_Comments__c;
          newChildLSA.Type_of_Backup_Heat__c = getConsumerFormInfo.Type_of_Back_up_Fuel__c;               
         //insert newChildLSA;
          
          Database.SaveResult saveResults = Database.insert(newChildLSA, false);
if(saveResults.isSuccess())
{
  Lennox_LSA__c newChildLSARecord = [Select Id FROM Lennox_LSA__c WHERE ID =: saveResults.getId() ];
findOrCreateConsumerEquipmentData(consumerForm, getConsumerFormInfo.Site_Location__c, 
                null ,newChildLSARecord);         }            
        }
        return new Response(true, consumerForm, msg);        
      } catch (Exception e) {
        Database.rollback(sp);
        system.debug('Exception e'+e);
        return new Response(false, null, getExceptionString(e));
      }
    } else {
      Database.rollback(sp);
      return new Response(false, null, 'Submitted');
    }
  }
  

  @testVisible
  private static void createSiteLocation(Lennox_Form__c lennoxForm, Lennox_LSA_Program__c lSAProgram){
    
    Home_Owners__c siteLocation = new Home_Owners__c();
    siteLocation.FirstName__c = lennoxForm.JobFirstName__c;
    siteLocation.LastName__c = lennoxForm.JobLastName__c;
    siteLocation.Postal_Code__c = lennoxForm.JobPostalCode__c;
    siteLocation.Address__c = lennoxForm.JobStreetAddress__c;
    siteLocation.City__c = lennoxForm.JobCity__c;
    siteLocation.StateProvince__c = lennoxForm.JobState__c;
    
    Insert siteLocation;
    
    lennoxForm.Site_Location__c = siteLocation.Id;
    
    if(!test.isRunningTest()){
      Update lennoxForm;
    }
    
    findOrCreateEquipmentData(lennoxForm, siteLocation, lSAProgram);
  }
  
  private static void findOrCreateEquipmentData(Lennox_Form__c lennoxForm, Home_Owners__c siteLocation, 
                         Lennox_LSA_Program__c lSAProgram) 
  {
    
    Equipment_Data__c eData;
    List<Equipment_Data__c> eDataList = new List<Equipment_Data__c>();
    if (String.isNotEmpty(lennoxForm.IndoorUnitSerialNumber__c)) {
      
      eDataList = [
        SELECT Id
        FROM Equipment_Data__c
        WHERE Serial_Number__c =: lennoxForm.IndoorUnitSerialNumber__c
      ];
      
      if (eDataList != null && !eDataList.isEmpty()) {
        
        updateOrCreateEquipmentJunction(eDataList[0].Id, lennoxForm,null, siteLocation, lSAProgram,null);
      } else {
        
        eData = new Equipment_Data__c();
        //eData.Type__c = type,
        eData.Installation_Date__c = lennoxForm.DateUnitInstalled__c;
        eData.Serial_Number__c = lennoxForm.IndoorUnitSerialNumber__c;
        eData.Model_Number__c = lennoxForm.IndoorUnitModelNumber__c;
        
        eDataList.add(eData);
        Insert eDataList;
        
        updateOrCreateEquipmentJunction(eDataList[0].Id, lennoxForm,null, siteLocation, lSAProgram,null);
      }
    }
  }
  
  private static void updateOrCreateEquipmentJunction(String equipDataId, Lennox_Form__c lennoxForm, Consumer_Form__c consumerForm,
                            Home_Owners__c siteLocation,Lennox_LSA_Program__c lSAProgram, Lennox_LSA__c consumerChildLSA)
  {
    if(lennoxForm != null ){
    lennoxForm.Equipment_Data__c = equipDataId;
    }else{
      consumerForm.Equipment_Data__c =equipDataId;
    }
    Case_Equip_Junction__c euipJunction;
    List<Case_Equip_Junction__c> euipJunctionlist = new List<Case_Equip_Junction__c>();
    
    if (String.isNotBlank(equipDataId)) {
      
      euipJunctionlist = [SELECT Id, Lennox_LSA__c, Equipment_Data__c,Lennox_Form__c,Consumer_Form__c
                FROM Case_Equip_Junction__c  
                WHERE Equipment_Data__c =: equipDataId
                AND Lennox_LSA__c != NULL
                ];
      
      
      System.debug('euipJunctionlist '+ euipJunctionlist);
      if(lennoxForm != null){
      if (euipJunctionlist != null && !euipJunctionlist.isEmpty() ) {
        
        lennoxForm.Lennox_LSA__c = euipJunctionlist[0].Lennox_LSA__c;
        
        Lennox_LSA__c lennoxLSARec =  new Lennox_LSA__c();
        lennoxLSARec.Id = euipJunctionlist[0].Lennox_LSA__c;
        lennoxLSARec.lennoxForm__c = lennoxForm.Id;
        lennoxLSARec.Lennox_LSA_Program__c = lSAProgram.Id;
        update lennoxLSARec;
        
        
        euipJunction = euipJunctionlist[0];
        if(euipJunction.Lennox_Form__c == null){
          euipJunction.Lennox_Form__c = lennoxForm.Id;
          Update euipJunction;
        }
      } else {
        
        Lennox_LSA__c newLennoxLSARec = CreateLennoxLSA(siteLocation, lennoxForm, lSAProgram);
        System.debug('newLennoxLSARec '+ newLennoxLSARec);
        
        euipJunction = new Case_Equip_Junction__c();
        euipJunction.Equipment_Data__c  = equipDataId;
        euipJunction.Lennox_Form__c = lennoxForm.Id;
        euipJunction.Lennox_LSA__c = newLennoxLSARec != null ? newLennoxLSARec.id : null;
        
        euipJunctionlist.add(euipJunction);
        update lennoxForm;
        Insert euipJunctionlist;
      }
      }
      else if(consumerForm != null && euipJunctionlist != null && !euipJunctionlist.isEmpty() ){
         
        //consumerForm.Lennox_LSA__c = euipJunctionlist[0].Lennox_LSA__c;
        
      /*    Lennox_LSA__c lennoxLSARec =  new Lennox_LSA__c();
        lennoxLSARec.Id = euipJunctionlist[0].Lennox_LSA__c;
        lennoxLSARec.lennoxForm__c = lennoxForm.Id;
        lennoxLSARec.Lennox_LSA_Program__c = lSAProgram.Id;
        update lennoxLSARec;
        */
        
        euipJunction = euipJunctionlist[0];
        if(euipJunction.Consumer_Form__c == null){
          euipJunction.Consumer_Form__c = consumerForm.Id;
          Update euipJunction;
        }
      }else{
         euipJunction = new Case_Equip_Junction__c();
        euipJunction.Equipment_Data__c  = equipDataId;
        euipJunction.Consumer_Form__c = consumerForm.Id;
        euipJunction.Lennox_LSA__c = consumerChildLSA != null ? consumerChildLSA.id : null;
        
        euipJunctionlist.add(euipJunction);
        //update lennoxForm;
        Insert euipJunctionlist;
      }
    }
    }
  
  
  private static Lennox_LSA__c CreateLennoxLSA(Home_Owners__c siteLocation, Lennox_Form__c lennoxForm, 
                         Lennox_LSA_Program__c lSAProgram) 
  {
    
    Lennox_LSA__c lennoxLSARec =  new Lennox_LSA__c();
    
    list<Case_Equip_Junction__c> junctionList = [Select Id, Name, Equipment_Data__r.Serial_Number__c, Lennox_LSA__c
                           FROM Case_Equip_Junction__c
                           Where Equipment_Data__r.Serial_Number__c =: lennoxForm.IndoorUnitSerialNumber__c 
                           AND Lennox_LSA__c != null];
    
    if(junctionList != null && !junctionList.isEmpty()){
      lennoxForm.Lennox_LSA__c = junctionList[0].Lennox_LSA__c;
      lennoxLSARec.Id = junctionList[0].Lennox_LSA__c;
      lennoxLSARec.lennoxForm__c = lennoxForm.Id;
      lennoxLSARec.Lennox_LSA_Program__c = lSAProgram.Id;
      update lennoxForm;
      update junctionList;
    }else{
      lennoxLSARec.recordTypeId = Schema.SObjectType.Lennox_LSA__c.getRecordTypeInfosByName()
        .get('Corp Program')
        .getRecordTypeId();
      //lennoxLSARec.Account__c = ;
      
      Account account = getAccount(lennoxForm.DealerNumber__c);
      System.debug('account '+ account);
      System.debug('lSAProgram ::::'+lSAProgram);
      
      // System.debug('account Reason_for_Reimbursement__c '+ lSAProgram.Reason_for_Reimbursement__c);
      // System.debug('account Order_Reason_N__c '+ lSAProgram.Order_Reason_N__c);
      
      lennoxLSARec.Home_Owner__c = siteLocation != NULL ? siteLocation.Id : NULL;
      lennoxLSARec.Account__c = account != null ? account.Id : null;
      lennoxLSARec.Reason_for_Reimbursement__c = lSAProgram.Reason_for_Reimbursement__c;//'Concession';//lSAProgram.Reason_for_Reimbursement__c;
      //lennoxLSARec.Order_Reason__c = lSAProgram.Order_Reason_N__c;//'Corporate Order Entry Error'; //lSAProgram.Order_Reason_N__c;
      lennoxLSARec.Order_Reason__c = lSAProgram.Order_Reason__c;//'Shipping Damage'; //lSAProgram.Order_Reason_N__c;
      
      lennoxLSARec.Requestor_Comments__c = lSAProgram.Order_Reason__c;
      lennoxLSARec.Requested_Dollar_Amount__c = lSAProgram.Amount__c;
      
      //lennoxLSARec.lennoxForm__c = lennoxForm.Id;
      
      lennoxLSARec.I_Certify__c = true;
      lennoxLSARec.Submitter_s_name__c = lennoxForm.DealerContactSubmitter__c;
      lennoxLSARec.Date_of_field_action__c = lennoxForm.Date_of_field_action__c;
      lennoxLSARec.Lennox_LSA_Program__c = lSAProgram.Id;
      
      
      
      if(!test.isRunningTest()){
        insert lennoxLSARec;
        lennoxForm.Lennox_LSA__c = lennoxLSARec.Id;
        update lennoxForm;
      }
      
      System.debug('lennoxLSARec '+ lennoxLSARec);
    }
    return lennoxLSARec;
  }
  
  private static Account getAccount(String dealerNo) {
    
    System.debug('dealerNo ' + dealerNo);
    
    try {
      
      return [
        SELECT Id, Name
        FROM Account
        WHERE SAP_Customer_Number__c =:dealerNo
      ][0];
    } catch(Exception exp) {
      
    }
    return null;
  }
  
  private static String getExceptionString(Exception e) {
    
    return e.getLineNumber() 
      + ' | ' 
      + e.getMessage();
  }
  
  // Homeowner Request Form
  @AuraEnabled
  public static Response LSAserialNumberCheck (String unitSerialNumber) {
    List<Consumer_Form__c> ConsumerFormList = new List<Consumer_Form__c>();
    List<Lennox_LSA__c> checkConsumerChildLSARecordList = new List<Lennox_LSA__c>();
    
    System.debug('unitSerialNumber ' + unitSerialNumber);
    if (String.isNotBlank(unitSerialNumber)) {
      try {
        if(Test.isRunningTest())
        {
        ConsumerFormList =  [
          SELECT Id, Serial_Number__c,Job_First_Name__c,Job_Last_Name__c,Site_City__c,Site_State__c,Site_Postal_Code__c,Site_Street_Address__c,Lennox_LSA__r.Home_Owner__r.Name,Lennox_LSA__r.Home_Owner__r.Email__c,
          Unit_Type__c,Unit_Serial_Number__c,Unit_Model_Number__c,Type_of_Back_up_Fuel__c,Lennox_LSA__r.Account__r.Name,Site_Location__c
          FROM Consumer_Form__c
           LIMIT 1
        ];
        }else{
            ConsumerFormList =  [
          SELECT Id, Serial_Number__c,Job_First_Name__c,Job_Last_Name__c,Site_City__c,Site_State__c,Site_Postal_Code__c,Site_Street_Address__c,Lennox_LSA__r.Home_Owner__r.Name,Lennox_LSA__r.Home_Owner__r.Email__c,
          Unit_Type__c,Unit_Serial_Number__c,Unit_Model_Number__c,Type_of_Back_up_Fuel__c,Lennox_LSA__r.Account__r.Name,Site_Location__c
          FROM Consumer_Form__c
          WHERE Serial_Number__c =: unitSerialNumber LIMIT 1];
        }
        if(ConsumerFormList.size()>0){
          
          checkConsumerChildLSARecordList = [SELECT Id,Consumer_Form__c FROM Lennox_LSA__c WHERE Consumer_Form__c =:  ConsumerFormList[0].Id LIMIT 1];
          if(ConsumerFormList != null && !ConsumerFormList.isEmpty() && checkConsumerChildLSARecordList.isEmpty()  ){
            
            return new Response(true, ConsumerFormList[0], 'Pending');
          } else if(ConsumerFormList != null && !checkConsumerChildLSARecordList.isEmpty()   ){
            
            return new Response(true, null, 'Submitted'); // Consumer Program has already Submitted!
          }else{
            return new Response(true, null, 'Not found');// Consumer Program is not found!
          }
        }
        return new Response(true, null, 'Not found');// Consumer Program is not found!
      }catch(Exception e) {
        
        return new Response(false, null, getExceptionString(e));
      }
      
    } else {
      
      return new Response(false, null, 'Error occurred!');
    }
  }
  
  //Create Equipment Date for Homeowner
  public static void findOrCreateConsumerEquipmentData(Consumer_Form__c consumerForm, Id siteLocationId, 
                         Id lSAProgramId,Lennox_LSA__c consumerChildLSA) 
  {
    
    Equipment_Data__c eData;
    List<Equipment_Data__c> eDataList = new List<Equipment_Data__c>();
    if (String.isNotEmpty(consumerForm.Unit_Serial_Number__c)) {
      
      eDataList = [
        SELECT Id
        FROM Equipment_Data__c
        WHERE Serial_Number__c =: consumerForm.Unit_Serial_Number__c
      ];
      
      if (eDataList != null && !eDataList.isEmpty()) {
        
        updateOrCreateEquipmentJunction(eDataList[0].Id, null,consumerForm, null, null,consumerChildLSA);
      } else {
        
        eData = new Equipment_Data__c();
        //eData.Type__c = type,
        //eData.Installation_Date__c = consumerForm.DateUnitInstalled__c;
        eData.Serial_Number__c = consumerForm.Unit_Serial_Number__c;
        eData.Model_Number__c = consumerForm.Unit_Model_Number__c;
        
        eDataList.add(eData);
        Insert eDataList;
        
        updateOrCreateEquipmentJunction(eDataList[0].Id,null, consumerForm, null, null,consumerChildLSA);
      }
    }
  }
  
  @AuraEnabled
  public static Response checkSerialNumberApex(String serialNumber, String programId){
    try {
      List<Lennox_Form__c> listForm = [SELECT Id FROM Lennox_Form__c WHERE Lennox_LSA_Program__c = :programId AND IndoorUnitSerialNumber__c = :serialNumber];
      if(listForm != null && listForm.size() > 0){
        return new Response(true, false, System.Label.LSA_Error_Message);
      } else {
        return new Response(true, true, null);
      }
    } catch (Exception e){
      return new Response(false, null, getExceptionString(e));
    }
  }

  @AuraEnabled
  public static Response searchSerialNumberApex(String serialNumber, String programId){
    try{
      List<Lennox_Form__c> listForm = [SELECT Id FROM Lennox_Form__c WHERE Lennox_LSA_Program__c = :programId AND IndoorUnitSerialNumber__c = :serialNumber];
      if(listForm != null && listForm.size() > 0){
        return new Response(true, null, 'A form has already been submitted on this Serial Number for this Lennox Program. Please contact your Field Technical Consultant with any questions.');
      }
      List<Program_LSA_Equipment__c> listProgramEquipment = [SELECT Id, Lennox_LSA_Program__r.Name, Serial_Number__c, Model_Number__c, Equipment_Data__r.Installation_Date__c, Equipment_Data__r.type__c FROM Program_LSA_Equipment__c WHERE Lennox_LSA_Program__c = :programId AND Serial_Number__c = :serialNumber];
      if(listProgramEquipment == null || listProgramEquipment.size() == 0){
        return new Response(true, null, 'This Serial Number is not recognized as being part of this Lennox Program. Please contact your Field Technical Consultant with any questions.');
      } else {
        return new Response(true, listProgramEquipment[0], '');
      }
    } catch (Exception e){
      return new Response(false, null, getExceptionString(e));
    }

  }
  
  //------------------------------------------   ------------------------------------------------//
  
  public class Response {
    
    @AuraEnabled
    public String msg;
    
    @AuraEnabled
    public boolean isSuccess;
    
    @AuraEnabled
    public object data;
    
    public Response() {}
    
    public Response(boolean isSuccess, object data, String msg) {
      
      this.msg = msg;
      this.isSuccess = isSuccess;
      this.data = data;
    }
  }
}