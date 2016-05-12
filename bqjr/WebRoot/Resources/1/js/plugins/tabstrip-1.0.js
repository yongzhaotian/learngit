/****************************************************************************************************
 * ------------------------------
 * 日期：2009/12/08
 * 作者：杨松
 * ------------------------------
 * 写在前面：容器权限控制说明
 * Tab以及Strip包含两类对象
 * 1.容器
 * 2.容器中元素
 * 容器以及容器中元素都有两个共同属性：_isCache,_canClose
 * 这两个属性分别控制容器中元素是否缓存以及是否有关闭按钮
 * 如果容器设置为无缓存，即使元素设置了缓存，元素缓存不生效，只有在容器缓存打开的情况下，元素缓存才能生效
 * 关闭按钮属性同缓存
 ******************************************************************************************************/

/*********************************
 *对象说明：容器元素定义 
 *********************************/
function TabStripItem(_id,_name,_script){ 
	this.id = _id;						//编号
	this.name = _name;					//名称
	this._actionScript = _script;		//执行脚本
	this._cache = true;					//默认可缓存
	this._canClose = true;				//是否有关闭按钮，默认有
}
/**
 * 获取编号
 * @return
 */
TabStripItem.prototype.getID = function(){
	return this.id;
};
/**
 * 获取名称
 * @return
 */
TabStripItem.prototype.getName = function(){
	return this.name;
};
/**
 * 设置是否有关闭按钮
 * @param b
 * @return
 */
TabStripItem.prototype.setCanClose = function(b){
	this._canClose = b;
};
/**
 * 取出是否有关闭按钮
 */
TabStripItem.prototype.getCanClose = function(){
	return this._canClose;
};
/**
 * 获取是否缓存
 * @param b
 * @return
 */
TabStripItem.prototype.setCache = function(b){
	this._cache = b;
};
/**
 * 设置是否缓存
 * @return
 */
TabStripItem.prototype.getCache = function(){
	return this._cache;
};
/**
 * 取出动作脚本
 * @return
 */
TabStripItem.prototype.getActionScript = function(){
	return escape(this._actionScript);
};
/**
 * 设置动作执行脚本
 * @param s
 * @return
 */
TabStripItem.prototype.setActionScript = function(s){
	this._actionScript = s;
};
/*********************************
 *对象说明：元素容器 
 *********************************/
/**
 * @param id 编号
 * @param name 名称
 * @param view 展现方式：tab,strip
 * @param container 组件存放容器
 */
function TabStrip(id,name,view,container){
	this._id = id;							//ID
	this._name = name;						//名称
	this._selectedItem = "";				//初始化打开项
	this._view = view;						//展现方式：tab,strip
	this._tabs = new Array();				//子标签项容器
	this._container = $(container);			//组件存放容器
	this._isCache 	= true;					//是否缓存，如果缓存了，则Tab切换时，不再刷新页面
	this._canClose = true;					//元素是否可关闭，如果缓存了，则Tab切换时，不再刷新页面
	this._closeCallback = "";				//设置关闭按钮的回调函数
	this._isDialogTitle = false;			//是否设置DialogTitle，主在要对象打开时，会有用，其它地方没效果
	this._debugListenStatu = false;			//是否输出调试情况下监听状态
	this._isAddButton = false;				//设置是否有新增功能按钮
	this._addCallback = "";					//设置新增功能按钮的回调函数
	//类型参数容错处理
	if(this._view != "tab" && this._view != "strip"){
		this._view = "tab";
	}
}
/**
 * 设置ID
 * @param _id
 * @return
 */
TabStrip.prototype.setID = function(_id){
	this._id = _id;
};
/**
 * 返回ID
 * @param _id
 * @return
 */
TabStrip.prototype.getID = function(){
	return this._id;
};
/**
 * 设置名称
 * @param _name
 * @return
 */
TabStrip.prototype.setName = function(_name){
	this._name = _name;
};
/**
 * 返回名称
 * @param _name
 * @return
 */
TabStrip.prototype.getName = function(_name){
	return this._name;
};
/**
 * 设置默认选中项
 * @param _id 选中项ID
 * @return
 */
TabStrip.prototype.setSelectedItem = function(_id){
	this._selectedItem = _id;
};
/**
 * 返回默认选中项ID
 * @return
 */
TabStrip.prototype.getSelectedItem = function(){
	return this._selectedItem;
};

