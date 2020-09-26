public class SendEmail {
    
	
    public static void SendToCandidate(String toAddress) {
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       String[] toAddresses = new String[] {toAddress};
       mail.setToAddresses(toAddresses);
       mail.setSubject('Regarding Job Offer'); 
       mail.setPlainTextBody('Congratulation !!!');
       Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
       inspectResults(results);
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