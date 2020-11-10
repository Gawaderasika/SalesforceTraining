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
     <table class="my-list-border">
        <tr>
            <th ng-repeat = "field in fields" class="my-list-border">
                {{field.label}}
            </th>
        </tr>
        <tr ng-repeat = "record in records">
            <td ng-repeat="field in record" class="my-list-border">{{field}}</td>
            <td><button ng-click="delete(record.Id)">Delete</button></td>
        </tr>   
     </table>
    `;
    return directive;
});
