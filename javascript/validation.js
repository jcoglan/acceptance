Acceptance.Validation = Acceptance.Class({
  initialize: function(object) {
    Acceptance.extend(this, object);
    this._errors        = [];
    this._indeterminate = false;
    this._cancelled     = false;
    this._callbacks     = [];
  },
  
  getForm: function() {
    return this._form;
  },
  
  getDisplayName: function() {
    return this._displayName;
  },
  
  getInput: function() {
    return this._input;
  },
  
  getValue: function() {
    return this._value;
  },
  
  get: function(field) {
    return this._data[field];
  },
  
  getEventType: function() {
    return this._eventType;
  },
  
  isValid: function() {
    return this._errors.length === 0 &&
           this._indeterminate === false;
  },
  
  addError: function(message) {
    this._errors.push(message);
  },
  
  getErrorMessages: function() {
    return this._errors.slice();
  },
  
  indeterminate: function() {
    this._indeterminate = true;
  },
  
  isIndeterminate: function() {
    return this._indeterminate;
  },
  
  cancel: function() {
    this._cancelled = true;
    
    Acceptance.each(this._callbacks, function(callback) {
      callback[0].call(callback[1]);
    });
  },
  
  isCancelled: function() {
    return this._cancelled;
  },
  
  onCancel: function(callback, scope) {
    this._callbacks.push([callback, scope]);
  }
  
}, {
  create: function(object) {
    return new this(object);
  }
});

