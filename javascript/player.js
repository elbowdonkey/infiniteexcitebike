var Player = Class.extend({
  spriteSheet: new Image(),

  init: function(game, settings) {

    this.spriteSheet.src = "images/bikes2.png";
    this.spriteSheet.onload = this.draw.bind(this);

    this.position = settings.position || {x: 0, y: 0};

    // TODO: throw an error if any of these is undefined
    this.game      = game;
    this.signature = settings.signature || null;
    this.client_id = settings.client_id || null;

    this.animations = {
      idle: [0],
      rolling: [0,1]
    }

    // TODO: depending on player input, change animation
    this.animation = this.animations.idle;
  },

  update: function(serverData) {
    this.position = serverData.position;
  },

  draw: function() {
    var spriteX = 0;
    var spriteY = 0;
    var spriteWidth = 26;
    var spriteHeight = 26;
    var destinationX = this.position.x;
    var destinationY = this.position.y;
    var destinationWidth = spriteWidth * 2;
    var destinationHeight = spriteHeight * 2;

    // assuming the elements in the animation array represent positions, rotate through each element for each draw
    // var frame = this.animation.shift();
    // this.animation.push(frame);

    // spriteX = spriteX + (spriteWidth * frame);
    this.game.context.drawImage(this.spriteSheet, spriteX, spriteY, spriteWidth, spriteHeight, destinationX, destinationY, destinationWidth, destinationHeight);
  },
});