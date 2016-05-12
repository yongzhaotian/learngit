<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe:文档附件列表
		Input Param:
       		文档编号:DocNo
		Output Param:

		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "文档附件列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量                     
    String sSql = "";   	
	String sSerialNo=  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sRegCode=  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RegCode"));
	String sType=  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));
	String sPhaseType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseType"));
	String company=Sqlca.getString("select company from store_info where serialno='"+sSerialNo+"'");
	
	if (sPhaseType == null) sPhaseType = "";
	String sObjectType = "RetailApply";
	ARE.getLog().debug("StoreAttachmentList.jsp参数    sSerialNo="+sSerialNo+"Type="+sType+" "+sPhaseType+"company"+company);
	
	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//担保信息项下的抵押物	
	

 	String sTempletNo = "AttachmentList"; //模版编号

	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	String sRegCodeString ="";
 	if(sRegCode==null){
 		sRegCode = "";
 	}else{
 		sRegCodeString=sRegCode.replace(",", "','");
 	}
 	doTemp.WhereClause ="  where  Type='"+sType +"' and ObjectNo in ('"+ sRegCodeString+"') and company='"+company+"'";
 	
	//生成查询条件
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(25);//25条一分页
	
	//删除相应的物理文件;DelDocFile(表名,where语句)
	dwTemp.setEvent("BeforeDelete","!DocumentManage.DelDocFile(DOC_ATTACHMENT,DocNo='#DocNo' and AttachmentNo='#AttachmentNo')");
// 	dwTemp.setEvent("AfterInsert","!DocumentManage.InsertDocRelative(#DocNo,"+sObjectType+","+sObjectNo+")");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//传入显示模板参数
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i)); 
	
	
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
		{CurUser.hasRole("1005")&&((sPhaseType.equals("01"))||(sPhaseType.equals("04")))?"true":"false","","Button","上传附件","上传附件","newRecord()",sResourcesPath},
		{"true","","Button","下载附件","下载附件","viewFile()",sResourcesPath},
		{"true","","Button","批量下载附件","批量下载附件","DownAllFile()",sResourcesPath},
		{CurUser.hasRole("1005")&&((sPhaseType.equals("01"))||(sPhaseType.equals("04")))?"true":"false","","Button","删除","删除","deleteRecord()",sResourcesPath},
		//{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
		};
	





	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	 function mySelectRow(){
		var sDocNo = getItemValue(0,getRow(),"DocNo");
		var sAttachmentNo = getItemValue(0,getRow(),"AttachmentNo");
		if(typeof(sDocNo)=="undefined" || sDocNo.length==0 || typeof(sAttachmentNo)=="undefined" || sAttachmentNo.length==0) {
			AsControl.OpenView("/Blank.jsp","TextToShow=请先选择相应的信息!","rightdown","");
		}else{
			AsControl.OpenView("/BusinessManage/RetailManage/ImageViewInfo.jsp","DocNo="+sDocNo+"&AttachmentNo="+sAttachmentNo,"rightdown","");
		}
	} 
	
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/	
	function newRecord()
	{
		var sType = "<%=sType%>";
		var sObjectNo = "<%=sRegCode%>";
		var company = "<%=company%>";
		popComp("AttachmentChooseDialog","/BusinessManage/RetailManage/StoreAttachmentChooseDialog.jsp","Type="+sType+"&company="+company+"&ObjectNo="+sObjectNo+"&isNtfs=Y","dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		var sAttachmentNo = getItemValue(0,getRow(),"AttachmentNo");
		
		if (typeof(sAttachmentNo)=="undefined" || sAttachmentNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			if(confirm(getHtmlMessage(2))) //您真的想删除该信息吗？
			{
        		as_del('myiframe0');
        		as_save('myiframe0'); 
        		reloadSelf();
    		}
		}
		
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewFile()
	{
		sAttachmentNo = getItemValue(0,getRow(),"AttachmentNo");
		sDocNo= getItemValue(0,getRow(),"DocNo");
		if (typeof(sAttachmentNo)=="undefined" || sAttachmentNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		else
		{
			popComp("AttachmentView","/BusinessManage/RetailManage/AttachmentViewStore.jsp","DocNo="+sDocNo+"&AttachmentNo="+sAttachmentNo);
		}
	}
	/*~[Describe=批量下载;InputParam=无;OutPutParam=无;]~*/
	function DownAllFile(){
		var sType = "<%=sType%>";
		var sObjectNo = "<%=sRegCode%>";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		popComp("AttachmentView","/BusinessManage/RetailManage/DownAllFile.jsp","SerialNo="+sObjectNo+"&Type="+sType+"&Ntfs=S");

	}
	
	function goBack()
	{
		self.close();
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">


	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>
