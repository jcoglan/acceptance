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
    Acceptance.Event.on(this._input, 'blur', function() { this.validate('blur') }, this);
    
    Acceptance.Event.on(this._input, 'focus', function() {
      this._touched = true;
      this._cancelValidation();
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
  
  onValidation: function(callback, scope) {
    this._callbacks.push([callback, scope]);
  },
  
  addTest: function(test) {
    this._tests.push(test);
  },
  
  _hasInput: function() {
    return Acceptance.Dom.exists(this._input);
  },
  
  isValid: function(eventType, callback, scope) {
    this.validate(eventType, function() {
      callback.call(scope, !!this._valid);
    }, this);
  },
  
  validate: function(eventType, callback, scope) {
    this._cancelValidation();
    
    var tests = this._tests.slice(),
        i     = 0,
        n     = tests.length,
        self  = this;
    
    if (n === 0) return (callback instanceof Function) && callback.call(scope);
    
    var validation = this._currentValidation =
        this._generateValidationObject(eventType);
    
    Acceptance.each(tests, function(test) {
      test(function(result) {
        if (validation.isCancelled()) return;
        if (result === null) validation.indeterminate();
        
        if (result instanceof Array) Acceptance.each(result, function(error) {
          validation.addError(error);
        });

        i += 1;
        if (i < n) return;

        self._valid = validation.isValid();
        self._notifyObservers(validation, callback, scope);
        
      }, validation);
    });
  },
  
  _notifyObservers: function(validation, callback, scope) {
    Acceptance.each(this._callbacks, function(callback) {
      callback[0].call(callback[1], validation);
    });
    
    Acceptance.notifyClient(validation);
    
    if (callback instanceof Function) callback.call(scope);
  },
  
  _cancelValidation: function() {
    if (!this._currentValidation) return;
    this._currentValidation.cancel();
    delete this._currentValidation;
  },
  
  _generateValidationObject: function(eventType) {
    var formData = Acceptance.Dom.getValues(this._form.getForm()),
        value    = formData[this._fieldName];
    
    return Acceptance.Validation.create({
      _form:      this._form.getForm(),
      _input:     this.getInput(),
      _value:     value,
      _data:      formData,
      _eventType: eventType
    });
  }
  
}, {
  _isPresent: function(message) {
    return function(returns, validation) {
      var value = validation.getValue();
      returns( Acceptance.trim(value) ? true : [message] );
    }
  }
});

