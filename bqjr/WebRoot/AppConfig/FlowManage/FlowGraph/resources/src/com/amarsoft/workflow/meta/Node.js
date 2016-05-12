
/**
 * <p>Title: Node</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) amarsoft.com 2011</p>
 * @author
 */
function Node(model, wrapper) {
    this.base = MetaNode;
    var imageUrl = WorkFlowWorkSpace.WORK_FLOW_PATH + "images/workflow/node.gif";
    this.base(model, imageUrl, wrapper);
}
Node.prototype = new MetaNode();

