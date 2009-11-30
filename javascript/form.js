Acceptance.Form = Acceptance.Class({
  initialize: function(formId) {
    this._formId       = formId;
    this._requirements = {};
    this._invalid      = [];
    this.getForm();
  },
  
  getForm: function() {
    if (this._hasForm()) return this._form;
    
    this._form   = Acceptance.Dom.get(this._formId);
    this._submit = Acceptance.Dom.getInputs(this._form, '', 'submit')[0];
    Acceptance.Event.on(this._form, 'submit', this._handleSubmit, this);
    
    return this._form;
  },
  
  _hasForm: function() {
    return Acceptance.Dom.exists(this._form);
  },
  
  _handleSubmit: function(form, event) {
    if (!this.isValid()) event.stopDefault();
  },
  
  isValid: function() {
    var valid = true;
    Acceptance.each(this._requirements, function(name, field) {
      if (!field.isValid()) valid = false;
    });
    return valid;
  },
  
  getField: function(field) {
    return this._requirements[field] =
            this._requirements[field] ||
            new Acceptance.Field(this, field);
  }
}, {
  _registry: {},
  
  get: function(formId) {
    return this._registry[formId] = this._registry[formId] ||
                                    new this(formId);
  }
});

