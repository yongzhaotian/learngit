
/**
 * <p>Title:  </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) amarsoft.com 2011</p>
 * @author
 */
function WorkFlowModelConverter() {
}

//
WorkFlowModelConverter.convertModelToXML = function (model) {
    var doc = XMLDocument.newDomcument();

	//root
    var workflowProcessNode = doc.createElement(WorkFlowModelConverter.NODE_ROOT);
    workflowProcessNode.setAttribute(WorkFlowModelConverter.ATTR_ROOT_ID, model.getProcessId());
    workflowProcessNode.setAttribute(WorkFlowModelConverter.ATTR_ROOT_NAME, model.getProcessName());
    workflowProcessNode.setAttribute(WorkFlowModelConverter.ATTR_ROOT_CURACTIVITIES, model.getCurActivities());
    doc.documentElement = workflowProcessNode;

    //
    var activitiesNode = doc.createElement(WorkFlowModelConverter.NODE_ACTIVITIES);
    workflowProcessNode.appendChild(activitiesNode);

    //metaNodes
    var metaNodeModels = model.getMetaNodeModels();
    for (var i = 0; i < metaNodeModels.size(); i++) {
        var metaNodeModel = metaNodeModels.get(i);
        var activitieNode = WorkFlowModelConverter.convertMetaNodeModelToXML(metaNodeModel, doc);
        activitiesNode.appendChild(activitieNode);
    }
    
    //
    var transitionsNode = doc.createElement(WorkFlowModelConverter.NODE_TRANSITIONS);
    workflowProcessNode.appendChild(transitionsNode);

    //
    var transitionModels = model.getTransitionModels();
    for (var i = 0; i < transitionModels.size(); i++) {
        var transitionModel = transitionModels.get(i);
        var transitionNode = WorkFlowModelConverter.convertTransitionModelToXML(transitionModel, doc);
        transitionsNode.appendChild(transitionNode);
    }

    //
    return doc;
};
WorkFlowModelConverter.convertMetaNodeModelToXML = function (metaNodeModel, doc) {
    var activitieNode = doc.createElement(WorkFlowModelConverter.NODE_ACTIVITIE);

    //
    activitieNode.setAttribute(WorkFlowModelConverter.ATTR_ACTIVITIE_ID, metaNodeModel.getID());
    activitieNode.setAttribute(WorkFlowModelConverter.ATTR_ACTIVITIE_TYPE, metaNodeModel.type);
    activitieNode.setAttribute(WorkFlowModelConverter.ATTR_ACTIVITIE_NAME, metaNodeModel.getText());
    activitieNode.setAttribute(WorkFlowModelConverter.ATTR_ACTIVITIE_X_COORD, metaNodeModel.getPosition().getX());
    activitieNode.setAttribute(WorkFlowModelConverter.ATTR_ACTIVITIE_Y_COORD, metaNodeModel.getPosition().getY());
    activitieNode.setAttribute(WorkFlowModelConverter.ATTR_ACTIVITIE_WIDTH, metaNodeModel.getSize().getWidth());
    activitieNode.setAttribute(WorkFlowModelConverter.ATTR_ACTIVITIE_HEIGHT, metaNodeModel.getSize().getHeight());
    
    activitieNode.setAttribute(WorkFlowModelConverter.ATTR_ACTIVITIE_BELONGPROCESS, metaNodeModel.getBelongProcess());
    activitieNode.setAttribute(WorkFlowModelConverter.ATTR_ACTIVITIE_PHASENO, metaNodeModel.getPhaseNo());
    activitieNode.setAttribute(WorkFlowModelConverter.ATTR_ACTIVITIE_PHASENAME, metaNodeModel.getPhaseName());
    activitieNode.setAttribute(WorkFlowModelConverter.ATTR_ACTIVITIE_ISINUSE, metaNodeModel.getIsInuse());
    activitieNode.setAttribute(WorkFlowModelConverter.ATTR_ACTIVITIE_EDITSTATUS, metaNodeModel.getEditStatus());
    activitieNode.setAttribute(WorkFlowModelConverter.ATTR_ACTIVITIE_TRANPHASENAMES, metaNodeModel.getTranPhaseNames());

    //
    return activitieNode;
};
WorkFlowModelConverter.convertTransitionModelToXML = function (transitionModel, doc) {
    var transitionNode = doc.createElement(WorkFlowModelConverter.NODE_TRANSITION);

    //
    transitionNode.setAttribute(WorkFlowModelConverter.ATTR_TRANSITION_ID, transitionModel.getID());
    transitionNode.setAttribute(WorkFlowModelConverter.ATTR_TRANSITION_NAME, transitionModel.getText());
    transitionNode.setAttribute(WorkFlowModelConverter.ATTR_TRANSITION_FROM, transitionModel.getFromMetaNodeModel().getID());
    transitionNode.setAttribute(WorkFlowModelConverter.ATTR_TRANSITION_TO, transitionModel.getToMetaNodeModel().getID());

    //
    return transitionNode;
};

