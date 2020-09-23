public class dynamic_soql_class {
    public String q{set;get;}
    public List<Account> a {set;get;}
    public void search(){
        //List<Account> a = [SELECT Id, Name FROM Account WHERE Name LIKE '%John%'];
        a = Database.query('SELECT Id, Name FROM Account WHERE Name LIKE \'%' + q + '%\'');
    }
}