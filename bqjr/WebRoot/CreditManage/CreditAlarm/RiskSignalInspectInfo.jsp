<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 预警信号检查报告信息_info
		Input Param:
			  ObjectType:对象类型
			  ObjectNo：对象编号   
	 */
	String PG_TITLE = "预警信号检查报告信息"; // 浏览器窗口标题 <title> PG_TITLE </title>

	//定义变量
	String sSql = "";

	//获得页面参数	
	String sObjectType =  CurPage.getParameter("ObjectType");
	String sObjectNo =  CurPage.getParameter("ObjectNo");
	//将空值转化为空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	//	获取预警信号检查报告流水号
	sSql ="select SerialNo from INSPECT_INFO where ObjectType =:ObjectType and ObjectNo =:ObjectNo";
	String sSerialNo = Sqlca.getString(new SqlObject(sSql).setParameter("ObjectType",sObjectType).setParameter("ObjectNo",sObjectNo));
	if(sSerialNo == null) sSerialNo = "";
	
	String[][] sHeaders = {
							{"Opinion1","业务"},
							{"Opinion2","现状/问题"},
							{"Opinion3","紧急行动结果"},
							{"Opinion4","处理结果"},							
							{"Remark","备注"},
							{"InspectOrgName","检查机构"},
							{"InspectUserName","检查人"},
							{"InspectDate","检查时间"},
							{"UpdateDate","更新时间"}
						};
		
	sSql =  " select SerialNo,ObjectType,ObjectNo,InspectType,UptoDate, "+
			" Opinion1,Opinion2,Opinion3,Opinion4,Remark,InspectOrgID, "+
			" getOrgName(InspectOrgID) as InspectOrgName,InspectUserID, "+
			" getUserName(InspectUserID) as InspectUserName,InspectDate, "+
			" InputOrgID,InputUserID,InputDate,FinishDate "+
			" from INSPECT_INFO "+
			" where ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sObjectNo+"' ";
			
	//通过SQL语句产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable="INSPECT_INFO";
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);

	//设置只读属性
	doTemp.setReadOnly("Opinion1,Opinion2,Opinion3,Opinion4,Remark,InspectOrgName,InspectUserName,InspectDate",true);
	if(sSerialNo.equals(""))doTemp.setReadOnly("Opinion1,Opinion2,Opinion3,Opinion4,Remark",false);
	//设置必输属性
	doTemp.setRequired("Opinion1,Opinion2",true);
	//设置不可见属性
	doTemp.setVisible("SerialNo,ObjectType,ObjectNo,InspectType,UptoDate,InspectOrgID",false);
	doTemp.setVisible("InspectUserID,InputOrgID,InputUserID,InputDate,FinishDate",false);
	//设置不可更新
	doTemp.setUpdateable("InspectOrgName,InspectUserName",false);
	//设置格式
	doTemp.setHTMLStyle("InspectUserName,InspectDate,UpdateDate"," style={width:80px;} ");
	doTemp.setHTMLStyle("Opinion1,Opinion2,Opinion3,Opinion4,Remark"," style={height:100px;width:400px;overflow:auto} ");
 	doTemp.setLimit("Opinion1,Opinion2,Opinion3,Opinion4,Remark",100);
 	doTemp.setEditStyle("Opinion1,Opinion2,Opinion3,Opinion4,Remark","3");
 	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
		
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//获取检查截止日期
	sSql ="select NextCheckDate from RISKSIGNAL_OPINION where SerialNo =:SerialNo";
	String sUpToDate = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(sUpToDate == null) sUpToDate = "";
	
	String sButtons[][] = {
			{(sSerialNo.equals("")?"true":"false"),"","Button","保存","保存预警检查报告的信息","saveRecord()",sResourcesPath},		
			{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
			
	/*~[Describe=返回列表页面;]~*/
	function goBack(){
		top.close();
	}
	
	/*~[Describe=执行插入操作前执行的代码;]~*/
	function beforeInsert(){
		initSerialNo();//初始化流水号字段				
		bIsInsert = false;
	}
	/*~[Describe=执行更新操作前执行的代码;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;]~*/
	function initRow(){
		if (getRowCount(0)==0){ //如果没有找到对应记录，则新增一条，并设置字段默认值
			as_add("myiframe0");//新增记录			
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"InspectType","05");  //01：首次检查；02：定期检查；03：不定期检查；04：专项检查；05：预警信号检查
			setItemValue(0,0,"UptoDate","<%=sUpToDate%>");			
			setItemValue(0,0,"InspectUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InspectUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InspectOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InspectOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");			
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InspectDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"FinishDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;			
		}		
    }
	
	/*~[Describe=初始化流水号字段;]~*/
	function initSerialNo(){
		var sTableName = "INSPECT_INFO";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "AL";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段		
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>