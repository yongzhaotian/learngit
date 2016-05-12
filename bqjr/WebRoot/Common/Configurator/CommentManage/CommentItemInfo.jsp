<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author:   cwzhan 2004-12-15
		Tester:
		Content:    注释项详情
		Input Param:
                    CommentItemID：    注释项编号
 		Output param:
		                
		History Log: Thong 2005-03-15
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "注释项详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql ="",TempStr="";
	long Value = 0;
	SqlObject so = null;
	String sNewSql = "";
	//获得组件参数	
	String sCommentItemID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CommentItemID"));
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType",10));
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo",10));
	if(sCommentItemID==null) sCommentItemID="";

	String sDefSortNo = "";

	//如果没有传入sCommentItemID，则新增一条，生成一个排序号
	if(sCommentItemID.equals("") && sObjectType!= null){
		if(sObjectType!=null && sObjectType.equals("ComponentDefinition")){
			sNewSql = "select OrderNo from REG_COMP_DEF where CompID=:CompID";
			so=new SqlObject(sNewSql);
			so.setParameter("CompID",sObjectNo);
			sDefSortNo=Sqlca.getString(so);
		}
		sDefSortNo = "20"+sDefSortNo;

		//判断页面是否归类
		if (sDefSortNo.equals("20999999")){
			%>
				<script type="text/javascript">
					alert("你所选择的组件还未归类，无法新增帮助，请先将该组件归类！");
					parent.close();
				</script>
		   <%
			   return ;
		}

		//add by thong
		//如果有重复的值那么找出该列的最大值+10。(给REG_COMMENT_ITEM中的SortNo赋值)
		ASResultSet rsTemp ;
		sNewSql = "select Count(*) from reg_comment_item where SortNo = :SortNo" ;
		so=new SqlObject(sNewSql);
		so.setParameter("SortNo",sDefSortNo);
		rsTemp = Sqlca.getASResultSet(so) ;
		rsTemp.next();
		int iCountTmp = rsTemp.getInt(1);
		if(iCountTmp>0) {
			String tValue = sDefSortNo.substring(0,4) ;
			sNewSql = "select Max(SortNo) from reg_comment_item where Sortno Like :Value";
			so=new SqlObject(sNewSql);
			so.setParameter("Value",tValue);
			ASResultSet rsTemp1 = Sqlca.getASResultSet(so) ;
			if(rsTemp1.next()) {
				String sValue =rsTemp1.getString(1);
				try{
					Value = Long.parseLong(sValue) + 10 ;
				}catch(Exception ex){
					throw new Exception("错误的排序号:"+sValue);
				}
			}
			rsTemp1.getStatement().close();
		}
		rsTemp.getStatement().close();
	}
