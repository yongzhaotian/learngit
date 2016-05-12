<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Describe: 信用等级认定列表;
		Input Param:
			EvaluateType：	01   需认定分类
							02   已认定分类
	 */
	String PG_TITLE = "信用等级认定列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//定义变量	
	String sSql = "";//--存放sql语句
	String sBtns = "";//--存放提示信息	
	String sOrgLevel = CurOrg.getOrgLevel();//机构级别（0：总行；3：分行；6：支行；9：网点）
	
	//获得组件参数，评估类型
	String sEvaluateType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("EvaluateType"));

	String sHeaders[][] =  {	{"CustomerName","客户名称"},
							{"AccountMonth","会计月份"},
							{"ModelName","评估模型"},
							{"EvaluateScore","系统评估得分"},
							{"EvaluateResult","系统评估结果"},						
							{"CognScore","人工认定得分"},
							{"CognResult","人工认定结果"},
							{"CognResult4","支行认定结果"},
							{"CognResult2","分行认定结果"},
							{"CognResult3","总行认定结果"},
							{"OrgName","评估单位"},
							{"UserName","评估客户经理"},
							{"CognOrgName","最终认定单位"},
							{"CognUserName","最终认定人"}
						};    				   		
	
	sSql = " select R.ObjectNo as ObjectNo,R.SerialNo as SerialNo,CI.CustomerID as CustomerID,CI.CustomerName as CustomerName,"+
		   " R.AccountMonth as AccountMonth,C.ModelName as ModelName,R.EvaluateScore as EvaluateScore,"+
		   " R.EvaluateResult as EvaluateResult,R.CognDate as CognDate,R.ModelNo as ModelNo,R.FinishDate2,R.FinishDate3,"+
           " CognScore,CognResult,CognResult4,CognResult2,CognResult3,getOrgName(R.OrgID) as OrgName,R.OrgID as OrgID,getUserName(R.UserID) as UserName,R.UserID as UserID,"+
           " getOrgName(R.CognOrgID) as CognOrgName,"+
           " getUserName(R.CognUserID) as CognUserName "+
           " from EVALUATE_RECORD R,EVALUATE_CATALOG C,CUSTOMER_INFO CI" + 
           " where R.ModelNo = C.ModelNo "+
           " and R.ObjectType = 'Customer' "+
           " and R.ObjectNo = CI.Customerid"+
           " and exists (select OI.OrgId from ORG_INFO OI where OI.OrgId = R.OrgID "+
           " and OI.SortNo like '"+CurOrg.getSortNo()+"%')";

	if(sEvaluateType.equals("01")){ //需认定信用等级
		if(sOrgLevel.equals("0")){ //总行风险分类认定
			sSql += " and (R.FinishDate3 = ' ' or R.FinishDate3 is null) and R.FinishDate2 <> ' ' and R.FinishDate2 is not null";
		}
		if(sOrgLevel.equals("3")){ //分行风险分类认定
			sSql += " and (R.FinishDate2 = ' ' or R.FinishDate2 is null) and R.FinishDate4 <> ' ' and R.FinishDate4 is not null";
		}
		if(sOrgLevel.equals("6")){ //支行风险分类认定
			sSql += " and (R.FinishDate4 = ' ' or R.FinishDate4 is null) ";
		}
	}else if(sEvaluateType.equals("02")){ //已认定信用等级
		if(sOrgLevel.equals("0")){ //总行风险分类认定
			sSql += " and R.FinishDate3 <> ' ' and R.FinishDate3 is not null and CognUserID3='"+CurUser.getUserID()+"'";
		}
		if(sOrgLevel.equals("3")){ //分行风险分类认定
			sSql += " and R.FinishDate2 <> ' ' and R.FinishDate2 is not null and CognUserID2='"+CurUser.getUserID()+"'";
		}
		if(sOrgLevel.equals("6")){ //支行风险分类认定
			sSql += " and R.FinishDate4 <> ' ' and R.FinishDate4 is not null and CognUserID4='"+CurUser.getUserID()+"'";
		}		
	}
	
	sSql += " and (R.FinishDate <> ' ' and R.FinishDate is not null) order by CustomerName DESC";

	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//设不可见
	doTemp.setVisible("SerialNo,ObjectNo,ModelNo,UserID,OrgID,CognUserID,CognOrgID,CustomerID,FinishDate2,FinishDate3",false);
	//为了删除
	doTemp.UpdateTable = "EVALUATE_RECORD";
	doTemp.setVisible("ObjectType,ObjectNo,SerialNo,ModelNo,UserID,OrgID,CognUserID,CognOrgID",false);
	doTemp.setVisible("CognDate,CognOrgName,CognUserName",false);
	doTemp.setAlign("ModelName,EvaluateResult,CognResult,CognResult4,CognResult2,CognResult3","2");
	//设置宽度
	doTemp.setHTMLStyle("ModelName","style={width:150px} ");
	doTemp.setHTMLStyle("AccountMonth,CognDate,EvaluateScore,EvaluateResult,UserName,CognScore,CognResult,CognResult2,CognResult3,CognResult4","  style={width:80px}  ");
	//设置EvaluateScore的检查格式(1 String 2 Number 3 Date(yyyy/mm/dd) 4 DateTime(yyyy/mm/dd hh:mm:ss))
	doTemp.setCheckFormat("BusinessSum,EvaluateScore,CognScore","2");
	//设置EvaluateScore的字段类型("String","Number")
	doTemp.setType("EvaluateScore,CognScore","Number");

	doTemp.setColumnAttribute("CustomerName,UserName,OrgName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	if(sEvaluateType.equals("01")){
		sBtns = "等级认定,客户详情,评估详情";
	}else if(sEvaluateType.equals("02")){
		sBtns = "认定详情,客户详情,评估详情";
	}

	String sButtons[][] = {
		{(sBtns.indexOf("直接认定")>=0?"true":"false"),"","Button","直接认定","直接认定","newRecord()",sResourcesPath},
		{(sBtns.indexOf("认定详情")>=0?"true":"false"),"","Button","认定详情","认定详情","viewAndEdit()",sResourcesPath},
		{(sBtns.indexOf("等级认定")>=0?"true":"false"),"","Button","等级认定","等级认定","viewAndEdit()",sResourcesPath},
		{(sBtns.indexOf("评估详情")>=0?"true":"false"),"","Button","评估详情","查看评估详情","my_detail()",sResourcesPath},
		{(sBtns.indexOf("客户详情")>=0?"true":"false"),"","Button","客户详情","客户详情","CustomerviewAndEdit()",sResourcesPath},		
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{  
		    if("<%=sEvaluateType%>"=="01"){
			    OpenPage("/Common/Evaluate/EvaluateCognInfo.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo, "_self","");
		    }else{
		       OpenPage("/Common/Evaluate/EvaluateCognInfo.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&IsReadOnly=Y", "_self",""); 
		    }        
		}
	}
   	/*~[Describe=查看及修改客户详情;InputParam=无;OutPutParam=无;]~*/
	function CustomerviewAndEdit(){
		var sCustomerID=getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		openObject("Customer",sCustomerID,"001");
	}

    function my_detail(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sUserID       = getItemValue(0,getRow(),"UserID");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			var sEditable="true";
			if(sUserID!="<%=CurUser.getUserID()%>")
				sEditable="false";
			if("<%=sEvaluateType%>"=="02")
				sEditable="false";
			OpenComp("EvaluateDetail","/Common/Evaluate/EvaluateDetail.jsp","Action=display&ObjectType=Customer&ObjectNo="+sObjectNo+"&SerialNo="+sSerialNo+"&Editable="+sEditable,"_blank",OpenStyle);
		}
		reloadSelf();
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	showFilterArea();
</script>
<%@	include file="/IncludeEnd.jsp"%>