var rasikaTable = angular.module("rasikaTable", []);
rasikaTable.directive("rasikaTable",function(){
    var directive = {};
    directive.restrict = 'E';   
    directive.scope = {
        sObjectName : "@",
        fields : "=",
        records : "=",
        deleteAction : "&"
    },
    directive.controller = function($scope){
        $scope.Math = window.Math;
        $scope.currentPage = 1;
        $scope.start = 0;
        $scope.delete = function(recordId) {
            $scope.deleteAction({
                sObjectName : $scope.sObjectName,
                Id : recordId,
            });
        }
        $scope.previous = function(){
            if($scope.start != 0){
                $scope.start = $scope.start - 3;
                $scope.currentPage -= 1;
            }
    	}
    	$scope.next = function(){
    			$scope.start = $scope.start + 3;
            	$scope.currentPage += 1;
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
                      {{record[field.apiName]}} in {{records.length/3}}
                 	</td>
                </tr>
     		</table>
            <p id = "pageNo">Page {{currentPage}} of {{Math.ceil(records.length/3)}}</p>       
     		<button class="button btnPrev" ng-click = "previous()">Previous</button>
     		<button class="button btnNext" ng-click = "next()">Next</button>
     	</div>
    `;
    return directive;
});
