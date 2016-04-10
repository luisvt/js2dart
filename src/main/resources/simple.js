arr.slice();

Array.prototype.push.apply(arr1, arr2);

'use strict';

var Apple = (function () {
  function Apple() {
  }

  Apple.prototype = {
    get color() {
      return 'red';
    },

    setFlags: function Annotation_setFlags(flags) {
      if (isInt(flags)) {
        this.flags = flags;
      } else {
        this.flags = 0;
      }
    }
  };

  Util.inherit(AppleExt, Apple, {
    getOperatorList: function TextWidgetAnnotation_getOperatorList(evaluator, task) {

    }
  });

  return Apple;
})();

if(typeof 37 === "number") {

}

var re = /ab+c/;

function Person() {

}

Person.prototype = {
  get name() {
    return 'luis';
  },

  set name(name) {

  },

  age: function () {

  }

};

var apples = [];

//comment
apples.splice(4, 5);

apples.push(3);

//comment
3 === 4 || 3 !== 5;

var a = apple || {};


