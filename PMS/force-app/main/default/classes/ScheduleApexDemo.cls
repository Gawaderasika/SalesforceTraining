public class ScheduleApexDemo implements Schedulable{
    public void execute(SchedulableContext sc){
        //Any code written in this method can be schedule
        /*List<Account> accs = [SELECT id, name FROM Account WHERE CREATEDDATE = Today];
        for(Account acc: accs){
            acc.name = 'Created today: ' + acc.Name;
        }
        UPDATE accs;*/
        
        Database.executeBatch(new TestScheduleBatch());
    }

}