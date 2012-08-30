var Hurdle = Class.extend({
	game: null,

	init: function(game, settings) {
		this.game = game;
		this.position = settings["position"];
		this.width 		= settings["width"];
    this.curves 	= settings["curves"];
    this.kind			= settings["kind"];
	},

	update: function() {
		this.draw();
	},

	draw: function() {
    //return;
    var spriteX = 0;
    var spriteY = 0;
    var spriteWidth = this.width;
    var spriteHeight = 176;
    var destinationX = this.position.x;
    var destinationY = this.position.y;
    var destinationWidth = spriteWidth * 2;
    var destinationHeight = spriteHeight * 2;

    destinationX = this.position.x - this.game.screen.scroll.x;

    this.game.context.drawImage(this.spriteSheet, spriteX, spriteY, spriteWidth, spriteHeight, destinationX, destinationY, destinationWidth, destinationHeight);
  },
});

var HurdleA = Hurdle.extend({
	spriteSheet: new Image(),
	init: function(game, settings) {
		this.spriteSheet.src = "images/HurdleA.png";
		this._super(game, settings);
	},
});

var HurdleB = Hurdle.extend({
	spriteSheet: new Image(),
	init: function(game, settings) {
		this.spriteSheet.src = "images/HurdleB.png";
		this._super(game, settings);
	},
});

var HurdleC = Hurdle.extend({
	spriteSheet: new Image(),
	init: function(game, settings) {
		this.spriteSheet.src = "images/HurdleC.png";
		this._super(game, settings);
	},
});

var HurdleD = Hurdle.extend({
	spriteSheet: new Image(),
	init: function(game, settings) {
		this.spriteSheet.src = "images/HurdleD.png";
		this._super(game, settings);
	},
});