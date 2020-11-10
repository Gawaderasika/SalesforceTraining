public class AccountQueueableChainPrimary implements Queueable{
	
    public void execute(QueueableContext qc){
        //write any logic to run asynchrounously
        List<Account> accListFromStartMethod = [SELECT id from Account];
        for(Account acc: accListFromStartMethod){
            acc.Name = 'Batch Update: ' + acc.Name;
        }
        UPDATE accListFromStartMethod;
    }
}