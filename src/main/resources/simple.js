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
  }
})();

var re = /ab+c/;

function Person() {

}

var apples = [];

//comment
apples.splice(4, 5);

//comment
3 === 4 || 3 !== 5;

