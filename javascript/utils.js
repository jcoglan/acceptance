Acceptance = {
  each: function(object, block, context) {
    if (object instanceof Array) {
      for (var i = 0, n = object.length; i < n; i += 1) {
        block.call(context, object[i], i);
      }
    } else if (object instanceof Object) {
      for (var key in object ) {
        if (object.hasOwnProperty(key))
          block.call(context, key, object[key]);
      }
    }
  },
  
  trim: function(string) {
    if (!string) return '';
    return string.replace(/^\s*/g, '').replace(/\s*$/g, '');
  },
  
  extend: function(target, source) {
    if (!target || !source) return target;
    this.each(source, function(key, value) {
      if (target[key] !== value) target[key] = value;
    });
    return target;
  },
  
  Class: function(prototype, classMethods) {
    var klass = function() {
      this.initialize.apply(this, arguments);
    };
    this.extend(klass.prototype, prototype);
    this.extend(klass, classMethods);
    
    klass.prototype.klass = klass;
    return klass;
  }
};

