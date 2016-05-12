<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:    
		Tester:	
		Content: 客户列表
		Input Param:
              ObjectType:  对象类型
              ObjectNo  :  对象编号
              ModelType :  评估模型类型 010--信用等级评估   030--风险度评估  080--授信限额 018--信用村镇评定  具体由'EvaluateModelType'代码说明
              CustomerID：  客户代码        　        
		Output param:
			               
		History Log: 
			DATE	CHANGER		CONTENT
			2005.7.22 fbkang    页面整理
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "评估列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
    //定义变量
    String sContext = "";//传递参数
	String sSql = "";//--存放sql语句
	String sObjectType = "";//--对象类型
	String sObjectNo = "";//--对象编号
	String sModelType = "";//--模型类型
	String sFag = "";//--标志
	String sCustomerType = "";//--客户类型
	String sModelTypeAttributes="";//--模型类型属性
	String sCustomerID = "";//--客户代码
    String sDisplayFinalResult="";//--显示结果
    String sSMEStatus="";
    //获得组件参数，对象类型、对象编号、模型类型、客户代码
	sObjectType  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	sObjectNo    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	sModelType   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelType"));
	sCustomerID  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if (sModelType==null) 
		sModelType = "010"; //缺省模型类型为"信用等级评估"
	ASResultSet rs = null;
%>	
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	sSql = "select * from CODE_LIBRARY where CodeNo='EvaluateModelType' and ItemNo=:sModelType ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sModelType",sModelType));
	if(rs.next()){
		sModelTypeAttributes = rs.getString("RelativeCode");
	}else{
		throw new Exception("模型类型 ["+sModelType+"] 没有定义。请查看CODE_LIBRARY:EvaluateModelType");
	}
	rs.getStatement().close();
	
	sDisplayFinalResult = StringFunction.getProfileString(sModelTypeAttributes,"DisplayFinalResult");
	
	//获取中小企业客户认定情况
	sSql = "select * from CUSTOMER_INFO where CustomerID=:sCustomerID ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sCustomerID",sCustomerID));
	if(rs.next()){
		sSMEStatus = rs.getString("Status");
		sCustomerType=rs.getString("CustomerType");
	}
	rs.getStatement().close();
	
	//通过DW模型产生ASDataObject对象doTemp
		String sTempletNo = "EvaluateList";//模型编号
	       
	if (sModelType.equals("030"))//  如果是业务风险评估，减少列表的项
	{		
		String sModelTypeName="风险度评估表";
		//风险度评估只对申请做，如果当前对象为合同和通知书，显示关联的申请的风险度评估
		if(sObjectType.equals("CreditApply"))
		{	
			sTempletNo = "CreditApplyEvaluateList";
			sContext += sObjectType +","+sObjectNo;
		 }
	}else//其它阶段的评估
	{
		sContext += sObjectType +","+sObjectNo+","+sModelType;
	}

	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	if (sModelType.equals("080"))
	{
		//设置不可见项
		doTemp.setVisible("EvaluateResult,CognScore,CognResult,CognOrgName,CognUserName,CognDate",false);
		doTemp.setHTMLStyle("EvaluateScore,CognScore","style={width:160px} ");	
	}else if(sModelType.equals("070")){//增加流动资金需求量模型测算ModelType='070';
		//设置不可见项
		doTemp.setVisible("EvaluateResult,CognScore,CognResult,CognOrgName,CognUserName,CognDate",false);
		doTemp.setHTMLStyle("EvaluateScore,CognScore","style={width:160px} ");	
	}
	
	//如果为个人客户，隐藏报表口径字段的显示
	if (sModelType.equals("015") || sModelType.equals("017")) //modify by cbsu 2009-10-20 sModelType=17表示个体经营户
	{
		doTemp.setVisible("ReportScope,ReportScopeName",false);			  
	}
	doTemp.setVisible("ObjectType,ObjectNo,SerialNo,ModelNo,UserID,OrgID,CognUserID,CognOrgID,FinishDate",false);
	if(sDisplayFinalResult==null || !sDisplayFinalResult.equalsIgnoreCase("Y"))
	{
		doTemp.setVisible("EvaluateScore,EvaluateResult,CognScore,CognResult",false);
	}

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));


	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20);
	Vector vTemp = dwTemp.genHTMLDataWindow(sContext);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));		
	
%> 

