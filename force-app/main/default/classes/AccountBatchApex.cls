public class AccountBatchApex implements Database.Batchable<SObject>{
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT id, Name from Account');
    }
    
    public void execute(Database.BatchableContext bc, List<Account> accListFromStartMethod){
        Integer i=1;
        for(Account acc: accListFromStartMethod){
            acc.Name = 'Account-'+ i;
            i = i + 1;
        }
        UPDATE accListFromStartMethod;
    }
    
    public void finish(Database.BatchableContext bc){
        
    }

}