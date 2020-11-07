/************************************************************************************************************************************
Author 		: 	Shahaji Mahakale
Description :   This apex class is used to create composite request for bulk data operation in rest model
History		:
----------------------------------------------------------------------------------------------------------------------------------
VERSION		DATE				AUTHOR					DETAIL
1	 	    7/11/2019		    Shahaji Mahakale       Initial Development
**************************************************************************************************************************************/

public class RecordWrapper {
    public List<object> compositeRequest; 
    Public static List<object> getCompositeRequestData(List<Object> lstRecord, String objectName) {
        List<object> lstObjectRecord = new List<object>();
        for(Object record : lstRecord)
        { 
            Id recordId = null;
            Item item;
            Map<String, Object> mapField = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(record));
            for(String key : mapField.keySet()){
                if(key.toLowerCase() == 'id'){
                    recordId = (Id)mapField.get(key);
                }
            }
            if(recordId == null)
            {
                item = new Item('POST','/services/data/v43.0/sobjects/'+objectName,'pms'+String.valueOf((Math.round(Math.random() * 255)-128) & 255),record);
            }
            else
            {
                Map<String, Object> mapRecord = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(record));
                if(mapRecord.containsKey('Id')){
                    mapRecord.remove('Id');
                }
                else{
                     mapRecord.remove('id');
                }
                item = new Item('PATCH','/services/data/v43.0/sobjects/'+objectName+'/'+recordId,'pms'+String.valueOf((Math.round(Math.random() * 255)-128) & 255),mapRecord);
            }
            lstObjectRecord.add(item);
        }
        return lstObjectRecord;
    }
    class Item{
        public String method;
        public String url;
        public String referenceId;
        public object body;
        Item(String method,String url,String referenceId,object body){
            this.method=method;
            this.url=url;
            this.referenceId=referenceId;
            this.body=body;
        }
    }
}