<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 机构信息详情
	 */
	String PG_TITLE = "机构信息详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//获得页面参数	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));	
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	
	String sApproveNeed =  CurConfig.getConfigure("ApproveNeed");
	
	//将空值转化成空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";

	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "ContractInfo300028";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//if(sOrgID.equals("")) doTemp.setReadOnly("OrgID,OrgLevel", false);
	
	//doTemp.appendHTMLStyle("OrgID,SortNo"," onkeyup=\"value=value.replace(/[^0-9]/g,&quot;&quot;) \" onbeforepaste=\"clipboardData.setData(&quot;text&quot;,clipboardData.getData(&quot;text&quot;).replace(/[^0-9]/g,&quot;&quot;))\" ");
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//定义后续事件
	//dwTemp.setEvent("AfterInsert","!SystemManage.AddOrgBelong(#OrgID,#RelativeOrgID)");
	//dwTemp.setEvent("AfterUpdate","!SystemManage.AddOrgBelong(#OrgID,#RelativeOrgID)");
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"true","All","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		     {"true","","Button","返回","返回到列表界面","doReturn()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false;
	function saveRecord(){
			/*****************月收入总额==家里每月提供生活费+其他收入*********/
		    var monthly_income_total=0;
			var monthly_income_payments=getItemValue(0,getRow(),"monthly_income_payments");
			var monthly_income_Other=getItemValue(0,getRow(),"monthly_income_Other");
			monthly_income_total=parseInt(monthly_income_payments)+parseInt(monthly_income_payments)
   			if(monthly_income_total){
	   			 if(!isNaN(monthly_income_total)){ 
					setItemValue(0,0,"monthly_income_total",monthly_income_total);
	   			 }
   			}

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
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			setItemValue(0,0,"updateby","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"createby","<%=CurUser.getUserID()%>");
	       setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	       setItemValue(0,0,"createDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}else{
			   setItemValue(0,0,"createby","<%=CurUser.getUserID()%>");
		       setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		}
		setItemValue(0,0,"Putoutno",<%=sObjectNo%>);
		
	}

	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>