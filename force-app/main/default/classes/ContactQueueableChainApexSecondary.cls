/********************************************************************** 
Name: ContactQueueableChainApexSecondary
Copyright © 2009 Enzigma Software Pvt Ltd. 
====================================================== 
====================================================== 
Purpose: Queueable apex-chain (Asynchronous Apex)
------- 
====================================================== 
====================================================== 
History 
------- 
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP 
1.0 - Name 25/09/2020 INITIAL DEVELOPMENT 
***********************************************************************/ 
public class ContactQueueableChainApexSecondary implements Queueable{
    public void execute(QueueableContext qCntx){
        //Logic that needs to run in background
        Delete [SELECT Id FROM Contact WHERE contactAddress__c = 'India'];
    }
}