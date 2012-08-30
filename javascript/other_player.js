var OtherPlayer = Player.extend({
  spriteSheet: new Image(),

  init: function(game, settings) {
    this._super(game, settings);
    this.spriteSheet.src = "images/bikes_green.png";
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
  }
});