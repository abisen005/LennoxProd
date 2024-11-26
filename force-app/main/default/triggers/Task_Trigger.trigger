trigger Task_Trigger on Task (before update) {
	
    if(Trigger.isBefore){ 
    
        if(Trigger.isUpdate){
             
        	Task_Trigger_Handler.beforeUpdate(Trigger.New);
    	}
    }
    
}