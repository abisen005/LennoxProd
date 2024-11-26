public with sharing class SiteLocationSearch {


  private String soql {get;set;}
  
  public List<home_owners__c> Sites {get;set;}



 
  public String sortDir {
    get  { if (sortDir == null) {  sortDir = 'desc'; } return sortDir;  }
    set;
  }

  
  public String sortField {
    get  { if (sortField == null) {sortField = 'name'; } return sortField;  }
    set;
  }

 
  public String debugSoql {
    get { return soql + ' order by ' + sortField + ' ' + sortDir + ' limit 30'; }
    set;
  }

  
  public SiteLocationSearch() {
  



    soql = 'select address__c, name,email__c,  lastname__c,firstname__c, phone__c from Home_owners__c where CreatedDate = LAST_N_DAYS:30';
runQuery();  



}



  
  public void toggleSort() {
    
    sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
    
    runQuery();
  }


  public void runQuery() {

    try {
       sites = Database.query(soql + ' order by ' + sortField + ' ' + sortDir + ' limit 30');
    } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'));
    }

  }

 
  public PageReference runSearch() {



    String address = Apexpages.currentPage().getParameters().get('address');
    String email= Apexpages.currentPage().getParameters().get('email');
    String phone= Apexpages.currentPage().getParameters().get('phone');
    String name= Apexpages.currentPage().getParameters().get('name');
    String contact= Apexpages.currentPage().getParameters().get('contact');


    soql = 'select name, all_names__c,all_phones__c,all_email__c, address__c, email__c, firstname__c, lastname__c,  phone__c from Home_owners__c where name !=null';
    



       
     if (!address.equals(''))
       soql +=' and address__c LIKE \'%'  +String.escapeSingleQuotes(address)+'%\'';

    if (!email.equals(''))
       soql +=' and all_email__c LIKE \'%' +String.escapeSingleQuotes(email)+'%\'';
       
    if (!phone.equals(''))
      soql += ' and all_phones__c LIKE  \'%'+String.escapeSingleQuotes(phone)+'%\'';  

     if (!name.equals(''))
       soql +=' and name LIKE \'%'  +String.escapeSingleQuotes(name)+'%\'';
       
      if (!contact.equals(''))
       soql +=' and all_names__c LIKE \'%' +String.escapeSingleQuotes(contact)+'%\'';
       

 
    // run the query again
    runQuery();

    return null;
  }


}