%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
   	String sHeaders[][] = {
				{"CommentItemID","注释项编号"},
				{"CommentItemName","注释导读"},
				{"SortNo","排序号"},
				{"ChapterNo","章节号"},
				{"CommentItemType","注释项类型"},
				{"CommentText","注释文字内容"},
				{"DocNo","注释文档编号"},
				{"DoGenDesignSpec","是否生成设计文档"},
				{"DoGenHelp","是否生成帮助文件"},
				{"Remark","备注"},
				{"InputUserName","输入人"},
				{"InputUser","输入人"},
				{"InputOrgName","输入机构"},
				{"InputOrg","输入机构"},
				{"InputTime","输入时间"},
				{"UpdateUserName","更新人"},
				{"UpdateUser","更新人"},
				{"UpdateTime","更新时间"}
			       };  

	sSql = " Select  "+
				"CommentItemID,"+
				"CommentItemName,"+
				"SortNo,"+
				"ChapterNo,"+
				"CommentItemType,"+
				"CommentText,"+
				"DocNo,"+
				"DoGenDesignSpec,"+
				"DoGenHelp,"+
				"Remark,"+
				"getUserName(InputUser) as InputUserName,"+
				"InputUser,"+
				"getOrgName(InputOrg) as InputOrgName,"+
				"InputOrg,"+
				"InputTime,"+
				"getUserName(UpdateUser) as UpdateUserName,"+
				"UpdateUser,"+
				"UpdateTime "+
				"From REG_COMMENT_ITEM Where CommentItemID ='"+sCommentItemID+"'";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="REG_COMMENT_ITEM";
	doTemp.setKey("CommentItemID",true);
	doTemp.setHeader(sHeaders);

	doTemp.setDDDWCode("CommentItemType","CommentItemType");
	doTemp.setDDDWCodeTable("DoGenDesignSpec","true,是,false,否");
	doTemp.setDDDWCodeTable("DoGenHelp","true,是,false,否");
	doTemp.setHTMLStyle("CommentItemID,CommentItemName"," style={width:200px} ");
	doTemp.setHTMLStyle("SortNo"," style={width:160px} ");
	doTemp.setHTMLStyle("ChapterNo"," style={width:160px} ");
	doTemp.setHTMLStyle("DocNo"," style={width:160px} ");
	doTemp.setHTMLStyle("InputUser,UpdateUser"," style={width:160px} ");
	doTemp.setHTMLStyle("InputOrg"," style={width:160px} ");
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:130px} ");
	doTemp.setEditStyle("CommentText,Remark","3");
	doTemp.setHTMLStyle("CommentText,Remark"," style={height:100px;width:600px;overflow:auto} ");
    doTemp.appendHTMLStyle("CommentText"," onDBLClick=\"parent.editObjectValueWithScriptEditorForComment(this)\" style={width=400px;height=150px;overflow:auto;} ");
 	//doTemp.setLimit("Remark,CommentText",200);
	
	doTemp.setDefaultValue("DoGenDesignSpec","01");
	doTemp.setDefaultValue("DoGenHelp","01");
	doTemp.setDefaultValue("CommentItemType","020");
	if(Value == 0) {
		doTemp.setDefaultValue("SortNo",sDefSortNo);
		doTemp.setDefaultValue("CommentItemID",sDefSortNo);
	}else {
		TempStr = String.valueOf(Value) ;
		doTemp.setDefaultValue("SortNo",TempStr);
		doTemp.setDefaultValue("CommentItemID",TempStr);
	}

	doTemp.setReadOnly("InputUserName,UpdateUserName,InputOrgName,InputTime,UpdateTime",true);
	doTemp.setVisible("InputUser,InputOrg,UpdateUser,DocNo",false);    	
	doTemp.setUpdateable("InputUserName,InputOrgName,UpdateUserName",false);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);

	//filter过滤条件
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//定义后续事件
	dwTemp.setEvent("AfterInsert","!Configurator.InsertCommRela(#CommentItemID,'"+sObjectType+"','"+sObjectNo+"')");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sCriteriaAreaHTML = ""; 
%>

<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径
	String sButtons[][] = {
		{"true","","Button","保存","保存修改","saveRecord()",sResourcesPath},
		{"true","","Button","保存并新增","保存修改并新增另一条记录","saveRecordAndAdd()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
    var sCurCommentItemID=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(){
		var sReturnValue = PopPageAjax("/Common/Configurator/CommentManage/GetBooleanValueAjax.jsp?sTempStr=<%=TempStr%>&rand="+randomNumber(),"", "dialogWidth:280px; dialogHeight:200px; help: no; scroll: no; status: no");
		if(typeof(sReturnValue) == "unedfined" || sReturnValue == "") {
			alert("保存时出错请与系统管理员联系！");
			return ;
		}else if(sReturnValue != "" && sReturnValue == '1') {
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
			as_save("myiframe0","");
		}else {
			setItemValue(0,0,"SortNo",sReturnValue);
			setItemValue(0,0,"CommentItemID",sReturnValue);
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
			as_save("myiframe0","");
		}
	}
    /*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndBack(){
        setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
        as_save("myiframe0","doReturn('Y');");
	}

    /*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndAdd(){
        as_save("myiframe0","newRecord()");
	}

    /*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"CommentItemID");
        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

    /*~[Describe=新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord(){
        OpenComp("CommentItemInfo","/Common/Configurator/CommentManage/CommentItemInfo.jsp","","_self","");
	}

    function editObjectValueWithScriptEditorForComment(oObject){
		sInput = oObject.value;
		//alert(sInput);
		sInput = real2Amarsoft(sInput);
		sInput = replaceAll(sInput,"~","$[wave]");
		//alert(sInput);
		oTempObj = oObject;
        saveParaToComp("ScriptText="+sInput,"openScriptEditorForASScriptAndSetText()");
	}
    
    function openScriptEditorForASScriptAndSetText(){
		var oMyobj = oTempObj;
		<%
			if(TempStr != "" || TempStr != null){
				sDefSortNo = TempStr ;
			}
		%>
		sOutPut = popComp("ScriptEditorForComment","/Common/ScriptEditor/ScriptEditorForComment.jsp","CommentItemID=<%=sDefSortNo%>","");
		if(typeof(sOutPut)!="undefined" && sOutPut!="_CANCEL_")
		{
			oMyobj.value = amarsoft2Real(sOutPut);
		}
	}

	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
 
			bIsInsert = true;
		}
	}
    </script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
