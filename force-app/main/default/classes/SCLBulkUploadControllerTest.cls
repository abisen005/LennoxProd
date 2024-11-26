@isTest
public with sharing class SCLBulkUploadControllerTest {
    @isTest
    static void testUpload() {
		string goodCsv = 'Plant\tIs your store NEW?(<12 mos OLD)\tType of Request\tReason for Request\tMaterial #\tProduct Division\tMaterial Description\tJan\tFeb\tMar\tApr\tMay\tJun\tJul\tAug\tSep\tOct\tNov\tDec\r\nPlant\tYes\tDo not Stock\tReason 1\tTX101251\tParts & Supplies\tTest Description 1\t4\t\t\t2\t\t4\t1\t\t7\t\t5\t\r\nPlanX\tYes\tDo not Stock\tReason 1\tTX101251\tParts & Supplies\tTest Description 2\t4\t\t\t2\t\t4\t1\t\t7\t\t5\t';
        string errorCsv = 'Plant\tIs your store NEW?(<12 mos OLD)\tType of Request\tReason for Request\tMaterial #\tProduct Division\tMaterial Description\tJan\tFeb\tMar\tApr\tMay\tJun\tJul\tAug\tSep\tOct\tNov\tDec\r\nPlant\tYes\tDo not Stock\tReason 1\tTX101251\tParts & Supplies\tTest Description 1\t4\t\t\t2\t\t4\t1\t\t7\t\t5\t\r\nPlant 101\tSDFDFDF\tDo not Stock\tReason 1\tTX101251\tParts & Supplies\tTest Description 2\t4\t\t\t2\t\t4\t1\t\t7\t\t5\t';
        
        goodCsv = goodCsv.replace('\t', ',');
        errorCsv = errorCsv.replace('\t', ',');

				
        bypassTrigger__c bs = new bypassTrigger__c(Name='SCL', Bypass_triggers__c=false, Primary_Object__c='SupplyChain__c');
        insert bs;

        bs = new bypassTrigger__c(Name='forecast', Bypass_triggers__c=false, Primary_Object__c='SCskus__c');
		insert bs;
        
        Account a = new Account(
            name='Tester',
            SAP_Customer_Number__c='B9999'
        );
        insert a;
         
        SupplyChain__c sc = new SupplyChain__c(
            SupplyPlanners__c='Rebecca Grigg',
            locationdescription__c='x',
            ShortDescriptionofRequest__c='xxx'
        );
        insert sc;        
        
        string base64Data = EncodingUtil.base64Encode(blob.valueOf(goodCsv));
        SCLBulkUploadController.ScSkuResult result = SCLBulkUploadController.uploadFile(sc.Id, null, base64Data, null);
        system.debug('goodCsv');
        system.debug(result);
        system.assert(result!=null);
        
        List<SCskus__c> skus = [
            SELECT
            	recordtypeid,
            	supplychain__c,
            	storea__c,
            	Has_store_opened_in_last_12_months__c,
            	TypeofRequest__c,
        	    reasonforrequest__c,
            	Material__c,
            	Name,
				ProductDivision__c,
            	MaterialDescription__c,
            	jan__c,
            	feb__c,
            	march__c,            
            	apr__c ,   
            	may__c,
            	june__c,
            	july__c,
	           	aug__c,
    	        sept__c,
        	    oct__c,
            	nov__c,
            	dec__c
            FROM SCskus__c
            WHERE supplychain__c=:sc.Id
        ];
        
        for(SCskus__c s : skus) {
            s.Id = null;
        }
        
        result = SCLBulkUploadController.saveRecords(null, skus);
		system.debug('skus');
        system.debug(result);
        system.assert(result!=null);
                
        base64Data = EncodingUtil.base64Encode(blob.valueOf(errorCsv));
        result = SCLBulkUploadController.uploadFile(sc.Id, null, base64Data, null);
        system.debug('errorCsv');
        system.debug(result);
        system.assert(result!=null);
    }}