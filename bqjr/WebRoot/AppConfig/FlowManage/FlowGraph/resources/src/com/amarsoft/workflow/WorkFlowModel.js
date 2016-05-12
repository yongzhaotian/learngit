
/**
 * <p>Title:  </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) amarsoft.com 2011</p>
 * @author
 */
function WorkFlowModel() {
    this.base = Observable;
    this.base();
    this.resetID();
    this.setName(null);

    //
    this.metaNodeModels = new Array();
    this.transitionModels = new Array();

    //
    this.selectedMetaNodeModels = new Array();
    this.selectedTransitionModels = new Array();

    //
    this.setEnable(true);
    this.setEditable(true);
}
WorkFlowModel.prototype = new Observable();

//
WorkFlowModel.prototype.addMetaNodeModel = function (metaNodeModel) {
	//null
    if (metaNodeModel == null) {
        return;
    }
    //exist
    if (this.metaNodeModels.indexOf(metaNodeModel) > -1) {
        return;
    }

	//
    var id = metaNodeModel.getID();
    if (id) {
        this.updateID(id);
    } else {
        metaNodeModel.setID(this.nextID());
    }

    //
    this.metaNodeModels.add(metaNodeModel);
    var args = [WorkFlowModel.META_NODE_MODEL_ADD, metaNodeModel];
    this.notifyObservers(args);
};
WorkFlowModel.prototype.removeMetaNodeModel = function (metaNodeModel) {
	//null
    if (metaNodeModel == null) {
        return;
    }

    //
    var fromTransitionModels = metaNodeModel.getFroms();
    for (var i = 0; i < fromTransitionModels.size(); i++) {
        this.removeTransitionModel(fromTransitionModels.get(i));
    }
    var toTransitionModels = metaNodeModel.getTos();
    for (var i = 0; i < toTransitionModels.size(); i++) {
        this.removeTransitionModel(toTransitionModels.get(i));
    }

    //
    this.metaNodeModels.remove(metaNodeModel);
    this.removeSelectedMetaNodeModel(metaNodeModel);

    //
    var args = [WorkFlowModel.META_NODE_MODEL_REMOVE, metaNodeModel];
    this.notifyObservers(args);
};
WorkFlowModel.prototype.getMetaNodeModels = function () {
    return this.metaNodeModels;
};

//
WorkFlowModel.prototype.addTransitionModel = function (transitionModel) {
	//null
    if (transitionModel == null) {
        return;
    }
    //exist
    if (this.transitionModels.indexOf(transitionModel) > -1) {
        return;
    }

    //
    var id = transitionModel.getID();
    if (id) {
        this.updateID(id);
    } else {
        transitionModel.setID(this.nextID());
    }

    //
    this.transitionModels.add(transitionModel);
    var args = [WorkFlowModel.TRANSITION_MODEL_ADD, transitionModel];
    this.notifyObservers(args);
};
WorkFlowModel.prototype.removeTransitionModel = function (transitionModel) {
	//null
    if (transitionModel == null) {
        return;
    }

    //
    this.transitionModels.remove(transitionModel);
    this.removeSelectedTransitionModel(transitionModel);
    var args = [WorkFlowModel.TRANSITION_MODEL_REMOVE, transitionModel];
    this.notifyObservers(args);
};
WorkFlowModel.prototype.getTransitionModels = function () {
    return this.transitionModels;
};

//
WorkFlowModel.prototype.addSelectedMetaNodeModel = function (metaNodeModel) {
	//null
    if (metaNodeModel == null) {
        return;
    }
    //exist
    if (this.selectedMetaNodeModels.indexOf(metaNodeModel) > -1) {
        return;
    }
    metaNodeModel.setSelected(true);
    this.selectedMetaNodeModels.add(metaNodeModel);
};
WorkFlowModel.prototype.removeSelectedMetaNodeModel = function (metaNodeModel) {
	//null
    if (metaNodeModel == null) {
        return;
    }
    metaNodeModel.setSelected(false);
    this.selectedMetaNodeModels.remove(metaNodeModel);
};
WorkFlowModel.prototype.getSelectedMetaNodeModels = function () {
    return this.selectedMetaNodeModels;
};
WorkFlowModel.prototype.clearSelectedMetaNodeModels = function () {
    for (var i = 0; i < this.selectedMetaNodeModels.size(); i++) {
        this.selectedMetaNodeModels.get(i).setSelected(false);
    }
    return this.selectedMetaNodeModels.clear();
};

