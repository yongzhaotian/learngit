/****************************************************************************************************
 * ------------------------------
 * ���ڣ�2009/12/08
 * ���ߣ�����
 * ------------------------------
 * д��ǰ�棺����Ȩ�޿���˵��
 * Tab�Լ�Strip�����������
 * 1.����
 * 2.������Ԫ��
 * �����Լ�������Ԫ�ض���������ͬ���ԣ�_isCache,_canClose
 * ���������Էֱ����������Ԫ���Ƿ񻺴��Լ��Ƿ��йرհ�ť
 * �����������Ϊ�޻��棬��ʹԪ�������˻��棬Ԫ�ػ��治��Ч��ֻ������������򿪵�����£�Ԫ�ػ��������Ч
 * �رհ�ť����ͬ����
 ******************************************************************************************************/

/*********************************
 *����˵��������Ԫ�ض��� 
 *********************************/
function TabStripItem(_id,_name,_script){ 
	this.id = _id;						//���
	this.name = _name;					//����
	this._actionScript = _script;		//ִ�нű�
	this._cache = true;					//Ĭ�Ͽɻ���
	this._canClose = true;				//�Ƿ��йرհ�ť��Ĭ����
}
/**
 * ��ȡ���
 * @return
 */
TabStripItem.prototype.getID = function(){
	return this.id;
};
/**
 * ��ȡ����
 * @return
 */
TabStripItem.prototype.getName = function(){
	return this.name;
};
/**
 * �����Ƿ��йرհ�ť
 * @param b
 * @return
 */
TabStripItem.prototype.setCanClose = function(b){
	this._canClose = b;
};
/**
 * ȡ���Ƿ��йرհ�ť
 */
TabStripItem.prototype.getCanClose = function(){
	return this._canClose;
};
/**
 * ��ȡ�Ƿ񻺴�
 * @param b
 * @return
 */
TabStripItem.prototype.setCache = function(b){
	this._cache = b;
};
/**
 * �����Ƿ񻺴�
 * @return
 */
TabStripItem.prototype.getCache = function(){
	return this._cache;
};
/**
 * ȡ�������ű�
 * @return
 */
TabStripItem.prototype.getActionScript = function(){
	return escape(this._actionScript);
};
/**
 * ���ö���ִ�нű�
 * @param s
 * @return
 */
TabStripItem.prototype.setActionScript = function(s){
	this._actionScript = s;
};
/*********************************
 *����˵����Ԫ������ 
 *********************************/
/**
 * @param id ���
 * @param name ����
 * @param view չ�ַ�ʽ��tab,strip
 * @param container ����������
 */
function TabStrip(id,name,view,container){
	this._id = id;							//ID
	this._name = name;						//����
	this._selectedItem = "";				//��ʼ������
	this._view = view;						//չ�ַ�ʽ��tab,strip
	this._tabs = new Array();				//�ӱ�ǩ������
	this._container = $(container);			//����������
	this._isCache 	= true;					//�Ƿ񻺴棬��������ˣ���Tab�л�ʱ������ˢ��ҳ��
	this._canClose = true;					//Ԫ���Ƿ�ɹرգ���������ˣ���Tab�л�ʱ������ˢ��ҳ��
	this._closeCallback = "";				//���ùرհ�ť�Ļص�����
	this._isDialogTitle = false;			//�Ƿ�����DialogTitle������Ҫ�����ʱ�������ã������ط�ûЧ��
	this._debugListenStatu = false;			//�Ƿ������������¼���״̬
	this._isAddButton = false;				//�����Ƿ����������ܰ�ť
	this._addCallback = "";					//�����������ܰ�ť�Ļص�����
	//���Ͳ����ݴ���
	if(this._view != "tab" && this._view != "strip"){
		this._view = "tab";
	}
}
/**
 * ����ID
 * @param _id
 * @return
 */
