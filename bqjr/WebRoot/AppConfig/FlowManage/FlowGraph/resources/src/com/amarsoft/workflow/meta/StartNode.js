
/**
 * <p>Title: StartNode</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) amarsoft.com 2011</p>
 * @author
 */
function StartNode(model, wrapper) {
    this.base = MetaNode;
    var imageUrl = WorkFlowWorkSpace.WORK_FLOW_PATH + "images/workflow/start.gif";
    this.base(model, imageUrl, wrapper);
}
StartNode.prototype = new MetaNode();

