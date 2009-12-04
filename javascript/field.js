Acceptance.Field = Acceptance.Class({
  initialize: function(form, fieldName, message) {
    form._numRequirements += 1;
    this._form      = form;
    this._fieldName = fieldName;
    this._valid     = true;
    this._tests     = [];
    this._callbacks = [];
    this.getInput();
  },
  
  getInput: function() {
    if (this._hasInput()) return this._input;
    
    this._input = Acceptance.Dom.getInputs(this._form.getForm(), this._fieldName)[0];
    Acceptance.Event.on(this._input, 'blur', this.validate, this);
    
    Acceptance.Event.on(this._input, 'focus', function() {
      this._touched = true;
    }, this);
    
    return this._input;
  },
  
  isTouched: function() {
    return !!this._touched;
  },
  
  setMessage: function(message) {
    if (!message) return;
    this.addTest(this.klass._isPresent(message));
  },
  
  onChange: function(callback, scope) {
    this._callbacks.push([callback, scope]);
  },
  
  addTest: function(test) {
    this._tests.push(test);
  },
  
  _hasInput: function() {
    return Acceptance.Dom.exists(this._input);
  },
  
  isValid: function(callback, scope) {
    this.validate(function() {
      callback.call(scope, !!this._valid);
    }, this);
  },
  
  validate: function(callback, scope) {
    var tests    = this._tests.slice(),
        formData = Acceptance.Dom.getValues(this._form.getForm()),
        value    = formData[this._fieldName],
        errors   = [];
    
    var i = 0, n = tests.length, self = this;
    if (n === 0 && (callback instanceof Function)) return callback.call(scope);

    Acceptance.each(tests, function(test) {
      test(function(result) {
        if (result instanceof Array) errors = errors.concat(result);

        i += 1;
        if (i < n) return;

        self._valid = (errors.length === 0);
        Acceptance.notifyClient(self, errors);
        if (callback instanceof Function) callback.call(scope);
      }, value, formData, errors);
    });
    
    Acceptance.each(this._callbacks, function(callback) {
      callback[0].call(callback[1]);
    });
  }
}, {
  _isPresent: function(message) {
    return function(returns, value) {
      returns( Acceptance.trim(value) ? true : [message] );
    }
  }
});

