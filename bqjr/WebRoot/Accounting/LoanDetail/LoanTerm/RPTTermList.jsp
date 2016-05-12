<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

  
<%
	String PG_TITLE = "不规则还款计划信息管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//定义变量
	String businessType = "";
	String projectVersion = "";
	
	//获得组件参数	
	
	//获得页面参数
	String sObjectNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
	String sTermMonth = DataConvert.toRealString(iPostChange,CurPage.getParameter("TermMonth"));
	double dBusinessSum = Double.parseDouble(DataConvert.toRealString(iPostChange,CurPage.getParameter("BusinessSum")));
	String sMaturity = DataConvert.toRealString(iPostChange,CurPage.getParameter("Maturity"));
	String sPutoutDate = DataConvert.toRealString(iPostChange,CurPage.getParameter("PutOutDate"));
	String status = DataConvert.toRealString(iPostChange,CurPage.getParameter("Status"));
	String sRPTTermID = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("TermID")));//组件ID
	String right=DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("RightType")));
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(status == null) status = "";
	
	AbstractBusinessObjectManager boManager = new DefaultBusinessObjectManager(Sqlca);
	BusinessObject businessObject = AbstractBusinessObjectManager.getBusinessObject(sObjectType, sObjectNo,Sqlca);
	
	if(businessObject==null){
		throw new Exception("未取到业务主对象ObjectType="+sObjectType+",ObjectNo="+sObjectNo+"，请检查！");
	}
	sObjectType = businessObject.getObjectType();
	
	
	//初始化业务对象参数
	String productVersion = businessObject.getString("ProductVersion");
	String productID = businessObject.getString("BusinessType");
	if("".equalsIgnoreCase(productVersion))
		throw new Exception("取到的产品版本为空，请检查！");
	if("".equalsIgnoreCase(productID)) 
		throw new Exception("取到的产品编号为空，请检查！");
	businessObject.setAttributeValue("RPTTermID", sRPTTermID);
	boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,businessObject);
	
	//加载还款方式信息
	String whereClauseSql ="";
	ASValuePool as = new ASValuePool();	
	whereClauseSql =" ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status " ;
	as = new ASValuePool();
	as.setAttribute("ObjectType", businessObject.getObjectType());
	as.setAttribute("ObjectNo", businessObject.getObjectNo());
	as.setAttribute("Status", "0");
	List<BusinessObject> rptList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment, whereClauseSql,as);
		
	if (rptList!=null&&!rptList.isEmpty()){
		for(BusinessObject rpt:rptList){
			if(!rpt.getString("RPTTERMID").startsWith("RPT20-")){
			   boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_delete,rpt);
			}
		}
	}
	boManager.updateDB();
	boManager.commit();
	
	ASValuePool term = ProductConfig.getProductTerm(productID, productVersion, sRPTTermID);
	if(term == null || term.isEmpty()) term = ProductConfig.getTerm(sRPTTermID);
	
	//显示模版编号
	String sTempletNo = "RPTTermList";
	String sTempletFilter = "1=1";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
	//是否选择输入期限
	String termInput = ProductConfig.getProductTermParameterAttribute(productID, productVersion, sRPTTermID, "TermInput","DefaultValue");//是否选择输入期限
	if("2".equals(termInput)){//输入日期
		doTemp.setVisible("SegStages", false);
		doTemp.setRequired("SegStages", false);
	}else{//输入期限
		doTemp.setVisible("SegFromDate",false);
		doTemp.setVisible("SegToDate", false);
		doTemp.setRequired("SegFromDate",false);
		doTemp.setRequired("SegToDate", false);
	}
	
	doTemp.WhereClause += " and Status in('"+status.replaceAll("@","','")+"')";
	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	
	dwTemp.Style = "1"; //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo+","+businessObject.getObjectType());
	for(int i=0;i < vTemp.size();i++)out.print((String) vTemp.get(i));
	
	
	String sButtons[][] = {
			{"true","","Button","新增","新增","newRecord()",sResourcesPath}, 
			{"true", "", "Button", "删除", "删除","deleteRecord()",sResourcesPath},
			/* {"true","","Button","保存","保存","saveRecord()",sResourcesPath}, */};
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<script language=javascript>
	/*~[Describe=新增;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		//新增不规则还款区段
		var returnValue = setObjectValue("SelectTermLibrary1","TermID,<%=sRPTTermID+"-"%>,ObjectType,Product,ObjectNo,<%=productID+"-"+productVersion%>","",0,0,"");
		if(typeof(returnValue)=="undefined" || returnValue=="" || returnValue=="_CANCEL_" || returnValue=="_CLEAR_") 
		{
			return;
		}
		var sTermID = returnValue.split("@")[0];
		RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+sTermID+",<%=businessObject.getObjectType()%>,<%=sObjectNo%>");
		setNoCheckRequired(0);
		 as_save("myiframe0","reloadSelf()");
	}
	
	
	function saveRecord(){
		//检验录入的还款计划
		var dBusinessSum="<%=dBusinessSum%>";
		var termInput="<%=termInput%>";
		var sPutoutDate="<%=sPutoutDate%>";
		var sMaturity="<%=sMaturity%>"; 
		var sSegBusinessSum=0;
		//校验输入的还款计划金额
		for(var i=0;i<getRowCount(0);i++){
			sSegBusinessSum=sSegBusinessSum+getItemValue(0,i,"SegRPTAmount");
		} 
		if (Math.abs(dBusinessSum-sSegBusinessSum)>0.01){
			alert("还款计划金额录入不正确!");
			return false;
		} 
		//对输入的还款日进行校验
		var day=0;
		var countday1=0;
		for(var i=0;i<getRowCount(0);i++){
			 day = getItemValue(0,i,"DefaultDueDay");	
				if(!(typeof(day)=="undefined" || day.length==0)&&(day>28||day<1)) countday1++;			
			}
		if(countday1>0) {
			alert("还款日只能录入1-28日之间,请重新录入!");
			return false;		
		}
		//对输入的日期或期限进行校验
		 if (termInput==2){//录入日期
			 var sSegToDate="";
			 var sSegToDate2="";
			 var sSegFromDate="";
			 if(getRowCount(0)==1){//仅输入一条记录
			    	setItemValue(0,0,"SegFromDate",sPutoutDate);
			    	sSegToDate=getItemValue(0,0,"SegToDate");
			    	if(sSegToDate<sMaturity&&!(sSegToDate==""||sSegToDate==null||sSegToDate.length==0)){//判断并设置最后一条记录的结束日期
				   	 	   alert("最后一条结束日期小于贷款到期日");
					       return false;
				    }else{
				    	setItemValue(0,0,"SegToDate","");
			        } 
			    }else{
			    	for(var i=0;i<getRowCount(0);i++)              
					{
			    		if(i==0){setItemValue(0,i,"SegFromDate",sPutoutDate);}
					    sSegToDate=getItemValue(0,i,"SegToDate");
						if(i>0){
						sSegToDate2=getItemValue(0,i-1,"SegToDate");//取上一条还款计划的结束日期
						setItemValue(0,i,"SegFromDate",sSegToDate2);
						}
						if(sSegFromDate>sSegToDate){
							alert("还款计划日期录入不正确");
						    return false;
						}
					    if(i<(getRowCount(0)-1)&&sSegToDate>sMaturity){
					        alert("第"+(i+1)+"条还款计划结束日期录入错误");
					        return false;
					    } 
					    if(i<(getRowCount(0)-1)&&(sSegToDate==""||sSegToDate==null||sSegToDate.length==0)){
					        alert("第"+(i+1)+"条还款计划未录入结束日期");
					        return false;
					    }
					}
			    	if(sSegToDate<sMaturity&&!(sSegToDate==""||sSegToDate==null||sSegToDate.length==0)){//判断并设置最后一条记录的结束日期
				   	 	   alert("最后一条结束日期小于贷款到期日");
					       return false;
				    }else{
				    	setItemValue(0,(getRowCount(0)-1),"SegToDate","");
				    }	
			    }  
		}else{//录入期限
			var sSegTermDate=sPutoutDate;
			var segStages="";
			var segTermUnit="020";
			for(var i=0;i<getRowCount(0);i++)              
			{
				segStages=getItemValue(0,i,"SegStages");
				if(typeof(segStages) == "undefined" || segStages.length == 0)
				{
					alert("第"+(i+1)+"条还款计划未录入期限！");
					return false;
				}
			    sSegTermDate = RunMethod("BusinessManage","CalcMaturity",segTermUnit+","+segStages+","+sSegTermDate);
			    if(i<getRowCount(0)-1&&sSegTermDate>=sMaturity){
			    	alert("第"+(i+1)+"条还款计划已超过贷款期限！");
					return false;
			    } 	
			}
			if (sSegTermDate<sMaturity){
			  alert("还款计划期限小于贷款期限");
			  return false;
			} 
		}
	 as_save("myiframe0","reloadSelf()");
	 return true;
	}
	/*~[Describe=删除;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord(){
		setNoCheckRequired(0);  //先设置所有必输项都不检查
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("确定删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	//初始化
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>