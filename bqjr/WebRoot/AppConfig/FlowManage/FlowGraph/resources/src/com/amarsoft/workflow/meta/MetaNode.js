
/**
 * <p>Title: MetaNode</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) amarsoft.com 2011</p>
 * @author
 */
function MetaNode(model, img, wrapper) {
    this.base = Panel;
    this.base(Toolkit.newLayer());
    this.setClassName("NAME_XIO_UI_FONT NAME_XIO_XIORKFLOW_METANODE");

    this.wrapper = wrapper;

    //bound rectangle
    var rectangleUrl = WorkFlowWorkSpace.WORK_FLOW_PATH + "images/workflow/rectangle.gif";
    //lefttop
    this.lefttopRetangle = new Component(Toolkit.newImage());
    this.lefttopRetangle.getUI().src = rectangleUrl;
    this.lefttopRetangle.setLeft("-5px");
    this.lefttopRetangle.setTop("-5px");
    this.lefttopRetangle.setPosition("absolute");
    this.add(this.lefttopRetangle);
    //righttop
    this.righttopRetangle = new Component(Toolkit.newImage());
    this.righttopRetangle.getUI().src = rectangleUrl;
    this.righttopRetangle.setRight("-5px");
    this.righttopRetangle.setTop("-5px");
    this.righttopRetangle.setPosition("absolute");
    this.add(this.righttopRetangle);
    //leftbottom
    this.leftbottomRetangle = new Component(Toolkit.newImage());
    this.leftbottomRetangle.getUI().src = rectangleUrl;
    this.leftbottomRetangle.setLeft("-5px");
    this.leftbottomRetangle.setBottom("-5px");
    this.leftbottomRetangle.setPosition("absolute");
    this.add(this.leftbottomRetangle);
    //rightbottom
    this.rightbottomRetangle = new Component(Toolkit.newImage());
    this.rightbottomRetangle.getUI().src = rectangleUrl;
    this.rightbottomRetangle.setRight("-5px");
    this.rightbottomRetangle.setBottom("-5px");
    this.rightbottomRetangle.setPosition("absolute");
    this.add(this.rightbottomRetangle);
    this.rightbottomRetangle.setCursor(Cursor.RESIZE_SE);

    //
    this.table = Toolkit.newTable();
    this.table.width = "100%";
    this.table.height = "100%";
    this.table.cellPadding = 0;
    this.table.cellSpacing = 0;
    this.add(this.table);
    
    
    //
    var titleRow = this.table.insertRow(-1);
    titleRow.className = "TITLE";

    //
    var titleImgCell = titleRow.insertCell(-1);
    titleImgCell.align = "center";
    titleImgCell.valign = "middle";
    if (!img) {
        img = WorkFlowWorkSpace.WORK_FLOW_PATH + "images/workflow/metanode.gif";
    }
    var titleImg = Toolkit.newLayer();
    titleImg.className = "IMG";
    titleImg.style.background = "url(' " + img + "')";
    titleImgCell.appendChild(titleImg);

    //
    this.titleTxtCell = titleRow.insertCell(-1);
    this.titleTxtCell.align = "center";
    this.titleTxtCell.valign = "middle";
    this.titleTxtCell.className = "TXT";
    
    //
    /*
    this.titleInputCell = titleRow.insertCell(-1);
    this.titleInputCell.align = "left";
    this.titleInputCell.valign = "middle";
    this.titleInput = Toolkit.newElement("<input type=\"text\" >");
    this.titleInput.style.display = "none";
    var _MetaNode = this;
    this.titleInput.onchange = function () {
        _MetaNode.stopEdit();
    };
    this.titleInput.onblur = function () {
        _MetaNode.stopEdit();
    };
    this.titleInputCell.appendChild(this.titleInput);
	*/
    //*********add by ymqiao 20101231 add property row*****************
    this.extProperty = new Component(Toolkit.newLayer());
    this.extProperty.setClassName("NAME_XIO_XIORKFLOW_METANODE_EXTPROP");
    this.extProperty.setLeft("0px");
    this.extProperty.setTop("30px");
    this.extProperty.setPosition("absolute");
    this.extProperty.setDisplay("");
    this.extProperty.insertBefore(this);
    if(this.wrapper){
    	this.wrapper.getViewer().add(this.extProperty);
    }
    //this.add(this.extProperty);
    //content
    var propTable = Toolkit.newTable();
    propTable.width = "100%";
    propTable.height = "100%";
    propTable.cellPadding = "0";
    propTable.cellSpacing = "2";
    propTable.border.style = "{1px FFF8DC solid;}";
    this.extProperty.add(propTable);
    
    var phaseNoRow = propTable.insertRow(-1);//PhaseNo,阶段编号
    phaseNoRow.className = "TITLE";
    this.phaseNoTitleCell = phaseNoRow.insertCell(-1);
    this.phaseNoTitleCell.align = "right";
    this.phaseNoTitleCell.valign = "top";
    this.phaseNoTitleCell.width = "60px";
    this.phaseNoTitleCell.height = "20px";
    this.phaseNoTitleCell.className = "TITLECELL";
    this.phaseNoTitleCell.innerText = "\u9636\u6bb5\u7f16\u53f7:";//阶段编号:
    this.phaseNoValueCell = phaseNoRow.insertCell(-1);
    this.phaseNoValueCell.align = "left";
    this.phaseNoValueCell.valign = "top";
    this.phaseNoValueCell.className = "TXT";
    this.phaseNoValueCell.innerText = "\u503c\u672a\u8bbe\u7f6e";//值未设置
    
    var phaseNameRow = propTable.insertRow(-1);//PhaseName,阶段名称
    phaseNameRow.className = "TITLE";
    this.phaseNameTitleCell = phaseNameRow.insertCell(-1);
    this.phaseNameTitleCell.align = "right";
    this.phaseNameTitleCell.vAlign = "top";
    this.phaseNameTitleCell.width = "60px";
    this.phaseNameTitleCell.height = "20px";
    this.phaseNameTitleCell.className = "TITLECELL";
    this.phaseNameTitleCell.innerText = "\u9636\u6bb5\u540d\u79f0:";//阶段名称: 
    this.phaseNameValueCell = phaseNameRow.insertCell(-1);
    this.phaseNameValueCell.align = "left";
    this.phaseNameValueCell.vAlign = "top";
    this.phaseNameValueCell.className = "TXT";
    this.phaseNameValueCell.innerText = "\u503c\u672a\u8bbe\u7f6e";//值未设置
    /*
    var isInuseRow = propTable.insertRow(-1);//IsInuse,阶段状态
    isInuseRow.className = "TITLE";
    this.isInuseTitleCell = isInuseRow.insertCell(-1);
    this.isInuseTitleCell.align = "right";
    this.isInuseTitleCell.vAlign = "top";
    this.isInuseTitleCell.width = "60px";
    this.isInuseTitleCell.height = "20px";
    this.isInuseTitleCell.className = "TITLECELL";
    this.isInuseTitleCell.innerText = "\u9636\u6bb5\u72b6\u6001:";//阶段状态:
    this.isInuseValueCell = isInuseRow.insertCell(-1);
    this.isInuseValueCell.align = "left";
    this.isInuseValueCell.vAlign = "top";
    this.isInuseValueCell.className = "TXT";
    this.isInuseValueCell.innerText = "\u503c\u672a\u8bbe\u7f6e";//值未设置
    
    var editStatusRow = propTable.insertRow(-1);//EditStatus,编辑状态
    editStatusRow.className = "TITLE";
    this.editStatusTitleCell = editStatusRow.insertCell(-1);
    this.editStatusTitleCell.align = "right";
    this.editStatusTitleCell.vAlign = "top";
    this.editStatusTitleCell.width = "60px";
    this.editStatusTitleCell.height = "20px";
    this.editStatusTitleCell.className = "TITLECELL";
    this.editStatusTitleCell.innerText = "\u7f16\u8f91\u72b6\u6001:";//编辑状态:
    this.editStatusValueCell = editStatusRow.insertCell(-1);
    this.editStatusValueCell.align = "left";
    this.editStatusValueCell.vAlign = "top";
    this.editStatusValueCell.className = "TXT";
    this.editStatusValueCell.innerText = "\u503c\u672a\u8bbe\u7f6e";//值未设置
    */
    var tranPhaseNamesRow = propTable.insertRow(-1);//TranPhaseNames,阶段跳转
    tranPhaseNamesRow.className = "TITLE";
    this.tranPhaseNamesTitleCell = tranPhaseNamesRow.insertCell(-1);
    this.tranPhaseNamesTitleCell.align = "right";
    this.tranPhaseNamesTitleCell.vAlign = "top";
    this.tranPhaseNamesTitleCell.width = "60px";
    this.tranPhaseNamesTitleCell.height = "20px";
    this.tranPhaseNamesTitleCell.className = "TITLECELL";
    this.tranPhaseNamesTitleCell.innerText = "\u9636\u6bb5\u8df3\u8f6c:";//阶段跳转:
    this.tranPhaseNamesValueCell = tranPhaseNamesRow.insertCell(-1);
    this.tranPhaseNamesValueCell.align = "left";
    this.tranPhaseNamesValueCell.vAlign = "top";
    this.tranPhaseNamesValueCell.className = "TXT";
    this.tranPhaseNamesValueCell.innerText = "\u503c\u672a\u8bbe\u7f6e";//值未设置
    //*********end********************************
    
    //
    this.setModel(model);
    this.rightbottomRetangle.addMouseListener(new MetaNodeResizeMouseListener(this.rightbottomRetangle, model, this.wrapper));
}
MetaNode.prototype = new Panel();

