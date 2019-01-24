angular.module('remote', [])
.controller('remoteCtl', function ($scope, $http) {
    var limit = 1000,
        lim = p => _.clamp(Math.round(p * limit), -limit, limit);
    function setPower(left, right, manual = true) {
        $http.post('/power', { left: lim(left), right: lim(right), manual});
    }
    var send = _.throttle(setPower, 100, { leading: true, trailing: true });
    $scope.setPower = (speed, turn) => {
        $scope.power = { speed, turn };
        send(speed - turn, speed + turn);
    };
    $scope.auto = ($e) => {setPower(0, 0, false); $e.stopPropagation()};
    $scope.power = { speed: 0, turn: 0 };
})
.directive('joystick', () => ({
restrict: 'C',
scope: true,
link: function ($scope, $element) {
    $scope.adjust = function ($e) {
        var e = $e.touches && $e.touches[0] || $e,
            speed = (100 - e.clientY) / 100,
            turn = (100 - e.clientX) / 100;
        $scope.setPower(speed, turn);
    }
    $element.on('touchmove', $scope.adjust);
}
}));
