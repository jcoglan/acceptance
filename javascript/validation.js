Acceptance.Validation = Acceptance.Class({
  initialize: function(object) {
    Acceptance.extend(this, object);
    this._errors = [];
    this._valid  = true;
  },
  
  getForm: function() {
    return this._form;
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
    return this._valid;
  },
  
  addError: function(message) {
    this._errors.push(message);
    this._valid = false;
  },
  
  getErrorMessages: function() {
    return this._errors.slice();
  },
  
  indeterminate: function() {
    this._indeterminate = true;
  },
  
  isIndeterminate: function() {
    return !!this._indeterminate;
  }
  
}, {
  create: function(object) {
    return new this(object);
  }
});

