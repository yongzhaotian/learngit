
/**
 * <p>Title: ScrollPanel</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) amarsoft.com 2011</p>
 * @author
 */
function Label(ui) {
    this.base = Panel;
    this.base(ui);
    this.setClassName("NAME_XIO_UI_FONT NAME_XIO_UI_LABEL");
}
Label.prototype = new Panel();
Label.prototype.toString = function () {
    return "[Component,Panel,Label]";
};

