<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
	Author:  bwang 
	Tester:
	Content: 信用等级认定签署意见
	Input Param:
		
	Output param:
	History Log: 
	
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "信用等级认定签署意见";
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%	
	String sSql="";
	ASResultSet rs=null;
	String sCognResult="",sCustomerName="",sModelName="";
	String sAccountMonth="",sEvaluateDate="",sSystemScore="",sSystemResult="",sCustomerID="";
	//获取组件参数：任务流水号
	String sSerialNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("TaskNo"));
	String sERSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ERSerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));

	//将空值转化为空字符串
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sERSerialNo == null) sERSerialNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
	<%
	//取得当前阶段的评定结果
	sSql = " select ER.ObjectNo,getCustomerName(ER.ObjectNo) as CustomerName,"+
	   " CognResult,ER.AccountMonth ,"+
	   " EC.ModelName as ModelName,ER.EvaluateDate,ER.EvaluateScore,ER.EvaluateResult"+
	   " from EVALUATE_RECORD ER,EVALUATE_CATALOG EC" + 
       " where ER.ObjectType = :ObjectType"+
       " and ER.SerialNo = :SerialNo and ER.ModelNo=EC.ModelNo";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType",sObjectType).setParameter("SerialNo",sERSerialNo));
	if(rs.next()){
		sCognResult = rs.getString("CognResult");
		sModelName=rs.getString("ModelName");
		sAccountMonth=rs.getString("AccountMonth");
	 	sEvaluateDate=rs.getString("EvaluateDate");
 		sSystemScore=rs.getString("EvaluateScore");
	 	sSystemResult=rs.getString("EvaluateResult");
	 	sCustomerID=rs.getString("ObjectNo");
	 	sCustomerName=rs.getString("CustomerName");
	 	
	 	if (sModelName==null)sModelName="";
	 	if (sAccountMonth==null)sAccountMonth="";
	 	if (sEvaluateDate==null)sEvaluateDate="";
	 	if (sSystemScore==null)sSystemScore="";
	 	if (sSystemResult==null)sSystemResult="";
	 	if (sCustomerID==null)sCustomerID="";
	 	if (sCustomerName==null)sCustomerName="";
		if(sCognResult ==null) sCognResult=""; 
	 
	}
	
	rs.getStatement().close();
	String sHeaders[][] = { 
							{"AccountMonth","会计月份"},
	                        {"ModelName","评估模型"},
	                        {"SystemScore","系统评估得分"},
	                        {"SystemResult","系统评估结果"},
	                        {"CustomerName","客户名称"},
	                        {"CognScore","人工评定得分"},
							{"CognResult","人工评定结果"},
							{"PhaseOpinion","评定原因说明"},
							{"InputTime","人工评定日期"},
							{"InputOrgName","评估单位"},
							{"InputUserName","评估人"}
			              };                 
		
	//定义SQL语句
	 sSql = 	" select SerialNo,'' as AccountMonth, PhaseChoice as ModelName,"+//会计月份,评估模型
	 			" PhaseOpinion3 as SystemScore,PhaseOpinion1 as SystemResult,"+//系统评估得分，系统评估结果
	 			" BailSum as CognScore,PhaseOpinion2 as CognResult,"+//人工评分，人工评定结果
	 			" OpinionNo,PhaseOpinion, CustomerId,CustomerName,"+//评定原因说明，客户名称
				" InputOrg,getOrgName(InputOrg) as InputOrgName,ObjectType,ObjectNo, "+
				" InputUser,getUserName(InputUser) as InputUserName, "+
				" InputTime,UpdateUser,UpdateTime "+
				" from FLOW_OPINION " +
				" where SerialNo='"+sSerialNo+"' ";
	//通过SQL参数产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sSql);
	//定义列表表头
	doTemp.setHeader(sHeaders); 
	//对表进行更新、插入、删除操作时需要定义表对象、主键   
	doTemp.UpdateTable = "FLOW_OPINION";
	doTemp.setKey("SerialNo,OpinionNo",true);		
	//设置字段是否可见  
	doTemp.setVisible("AccountMonth,SerialNo,OpinionNo,InputOrg,InputUser,UpdateUser,UpdateTime,ObjectType,ObjectNo,CustomerId",false);		
	//设置不可更新字段
	doTemp.setUpdateable("InputOrgName,InputUserName,AccountMonth",false);
	//设置必输项
	doTemp.setRequired("CognScore,PhaseOpinion",true);
	doTemp.setAlign("SystemScore","3");
	doTemp.setType("CognScore","Number");
	doTemp.setCheckFormat("CognScore","2");
	//人工认定分数
	doTemp.setHTMLStyle("CognScore"," onChange=\"javascript:parent.setResult()\" ");
	doTemp.setHTMLStyle("CognScore"," onkeyup=\"javascript:parent.setResult()\" ");
	//doTemp.appendHTMLStyle("CognScore"," myvalid=\"parseFloat(myobj.value,10)>0.01 && parseFloat(myobj.value,10)<=100 \" mymsg=\"人工评定得分的范围为(0,100]\" ");
	
	//设置下拉框
	doTemp.setDDDWSql("SystemResult,CognResult","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CreditLevel' order by SortNo ");
	//设置只读属性
	doTemp.setReadOnly("CustomerName,InputOrgName,InputUserName,InputTime,AccountMonth,ModelName,CognResult,SystemScore,SystemResult",true);
	//编辑形式为备注栏
	doTemp.setEditStyle("PhaseOpinion","3");
	//置html格式
	doTemp.setHTMLStyle("ModelName"," style={width:50%}");
	doTemp.setHTMLStyle("PhaseOpinion"," style={height:100px;width:50%;overflow:auto;font-size:9pt;} ");
	//限制评定原因的输入字数
	doTemp.setLimit("PhaseOpinion",400);
	
	//生成ASDataWindow对象		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);	
	dwTemp.Style="2";//freeform形式
	
	//将人工评估分数和结果更新到EVALUATE_RECORD表中
	dwTemp.setEvent("AfterInsert","!WorkFlowEngine.UpdateEvaluateManResult(#ObjectNo,#SerialNo)");
    dwTemp.setEvent("AfterUpdate","!WorkFlowEngine.UpdateEvaluateManResult(#ObjectNo,#SerialNo)");
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
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
			{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
			{"true","","Button","删除","删除意见","deleteRecord()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	/*~[Describe=保存签署的意见;InputParam=无;OutPutParam=无;]~*/
	function saveRecord()
	{
		sObjectType = "<%=sObjectType%>";
		sOpinionNo = getItemValue(0,getRow(),"OpinionNo");		
		if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0)
		{
			initOpinionNo();
		}
		//不允许签署的意见为空白字符
		if(/^\s*$/.exec(getItemValue(0,0,"PhaseOpinion"))){
			alert("请签署评定原因说明！");
			setItemValue(0,0,"PhaseOpinion","");
			return;
		}
		//不允许人工评分为0
		if( getItemValue(0,0,"CognScore") == 0.0 || getItemValue(0,0,"CognScore") > 100.0 ){
			alert("请正确填写人工评分！人工评定得分的范围为(0,100]");
			return;
		}
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		as_save("myiframe0"); 
	}
	
	/*~[Describe=删除意见;InputParam=无;OutPutParam=无;]~*/
    function deleteRecord()
    {
	    sSerialNo=getItemValue(0,getRow(),"SerialNo");
	    sOpinionNo = getItemValue(0,getRow(),"OpinionNo");
	    if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0)
	 	{
	   		alert("您还没有签署意见，不能做删除意见操作！");
	 	}
	 	else if(confirm("你确实要删除意见吗？"))
	 	{
	   		sReturn= RunMethod("BusinessManage","DeleteSignOpinion",sSerialNo+","+sOpinionNo);
	   		if (sReturn==1)
	   		{
	    		alert("意见删除成功!");
	  		}
	   		else
	   		{
	    		alert("意见删除失败！");
	   		}
		}
		reloadSelf();
	} 
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initOpinionNo() 
	{
		/** --update Object_Maxsn取号优化 tangyb 20150817 start-- 
		var sTableName = "FLOW_OPINION";//表名
		var sColumnName = "OpinionNo";//字段名
		var sPrefix = "";//无前缀
								
		//获取流水号
		var sOpinionNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sOpinionNo);*/
		//获取流水号
		var sOpinionNo = '<%=DBKeyUtils.getSerialNo("FO")%>';
		//将流水号置入对应字段
		setItemValue(0,getRow(),"OpinionNo",sOpinionNo);
		/** --end --*/
	}
	
	/*~[Describe=插入一条新记录;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		//如果没有找到对应记录，则新增一条，并可以设置字段默认值
		if (getRowCount(0)==0) 
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,getRow(),"SerialNo","<%=sSerialNo%>");
			setItemValue(0,getRow(),"ObjectType","<%=sObjectType%>");
			setItemValue(0,getRow(),"ObjectNo","<%=sERSerialNo%>");
			setItemValue(0,getRow(),"InputOrg","<%=CurOrg.getOrgID()%>");
			setItemValue(0,getRow(),"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,getRow(),"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,getRow(),"InputTime","<%=StringFunction.getToday()%>");	
			setItemValue(0,getRow(),"AccountMonth","<%=sAccountMonth%>");
			setItemValue(0,getRow(),"ModelName","<%=sModelName%>");
			setItemValue(0,getRow(),"EvaluateDate","<%=sEvaluateDate%>");
			setItemValue(0,getRow(),"SystemScore","<%=DataConvert.toMoney(sSystemScore)%>");
			setItemValue(0,getRow(),"SystemResult","<%=sSystemResult%>");	
			setItemValue(0,getRow(),"CustomerName","<%=sCustomerName%>");	
			setItemValue(0,getRow(),"CognResult","<%=sCognResult%>");
		}      
	}
	
		/*~[Describe=根据分值换算评级结果;InputParam=无;OutPutParam=无;]~*/
	function setResult(){		
		//评估分值结果换算
		//需要根据具体情况进行调整
		var CognScore = getItemValue(0,getRow(),"CognScore");
	    var sObjectType = "<%=sObjectType%>";
	    var sObjectNo = "<%=sObjectNo%>";
	    var sERSerialNo = "<%=sERSerialNo%>";

	    //由于有多种信用等级评估模板，而每种模板的评级方法不尽相同，因此必须根据不同的模板来进行评估分值的结果换算工作。
	    //add by cbsu 2009-11-18
	    var sParaString = sObjectType + "," + sObjectNo + "," + sERSerialNo + "," + CognScore;
		var result = RunMethod("信用等级评估","GetEvaluateResult",sParaString);
	    if(typeof(result)=="undefined" || result.length==0) {
	        result = "0";
		} else
		setItemValue(0,getRow(),"CognResult",result);
	}
	</script>
<%/*~END~*/%>


<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%@ include file="/IncludeEnd.jsp"%>