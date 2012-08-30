var Game = Class.extend({
  background: new Image(),
  others: {},
  track: {hurdles: {}},
  trackWidth: null,

  init: function() {
    this.canvas = $('#game');
    this.context = this.canvas[0].getContext("2d");
    this.context.webkitImageSmoothingEnabled = false;


    this.background.onload = this.drawBg.bind(this);

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

    if (this.player) {
      this.screen.scroll.x = this.player.position.x - this.screen.width/2;
    }

    this.trackWidth = serverData.game.track.width;

    this.updateEntities(serverData);
    this.draw();
  },

  updateEntities: function(serverData) {
    this.player.update(this.getPlayerData(serverData));
    this.addOthers(serverData);
    this.addHurdles(serverData);
    this.updateOthers(serverData);
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
        var hurdleKind = eval(hurdle_deets["kind"])
        this.track.hurdles[hurdle_id] = new hurdleKind(this, hurdle_deets);
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

  drawHurdles: function() {
    for (hurdle_id in this.track.hurdles) {
      this.track.hurdles[hurdle_id].draw();
    }
  },

  drawOthers: function() {
    for (other_client_id in this.others) {
      this.others[other_client_id].draw();
    }
  },

  draw: function() {
    this.clear();
    this.drawBg();
    this.drawHurdles();
    this.drawOthers();
    this.player.draw();
  },

  setScreenPos: function( x, y ) {
    this.screen.scroll.x = x;
    this.screen.scroll.y = y;
  },

  drawBg: function() {
    this.setScreenPos(this.screen.scroll.x, this.screen.scroll.y);

    var spriteX = 0;
    var spriteY = 0;
    var spriteWidth = 32;
    var spriteHeight = 352;
    var destinationX = 0;
    var destinationY = 0;
    var destinationWidth = 32;
    var destinationHeight = spriteHeight;
    var repeatCount = this.screen.width/spriteWidth;

    var tileOffsetX = (this.screen.scroll.x / spriteWidth).toInt();
    var pxOffsetX = this.screen.scroll.x % spriteWidth;
    var pxMinX = -pxOffsetX - spriteWidth;
    var pxMaxX = this.screen.width + spriteWidth - pxOffsetX;

    var drawPos = function( p ) { return Math.round(p); }

    for( var mapX = -1, pxX = pxMinX; pxX < pxMaxX; mapX++, pxX += spriteWidth) {
      var tileX = mapX + tileOffsetX;
      this.context.drawImage(
        this.background,
        spriteX,
        spriteY,
        spriteWidth,
        spriteHeight,
        drawPos(pxX),
        destinationY,
        destinationWidth,
        destinationHeight
      );
    }
  }
});