//
MetaNode.prototype.setModel = function (model) {
    if (this.model == model) {
        return;
    }
    if (this.model) {
        this.model.removeObserver(this);
    }
    this.model = model;
    this.model.addObserver(this);

    //
    this._updatePosition();
    this._updateSize();
    this._updateText();
    this._updateBoundRectangle();
    //add by ymqiao 20101231
    this._updateExtProperty();
    this._updateCurActivities();
    
};
MetaNode.prototype._updateCurActivities = function() {
	//
    if(this.wrapper){
    	var curActivities = this.wrapper.getModel().getCurActivities();
    	var activities = curActivities.split(",");
    	for(var i = 0; i < activities.length; i++){
    		if(activities[i] == this.model.getPhaseNo()){
    			this.setBackgroundColor("#00BFFF");//FF8C00
    		}
    	}
    }
};
MetaNode.prototype.getModel = function () {
    return this.model;
};

//
MetaNode.prototype.startEdit = function () {
	var flowNo = this.model.getBelongProcess();
	var phaseNo = this.model.getPhaseNo();
	var editStatus = this.model.getEditStatus();
	var isInuse = this.model.getIsInuse();
	var returnValue = isInuse;
	if(editStatus == "000"){
		//该流程节点不可编辑!
		alert("\u8be5\u6d41\u7a0b\u8282\u70b9\u4e0d\u53ef\u7f16\u8f91!");
		return;
	} else {
		returnValue = PopComp("WFCfgUserSelect","/Common/Configurator/FlowManage/FlowModelInfo.jsp","FlowNo="+flowNo+"&PhaseNo="+phaseNo+"&Editable="+editStatus+"&IsInuse="+isInuse,"dialogWidth:600px;dialogHeight:480px;center:yes;help:no;scroll:no;status:no;resizable:yes;");
		//returnValue = AsControl.PopView("/AppConfig/FlowManage/FlowModelInfo.jsp","FlowNo="+flowNo+"&PhaseNo="+phaseNo+"&Editable="+editStatus+"&IsInuse="+isInuse,"dialogWidth:600px;dialogHeight:480px;center:yes;help:no;scroll:no;status:no;resizable:yes;");
	}
	if(returnValue){
		this.wrapper.setChanged(false);//add by ymqiao 20110120 cancel the confirm in updateprocess.js before refresh 
		window.name = "__self";//add by ymqiao 20110120 refresh this window
	    window.open(window.location.href, "__self");
	    
		this.model.setIsInuse(returnValue);
		this._updateExtProperty();
	}
	//popComp("WFCfgUserSelect","/WorkFlowCfg/WFCfgUserSelect.jsp","FlowNo=CreditFlow&PhaseNo=0010","dialogWidth:1000px;dialogHeight:550px;center:yes;help:no;scroll:no;status:no;resizable:yes;");
    //this.titleTxtCell.style.display = "none";
    //this.titleInput.style.display = "";
    //this.titleInputCell.style.display = "";
    //this.titleInput.focus();
    //this.extProperty.setDisplay("");//add
    this.getModel().setEditing(true);
};
MetaNode.prototype.stopEdit = function () {
    //this.titleTxtCell.style.display = "";
    //this.titleInput.style.display = "none";
    //this.titleInputCell.style.display = "none";
    this.extProperty.setDisplay("none");//add
    //this.getModel().setText(this.titleInput.value);
    this.getModel().setEditing(false);
};
//add by ymqiao 20201231
MetaNode.prototype.showTips = function () {
	this.extProperty.setDisplay("");
};
MetaNode.prototype.hideTips = function () {
	this.extProperty.setDisplay("none");
};
MetaNode.prototype._updateExtProperty = function () {
	var pahseNo = this.model.getPhaseNo();
	if(pahseNo) this.phaseNoValueCell.innerText = pahseNo;
	
	var phaseName = this.model.getPhaseName();
	if(phaseName) this.phaseNameValueCell.innerText = phaseName;
	/*
	var editStatus = this.model.getEditStatus();
	if(editStatus) {
		if(editStatus == "11"){
			//可屏蔽,可编辑处理人
			editStatus = "\u53ef\u5c4f\u853d,\u53ef\u7f16\u8f91\u5904\u7406\u4eba";
		} else if(editStatus == "10"){
			//可屏蔽,不可编辑处理人
			editStatus = "\u53ef\u5c4f\u853d,\u4e0d\u53ef\u7f16\u8f91\u5904\u7406\u4eba";
		} else if(editStatus == "01"){
			//不可屏蔽,可编辑处理人
			editStatus = "\u4e0d\u53ef\u5c4f\u853d,\u53ef\u7f16\u8f91\u5904\u7406\u4eba";
		} else {
			//不可屏蔽,不可编辑处理人
			editStatus = "\u4e0d\u53ef\u5c4f\u853d,\u4e0d\u53ef\u7f16\u8f91\u5904\u7406\u4eba";
		}
		this.editStatusValueCell.innerText = editStatus;
	}
	*/
	var tranPhaseNames = this.model.getTranPhaseNames();
	if(tranPhaseNames) this.tranPhaseNamesValueCell.innerText = tranPhaseNames;
	/*
	var isInuse = this.model.getIsInuse();
	if(isInuse && isInuse == "0"){
		this.isInuseValueCell.innerText = "\u5c4f\u853d";//屏蔽
		this.setBackgroundColor("#C0C0C0");//buttonface,
		this.setOpacity("30");
	} else {
		this.isInuseValueCell.innerText = "\u975e\u5c4f\u853d";//非屏蔽
		this.setBackgroundColor("#FFD700");//#FFD700,DAA520
	}
	*/
};

