var rasika_table = angular.module("rasika_table", []);
rasika_table.directive("rasika_table",function(){
    var directive = {};
    directive.restrict = 'E';   
    directive.scope = {
        sObjectName : "@",
        fields : "=",
        records : "=",
        deleteAction : "&"
    },
    directive.controller = function($scope){
    	$scope.nullVal = "NULL VALUE";
        $scope.start = 0;
        $scope.delete = function(recordId) {
            $scope.deleteAction({
                sObjectName : $scope.sObjectName,
                Id : recordId,
            });
        }
        $scope.previous = function(){
            if($scope.start != 0){
                $scope.start = $scope.start - 5;
            }
    	}
    	$scope.next = function(){
    		$scope.start = $scope.start + 5;
    	}
	}
    directive.template = 
    `
    	<div id = "divTable">
     		<table class="table table-bordered" id = "recordTable">
                <tr class = "tableHeader">
            		<th ng-repeat = "field in fields" class="my-list-border" ng-show = "field.selected" class = "tHeader">
                		{{field.label}}
            		</th>
        		</tr>
                <tr ng-repeat = "record in records| limitTo : 3 : start" class = "tableRecords">
                	<td ng-repeat = "field in fields" ng-show = "field.selected">
                 		{{record[field.apiName]}}
                 	</td>
                </tr>
     		</table>
     		<button class="button btnPrev" ng-click = "previous()">Previous</button>
     		<button class="button btnNext" ng-click = "next()">Next</button>
     	</div>
    `;
    return directive;
});
