public class jsRemotingControllerv1 {
//take object from jsRemoting and create account
    @RemoteAction
    public static void createAccount(Account a) {
        try {
            Database.SaveResult sr = Database.insert(a);
        } catch(DmlException e) {
 
                system.debug(e.getmessage());
        }
    }
    @RemoteAction
    public static void createContact(Contact c) {
        try {
            Database.SaveResult sr = Database.insert(c);
        } catch(DmlException e) {
 			system.debug(e.getmessage());
        }
    }
}