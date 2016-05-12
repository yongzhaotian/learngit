
/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) amarsoft.com 2011</p>
 * @author
 */
function DeleteMetaActionListener(workFlow) {
    this.workFlow = workFlow;
}
DeleteMetaActionListener.prototype.actionPerformed = function (obj) {
    var workFlowModel = this.workFlow.getWrapper().getModel();
    workFlowModel.deleteSelected();
};

