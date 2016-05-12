<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 机构信息详情
	 */
	String PG_TITLE = "机构信息详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//获得页面参数	
	String sOrgID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CurOrgID"));
	if(sOrgID == null) sOrgID = "";

	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "OrgInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	if(sOrgID.equals("")) doTemp.setReadOnly("OrgID,OrgLevel", false);
	
	doTemp.appendHTMLStyle("OrgID,SortNo"," onkeyup=\"value=value.replace(/[^0-9]/g,&quot;&quot;) \" onbeforepaste=\"clipboardData.setData(&quot;text&quot;,clipboardData.getData(&quot;text&quot;).replace(/[^0-9]/g,&quot;&quot;))\" ");
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//定义后续事件
	//dwTemp.setEvent("AfterInsert","!SystemManage.AddOrgBelong(#OrgID,#RelativeOrgID)");
	//dwTemp.setEvent("AfterUpdate","!SystemManage.AddOrgBelong(#OrgID,#RelativeOrgID)");
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sOrgID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{(CurUser.hasRole("099")?"true":"false"),"","Button","保存","保存修改","saveRecord()",sResourcesPath},
		{"true","","Button","返回","返回到列表界面","doReturn()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false;
	function saveRecord(){
		if(bIsInsert && checkPrimaryKey("ORG_INFO","OrgID")){
			alert("该机构号已存在，请检查输入！");
			return;
		}
		
	    var sOrgLevel = getItemValue(0,getRow(),"OrgLevel");
	    if (typeof(sOrgLevel) == 'undefined' || sOrgLevel.length == 0){
        	alert(getBusinessMessage("901"));//请选择级别！
        	return;
        }else{
        	if(sOrgLevel != '0'){
        		var sBelongOrgName = getItemValue(0,getRow(),"BelongOrgName");
			    if (typeof(sBelongOrgName) == 'undefined' || sBelongOrgName.length == 0){
		        	alert("请选择上级机构！");
		        	return;
		        }
        	}
        }
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
       setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
       as_save("myiframe0","");
	}
	
	function checkOrgSortNo(){
		var sSortNo=getItemValue(0,getRow(),"SortNo");
		if(!(typeof(sSortNo) == "undefined" || sSortNo.length==0)){
			var Return=RunMethod("BusinessManage","checkOrgUnique",sSortNo);
			if(Return!=0){
				alert("排序号已存在，请重新输入！");
				setItemValue(0,0,"SortNo","");
			}
			
		}
		
	}
    
	function doReturn(){
		if(parent.reloadView){
			parent.reloadView();
		}else{
			OpenPage("/AppConfig/OrgUserManage/OrgList.jsp","_self","");
		}
	}

	<%/*~[Describe=弹出机构选择窗口，并置将返回的值设置到指定的域;]~*/%>
	function getOrgName(){
		var sOrgID = getItemValue(0,getRow(),"OrgID");
		var sOrgLevel = getItemValue(0,getRow(),"OrgLevel");
		if (typeof(sOrgID) == 'undefined' || sOrgID.length == 0){
        	alert(getBusinessMessage("900"));//请输入机构编号！
        	return;
        }
		if (typeof(sOrgLevel) == 'undefined' || sOrgLevel.length == 0){
        	alert(getBusinessMessage("901"));//请选择级别！
        	return;
        }
		sParaString = "OrgID"+","+sOrgID+","+"OrgLevel"+","+sOrgLevel;
		
		if(<%=sOrgID.startsWith("10")%>){	
			setObjectValue("SelectOrgFunction","","@BelongOrgID@0@BelongOrgName@1",0,0,"");//针对总行职能部门
	    }else{
	    	setObjectValue("SelectOrg",sParaString,"@BelongOrgID@0@BelongOrgName@1",0,0,"");//针对一般机构
		}
	}
	
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getNow()%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getNow()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>