trigger PanCardTrigger on PAN_Card__c (before insert, before update, after insert, after update) {
    if(Trigger.isBefore && trigger.isInsert){
        for(PAN_card__c p: trigger.new){
            p.Description__c = 'Trigger';
        }
    }
    else if(Trigger.isBefore && trigger.isUpdate){
        for(PAN_card__c p: trigger.new){
            p.Description__c = 'Trigger';
        }
    }
}
//pancardno