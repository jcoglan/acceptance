Acceptance.DSL = {
  Root: {
    form: function(id) {
      var description = Acceptance.Description.get(id);
      return new Acceptance.DSL.Description(description);
    }
  },
  
  Description: Acceptance.Class({
    initialize: function(form) {
      this._form = form;
    },
    
    requires: function(field, message) {
      var requirement = this._form.getRequirement(field);
      requirement.setMessage(message);
      return new Acceptance.DSL.Requirement(requirement);
    }
  }),
  
  Requirement: Acceptance.Class({
    initialize: function(field) {
      this._field = field;
    }
  })
};

Acceptance.extend(Acceptance, {
  form: Acceptance.DSL.Root.form,
  
  onValidation: function(block, context) {
    this._validationHook = [block, context];
  },
  
  notifyClient: function(requirement, errors) {
    var callback = this._validationHook;
    if (!callback) return;
    
    callback[0].call(callback[1], {
      form:   requirement._form.getForm(),
      input:  requirement.getInput(),
      name:   requirement._fieldName,
      valid:  requirement._valid,
      errors: errors.slice()
    });
  }
});

