Acceptance.Field = Acceptance.Class({
  initialize: function(form, fieldName, message) {
    this._form      = form;
    this._fieldName = fieldName;
    this._message   = message;
    this._tests     = [];
    this.getInput();
  },
  
  getInput: function() {
    if (this._hasInput()) return this._input;
    
    this._input = Acceptance.Dom.getInputs(this._form.getForm(), this._fieldName)[0];
    Acceptance.Event.on(this._input, 'blur', this._validate, this);
    
    return this._input;
  },
  
  setMessage: function(message) {
    if (!message) return;
    this._message = message;
  },
  
  _hasInput: function() {
    return this._input && Acceptance.Dom.exists(this._input);
  },
  
  isValid: function() {
    this._validate();
    return !!this._valid;
  },
  
  _validate: function() {
    var tests    = this._tests.length ? this._tests : [this.klass._isPresent(this._message)],
        formData = Acceptance.Dom.getValues(this._form.getForm()),
        value    = formData[this._fieldName],
        errors   = [];
    
    Acceptance.each(tests, function(test) {
      var result = test(value, formData);
      if (result === true) return;
      errors = errors.concat(result);
    });
    
    this._valid = (errors.length === 0);
    Acceptance.notifyClient(this, errors);
  }
}, {
  _isPresent: function(message) {
    return function(value) {
      return Acceptance.trim(value) ? true : [message];
    }
  }
});

