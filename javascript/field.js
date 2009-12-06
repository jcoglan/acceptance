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
  
  isValid: function(eventType, callback, scope) {
    this.validate(eventType, function() {
      callback.call(scope, !!this._valid);
    }, this);
  },
  
  validate: function(eventType, callback, scope) {
    var validation = this._generateValidationObject(eventType),
        tests      = this._tests.slice();
    
    var i = 0, n = tests.length, self = this;
    if (n === 0 && (callback instanceof Function)) return callback.call(scope);
    
    Acceptance.each(tests, function(test) {
      test(function(result) {
        if (result instanceof Array) Acceptance.each(result, function(error) {
          validation.addError(error);
        });

        i += 1;
        if (i < n) return;

        self._valid = validation.isValid();
        
        Acceptance.notifyClient(validation);
        
        if (callback instanceof Function) callback.call(scope);
      }, validation);
    });
    
    Acceptance.each(this._callbacks, function(callback) {
      callback[0].call(callback[1]);
    });
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

