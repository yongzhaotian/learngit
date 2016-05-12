
/**
 * <p>Title:  </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) amarsoft.com 2011</p>
 * @author
 */
function WorkFlowViewPattern(ui) {
    this.base = Frame;
    this.base(ui);
    this.ui.style.overflow = "auto";
    
    //
    this.workFlowToolBar = new WorkFlowViewerToolBar();
    this.add(this.workFlowToolBar);

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
    //欢迎使用WorkFlow工作流定制系统
    this.statusPanel.setText("\u6b22\u8fce\u4f7f\u7528WorkFlow\u5de5\u4f5c\u6d41\u5b9a\u5236\u7cfb\u7edf");
    this.add(this.statusPanel);

	//
    this.workFlowToolBar.getViewerPatternButtonGroup().addObserver(this);

    //
    var model = new WorkFlowModel();
    model.setEditable(false);
    this.workFlowWrapper = new WorkFlowWrapper(this.workFlowViewer, model, this.stateMonitor, this.statusPanel);
    this.tableViewer.setModel(this.workFlowWrapper.getModel());
}
WorkFlowViewPattern.prototype = new Frame();
WorkFlowViewPattern.prototype.getToolBar = function () {
    return this.workFlowToolBar;
};
WorkFlowViewPattern.prototype.getStatusLabel = function () {
    return this.statusPanel;
};
WorkFlowViewPattern.prototype.getWrapper = function () {
    return this.workFlowWrapper;
};
WorkFlowViewPattern.prototype.getTableViewer = function () {
    return this.tableViewer;
};

//
WorkFlowViewPattern.prototype.update = function (observable, arg) {
    if (arg == ButtonGroup.PRESSED_CHANGED) {
        //
        if (observable == this.getToolBar().getViewerPatternButtonGroup()) {
            var pressedButtonModel = this.getToolBar().getViewerPatternButtonGroup().getPressedButtonModel();
            var modelName = pressedButtonModel.name;
            switch (modelName) {
              case WorkFlowViewerToolBar.BUTTON_NAME_DESIGN:
                this.workFlowViewer.setDisplay("");
                this.viewerRow.style.display = "";
                this.workFlowViewer.setHeight("100%");
                this.viewerRow.height = "100%";
                this.tableViewer.setDisplay("none");
                this.tableViewerRow.style.display = "none";
                this.getStatusLabel().setText("\u8bbe\u8ba1\u6a21\u5f0f");
                break;
              case WorkFlowViewerToolBar.BUTTON_NAME_TABLE:
                this.workFlowViewer.setDisplay("none");
                this.viewerRow.style.display = "none";
                this.tableViewer.setDisplay("");
                this.tableViewerRow.style.display = "";
                this.tableViewer.setHeight("100%");
                this.tableViewerRow.height = "100%";
                this.getStatusLabel().setText("\u8868\u683c\u6d4f\u89c8\u6a21\u5f0f");
                break;
              case WorkFlowViewerToolBar.BUTTON_NAME_MIX:
                this.workFlowViewer.setDisplay("");
                this.viewerRow.style.display = "";
                this.workFlowViewer.setHeight("100%");
                this.viewerRow.height = "100%";
                this.tableViewer.setDisplay("");
                this.tableViewerRow.style.display = "";
                this.tableViewer.setHeight("200px");
                this.tableViewerRow.height = "200px";
                this.getStatusLabel().setText("\u8bbe\u8ba1\u6a21\u5f0f\u3001\u8868\u683c\u6a21\u5f0f\u540c\u65f6\u663e\u793a");
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

//
function WorkFlowViewerToolBar() {
    this.base = ToolBar;
    this.base();

    //
    this.addSeparator();

    //
    this.viewerPatternButtonGroup = new ButtonGroup();

    //design
    var designButton = new ToggleButton("", "\u8bbe\u8ba1", true);
    this.add(designButton);
    this.viewerPatternButtonGroup.add(designButton);
    designButton.getModel().name = WorkFlowViewerToolBar.BUTTON_NAME_DESIGN;

    //table
    var tableButton = new ToggleButton("", "\u8868\u683c", true);
    this.add(tableButton);
    this.viewerPatternButtonGroup.add(tableButton);
    tableButton.getModel().name = WorkFlowViewerToolBar.BUTTON_NAME_TABLE;

    //混合显示
    var mixButton = new ToggleButton("", "\u6df7\u5408\u663e\u793a", true);
    this.add(mixButton);
    this.viewerPatternButtonGroup.add(mixButton);
    mixButton.getModel().name = WorkFlowViewerToolBar.BUTTON_NAME_MIX;
}
WorkFlowViewerToolBar.prototype = new ToolBar();
WorkFlowViewerToolBar.prototype.setButtonEnable = function (b) {
    var viewPatternbuttons = this.viewerPatternButtonGroup.getButtons();
    for (var i = 0; i < viewPatternbuttons.size(); i++) {
        viewPatternbuttons.get(i).getModel().setEnabled(b);
    }
};
WorkFlowViewerToolBar.prototype.getViewerPatternButtonGroup = function () {
    return this.viewerPatternButtonGroup;
};

//
WorkFlowViewerToolBar.BUTTON_NAME_DESIGN = "BUTTON_NAME_DESIGN";
WorkFlowViewerToolBar.BUTTON_NAME_TABLE = "BUTTON_NAME_TABLE";
WorkFlowViewerToolBar.BUTTON_NAME_MIX = "BUTTON_NAME_MIX";

