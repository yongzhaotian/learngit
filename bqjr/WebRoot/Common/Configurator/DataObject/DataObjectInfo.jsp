<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 数据对象目录详情
		Input Param:
                    DoNo：      数据对象编号
	 */
	String PG_TITLE = "数据对象目录详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//获得组件参数	
	String sDoNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DoNo"));
	if(sDoNo==null) sDoNo="";
	
	//通过显示模版产生ASDataObject对象doTemp
 	String sTempletNo = "DataObjectInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	if (sDoNo.equals("") || sDoNo.equals("null")) {
 	  	doTemp.setRequired("DONO",true);
		doTemp.setReadOnly("DONO",false);
	}else{
		doTemp.setRequired("DONO",false);
		doTemp.setReadOnly("DONO",true);
	}
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//定义后续事件
	dwTemp.setEvent("AfterUpdate","!Configurator.UpdateDOUpdateTime("+StringFunction.getTodayNow()+","+CurUser.getUserID()+","+sDoNo+")");

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sDoNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","保存","保存修改","saveRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function saveRecord(){
	    as_save("myiframe0","");
	}
    
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			setItemValue(0,0,"DOCLASS","10");
			setItemValue(0,0,"ISINUSE","1");
            
			bIsInsert = true;
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>