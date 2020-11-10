public class TestDemoContactBatch implements Database.Batchable<SObject>{
	
    public Database.QueryLocator start(Database.BatchableContext bc){
        // 1 million --- 2000 records to execute
        return Database.getQueryLocator('SELECT id, lastname from Contact');	//it will not hit an exception
    }
    
    public void execute(Database.BatchableContext bc, List<Contact> subListFromStartMethod){
        //Logic to process all 2000 records
        for(Contact con: subListFromStartMethod){
            con.lastname = 'Batch updated : '+con.lastname;
        }
        UPDATE subListFromStartMethod;
    }
    
    public void finish(Database.BatchableContext bc){
        //Post process logic
        System.debug('@@ Batch job completed');
    }
}