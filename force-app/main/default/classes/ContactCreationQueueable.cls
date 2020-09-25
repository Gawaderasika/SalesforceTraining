/********************************************************************** 
Name: ContactCreationQueueable
Copyright © 2009 Enzigma Software Pvt Ltd. 
====================================================== 
====================================================== 
Purpose: Queueable apex (Asynchronous Apex)
------- 
====================================================== 
====================================================== 
History 
------- 
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP 
1.0 - Name 25/09/2020 INITIAL DEVELOPMENT 
***********************************************************************/ 
public class ContactCreationQueueable implements Queueable{
    public List<Account> accListToCreateContacts;
    
    public ContactCreationQueueable(List<Account> expectingAccountsFROMTrigger){
        this.accListToCreateContacts = expectingAccountsFROMTrigger;
    }
    public void execute(QueueableContext qCont){
        List<Contact> conListToCreate = new List<Contact>();
        
        for(Account acc: accListToCreateContacts){
            Contact con = new Contact();
            con.lastname = acc.Name;
            con.AccountId = acc.Id;
            conListToCreate.add(con);
        }
        if(conListToCreate.size()>0)
            INSERT conListToCreate;
        
    }
}