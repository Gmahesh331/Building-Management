@istest
public class Test_Contract_Creation 
{
    @testsetup
    public static void Setup()
    {
        Building__c B = new Building__c(Name = 'Test');
        insert B;
        Flat__c F1 = new Flat__c(Building_Name__c = B.id,Flat_Number__c = 102,	Status__c='Vacant');
        insert F1;
        Flat__c F2 = new Flat__c(Building_Name__c = B.id,Flat_Number__c = 103,	Status__c='Vacant');
        insert F2;
        Flat__c F3 = new Flat__c(Building_Name__c = B.id,Flat_Number__c = 104,	Status__c='Occupied');
        insert F3;
        Flat__c F4 = new Flat__c(Building_Name__c = B.id,Flat_Number__c = 105,	Status__c='Pending For Approval');
        insert F4;
    }
    @istest static void Vacant_Flat()
    {
        Flat__c Flat103 = [select id,status__c from Flat__c where Flat_Number__c = 103];
            contract__c con103 = new contract__c();
            con103.Flat_Number__c = Flat103.id;
            insert con103;
        list<contract__c> fetch_con103 = [select id from contract__c];
        system.assertEquals(1, fetch_con103.size());
    }
    @istest static void Occupied_Flat()
    {
        Flat__c Flat104 = [select id,status__c from Flat__c where Flat_Number__c = 104];
            contract__c Con104 = new contract__c();
            Con104.Flat_Number__c = Flat104.id;
            insert Con104;
        list<contract__c> fetch_Con104 = [select id from contract__c];
        system.assertEquals(0, fetch_Con104.size());
    }
    @istest
    public static void StatusUpdate()
    {
        Flat__c F103 = [select id,status__c from Flat__c where Flat_Number__c = 103];
            contract__c c103 = new contract__c();
            c103.Flat_Number__c = F103.id;
        	c103.Status__c = 'New';
        	c103.Start_Date__c = system.today();
            c103.Tenent_Name__c = 'Anil';
            insert c103;
        Contract__c Fetch_c103 = [select id,status__c,Tenent_Name__c from Contract__c where Tenent_Name__c = 'Anil'];
            Fetch_c103.status__c = 'Pending';
        	update Fetch_c103;
        Flat__c PendingFlat = [select id,status__c from Flat__c where Flat_Number__c = 103];
        system.assertEquals('Pending For Approval',PendingFlat.Status__c );
        Contract__c PendingCon = [select id,status__c,Tenent_Name__c from Contract__c where Tenent_Name__c = 'Anil'];
        	PendingCon.status__c = 'Active';
        	update PendingCon;
        Flat__c OccupiedFlat = [select id,status__c from Flat__c where Flat_Number__c = 103];
        system.assertEquals('Occupied',OccupiedFlat.Status__c);
        Contract__c ExpiredCon = [select id,status__c,Tenent_Name__c from Contract__c where Tenent_Name__c = 'Anil'];
        	ExpiredCon.Start_Date__c = date.newInstance(2020, 01, 01);
        	update ExpiredCon;
        Flat__c VacantFlat = [select id,status__c from Flat__c where Flat_Number__c = 103];
        system.assertEquals('Vacant',VacantFlat.Status__c);
    }
    @istest static void Rejected()
    {
        Flat__c Flat103 = [select id,status__c from Flat__c where Flat_Number__c = 102];
        	contract__c newcon = new contract__c();
            newcon.Flat_Number__c = Flat103.id;
        	newcon.Status__c = 'New';
        	newcon.Start_Date__c = system.today();
        	newcon.Tenent_Name__c = 'Chary';
            insert newcon;
        Contract__c pendingCon = [select id,status__c,Tenent_Name__c from Contract__c where Tenent_Name__c = 'Chary'];
            pendingCon.Status__c = 'Pending';
            update pendingCon;
        Contract__c RejectedCon = [select id,status__c,Tenent_Name__c from Contract__c where Tenent_Name__c = 'Chary'];
            RejectedCon.Status__c = 'Rejected';
            update RejectedCon;
        Flat__c Vacant102Flat = [select id,status__c from Flat__c where Flat_Number__c = 102];
        system.assertEquals('Vacant',Vacant102Flat.Status__c );
    }
}