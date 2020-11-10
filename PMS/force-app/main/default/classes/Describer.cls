public class Describer
{
    public map<string, string> getFieldList(){
        map<string, string> fieldList = new map<string, string>();
            map<string,SObjectField> fList = schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap();
            for(string str: fList.keySet()){
				fieldList.put(str, fList.get(str).getDescribe().getLabel());                
            }
        return fieldList;
    }
}