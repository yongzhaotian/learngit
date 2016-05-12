
/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) amarsoft.com 2011</p>
 * @author
 */
function ForkNodeModel() {
    this.base = MetaNodeModel;
    this.base();

    //
    this.FROMS_MAX = MetaNodeModel.NUM_NOT_LIMIT;
    this.TOS_MAX = MetaNodeModel.NUM_NOT_LIMIT;//add by ymqiao 20101227
    this.setText("ForkNode");

    //
    this.setSize(new Dimension(80, 30));
}
ForkNodeModel.prototype = new MetaNodeModel();

//
ForkNodeModel.prototype.toString = function () {
	//½áÊø
    return "[\u5206\u652f:" + this.getText() + "]";
};

//
ForkNodeModel.prototype.type = MetaNodeModel.TYPE_FORK_NODE;

