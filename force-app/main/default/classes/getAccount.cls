public class getAccount {
    public static void getAllAccounts()
    {
        List<Account> lstAcc=[SELECT Id from Account];
        system.debug(lstAcc);
    }

}