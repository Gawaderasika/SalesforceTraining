public class AccountQueueableChainSecondary implements Schedulable{

    public void execute(SchedulableContext sc){
        System.enqueueJob(new AccountQueueableChainPrimary());
    }
}