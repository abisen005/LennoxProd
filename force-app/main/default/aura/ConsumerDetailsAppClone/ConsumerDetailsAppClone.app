<!--<aura:application extends="force:slds">
    <c:ConsumersDetails/>
</aura:application> -->


<aura:application access="GLOBAL" extends="ltng:outApp" 
    implements="ltng:allowGuestAccess"> 
    
    <aura:dependency resource="c:ConsumersDetails"/>
    <aura:dependency resource="c:SidePanelComponent"/>
    <aura:dependency resource="c:ConfirmationPage"/>
    
</aura:application>