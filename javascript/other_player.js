var OtherPlayer = Player.extend({
  spriteSheet: new Image(),

  init: function(game, settings) {
    this._super(game, settings);
    var sprite_color = Math.round(Math.random() * 11) -1;
    this.spriteSheet.src = "images/bikes_" + sprite_color + ".png";
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