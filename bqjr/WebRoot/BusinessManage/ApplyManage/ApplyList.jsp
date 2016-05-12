<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:FWang 2005.5.13
 * Tester:
 *
 * Content: 本页面用于显示业务申请记录
 * Input Param:
 * Output param:
 *
 * History Log: zpsong 2005.6.1 
 *              fwang  2005.6.24 修改合同收回部分 
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
    //获取查询类型和查询条件	
	String sCondition = DataConvert.toRealString(iPostChange,(String)request.getParameter("Condition"));
	String sCondition2 = sCondition;
	//将查询条件中的特殊字符进行转换
	if(sCondition==null||sCondition.equals(""))
	{
	 	sCondition = " 1^2";	 	
	}
	else
	{
		sCondition = " 1^1 and "+sCondition;
	}
	sCondition2 = StringFunction.replace(sCondition,"^","=");
	sCondition2 = StringFunction.replace(sCondition2,"*","%");

%>
<html>
<head>
<!--标题名称-->
<title>申请列表</title> 
</head>
<%
	//列表表头
	String sHeaders[][] = { 
							  {"CustomerID","客户代码"},
							  {"CustomerName","客户名称"},
							  {"ApplyStatusName","申请状态"},
							  {"SerialNo","申请流水号"},
							  {"OccurTypeName","发生类型"},
							  {"BusinessTypeName","业务品种"},		
							  {"BusinessSum","金额"},
							  {"BusinessCurrencyName","币种"},
							  {"TermMonth","期限月"},
							  {"TermDay","期限日"},
							  {"ApplyDate","申请日期"},
							  {"OrgName","经办机构"},
							  {"UserName","经办人"},
							  {"ContractStatus","相应合同状态"},
							  {"ApplyStatus","申请状态"},
							  {"BusinessType","业务品种"},
							  {"FinishOrg","终批机构"},
							  {"ApplyType","申请方式"},
							  {"OccurType","发生类型"}
							};   				   		
	
	//定义SQL语句
	String sSql = "select CustomerID,CustomerName, ContractStatus," +
	       "ApplyStatus,getItemName('ApplyStatus',ApplyStatus) as ApplyStatusName, " +
		   "SerialNo, "+
		   "BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+
		   "BusinessSum,getItemName('Currency',BusinessCurrency) as BusinessCurrencyName,"+
		   "getItemName('OccurType',OccurType) as OccurTypeName,TermMonth,TermDay,ApplyDate,FinishOrg,ApplyType,OccurType,"+
	       "getOrgName(OperateOrg) as OrgName, "+
	       "getUserName(OperateUser) as UserName "+
	       "from BUSINESS_APPLY " +
	       "where "+sCondition2;	
	//通过SQL参数产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sSql);
	//定义列表表头
	doTemp.setHeader(sHeaders);	    
	//对表进行更新、插入、删除操作时需要定义表对象、主键   
	doTemp.UpdateTable = "BUSINESS_APPLY";                                
	doTemp.setKey("SerialNo",true);
    doTemp.setVisible("ContractStatus,ApplyStatus,BusinessType,FinishOrg,ApplyType,OccurType",false);
    //设置数据类型
    doTemp.setType("BusinessSum","Number");
    //设置对齐格式
    doTemp.setAlign("BusinessCurrencyName","2");
    //置html格式
    doTemp.setHTMLStyle("CustomerID,SerialNo"," style={width:120px} ondblclick=\"javascript:parent.my_DBLClick()\"");
	doTemp.setHTMLStyle("CustomerName"," style={width:160px} ondblclick=\"javascript:parent.my_DBLClick()\"");
	doTemp.setHTMLStyle("ApplyDate,OccurTypeName,UserName,InputTime,ConsultClassifyName"," style={width:80px} ondblclick=\"javascript:parent.my_DBLClick()\""); 
	doTemp.setHTMLStyle("BusinessSum,ApplyStatusName,BusinessTypeName,OrgName"," style={width:100px}  ondblclick=\"javascript:parent.my_DBLClick()\"");
	doTemp.setHTMLStyle("BusinessCurrencyName,TermMonth,TermMDay,UserName"," style={width:80px}  ondblclick=\"javascript:parent.my_DBLClick()\"");
   
	//生成ASDataWindow对象，参数一用于本页面内区别其他的ASDataWindow，参数二是ASDataObject对象	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
					

