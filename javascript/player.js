var Player = Class.extend({
  spriteSheet: new Image(),
  throttleLevel: 0,
  init: function(game, settings) {

    this.spriteSheet.src = "images/bikes2.png";
    this.spriteSheet.onload = this.draw.bind(this);
    this.animFrame = 0;

    this.position = settings.position || {x: 0, y: 0};
    this.game      = game;
    this.signature = settings.signature || null;
    this.client_id = settings.client_id || null;

    this.animations = {
      idle: [0],
      rolling: [1,2],
      jumping: [3,4,5,6]
    }

    this.animation = this.animations.idle;

    this.input = new Input();
    this.input.bind( KEY.RIGHT_ARROW, 'right' );
    this.input.bind( KEY.LEFT_ARROW, 'left' );
  },

  update: function(serverData) {
    this.handleInputs();
    this.throttleLevel = serverData.throttle.level;

    if (this.throttleLevel > 0) {
      this.animation = this.animations.rolling;
    } else {
      this.animation = this.animations.idle;
    }

    if (serverData.atHurdle) {
      this.animation = this.animations.jumping;
    }

    this.position = serverData.position;
  },

  handleInputs: function() {
    if (this.input.state('right')) {
      socket.connection.send(JSON.stringify({input: "right"}));
    } else if (this.input.state('left')) {
      socket.connection.send(JSON.stringify({input: "left"}));
    } else {
      if (this.throttleLevel > 0) {
        socket.connection.send(JSON.stringify({input: "coast"}));
      }
    }
  },

  draw: function() {
    var spriteX = 0;
    var spriteY = 0;
    var spriteWidth = 26;
    var spriteHeight = 26;
    var destinationX = this.position.x-26;
    var destinationY = this.position.y;
    var destinationWidth = spriteWidth * 2;
    var destinationHeight = spriteHeight * 2;

    var frame = this.animation[this.animFrame];
    spriteX = spriteX + (spriteWidth * frame);
    this.game.context.drawImage(this.spriteSheet, spriteX, spriteY, spriteWidth, spriteHeight, destinationX, destinationY, destinationWidth, destinationHeight);
    this.animFrame += 1;
    if (this.animFrame > this.animation.length-1) {
      this.animFrame = 0;
    }
  },
});