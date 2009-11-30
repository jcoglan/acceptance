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
    
    toBeChecked: function(message) {
      var field = this._field;
      field.addTest(function(value) {
        var input = field.getInput();
        return (value === input.value && input.checked) || [message];
      });
      return this;
    },
    
    toBeOneOf: function(list, message) {
      this._field.addTest(function(value) {
        return Acceptance.arrayIncludes(list, value) || [message];
      });
      return this;
    },
    
    toBeNoneOf: function(list, message) {
      this._field.addTest(function(value) {
        return !Acceptance.arrayIncludes(list, value) || [message];
      });
      return this;
    },
    
    toConfirm: function(field, message) {
      this._field.addTest(function(value, data) {
        return (value === data[field]) || [message];
      });
      return this;
    },
    
    toHaveLength: function(options, message) {
      var min = options.minimum, max = options.maximum;
      this._field.addTest(function(value) {
        return (typeof options === 'number' && value.length !== options && [message]) ||
               (min !== undefined && value.length < min && [message]) ||
               (max !== undefined && value.length > max && [message]) ||
               true;
      });
      return this;
    },
    
    toMatch: function(pattern, message) {
      this._field.addTest(function(value) {
        return pattern.test(value) || [message];
      });
      return this;
    }
  })
};

Acceptance.extend(Acceptance, {
  form: Acceptance.DSL.Root.form,
  
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

