calendarPopoverDirective = angular.module('calendarPopoverDirectiveModule', [])

calendarPopoverDirective.directive('calendarPopover', ($templateCache) ->
  restrict: 'E'
  template: '<div ng-click="select(day)">
              <div id="{{day.dateKey}}" title="Total balance: {{day.balance | currency}} ">
                {{day.dateOfMonth}} <span class=badge ng-show="day.count > 0">{{day.count}}</span>
                <div id="{{day.dateKey}}-content" ng-show=false>
                  <div ng-repeat="bill in day.bills">
                    <li><a href="/bills/{{bill.bill_id}}">{{bill.note}}</a>
                  </div>
                </div>
              </div>
            </div>'
  link: (scope, element, attrs) ->
    scope.select = (day) ->
      scope.calendar.selectDay = day
      newElementId = "#" + scope.calendar.selectDay.dateKey
      contentElementId = "#" + scope.calendar.selectDay.dateKey + "-content"
      element.find(newElementId).popover(
        html: true,
        placement:'right',
        content: element.find(contentElementId).html(),
        container: 'body'
      ).popover()
      return newElementId
)