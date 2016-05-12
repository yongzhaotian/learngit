
/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) amarsoft.com 2011</p>
 * @author
 */
function EndNodeModel() {
    this.base = MetaNodeModel;
    this.base();

    //
    this.FROMS_MAX = 0;
    this.TOS_MAX = MetaNodeModel.NUM_NOT_LIMIT;//add by ymqiao 20101227
    
    this.setText("EndNode");

    //
    this.setSize(new Dimension(80, 30));
}
EndNodeModel.prototype = new MetaNodeModel();

//
EndNodeModel.prototype.toString = function () {
	//½áÊø
    return "[\u7ed3\u675f:" + this.getText() + "]";
};

//
EndNodeModel.prototype.type = MetaNodeModel.TYPE_END_NODE;

