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
    
    addTest: function(tester) {
      this._field.addTest(tester);
      return this;
    },
    
    toBeChecked: function(message) {
      var field = this._field;
      return this.addTest(function(returns, value) {
        var input = field.getInput();
        returns( (value === input.value && input.checked) || [message] );
      });
    },
    
    toBeOneOf: function(list, message) {
      return this.addTest(function(returns, value) {
        returns( Acceptance.arrayIncludes(list, value) || [message] );
      });
    },
    
    toBeNoneOf: function(list, message) {
      return this.addTest(function(returns, value) {
        returns( !Acceptance.arrayIncludes(list, value) || [message] );
      });
    },
    
    toConfirm: function(field, message) {
      return this.addTest(function(returns, value, data) {
        returns( (value === data[field]) || [message] );
      });
    },
    
    toHaveLength: function(options, message) {
      var min = options.minimum, max = options.maximum;
      return this.addTest(function(returns, value) {
        returns ( (typeof options === 'number' && value.length !== options && [message]) ||
                  (min !== undefined && value.length < min && [message]) ||
                  (max !== undefined && value.length > max && [message]) ||
                  true
                );
      });
    },
    
    toMatch: function(pattern, message) {
      return this.addTest(function(returns, value) {
        returns( pattern.test(value) || [message] );
      });
    }
  })
};

Acceptance.extend(Acceptance, {
  form: Acceptance.DSL.Root.form,
  
  macro: function(name, tester) {
    Acceptance.DSL.Requirement.prototype[name] = tester;
  },
  
  onValidation: function(block, context) {
    this._validationHook = [block, context];
  },
  
  notifyClient: function(field, errors) {
    var callback = this._validationHook;
    if (!callback) return;
    
    callback[0].call(callback[1], {
      form:   field._form.getForm(),
      input:  field.getInput(),
      name:   field._fieldName,
      valid:  field._valid,
      errors: errors.slice()
    });
  }
});

