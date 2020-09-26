public class QueueableScheduleClass implements Schedulable{

    public void execute(SchedulableContext sc){
        System.enqueueJob(new QueueableClassDemo());
    }
}