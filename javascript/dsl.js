Acceptance.DSL = {
  Root: {
    form: function(id) {
      var form = Acceptance.Form.get(id);
      return new Acceptance.DSL.Description(form);
    }
  },
  
  Description: Acceptance.Class({
    initialize: function(form) {
      this._form = form;
    },
    
    requires: function(field, message) {
      var field = this._form.getField(field);
      field.setMessage(message);
      return new Acceptance.DSL.Requirement(this, field);
    },
    
    onValidation: function(field, callback, scope) {
      var field = this._form.getField(field);
      field.onValidation(callback, scope);
      return this;
    }
  }),
  
  Requirement: Acceptance.Class({
    initialize: function(description, field) {
      this._description = description;
      this._field = field;
    },
    
    requires: function() {
      var proxy = this._description;
      return proxy.requires.apply(proxy, arguments);
    },
    
    toBeChecked: function(message) {
      this._field.addTest(function(result, validation) {
        var input = validation.getInput();
        result( input.checked || [message] );
      });
      return this;
    },
    
    toBeOneOf: function(list, message, options) {
      options = options || {};
      this._field.addTest(function(result, validation) {
        var value = Acceptance.trim(validation.getValue());
        if (options.allowBlank && !Acceptance.trim(value)) return result( true );
        result( Acceptance.arrayIncludes(list, value) || [message] );
      });
      return this;
    },
    
    toBeNoneOf: function(list, message) {
      this._field.addTest(function(result, validation) {
        var value = Acceptance.trim(validation.getValue());
        result( !Acceptance.arrayIncludes(list, value) || [message] );
      });
      return this;
    },
    
    toConfirm: function(field, message) {
      var targetValid = false;
      
      this._description.onValidation(field, function(validation) {
        targetValid = validation.isValid();
        if (this._field.isTouched()) this._field.validate('change');
      }, this);
      
      this._field.addTest(function(result, validation) {
        if (!targetValid) return result( null );
        var value = validation.getValue();
        result( (value === validation.get(field)) || [message] );
      });
      return this;
    },
    
    toHaveLength: function(settings, options) {
      var min         = settings.minimum,
          max         = settings.maximum,
          options     = options || {},
          tooShort    = options.message || options.tooShort,
          tooLong     = options.message || options.tooLong,
          wrongLength = options.message || options.wrongLength;
      
      this._field.addTest(function(result, validation) {
        var value = validation.getValue(), length = value.length;
        
        if (options.allowBlank && !Acceptance.trim(value))
          return result( true );
        
        if (min !== undefined && length < min)
          return result( [Acceptance.interpolate(tooShort, {count: min})] );
        
        if (max !== undefined && length > max)
          return result( [Acceptance.interpolate(tooLong, {count: max})] );
        
        if (typeof settings === 'number' && length !== settings)
          return result( [Acceptance.interpolate(wrongLength, {count: settings})] );
        
        result( true );
      });
      return this;
    },
    
    toMatch: function(pattern, message, options) {
      options = options || {};
      this._field.addTest(function(result, validation) {
        var value = validation.getValue();
        if (options.allowBlank && !Acceptance.trim(value)) return result( true );
        result( pattern.test(value) || [message] );
      });
      return this;
    }
  })
};

Acceptance.extend(Acceptance, {
  form: Acceptance.DSL.Root.form,
  
  macro: function(name, tester) {
    Acceptance.DSL.Requirement.prototype[name] = function() {
      this._field.addTest(tester.apply(this, arguments));
      return this;
    };
  },
  
  onValidation: function(block, context) {
    this._validationHook = [block, context];
  },
  
  notifyClient: function(validation) {
    var callback = this._validationHook;
    if (!callback) return;
    
    callback[0].call(callback[1], validation);
  }
});

