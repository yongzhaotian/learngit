
/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) amarsoft.com 2011</p>
 * @author
 */
function WorkFlowToolBar(workFlow) {
    this.base = ToolBar;
    this.base();

    //
    this.workFlow = workFlow;

    //
    this.addSeparator();

    //
    this.saveButton = new Button(WorkFlowWorkSpace.WORK_FLOW_PATH + "images/workflow/save.gif", "\u4fdd\u5b58");
    //保存
    this.saveButton.setToolTipText("\u4fdd\u5b58");
    this.saveButton.addActionListener(new SaveActionListener(this.workFlow));
    this.add(this.saveButton);

    //
    this.nodeButtonGroup = new ButtonGroup();

    //
    this.addSeparator();

    //
    this.selectButton = new ToggleButton(WorkFlowWorkSpace.WORK_FLOW_PATH + "images/workflow/select.gif", "", true);
    //选择
    this.selectButton.setToolTipText("\u9009\u62e9");
    this.add(this.selectButton);
    this.nodeButtonGroup.add(this.selectButton);
    this.selectButton.getModel().name = WorkFlowToolBar.BUTTON_NAME_SELECT;

    //
    this.addSeparator();

    //
    this.startButton = new ToggleButton(WorkFlowWorkSpace.WORK_FLOW_PATH + "images/workflow/start.gif");
    //开始节点
    this.startButton.setToolTipText("\u5f00\u59cb\u8282\u70b9");
    //this.add(this.startButton);//add by ymqiao 20101231,只创建不加入工具栏,防止代码中出现undefined错误
    this.nodeButtonGroup.add(this.startButton);
    this.startButton.getModel().name = WorkFlowToolBar.BUTTON_NAME_START_NODE;

    //
    this.endButton = new ToggleButton(WorkFlowWorkSpace.WORK_FLOW_PATH + "images/workflow/end.gif", "");
    //结束节点
    this.endButton.setToolTipText("\u7ed3\u675f\u8282\u70b9");
    //this.add(this.endButton);//add by ymqiao 20101231,只创建不加入工具栏,防止代码中出现undefined错误
    this.nodeButtonGroup.add(this.endButton);
    this.endButton.getModel().name = WorkFlowToolBar.BUTTON_NAME_END_NODE;

    //
    //this.addSeparator();//add by ymqiao 20101231

    //
    this.nodeButton = new ToggleButton(WorkFlowWorkSpace.WORK_FLOW_PATH + "images/workflow/node.gif");
    //任务节点
    this.nodeButton.setToolTipText("\u4efb\u52a1\u8282\u70b9");
    //this.add(this.nodeButton);//add by ymqiao 20101231,只创建不加入工具栏,防止代码中出现undefined错误
    this.nodeButtonGroup.add(this.nodeButton);
    this.nodeButton.getModel().name = WorkFlowToolBar.BUTTON_NAME_NODE;

    //
    this.forkButton = new ToggleButton(WorkFlowWorkSpace.WORK_FLOW_PATH + "images/workflow/fork.gif");
    //分支节点
    this.forkButton.setToolTipText("\u5206\u652f\u8282\u70b9");
    //this.add(this.forkButton);//add by ymqiao 20101231,只创建不加入工具栏,防止代码中出现undefined错误
    this.nodeButtonGroup.add(this.forkButton);
    this.forkButton.getModel().name = WorkFlowToolBar.BUTTON_NAME_FORK_NODE;

    //
    this.joinButton = new ToggleButton(WorkFlowWorkSpace.WORK_FLOW_PATH + "images/workflow/join.gif");
    //汇聚节点
    this.joinButton.setToolTipText("\u6c47\u805a\u8282\u70b9");
    //this.add(this.joinButton);//add by ymqiao 20101231,只创建不加入工具栏,防止代码中出现undefined错误
    this.nodeButtonGroup.add(this.joinButton);
    this.joinButton.getModel().name = WorkFlowToolBar.BUTTON_NAME_JOIN_NODE;

    //
    //this.addSeparator();//add by ymqiao 20101231

    //
    this.transitionButton = new ToggleButton(WorkFlowWorkSpace.WORK_FLOW_PATH + "images/workflow/transition.gif");
    //连接
    this.transitionButton.setToolTipText("\u8fde\u63a5");
    //this.add(this.transitionButton);//add by ymqiao 20101231,只创建不加入工具栏,防止代码中出现undefined错误
    this.nodeButtonGroup.add(this.transitionButton);
    this.transitionButton.getModel().name = WorkFlowToolBar.BUTTON_NAME_TRANSITION;

    //
    //this.addSeparator();//add by ymqiao 20101231

    //
    this.deleteButton = new Button(WorkFlowWorkSpace.WORK_FLOW_PATH + "images/workflow/delete.gif");
    //删除
    this.deleteButton.setToolTipText("\u5220\u9664");
    this.deleteButton.addActionListener(new DeleteMetaActionListener(this.workFlow));
    this.add(this.deleteButton);//add by ymqiao 20101231,只创建不加入工具栏,防止代码中出现undefined错误

    //
    this.addSeparator();//add by ymqiao 20110120

    //
    this.viewerPatternButtonGroup = new ButtonGroup();

    //design-->图形
    var designButton = new ToggleButton("", "\u56fe\u5f62", true);
    //设计视图-->图形视图
    designButton.setToolTipText("\u56fe\u5f62\u89c6\u56fe");
    this.add(designButton);
    this.viewerPatternButtonGroup.add(designButton);
    designButton.getModel().name = WorkFlowToolBar.BUTTON_NAME_DESIGN;

    //table
    var tableButton = new ToggleButton("", "\u8868\u683c", true);
    //表格视图
    tableButton.setToolTipText("\u8868\u683c\u89c6\u56fe");
    this.add(tableButton);
    this.viewerPatternButtonGroup.add(tableButton);
    tableButton.getModel().name = WorkFlowToolBar.BUTTON_NAME_TABLE;

    //混合显示
    var mixButton = new ToggleButton("", "\u6df7\u5408\u663e\u793a", true);
    //混合视图
    mixButton.setToolTipText("\u6df7\u5408\u89c6\u56fe");
    this.add(mixButton);
    this.viewerPatternButtonGroup.add(mixButton);
    mixButton.getModel().name = WorkFlowToolBar.BUTTON_NAME_MIX;

    //
    //this.addSeparator();//add by ymqiao 20101231

    //
    var helpButton = new Button(WorkFlowWorkSpace.WORK_FLOW_PATH + "images/workflow/help.gif", "\u5e2e\u52a9");
    helpButton.addActionListener(new HelpActionListener());
    //帮助
    helpButton.setToolTipText("\u5e2e\u52a9");
    //this.add(helpButton);//add by ymqiao 20101231,只创建不加入工具栏,防止代码中出现undefined错误
}
WorkFlowToolBar.prototype = new ToolBar();
WorkFlowToolBar.prototype.getNodeButtonGroup = function () {
    return this.nodeButtonGroup;
};
WorkFlowToolBar.prototype.setDesignButtonEnable = function (b) {
    var buttons = this.nodeButtonGroup.getButtons();
    for (var i = 0; i < buttons.size(); i++) {
        buttons.get(i).getModel().setEnabled(b);
    }
    this.deleteButton.getModel().setEnabled(b);
};
WorkFlowToolBar.prototype.setButtonEnable = function (b) {
    var buttons = this.nodeButtonGroup.getButtons();
    for (var i = 0; i < buttons.size(); i++) {
        buttons.get(i).getModel().setEnabled(b);
    }
    var viewPatternbuttons = this.viewerPatternButtonGroup.getButtons();
    for (var i = 0; i < viewPatternbuttons.size(); i++) {
        viewPatternbuttons.get(i).getModel().setEnabled(b);
    }
    this.deleteButton.getModel().setEnabled(b);
    this.saveButton.getModel().setEnabled(b);
};
WorkFlowToolBar.prototype.getViewerPatternButtonGroup = function () {
    return this.viewerPatternButtonGroup;
};