/**
 * TAB窗口中，iframe前缀（解决TAB中嵌套TAB会出现iframe名称冲突的情况）
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
 * 设置是否缓存Tab,如果缓存了，则Tab切换时，不再刷新页面
 * @param b
 * @return
 */
TabStrip.prototype.setIsCache = function(b){
	this._isCache = b;
};
/**
 * 获取是否缓存Tab
 * @param b
 * @return
 */
TabStrip.prototype.getIsCache = function(){
	return this._isCache;
};
/**
 * 取出容器是否限制了关闭按钮
 */
TabStrip.prototype.getCanClose = function(){
	return this._canClose;
};
/**
 * 设置容器是限制关闭按钮
 */
TabStrip.prototype.setCanClose = function(b){
	this._canClose = b;
};
/**
 * 关闭按钮点击后的回调函数
 * @param s
 * @return
 */
TabStrip.prototype.setCloseCallback = function(s){
	this._closeCallback = s;
};
/**
 * 关闭按钮点击后的回调函数
 * @return
 */
TabStrip.prototype.getCloseCallback = function(){
	return this._closeCallback;
};
/**
 * 是否需要设置窗口对话框标题，主要用在打开对象时
 * @param b
 * @return
 */
TabStrip.prototype.setIsDialogTitle = function(b){
	this._isDialogTitle = b;
};
/**
 * 返回是否设置了对话框标题
 */
TabStrip.prototype.getIsDialogTitle = function(){
	return this._isDialogTitle;
};
/**
 * 是否有新增按钮开关
 * @param b
 * @return
 */
TabStrip.prototype.setIsAddButton = function(b){
	this._isAddButton = b;
};
/**
 * 是否有新增按钮
 * @param b
 * @return
 */
TabStrip.prototype.getIsAddButton = function(){
	return this._isAddButton;
};
/**
 * 设置新增功能按钮执行脚本
 * @param s
 * @return
 */
TabStrip.prototype.setAddCallback = function(s){
	this._addCallback = s;
};
/**
 * 返回新增功能按钮执行脚本
 * @param s
 * @return
 */
TabStrip.prototype.getAddCallback = function(){
	return this._addCallback;
};
/**
 * 设置是否输出正在监听的状态
 * @param b
 * @return
 */
TabStrip.prototype.setDebugListenStatu = function(b){
	this._debugListenStatu = b;
};
/**
 * 获取是否输出正在监听的状态
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
 * 获取节点个数
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
 * 增加一个选项页数据，如果ID重复，则添加失败，返回一个空值，添加成功，则返回添加的对象
 * @param _id ID值
 * @param _name 选卡名称
 * @param _script 脚本
 * @param _isCache 是否缓存(true/false)
 * @param _isClose 是否显示关闭按钮(true/false)
 * @return
 */
TabStrip.prototype.addDataItem = function(_id,_name,_script,_isCache,_isClose){
	//寻找ID是否重复
	for(var i=0;i<this._tabs.length;i++){
		var item = this._tabs[i];
		if(item != null && item.id == _id){
			return null;
		}
	}
	var tabItem = new TabStripItem(_id,_name,_script);
	//设置是否缓存，如果容器允许缓存，元素缓存才能生效
	if(this.getIsCache() == true){
		tabItem.setCache(_isCache);
	}else{
		tabItem.setCache(false);
	}
	//设置是否能关闭，容器设置优先
	if(this.getCanClose() == true){
		tabItem.setCanClose(_isClose);
	}else{
		tabItem.setCanClose(false);
	}
	this._tabs.push(tabItem);
	return tabItem;
};
/**
 * 添加一项
 * @param _id ID值
 * @param _name 名称
 * @param _script 脚本
 * @param _isCache 是否缓存(true/false)
 * @param _isClose 是否显示关闭按钮(true/false)
 * @param _isOpen 添加后是否立即打开
 * @return
 */
