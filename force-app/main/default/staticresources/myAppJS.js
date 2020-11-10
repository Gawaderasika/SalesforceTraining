var myApp = angular.module("myApp", ["myFactory","myList"]);
myApp.controller("myController", ['$scope','myFactory',function($scope,factory) {
   
    $scope.objName;
    $scope.result = [];
    $scope.fieldsShow = [];
    $scope.limitRecords = 'LIMIT 100';
    
    $scope.run = function(){
        $scope.fieldsShow = [];
    	$scope.fields.forEach(function(field) {
      		if (field.selected) {
        		$scope.fieldsShow.push(field.apiName);
      		}
    	});
        var query = factory.getObjectQuery($scope.objName,$scope.fieldsShow,$scope.limitRecords);
    	factory.getRecords(query,getRecordsSuccess,onError);
      
        factory.disp();
    }
    
    $scope.selectButton = function(obj){
        $scope.objName = obj;
        $scope.fields = factory.getObjectAllField($scope.objName);
        factory.hide();
    }
   	
    $scope.deleteRecord = function(sObjectName, Id, onSuccess,onError) {
        factory.deleteRecord(sObjectName, Id, removeRecord,onError);
    }
    
    removeRecord = function(key, value){
        let count;
        for( i= 0; i<$scope.result.length; i++){
            if($scope.result[i][key] == value){
                count = i;
                break;
            }
        }        
        $scope.result.splice(count,1);
        $scope.$apply();
        alert('record remove successfully');
    }
    
    function getRecordsSuccess(result){
        //$scope.testResult = {};
        /*$scope.resultData = [];
        $scope.result1 = {};
        result.forEach(data => {
            $scope.fieldsShow.forEach(x => {
            	if(data.hasOwnProperty(x)){
            		$scope.result1.push(x,data[x]);
        		}
            	else
            	{
           			$scope.result1.push(x, 'NA');
            	}
        	})
           	$scope.resultData.push($scope.result1);
        })
        console.log('data',$scope.resultData);
        $scope.$apply();*/
        /*result.forEach((record, val) => {
            	var data = {};
                $scope.fieldsShow.forEach((fieldApiName, value) => {
            		if(!record.hasOwnProperty(fieldApiName)){
            			record[fieldApiName]="NA";
        			}
        		})
        	}
        )*/
        $scope.result = result;
        $scope.$apply();
    }
    
    function onError(message){
        alert(message);
    }
}]);