//
MetaNode.prototype._updatePosition = function () {
    var point = this.model.getPosition();
    this.setLeft(point.getX() + "px");
    this.setTop(point.getY() + "px");
    this.extProperty.setLeft(point.getX() + 5 + "px");
    this.extProperty.setTop(point.getY() + this.model.getSize().getHeight()+ 10 + "px");
};
MetaNode.prototype._updateSize = function () {
    var size = this.model.getSize();
    this.setWidth(size.getWidth() + "px");
    this.setHeight(size.getHeight() + "px");
};
MetaNode.prototype._updateText = function () {
    var text = this.model.getText();
    //this.titleInput.value = text;
    this.titleTxtCell.innerText = text;
};
MetaNode.prototype._updateBoundRectangle = function () {
    if (this.model.isSelected()) {
        this.lefttopRetangle.setClassName("BOUND_RECTANGLE");
        this.righttopRetangle.setClassName("BOUND_RECTANGLE");
        this.leftbottomRetangle.setClassName("BOUND_RECTANGLE");
        this.rightbottomRetangle.setClassName("BOUND_RECTANGLE");
    } else {
        this.lefttopRetangle.setClassName("BOUND_RECTANGLE_UNSELECTED");
        this.righttopRetangle.setClassName("BOUND_RECTANGLE_UNSELECTED");
        this.leftbottomRetangle.setClassName("BOUND_RECTANGLE_UNSELECTED");
        this.rightbottomRetangle.setClassName("BOUND_RECTANGLE_UNSELECTED");

        //
        this.stopEdit();
    }
};

//
MetaNode.prototype.update = function (observable, arg) {
    this.wrapper.setChanged(true);
    switch (arg) {
      case MetaNodeModel.POSITION_CHANGED:
        this._updatePosition();
        break;
      case MetaNodeModel.SIZE_CHANGED:
        this._updateSize();
        break;
      case MetaModel.TEXT_CHANGED:
        this._updateText();
        break;
      case MetaModel.SELECTED_CHANGED:
        this._updateBoundRectangle();
        break;
      case MetaModel.SUICIDE:
        this._suicide();
        break;
      default:
        break;
    }
};

//
MetaNode.prototype._suicide = function () {
    this.listenerProxy.clear();
    if (!this.wrapper) {
        return;
    }
    this.wrapper.removeMetaNode(this);
};

