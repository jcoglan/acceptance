Acceptance.Event = Acceptance.Class({
  initialize: function(nativeEvent) {
    this._event = nativeEvent;
  },
  
  stopDefault: function() {
    if (this._event.preventDefault) this._event.preventDefault();
    else this._event.returnValue = false;
  }
}, {
  _registry: [],
  
  on: function(element, eventName, callback, scope) {
    if (!element || element.nodeType !== 1) return;
    
    var listener = function(event) {
      callback.call(scope, element, new Acceptance.Event(event));
    };
    
    if (element.addEventListener)
      element.addEventListener(eventName, listener, false);
    else
      element.attachEvent('on' + eventName, listener);
    
    this._registry.push({
      _element:   element,
      _type:      eventName,
      _callback:  callback,
      _scope:     scope,
      _listener:  listener
    });
  },
  
  detach: function(element, eventName, callback, scope) {
    var i = this._registry.length, register;
    while (i--) {
      register = this._registry[i];
      
      if ((element   && element   !== register._element  ) ||
          (eventName && eventName !== register._type     ) ||
          (callback  && callback  !== register._callback ) ||
          (scope     && scope     !== register._scope    ))
        continue;
      
      if (register._element.removeEventListener)
        register._element.removeEventListener(register._type, register._listener, false);
      else
        register._element.detachEvent('on' + register._type, register._listener);
      
      register._element  = null;
      register._callback = null;
      register._listener = null;
      register = null;
      
      this._registry.splice(i,1);
    }
  },
  
  ENV: this
});

Acceptance.Event.on(Acceptance.Event.ENV, 'unload',
    Acceptance.Event.detach,
    Acceptance.Event);

