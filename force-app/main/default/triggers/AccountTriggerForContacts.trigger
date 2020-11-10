trigger AccountTriggerForContacts on Account (after insert) {
    if(Trigger.isAfter && Trigger.isInsert){
        System.enqueueJob(new ContactCreationqueueable(Trigger.new)); //Trigger.new has list of accounts that are created
    }
}