
/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) amarsoft.com 2011</p>
 * @author
 */
function JoinNodeModel() {
    this.base = MetaNodeModel;
    this.base();

    //
    this.TOS_MAX = MetaNodeModel.NUM_NOT_LIMIT;
    this.FROMS_MAX = MetaNodeModel.NUM_NOT_LIMIT;//add by ymqiao 20101227
    this.setText("JoinNode");

    //
    this.setSize(new Dimension(80, 30));
}
JoinNodeModel.prototype = new MetaNodeModel();

//
JoinNodeModel.prototype.toString = function () {
	//汇聚
    return "[\u6c47\u805a:" + this.getText() + "]";
};

//
JoinNodeModel.prototype.type = MetaNodeModel.TYPE_JOIN_NODE;

