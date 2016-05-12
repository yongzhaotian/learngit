
//
/**
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) amarsoft.com 2011</p>
 * @author
 */
function WrapperMetaMouseListener(wrapper) {
    this.wrapper = wrapper;
}
WrapperMetaMouseListener.prototype = new MouseListener();
WrapperMetaMouseListener.prototype.onClick = function (e) {
    var state = this.wrapper.getStateMonitor().getState();
    if (state == StateMonitor.SELECT) {
        return;
    }

	//
    var viewer = this.wrapper.getViewer();
    var workFlowModel = this.wrapper.getModel();
    var point = Toolkit.getContainerCoord(e, viewer);

    //
    var metaNodeModel = null;
    switch (state) {
      case StateMonitor.NODE:
        metaNodeModel = new NodeModel();
        break;
      case StateMonitor.FORK_NODE:
        metaNodeModel = new ForkNodeModel();
        break;
      case StateMonitor.JOIN_NODE:
        metaNodeModel = new JoinNodeModel();
        break;
      case StateMonitor.START_NODE:
        metaNodeModel = new StartNodeModel();
        break;
      case StateMonitor.END_NODE:
        metaNodeModel = new EndNodeModel();
        break;
      default:
        break;
    }
    if (metaNodeModel !== null) {
        if (workFlowModel.getMetaNodeModels().size() >= WorkFlowWorkSpace.META_NODE_MAX) {
        	//�ڵ������ܳ���:
            alert("\u8282\u70b9\u6570\u4e0d\u80fd\u8d85\u8fc7:" + WorkFlowWorkSpace.META_NODE_MAX);
            return;
        }
        metaNodeModel.setPosition(point);
        workFlowModel.addMetaNodeModel(metaNodeModel);
        this.wrapper.getStateMonitor().resetState(StateMonitor.SELECT);
        //�ɹ������һ���ڵ㣬������˫���ڵ�༭�ڵ�����
        this.wrapper.setStatusInfo("\u6210\u529f\u6dfb\u52a0\u4e86\u4e00\u4e2a\u8282\u70b9\uff0c\u60a8\u53ef\u4ee5\u53cc\u51fb\u8282\u70b9\u7f16\u8f91\u8282\u70b9\u540d\u79f0");
    }
};

