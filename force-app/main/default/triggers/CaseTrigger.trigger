/** ===========================================================================
@Purpose	: This trigger used to change the owner of case.
@Date		: 6 Mar 2019
===========================================================================
ChangeLog : 
=========================================================================== 
 */
trigger CaseTrigger on Case (before update) {

    try{
        
        if(Trigger.isUpdate && Trigger.isbefore){
            
            CaseTriggerHandler.changeCaseOwner(Trigger.newMap);
        }
    }
    catch(Exception ex){
        System.debug('Error in CaseTrigger '+ex.getLineNumber()+' '+ex.getMessage());
        System.debug(ex.getStackTraceString());
    }
}