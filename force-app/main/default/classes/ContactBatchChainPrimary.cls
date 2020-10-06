public class ContactBatchChainPrimary implements Database.Batchable<SObject>{
    
    //interface contains to-do list
	
    public Database.QueryLocator start(Database.BatchableContext bc){
        // 1 million --- 2000 records to execute
        // Query all the records to process
        return Database.getQueryLocator('SELECT id, lastname from Contact');	//it will not hit an exception even the query returns 1m records22
    }
    
    public void execute(Database.BatchableContext bc, List<Contact> subListFromStartMethod){
        //Logic to process all 2000 records
        //Process batch of records from start
        for(Contact con: subListFromStartMethod){
            con.lastname = 'Batch updated : '+con.lastname;
        }
        UPDATE subListFromStartMethod;
        //call outs
        //complex logic
        //update - triggers take time to execute
    }
    
    public void finish(Database.BatchableContext bc){
        //Post process logic
        //any post processing logic Eg. Send email, log creations
        System.debug('@@ Batch job completed');
    }
}