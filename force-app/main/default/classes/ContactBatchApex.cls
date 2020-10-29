public class ContactBatchApex implements Database.Batchable<SObject>{
    public Database.QueryLocator start(Database.BatchableContext cnt){
        return Database.getQueryLocator('SELECT id from Contact where name like "%batch"%');
    }
    
    public void execute(Database.BatchableContext cnt, List<Contact> conListFromStartMethod){
        for(Contact con: conListFromStartMethod){
            con.AssistantPhone = '1234567890';
        }
        UPDATE conListFromStartMethod;
    }
    
    public void finish(Database.BatchableContext bc){
        
    }

}