Function.prototype.bind = function(){
  var fn = this, args = Array.prototype.slice.call(arguments),
    object = args.shift();
  return function(){
    return fn.apply(object,
      args.concat(Array.prototype.slice.call(arguments)));
  };
};

var WebsocketClient = Class.extend({
  player: null,
  init: function() {
    this.connection = new WebSocket("ws://0.0.0.0:9000/");
    this.connection.onopen = this._onopen.bind(this);
    this.connection.onerror = this._onerror.bind(this);
    this.connection.onmessage = this._onmessage.bind(this);
    this.connection.onclose = this._onclose.bind(this);

    this.setupGame();
  },

  setupGame: function() {
    this.game = new Game();
  },

  setupPlayer: function(settings) {
    this.player = new Player(settings);
  },

  _onopen: function() {
    console.log("socket connected");
  },

  _onerror: function(error) {
    console.log(error);
  },

  _onmessage: function(message) {
    var data = JSON.parse(message.data);

    if (this.player == null && data.client_id != undefined) {
      this.setupPlayer(data);
    }

    if (data.advance) {
      this.game.update();
    }

    console.log(message, data);
  },

  _onclose: function() {
    console.log("socket closed");
  }
});