TabStrip.prototype.setID = function(_id){
	this._id = _id;
};
/**
 * ����ID
 * @param _id
 * @return
 */
TabStrip.prototype.getID = function(){
	return this._id;
};
/**
 * ��������
 * @param _name
 * @return
 */
TabStrip.prototype.setName = function(_name){
	this._name = _name;
};
/**
 * ��������
 * @param _name
 * @return
 */
TabStrip.prototype.getName = function(_name){
	return this._name;
};
/**
 * ����Ĭ��ѡ����
 * @param _id ѡ����ID
 * @return
 */
TabStrip.prototype.setSelectedItem = function(_id){
	this._selectedItem = _id;
};
/**
 * ����Ĭ��ѡ����ID
 * @return
 */
TabStrip.prototype.getSelectedItem = function(){
	return this._selectedItem;
};

/**
 * TAB�����У�iframeǰ׺�����TAB��Ƕ��TAB�����iframe���Ƴ�ͻ�������
 * @return
 */
TabStrip.prototype.getIframePrefix = function(){
	var preFix = "iframe_";
	if(this._view == "tab"){
		preFix = "tab_"+this.getID()+"_iframe_";;
	}else{
		preFix = "strip_"+this.getID()+"_iframe_";;
	}
	return preFix;
};

/**
 * �����Ƿ񻺴�Tab,��������ˣ���Tab�л�ʱ������ˢ��ҳ��
 * @param b
 * @return
 */
TabStrip.prototype.setIsCache = function(b){
	this._isCache = b;
};
/**
 * ��ȡ�Ƿ񻺴�Tab
 * @param b
 * @return
 */
TabStrip.prototype.getIsCache = function(){
	return this._isCache;
};
/**
 * ȡ�������Ƿ������˹رհ�ť
 */
TabStrip.prototype.getCanClose = function(){
	return this._canClose;
};
/**
 * �������������ƹرհ�ť
 */
TabStrip.prototype.setCanClose = function(b){
	this._canClose = b;
};
/**
 * �رհ�ť�����Ļص�����
 * @param s
 * @return
 */
TabStrip.prototype.setCloseCallback = function(s){
	this._closeCallback = s;
};
/**
 * �رհ�ť�����Ļص�����
 * @return
 */
TabStrip.prototype.getCloseCallback = function(){
	return this._closeCallback;
};
/**
 * �Ƿ���Ҫ���ô��ڶԻ�����⣬��Ҫ���ڴ򿪶���ʱ
 * @param b
 * @return
 */
TabStrip.prototype.setIsDialogTitle = function(b){
	this._isDialogTitle = b;
};
/**
 * �����Ƿ������˶Ի������
 */
TabStrip.prototype.getIsDialogTitle = function(){
	return this._isDialogTitle;
};
/**
 * �Ƿ���������ť����
 * @param b
 * @return
 */
TabStrip.prototype.setIsAddButton = function(b){
	this._isAddButton = b;
};
/**
 * �Ƿ���������ť
 * @param b
 * @return
 */
TabStrip.prototype.getIsAddButton = function(){
	return this._isAddButton;
};
/**
 * �����������ܰ�ťִ�нű�
 * @param s
 * @return
 */
TabStrip.prototype.setAddCallback = function(s){
	this._addCallback = s;
};
/**
 * �����������ܰ�ťִ�нű�
 * @param s
 * @return
 */
TabStrip.prototype.getAddCallback = function(){
	return this._addCallback;
};
/**
 * �����Ƿ�������ڼ�����״̬
 * @param b
 * @return
 */
TabStrip.prototype.setDebugListenStatu = function(b){
	this._debugListenStatu = b;
};
/**
 * ��ȡ�Ƿ�������ڼ�����״̬
 * @param b
 * @return
 */
TabStrip.prototype.getDebugListenStatu = function(b){
	return this._debugListenStatu;
};
TabStrip.prototype.genHTML = function(){
	if(this._view == "tab"){
		return this.genTabHTML();
	}else{
		return this.genStripHTML();
	}
};

