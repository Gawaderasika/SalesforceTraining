var rasika_factory = angular.module("rasika_factory", []);
      
rasika_factory.factory("rasika_factory", function() {
    var factory = {};
    factory.getObjectAllField = function(sObjectName, propName){
        let result = [];
        let fields = rasika_factory.objectSchema[sObjectName].fields; 
        angular.forEach(fields,function(field){
            if(field[propName] != undefined)
                result.push(field[propName]);
            else
                result.push(field);
        });
        return result;
    }
    factory.getObjectQuery = function(sObjectName, limitClause){
        let query = 'SELECT ';
        let fields = this.getObjectAllField(sObjectName,'apiName'); 
        angular.forEach(fields,function(field){
            query += field + ',';
        });
        query = query.substring(0,query.length-1);
        query += ' FROM ' + sObjectName + ' ' + limitClause;
        return query;
    }
    factory.getRecords = function(query,onSuccess,onError){
        rasika_class.getRecords(query,function(result,response){
            if(response.status){
                onSuccess(result);
            }else{
                onError(response.status);
            }
        });
    }
    factory.deleteRecord = function(sObjectName, Id, onSuccess,onError) {
        rasika_class.deleteRecord(sObjectName, Id, function(result, response){
            if(response.status){
                onSuccess('Id',Id);
            }else{
                onError(response.message);
            }
        });
    }
    
    return factory;
});

rasika_factory.objectSchema = {
    'Contact' : {
        apiName : 'Contact',
        fields : [
            {
                label:'Id',
                apiName:'Id'
            },
            {
                label:'Name',
                apiName:'Name'
            },
            {
                label:'Account',
                apiName:'Account'
            },
            {
                label:'Phone',
                apiName:'Phone'
            }
        ]
    },
    'Account' : {
        apiName : 'Account',
        fields : [
            {
                label:'Id',
                apiName:'Id'
            },
            {
                label:'Name',
                apiName:'Name'
            },
            {
                label:'AccountNumber',
                apiName:'AccountNumber'
            },
            {
                label:'Phone',
                apiName:'Phone'
            }
        ]
    },
    'Job_Rasika__c' : {
        apiName : 'Job_Rasika__c',
        fields : [
            {
                label:'Id',
                apiName:'Id'
            },
            {
                label:'Name',
                apiName:'Name'
            },
            {
                label:'Active',
                apiName:'Id'
            },
            {
                label:'Description',
                apiName:'Description__c'
            }
        ]
    },
    'Candidate_Rasika__c' : {
        apiName : 'Candidate_Rasika__c',
        fields : [
            {
                label:'Id',
                apiName:'Id'
            },
            {
                label:'Name',
                apiName:'Name'
            },
            {
                label:'Full Name',
                apiName:'Full_Name__c'
            },
            {
                label:'Status',
                apiName:'Status__c'
            }
        ]
    }
};   

