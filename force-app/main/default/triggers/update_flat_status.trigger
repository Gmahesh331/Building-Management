trigger update_flat_status on contract__c (before insert,After update) 
{
    if(trigger.isinsert && trigger.isbefore)
    {
        HelperClass_Contract.ValidationForContractCreation(Trigger.new);
    }
    if(trigger.isupdate && trigger.isafter)
    {
        HelperClass_Contract.StatusUpdate(Trigger.newMap,Trigger.oldMap);
    }
}