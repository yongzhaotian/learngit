function StringBuffer() {  
    this._objArray = [];  
    this._undoFlag = false;  
};  
  
StringBuffer.prototype.toString = function() {  
    if(this._objArray.length==0) {  
        return '';  
    }  
    var str = this._objArray.join('');  
    if(this._objArray.length > 1) {  
        this.clear();  
        this.append(str);  
    }  
    this._undoFlag = false;  
    return str;  
};  
  
StringBuffer.prototype.append = function(object) {  
    this._objArray[this._objArray.length] = object;  
    this._undoFlag = true;  
    return this;  
};  
  
StringBuffer.prototype.clear = function() {  
    this._objArray.length = 0;  
    this._undoFlag = false;  
};  
  
StringBuffer.prototype.undoLastAppend = function() {  
    if(this._undoFlag) {  
        this._objArray.length = this._objArray.length -1;  
        this._undoFlag = false;  
    }  
};  
  
StringBuffer.prototype.setSize = function(size) {  
    if(size==null || size<=0) {  
        this.clear();  
        return;  
    }  
    var str = this._objArray.join('');  
    if(size < str.length) {  
        str = str.substring(0, size);  
        this.clear();  
        this.append(str);  
    } else if(this._objArray.length > 1) {  
        this.clear();  
        this.append(str);  
    }  
    this._undoFlag = false;  
};  
  
StringBuffer.prototype.getSize = function() {  
    var str = this.toString();  
    return str.length;  
}; 