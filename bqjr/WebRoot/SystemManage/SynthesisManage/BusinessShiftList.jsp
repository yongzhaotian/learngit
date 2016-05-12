<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: 待处理业务转授权列表界面
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "待处理业务转授权"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获得页面参数
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "BusinessShiftList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(100);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(CurOrg.getSortNo());
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	
	//out.println(doTemp.SourceSql); //常用这句话调试datawindow
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
	String sButtons[][] = {
			{"true","","Button","查看业务详情","查看业务详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","转授权","待处理业务转授权信息","transferTask()",sResourcesPath}	,
		   {"true","","PlainText","(双击左键选择/取消 是否转授权)","(双击左键选择或取消 是否转授权)","style={color:red}",sResourcesPath}			
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		//检查是否存在已选中的记录
    	sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		//获取对象类型和对象编号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
	  
		//modified by ttshao begin
		//获取ObjectNo对应的借据流水号和会计月份
		var sDuebillNo = RunMethod("Test","getDuebillNo",sObjectNo);
		var sAccountMonth = RunMethod("Test","getAccountMonth",sObjectNo);
	        
		if(sObjectType == "Classify"){
			 //获得ObjectType(五级分类对象类型，为"Classify")， SerialNo(Classify_Record表的SerialNo，即五级分类申请流水号)，sDuebillNo(借据号或合同号), 
	        //AccountMonth(会计月份),ResultType(五级分类是借据或合同，值为"BusinessDueBill"或"BusinessContract")
	        //sSerialNo = getItemValue(0,getRow(),"SerialNo");
	        //var sAccountMonth = getItemValue(0,getRow(),"2012/09");
	  
	        sClassifyType = "020";
	        sViewID = "002";//jschen@20100423 控制tab只读
	       
	        sCompID = "CreditTab";
	        sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
	        sParamString = "ComponentName=风险分类参考模型"+
					       "&OpenType=Tab"+ 
	            		   "&Action=_DISPLAY_"+
	            		   "&ClassifyType="+sClassifyType+
	            		   "&ObjectType="+"Classify"+
	            		   "&ObjectNo="+sObjectNo+ //classify_record的流水号 ，也就是fo、ft中的objectno
	            		   "&SerialNo="+sDuebillNo+ //借据流水号
	            		   "&AccountMonth="+sAccountMonth+
	            		   "&ModelNo=Classify1"+
	            		   "&ResultType=BusinessDueBill"+
	            		   "&ViewID="+sViewID;
	        popComp(sCompID,sCompURL,sParamString,"");
	      
	        reloadSelf();
		}else if(sObjectType == "SMEApply"){
		//获得申请类型、申请流水号
		//客户信息录入模态框调用	
		sReturnValue = PopComp("SMEApplyCreateInfo","/Common/WorkFlow/SMEApplyCreateInfo.jsp","ObjectNo="+sObjectNo,"");
		}
		else{
		//modified by ttshao enf
		OpenObject(sObjectType,sObjectNo,"002");	
		}
	}
	
	/*~[Describe=待处理业务转授权;InputParam=无;OutPutParam=无;]~*/	
	function transferTask()
    {    	
    	//检查是否存在已选中的记录
    	var j = 0;
		var a = getRowCount(0);
		for(var i = 0 ; i < a ; i++)
		{				
			var sStatus = getItemValue(0,i,"Status");
			if(sStatus == "√")
				j=j+1;
		}
		if(j <= 0)
		{
			alert(getBusinessMessage('918'));//请选择待处理业务！
			return;
		}
    	if (confirm(getBusinessMessage('920')))//确认转移该待处理业务吗？
    	{				
			var sSerialNo = "";			
			var sFromOrgID = "";
			var sFromOrgName = "";
			var sFromUserID = "";
			var sFromUserName = "";
			var sToUserID = "";
			var sToUserName = "";
			//获取当前机构
			var sOrgID = "<%=CurOrg.getOrgID()%>";
			var sParaString = "BelongOrg"+","+sOrgID
			sUserInfo = setObjectValue("SelectUserBelongOrg",sParaString,"",0);	
		    if (sUserInfo == "" || sUserInfo == "_CANCEL_" || sUserInfo == "_NONE_" || sUserInfo == "_CLEAR_" || typeof(sUserInfo) == "undefined") 
		    {
			    alert(getBusinessMessage('921'));//请选择转授权后的用户！
			    return;
		    }else
		    {
			    sUserInfo = sUserInfo.split('@');
			    sToUserID = sUserInfo[0];
			    sToUserName = sUserInfo[1];			    
		   
				//需判定是否至少有一个合同被选定待交接了。把有的找出来
				var b = getRowCount(0);				
				for(var i = 0 ; i < b ; i++)
				{
	
					var a = getItemValue(0,i,"Status");
					if(a == "√")
					{
						sSerialNo = getItemValue(0,i,"SerialNo");	
						sFromOrgID = getItemValue(0,i,"OrgID");
						sFromOrgName = getItemValue(0,i,"OrgName");
						sFromUserID = getItemValue(0,i,"UserID");
						sFromUserName = getItemValue(0,i,"UserName");	
						if(sFromUserID == sToUserID)
						{
							alert(getBusinessMessage('922'));//不允许待处理业务转授权在同一用户间进行，请重新选择转授权后的用户！
							return;
						}										
						//调用页面更新
						sReturn = PopPageAjax("/SystemManage/SynthesisManage/BusinessShiftActionAjax.jsp?SerialNo="+sSerialNo+"&FromOrgID="+sFromOrgID+"&FromOrgName="+sFromOrgName+"&FromUserID="+sFromUserID+"&FromUserName="+sFromUserName+"&ToUserID="+sToUserID+"&ToUserName="+sToUserName+"","","dialogWidth=21;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 
						if(sReturn == "TRUE")
							alert("任务流水号("+sSerialNo+"),"+"业务转授权成功！");
						else if(sReturn == "FALSE")
							alert("任务流水号("+sSerialNo+"),"+"业务转授权失败！");						
					}
				}				
				reloadSelf();
				
			}
		}
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	
	/*~[Describe=右击选择记录;InputParam=无;OutPutParam=无;]~*/
	function onDBClickStatus()
	{
		sStatus = getItemValue(0,getRow(),"Status") ;
		if (typeof(sStatus) == "undefined" || sStatus == "")
			setItemValue(0,getRow(),"Status","√");
		else
			setItemValue(0,getRow(),"Status","");

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
