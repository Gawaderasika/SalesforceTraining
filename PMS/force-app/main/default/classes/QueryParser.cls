/************************************************************************************************************************************
Author 		: 	Shahaji Mahakale
Description :   This class is used to create the query string dynamically.
History		:
-------------------------------------------------------------------------------------------------------------------------------------
VERSION		DATE				AUTHOR					DETAIL
1	 	    23/10/2019		  Shahaji Mahakale       Initial Development
**************************************************************************************************************************************/
public class QueryParser {
    public static String parse(ModelWrapper query, Boolean isStaticResourceCall){
        List<String> lstEvaluationCriteria = new List<String>();
        String evaluationCriteria = '';
        String strQuery = 'SELECT ';
        if(!query.fields.contains('Id')){
            query.fields.add('Id');
        }
        strQuery += String.join(query.fields, ',') ;
        strQuery += (' FROM '+ query.objType);
        Map<String,String> mapCompareStr =new Map<String ,String>();
        mapCompareStr.put('equals', ' = ');
        mapCompareStr.put('not equals', ' !=');
        mapCompareStr.put('less than', ' <');
        mapCompareStr.put('greater than', ' >');
        mapCompareStr.put('less than equal to', ' <=');
        mapCompareStr.put('greater than equal to', ' >=');
       
        if(isStaticResourceCall){
            if(query.Criteria != null && query.Criteria.conditions.size() > 0){
                strQuery += ' WHERE ' ;
                if(String.isNotBlank(query.Criteria.evaluationCriteria)){
                    lstEvaluationCriteria = query.Criteria.evaluationCriteria.split(',');
                }
                for(ModelWrapper.Condition condition : query.Criteria.conditions){
                    if(String.valueOf(condition.fieldName).contains('name')){
                        strQuery += condition.fieldName+' = '+'\''+condition.value+'\'' ; 
                    }else{
                        strQuery += condition.fieldName+' '+ mapCompareStr.get(condition.operator)+' \''+condition.value+'\'';
                    }
                    if(lstEvaluationCriteria.size() > 0 ){
                        for(Integer index = 0 ; index < lstEvaluationCriteria.size() ; index++){
                            evaluationCriteria = lstEvaluationCriteria[index];
                            lstEvaluationCriteria.remove(index);
                            break;
                        }                                        
                        strQuery += ' '+evaluationCriteria+' ';
                        
                    }
                    else if(query.Criteria.conditions[query.Criteria.conditions.size()-1].fieldName != condition.fieldName){
                        strQuery +=' AND ' ;
                    }
                }
            }
            return strQuery;
        }
        else{
            if(query.conditions != null && query.conditions.size() > 0){
                strQuery += ' WHERE ' ;
                for(ModelWrapper.Condition condition : query.conditions){
                    if(String.valueOf(condition.fieldName).contains('name')){
                        strQuery += condition.fieldName+' = '+'\''+condition.value+'\'' ;
                    }else{
                        strQuery += condition.fieldName+' '+ mapCompareStr.get(condition.operator)+' \''+condition.value+'\'';
                    }
                    if(query.conditions[query.conditions.size()-1].fieldName != condition.fieldName){
                        strQuery +=' AND ' ;
                    }
                }
            }
            return strQuery;  
        }
    }
}