//
WorkFlowModel.prototype.addSelectedTransitionModel = function (transitionModel) {
	//null
    if (transitionModel == null) {
        return;
    }
    //exist
    if (this.selectedTransitionModels.indexOf(transitionModel) > -1) {
        return;
    }
    transitionModel.setSelected(true);
    this.selectedTransitionModels.add(transitionModel);
};
WorkFlowModel.prototype.removeSelectedTransitionModel = function (transitionModel) {
	//null
    if (transitionModel == null) {
        return;
    }
    transitionModel.setSelected(false);
    this.selectedTransitionModels.remove(transitionModel);
};
WorkFlowModel.prototype.getSelectedTransitionModels = function () {
    return this.selectedTransitionModels;
};
WorkFlowModel.prototype.clearSelectedTransitionModels = function () {
    for (var i = 0; i < this.selectedTransitionModels.size(); i++) {
        this.selectedTransitionModels.get(i).setSelected(false);
    }
    return this.selectedTransitionModels.clear();
};

//
WorkFlowModel.prototype.deleteSelected = function () {
    var selectedMetaNodeModels = this.getSelectedMetaNodeModels().clone();
    var selectedTransitionModels = this.getSelectedTransitionModels().clone();
    if ((selectedMetaNodeModels.size() > 0) || (selectedTransitionModels.size() > 0)) {
        if (!window.confirm("\u5220\u9664\u540e\u5c06\u65e0\u6cd5\u56de\u590d\uff0c\u60a8\u786e\u5b9a\u5220\u9664\uff1f")) {
            return;
        }

        //
        for (var i = 0; i < selectedTransitionModels.size(); i++) {
            this.removeTransitionModel(selectedTransitionModels.get(i));
        }

        //add by ymqiao 20101231
        //节点不允许删除！
        if(selectedMetaNodeModels.size() > 0){
        	alert("\u8282\u70b9\u4e0d\u5141\u8bb8\u5220\u9664\uff01");
            return;
        }
        //以下语句不执行
        for (var i = 0; i < selectedMetaNodeModels.size(); i++) {
            this.removeMetaNodeModel(selectedMetaNodeModels.get(i));
        }
    }
};


//
WorkFlowModel.prototype.setEnable = function (enable) {
    this.enable = enable;
};
WorkFlowModel.prototype.isEnable = function () {
    return this.enable;
};
WorkFlowModel.prototype.setEditable = function (editable) {
    this.editable = editable;
};
WorkFlowModel.prototype.isEditable = function () {
    return this.editable;
};

//
WorkFlowModel.prototype.setName = function (name) {
    this.name = name;
};
WorkFlowModel.prototype.getName = function () {
    return this.name;
};

//
WorkFlowModel.prototype.setProcessId = function(processId) {
	this.processId = processId;
};
WorkFlowModel.prototype.getProcessId = function() {
	return this.processId;
};
//
WorkFlowModel.prototype.setProcessName = function(processName) {
	this.processName = processName;
};
WorkFlowModel.prototype.getProcessName = function() {
	return this.processName;
};
WorkFlowModel.prototype.setCurActivities = function(curActivities) {
	this.curActivities = curActivities;
};
WorkFlowModel.prototype.getCurActivities = function() {
	return this.curActivities;
};

//
WorkFlowModel.prototype.resetID = function () {
    this.id = WorkFlowWorkSpace.ID;
};
WorkFlowModel.prototype.updateID = function (id) {
    if (id > this.id) {
        this.id = id;
    }
};
WorkFlowModel.prototype.nextID = function () {
    return this.id++;
};

//
WorkFlowModel.moveMetaNodeModelBy = function (metaNodeModels, x, y) {
    for (var i = 0; i < metaNodeModels.size(); i++) {
        var metaNodeModel = metaNodeModels.get(i);
        var pos = metaNodeModel.getPosition();
        if (((pos.getX() + x) < 0) || ((pos.getY() + y) < 0)) {
            return;
        }
    }
    for (var i = 0; i < metaNodeModels.size(); i++) {
        var metaNodeModel = metaNodeModels.get(i);
        var pos = metaNodeModel.getPosition();
        metaNodeModel.setPosition(new Point(pos.getX() + x, pos.getY() + y));
    }
};

//static
WorkFlowModel.META_NODE_MODEL_ADD = "META_NODE_MODEL_ADD";
WorkFlowModel.META_NODE_MODEL_REMOVE = "META_NODE_MODEL_REMOVE";
WorkFlowModel.TRANSITION_MODEL_ADD = "TRANSITION_MODEL_ADD";
WorkFlowModel.TRANSITION_MODEL_REMOVE = "TRANSITION_MODEL_REMOVE";

