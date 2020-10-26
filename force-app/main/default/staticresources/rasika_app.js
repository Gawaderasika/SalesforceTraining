var rasika_app = angular.module("rasika_app", ["rasika_factory","rasika_directory"]);
rasika_app.controller("rasika_controller", ['$scope','rasika_factory',function($scope,factory) {
    
    $scope.objName;
    $scope.result = [];
    $scope.selectButton = function(obj){
    	$scope.objName = obj;
        $scope.fields = factory.getObjectAllField($scope.objName);
    	var query = factory.getObjectQuery($scope.objName,'LIMIT 5');
    	factory.getRecords(query,getRecordsSuccess,onError);
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
        alert('Error occured : '+message);
    }
}]);

