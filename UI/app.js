angular.module('todoApp', [])
  .controller('ManualController', function() {
    var isManualControl = true;
    var todoList = this;

    this.manualControl = function() {
      console.log('manualControl');
      this.isManualControl = true;
    };

    this.fuzzyControl = function() {
        console.log('fuzzyControl');
        this.isManualControl = false;
    };
  });