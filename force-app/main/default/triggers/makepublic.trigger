trigger makepublic on EmailMessage (before Insert) {
for(EmailMessage oe:trigger.new){
oe.IsExternallyVisible=true;
}

}