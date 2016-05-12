<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 业务基本信息
		Input Param:
				 SerialNo：业务申请流水号
	 */
	String PG_TITLE = "业务基本信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//定义变量
	String sTable="";
	
	//获得页面参数	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));	
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType"));
	
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sApplyType == null) sApplyType="";
	
	//2010/08/03 sxjiang 在申请详情页面查看的时候，查看该笔业务关联哪个债务重组
	//主要是因为债务重组的信息存放在Business_Apply中，而此时查看的业务申请信息也是存放在Business_Apply中
	//但在list页面只能传一个serialNo进来，所以在此先要检索该业务是否有关联的债务重组信息
	if(sApplyType.indexOf("Apply") > -1 && sObjectType.equalsIgnoreCase("NPAReformApply")){
		String ObjectNo_temp = "";
		String sSql = "select ObjectNo from Apply_Relative where ObjectType = 'NPAReformApply' and SerialNo = :SerialNo ";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
		while(rs.next()){
			ObjectNo_temp = rs.getString(1);
		}
		rs.getStatement().close();
		if(!"".equals(ObjectNo_temp)){   //如果在关联表Apply_Relative中查到有关联的债务重组信息，则把这个ObjectNo_temp给sObjectNo进行后续操作
			sObjectNo = ObjectNo_temp;
		}
	}

	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "";
	if(sApplyType.equals("01"))
		sTempletNo = "NPAReformApplyInfo";
	else
		sTempletNo = "NPAReformApplyInfo2";
		
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
		
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”
	/*~[Describe=保存;]~*/
	function saveRecord(sPostEvents){	
		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
		
	/*~[Describe=执行更新操作前执行的代码;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"OperateOrgID","<%=CurOrg.getOrgID()%>");		
		setItemValue(0,0,"OperateUserID","<%=CurUser.getUserID()%>");					
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>