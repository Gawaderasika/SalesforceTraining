var rasika_app = angular.module("rasika_app", ["rasika_factory","rasika_table"]);
rasika_app.controller("rasika_controller", ['$scope','rasika_factory',function($scope,factory) {
   
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
        $scope.result = result;
        $scope.$apply();
    }
    
    function onError(message){
        alert(message);
    }
}]);

