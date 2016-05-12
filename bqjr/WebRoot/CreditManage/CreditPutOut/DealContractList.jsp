<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: cchang 2004-12-06
		Tester:
		Describe: 客户在其他金融机构业务活动;
		Input Param:
				DealType：
				    03待完成放贷的合同
					04已完成放贷的合同
		Output Param:
			
		HistoryLog:
			zywei 2007/10/10 修改取消合同的提示语
			jgao 2009-10-26 增加集团授信额度登记合同后生成集团成员额度的方法
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "合同列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql1="";
    String sWhereCond = "";
	//获得组件参数
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%		 			
	//where语句统一修改处，涉及业务不配在模板中				
	sWhereCond	= " where ManageUserID = '"+CurUser.getUserID()+"' "+						
 			                   " and (DeleteFlag = ''  or  DeleteFlag is null) ";	 			
	
	if(sDealType.equals("03")){
		//sSql1 =" and BusinessType not like '30%' and (PigeonholeDate ='' or PigeonholeDate is null) ";
	    sSql1 =" and ReinforceFlag = '000' and BusinessType not like '30%' and (PigeonholeDate =' ' or PigeonholeDate is null) ";
	}
	else if(sDealType.equals("04")){
		//sSql1 =" and BusinessType not like '30%' and (PigeonholeDate !='' and PigeonholeDate is not null) ";
	    //sSql1 =" and (ReinforceFlag = '000' and BusinessType not like '30%' and (PigeonholeDate !='' and PigeonholeDate is not null)) or ReinforceFlag = '020' ";
	    sSql1 =" and BusinessType not like '30%' and (PigeonholeDate !=' ' and PigeonholeDate is not null) ";
	}
	else if(sDealType.equals("05")){ //待完成登记的授信额度
		//sSql1 =" and BusinessType like '30%' and (PigeonholeDate ='' or PigeonholeDate is null) ";
	    sSql1 =" and ReinforceFlag = '000' and BusinessType like '30%' and (PigeonholeDate =' ' or PigeonholeDate is null) ";
	}
	else if(sDealType.equals("06")){ //已完成登记的授信额度
	    //增加过滤条件，滤掉集团成员授信额度                                                                                                
	    //sSql1 =" and BusinessType like '30%' and (PigeonholeDate !=' ' and PigeonholeDate is not null) and (GroupLineID is null or GroupLineID='')";   
	    //sSql1 =" and ((ReinforceFlag='000' and BusinessType like '30%' and (PigeonholeDate !='' or PigeonholeDate is not null)) or  ReinforceFlag='120') and (GroupLineID is null or GroupLineID='')  ";
	    sSql1 =" and BusinessType like '30%' and FreezeFlag in ('1','2','3') and (PigeonholeDate !=' ' and PigeonholeDate is not null) and (GroupLineID is null or GroupLineID=' ')  ";
	}
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "DealContractList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);	
		
	doTemp.WhereClause = doTemp.WhereClause + sWhereCond + sSql1;

	if (sDealType.equals("06") || sDealType.equals("05")) {
		doTemp.setVisible("Balance",false);
	}
	
	doTemp.setKeyFilter("SerialNo");
	//增加过滤器
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20); 	//服务器分页

	dwTemp.setEvent("AfterDelete","!BusinessManage.DeleteBusiness(BusinessContract,#SerialNo,DeleteBusiness)+!BusinessManage.UpdateBusiness(BusinessContract,#RelativeserialNo,UpdateBusiness)"); 
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
	String sButtons[][] = {
		{"true","","Button","合同详情","合同详情","viewTab()",sResourcesPath},
		{"false","","Button","额度详情","额度详情","viewTab()",sResourcesPath},
		{"true","All","Button","取消合同","取消合同","cancelContract()",sResourcesPath},
		{"true","","Button","完成放贷","完成放贷","archive()",sResourcesPath},
		{"false","","Button","登记完成","登记完成","archive()",sResourcesPath},
		{"true","","Button","加入重点链接","加入重点链接","addUserDefine()",sResourcesPath}
	};

	if(sDealType.equals("04")){
		sButtons[2][0] ="false";
		sButtons[3][0] ="false";
	}
	if(sDealType.equals("05")){
		sButtons[3][0] ="false";//关闭“完成放贷”按钮
		sButtons[4][0] ="true";//打开“登记完成”按钮
		sButtons[1][0] ="true";//打开“额度详情”按钮
		sButtons[0][0] ="false";//打开“合同详情”按钮
	}
	if(sDealType.equals("06")){
		sButtons[2][0] ="false";//关闭“取消合同”按钮
		sButtons[3][0] ="false";//关闭“完成放贷”按钮
		sButtons[1][0] ="true";//打开“额度详情”按钮
		sButtons[0][0] ="false";//打开“合同详情”按钮
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab(){
		var sObjectType = "BusinessContract";
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//获取在哪个树图项下的参数
		sDealType = "<%=sDealType%>"; 
		sViewID = "001";//默认为001
		//当传入类型为已登记完成的授信额度时，不允许修改其详情内容，设为只读，add by jgao1 2009-11-4
		if(sDealType == "06"){
			sViewID="003";
		}		
		var sCompID = "CreditTab";
		var sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		var sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ViewID="+sViewID;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}

	/*~[Describe=加入重点合同连接;InputParam=无;OutPutParam=无;]~*/
	function addUserDefine(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getBusinessMessage('420'))){ //要把这个合同信息加入重点合同链接中吗？
			var sRvalue=PopPageAjax("/Common/ToolsB/AddUserDefineActionAjax.jsp?ObjectType=BusinessContract&ObjectNo="+sSerialNo,"","");
			alert(getBusinessMessage(sRvalue));
		}
	}

	/*~[Describe=完成放贷;InputParam=无;OutPutParam=无;]~*/
	function archive(){
		var sObjectType = "BusinessContract";
		var sBusinessType=getItemValue(0,getRow(),"BusinessType");
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//如果为授信额度业务
		if(sBusinessType.length>2 && sBusinessType.substring(0,1)=="3"){
			ssReturn = autoRiskScan("015","&SerialNo="+sObjectNo);
			if(ssReturn != true){
				return;
			}
			//你确认登记完该笔授信额度吗？
			if(confirm("你确认登记完该笔授信额度吗?")){
				//如果是集团授信额度，在登记完成时需生成集团成员的合同，因此只有登记完成的授信额度才可以引用
				if(sBusinessType.length>=4 && sBusinessType.substring(0,4)=="3020"){
					sTrue = RunMethod("CreditLine","InitGroupContract",sObjectNo);
					if(sTrue != "true"){
						alert("生成集团授信额度失败！");
						return;
					}
				}
				sReturn = PopPageAjax("/Common/WorkFlow/AddPigeonholeActionAjax.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"","");
				if(typeof(sReturn)!="undefined" && sReturn.length!=0 && sReturn!="failed"){					
					alert("该笔授信额度已经置为完成登记！");//该笔授信额度已经置为完成登记！
					reloadSelf();
				}
			}
		}else{
			if(confirm(getBusinessMessage('421'))) //您真的想将该笔合同置为完成放贷吗？
			{
				sReturn = PopPageAjax("/Common/WorkFlow/AddPigeonholeActionAjax.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"","");
				if(typeof(sReturn)!="undefined" && sReturn.length!=0 && sReturn!="failed"){
					alert(getBusinessMessage('422'));//该笔合同已经置为完成放贷！
					reloadSelf();				
				}
			}
		}
	}
	
	/*~[Describe=取消合同;InputParam=无;OutPutParam=无;]~*/
	function cancelContract(){
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getHtmlMessage('70'))){ //您真的想取消该信息吗？
		    sReturn = PopPageAjax("/CreditManage/CreditPutOut/CheckContractDelActionAjax.jsp?ObjectNo="+sObjectNo,"","");
	        if (typeof(sReturn)=="undefined" || sReturn.length==0){
	            as_del('myiframe0');
	            as_save('myiframe0');  //如果单个删除，则要调用此语句
	        }else if(sReturn == 'Reinforce'){
	            alert(getBusinessMessage('425'));//该合同为补登合同，不能删除！
	            return;
	        }else if(sReturn == 'Finish'){
	            alert(getBusinessMessage('426'));//该合同已经被终结了，不能删除！
	            return;
	        }else if(sReturn == 'Pigeonhole'){
	            alert(getBusinessMessage('427'));//该合同已经完成放贷了，不能删除！
	            return;
	        }else if(sReturn == 'PutOut'){
	            alert(getBusinessMessage('428'));//该合同已经出帐了，不能删除！
	            return;
	        }else if(sReturn == 'Other'){
	            alert(getBusinessMessage('429'));//该合同管户人为其它人员，不能删除！
	            return;
	        }else if(sReturn == 'Use'){
	            alert(getBusinessMessage('430'));//该授信额度已被占用，不能删除！
	            return;
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


<%@	include file="/IncludeEnd.jsp"%>