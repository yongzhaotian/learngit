
/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) amarsoft.com 2011</p>
 * @author
 */
function StartNodeModel() {
    this.base = MetaNodeModel;
    this.base();

    //
    this.TOS_MAX = 0;
    this.FROMS_MAX = MetaNodeModel.NUM_NOT_LIMIT;//add by ymqiao 20101227
    this.setText("StartNode");

    //
    this.setSize(new Dimension(80, 30));
}
StartNodeModel.prototype = new MetaNodeModel();

//
StartNodeModel.prototype.toString = function () {
	//¿ªÊ¼
    return "[\u5f00\u59cb:" + this.getText() + "]";
};

//
StartNodeModel.prototype.type = MetaNodeModel.TYPE_START_NODE;

