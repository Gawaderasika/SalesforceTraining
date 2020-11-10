public class AccountBatchChainSecondary implements Database.Batchable<SObject>{
	
    public Database.QueryLocator start(Database.BatchableContext bc){
        // 1 million --- 2000 records to execute
        return Database.getQueryLocator('SELECT id, Name from Account');	//it will not hit an exception
    }
    
    public void execute(Database.BatchableContext bc, List<Account> subListFromStartMethod){
        //Logic to process all 2000 records
        for(Account acc: subListFromStartMethod){
            acc.Name = acc.Name+' Batch';
        }
        UPDATE subListFromStartMethod;
    }
    
    public void finish(Database.BatchableContext bc){
        //Post process logic
        System.debug('@@ Batch job completed');
        Database.executeBatch(new ContactBatchChainPrimary(), 25 );
    }
}