//
WorkFlowModelConverter.convertXMLToModel = function (doc, initModel) {
    if (!doc) {
        return null;
    }
    var model = initModel;
    if (!model) {
        model = new WorkFlowModel();
    }
    
    //
    var processNodes = doc.getElementsByTagName("WorkflowProcess");
    if(processNodes.length > 0) {
    	processNode = processNodes[0];
    	model.setProcessId(processNode.getAttribute(WorkFlowModelConverter.ATTR_ROOT_ID));
        model.setProcessName(processNode.getAttribute(WorkFlowModelConverter.ATTR_ROOT_NAME));
        model.setCurActivities(processNode.getAttribute(WorkFlowModelConverter.ATTR_ROOT_CURACTIVITIES));
    }
    

    //
    var activitieNodes = doc.getElementsByTagName("Activitie");
    for (var i = 0; i < activitieNodes.length; i++) {
        var activitieNode = activitieNodes[i];
        var metaNodeModel = WorkFlowModelConverter.convertXMLToMetaNodeModel(activitieNode);
        model.addMetaNodeModel(metaNodeModel);
    }

    //
    var transitionNodes = doc.getElementsByTagName("Transition");
    for (var i = 0; i < transitionNodes.length; i++) {
        var transitionNode = transitionNodes[i];
        var transitionModel = WorkFlowModelConverter.convertXMLToTransitionModel(transitionNode, model);
        model.addTransitionModel(transitionModel);
    }

    //
    return model;
};
WorkFlowModelConverter.convertXMLToMetaNodeModel = function (node) {
    var metaNodeModel = null;

	//
    var type = node.getAttribute(WorkFlowModelConverter.ATTR_ACTIVITIE_TYPE);
    switch (type) {
      case MetaNodeModel.TYPE_NODE:
        metaNodeModel = new NodeModel();
        break;
      case MetaNodeModel.TYPE_START_NODE:
        metaNodeModel = new StartNodeModel();
        break;
      case MetaNodeModel.TYPE_END_NODE:
        metaNodeModel = new EndNodeModel();
        break;
      case MetaNodeModel.TYPE_FORK_NODE:
        metaNodeModel = new ForkNodeModel();
        break;
      case MetaNodeModel.TYPE_JOIN_NODE:
        metaNodeModel = new JoinNodeModel();
        break;
    }
    if (!metaNodeModel) {
        return null;
    }

    //
    var id = eval(node.getAttribute(WorkFlowModelConverter.ATTR_ACTIVITIE_ID));
    metaNodeModel.setID(id);
    
    //
    var name = node.getAttribute(WorkFlowModelConverter.ATTR_ACTIVITIE_NAME);
    metaNodeModel.setText(name);

    //
    var xCoordinate = eval(node.getAttribute(WorkFlowModelConverter.ATTR_ACTIVITIE_X_COORD));
    var yCoordinate = eval(node.getAttribute(WorkFlowModelConverter.ATTR_ACTIVITIE_Y_COORD));
    metaNodeModel.setPosition(new Point(xCoordinate, yCoordinate));

    //
    var width = eval(node.getAttribute(WorkFlowModelConverter.ATTR_ACTIVITIE_WIDTH));
    var height = eval(node.getAttribute(WorkFlowModelConverter.ATTR_ACTIVITIE_HEIGHT));
    metaNodeModel.setSize(new Dimension(width, height));
    
    //add by ymqiao 20101230
    var belongProcess = node.getAttribute(WorkFlowModelConverter.ATTR_ACTIVITIE_BELONGPROCESS);
    metaNodeModel.setBelongProcess(belongProcess);
    var phaseNo = node.getAttribute(WorkFlowModelConverter.ATTR_ACTIVITIE_PHASENO);
    metaNodeModel.setPhaseNo(phaseNo);
    var phaseName = node.getAttribute(WorkFlowModelConverter.ATTR_ACTIVITIE_PHASENAME);
    metaNodeModel.setPhaseName(phaseName);
    var isInuse = node.getAttribute(WorkFlowModelConverter.ATTR_ACTIVITIE_ISINUSE);
    metaNodeModel.setIsInuse(isInuse);
    var editStatus = node.getAttribute(WorkFlowModelConverter.ATTR_ACTIVITIE_EDITSTATUS);
    metaNodeModel.setEditStatus(editStatus);
    var tranPhaseNames = node.getAttribute(WorkFlowModelConverter.ATTR_ACTIVITIE_TRANPHASENAMES);
    metaNodeModel.setTranPhaseNames(tranPhaseNames);

    //
    return metaNodeModel;
};
WorkFlowModelConverter.convertXMLToTransitionModel = function (node, model) {
    var fromID = node.getAttribute(WorkFlowModelConverter.ATTR_TRANSITION_FROM);
    fromMetaNodeModel = WorkFlowModelConverter.getMetaNodeModel(model, fromID);
    var toID = node.getAttribute(WorkFlowModelConverter.ATTR_TRANSITION_TO);
    toMetaNodeModel = WorkFlowModelConverter.getMetaNodeModel(model, toID);

    //
    var id = eval(node.getAttribute(WorkFlowModelConverter.ATTR_TRANSITION_ID));

    //
    var name = node.getAttribute(WorkFlowModelConverter.ATTR_TRANSITION_NAME);
    name = name ? name : "";

    //
    var transitionModel = new TransitionModel(fromMetaNodeModel, toMetaNodeModel, id);

	//
    transitionModel.setText(name);

    //
    return transitionModel;
};
WorkFlowModelConverter.getMetaNodeModel = function (model, id) {
    var metaNodeModels = model.getMetaNodeModels();
    for (var i = 0; i < metaNodeModels.size(); i++) {
        var metaNodeModel = metaNodeModels.get(i);
        if (metaNodeModel.getID() == id) {
            return metaNodeModel;
        }
    }
};