%> 
<body bgcolor="#DCDCDC" leftmargin="0" topmargin="0" >
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0">
<tr height=1 valign=top bgcolor='#DCDCDC'>
    <td>
    	<table>
	    	<tr>
			<!--按照新增、详情、删除顺序排列按钮-->
	 		    <td>
	                <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","查询","选择查询条件","javascript:my_query()",sResourcesPath)%>
	    		</td>
                <td>
	                <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","新增","新增申请","javascript:my_add()",sResourcesPath)%>
	    		</td>
				<td>
	                <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","查看/修改","查看和修改申请","javascript:my_info()",sResourcesPath)%>
	    		</td>
				<td>
	                <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","删除","删除申请","javascript:my_del()",sResourcesPath)%>
	    		</td>
				<td>
	                <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","提交","提交申请","javascript:my_submit()",sResourcesPath)%>
	    		</td>
	            <td>
	                <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","收回","收回申请","javascript:my_callback()",sResourcesPath)%>
	    		</td>
				<td>
					<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","打印业务送审表","打印业务送审表","javascript:my_print()",sResourcesPath)%>
	    		</td>
				<td>
	                <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","查看总行批复","查看总行批复","javascript:my_HQ()",sResourcesPath)%>
	    		</td>
                <td>
                    <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","查看分行批复","查看分行批复","javascript:my_BR()",sResourcesPath)%>
	    		</td>
                <td>
	                <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","合同登记","合同登记","javascript:my_addContract()",sResourcesPath)%>
	    		</td>
			</tr>
		</table>
    </td>
</tr>
<tr>
    <td colpsan=3>
		<iframe name="myiframe0" width=100% height=100% frameborder=0></iframe>
    </td>
