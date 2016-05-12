
/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) amarsoft.com 2011</p>
 * @author
 */
function WorkFlowXMLViewer() {
    this.base = ScrollPanel;
    this.base();

    //
    this.setClassName("NAME_XIO_UI_FONT NAME_XIO_XIORKFLOW_XML_VIEWER");

    //
    this.pre = Toolkit.newElement("pre");
    this.getUI().appendChild(this.pre);
}
WorkFlowXMLViewer.prototype = new ScrollPanel();
WorkFlowXMLViewer.prototype.refresh = function (model) {
    this.pre.innerText = "";

	//
    var doc = WorkFlowModelConverter.convertModelToXML(model);

    //
    this.pre.innerText = doc.xml;
};

