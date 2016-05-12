
/**
 * <p>Title:JoinNode</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) amarsoft.com 2011</p>
 * @author
 */
function JoinNode(model, wrapper) {
    this.base = MetaNode;
    var imageUrl = WorkFlowWorkSpace.WORK_FLOW_PATH + "images/workflow/join.gif";
    this.base(model, imageUrl, wrapper);
}
JoinNode.prototype = new MetaNode();

