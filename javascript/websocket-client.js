var WebsocketClient = Class.extend({
  player: null,
  init: function() {
    this.connection = new WebSocket("ws://192.168.1.10:9000/");
    this.connection.onopen = this._onopen.bind(this);
    this.connection.onerror = this._onerror.bind(this);
    this.connection.onmessage = this._onmessage.bind(this);
    this.connection.onclose = this._onclose.bind(this);

    this.setupGame();
  },

  setupGame: function() {
    this.game = new Game();
  },

  _onopen: function() {
    console.log("socket connected");
  },

  _onerror: function(error) {
    console.log(error);
  },

  _onmessage: function(message) {
    var data = JSON.parse(message.data);

    if (data.remove) {
      delete this.game.others[data.remove];
    } else {
      this.game.serverQueue.push(data);  
    }
  },

  _onclose: function() {
    console.log("socket closed");
    clearInterval(this.game.clock);
  }
});