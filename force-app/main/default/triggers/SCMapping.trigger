trigger SCMapping on SupplyChain__c(before insert, before update) {

bypasstrigger__c settings=bypasstrigger__c.getInstance('SCL');
String ObjectPrimary=settings.primary_object__c;
Boolean bypass_triggers=settings.bypass_triggers__c;


if(bypass_triggers !=true){
    
    //Trigger to insert  correct SC personnel
boolean executeTrigger = false;
        
        
    for (SupplyChain__c sc:  Trigger.new){
    
    
    
  if(sc.bypass_triggers__c != true){
  
    if(sc.status__c!='Closed'){
    
       if((trigger.isinsert) || (trigger.isupdate)){   
   
    if(checkRecursive.runOnce() ) 
            executeTrigger  = true;
    } else {
        executeTrigger  = true;}
        

      

     

   if (sc.SCLRerouteto__c=='Commercial'){
     sc.manager__c='005C000000Aa7JRIAZ'; }
  else{
     
 Map<ID,Schema.RecordTypeInfo> r_Map = SupplyChain__c.sObjectType.getDescribe().getRecordTypeInfosById();
        if((r_map.get(sc.recordTypeID).getName().containsIgnoreCase('Network'))){  
      sc.routeto__c= 'Process Improvement Team';}
else{
If(sc.RequesterDistrict__c==null && sc.routeto__c==null && sc.network_request__c==false){

      sc.routeto__c= 'Deployment Planner';}
      }} 
   if(sc.SCLReroute__c!=null){
                  User[] u54=[select email, name, id from user where name =:sc.SCLReroute__c];
                    if(u54.size()> 0)
                    sc.routedtoemail__c=u54[0].email;
                    
}
    
     
     else{
     
    Map<ID,Schema.RecordTypeInfo> rt_Map = SupplyChain__c.sObjectType.getDescribe().getRecordTypeInfosById();
    
    if((sc.islpp__c ==true) &&((rt_map.get(sc.recordTypeID).getName().containsIgnoreCase('Increase')))|| ((rt_map.get(sc.recordTypeID).getName().containsIgnoreCase('Forecast')))){  
    sc.ShortDescriptionofRequest__c='Forecast Request';
    sc.routeto__c='Inventory Optimization';
    sc.bypass_triggers__c=true;
    }

      
     
      
      
      

        SupplyChainMapping__c[] r=[select deploymentplanner__c, DeploymentPlanningMgr__c, TransportationMgr__c, DemandPlannerMgr__c, transportation__c,demandplanner__c from SupplyChainMapping__c where DistCode__c=:sc.RequesterDistrict__c];
  
 //  SupplyChainMapping__c[] w=[select LifeCyclePlanningMgr__c from SupplyChainMapping__c where LifeCyclePlanning__c=:sc.LifeCyclePlanning__c LIMIT 1];
 //  SupplyChainMapping__c[] y=[select SupplyPlannerMgr__c from SupplyChainMapping__c where SupplyPlanners__c=:sc.SupplyPlanners__c LIMIT 1];
  
  //track shipment
  
       
   if(sc.SCLReroute__c!=null){
                  User[] u3=[select email, name, id from user where name =:sc.SCLReroute__c];
                    if(u3.size()> 0)
                    sc.routedtoemail__c=u3[0].email;
                    }
  
  else{
           if((rt_map.get(sc.recordTypeID).getName().containsIgnoreCase('Tracking')) || (rt_map.get(sc.recordTypeID).getName().containsIgnoreCase('Transportation'))){ 
           
           if  ((sc.transportation__c=='Where’s my shipment?') && (sc.trackingfrom__c=='LDC' || sc.trackingfrom__c=='RDC')){
  

          if(r.size()>0){
            if(r[0].transportation__c!=null){
                User[] u5=[select id, email, name from user where id=:r[0].transportation__c LIMIT 1];
                if(u5.size()> 0)
                    sc.routeto11__c=u5[0].id;
             
             }
                    if(r[0].TransportationMgr__c!=null){
                User[] u11=[select id, email, name from user where id=:r[0].TransportationMgr__c LIMIT 1];
                if(u11.size()> 0)
                    sc.manager__c=u11[0].id;
             
             }     
             
             
             
             
             }
             }
             
             if ((sc.transportation__c=='Where’s my shipment?') && (sc.trackingfrom__c!='LDC' || sc.trackingfrom__c!='RDC')){
             sc.routeto__c= 'Supply Planner';

}




if((sc.transportation__c!='Freight Claim Question') && (sc.transportation__c!='Where’s my shipment?') && (r.size()>0)){
            if(r[0].transportation__c!=null){
                User[] u4=[select id, name from user where id=:r[0].transportation__c LIMIT 1];
                if(u4.size()> 0)
                    sc.routeto11__c=u4[0].id;
             
             }
             
                            if(r[0].TransportationMgr__c!=null){
                User[] u12=[select id, email, name from user where id=:r[0].TransportationMgr__c LIMIT 1];
                if(u12.size()> 0)
                    sc.manager__c=u12[0].id;     
             
             
             
             
            } 
             
             
             }
}


               
//product increase
        
  if(rt_map.get(sc.recordTypeID).getName().containsIgnoreCase('Increase') && (sc.islpp__c!=true)){ 
    
          if(r.size()>0){
            if(r[0].demandplanner__c!=null){
                User[] u3=[select id, name from user where id=:r[0].demandplanner__c LIMIT 1];
                if(u3.size()> 0)
                    sc.routeto11__c=u3[0].id;
             
             }
             
                                          if(r[0].DemandPlannerMgr__c!=null){
                User[] u15=[select id, name from user where id=:r[0].DemandPlannerMgr__c LIMIT 1];
                if(u15.size()> 0)
                    sc.manager__c=u15[0].id;
                

             
             }      
             
             
             
             
             
             
             }
  
}
                          //other
        
  if(rt_map.get(sc.recordTypeID).getName().containsIgnoreCase('Other')){ 

                           if(r.size()>0){
            if(r[0].deploymentplanner__c!=null){
                User[] u2=[select id, name from user where id=:r[0].deploymentplanner__c LIMIT 1];
                if(u2.size()> 0)
                    sc.routeto11__c=u2[0].id;
                

             
             }
             
                               if(r[0].DeploymentPlanningMgr__c!=null){
                User[] u14=[select id, name from user where id=:r[0].DeploymentPlanningMgr__c LIMIT 1];
                if(u14.size()> 0)
                    sc.manager__c=u14[0].id;
                

             
             }      
             
             
             
             
             
             }}

    
   
   
                 //product shortage.  supply planning
        
  if(rt_map.get(sc.recordTypeID).getName().containsIgnoreCase('Shortage')){ 

             
  
             
              if(r.size()>0){
            if(r[0].deploymentplanner__c!=null){
                User[] u1=[select id, name from user where id=:r[0].deploymentplanner__c LIMIT 1];
                if(u1.size()> 0)
                    sc.routeto11__c=u1[0].id;
                

             
             }
             
                    if(r[0].DeploymentPlanningMgr__c!=null){
                User[] u13=[select id, name from user where id=:r[0].DeploymentPlanningMgr__c LIMIT 1];
                if(u13.size()> 0)
                    sc.manager__c=u13[0].id;
                

             
             }     
             
             
             
             
             
             }
             
             
  
             
   }
    
   //product substitution.  product life cycle 
         
  if((rt_map.get(sc.recordTypeID).getName().containsIgnoreCase('PIPO')) || (rt_map.get(sc.recordTypeID).getName().containsIgnoreCase('Phase'))){ 
    

             sc.routeto__c='Product Life Cycle';    
             } 
             




                    
                                if(sc.LifeCyclePlanning__c!=null){
                User[] u42=[select email, name, id from user where name =:sc.LifeCyclePlanning__c];
                if(u42.size()> 0)
                    sc.routedtoemail__c=u42[0].email;
                    
 //                              if(w[0].LifeCyclePlanningMgr__c!=null){
 //               User[] u71=[select id, email, name from user where id=:w[0].LifeCyclePlanningMgr__c LIMIT 1];
 //               if(u71.size()> 0)
 //                   sc.manager__c=u71[0].id;  
                    
    //                }
                    
                    }
                    
               if(sc.SupplyPlanners__c!=null){
                User[] u24=[select email, name, id from user where name =:sc.SupplyPlanners__c];
                if(u24.size()> 0)
                    sc.routedtoemail__c=u24[0].email;
                    
 //              if(y[0].SupplyPlannerMgr__c!=null){
  //              User[] u72=[select id, email, name from user where id=:y[0].SupplyPlannerMgr__c LIMIT 1];
  //              if(u72.size()> 0)
 //                   sc.manager__c=u72[0].id;     
                    
  //                  }
                    
                    }

    
            if(sc.routeto11__c!=null){
                User[] u22=[select email, name, id from user where id =:sc.Routeto11__c];
                if(u22.size()> 0)
                    sc.routedtoemail__c=u22[0].email;
                    
}
}
            
//}

}
}}}}}