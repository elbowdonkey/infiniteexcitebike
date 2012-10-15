Function.prototype.bind = function(){
  var fn = this, args = Array.prototype.slice.call(arguments),
    object = args.shift();
  return function() {
    return fn.apply(object, args.concat(Array.prototype.slice.call(arguments)));
  };
};

Number.prototype.toInt = function() {
  return (this | 0);
};

Array.prototype.random = function() {
	return this[ Math.floor(Math.random() * this.length) ];
};