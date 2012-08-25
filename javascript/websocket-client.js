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
    if (this.game.player == null && settings.client_id != undefined) {
      this.game.player = new Player(this.game,settings);
    }
  },

  setupOtherPlayers: function(settings) {
    var gameData = settings.game;
    if (gameData == undefined) {
      return;
    }

    var others = gameData.players || null;
    if (others == null) {
      return;
    }

    if (others.length > 1) {
      for (var i = others.length - 1; i >= 0; i--) {
        var other = others[i];
        if (this.otherPlayers[other.client_id] == undefined && other.client_id != this.player.client_id) {
          this.otherPlayers[other.client_id] = new OtherPlayer(this.game,other);
        }
      };
    }
  },

  _onopen: function() {
    console.log("socket connected");
  },

  _onerror: function(error) {
    console.log(error);
  },

  _onmessage: function(message) {
    var data = JSON.parse(message.data);

    if (data.client_id) {
      this.setupPlayer(data);
    }

    if (data.advance) {
      this.game.update(data);
    }

    if (data.remove) {
      delete this.game.others[data.remove];
    }
  },

  _onclose: function() {
    console.log("socket closed");
  }
});