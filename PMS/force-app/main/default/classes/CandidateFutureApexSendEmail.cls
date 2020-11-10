/********************************************************************** 
Name: CandidateFutureApexSendEmail
sendemail
Copyright © 2009 Enzigma Software Pvt Ltd. 
====================================================== 
====================================================== 
Purpose: Send email to candidate with PDF attachement
------- 
====================================================== 
====================================================== 
History 
------- 
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP 
1.0 - Name 25/09/2020 INITIAL DEVELOPMENT 
***********************************************************************/
public class CandidateFutureApexSendEmail {
    
    @future(callout=true)
    public static void SendToCandidate(String cId, String emailId) {
                 
    	//for(Candidate_Rasika__c c: cnd){
            //if(c.Status__c == 'HIRED'){
                
            try{
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       			Messaging.EmailFileAttachment attachPdf = new Messaging.EmailFileAttachment();
       	
       			PageReference pref = page.CandidateDetailPDF;
				pref.getParameters().put('id',cId);
				pref.setRedirect(true);
				Blob b = pref.getContent();
				attachPdf.setFileName('CandidateDetailPDF.pdf');
				attachPdf.setBody(b);
           
       			String[] toAddresses = new String[] {emailId};
       			mail.setToAddresses(toAddresses);
       			mail.setSubject('Regarding Job Offer'); 
       			mail.setPlainTextBody('Congratulation !!!');
        
       			mail.setFileAttachments(new Messaging.EmailFileAttachment[] {attachPdf});
       			Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
       			inspectResults(results);
            }
            catch(Exception ee){}
            //}
    	//}
    }
    private static Boolean inspectResults(Messaging.SendEmailResult[] results) {
       Boolean sendResult = true;
       for (Messaging.SendEmailResult res : results) {
           if (res.isSuccess()) {
               System.debug('Email sent successfully');
           }
           else {
               sendResult = false;
               System.debug('The following errors occurred: ' + res.getErrors());                
           }
       }
       return sendResult;
   }
}