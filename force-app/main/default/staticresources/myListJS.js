var myList = angular.module("myList", []);

myList.directive("myList",function(){
    var directive = {};
    directive.restrict = 'E';   
    directive.scope = {
        sObjectName : "@",
        fields : "=",
        records : "=",
        deleteAction : "&"
    },
    directive.controller = function($scope){
        $scope.delete = function(recordId) {
            $scope.deleteAction({
                sObjectName : $scope.sObjectName,
                Id : recordId,
            });
        }
}
    directive.template = 
    `
    <div id = "divTable">
     <table class="my-list-border" id = "recordTable">
        <tr class = "tableHeader">
            <th ng-repeat = "field in fields" class="my-list-border" ng-show = "field.selected" class = "tHeader">
                {{field.label}}
            </th>
        </tr>
        <tr class = "tableRecords" ng-repeat = "record in records">
            <td ng-repeat="field in record" class="my-list-border">
                 {{field}}
            </td>
        </tr> 
     </table>
     <button class="button btnPrev" ng-click = "previous()">previous</button>
     <button class="button btnNext" ng-click = "next()">next</button>
     </div>
    `;
    return directive;
});