TabStrip.prototype.addItem = function(_id,_name,_script,_cache,_isClose,_isOpen){
	var item = this.addDataItem(_id,_name,_script,_cache,_isClose);
	var b = false;
	if(item != null){
		//操作DOM
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
 * 删除一项
 * @param _id
 * @return
 */
TabStrip.prototype.deleteItem = function(_id){
	//移除此数据项
	for(var i=0;i<this._tabs.length;i++){
		var item = this._tabs[i];
		if(item != null && item.getID() == _id){
			 _selfobj._tabs[i] = null;		//从数据项中移除此顶
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
 * 工具函数，用于处理在容器中打开组件时，使用OpenComp的形式（老版本）
 * @param s 脚本字符串
 * @param itemid 容器编号
 * @return
 */
TabStrip.prototype.convertScript = function(s,itemid){
	var exeScript = s;
	var ItemID = itemid;
	exeScript = exeScript.replace("TabContentFrame",this.getIframePrefix()+ItemID);	//兼容老版本配置
	//Tab中打开页面时，如果有主菜单，则应去除其主菜单，特殊处理该参数
	if(exeScript.indexOf("OpenComp(")==0 ||exeScript.indexOf("openComp(")==0){
		//a.去除两端括号,双引号,单引号
		exeScript = exeScript.replace(/(O|o)penComp\(/,"");
		exeScript = exeScript.replace(/\)/,"").replace(/\"/g,"").replace(/\'/g,"");
		part = exeScript.split(",");
		try{
			compID = part[0];
			url = part[1];
			parameter = part[2];
			target = this.getIframePrefix()+ItemID;	//这里换为相应frame的name
			if(isNull(parameter)){
				parameter = "_SYSTEM_MENU_FALG=0";		//tab或strip中打开的内容不显示主菜单
			}else{
				parameter += "&_SYSTEM_MENU_FALG=0";
			}
			exeScript = 'OpenComp("'+compID+'","'+url+'","'+parameter+'","'+target+'")';
		}catch(e){
			//防止数组下标越界报错
		}
	}
	return exeScript;
};
/**************************************************************
 * 
 * 以下定义了对Tab的节点操作
 * 
 **************************************************************/
/**
 * 生成HTML格式的Tab选项卡,只生成DOM数据
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
	//新增Tab功能按钮
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
 * 初始化
 */
TabStrip.prototype.initTab = function(){
	_selfobj = this;
	tabID = _selfobj.getID();
	//添加至容器
	$(this._container).html(this.genHTML());
	$("#"+tabID+">div>ul").children("li").each(function(){
		//鼠标移入，移出
		_selfobj.bindTabHover($(this));
		//单击
		_selfobj.bindTabClick($(this));
		//双击，关闭:如果没有关闭按钮，则不允许关闭
		_selfobj.bindTabDbClick($(this));
	});
	//设置默认项，防止没有报错，用try...catch包裹
	try{
		$("#handle_"+_selfobj.getSelectedItem()).click();
	}catch(e){
		alert("打开第"+_selfobj.getSelectedItem()+"个Tab异常");
	};
};
/**
 * 改变Tab显示状态
 * @param obj
 * @param s
 * @return
 */
TabStrip.prototype.showTabStatus = function(obj,s){
	var prefix = "tab_";
	if(this.isNewTabButton(obj)){	//新建按钮和一般按钮使用不同样式
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
 * 结指定tab对象绑定hover事件
 * @param obj
 * @return
 */
TabStrip.prototype.bindTabHover = function(obj){
	//鼠标移上，移出
	obj.hover(function(){
		//鼠标移动，对于已激活按钮无效
		if($(this).data("_active") != "1"){
			_selfobj.showTabStatus($(this),"over");
			//关闭按钮,只有允许关闭的情况下，才绑定关闭按钮
			if($(this).attr("_isclose") == "true" && $(this).data("_tab_close") != "1"){
				//添加关闭按钮
				$(this).find("span:eq(2)").append("<div></div>");
				$(this).find("span:eq(2)").find("div").addClass("tab_close");
				$(this).data("_tab_close","1");
				//为关闭按钮绑定事件
				_li = $(this);
				$(this).find("span:eq(2)").find("div").click(function(){
					_li.dblclick();
				});
			}
		}
	},function(){
		//鼠标移动，对于已激活按钮无效
		if($(this).data("_active") != "1"){
			_selfobj.showTabStatus($(this),"inactive");
			//移除关闭按钮
			if($(this).attr("_isclose") == "true" && $(this).data("_tab_close") == "1"){
				$(this).find("span:eq(2)").find("div").remove();
				$(this).data("_tab_close","0");
			}
		}
	});
};

/**
 * 给tab绑定单击事件
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
				//1.清除当前已激活的
				if($(this).data("_active") == "1"){
					_selfobj.showTabStatus($(this),"inactive");
					$(this).data("_active","0");
					//如果有关闭按钮，则清除关闭按钮
					if($(this).attr("_isclose") == "true" && $(this).data("_tab_close") == "1"){
						$(this).find("span:eq(2)").find("div").remove();
						$(this).data("_tab_close","0");
					}
				}
				//如果有元素设置了不缓存，则清除它
				if($(this).attr("_iscache") != "true" && $(this).data("_loaded") == "1" ){
					resetItemID = $(this).attr("id").replace(/^handle_/,"");
					iframe = '<iframe id="'+_selfobj.getIframePrefix()+resetItemID+'" frameborder="0" name="'+_selfobj.getIframePrefix()+resetItemID+'" src="about:blank"></iframe>';
					$("#tab_"+resetItemID).empty();
					$("#tab_"+resetItemID).append(iframe);	//重新建立iframe
					$(this).data("_loaded","0");
				}
			});
			
			//2.把当前项设置为激活
			_selfobj.showTabStatus($(this),"active");
			$(this).data("_active","1");
			//关闭按钮
			if($(this).attr("_isclose") == "true" && $(this).data("_tab_close") != "1"){
				$(this).find("span:eq(2)").append("<div></div>");
				$(this).find("span:eq(2)").find("div").addClass("tab_close");
				$(this).data("_tab_close","1");
				//为关闭按钮绑定事件
				_li = $(this);
				$(this).find("span:eq(2)").find("div").click(function(){
					_li.dblclick();
				});
			}
			
			//3.隐藏所有窗口
			$(this).parents("div.tabs").children("div:eq(1)").children("div").each(function(){
				$(this).css("display","none"); 
			});
			
			//4.显示当前窗口
			$("#tab_"+ItemID).css("display","block");
			
			//5.加载页面
			try{setDialogTitle("&nbsp;&nbsp;");}catch(e){}			//先清除标题
			if($(this).data("_loaded") != "1"){		//如果已经加载过了，则不用再加载了
				//3.取执行脚本
				exeScript=$(this).attr("_action");
				exeScript = unescape(exeScript);
				exeScript = _selfobj.convertScript(exeScript,ItemID);
				try{
					eval(exeScript);
				}catch(e){
					alert("选项卡["+$(this).text()+"]执行脚本为["+exeScript+"]，该脚本执行异常");
					return;
				}
				$(this).data("_loaded","1");		//记下加载状态
			}
				
			//6.2 设置标题
			//记录下title，由于tab切换时，不再重新加载，因此需要记录下原来的title
			//这里需要特别注意，由于页面是在iframe中打开，所以不会阻塞，在页面打开以前，就执行到这里了
			//监听
			oLi = this;
			//6.3 设置对话框标题，主要用在打开对象时
			listenNum = 0;
			if(_selfobj.getIsDialogTitle()){
				timeoutID = setInterval(function(){
					if(_selfobj.getDebugListenStatu()){
						$("#"+tabID).before(listenNum+++"-加载中,监听...<br/>");
					}
					if(isNull($(oLi).data("_title")) || unescape($(oLi).data("_title")) == "&nbsp;&nbsp;"){
						dialogTitle = "";
						try{dialogTitle = getDialogTitle();}catch(e){};
						$(oLi).data("_title", escape(dialogTitle));
					}else{
						try{setDialogTitle(unescape($(oLi).data("_title")));}catch(e){};
						clearInterval(timeoutID);						//设置成功后，清除定时器
					}
				},10);
			}
		//单击事件后推号结束
		});
	}
};

/**
 * 给tab绑定双击事件,对于新增Tab按钮，不绑定双击事件
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
				_selfobj.deleteItem(ItemID);					//从DOM模型中移除数据
				_closeCallback = _selfobj.getCloseCallback();	//触发回调函数
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
 * 添加一个新Tab项
 * @param item tab数据对象
 * @param _isOpen 是否立即打开
 * @return
 */
TabStrip.prototype.addTabItem = function(item,_isOpen){
	
	htmlLi = '';
	htmlDiv = '';
	//按钮
	htmlLi += '<li id="handle_'+item.getID()+'" _action="'+item.getActionScript()+'" _isclose="'+item.getCanClose()+'" _iscache="'+item.getCache()+'">';
	htmlLi += 	'<span class="tab_inactive_left"></span>';
	htmlLi += 	'<span class="tab_inactive_center"><a onclick="return false;" href="#">'+item.getName()+'</a></span>';
	htmlLi += 	'<span class="tab_inactive_control"></span>'; 
	htmlLi += 	'<span class="tab_inactive_right"></span>'; 
	htmlLi += '</li>';
	//内容容器
	htmlDiv +='<div id="tab_'+item.getID()+'">';
	htmlDiv +='<iframe id="'+this.getIframePrefix()+item.getID()+'" frameborder="0" name="'+this.getIframePrefix()+item.getID()+'" src="about:blank"></iframe>';
	htmlDiv +='</div>';
	//找到按钮容器，添加按钮（如果有新建按钮，添加到倒数第二）
	if(!this.getIsAddButton()){
		$("#"+this.getID()+">div>ul").append(htmlLi);
	}else{
		$("#"+this.getID()+">div>ul").find("li:last").before(htmlLi);
	}
	//找到内容容器，添加内容
	$("#tabs_content_"+_selfobj.getID()).append(htmlDiv);
	//绑定事件
	this.bindTabHover($("#handle_"+item.getID()));
	this.bindTabClick($("#handle_"+item.getID()));
	this.bindTabDbClick($("#handle_"+item.getID()));
	if(_isOpen){	//是否打开添加项
		$("#handle_"+item.getID()).click();
	}
	return true;
};

/**
 * 删除一个tab项
 * @param id
 * @return
 */
TabStrip.prototype.deleteTabItem = function(id){
	//1.打开前一个Tab
	try{
		//找完前面，找后面
		if($("#handle_"+id).prev("li").html() != null){
			$("#handle_"+id).prev("li").click();
		}else if($("#handle_"+id).next("li").html() != null){
			$("#handle_"+id).next("li").click();
		}
		//2.删除标签
		$("#handle_"+id).remove();
		//3.删除内容
		$("#tab_"+id).remove();
	}catch(e){};
};
/**
 * 判断按钮是否为新增TAB功能按钮
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
 * 以下定义了对Strip的节点操作
 * 
 **************************************************************/
TabStrip.prototype.initStrip = function(){
	_selfobj = this;
	tabID = _selfobj.getID();
	//添加至容器
	$(this._container).html(this.genHTML());
	$("#"+tabID+">div").find("h3").each(function(){
		//鼠标移入，移出
		_selfobj.bindStripHover($(this));
		//单击
		_selfobj.bindStripClick($(this));
	});	
	
	//设置默认项，防止没有报错，用try...catch包裹
	try{
		$("#strip_hand_"+_selfobj.getSelectedItem()).click();
	}catch(e){
	};
};
/**
 * 添加一个新Strip
 * @param item
 * @param _isOpen
 * @return
 */
TabStrip.prototype.addStripItem = function(item,_isOpen){
	var htmlItem = '';
	//1.组装
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
	//2.添加到容器
	$("#"+this.getID()).append(htmlItem);
	//3.绑定事件
	this.bindStripHover($("#strip_hand_"+item.getID()));
	this.bindStripClick($("#strip_hand_"+item.getID()));
	//4.添加后，是否立即打开
	if(_isOpen){
		$("#strip_hand_"+item.getID()).click();
	}
	return true;
};
/**
 * 返回Strip形式的HTML
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
 * 给Strip绑定
 * @param obj
 * @return
 */
TabStrip.prototype.bindStripHover = function(obj){
	obj.hover(function(){
		$(this).find("span:eq(0)").removeClass();
		$(this).find("span:eq(0)").addClass("strip_hand_over");
	},function(){
		if($(this).data("_active") != "1"){					//如果该项已激活，则hover移出无效
			$(this).find("span:eq(0)").removeClass();
			$(this).find("span:eq(0)").addClass("strip_hand_inactive");
		}
	});
};
/**
 * Strip单击事件绑定
 * @param obj
 * @return
 */
TabStrip.prototype.bindStripClick = function(obj){
	_selfobj = this;
	obj.click(function(){
		ItemID = $(this).attr("id").replace(/^strip_hand_/,"");
		if($(this).data("_active") != "1"){
			//1.设置外观
			$(this).find("span:eq(0)").removeClass();
			$(this).find("span:eq(0)").addClass("strip_hand_over");
			//2.取出标识号
			//3.执行打开
			if($(this).data("_loaded") != "1"){
				exeScript=$(this).attr("_action");
				exeScript = _selfobj.convertScript(exeScript,ItemID);	//脚本兼容性转转
				exeScript = unescape(exeScript);
				eval(exeScript);
				$(this).data("_loaded","1");
			}
			//4.显示
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