/**
 * ��ȡ�ڵ����
 * @return
 */
TabStrip.prototype.getItemNumber = function(){
	var count = 0;
	for(var i=0;i<this._tabs.length;i++){
		if(this._tabs[i] != null){
			count ++;
		}
	}
	return count;
};
/**
 * ����һ��ѡ��ҳ���ݣ����ID�ظ��������ʧ�ܣ�����һ����ֵ����ӳɹ����򷵻���ӵĶ���
 * @param _id IDֵ
 * @param _name ѡ������
 * @param _script �ű�
 * @param _isCache �Ƿ񻺴�(true/false)
 * @param _isClose �Ƿ���ʾ�رհ�ť(true/false)
 * @return
 */
TabStrip.prototype.addDataItem = function(_id,_name,_script,_isCache,_isClose){
	//Ѱ��ID�Ƿ��ظ�
	for(var i=0;i<this._tabs.length;i++){
		var item = this._tabs[i];
		if(item != null && item.id == _id){
			return null;
		}
	}
	var tabItem = new TabStripItem(_id,_name,_script);
	//�����Ƿ񻺴棬������������棬Ԫ�ػ��������Ч
	if(this.getIsCache() == true){
		tabItem.setCache(_isCache);
	}else{
		tabItem.setCache(false);
	}
	//�����Ƿ��ܹرգ�������������
	if(this.getCanClose() == true){
		tabItem.setCanClose(_isClose);
	}else{
		tabItem.setCanClose(false);
	}
	this._tabs.push(tabItem);
	return tabItem;
};
/**
 * ���һ��
 * @param _id IDֵ
 * @param _name ����
 * @param _script �ű�
 * @param _isCache �Ƿ񻺴�(true/false)
 * @param _isClose �Ƿ���ʾ�رհ�ť(true/false)
 * @param _isOpen ��Ӻ��Ƿ�������
 * @return
 */
TabStrip.prototype.addItem = function(_id,_name,_script,_cache,_isClose,_isOpen){
	var item = this.addDataItem(_id,_name,_script,_cache,_isClose);
	var b = false;
	if(item != null){
		//����DOM
		if(this._view == "tab"){
			b = this.addTabItem(item,_isOpen);
		}else{
			b = this.addStripItem(item,_isOpen);
		}
	}else{
		$("#handle_"+_id).click();
	}
	return b;
};
/**
 * ɾ��һ��
 * @param _id
 * @return
 */
TabStrip.prototype.deleteItem = function(_id){
	//�Ƴ���������
	for(var i=0;i<this._tabs.length;i++){
		var item = this._tabs[i];
		if(item != null && item.getID() == _id){
			 _selfobj._tabs[i] = null;		//�����������Ƴ��˶�
		}
	}
	if(this._view == "tab"){
		this.deleteTabItem(_id);
	}
};
TabStrip.prototype.init = function(){
	if(this._view == "tab"){
		this.initTab();
	}else{
		this.initStrip();
	}
};
/**
 * ���ߺ��������ڴ����������д����ʱ��ʹ��OpenComp����ʽ���ϰ汾��
 * @param s �ű��ַ���
 * @param itemid �������
 * @return
 */
