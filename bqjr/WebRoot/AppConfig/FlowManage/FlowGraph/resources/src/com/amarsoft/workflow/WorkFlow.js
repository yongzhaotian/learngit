
/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) amarsoft.com 2011</p>
 * @author
 */
function WorkFlow(ui) {
    this.base = Frame;
    this.base(ui);
    this.ui.style.overflow = "auto";

    //
    this.stateMonitor = new StateMonitor();
    this.workFlowToolBar = new WorkFlowToolBar(this);
    this.add(this.workFlowToolBar);
    this.stateMonitor.addObserver(this.workFlowToolBar);

    //
    this.workFlowViewer = new WorkFlowViewer();
    this.workFlowViewer.setWidth("100%");
    this.workFlowViewer.setHeight("100%");
    this.viewerRow = this.add(this.workFlowViewer);

    //
    this.tableViewer = new WorkFlowTableViewer();
    this.tableViewer.setWidth("100%");
    this.tableViewer.setHeight("100%");
    this.tableViewerRow = this.add(this.tableViewer);
    this.tableViewer.setDisplay("none");

    //
    this.statusPanel = new StatusLabel();
    //��ӭʹ�ù���������ϵͳ
    this.statusPanel.setText("\u6b22\u8fce\u4f7f\u7528\u5de5\u4f5c\u6d41\u5b9a\u5236\u7cfb\u7edf");
    this.add(this.statusPanel);

	//
    this.workFlowToolBar.getNodeButtonGroup().addObserver(this);
    this.workFlowToolBar.getViewerPatternButtonGroup().addObserver(this);

    //
    this.workFlowWrapper = new WorkFlowWrapper(this.workFlowViewer, null, this.stateMonitor, this.statusPanel);
    this.tableViewer.setModel(this.workFlowWrapper.getModel());
}
WorkFlow.prototype = new Frame();

//
WorkFlow.prototype.getToolBar = function () {
    return this.workFlowToolBar;
};
WorkFlow.prototype.getStatusLabel = function () {
    return this.statusPanel;
};
WorkFlow.prototype.getWrapper = function () {
    return this.workFlowWrapper;
};
WorkFlow.prototype.getTableViewer = function () {
    return this.tableViewer;
};
WorkFlow.prototype.setProcessList = function (processList) {
    this.processList = processList;
};
WorkFlow.prototype.getProcessList = function () {
    return this.processList;
};

