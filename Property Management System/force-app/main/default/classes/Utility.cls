public class Utility {
    
    public static Map<String,Id> getActiveRecordTypesByDevName(sObject record) {
        Map<String, Id> mapRecordTypes = new Map<String,Id>();
        for(Schema.RecordTypeInfo recordType : record.getsObjectType().getDescribe().getRecordTypeInfos()) {
            if(recordType.active){
                mapRecordTypes.put( recordType.getDeveloperName(), recordType.getRecordTypeId());
            }
        }
        return mapRecordTypes;
    }
  
    
}