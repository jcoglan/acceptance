Acceptance.Dom = {
  INPUT_TAGS: ['input', 'textarea', 'select'],
  
  get: function(id) {
    return document.getElementById(id);
  },
  
  exists: function(element) {
    if (!element) return false;
    while (element.parentNode) {
      if (element.tagName.toLowerCase() === 'body') return true;
      element = element.parentNode;
    }
    return false;
  },
  
  getInputs: function(form, name, type) {
    var results = [];
    Acceptance.each(this.INPUT_TAGS, function(tagName) {
      var inputs = form.getElementsByTagName(tagName),
          i = inputs.length;
      
      while (i--) {
        if (name && inputs[i].name !== name) continue;
        if (type && inputs[i].type !== type) continue;
        results.push(inputs[i]);
      }
    });
    return results;
  },
  
  getValues: function(form) {
    var data = {};
    Acceptance.each(this.getInputs(form), function(input) {
      data[input.name] = input.value;
    });
    return data;
  },
  
  set: function(element, attributes) {
    if (!element) return;
    Acceptance.each(attributes, function(key, value) {
      switch (true) {
        case value === true:    element.setAttribute(key, key); break;
        case value === false:   element.removeAttribute(key);   break;
        
        default: element.setAttribute(key, value);
      }
    });
  }
};
