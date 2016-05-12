
/**
 * <p>Title: ForkNode</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) amarsoft.com 2011</p>
 * @author
 */
function ForkNode(model, wrapper) {
    this.base = MetaNode;
    var imageUrl = WorkFlowWorkSpace.WORK_FLOW_PATH + "images/workflow/fork.gif";
    this.base(model, imageUrl, wrapper);
}
ForkNode.prototype = new MetaNode();

