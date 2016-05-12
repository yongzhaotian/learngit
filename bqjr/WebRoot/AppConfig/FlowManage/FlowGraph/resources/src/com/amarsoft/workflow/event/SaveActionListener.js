
/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) amarsoft.com 2011</p>
 * @author
 */
function SaveActionListener(workFlow) {
    this.workFlow = workFlow;
}
SaveActionListener.prototype.actionPerformed = function (obj) {
    var wrapper = this.workFlow.getWrapper();
    var toolbar = this.workFlow.getToolBar();
    var name = wrapper.getModel().getName();
    if (!name) {
    	//������������������ͼ����ɵ����֣�
        name = prompt("\u8bf7\u8f93\u5165\u5de5\u4f5c\u6d41\u7a0b\u56fe\u7684\u540d\u5b57\uff1f", "");
        if (name != null && name != "") {
            var addProcess = new AddProcess(wrapper, toolbar, this.workFlow.getProcessList());
            addProcess.addProcess(name);
        }
    } else {
        var updateProcess = new UpdateProcess(wrapper, toolbar);
        updateProcess.updateProcess();
    }
};

