<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "分录模板参数信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//定义变量
	String sSql = "";
	
	String inputparatemplete =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Inputparatemplete"));
    if(null==inputparatemplete|| "".equals(inputparatemplete)) inputparatemplete="ProductDefine";
	
	String sHeaders[][] = { 							
							{"DoNo","模板编号"},
							{"ColName","参数定义"},
							{"ColHeader","参数名称"}
						}; 
	
	sSql = " Select DoNo,ColName,ColHeader "+
		   " From dataobject_library "+
		   " Where dono='"+inputparatemplete+"' And ColType='Number' And colcheckformat='2' "+
		   " and colunit like '%元%' "+
		   " Order By colindex ";
	
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);

	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "dataobject_library";
	//设置关键字
	doTemp.setKey("DoNo",true);	 	

	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("ColHeader","style={width:180px} ");  	
	
	//设置对齐方式
	doTemp.setAlign("NormalBalance,OverDueBalance,PayInte","3");
	doTemp.setType("NormalBalance,OverDueBalance,PayInte","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("NormalBalance,OverDueBalance,PayInte","2");
	
	//	设置不可见项
	doTemp.setVisible("ContractSerialNo,BusinessType,ReturnType,ReturnTypeName,CertID,BusinessSum",false);
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
				{"true","","Button","确定","确定","confirm()",sResourcesPath},
				{"true","","Button","取消","取消","javaScript:self.close()",sResourcesPath}
			};
	%> 


	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>
	
	//---------------------定义按钮事件------------------------------------
	
	/*~[Describe=确定;InputParam=无;OutPutParam=SerialNo;]~*/
	function confirm()
	{
		var colName = getItemValue(0,getRow(),"ColName");
		if(typeof(colName) == "undefined" || colName.length == 0 ) 
			self.returnValue = "_CANCEL_";
		else
			self.returnValue = colName;	
		self.close();
	}
	
	</script>
	

<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	


<%@ include file="/IncludeEnd.jsp"%>
