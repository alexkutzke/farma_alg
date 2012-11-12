// My Library
$.fn.getCursorPosition = function() {
   var pos = 0;
   var el = $(this).get(0);
   // IE Support
   if (document.selection) {
      el.focus();
      var Sel = document.selection.createRange();
      var SelLength = document.selection.createRange().text.length;
      Sel.moveStart('character', -el.value.length);
      pos = Sel.text.length - SelLength;
   }
   // Firefox support
   else if (el.selectionStart || el.selectionStart == '0')
      pos = el.selectionStart;

   return pos;
}

jQuery.fn.setSelection = function(selectionStart, selectionEnd) {
    if(this.lengh == 0) return this;
    input = this[0];

    if (input.createTextRange) {
        var range = input.createTextRange();
        range.collapse(true);
        range.moveEnd('character', selectionEnd);
        range.moveStart('character', selectionStart);
        range.select();
    } else if (input.setSelectionRange) {
        input.focus();
        input.setSelectionRange(selectionStart, selectionEnd);
    }

    return this;
}

$.fn.insertAtCursor = function(val) {
   var startPos = this.getCursorPosition();
   var endPos = this.getCursorPosition();
   var value = $(this).val().substring(0, startPos)
         + val
         + $(this).val().substring(endPos, $(this).val().length);

   $(this).val(value);
   var cursor = startPos + val.length;
   $(this).setSelection(cursor, cursor);
}

/** Table */
$.fn.row = function(i) {
    return $('tr:nth-child('+(i+1)+') td', this);
}

$.fn.column = function(i) {
    return $('tr td:nth-child('+(i+1)+')', this);
}

jQuery.extend({
    deepclone: function(objThing) {
        // return jQuery.extend(true, {}, objThing);
        /// Fix for arrays, without this, arrays passed in are returned as OBJECTS! WTF?!?!
        if ( jQuery.isArray(objThing) ) {
            return jQuery.makeArray( jQuery.deepclone($(objThing)) );
        }
        return jQuery.extend(true, {}, objThing);
    },
});
