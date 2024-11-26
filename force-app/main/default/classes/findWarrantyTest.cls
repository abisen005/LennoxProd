@istest
public class findWarrantyTest {

    static testmethod void findWarrantyrecordsTest()
    {
    Test.setCurrentPageReference(new PageReference('Page.LineItemsWarranty')); 
    findWarranty war = new findWarranty();
    war.getWarranty();
    }

}