
/**
 * <p>Title: EndNode</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) amarsoft.com 2011</p>
 * @author
 */
function EndNode(model, wrapper) {
    this.base = MetaNode;
    var imageUrl = WorkFlowWorkSpace.WORK_FLOW_PATH + "images/workflow/end.gif";
    this.base(model, imageUrl, wrapper);
}
EndNode.prototype = new MetaNode();

