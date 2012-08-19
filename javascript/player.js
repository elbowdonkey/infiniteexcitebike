var Player = Class.extend({
  spriteSheet: new Image(),
  throttle_level: 0,
  throttle_counter: 0,
  throttle_steps: [0,8,16,32],

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

    this.input = new Input();
    this.input.bind( KEY.UP_ARROW, 'jump' );
    this.input.bind( KEY.RIGHT_ARROW, 'right' );
    this.input.bind( KEY.LEFT_ARROW, 'left' );
  },

  update: function(serverData) {
    if (serverData) {
      // when server data is available, use it to course correct
      this.position = serverData.position;
      this.game.offset = serverData.position;  
    } else {
      // use the data from our client side simulation
    }
    

    if (this.input.state('right')) {
      console.log('input here');
      socket.connection.send(JSON.stringify({input: "right"}));
    }

    if (this.input.state('left')) {
      socket.connection.send(JSON.stringify({input: "left"}));
    }
    // socket.game.clear();
    // this.draw();
    this.input.clearPressed();
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

  /*
  apply_throttle: function() {
    this.set_new_position("right");
  },

  apply_brake: function() {
    this.set_new_position("left");
  },

  set_new_position: function(direction) {
    var right = direction == "right";
    var left = direction == "left";

    if (this.throttle_counter >= this.throttle_steps[0]) this.throttle_level = 0;
    if (this.throttle_counter >= this.throttle_steps[1]) this.throttle_level = 1;
    if (this.throttle_counter >= this.throttle_steps[2]) this.throttle_level = 2;
    if (this.throttle_counter >= this.throttle_steps[3]) this.throttle_level = 3;

    if (right) {
      this.throttle_counter += 1;
    } else {
      this.throttle_counter -= 1;
    }

    this.throttle_counter = this.throttle_counter.limit(0,32);
    this.throttle_level = this.throttle_level.limit(0,3);

    console.log(this.throttle_level);


    if (this.throttle_level > 0) this.position.x += this.throttle_level;
  },
  */
});