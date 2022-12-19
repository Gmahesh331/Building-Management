public class HelperClass_Contract 
{
	Public Static Void ValidationForContractCreation(list<contract__c> NewContract)
    {
        list<Flat__c> AllFlatsRec = [select id,status__c from Flat__c];
        for(contract__c EachRec : NewContract)
        {
            for(Flat__c EachFlat : AllFlatsRec)
            {
                if(EachFlat.Status__c != 'Vacant' && EachRec.Flat_Number__c == EachFlat.Id)
                {
                    EachRec.adderror('Sorry! This Flat Is not Vacant');
                }
            }
        }
    }
    Public static void StatusUpdate(Map<id,Contract__c> NewMap, Map<id,Contract__c> OldMap)
    {
        map<id,Contract__c> DumpMap = new map<id,Contract__c>();
        for(Contract__c NewCon : NewMap.values())
        {
            contract__c OldCon = OldMap.get(NewCon.id);
            if((NewCon.status__c == 'Pending' && OldCon.Status__C == 'New') || (OldCon.Status__C == 'Pending' && NewCon.status__c == 'Active') || (NewCon.Status__C == 'Rejected' && OldCon.status__c == 'Pending') || (NewCon.Status__C == 'Expired' && OldCon.status__c == 'Active'))
            {
                DumpMap.put(NewCon.Flat_Number__c,NewCon);
            }
        }
        if(DumpMap.size() > 0)
        {
            list<flat__c> Flt = [select id,status__c,(select id,status__c,End_Date__c from contracts__r where id in:NewMap.keyset()) from flat__c where id in:DumpMap.keyset()];
            for(flat__c EachFlt : Flt)
            {
                for(contract__c RelCon:EachFlt.contracts__r)
                {
                    if(RelCon.Status__c == 'Pending')
                    {
                        EachFlt.Status__c = 'Pending For Approval';
                    }
                    if(RelCon.Status__c == 'Active')
                    {
                        EachFlt.Status__c = 'Occupied';
                    }
                    if(RelCon.Status__c == 'Rejected')
                    {
                        EachFlt.Status__c = 'Vacant';
                    }
                    if(RelCon.Status__c == 'Expired')
                    {
                        EachFlt.Status__c = 'Vacant';
                    }
                }
            }
                        Update Flt;	
        }
		
    }
}