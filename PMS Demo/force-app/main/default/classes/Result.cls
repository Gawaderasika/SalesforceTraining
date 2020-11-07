/************************************************************************************************************************************
Author 		: 	Shahaji Mahakale
Description :   
History		:
----------------------------------------------------------------------------------------------------------------------------------
VERSION		DATE				AUTHOR					DETAIL
1	 	    08/09/2019		    Shahaji Mahakale       Initial Development
**************************************************************************************************************************************/
public class Result {
    @AuraEnabled
    public Boolean success;
    @AuraEnabled
    public Object data;
    @AuraEnabled
    public List<Id> lstIds;
    @AuraEnabled
    public String message;
    public Result(Object data){
        this.success = true;
        this.data = data;
    }
    public Result(List<SObject> records){
        this.success = true;
        this.data = records;
    }
    public Result(Exception ex){
        this.success = false;
        this.message = ex.getMessage();
        List<String> errorStr =new List<String>();
        errorStr = this.message.split (',');
        if(errorStr.size() > 1){
            this.message = errorStr[errorStr.size() - 1];
        }
        this.message =  this.message.replace('[','');
        this.message =  this.message.replace(']','');
        this.message =  this.message.replace(':','');
    }
    public Result(Boolean success){
        this.success=success;
    }
}