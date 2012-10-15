var Player = Class.extend({
  spriteSheet: new Image(),
  throttleLevel: 0,
  offset: {x: 0, y: 0},
  lane: 2,
  targetLane: 2,
  laneOffsets: [48,24,0,-24],
  changingLanes: false,

  init: function(game, settings) {

    var sprite_color = settings.color;
    this.spriteSheet.src = "images/bikes_" + sprite_color + ".png";

    this.spriteSheet.onload = this.draw.bind(this);
    this.animFrame = 0;

    this.position  = settings.position || {x: 0, y: 0};
    this.game      = game;
    this.signature = settings.signature || null;
    this.client_id = settings.client_id || null;

    this.animations = {
      idle:     [0],
      rolling:  [1,2],
      laneUp:   [23],
      laneDown: [24],
      shifting: [0,2],
      jumping:  [5]
    }

    this.animation = this.animations.idle;

    this.input = new Input();
    this.input.bind( KEY.RIGHT_ARROW, 'right' );
    this.input.bind( KEY.LEFT_ARROW, 'left' );
    this.input.bind( KEY.UP_ARROW, 'up' );
    this.input.bind( KEY.DOWN_ARROW, 'down' );
  },

  update: function(serverData) {
    this.handleInputs();
    this.throttleLevel = serverData.throttle.level;
    this.targetLane = serverData.lane;

    var targetAnim = this.animations.idle;

    if (this.throttleLevel > 0) targetAnim = this.animations.rolling;

    if (this.changingLanes) {
      if (this.targetLane < this.lane) targetAnim = this.animations.laneUp;
      if (this.targetLane > this.lane) targetAnim = this.animations.laneDown;
    }

    if (this.changingLanes && this.throttleLevel == 0) targetAnim = this.animations.shifting;

    if (serverData.atHurdle) targetAnim = this.animations.jumping;

    this.position = serverData.position;
    this.animation = targetAnim;
  },

  handleInputs: function() {
    var right = this.input.state('right');
    var left  = this.input.state('left');
    var up    = this.input.state('up');
    var down  = this.input.state('down');

    if (right) {
      this.sendInput("right");
    } else if (left) {
      this.sendInput("left");
    } else if (up && !this.changingLanes) {
      this.sendInput("up");
      this.startLaneChange('up');
    } else if (down && !this.changingLanes) {
      this.sendInput("down");
      this.startLaneChange('down');
    } else {
      if (this.throttleLevel > 0) this.sendInput("coast");
    }

    this.makeLaneChange();
  },

  sendInput: function(input) {
    socket.connection.send(JSON.stringify({input: input}));
  },

  startLaneChange: function(direction) {
    console.log('changing to lane: ', this.targetLane);
    this.changingLanes = true;
    if (direction == "up")   this.targetLane = this.lane - 1;
    if (direction == "down") this.targetLane = this.lane + 1;
    if (this.targetLane < 0) this.targetLane = 0;
    if (this.targetLane > 3) this.targetLane = 3;
  },

  makeLaneChange: function() {
    if (this.changingLanes) {
      var offsetDifference = Math.abs(this.offset.y - this.laneOffsets[this.targetLane]);

      if (offsetDifference == 0) {
        this.lane          = this.targetLane;
        this.targetLane    = null;
        this.animation   = this.animations.rolling;
        this.changingLanes = false;
        return;
      }

      var laneAbove = this.targetLane < this.lane;
      var laneBelow = this.targetLane > this.lane;
      var moveBy = 0.75;
      var fractionalStep = offsetDifference < moveBy;

      this.animation = laneAbove ? this.animations.laneUp : this.animations.laneDown;

      if (laneAbove) this.offset.y += fractionalStep ? offsetDifference : moveBy;
      if (laneBelow) this.offset.y -= fractionalStep ? offsetDifference : moveBy;
    }
  },

  draw: function() {
    var spriteX = 0;
    var spriteY = 0;
    var spriteWidth = 26;
    var spriteHeight = 26;
    var destinationX = this.position.x-26;
    var destinationY = this.position.y - this.offset.y;
    var destinationWidth = spriteWidth * 2;
    var destinationHeight = spriteHeight * 2;

    destinationX = this.position.x - this.game.screen.scroll.x - 26;

    var frame = this.animation[this.animFrame];
    spriteX = spriteX + (spriteWidth * frame);

    this.game.context.drawImage(this.spriteSheet, spriteX, spriteY, spriteWidth, spriteHeight, destinationX, destinationY, destinationWidth, destinationHeight);


    this.animFrame += 1;
    if (this.animFrame > this.animation.length-1) {
      this.animFrame = 0;
    }
  },
});