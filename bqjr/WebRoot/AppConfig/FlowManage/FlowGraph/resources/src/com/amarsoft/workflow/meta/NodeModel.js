
/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) amarsoft.com 2011</p>
 * @author
 */
function NodeModel() {
    this.base = MetaNodeModel;
    this.base();

    //
    this.setText("Node");
    
    this.FROMS_MAX = MetaNodeModel.NUM_NOT_LIMIT;//add by ymqiao 20101227
    this.TOS_MAX = MetaNodeModel.NUM_NOT_LIMIT;//add by ymqiao 20101227

    //
    this.setSize(new Dimension(80, 30));
}
NodeModel.prototype = new MetaNodeModel();

//
NodeModel.prototype.toString = function () {
	//½Úµã
    return "[\u8282\u70b9:" + this.getText() + "]";
};

//
NodeModel.prototype.type = MetaNodeModel.TYPE_NODE;

