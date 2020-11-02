public class rasikaClass {
    
    @remoteAction
    public static List<sObject> getRecords(String query){
        return Database.query(query);
    }
    //@remoteAction
    //public static List<String> getFunction(String sObjectName){
        /*Map<String, Schema.SObjectField> fieldMap = Opportunity.sObjectType.getDescribe().fields.getMap();
		// Get all of the fields on the object
		Set<String> fieldNames = new Set<String>();
        fieldNames.addAll(fieldMap.keySet());
		// Build a Dynamic Query String.
		List<Opportunity> opps = Database.query('select ' + string.join(fieldNames, ',') + ' from Opportunity');
        */
        /*Map<String, Schema.SObjectField> fieldMap = Opportunity.sObjectType.getDescribe().fields.getMap();
  
		// Get all of the fields on the object
		Set<String> fieldNames = fieldMap.keySet();
 
		// Build a Dynamic Query String.
		List<Opportunity> opps = Database.query('select ' + string.join(fieldNames, ',') + ' from Opportunity');*/

        /*system.debug('Inside class '+sObjectName);
    	List<String> fieldList = new List<String>();
        Map<string,SObjectField> fList = schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap();
        for(string str: fList.keySet()){
			fieldList.add(str);                
        }
        system.debug(fieldList);
        return fieldList;*/
    //}
    @remoteAction
    public static String deleteRecord (String sObjectName, String recordId){
        Delete Database.query('SELECT Id FROM '+sObjectName+' WHERE ID=:recordId');
        return 'Record delted successfully';
    }
}