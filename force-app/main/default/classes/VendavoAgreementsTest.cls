@isTest
public class VendavoAgreementsTest {
    
    public static testMethod String getAgreementsTestJson() {
        String json = '{'+
          '    \"data\": [{'+
          '        \"id\": \"997348648-1734\",'+
          '        \"uri\": \"https://dryvendavo.lennoxintl.com/vendavo/rest/agreement/997348648-1734\",'+
          '        \"type\": \"PriceAgreement\",'+
          '        \"VIsLatestRevision\": true,'+
          '        \"VValidity\": {'+
          '            \"type\": \"VDateRange\",'+
          '            \"to\": \"09/08/2015 23:59:59 -0500\",'+
          '            \"fromDate\": \"09/08/2014 00:00:00 -0500\",'+
          '            \"displayName\": \"\"'+
          '        },'+
          '        \"VVersionNumber\": 16,'+
          '        \"priceInProgress\": false,'+
          '        \"CDQType\": {'+
          '            \"id\": \"1926482585-1006\",'+
          '            \"type\": \"CDQType\",'+
          '            \"VName\": \"AOR\",'+
          '            \"lastModified\": \"09/02/2015 00:35:35 -0500\",'+
          '            \"created\": \"'+ System.now().adddays(-20) +' -0500\",'+
          '            \"VLabel\": \"AOR\",'+
          '            \"displayName\": \"AOR\"'+
          '        },'+
          '        \"GrossMarginP\": {'+
          '            \"type\": \"VPercentage\",'+
          '            \"Amount\": 100.000000000000000,'+
          '            \"displayName\": \"\"'+
          '        },'+
          '        \"SalesGroup\": {'+
          '            \"id\": \"770391271-1256\",'+
          '            \"type\": \"SalesLevel5\",'+
          '            \"VName\": \"393\",'+
          '            \"lastModified\": \"09/04/2015 18:00:20 -0500\",'+
          '            \"created\": \"'+ System.now().adddays(-20) +' -0600\",'+
          '            \"VLabel\": \"393-Joshua Phillips\",'+
          '            \"displayName\": \"393-Joshua Phillips\"'+
          '        },'+
          '        \"flagged\": false,'+
          '        \"VID\": \"PA-00001734-1\",'+
          '        \"PocketMarginP\": {'+
          '            \"type\": \"VPercentage\",'+
          '            \"Amount\": 87.126519048684100,'+
          '            \"displayName\": \"\"'+
          '        },'+
          '        \"CDQRevenue\": {'+
          '            \"type\": \"VMoney\",'+
          '            \"Amount\": 134130.0000000000,'+
          '            \"displayName\": \"134130.0000000000\",'+
          '            \"Currency\": {'+
          '                \"id\": \"1281012036-1000\",'+
          '                \"type\": \"VCurrency\",'+
          '                \"VISOCode\": \"USD\",'+
          '                \"VPrefix\": \"$\",'+
          '                \"VSuffix\": null,'+
          '                \"displayName\": \"USD\"'+
          '            }'+
          '        },'+
          '        \"VWaterfall\": {'+
          '            \"id\": \"1539600609-73087602\",'+
          '            \"type\": \"VWaterfall\",'+
          '            \"CustomerNegotiatedPrice\": {'+
          '                \"type\": \"VMoney\",'+
          '                \"Amount\": 134130.0000000000,'+
          '                \"displayName\": \"134130.0000000000\",'+
          '                \"Currency\": {'+
          '                    \"id\": \"1281012036-1000\",'+
          '                    \"type\": \"VCurrency\",'+
          '                    \"VISOCode\": \"USD\",'+
          '                    \"VPrefix\": \"$\",'+
          '                    \"VSuffix\": null,'+
          '                    \"displayName\": \"USD\"'+
          '                }'+
          '            },'+
          '            \"VInvoicePrice\": {'+
          '                \"type\": \"VMoney\",'+
          '                \"Amount\": 134130.0000000000,'+
          '                \"displayName\": \"134130.0000000000\",'+
          '                \"Currency\": {'+
          '                    \"id\": \"1281012036-1000\",'+
          '                    \"type\": \"VCurrency\",'+
          '                    \"VISOCode\": \"USD\",'+
          '                    \"VPrefix\": \"$\",'+
          '                    \"VSuffix\": null,'+
          '                    \"displayName\": \"USD\"'+
          '                }'+
          '            },'+
          '            \"VariablePocketMargin\": {'+
          '                \"type\": \"VMoney\",'+
          '                \"Amount\": 134130.0000000000,'+
          '                \"displayName\": \"134130.0000000000\",'+
          '                \"Currency\": {'+
          '                    \"id\": \"1281012036-1000\",'+
          '                    \"type\": \"VCurrency\",'+
          '                    \"VISOCode\": \"USD\",'+
          '                    \"VPrefix\": \"$\",'+
          '                    \"VSuffix\": null,'+
          '                    \"displayName\": \"USD\"'+
          '                }'+
          '            },'+
          '            \"displayName\": \"1539600609-73087602\",'+
          '            \"VPocketPrice\": {'+
          '                \"type\": \"VMoney\",'+
          '                \"Amount\": 134130.0000000000,'+
          '                \"displayName\": \"134130.0000000000\",'+
          '                \"Currency\": {'+
          '                    \"id\": \"1281012036-1000\",'+
          '                    \"type\": \"VCurrency\",'+
          '                    \"VISOCode\": \"USD\",'+
          '                    \"VPrefix\": \"$\",'+
          '                    \"VSuffix\": null,'+
          '                    \"displayName\": \"USD\"'+
          '                }'+
          '            }'+
          '        },'+
          '        \"created\": \"'+ System.now().adddays(-20) +' -0500\",'+
          '        \"Builder\": null,'+
          '        \"VNotes\": null,'+
          '        \"VCustomerSalesData\": {'+
          '            \"id\": \"1362880705-36184912\",'+
          '            \"uri\": \"https://dryvendavo.lennoxintl.com/vendavo/rest/customer/1362880705-36184912\",'+
          '            \"type\": \"VCustomerSalesData\",'+
          '            \"lastModified\": \"09/02/2015 23:59:58 -0500\",'+
          '            \"created\": \"'+ System.now().adddays(-20) +' -0500\",'+
          '            \"VLabel\": \"E05212-Brian Hester Heating & A/C Inc\",'+
          '            \"VSalesArea\": {'+
          '                \"id\": \"1189447896-1002\",'+
          '                \"type\": \"VSalesArea\",'+
          '                \"lastModified\": \"09/04/2015 18:00:23 -0500\",'+
          '                \"created\": \"'+ System.now().adddays(-20) +' -0600\",'+
          '                \"VDivision\": {'+
          '                    \"id\": \"218743599-1000\",'+
          '                    \"type\": \"VDivision\",'+
          '                    \"VName\": \"01\",'+
          '                    \"lastModified\": \"12/04/2014 11:27:27 -0600\",'+
          '                    \"created\": \"'+ System.now().adddays(-20) +' -0600\",'+
          '                    \"VLabel\": \"01\",'+
          '                    \"displayName\": \"01\"'+
          '                },'+
          '                \"VSalesOrg\": {'+
          '                    \"id\": \"2021414307-1002\",'+
          '                    \"type\": \"VSalesOrg\",'+
          '                    \"VName\": \"LXUS\",'+
          '                    \"lastModified\": \"09/04/2015 18:00:19 -0500\",'+
          '                    \"created\": \"'+ System.now().adddays(-20) +' -0600\",'+
          '                    \"VLabel\": \"LXUS-Lennox US Sales\",'+
          '                    \"displayName\": \"LXUS-Lennox US Sales\"'+
          '                },'+
          '                \"displayName\": \"LXUS0101\",'+
          '                \"VChannel\": {'+
          '                    \"id\": \"1786561051-1000\",'+
          '                    \"type\": \"VChannel\",'+
          '                    \"VName\": \"01\",'+
          '                    \"lastModified\": \"12/04/2014 11:27:27 -0600\",'+
          '                    \"created\": \"'+ System.now().adddays(-20) +' -0600\",'+
          '                    \"VLabel\": \"01-Sales\",'+
          '                    \"displayName\": \"01-Sales\"'+
          '                }'+
          '            },'+
          '            \"displayName\": \"E05212-Brian Hester Heating & A/C Inc\",'+
          '            \"VCustomer\": {'+
          '                \"id\": \"1392971443-157876\",'+
          '                \"type\": \"VSoldTo\",'+
          '                \"VName\": \"T123456\",'+
          '                \"lastModified\": \"05/05/2015 16:32:55 -0500\",'+
          '                \"created\": \"'+ System.now().adddays(-20) +' -0600\",'+
          '                \"address\": {'+
          '                    \"type\": \"VAddress\",'+
          '                    \"Notes\": null,'+
          '                    \"Street\": null,'+
          '                    \"Phone\": null,'+
          '                    \"State\": null,'+
          '                    \"Email\": null,'+
          '                    \"Fax\": null,'+
          '                    \"Zip\": null,'+
          '                    \"displayName\": \"\",'+
          '                    \"Country\": null,'+
          '                    \"City\": null'+
          '                },'+
          '                \"VLabel\": \"E05212-Brian Hester Heating & A/C Inc\",'+
          '                \"displayName\": \"E05212-Brian Hester Heating & A/C Inc\"'+
          '            }'+
          '        },'+
          '        \"SupportedPrice\": {'+
          '            \"type\": \"VMoney\",'+
          '            \"Amount\": 134130.0000000000,'+
          '            \"displayName\": \"134130.0000000000\",'+
          '            \"Currency\": {'+
          '                \"id\": \"1281012036-1000\",'+
          '                \"type\": \"VCurrency\",'+
          '                \"VISOCode\": \"USD\",'+
          '                \"VPrefix\": \"$\",'+
          '                \"VSuffix\": null,'+
          '                \"displayName\": \"USD\"'+
          '            }'+
          '        },'+
          '        \"CurrentApprover\": null,'+
          '        \"VScore\": 0,'+
          '        \"SalesOffice\": {'+
          '            \"id\": \"193026344-1093\",'+
          '            \"type\": \"Sales_Office\",'+
          '            \"VName\": \"U474\",'+
          '            \"lastModified\": \"09/04/2015 18:00:20 -0500\",'+
          '            \"created\": \"'+ System.now().adddays(-20) +' -0600\",'+
          '            \"VLabel\": \"U474-Des Moines\",'+
          '            \"displayName\": \"U474-Des Moines\"'+
          '        },'+
          '        \"Impact\": {'+
          '            \"type\": \"VMoney\",'+
          '            \"Amount\": -3707.0505660620,'+
          '            \"displayName\": \"-3707.0505660620\",'+
          '            \"Currency\": {'+
          '                \"id\": \"1281012036-1000\",'+
          '                \"type\": \"VCurrency\",'+
          '                \"VISOCode\": \"USD\",'+
          '                \"VPrefix\": \"$\",'+
          '                \"VSuffix\": null,'+
          '                \"displayName\": \"USD\"'+
          '            }'+
          '        },'+
          '        \"Description\": null,'+
          '        \"MarketSegment\": null,'+
          '        \"lastModified\": \"09/02/2015 08:40:36 -0500\",'+
          '        \"VCRM\": {'+
          '            \"id\": \"407999561-39102\",'+
          '            \"type\": \"VCRM\",'+
          '            \"VCRMID\": null,'+
          '            \"displayName\": \"407999561-39102\",'+
          '            \"VCRMName\": null'+
          '        },'+
          '        \"ProjectNumber\": \"PL47439305\",'+
          '        \"SFDCOppty\": null,'+
          '        \"VWorkflowOwner\": {'+
          '            \"id\": \"SXD04\",'+
          '            \"uri\": \"https://dryvendavo.lennoxintl.com/vendavo/rest/user/SXD04\",'+
          '            \"type\": \"VUser\",'+
          '            \"VName\": \"SXD04\",'+
          '            \"lastModified\": \"09/02/2015 12:31:30 -0500\",'+
          '            \"created\": \"'+ System.now().adddays(-20) +' -0600\",'+
          '            \"VFullName\": \"Stephanie Dong\",'+
          '            \"VLabel\": null,'+
          '            \"VEmail\": \"matt.mears@lennoxint.com\",'+
          '            \"displayName\": \"Stephanie Dong\"'+
          '        },'+
          '        \"VState\": {'+
          '            \"id\": \"538493065-1038\",'+
          '            \"type\": \"VApprovableState\",'+
          '            \"VName\": \"approved\",'+
          '            \"lastModified\": \"12/04/2014 11:27:15 -0600\",'+
          '            \"created\": \"'+ System.now().adddays(-20) +' -0600\",'+
          '            \"VLabel\": \"Approved\",'+
          '            \"VOrder\": 0,'+
          '            \"displayName\": \"Approved\"'+
          '        },'+
          '        \"displayName\": \"PA-00001734-1\",'+
          '        \"_links\": {'+
          '            \"flag\": \"https://dryvendavo.lennoxintl.com/vendavo/rest/agreement/997348648-1734/flag\"'+
          '        },'+
          '        \"_rights\": {'+
          '            \"edit\": false,'+
          '            \"delete\": false'+
          '        },'+
          '        \"_limits\": {'+
          '            \"VScore\": [0.0, 85.0, 92.0, 100.0]'+
          '        }'+
          '    }],'+
          '    \"_rights\": {'+
          '        \"create\": true'+
          '    },'+
          '    \"_paging\": {'+
          '        \"page\": 1,'+
          '        \"perPage\": 20,'+
          '        \"totalCount\": 20'+
          '    }'+
          '}';
        System.debug('json '+json);
        return json;
    }
    
