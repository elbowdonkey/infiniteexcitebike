var Game = Class.extend({
  init: function() {
    this.input = new Input();
    this.input.bind( KEY.UP_ARROW, 'jump' );
  },
  update: function() {
    console.log('jump!', this.input.state('jump'));
  },
});