<%/*END*/%>


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
			  {"true","All","Button","新增","新增评估信息","my_add()",sResourcesPath},
			  {"true","","Button","详情","查看评估详情","my_detail()",sResourcesPath},
			  {"true","All","Button","删除","删除所选中的信息","my_del()",sResourcesPath},
			  {"false","","Button","打印","打印评估详情","my_print()",sResourcesPath},
			  {"false","","Button","人工认定","调整认定原因说明","Reason()",sResourcesPath}
		     };
	if (sModelType.equals("030") || sModelType.equals("018") || sModelType.equals("080"))
	{
	    sButtons[3][0] = "false";
	}
	//sModelType为012时为中小企业信用等级评估 add by cbsu 2009-11-03
	if (sModelType.equals("010") ||sModelType.equals("018") || sModelType.equals("012")) {
		sButtons[4][0] = "false";
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script>
	//---------------------定义按钮事件---------------------//
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function my_add()
	{
		var CustomerType="<%=sCustomerType%>";
		var SMEStatus="<%=sSMEStatus%>";
		var stmp = CheckRole();
		if("true"==stmp)
		{    	
			if(CustomerType=="0120" && SMEStatus!="1"){
				alert(getBusinessMessage('960'))
			}
			else{
				sReturn = PopPage("/Common/Evaluate/AddEvaluateMessage.jsp?Action=display&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ModelType=<%=sModelType%>&EditRight=100","","dialogWidth:350px;dialogHeight:350px;resizable:yes;scrollbars:no");
	    		if(sReturn==null || sReturn=="" || sReturn=="undefined") return;
	    		sReturns = sReturn.split("@");
	    		sObjectType = sReturns[0];
	    		sObjectNo = sReturns[1];
	    		sModelType = sReturns[2];
	    		sModelNo = sReturns[3];
	    		sAccountMonth = sReturns[4];
	    		sReportScope = sReturns[5]; 
	    		sReturn=PopPage("/Common/Evaluate/ConsoleEvaluateAction.jsp?Action=add&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ModelType="+sModelType+"&ModelNo="+sModelNo+"&AccountMonth="+sAccountMonth+"&ReportScope="+sReportScope,"","dialogWidth=20;dialogHeight=20;resizable=yes;center:no;status:no;statusbar:no");
	    		if (typeof(sReturn) != "undefined" && sReturn.length>=0 && sReturn == "EXIST")
	    		{
	    			alert(getBusinessMessage('189'));//本期信用等级评估记录已存在，请选择其他月份！
	    			return;
	    		}
	    		
	    		if(typeof(sReturn) != "undefined" && sReturn.length>=0 && sReturn != "failed")
	    		{
	    			var sEditable="true";
					OpenComp("EvaluateDetail","/Common/Evaluate/EvaluateDetail.jsp","Action=display&CustomerID=<%=sCustomerID%>&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo="+sReturn+"&Editable="+sEditable,"_blank",OpenStyle);
	    		}
	    	    reloadSelf();
			}    		
	    }else
	    {
	        alert(getBusinessMessage('190'));//对不起，你没有信用等级评估的权限！
	    }
	}
	
	/*~[Describe=查看明细;InputParam=无;OutPutParam=无;]~*/
	function my_detail()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sUserID       = getItemValue(0,getRow(),"UserID");
		var sOrgID        = getItemValue(0,getRow(),"OrgID");
		var sModelType = "<%=sModelType%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			var sEditable="true";
			if(sUserID!="<%=CurUser.getUserID()%>")
				sEditable="false";
			//如果为个人信用等级评估则打开测算模型的编辑权限，而其它的只能查看，不能测算。
			//sModelType=015表示个人信用等级评估，sModelType=017表示个体经营户信用等级评估，sModelType=030表示风险度评估 
			//sModelType=019表示农户信用等级评估，sModelType=070表示流动资金需求量测算
			//详情请见代码表中EvaluateModelType的配置。modify by cbsu 2009-11-19
			if(sModelType == "015" || sModelType == "017" || sModelType == "019" || sModelType == "030" || sModelType == "070")
				sEditable="true";
			else
				sEditable="false";
			OpenComp("EvaluateDetail","/Common/Evaluate/EvaluateDetail.jsp","Action=display&CustomerID=<%=sCustomerID%>&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo="+sSerialNo+"&Editable="+sEditable,"_blank",OpenStyle);
		    reloadSelf();
		}		
	}
	
	/*~[Describe=删除;InputParam=无;OutPutParam=无;]~*/
	function my_del()
	{
		var stmp = CheckRole();
		if("true"==stmp)
		{
    		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
    		var sUserID       = getItemValue(0,getRow(),"UserID");
    		var sOrgID        = getItemValue(0,getRow(),"OrgID");
    		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
    		var sObjectType = getItemValue(0,getRow(),"ObjectType");
    		var sAccountMonth        = getItemValue(0,getRow(),"AccountMonth");
    		var sReportScope        = getItemValue(0,getRow(),"ReportScope");
    		//sModelType为系统评估模型的ItemNo值，详情请见代码表中EvaluateModelType的配置。
    		var sModelType = "<%=sModelType%>";
    		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
    		{
    			alert(getHtmlMessage('1'));//请选择一条信息！
    		}else if(sUserID=='<%=CurUser.getUserID()%>')
    		{
	          	if(confirm(getHtmlMessage('2')))
	          	{
		          	if(sModelType == "030" || sModelType == "070")
		          		sReturn=PopPage("/Common/Evaluate/ConsoleEvaluateAction.jsp?Action=delete&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo="+sSerialNo,"","dialogWidth=20;dialogHeight=20;resizable=yes;center:no;status:no;statusbar:no");
			        else
		    			sReturn = RunMethod("WorkFlowEngine","DeleteCreditCognTask",sObjectType+","+sSerialNo+",DeleteTask");
		        	//如果删除客户信用等级评估申请记录,要将报表状态置为完成。
		        	//sModelType的值 010:企业信用等级评估  012:中小企业信用等级评估 017:个体经营户信用等级评估
		          	if(sModelType == "010" || sModelType == "012" ||  sModelType == "017")
	          			RunMethod("CustomerManage","UpdateFSStatus",sObjectNo+","+'02'+","+sAccountMonth+","+sReportScope);
		    		if(typeof(sReturn) != "undefined" && sReturn.length>=0)
		    		{
		    			alert(getHtmlMessage('7'));//信息删除成功！
		    			reloadSelf();
		    		}else
		    		{
		    			alert(getHtmlMessage('8'));//对不起，删除信息失败！
		    		}		    	           
    		    } 
    		}else alert(getHtmlMessage('3'));
		}else
	    {
	       alert(getBusinessMessage('190'));//对不起，你没有信用等级评估的权限！
	    }
	}
	
	/*~[Describe=人工认定;InputParam=无;OutPutParam=无;]~*/
	function Reason()
	{
	    var stmp = CheckRole();
		if("true"==stmp)
		{
    		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
    		var sUserID = getItemValue(0,getRow(),"UserID");
    		var sOrgID = getItemValue(0,getRow(),"OrgID");
    		var sModelNo = getItemValue(0,getRow(),"ModelNo");
    		var sFinishDate	= getItemValue(0,getRow(),"FinishDate");
    		
    		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
    		{    		
    			alert(getHtmlMessage('1'));//请选择一条信息！  			
    		}else
    		{
    			OpenComp("EvaluateReason","/Common/Evaluate/Reason.jsp","FinishDate="+sFinishDate+"&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo="+sSerialNo+"&ModelNo="+sModelNo,"_blank","height=600, width=800, left=0,top=0,toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no");
    		    reloadSelf();
    		}
    	}
	    else
	    {
	        alert(getBusinessMessage('190'));//对不起，你没有信用等级评估的权限！
	    }
	}
	/*~[Describe=打印;InputParam=无;OutPutParam=无;]~*/
	function my_print()
	{

		sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		sModelNo      = getItemValue(0,getRow(),"ModelNo");
		sSerialNo     = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！  	
		}else
		{
			PopPage("/Common/Evaluate/EvaluatePrint.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo="+sSerialNo+"&rand="+randomNumber(),"_blank","");
 		}
	}
	/*~[Describe=评估校验;InputParam=无;OutPutParam=无;]~*/
	function CheckRole()
	{
	    var sCustomerID="<%=sCustomerID%>";
		var sReturn = RunMethod("CustomerManage","CheckRolesAction",sCustomerID+",<%=CurUser.getUserID()%>");
  
        if (typeof(sReturn)=="undefined" || sReturn.length==0){
        	return n;
        }
        var sReturnValue = sReturn.split("@");
        sReturnValue1 = sReturnValue[0];        //客户主办权
        sReturnValue2 = sReturnValue[1];        //信息查看权
        sReturnValue3 = sReturnValue[2];        //信息维护权
        sReturnValue4 = sReturnValue[3];        //业务申办权

        if(sReturnValue3 =="Y2")
            return "true";
        else
            return "n";
	}
</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	setPageSize(0,20);
	my_load(2,0,'myiframe0');
	
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
