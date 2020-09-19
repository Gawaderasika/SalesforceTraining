trigger ApexTrigger2 on Candidate_Rasika__c (before insert,before update, before delete, after insert,after update, after delete, after undelete) {
    if(Trigger.isBefore ){
        if(Trigger.isInsert){
            helper2.fun1(Trigger.new);
        }
        else if(Trigger.isUpdate){
            helper2.fun2(Trigger.new);
        }
        else if(Trigger.isUpdate){
            helper2.fun3(Trigger.old);
        }
        else if(Trigger.isDelete){
            helper2.fun4(Trigger.old);
        }
    }
    else if(Trigger.isAfter){
        if(Trigger.isInsert){
            helper2.fun5(Trigger.new);
        }
        else if(Trigger.isUpdate){
            helper2.fun6(Trigger.new);
        }
        else if(Trigger.isUndelete){
            helper2.fun7(Trigger.new);
        }
        else if(Trigger.isUpdate){
            helper2.fun8(Trigger.old);
        }
        else if(Trigger.isDelete){
            helper2.fun9(Trigger.old);
        }
    }
}