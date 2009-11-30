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
      return new Acceptance.DSL.Requirement(field);
    }
  }),
  
  Requirement: Acceptance.Class({
    initialize: function(field) {
      this._field = field;
    },
    
    requires: function() {
      var proxy = new Acceptance.DSL.Description(this._field._form);
      return proxy.requires.apply(proxy, arguments);
    },
    
    // TODO fix messages
    toHaveLength: function(options, message) {
      var min = options.minimum, max = options.maximum;
      this._field.addTest(function(value) {
        return (typeof options == 'number' && value.length != options &&
                    [message || 'must contain exactly ' + options + ' characters']) ||
                (min !== undefined && value.length < min &&
                    [message || 'must contain at least ' + min + ' characters']) ||
                (max !== undefined && value.length > max &&
                    [message || 'must contain no more than ' + max + ' characters']) ||
                true;
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

