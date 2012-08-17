KEY = {
  'LEFT_ARROW': 37,
  'UP_ARROW': 38,
  'RIGHT_ARROW': 39,
  'DOWN_ARROW': 40,
};


var Input = Class.extend({
  bindings: {},
  actions: {},
  presses: {},
  locks: {},
  delayedKeyup: {},
  isUsingKeyboard: false,
  
  initKeyboard: function() {
    if( this.isUsingKeyboard ) { return; }
    this.isUsingKeyboard = true;
    window.addEventListener('keydown', this.keydown.bind(this), false );
    window.addEventListener('keyup', this.keyup.bind(this), false );
  },
  
  keydown: function( event ) {
    if( event.target.type == 'text' ) { return; }
    
    var code = event.keyCode
    var action = this.bindings[code];
    if( action ) {
      this.actions[action] = true;
      if( !this.locks[action] ) {
        this.presses[action] = true;
        this.locks[action] = true;
      }
      event.stopPropagation();
      event.preventDefault();
    }
  },
  
  keyup: function( event ) {
    if( event.target.type == 'text' ) { return; }
    
    var code = event.keyCode
    var action = this.bindings[code];
    if( action ) {
      this.delayedKeyup[action] = true;
      event.stopPropagation();
      event.preventDefault();
    }
  },
  
  bind: function( key, action ) {
    if( key > 0 ) { this.initKeyboard(); }
    this.bindings[key] = action;
  },
  
  unbind: function( key ) {
    var action = this.bindings[key];
    this.delayedKeyup[action] = true;
    this.bindings[key] = null;
  },
  
  state: function( action ) {
    return this.actions[action];
  },
  
  
  pressed: function( action ) {
    return this.presses[action];
  },
  
  released: function( action ) {
    return this.delayedKeyup[action];
  },
    
  clearPressed: function() {
    for( var action in this.delayedKeyup ) {
      this.actions[action] = false;
      this.locks[action] = false;
    }
    this.delayedKeyup = {};
    this.presses = {};
  },
});