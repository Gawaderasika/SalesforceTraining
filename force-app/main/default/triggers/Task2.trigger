trigger Task2 on Job_Rasika__c (before delete, after delete) {
    if(Trigger.isBefore){
        if(Trigger.isDelete){
            for(Job_Rasika__c obj1: Trigger.old){
                if(obj1.Active__c == True){
                    obj1.addError('Trigger error: This Job is active and can not be deleted');
                }
            }
        }       
    }
    else if(Trigger.isAfter){
        if(Trigger.isInsert){
            for(Job_Rasika__c obj2: Trigger.new){
                if(obj2.Number_of_Positions__c == obj2.Hired_Applicants__c){
                    obj2.Active__c = False;
                    
                }
            }
        }
        else if(Trigger.isUpdate){
            for(Job_Rasika__c obj3: Trigger.new){
                if(obj3.Number_of_Positions__c > obj3.Hired_Applicants__c){
                    if(obj3.Active__c == False){
                        obj3.Active__c = True;
                    }
                }
            }
        }
    }
}