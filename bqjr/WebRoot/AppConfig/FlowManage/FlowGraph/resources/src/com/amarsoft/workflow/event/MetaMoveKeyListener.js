
//
/**
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) amarsoft.com 2011</p>
 * @author
 */
function MetaMoveKeyListener(wrapper) {
    this.wrapper = wrapper;
    this.step = WorkFlowWorkSpace.META_NODE_MOVED_STEP;
    this.num = 0;
    this.offset = 1;
}
MetaMoveKeyListener.prototype = new KeyListener();
MetaMoveKeyListener.prototype.onKeyUp = function (e) {
    this.step = WorkFlowWorkSpace.META_NODE_MOVED_STEP;
    this.offset = 1;
    this.num = 0;

    //
    var charCode = (e.charCode) ? e.charCode : e.keyCode;
    switch (charCode) {
      case 46:
        this.wrapper.getModel().deleteSelected();
        break;
      default:
        break;
    }
};
MetaMoveKeyListener.prototype.onKeyDown = function (e) {
    var state = this.wrapper.getStateMonitor().getState();
    if (state != StateMonitor.SELECT) {
        return;
    }

    //
    this.num++;
    if (this.num > 4) {
        this.offset++;
        this.step += this.offset;
        this.num = 0;
    }

    //
    var metaNodeModels = this.wrapper.getModel().getSelectedMetaNodeModels();
    var charCode = (e.charCode) ? e.charCode : e.keyCode;
    switch (charCode) {
      case 38://up
        WorkFlowModel.moveMetaNodeModelBy(metaNodeModels, 0, -this.step);
        break;
      case 40://down
        WorkFlowModel.moveMetaNodeModelBy(metaNodeModels, 0, this.step);
        break;
      case 37://left
        WorkFlowModel.moveMetaNodeModelBy(metaNodeModels, -this.step, 0);
        break;
      case 39://right
        WorkFlowModel.moveMetaNodeModelBy(metaNodeModels, this.step, 0);
        break;
      default:
        break;
    }
};