TabStrip.prototype.convertScript = function(s,itemid){
	var exeScript = s;
	var ItemID = itemid;
	exeScript = exeScript.replace("TabContentFrame",this.getIframePrefix()+ItemID);	//�����ϰ汾����
	//Tab�д�ҳ��ʱ����������˵�����Ӧȥ�������˵������⴦��ò���
	if(exeScript.indexOf("OpenComp(")==0 ||exeScript.indexOf("openComp(")==0){
		//a.ȥ����������,˫����,������
		exeScript = exeScript.replace(/(O|o)penComp\(/,"");
		exeScript = exeScript.replace(/\)/,"").replace(/\"/g,"").replace(/\'/g,"");
		part = exeScript.split(",");
		try{
			compID = part[0];
			url = part[1];
			parameter = part[2];
			target = this.getIframePrefix()+ItemID;	//���ﻻΪ��Ӧframe��name
			if(isNull(parameter)){
				parameter = "_SYSTEM_MENU_FALG=0";		//tab��strip�д򿪵����ݲ���ʾ���˵�
			}else{
				parameter += "&_SYSTEM_MENU_FALG=0";
			}
			exeScript = 'OpenComp("'+compID+'","'+url+'","'+parameter+'","'+target+'")';
		}catch(e){
			//��ֹ�����±�Խ�籨��
		}
	}
	return exeScript;
};
/**************************************************************
 * 
 * ���¶����˶�Tab�Ľڵ����
 * 
 **************************************************************/
/**
 * ����HTML��ʽ��Tabѡ�,ֻ����DOM����
 * @return
 */
TabStrip.prototype.genTabHTML = function(){
	var html = '<div class="tabs" id="'+this.getID()+'">';
	html +='<div class="tabs_button" id="tabs_button_'+this.getID()+'">';
	html +='<ul>';
	for(var i=0;i<this._tabs.length;i++){
		html += '<li id="handle_'+this._tabs[i].getID()+'" _action="'+this._tabs[i].getActionScript()+'" _isclose="'+this._tabs[i].getCanClose()+'" _iscache="'+this._tabs[i].getCache()+'">';
		html += 	'<span class="tab_inactive_left"></span>';
		html += 	'<span class="tab_inactive_center"><a onclick="return false;" href="#">'+this._tabs[i].name+'</a></span>';
		html += 	'<span class="tab_inactive_control"></span>'; 
		html += 	'<span class="tab_inactive_right"></span>'; 
		html += '</li>';
	}
	//����Tab���ܰ�ť
	if(this.getIsAddButton()){
		html += '<li id="addtab_handle_'+this.getID()+'" _action="">';
		html += 	'<span class="addtab_inactive_left"></span>';
		html += 	'<span class="addtab_inactive_center"><a onclick="return false;" href="#"></a></span>';
		html += 	'<span class="addtab_inactive_control"></span>'; 
		html += 	'<span class="addtab_inactive_right"></span>'; 
		html += '</li>';
	}
	html +='</ul>';
	html +='</div>';
	html +='<div class="tabs_content" id="tabs_content_'+this._id+'">';
	for(var j=0;j<this._tabs.length;j++){
		html +='<div id="tab_'+this._tabs[j].id+'">';
		html +='<iframe id="'+this.getIframePrefix()+this._tabs[j].id+'" frameborder="0" name="'+this.getIframePrefix()+this._tabs[j].id+'" src="about:blank"></iframe>';
		html +='</div>';
	}
	html +='</div>';
	html +='</div>';
	return html;
};
/**
 * ��ʼ��
 */
TabStrip.prototype.initTab = function(){
	_selfobj = this;
	tabID = _selfobj.getID();
	//���������
	$(this._container).html(this.genHTML());
	$("#"+tabID+">div>ul").children("li").each(function(){
		//������룬�Ƴ�
		_selfobj.bindTabHover($(this));
		//����
		_selfobj.bindTabClick($(this));
		//˫�����ر�:���û�йرհ�ť��������ر�
		_selfobj.bindTabDbClick($(this));
	});
	//����Ĭ�����ֹû�б�����try...catch����
	try{
		$("#handle_"+_selfobj.getSelectedItem()).click();
	}catch(e){
		alert("�򿪵�"+_selfobj.getSelectedItem()+"��Tab�쳣");
	};
};
/**
 * �ı�Tab��ʾ״̬
 * @param obj
 * @param s
 * @return
 */
TabStrip.prototype.showTabStatus = function(obj,s){
	var prefix = "tab_";
	if(this.isNewTabButton(obj)){	//�½���ť��һ�㰴ťʹ�ò�ͬ��ʽ
		prefix = "addtab_";
	}
	obj.find("span:eq(0)").removeClass();
	obj.find("span:eq(1)").removeClass();
	obj.find("span:eq(2)").removeClass();
	obj.find("span:eq(3)").removeClass();
	obj.find("span:eq(0)").addClass(prefix+s+"_left");
	obj.find("span:eq(1)").addClass(prefix+s+"_center");
	obj.find("span:eq(2)").addClass(prefix+s+"_control");
	obj.find("span:eq(3)").addClass(prefix+s+"_right");
};
/**
 * ��ָ��tab�����hover�¼�
 * @param obj
 * @return
 */
TabStrip.prototype.bindTabHover = function(obj){
	//������ϣ��Ƴ�
	obj.hover(function(){
		//����ƶ��������Ѽ��ť��Ч
		if($(this).data("_active") != "1"){
			_selfobj.showTabStatus($(this),"over");
			//�رհ�ť,ֻ������رյ�����£��Ű󶨹رհ�ť
			if($(this).attr("_isclose") == "true" && $(this).data("_tab_close") != "1"){
				//��ӹرհ�ť
				$(this).find("span:eq(2)").append("<div></div>");
				$(this).find("span:eq(2)").find("div").addClass("tab_close");
				$(this).data("_tab_close","1");
				//Ϊ�رհ�ť���¼�
				_li = $(this);
				$(this).find("span:eq(2)").find("div").click(function(){
					_li.dblclick();
				});
			}
		}
	},function(){
		//����ƶ��������Ѽ��ť��Ч
		if($(this).data("_active") != "1"){
			_selfobj.showTabStatus($(this),"inactive");
			//�Ƴ��رհ�ť
			if($(this).attr("_isclose") == "true" && $(this).data("_tab_close") == "1"){
				$(this).find("span:eq(2)").find("div").remove();
				$(this).data("_tab_close","0");
			}
		}
	});
};

/**
 * ��tab�󶨵����¼�
 * @param obj
 * @return
 */
TabStrip.prototype.bindTabClick = function(obj){
	_selfobj = this;
	if(this.isNewTabButton(obj)){
		obj.click(function(){
			exeScript= _selfobj.getAddCallback();
			exeScript = unescape(exeScript);
			if(!isNull(exeScript)){
				try{
					eval(exeScript);
				}catch(e){
					return;
				}
				return false;
			}
		});
	}else{
		obj.click(function(){
			ItemID = $(this).attr("id").replace(/^handle_/,"");
			$(this).parent("ul").children("li").each(function(i){
				//1.�����ǰ�Ѽ����
				if($(this).data("_active") == "1"){
					_selfobj.showTabStatus($(this),"inactive");
					$(this).data("_active","0");
					//����йرհ�ť��������رհ�ť
					if($(this).attr("_isclose") == "true" && $(this).data("_tab_close") == "1"){
						$(this).find("span:eq(2)").find("div").remove();
						$(this).data("_tab_close","0");
					}
				}
				//�����Ԫ�������˲����棬�������
				if($(this).attr("_iscache") != "true" && $(this).data("_loaded") == "1" ){
					resetItemID = $(this).attr("id").replace(/^handle_/,"");
					iframe = '<iframe id="'+_selfobj.getIframePrefix()+resetItemID+'" frameborder="0" name="'+_selfobj.getIframePrefix()+resetItemID+'" src="about:blank"></iframe>';
					$("#tab_"+resetItemID).empty();
					$("#tab_"+resetItemID).append(iframe);	//���½���iframe
					$(this).data("_loaded","0");
				}
			});
			
			//2.�ѵ�ǰ������Ϊ����
			_selfobj.showTabStatus($(this),"active");
			$(this).data("_active","1");
			//�رհ�ť
			if($(this).attr("_isclose") == "true" && $(this).data("_tab_close") != "1"){
				$(this).find("span:eq(2)").append("<div></div>");
				$(this).find("span:eq(2)").find("div").addClass("tab_close");
				$(this).data("_tab_close","1");
				//Ϊ�رհ�ť���¼�
				_li = $(this);
				$(this).find("span:eq(2)").find("div").click(function(){
					_li.dblclick();
				});
			}
			
			//3.�������д���
			$(this).parents("div.tabs").children("div:eq(1)").children("div").each(function(){
				$(this).css("display","none"); 
			});
			
			//4.��ʾ��ǰ����
			$("#tab_"+ItemID).css("display","block");
			
			//5.����ҳ��
			try{setDialogTitle("&nbsp;&nbsp;");}catch(e){}			//���������
			if($(this).data("_loaded") != "1"){		//����Ѿ����ع��ˣ������ټ�����
				//3.ȡִ�нű�
				exeScript=$(this).attr("_action");
				exeScript = unescape(exeScript);
				exeScript = _selfobj.convertScript(exeScript,ItemID);
				try{
					eval(exeScript);
				}catch(e){
					alert("ѡ�["+$(this).text()+"]ִ�нű�Ϊ["+exeScript+"]���ýű�ִ���쳣");
					return;
				}
				$(this).data("_loaded","1");		//���¼���״̬
			}
				
			//6.2 ���ñ���
			//��¼��title������tab�л�ʱ���������¼��أ������Ҫ��¼��ԭ����title
			//������Ҫ�ر�ע�⣬����ҳ������iframe�д򿪣����Բ�����������ҳ�����ǰ����ִ�е�������
			//����
			oLi = this;
			//6.3 ���öԻ�����⣬��Ҫ���ڴ򿪶���ʱ
			listenNum = 0;
			if(_selfobj.getIsDialogTitle()){
				timeoutID = setInterval(function(){
					if(_selfobj.getDebugListenStatu()){
						$("#"+tabID).before(listenNum+++"-������,����...<br/>");
					}
					if(isNull($(oLi).data("_title")) || unescape($(oLi).data("_title")) == "&nbsp;&nbsp;"){
						dialogTitle = "";
						try{dialogTitle = getDialogTitle();}catch(e){};
						$(oLi).data("_title", escape(dialogTitle));
					}else{
						try{setDialogTitle(unescape($(oLi).data("_title")));}catch(e){};
						clearInterval(timeoutID);						//���óɹ��������ʱ��
					}
				},10);
			}
		//�����¼����ƺŽ���
		});
	}
};

/**
 * ��tab��˫���¼�,��������Tab��ť������˫���¼�
 * @param obj
 * @return
 */
TabStrip.prototype.bindTabDbClick = function(obj){
	_selfobj = this;
	if(this.isNewTabButton(obj)){
		return false;
	}else{
		obj.dblclick(function(e){
			if($(this).attr("_isclose") != "true"){
				return false;
			}
			try{
				ItemID = $(this).attr("id").replace(/^handle_/,"");
				_selfobj.deleteItem(ItemID);					//��DOMģ�����Ƴ�����
				_closeCallback = _selfobj.getCloseCallback();	//�����ص�����
				if(!isNull(_closeCallback)){
					eval(_closeCallback);
				}
			}catch(e){
			}
			return false;
		});
	}
};
/**
 * ���һ����Tab��
 * @param item tab���ݶ���
 * @param _isOpen �Ƿ�������
 * @return
 */
TabStrip.prototype.addTabItem = function(item,_isOpen){
	
	htmlLi = '';
	htmlDiv = '';
	//��ť
	htmlLi += '<li id="handle_'+item.getID()+'" _action="'+item.getActionScript()+'" _isclose="'+item.getCanClose()+'" _iscache="'+item.getCache()+'">';
	htmlLi += 	'<span class="tab_inactive_left"></span>';
	htmlLi += 	'<span class="tab_inactive_center"><a onclick="return false;" href="#">'+item.getName()+'</a></span>';
	htmlLi += 	'<span class="tab_inactive_control"></span>'; 
	htmlLi += 	'<span class="tab_inactive_right"></span>'; 
	htmlLi += '</li>';
	//��������
	htmlDiv +='<div id="tab_'+item.getID()+'">';
	htmlDiv +='<iframe id="'+this.getIframePrefix()+item.getID()+'" frameborder="0" name="'+this.getIframePrefix()+item.getID()+'" src="about:blank"></iframe>';
	htmlDiv +='</div>';
	//�ҵ���ť��������Ӱ�ť��������½���ť����ӵ������ڶ���
	if(!this.getIsAddButton()){
		$("#"+this.getID()+">div>ul").append(htmlLi);
	}else{
		$("#"+this.getID()+">div>ul").find("li:last").before(htmlLi);
	}
	//�ҵ������������������
	$("#tabs_content_"+_selfobj.getID()).append(htmlDiv);
	//���¼�
	this.bindTabHover($("#handle_"+item.getID()));
	this.bindTabClick($("#handle_"+item.getID()));
	this.bindTabDbClick($("#handle_"+item.getID()));
	if(_isOpen){	//�Ƿ�������
		$("#handle_"+item.getID()).click();
	}
	return true;
};

/**
 * ɾ��һ��tab��
 * @param id
 * @return
 */
TabStrip.prototype.deleteTabItem = function(id){
	//1.��ǰһ��Tab
	try{
		//����ǰ�棬�Һ���
		if($("#handle_"+id).prev("li").html() != null){
			$("#handle_"+id).prev("li").click();
		}else if($("#handle_"+id).next("li").html() != null){
			$("#handle_"+id).next("li").click();
		}
		//2.ɾ����ǩ
		$("#handle_"+id).remove();
		//3.ɾ������
		$("#tab_"+id).remove();
	}catch(e){};
};
/**
 * �жϰ�ť�Ƿ�Ϊ����TAB���ܰ�ť
 * @param obj
 * @return
 */
TabStrip.prototype.isNewTabButton = function(obj){
	var id = obj.attr("id");
	var b = false;
	if(isNull(id)){
		id = "";
	}
	if(id.indexOf("addtab_handle_")>-1){
		b = true;
	}
	return b;
};
/**************************************************************
 * 
 * ���¶����˶�Strip�Ľڵ����
 * 
 **************************************************************/
TabStrip.prototype.initStrip = function(){
	_selfobj = this;
	tabID = _selfobj.getID();
	//���������
	$(this._container).html(this.genHTML());
	$("#"+tabID+">div").find("h3").each(function(){
		//������룬�Ƴ�
		_selfobj.bindStripHover($(this));
		//����
		_selfobj.bindStripClick($(this));
	});	
	
	//����Ĭ�����ֹû�б�����try...catch����
	try{
		$("#strip_hand_"+_selfobj.getSelectedItem()).click();
	}catch(e){
	};
};
/**
 * ���һ����Strip
 * @param item
 * @param _isOpen
 * @return
 */
TabStrip.prototype.addStripItem = function(item,_isOpen){
	var htmlItem = '';
	//1.��װ
	htmlItem += '<div id="strip_item_'+item.getID()+'" class="strip_item">';
	htmlItem += 	'<h3 id="strip_hand_'+item.getID()+'" _action="'+item.getActionScript()+'" _iscache="'+item.getCache()+'">';
	htmlItem += 		'<span class="strip_hand_inactive">';
	htmlItem += 			'<span class="arrow_inactive"></span>';
	htmlItem += 			'<span>'+item.getName()+'</span>';
	htmlItem += 		'</span>';
	htmlItem += 	'</h3>';
	htmlItem += 	'<div id="strip_item_container_'+item.getID()+'" class="hidden">';
	htmlItem += 		'<iframe id="'+this.getIframePrefix()+item.getID()+'" frameborder="0" name="'+this.getIframePrefix()+item.getID()+'" src="about:blank"></iframe>';
	htmlItem += 	'</div>';
	htmlItem += '</div>';
	//2.��ӵ�����
	$("#"+this.getID()).append(htmlItem);
	//3.���¼�
	this.bindStripHover($("#strip_hand_"+item.getID()));
	this.bindStripClick($("#strip_hand_"+item.getID()));
	//4.��Ӻ��Ƿ�������
	if(_isOpen){
		$("#strip_hand_"+item.getID()).click();
	}
	return true;
};
/**
 * ����Strip��ʽ��HTML
 * @return
 */
TabStrip.prototype.genStripHTML = function(){
	var html = '';
	html += '<div id="'+this.getID()+'" class="strip_main_content">';
	for(var i=0;i<this._tabs.length;i++){
		html += '<div id="strip_item_'+this._tabs[i].getID()+'" class="strip_item">';
		html += 	'<h3 id="strip_hand_'+this._tabs[i].getID()+'" _action="'+this._tabs[i].getActionScript()+'" _iscache="'+this._tabs[i].getCache()+'">';
		html += 		'<span class="strip_hand_inactive">';
		html += 			'<span class="arrow_inactive"></span>';
		html += 			'<span>'+this._tabs[i].getName()+'</span>';
		html += 		'</span>';
		html += 	'</h3>';
		html += 	'<div id="strip_item_container_'+this._tabs[i].getID()+'" class="hidden">';
		html += 		'<iframe id="'+this.getIframePrefix()+this._tabs[i].getID()+'" frameborder="0" name="'+this.getIframePrefix()+this._tabs[i].getID()+'" src="about:blank"></iframe>';
		html += 	'</div>';
		html += '</div>';
	}
	html +='</div>';
	return html;
};
/**
 * ��Strip��
 * @param obj
 * @return
 */
TabStrip.prototype.bindStripHover = function(obj){
	obj.hover(function(){
		$(this).find("span:eq(0)").removeClass();
		$(this).find("span:eq(0)").addClass("strip_hand_over");
	},function(){
		if($(this).data("_active") != "1"){					//��������Ѽ����hover�Ƴ���Ч
			$(this).find("span:eq(0)").removeClass();
			$(this).find("span:eq(0)").addClass("strip_hand_inactive");
		}
	});
};
/**
 * Strip�����¼���
 * @param obj
 * @return
 */
TabStrip.prototype.bindStripClick = function(obj){
	_selfobj = this;
	obj.click(function(){
		ItemID = $(this).attr("id").replace(/^strip_hand_/,"");
		if($(this).data("_active") != "1"){
			//1.�������
			$(this).find("span:eq(0)").removeClass();
			$(this).find("span:eq(0)").addClass("strip_hand_over");
			//2.ȡ����ʶ��
			//3.ִ�д�
			if($(this).data("_loaded") != "1"){
				exeScript=$(this).attr("_action");
				exeScript = _selfobj.convertScript(exeScript,ItemID);	//�ű�������תת
				exeScript = unescape(exeScript);
				eval(exeScript);
				$(this).data("_loaded","1");
			}
			//4.��ʾ
			$(this).find("span:first").find("span:first").removeClass();
			$(this).find("span:first").find("span:first").addClass("arrow_active");
			$("#strip_item_container_"+ItemID).removeClass();
			$("#strip_item_container_"+ItemID).addClass("show");
			$(this).data("_active","1");
		}else{
			$(this).find("span:first").find("span:first").removeClass();
			$(this).find("span:first").find("span:first").addClass("arrow_inactive");
			$("#strip_item_container_"+ItemID).removeClass();
			$("#strip_item_container_"+ItemID).addClass("hidden");
			$(this).data("_active","0");
		}
	});
};