//
WorkFlow.prototype.update = function (observable, arg) {
    if (arg == ButtonGroup.PRESSED_CHANGED) {
        if (observable == this.getToolBar().getNodeButtonGroup()) {
            var pressedButtonModel = this.getToolBar().getNodeButtonGroup().getPressedButtonModel();
            var modelName = pressedButtonModel.name;
            switch (modelName) {
              case WorkFlowToolBar.BUTTON_NAME_SELECT:
                this.stateMonitor.setState(StateMonitor.SELECT);
                //����ǰ����ѡ��״̬������ڵ㼴��ѡ��ڵ㣬����ctrl�����Ը�ѡ
                this.statusPanel.setText("\u60a8\u5f53\u524d\u5904\u4e8e\u9009\u62e9\u72b6\u6001\uff0c\u70b9\u51fb\u8282\u70b9\u5373\u53ef\u9009\u62e9\u8282\u70b9\uff0c\u6309\u4e0bctrl\u952e\u53ef\u4ee5\u590d\u9009");
                break;
              case WorkFlowToolBar.BUTTON_NAME_START_NODE:
                this.stateMonitor.setState(StateMonitor.START_NODE);
                //����ǰ������ӿ�ʼ�ڵ�״̬���ڿ��ӻ��༭����������ӿ�ʼ�ڵ�
                this.statusPanel.setText("\u60a8\u5f53\u524d\u5904\u4e8e\u6dfb\u52a0\u5f00\u59cb\u8282\u70b9\u72b6\u6001\uff0c\u5728\u53ef\u89c6\u5316\u7f16\u8f91\u533a\u70b9\u51fb\u9f20\u6807\u6dfb\u52a0\u5f00\u59cb\u8282\u70b9");
                break;
              case WorkFlowToolBar.BUTTON_NAME_END_NODE:
                this.stateMonitor.setState(StateMonitor.END_NODE);
                //����ǰ������ӽ����ڵ�״̬���ڿ��ӻ��༭����������ӽ����ڵ�
                this.statusPanel.setText("\u60a8\u5f53\u524d\u5904\u4e8e\u6dfb\u52a0\u7ed3\u675f\u8282\u70b9\u72b6\u6001\uff0c\u5728\u53ef\u89c6\u5316\u7f16\u8f91\u533a\u70b9\u51fb\u9f20\u6807\u6dfb\u52a0\u7ed3\u675f\u8282\u70b9");
                break;
              case WorkFlowToolBar.BUTTON_NAME_FORK_NODE:
                this.stateMonitor.setState(StateMonitor.FORK_NODE);
                //����ǰ������ӷ�֧�ڵ�״̬���ڿ��ӻ��༭����������ӷ�֧�ڵ�
                this.statusPanel.setText("\u60a8\u5f53\u524d\u5904\u4e8e\u6dfb\u52a0\u5206\u652f\u8282\u70b9\u72b6\u6001\uff0c\u5728\u53ef\u89c6\u5316\u7f16\u8f91\u533a\u70b9\u51fb\u9f20\u6807\u6dfb\u52a0\u5206\u652f\u8282\u70b9");
                break;
              case WorkFlowToolBar.BUTTON_NAME_JOIN_NODE:
                this.stateMonitor.setState(StateMonitor.JOIN_NODE);
                //����ǰ������ӻ�۽ڵ�״̬���ڿ��ӻ��༭����������ӻ�۽ڵ�
                this.statusPanel.setText("\u60a8\u5f53\u524d\u5904\u4e8e\u6dfb\u52a0\u6c47\u805a\u8282\u70b9\u72b6\u6001\uff0c\u5728\u53ef\u89c6\u5316\u7f16\u8f91\u533a\u70b9\u51fb\u9f20\u6807\u6dfb\u52a0\u6c47\u805a\u8282\u70b9");
                break;
              case WorkFlowToolBar.BUTTON_NAME_NODE:
                this.stateMonitor.setState(StateMonitor.NODE);
                //����ǰ�����������ڵ�״̬���ڿ��ӻ��༭���������������ڵ�
                this.statusPanel.setText("\u60a8\u5f53\u524d\u5904\u4e8e\u6dfb\u52a0\u4efb\u52a1\u8282\u70b9\u72b6\u6001\uff0c\u5728\u53ef\u89c6\u5316\u7f16\u8f91\u533a\u70b9\u51fb\u9f20\u6807\u6dfb\u52a0\u4efb\u52a1\u8282\u70b9");
                break;
              case WorkFlowToolBar.BUTTON_NAME_TRANSITION:
                this.stateMonitor.setState(StateMonitor.TRANSITION);
                //����ǰ�����������״̬���ڽڵ��ϰ�����꣬��ק������һ���ڵ㣬�����ڵ㽨������
                this.statusPanel.setText("\u60a8\u5f53\u524d\u5904\u4e8e\u6dfb\u52a0\u8fde\u63a5\u72b6\u6001\uff0c\u5728\u8282\u70b9\u4e0a\u6309\u4e0b\u9f20\u6807\uff0c\u6258\u62fd\u5230\u53e6\u5916\u4e00\u4e2a\u8282\u70b9\uff0c\u4e24\u4e2a\u8282\u70b9\u5efa\u7acb\u8fde\u63a5");
                break;
              default:
                break;
            }
            return;
        }

        //
        if (observable == this.getToolBar().getViewerPatternButtonGroup()) {
            var pressedButtonModel = this.getToolBar().getViewerPatternButtonGroup().getPressedButtonModel();
            var modelName = pressedButtonModel.name;
            switch (modelName) {
              case WorkFlowToolBar.BUTTON_NAME_DESIGN:
                this.workFlowViewer.setDisplay("");
                this.viewerRow.style.display = "";
                this.workFlowViewer.setHeight("100%");
                this.viewerRow.height = "100%";
                this.tableViewer.setDisplay("none");
                this.tableViewerRow.style.display = "none";
                this.getToolBar().setDesignButtonEnable(true);
                //����ǰ���������ͼ������ͼ�ǿ��ӻ��༭״̬
                this.getStatusLabel().setText("\u60a8\u5f53\u524d\u5904\u4e8e\u8bbe\u8ba1\u89c6\u56fe\uff0c\u8be5\u89c6\u56fe\u662f\u53ef\u89c6\u5316\u7f16\u8f91\u72b6\u6001");
                break;
              case WorkFlowToolBar.BUTTON_NAME_TABLE:
                this.workFlowViewer.setDisplay("none");
                this.viewerRow.style.display = "none";
                this.tableViewer.setDisplay("");
                this.tableViewerRow.style.display = "";
                this.tableViewer.setHeight("100%");
                this.tableViewerRow.height = "100%";
                this.getToolBar().setDesignButtonEnable(false);
                //����ǰ���ڱ����ͼ������ͼ�ǹ�������ͼ���ݵı�����״̬
                this.getStatusLabel().setText("\u60a8\u5f53\u524d\u5904\u4e8e\u8868\u683c\u89c6\u56fe\uff0c\u8be5\u89c6\u56fe\u662f\u5de5\u4f5c\u6d41\u7a0b\u56fe\u6570\u636e\u7684\u8868\u683c\u6d4f\u89c8\u72b6\u6001");
                break;
              case WorkFlowToolBar.BUTTON_NAME_MIX:
                this.workFlowViewer.setDisplay("");
                this.viewerRow.style.display = "";
                this.workFlowViewer.setHeight("100%");
                this.viewerRow.height = "100%";
                this.tableViewer.setDisplay("");
                this.tableViewerRow.style.display = "";
                this.tableViewer.setHeight("200px");
                this.tableViewerRow.height = "200px";
                this.getToolBar().setDesignButtonEnable(true);
                //����ǰ���ڻ����ͼ������ͼͬʱ���ڿ��ӻ��༭״̬�����ݱ�����״̬
                this.getStatusLabel().setText("\u60a8\u5f53\u524d\u5904\u4e8e\u6df7\u5408\u89c6\u56fe\uff0c\u8be5\u89c6\u56fe\u540c\u65f6\u5904\u4e8e\u53ef\u89c6\u5316\u7f16\u8f91\u72b6\u6001\u548c\u6570\u636e\u8868\u683c\u6d4f\u89c8\u72b6\u6001");
                break;
              default:
                break;
            }
            return;
        }

        //
        return;
    }
};