</tr>
</table>
</body>
</html>
<script type="text/javascript">
    
    //新增一笔申请
	function my_add()
	{	
		sApplyInfo = self.showModalDialog("<%=sWebRootPath%>/BusinessManage/ApplyManage/createApplyPreMessage.jsp?rand="+randomNumber(),"NewApply","dialogWidth=20;dialogHeight=17;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no;close:no");
		if(typeof(sApplyInfo) != "undefined" && sApplyInfo.length != 0)
		{			
			//获取发生类型、申请类型、申请人代码、申请人名称和客户类型
			sApplyInfo    = sApplyInfo.split("@");
			sOccurType    = sApplyInfo[0];
			sApplyType    = sApplyInfo[1];
			sCustomerID   = sApplyInfo[2];
			sCustomerName = sApplyInfo[3];	
			sCustomerType = sApplyInfo[4];	
			sBusinessType = sApplyInfo[5];
			if(typeof(sOccurType) != "undefined" && sOccurType.length != 0&&typeof(sApplyType) != "undefined" && sApplyType.length != 0)
			{
				var sTableName = "BUSINESS_APPLY";//表名
				var sColumnName = "SerialNo";//字段名
				var sPrefix = "";//前缀
		
				//获取流水号
				var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
                //alert(sSerialNo);
                if(typeof(sSerialNo) != "undefined" && sSerialNo.length != 0)
                {							
                    //向业务申请信息表(BUSINESS_APPLY)中新增一条记录
                    self.showModalDialog("<%=sWebRootPath%>/BusinessManage/ApplyManage/createApplyAction.jsp?SerialNo="+sSerialNo+"&OccurType="+sOccurType+"&ApplyType="+sApplyType+"&CustomerID="+sCustomerID+"&CustomerName="+sCustomerName+"&BusinessType="+sBusinessType+"&CustomerType="+sCustomerType+"&rand="+randomNumber(),"","dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
                    //根据申请书流水号和业务品种链接业务信息详情页面	
                   OpenWindow("/BusinessManage/ApplyManage/ApplyDetail.jsp?ObjectNo="+sSerialNo+"&CustomerID="+sCustomerID+"&BusinessType="+sBusinessType+"&ApplyType="+sApplyType+"&OccurType="+sOccurType+"&Condition=<%=sCondition%>","_top");
                }
			}
		}
	}

    //查询
    function my_query()
    {
        sReturnValue = self.showModalDialog("ApplyChoice.jsp?rand="+randomNumber(),"","dialogWidth=32;dialogHeight=32;center:yes;status:no;statusbar:no");
		if(sReturnValue != "doCancel" && typeof(sReturnValue) != "undefined")
		{	
            sReturnValue=sReturnValue.split("@");
	        sCondition=sReturnValue[0];
	        sType=sReturnValue[1];
            window.open("ApplyList.jsp?Condition="+sCondition+"&rand="+randomNumber(),"_self","");
        }   
    }

    //查看/修改详情
    function my_info()
	{
		//业务流水号
		sSerialNo = getItemValue(0,getRow(),"SerialNo"); 
		//业务品种
		sBusinessType=getItemValue(0,getRow(),"BusinessType");
		//申请方式
        sApplyType=getItemValue(0,getRow(),"ApplyType");
		//发生类型
		sOccurType=getItemValue(0,getRow(),"OccurType");

		sCustomerID = getItemValue(0,getRow(),"CustomerID"); 
        if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert("请选择一笔申请！");
			return;
		}	
	
		popComp("ApplyDetail","/BusinessManage/ApplyManage/ApplyDetail.jsp","ObjectNo="+sSerialNo+"&CustomerID="+sCustomerID+"&BusinessType="+sBusinessType+"&ApplyType="+sApplyType+"&OccurType="+sOccurType+"&Condition=<%=sCondition%>","","");
		
		//OpenWindow("/BusinessManage/ApplyManage/ApplyDetail.jsp?ObjectNo="+sSerialNo+"&CustomerID="+sCustomerID+"&BusinessType="+sBusinessType+"&ApplyType="+sApplyType+"&OccurType="+sOccurType+"&Condition=<%=sCondition%>","_top");
	}
	
    //删除申请,只有申请状态为未提交（11）的申请才能删除
	function my_del()
	{
		sSerialNo=getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined"||sSerialNo.length==0)
		{
		   alert("请选择一笔申请！");
		   return;
		}
	    //获得申请状态
		sApplyStatus=getItemValue(0,getRow(),"ApplyStatus");
		if(sApplyStatus!="11")
		{
		alert("该申请已提交,不能删除！");
		return;
		}
		if(confirm("您确定删除该申请？"))
		{
		var sReturnValue=self.showModalDialog("delApplyAction.jsp?SerialNo="+sSerialNo+"&rand="+randomNumber(),"","dialogWidth=32;dialogHeight=32;center:yes;status:no;statusbar:no");
		if(sReturnValue=="Success")
			{
			   alert("删除成功！")
			   self.location.reload();
			}
		 else
			{
			   alert("删除失败，请重新删除一次！");
			   return;
			} 
		}
	}
	
    //提交
    function my_submit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo"); 
		sStatus = getItemValue(0,getRow(),"ApplyStatus"); 
		sUpdateTable = "BUSINESS_APPLY";
		sColumns="ApplyStatus";
		sColumnsValue=21;
	    if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert("请选择一笔申请！");
			return;
		}else if(sStatus != "11" )
		{
			alert("申请状态为未提交的申请才能提交！");
		}else
		{
		    //提交前预警
            var sReturn3;
            sReturn3 = popComp("ScenarioAlarm.jsp","/PublicInfo/ScenarioAlarm.jsp","OneStepRun=yes&ScenarioNo=001&ObjectType=ApplySerialNo&ObjectNo="+sSerialNo,"dialogWidth=40;dialogHeight=40;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no","");
            if (typeof(sReturn3)== 'undefined' || sReturn3.length == 0) 
            {
                alert("好像是个奇怪的错误！");
                return;
            }else if (sReturn3 >= 0) //成功 
            {
                alert("成功啦，庆祝一下！"+sReturn3);    
                if( sReturn3 <= 50 )
                	return;
            }else  //失败
            {
                alert("呜呜，又失败了 :..( ");
                return;
            }
            

            //提交，更新下次分类日期、以及分类结果等信息
			sReturn = self.showModalDialog("<%=sWebRootPath%>/PublicInfo/updateTable.jsp?TableName="+sUpdateTable+"&Key=SerialNo&KeyValue="+sSerialNo+"&Column="+sColumns+"&ColumnValue="+sColumnsValue+"&rand="+randomNumber(),"","dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
			if (typeof(sReturn)=="undefined" || sReturn != 'Y') 
			{
				alert("提交失败，请重新操作");
				return 0;
			}else
			{
				alert("提交成功!");
				self.location.reload();
			}
		}
	}

    //收回
	function my_callback()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo"); 
		//对于申请状态为"已提交分行未登记"21且申请对应的合同状态为"未签合同"10的申请允许收回
		sApplyStatus=getItemValue(0,getRow(),"ApplyStatus");
		sContractStatus=getItemValue(0,getRow(),"ContractStatus");
        if(sApplyStatus=="21"&&sContractStatus=="10")
		{
			sUpdateTable = "BUSINESS_APPLY";
			sColumns="ApplyStatus";
			sColumnsValue=11;
			
			//收回
			sReturn = self.showModalDialog("<%=sWebRootPath%>/PublicInfo/updateTable.jsp?TableName="+sUpdateTable+"&Key=SerialNo&KeyValue="+sSerialNo+"&Column="+sColumns+"&ColumnValue="+sColumnsValue+"&rand="+randomNumber(),"","dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
			if (typeof(sReturn)=="undefined" || sReturn != 'Y') 
				{
					alert("提交失败，请重新操作");
					return 0;
				}else
				{
					alert("收回成功!");
					self.location.reload();
				}
		}
		//如果分行已经登记送审表，则提示"该申请已被分行登记，需要分行删除登记信息后才能收回"；如果申请已经登记了合同，则提示"该申请已经登记合同信息，需要先删除合同后才能收回"
		else if(sApplyStatus!="21"&&sApplyStatus!="11")//已登记分行送审表
		{
		  alert("该申请已被分行登记，需要分行删除登记信息后才能收回!");
		  return;
		}
		else if(sContractStatus!="10")//已登记合同
		{
		  alert("该申请已经登记合同信息，需要先删除合同后才能收回!");
		  return;
		}
	}
	
    //打印
	function my_print()
	{
		
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sApplyStatus = getItemValue(0,getRow(),"ApplyStatus");
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
	
		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert("请选择一笔业务！");
			return;
		}else if ( sApplyStatus=='11')
		{
			alert("该笔业务尚未提交，不能打印！");
			return;
		}else
		{
		 self.open("<%=sWebRootPath%>/BusinessManage/ApplyManage/BusinessApplySheet.jsp?ObjectNo="+sSerialNo+"&CustomerID="+sCustomerID+"&rand=" + randomNumber(),"",OpenStyle);
		}

	}
    
    //登记合同
	function my_addContract()
	{
	    sSerialNo=getItemValue(0,getRow(),"SerialNo");
		sApplyStatus = getItemValue(0,getRow(),"ApplyStatus");
        if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert("请选择一笔业务！");
			return;
		}else if ( sApplyStatus=='11')
		{
			alert("该笔业务尚未提交，不能登记合同！");
			return;
		}
		else
		{
			sReturnValue = self.showModalDialog("<%=sWebRootPath%>/BusinessManage/BusinessInfo/AddContractAction.jsp?ObjectNo="+ sSerialNo +"&rand="+randomNumber(),"","dialogWidth=20;dialogHeight=20;center:no;status:no;statusbar:no");
            if (sReturnValue != "false" && typeof(sReturnValue) != "undefined")
                window_open("<%=sWebRootPath%>/BusinessManage/BusinessInfo/BusinessDetail.jsp?ObjectType=BusinessContract&ObjectNo="+ sReturnValue +"&BackPage=ContractMain&rand="+randomNumber(),"_top","");
        } 
	}
    
    //双击查看详情
    function my_DBLClick()
    {
        my_info();
    }

</script>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>