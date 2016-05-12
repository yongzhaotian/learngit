
//
/**
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) amarsoft.com 2011</p>
 * @author
 */
function MetaNodeTextMouseListener(metaNode, wrapper) {
    this.metaNode = metaNode;
    this.wrapper = wrapper;
}
MetaNodeTextMouseListener.prototype = new MouseListener();
MetaNodeTextMouseListener.prototype.onDblClick = function (e) {
    var state = this.wrapper.getStateMonitor().getState();
    if (state != StateMonitor.SELECT) {
        return;
    }
    this.wrapper.getModel().clearSelectedMetaNodeModels();
    this.metaNode.startEdit();
};

//add by ymqiao 20101231
MetaNodeTextMouseListener.prototype.onMouseOver = function (e) {
	var state = this.wrapper.getStateMonitor().getState();
    if (state != StateMonitor.SELECT) {
        return;
    }
    //this.wrapper.getModel().clearSelectedMetaNodeModels();
    this.metaNode.showTips();
};

MetaNodeTextMouseListener.prototype.onMouseOut = function (e) {
	var state = this.wrapper.getStateMonitor().getState();
    if (state != StateMonitor.SELECT) {
        return;
    }
    //this.wrapper.getModel().clearSelectedMetaNodeModels();
    this.metaNode.hideTips();
};

