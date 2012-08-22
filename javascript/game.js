var Game = Class.extend({
  background: new Image(),
  others: {},
  track: {hurdles: {}},

  init: function() {
    this.canvas = $('#game');
    this.context = this.canvas[0].getContext("2d");
    this.context.webkitImageSmoothingEnabled = false;


    //this.background.onload = this.drawBg.bind(this);

    this.screen = {
      width: this.canvas.width(),
      height: this.canvas.height(),
      scroll: {
        x: 0,
        y: 0
      }
    }

    this.background.src = "images/bg.png";
    this.input = new Input();
    this.input.bind( KEY.UP_ARROW, 'jump' );
  },

  update: function(serverData) {
    if (this.input.state('jump')) console.log('jump!');
    this.input.clearPressed();

    this.player.update(this.getPlayerData(serverData));
    this.addOthers(serverData);
    this.addHurdles(serverData);
    this.updateOthers(serverData);
    this.clear();
    this.player.draw();
    this.drawOthers();
    this.draw();

  },

  clear: function() {
    this.context.clearRect(0, 0, this.screen.width, this.screen.height);
  },

  getPlayerData: function(serverData) {
    return serverData.game.players[this.player.client_id];
  },

  addHurdles: function(serverData) {
    for (hurdle_id in serverData.game.hurdles) {
      if (this.track.hurdles[hurdle_id] == undefined) {
        var hurdle_deets = serverData.game.hurdles[hurdle_id];
        this.track.hurdles[hurdle_id] = new Hurdle(this, hurdle_deets);
      }
    }
  },

  addOthers: function(serverData) {
    for (other_client_id in serverData.game.players) {
      if (this.others[other_client_id] == undefined && other_client_id != this.player.client_id) {
        var other_deets = serverData.game.players[other_client_id];
        this.others[other_client_id] = new OtherPlayer(this, other_deets);
      }
    }
  },

  updateOthers: function(serverData) {
    for (other_client_id in this.others) {
      this.others[other_client_id].update(serverData.game.players[other_client_id]);
    }
  },

  drawOthers: function() {
    for (other_client_id in this.others) {
      this.others[other_client_id].draw();
    }
  },

  draw: function() {
    //this.drawBg();
  },

  drawBg: function() {
    var spriteX = 0;
    var spriteY = 0;
    var spriteWidth = 32;
    var spriteHeight = 352;
    var destinationX = 0;
    var destinationY = 0;
    var destinationWidth = 32;
    var destinationHeight = spriteHeight;
    var repeatCount = this.screen.width/spriteWidth;

    // if (offset.x % spriteWidth == 0) {
    //   this.screen.scroll.x += 1;
    // }

    for (var x = 0; x < repeatCount; x++) {
      destinationX = (spriteWidth * x); // - offset.x;
      this.context.drawImage(this.background, spriteX, spriteY, spriteWidth, spriteHeight, destinationX, destinationY, destinationWidth, destinationHeight);
    };
  }
});