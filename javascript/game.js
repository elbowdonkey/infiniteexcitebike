var Game = Class.extend({
  background: new Image(),
  others: {},
  offset: {x: 0, y: 0},
  serverQueue: [],
  clock: null,

  init: function() {
    this.canvas = $('#game');
    this.context = this.canvas[0].getContext("2d");
    this.context.webkitImageSmoothingEnabled = false;

    this.screen = {
      width: this.canvas.width(),
      height: this.canvas.height(),
      scroll: {
        x: 0,
        y: 0
      }
    }

    this.background.src = "images/bg.png";

    this.clock = setInterval( this.processQueue.bind(this), 500 );
  },

  processQueue: function() {
    var data;

    if (this.player == undefined) {
      // grab the first message with our client_id
      data = this.serverQueue.shift();
    } else {
      // grab the newest message
      data = this.serverQueue.pop();
    }
    
    if (data) {
      if (data.client_id) {
        this.setupPlayer(data);
        return;
      }
    } else {
      //clearInterval(this.clock);
    }

    this.update(data);
  },

  update: function(serverData) {
    if (serverData) {
      console.log(serverData);
      this.player.update(this.getPlayerData(serverData));
      this.addOthers(serverData);
      this.updateOthers(serverData);
    } else {
      this.player.update();
    }

    this.clear();
    //this.drawBg();
    this.player.draw();
    this.drawOthers();
    this.draw();
  },

  clear: function() {
    this.context.clearRect(0, 0, this.screen.width, this.screen.height);
  },

  setupPlayer: function(settings) {
    if (this.player == null && settings.client_id != undefined) {
      this.player = new Player(this,settings);
    }
  },

  getPlayerData: function(serverData) {
    return serverData.game.players[this.player.client_id];
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
    this.clear();
    var pattern = this.context.createPattern(this.background,'repeat-x');
    this.context.fillStyle = pattern;
    this.context.fillRect(0,0,640,352);
    this.context.translate(-this.offset.x, 0);

    // var imageData = this.context.getImageData(0, 0, this.canvas.width, this.canvas.height);
    // var data = imageData.data;
    // this.context.putImageData(imageData, -this.offset.x, 0);
  },

  x_drawBg: function() {
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