//static
WorkFlowModelConverter.NODE_ROOT = "WorkflowProcess";
WorkFlowModelConverter.ATTR_ROOT_ID = "processId";
WorkFlowModelConverter.ATTR_ROOT_NAME = "processName";
WorkFlowModelConverter.ATTR_ROOT_CURACTIVITIES = "curActivities";

//
WorkFlowModelConverter.NODE_ACTIVITIES = "Activities";
WorkFlowModelConverter.NODE_ACTIVITIE = "Activitie";
WorkFlowModelConverter.ATTR_ACTIVITIE_ID = "id";
WorkFlowModelConverter.ATTR_ACTIVITIE_TYPE = "type";
WorkFlowModelConverter.ATTR_ACTIVITIE_NAME = "name";
WorkFlowModelConverter.ATTR_ACTIVITIE_X_COORD = "xCoordinate";
WorkFlowModelConverter.ATTR_ACTIVITIE_Y_COORD = "yCoordinate";
WorkFlowModelConverter.ATTR_ACTIVITIE_WIDTH = "width";
WorkFlowModelConverter.ATTR_ACTIVITIE_HEIGHT = "height";

WorkFlowModelConverter.ATTR_ACTIVITIE_BELONGPROCESS = "belongProcess";//add by ymqiao 20101230
WorkFlowModelConverter.ATTR_ACTIVITIE_PHASENO = "phaseNo";//add by ymqiao 20101230
WorkFlowModelConverter.ATTR_ACTIVITIE_PHASENAME = "phaseName";//add by ymqiao 20101231
WorkFlowModelConverter.ATTR_ACTIVITIE_ISINUSE = "isInuse";//add by ymqiao 20101230
WorkFlowModelConverter.ATTR_ACTIVITIE_EDITSTATUS = "editStatus";//add by ymqiao 20101230
WorkFlowModelConverter.ATTR_ACTIVITIE_TRANPHASENAMES = "tranPhaseNames";//add by ymqiao 20101230

//
WorkFlowModelConverter.NODE_TRANSITIONS = "Transitions";
WorkFlowModelConverter.NODE_TRANSITION = "Transition";
WorkFlowModelConverter.ATTR_TRANSITION_ID = "id";
WorkFlowModelConverter.ATTR_TRANSITION_NAME = "name";
WorkFlowModelConverter.ATTR_TRANSITION_FROM = "from";
WorkFlowModelConverter.ATTR_TRANSITION_TO = "to";

