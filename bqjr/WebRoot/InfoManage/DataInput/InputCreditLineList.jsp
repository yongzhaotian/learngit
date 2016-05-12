<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Author: jschen  2010.03.17
		Describe: 额度业务补登列表;
		Input Param:
			ReinforceFlag：110 需补登额度业务
			               120 已补登额度业务
	 */
	String PG_TITLE = "额度业务补登列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//定义变量
	String sSql="";
	String sClauseWhere="";
	
	//获得组件参数
	String sReinforceFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReinforceFlag"));
	if(sReinforceFlag==null) sReinforceFlag="";
	

	String sTempletNo="InputCreditLineList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	if(sReinforceFlag.equals("110")){  //待补登或新增的额度业务
		doTemp.WhereClause += " and ManageUserID ='"+CurUser.getUserID()+"'";
	}
	
	if(sReinforceFlag.equals("120")){  //补登或新增完成的额度业务
		doTemp.WhereClause += " and ManageUserID ='"+CurUser.getUserID()+"'";
	}
	doTemp.OrderClause +=" order by SerialNo";
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	//删除后续事件
	dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(ReinforceContract,#SerialNo,DeleteBusiness)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sReinforceFlag);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {		
				{"true","","Button","新增","新增","NewCreditBusiness()",sResourcesPath},
				{"true","","Button","详情","详情","CreditBusinessInfo()",sResourcesPath},
				{"true","","Button","删除","删除","DeleteBusinessInfo()",sResourcesPath},
				{"true","","Button","补登完成","补登完成","FinishCreditBusiness()",sResourcesPath},
				{"true","","Button","重新补登","重新补登","secondFinishCreditBusiness()",sResourcesPath},
			};
	
	//需补登额度业务
	if(sReinforceFlag.equals("110")){
		sButtons[4][0] = "false";
	}
	//补登完成额度业务
	if(sReinforceFlag.equals("120")){
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
	}
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	/*~[Describe=删除额度业务记录;InputParam=无;OutPutParam=无;]~*/
	function DeleteBusinessInfo(){
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		var sBusinessType=getItemValue(0,getRow(),"BusinessType");
		var sReinforceFlag = "<%=sReinforceFlag%>";

        var sReturn = RunMethod("PublicMethod","GetCreditLineCounts",sSerialNo);   
        if( parseFloat(sReturn) > 0){
            alert("该额度已被关联，不能删除！");  
            return;
        }		
						
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else if(confirm(getHtmlMessage('2'))){ //您真的想删除该信息吗？
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句			
		}
	}
	
	/*~[Describe=额度合同详情;InputParam=无;OutPutParam=无;]~*/
	function CreditBusinessInfo(){
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sReinforceFlag = "<%=sReinforceFlag%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			sCompID = "CreditTab";
			sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
			if(sReinforceFlag=="110"){
				sParamString = "ViewID=001&ObjectType=ReinforceContract&ObjectNo="+sSerialNo;
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
				reloadSelf();
			}else{
				sParamString = "ViewID=002&ObjectType=ReinforceContract&ObjectNo="+sSerialNo;
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
				reloadSelf();
			}
		}
	}

	/*~[Describe=新增额度业务;InputParam=无;OutPutParam=无;]~*/
	function NewCreditBusiness(){
		sCompID = "CreditLineInputCreationInfo";
		sCompURL = "/InfoManage/DataInput/CreditLineInputCreationInfo.jsp";		

		sReturn = popComp(sCompID,sCompURL,"","dialogWidth=450px;dialogHeight=300px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");		
		if(sReturn != '_CANCEL_' && typeof(sReturn)!="undefined" && sReturn.length!=0 && sReturn != "_NONE_"){
			//额度协议编号
			var sObjectNo = sReturn;
			sReturnValue = RunMethod("信息补登","InitialInputCLInfo",sObjectNo);
			var sReinforceFlag = "<%=sReinforceFlag%>";
			if(sReinforceFlag=="110") {
				//新增额度进入详情页面
				openObject("ReinforceContract",sObjectNo,"000");
			}
			reloadSelf();	
		}
	}

	/*~[Describe=置额度完成补登标志;InputParam=无;OutPutParam=无;]~*/
	function FinishCreditBusiness(){
		//合同流水号、客户编号、业务品种
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		var sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		
		//表示补登进入列表
		var sReinforceFlag = "<%=sReinforceFlag%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else {						
			if(typeof(sBusinessType)=="undefined" || sBusinessType.length==0){
				alert("额度类别为空，请先补登额度类别！");
				return;
			}else{	
				var sExistFlag = autoRiskScan("013","ObjectNo="+sSerialNo+"&CustomerID="+sCustomerID,10);   
				if(sExistFlag!=true){
					return;
				}else{
					RunMethod("信息补登","UpdateReinforceFlag",sSerialNo+","+sReinforceFlag+","+sBusinessType);
					sReturn = PopPageAjax("/Common/WorkFlow/AddPigeonholeActionAjax.jsp?ObjectType=ReinforceContract&ObjectNo="+sSerialNo,"","");
					if(sReturn == "true"){
						alert("补登完成，该业务已转到补登完成授信额度列表!");
					}
					reloadSelf();	
				}
			}
		}
	}

	/*~[Describe=重新补登;InputParam=无;OutPutParam=无;]~*/
	function secondFinishCreditBusiness(){
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sReinforceFlag = "<%=sReinforceFlag%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else {
			RunMethod("信息补登","UpdateReinforceFlag",sSerialNo+","+sReinforceFlag);
			sReturn = PopPageAjax("/Common/WorkFlow/AddPigeonholeActionAjax.jsp?ObjectType=ReinforceContract&Pigeonholed=Y&ObjectNo="+sSerialNo,"","");
			if(sReturn == "true"){
				alert("该笔额度业务已返回需补登授信额度列表，请重新补登!");
			}
			reloadSelf();		
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%@	include file="/IncludeEnd.jsp"%>