//
WorkFlowToolBar.prototype.update = function (observable, arg) {
    if (arg instanceof Array) {
        if (arg.size() == 2) {
            var property = arg[0];
            var state = arg[1];
            if (property == StateMonitor.OPERATION_STATE_RESET) {
                switch (state) {
                  case StateMonitor.SELECT:
                    this.selectButton.getModel().setPressed(true);
                    break;
                  case StateMonitor.NODE:
                    this.nodeButton.getModel().setPressed(true);
                    break;
                  case StateMonitor.FORK_NODE:
                    this.forkNodeButton.getModel().setPressed(true);
                    break;
                  case StateMonitor.JOIN_NODE:
                    this.joinNode.getModel().setPressed(true);
                    break;
                  case StateMonitor.START_NODE:
                    this.startNodeButton.getModel().setPressed(true);
                    break;
                  case StateMonitor.END_NODE:
                    this.endNodeButton.getModel().setPressed(true);
                    break;
                  case StateMonitor.TRANSITION:
                    this.transitionButton.getModel().setPressed(true);
                    break;
                  default:
                    break;
                }
            }
        }
    }
};

//
WorkFlowToolBar.BUTTON_NAME_SELECT = "BUTTON_NAME_SELECT";
WorkFlowToolBar.BUTTON_NAME_START_NODE = "BUTTON_NAME_START_NODE";
WorkFlowToolBar.BUTTON_NAME_END_NODE = "BUTTON_NAME_END_NODE";
WorkFlowToolBar.BUTTON_NAME_FORK_NODE = "BUTTON_NAME_FORK_NODE";
WorkFlowToolBar.BUTTON_NAME_JOIN_NODE = "BUTTON_NAME_JOIN_NODE";
WorkFlowToolBar.BUTTON_NAME_NODE = "BUTTON_NAME_NODE";
WorkFlowToolBar.BUTTON_NAME_TRANSITION = "BUTTON_NAME_TRANSITION";

//
WorkFlowToolBar.BUTTON_NAME_DESIGN = "BUTTON_NAME_DESIGN";
WorkFlowToolBar.BUTTON_NAME_TABLE = "BUTTON_NAME_TABLE";
WorkFlowToolBar.BUTTON_NAME_MIX = "BUTTON_NAME_MIX";

