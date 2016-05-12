/**
 * WorkFlow工作空间，报考建立工作空间所需要的资源。
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) amarsoft.com 2011</p>
 * @author
 */

//
/**
 * WorkFlow的工作空间
 */
function WorkFlowWorkSpace() {
}

//
WorkFlowWorkSpace.BASE_PATH = "/A3Web2.6/";

//
WorkFlowWorkSpace.WORK_FLOW_PATH = WorkFlowWorkSpace.BASE_PATH + "AppConfig/FlowManage/FlowGraph/resources/";

//
WorkFlowWorkSpace.DEFAULT_PROCESS_NAME = "default";

//
WorkFlowWorkSpace.URL_ADD_PROCESS = WorkFlowWorkSpace.BASE_PATH + "addprocess.wf";
WorkFlowWorkSpace.URL_DELETE_PROCESS = WorkFlowWorkSpace.BASE_PATH + "deleteprocess.wf";
WorkFlowWorkSpace.URL_GET_PROCESS = WorkFlowWorkSpace.BASE_PATH + "getprocess.wf";
WorkFlowWorkSpace.URL_LIST_PROCESS = WorkFlowWorkSpace.BASE_PATH + "listprocess.wf";
WorkFlowWorkSpace.URL_UPDATE_PROCESS = WorkFlowWorkSpace.BASE_PATH + "updateprocess.wf";
//

//
WorkFlowWorkSpace.STATUS_NULL = -1;
WorkFlowWorkSpace.STATUS_SUCCESS = 0;
WorkFlowWorkSpace.STATUS_FAIL = 1;
WorkFlowWorkSpace.STATUS_FILE_EXIST = 3;
WorkFlowWorkSpace.STATUS_FILE_NOT_FOUND = 5;
WorkFlowWorkSpace.STATUS_XML_PARSER_ERROR = 7;
WorkFlowWorkSpace.STATUS_IO_ERROR = 9;

//
WorkFlowWorkSpace.ID = 1;

//
WorkFlowWorkSpace.META_NODE_MOVED_STEP_TIME = 100;
WorkFlowWorkSpace.META_NODE_MOVED_STEP = 1;

//
WorkFlowWorkSpace.META_NODE_MAX = 30;

//
WorkFlowWorkSpace.META_NODE_MIN_WIDTH = 80;
WorkFlowWorkSpace.META_NODE_MIN_HEIGHT = 30;

//
/**
 * 建立工作空间
 */
WorkFlowWorkSpace.build = function () {
 	//引入所需要的资源，资源加载顺序不能更改

	//com.amarsoft.util
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/util/Message.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/util/Array.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/util/String.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/util/List.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/util/Observable.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/util/Observer.js");

	//com.amarsoft.geom
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/geom/Point.js");

	//com.amarsoft.html
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/html/Toolkit.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/html/Browser.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/html/Cursor.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/html/MouseEvent.js");

	//com.amarsoft.xml
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/xml/XMLDocument.js");

	//com.amarsoft.ajax
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/ajax/Ajax.js");

	//com.amarsoft.ui.event
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/ui/event/KeyListener.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/ui/event/MouseListener.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/ui/event/MouseWheelListener.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/ui/event/ContextMenuListener.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/ui/event/ListenerProxy.js");

	//com.amarsoft.ui
    BuildLibrary.loadCSS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/ui/ui.css");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/ui/Dimension.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/ui/Component.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/ui/Button.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/ui/ButtonModel.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/ui/ToggleButton.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/ui/ToggleButtonModel.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/ui/ButtonGroup.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/ui/ToolBar.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/ui/Panel.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/ui/ScrollPanel.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/ui/Label.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/ui/Frame.js");

	//com.amarsoft.geom.ui
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/geom/ui/GeometryCanvas.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/geom/ui/LineView.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/geom/ui/LineTextView.js");

    //com.amarsoft.workflow.meta.event
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/meta/event/MetaNodeMouseListener.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/meta/event/MetaNodeTextMouseListener.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/meta/event/MetaNodeTextKeyListener.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/meta/event/TransitionMouseListener.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/meta/event/MetaNodeResizeMouseListener.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/meta/event/TransitionTextMouseListener.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/meta/event/TransitionTextKeyListener.js");

    //com.amarsoft.workflow.meta
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/meta/DragablePanel.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/meta/MetaModel.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/meta/MetaNodeModel.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/meta/MetaNode.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/meta/StartNodeModel.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/meta/StartNode.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/meta/EndNodeModel.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/meta/EndNode.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/meta/NodeModel.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/meta/Node.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/meta/ForkNodeModel.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/meta/ForkNode.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/meta/JoinNodeModel.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/meta/JoinNode.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/meta/TransitionCompass.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/meta/TransitionModel.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/meta/Transition.js");

    //com.amarsoft.workflow.event
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/event/WrapperMetaMouseListener.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/event/WrapperSelectMouseListener.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/event/MetaMoveMouseListener.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/event/MetaMoveKeyListener.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/event/WrapperTransitionMouseListener.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/event/DeleteMetaActionListener.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/event/SaveActionListener.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/event/HelpActionListener.js");

    //com.amarsoft.workflow.process
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/process/AddProcess.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/process/GetProcess.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/process/UpdateProcess.js");

    //com.amarsoft.workflow
    BuildLibrary.loadCSS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/workflow.css");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/WorkFlowToolBar.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/StateMonitor.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/TransitionMonitor.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/WorkFlowViewer.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/WorkFlowTableViewer.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/WorkFlowXMLViewer.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/StatusLabel.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/WorkFlowModel.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/WorkFlowModelConverter.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/WorkFlow.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/WorkFlowWrapper.js");
    BuildLibrary.loadJS(WorkFlowWorkSpace.WORK_FLOW_PATH + "src/com/amarsoft/workflow/WorkFlowViewPattern.js");
    
};

//
/**
 * 资源加载
 */
function BuildLibrary() {
}
BuildLibrary.loadJS = function (url, charset) {
    if (!charset) {
        charset = "UTF-8";
    }
    var charsetProperty = " charset=\"" + charset + "\" ";
    document.write("<script type=\"text/javascript\" src=\"" + url + "\" onerror=\"alert('Error loading ' + this.src);\"" + charsetProperty + "></script>");
};
BuildLibrary.loadCSS = function (url, charset) {
    if (!charset) {
        charset = "UTF-8";
    }
    var charsetProperty = " charset=\"" + charset + "\" ";
    document.write("<link href=\"" + url + "\" type=\"text/css\" rel=\"stylesheet\" onerror=\"alert('Error loading ' + this.src);\"" + charsetProperty + "/>");
};

