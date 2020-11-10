public class AngularAssignmentController {
    
    @remoteAction
    public static List<sObject> getRecords(String query){
        return Database.query(query);
    }
    
    @remoteAction
    public static String deleteRecord (String sObjectName, String recordId){
        Delete Database.query('SELECT Id FROM '+sObjectName+' WHERE ID=:recordId');
        return 'Record delted successfully';
    }
	
}