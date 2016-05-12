<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
	String sDONO = CurPage.getParameter("DONO");
	if(sDONO == null) sDONO = "";
	
	ASObjectModel doTemp = new ASObjectModel("ObjectModelLibraryList");
	doTemp.setLockCount(2); //锁定两列
	doTemp.setDDDWJbo("GROUPID", "jbo.ui.system.DATAOBJECT_GROUP,DockID,DockName,DONO='"+sDONO+"' order by SortNo");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "0";//编辑模式
	dwTemp.setPageSize(20);
	dwTemp.ConvertCode2Title = "1";
	dwTemp.genHTMLObjectWindow(sDONO);
	
	String sButtons[][] = {
		{"true", "All","Button","快速新增","当前页面新增","afterAdd()","","","","btn_icon_add"},
		{"true", "All","Button","快速保存","快速保存当前页面","afterSave()","","","","btn_icon_save"},
		{"true", "All","Button","快速复制","快速复制当前记录","quickCopy()","","","",""},
		{"true", "All", "Button", "删除", "", "deleteRecord()", "", "", "", ""},
		{"true", "All", "Button", "配置信息分组", "配置信息分组", "setGroup()", "", "", "", "btn_icon_edit"},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	var sDONO = "<%=sDONO%>";
	function afterSave(){
		var dox = "";
		RunJavaMethodTrans("com.amarsoft.app.awe.config.dw.action.DataObjectLibListAction","setDoX","doX=0");
		if(as_isPageChanged()){
			if(confirm('子字段同步更新操作?')){
				dox = "1";
			}else{
				dox = "0";
			}
		}
		RunJavaMethodTrans("com.amarsoft.app.awe.config.dw.action.DataObjectLibListAction","setDoX","doX="+dox);
		as_save(0);
	}
	//快速新增
	function afterAdd(){
		as_add(0);
		//快速新增时候给定默认值
		setItemValue(0,getRow(),"DONO",sDONO);
	}
	function quickCopy(){
		if(as_isPageChanged()){
			alert('页面已经修改过了，请先保存！');
		}else{
			var sColIndex = getItemValue(0,getRow(),"ColIndex");
			var returnValue = doX(sColIndex,"quickCopyLib");
			if(returnValue == 'SUCCESS')alert('复制成功！');
			else alert('对不起，复制失败！');
			reloadSelf();
		}
	}
	//快速删除
	function deleteRecord(){
		if(as_isPageChanged()){
			alert('页面已经修改过了，请先保存！');
		}else{
			var sColIndex = getItemValue(0,getRow(),"ColIndex");
			if(!confirm(getMessageText('AWEW1002'))) return;
			var returnValue = doX(sColIndex,"quickDeleteLib");
			if(returnValue == 'SUCCESS')alert('删除成功！');
			else alert('对不起，删除失败！');
			reloadSelf();	
		}
	}
	//处理function
	function doX(sColIndex,method){
		var doWithX = "0";
		var returnValue = RunJavaMethodTrans("com.amarsoft.app.awe.config.dw.action.DataObjectLibListAction","isAlert","DONO="+sDONO+",ColIndex="+sColIndex);
		if(returnValue == 'SUCCESS'){
			if(confirm('子字段同步更新操作?'))
				doWithX = "1";
			else
				doWithX = "0";		
			returnValue = RunJavaMethodTrans("com.amarsoft.app.awe.config.dw.action.DataObjectLibListAction",method,"DONO="+sDONO+",ColIndex="+sColIndex+",doWithX="+doWithX);
		}else{
			returnValue = RunJavaMethodTrans("com.amarsoft.app.awe.config.dw.action.DataObjectLibListAction",method,"DONO="+sDONO+",ColIndex="+sColIndex+",doWithX="+doWithX);
		}
		return returnValue;
	}
	
	function setGroup(){
		AsControl.PopView("/AppConfig/PageMode/DWConfig/ObjectModelGroupList.jsp","DONO="+sDONO);
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
