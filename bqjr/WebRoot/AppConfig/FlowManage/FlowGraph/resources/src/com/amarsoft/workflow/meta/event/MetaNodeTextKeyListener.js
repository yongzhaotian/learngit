
//
/**
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) amarsoft.com 2011</p>
 * @author
 */
function MetaNodeTextKeyListener(metaNode, wrapper) {
    this.metaNode = metaNode;
    this.wrapper = wrapper;
}
MetaNodeTextKeyListener.prototype = new KeyListener();
MetaNodeTextKeyListener.prototype.onKeyUp = function (e) {
    var state = this.wrapper.getStateMonitor().getState();
    if (state != StateMonitor.SELECT) {
        return;
    }
    var charCode = (e.charCode) ? e.charCode : e.keyCode;
    //enter key
    if (charCode == 13) {
        this.metaNode.stopEdit();
    }
};

