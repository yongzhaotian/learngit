<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: 用款记录列表
		
		Input Param:
		SerialNo:流水号
		ObjectType:对象类型
		ObjectNo：对象编号
		
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "新增用款记录"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	SqlObject so = null;
	//获得组件参数
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sObjectNo   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
		
	
	 ASDataObject doTemp = null;
	 String sTempletNo = "UsedRecordList";
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//新增模型：2013-5-9
	
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置为只读
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo+","+sObjectNo+","+sObjectType);//新增参数传递：2013-5-9
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
		{"true","","Button","新增","新增提款记录","newRecord()",sResourcesPath},
		{"true","","Button","删除","删除提款记录","deleteRecord()",sResourcesPath},
		{"false","","Button","用款记录查询","入账账号提款查询","viewDrawing()",sResourcesPath},
		};
	//检查该报告是否已完成	
	String sSql="select Finishdate from INSPECT_INFO where SerialNo=:SerialNo and ObjectNo=:ObjectNo and  ObjectType=:ObjectType";//加了变量定义String：2013-5-9
	so = new SqlObject(sSql).setParameter("SerialNo",sSerialNo)
	.setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType);
	ASResultSet rs = Sqlca.getResultSet(so);
	if(rs.next()){
		String s =(String)rs.getString("Finishdate");
		if(s != null){
			sButtons[0][0] = "false";
			sButtons[1][0] = "false";
			sButtons[2][0] = "false";
		}
	}
	rs.getStatement().close();
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord(){
		OpenPage("/CreditManage/CreditCheck/UsedRecordInfo.jsp?SerialNo=<%=sSerialNo%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&rand="+randomNumber(),"_self","");
	}

	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
		}else{
			if (confirm("您确定要删除该记录吗？")){
				as_del('myiframe0');
				as_save('myiframe0');
			}
		}
	}
	/*~[Describe=完成;InputParam=无;OutPutParam=无;]~*/
	function viewDrawing(){
		sSerialNo = "<%=sSerialNo%>";
		sObjectNo = "<%=sObjectNo%>";
		sObjectType = "<%=sObjectType%>";

		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{ 
			sReturn=PopPage("/CreditManage/CreditCheck/getDrawingDialog.jsp","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
			if (typeof(sReturn)!="undefined" && sReturn !="_none_" && sReturn.length !=0){
				popComp("getDrawingInfo","/CreditManage/CreditCheck/getDrawingInfo.jsp","SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&"+sReturn,"resizable=yes;dialogWidth=50;dialogHeight=40;center:yes;status:no;statusbar:yes");					
			}	
		}
	}
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

