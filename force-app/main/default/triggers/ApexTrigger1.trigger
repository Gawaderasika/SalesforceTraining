trigger ApexTrigger1 on Job_Rasika__c (before insert,before update, before delete, after insert,after update, after delete, after undelete) {
    if(Trigger.isBefore ){
        if(Trigger.isInsert){
            helper1.fun1(Trigger.new);
        }
        else if(Trigger.isUpdate){
            helper1.fun2(Trigger.new);
        }
        else if(Trigger.isUpdate){
            helper1.fun3(Trigger.old);
        }
        else if(Trigger.isDelete){
            helper1.fun4(Trigger.old);
        }
    }
    else if(Trigger.isAfter){
        if(Trigger.isInsert){
            helper1.fun5(Trigger.new);
        }
        else if(Trigger.isUpdate){
            helper1.fun6(Trigger.new);
        }
        else if(Trigger.isUndelete){
            helper1.fun7(Trigger.new);
        }
        else if(Trigger.isUpdate){
            helper1.fun8(Trigger.old);
        }
        else if(Trigger.isDelete){
            helper1.fun9(Trigger.old);
        }
    }
}