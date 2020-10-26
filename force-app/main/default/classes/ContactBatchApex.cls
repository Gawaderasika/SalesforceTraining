public class ContactBatchApex implements Database.Batchable<SObject>{
    public Database.QueryLocator start(Database.BatchableContext cnt){
        return Database.getQueryLocator('SELECT id from Contact where name like "%batch%"');
    }
    
    public void execute(Database.BatchableContext cnt, List<Contact> conListFromStartMethod){
        List<Contact> contactUpdate= new List<Contact>();
        for(Contact con: conListFromStartMethod){
            con.lastname = 'James';
            contactUpdate.add(con);
        }
        UPDATE contactUpdate;
    }
    
    public void finish(Database.BatchableContext bc){
        
    }

}