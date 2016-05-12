<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:    hxli 2005-8-3
		Tester:
		Content: 诉讼案件列表
		Input Param:
			   CasePhase：案件状态     
		Output param:
				 
		History Log: zywei 2005/09/06 重检代码
		                  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "诉讼案件列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sContext = CurOrg.getOrgID() + "," + CurUser.getUserID();
	String sWhereClause = ""; //Where条件
	
	//获得组件参数	：案件状态	
	String sCasePhase =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemID"));
	if(sCasePhase == null) sCasePhase = "";	
%>
<%/*~END~*/%>


<%
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "LawCaseManageList";//模型编号
	
	//除终结案件之外的所有所有案件列表，如果包括终结，那么在列表中无法显示终结标志会引起误会，
	//因为是通过其终结日期来判断是否终结的，其案件阶段依然是终结前的阶段。案件阶段中并没有终结阶段的说！
	if(sCasePhase.equals("010") || sCasePhase.equals("020") || sCasePhase.equals("025") || sCasePhase.equals("030")){	//诉前案件列表
		sTempletNo = "LawCaseManageDetailList";
		sContext += "," + sCasePhase;
	}
	if(sCasePhase.equals("040")){	//终结归档案件列表
		sTempletNo = "LawCaseManageFileList";
	}			

	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);  //服务器分页
    
    //删除案件后删除关联信息
    dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(LawcaseInfo,#SerialNo,DeleteBusiness)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sContext);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
%>
<%/*~END~*/%>


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
	
		//如果为诉前案件，则列表显示如下按钮
		String sButtons[][] = {
					{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
					{"true","","Button","案件详情","查看/修改案件详情","viewAndEdit()",sResourcesPath},
					{"true","","Button","转入下阶段","转入下阶段","my_NextPhase()",sResourcesPath},
					{"true","","Button","归档","转入诉讼终结案件","my_Pigeonhole()",sResourcesPath},
					{"true","","Button","取消归档","取消转入诉讼终结案件","my_CancelPigeonhole()",sResourcesPath},
					{"true","","Button","取消","删除所选中的记录","deleteRecord()",sResourcesPath},
				};
				
		//如果为不良日常转入，那么：
		if(sCasePhase.equals("000"))			
		{
			sButtons[4][0]="false";			
		}

		//如果为诉前案件，则对应列表不显示取消归档等按钮
		if(sCasePhase.equals("010"))			
		{
			sButtons[4][0]="false";			
		}
		
		//如果为诉讼中案件，则对应列表不显示新增、删除等按钮
		if(sCasePhase.equals("020"))			
		{
			sButtons[0][0]="false";
			sButtons[4][0]="false";
			sButtons[5][0]="false";			
		}
		
		//如果为待执行案件、执行中案件，则对应列表不显示新增、删除等按钮
		if(sCasePhase.equals("025"))			
		{
			sButtons[0][0]="false";
			sButtons[4][0]="false";
			sButtons[5][0]="false";			
		}
		
		//如果为执行中案件，则对应列表不显示新增、删除等按钮
		if(sCasePhase.equals("030") )			
		{
			sButtons[0][0]="false";
			sButtons[4][0]="false";
			sButtons[5][0]="false";			
		}
		
		//如果为已终结案件，则对应列表不显示新增、删除、归档等按钮
		if(sCasePhase.equals("040"))			
		{
			sButtons[0][0]="false";
			sButtons[2][0]="false";
			sButtons[3][0]="false";			
			sButtons[5][0]="false";
		}
	
	
%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=SerialNo;]~*/
	function newRecord()
	{				
		//获得选择的案件类型
		var sLawCaseType = PopPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCaseTypeDialog.jsp","","resizable=yes;dialogWidth=21;dialogHeight=15;center:yes;status:no;statusbar:no");
		if(typeof(sLawCaseType) != "undefined" && sLawCaseType.length != 0 && sLawCaseType != '')
		{	
			//获取流水号
			var sTableName = "LAWCASE_INFO";//表名
			var sColumnName = "SerialNo";//字段名
			var sPrefix = "";//前缀
			var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);		
			var sReturn=PopPageAjax("/RecoveryManage/LawCaseManage/LawCaseDailyManage/AddLawCaseActionAjax.jsp?SerialNo="+sSerialNo+"&LawCaseType="+sLawCaseType+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
			if(typeof(sReturn)!="undefined" && sReturn=="true"){
				self.close();
				sObjectType = "LawCase";
				sObjectNo = sSerialNo;
				sViewID = "001";
				openObject(sObjectType,sObjectNo,sViewID);			
				reloadSelf();
			}
		} 		
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		if(confirm(getHtmlMessage(2))) //您真的想删除该信息吗？
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得案件流水号
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	
		var sCasePhase = "<%=sCasePhase%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			sObjectType = "LawCase";
			sObjectNo = sSerialNo;			
			if(sCasePhase=="040")
				sViewID = "002"
			else
				sViewID = "001"
			
			openObject(sObjectType,sObjectNo,sViewID);	
			reloadSelf();		
		}
	}
	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	/*~[Describe=转入下阶段;InputParam=无;OutPutParam=SerialNo;]~*/
	function my_NextPhase()
	{		
		//获得案件流水号
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			//获得选择阶段
			var sLawCasePhase = PopPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCasePhaseDialog.jsp","","resizable=yes;dialogWidth=21;dialogHeight=15;center:yes;status:no;statusbar:no");
			if(typeof(sLawCasePhase) != "undefined" && sLawCasePhase.length != 0 && sLawCasePhase != '')
			{			
				if(sLawCasePhase == '<%=sCasePhase%>')
				{
					alert(getBusinessMessage("779"));  //转入阶段与当前阶段相同！
					return;
				}else if(confirm(getBusinessMessage("777"))) //您真的想将该案件转到下阶段吗？
				{
					sReturnValue = RunMethod("PublicMethod","UpdateColValue","String@CasePhase@"+sLawCasePhase+",LAWCASE_INFO,String@SerialNo@"+sSerialNo);
					if(sReturnValue == "TRUE")
					{
						alert(getBusinessMessage("772"));//转入下阶段成功！
						reloadSelf();
					}else
					{
						alert(getBusinessMessage("773")); //转入下阶段失败！
						return;
					}						
				}
			}
        }    
	}
			
	/*~[Describe=归档;InputParam=无;OutPutParam=SerialNo;]~*/
	function my_Pigeonhole()
	{		
		//获得案件流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			if(confirm(getHtmlMessage('56'))) //您真的想将该信息归档吗？
			{				
				sPigeonholeDate = "<%=StringFunction.getToday()%>";
				sReturnValue = RunMethod("PublicMethod","UpdateColValue","String@PigeonholeDate@"+sPigeonholeDate+",LAWCASE_INFO,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE")
				{
					alert(getHtmlMessage('57'));//归档成功！
					reloadSelf();
				}else
				{
					alert(getHtmlMessage('60'));//归档失败！
					return;
				}
			}
        }    
	}
	
	/*~[Describe=取消归档;InputParam=无;OutPutParam=SerialNo;]~*/
	function my_CancelPigeonhole()
	{		
		//获得案件流水号
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			if(confirm(getHtmlMessage('58'))) //您真的想将该信息归档取消吗？
			{
				sReturnValue = RunMethod("PublicMethod","UpdateColValue","String@PigeonholeDate@None,LAWCASE_INFO,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE")
				{
					alert(getHtmlMessage('59'));//取消归档成功！
					reloadSelf();
				}else
				{
					alert(getHtmlMessage('61'));//取消归档失败！
					return;
				}				
        	}
        }    
	}
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
