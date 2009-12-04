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
    var validation = this._generateValidationObject(),
        tests      = this._tests.slice();
    
    var i = 0, n = tests.length, self = this;
    if (n === 0 && (callback instanceof Function)) return callback.call(scope);
    
    Acceptance.each(tests, function(test) {
      test(function(result) {
        if (result instanceof Array) Acceptance.each(result, function(error) {
          validation.errors.push(error);
        });

        i += 1;
        if (i < n) return;

        self._valid = (validation.errors.length === 0);
        validation.valid = self._valid;
        
        Acceptance.notifyClient(validation);
        
        if (callback instanceof Function) callback.call(scope);
      }, validation);
    });
    
    Acceptance.each(this._callbacks, function(callback) {
      callback[0].call(callback[1]);
    });
  },
  
  _generateValidationObject: function() {
    var formData = Acceptance.Dom.getValues(this._form.getForm()),
        value    = formData[this._fieldName];
    
    return {
      form:     this._form.getForm(),
      input:    this.getInput(),
      name:     this._fieldName,
      value:    value,
      formData: formData,
      errors:   []
    };
  }
}, {
  _isPresent: function(message) {
    return function(returns, validation) {
      var value = validation.value;
      returns( Acceptance.trim(value) ? true : [message] );
    }
  }
});