    static testMethod void testCopyAgreement() {
        
        Test.startTest();
        Vendavo__Deal__c deal = new Vendavo__Deal__c(Name = 'test',  Vendavo__VID__c = '1234');
        insert deal;
        VendavoLandingPageController.copyAgreement(deal.Id);
        Test.stopTest();
        
        
    }
    
    // CRON expression: midnight on March 15.
    // Because this is a test, job executes
    // immediately after Test.stopTest().
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    
    
    static testmethod void testScheduledJob() {
        
        Account acc = new Account(Name = 'Test Account', SAP_Customer_Number__c = 'T123456');
        insert acc;
        
        Test.startTest();
        
        // Schedule the test job
        String jobId = System.schedule('ScheduleApexClassTest',
                                       CRON_EXP, 
                                       new VendavoAgreementsScheduler());
        
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
                          NextFireTime
                          FROM CronTrigger WHERE id = :jobId];
        
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, ct.CronExpression);
        
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        
        // Verify the next time the job will run
        System.assertEquals('2022-03-15 00:00:00', String.valueOf(ct.NextFireTime));
        // Verify the scheduled job hasn't run yet.
        Integer dealCount = [SELECT Count() FROM Vendavo__Deal__c WHERE Vendavo__VSoldTo__r.SAP_Customer_Number__c = 'T123456'];
        System.assertEquals(dealCount,0);
        Test.stopTest();
        
    }
    
    
    
    
    static testmethod void testVendavoDealTrigger() {
        
        Test.startTest();
        Account acc = new Account(Name = 'Test Account', SAP_Customer_Number__c = 'T123456');
        insert acc;
        
        Account_Planning__c accPlan = new  Account_Planning__c(Name = 'test', Account_Plan_Year__c = String.valueOf(System.Today().year()), Dealer__c = acc.Id);
        insert accPlan;
        
        Account_Opportunty__c accountOpp = new Account_Opportunty__c();
        accountOpp.Dealer_Account_Plan__c = accPlan.Id;
        accountOpp.Opportunity_Type__c = 'CDQ Request';
        accountOpp.Opportunity_Status__c = 'In Progress';
        accountOpp.isApproved__c = TRUE;
        insert accountOpp;
        
        Vendavo__Deal__c deal = new Vendavo__Deal__c(Name = 'test',  Vendavo__VSoldTo__c = acc.Id);
        insert deal;
        
        deal.Vendavo__Status__c = 'approved';
        update deal;
        Test.stopTest();
        
    }
    
    static testmethod void testVendavoAgreementsSync() {
        User user = [SELECT Id, VendavoUID__c, Vendavo__VendavoID__c from user where Id =:UserInfo.getUserId()];
        user.VendavoUID__c = 'test';
        user.Vendavo__VendavoID__c = 'test';
        Update user;
        Account acc = new Account(Name = 'Test Account', SAP_Customer_Number__c = 'T123456');
        insert acc;
        Vendavo__Deal__c deal = new Vendavo__Deal__c(Name = 'test',  Vendavo__VSoldTo__c = acc.Id);
        insert deal;
        Vendavo_API_Credentials__c vendavoSettings = new Vendavo_API_Credentials__c(); 
        vendavoSettings.Agreement_Callout__c = 1;
        vendavoSettings.Created_Date_Cutoff__c = 30;
        Insert vendavoSettings;
        
        Test.StartTest();
        VendavoAgreementsSync.syncAgreements(1);
        Test.StopTest();
    }
}