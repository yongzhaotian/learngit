<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: 合同转移列表界面
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "合同转移"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%//获得页面参数
//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
//if(sInputUser==null) sInputUser="";

//通过DW模型产生ASDataObject对象doTemp
String sTempletNo = "ContractShiftList";//模型编号
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
for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));%>
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
		{"true","","Button","转移","转移合同信息","transferContract()",sResourcesPath}	,
		{"true","","PlainText","(双击左键选择/取消 是否转移)","(双击左键选择/取消 是否转移)","style={color:red}",sResourcesPath}		
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=转移合同;InputParam=无;OutPutParam=无;]~*/	
	function transferContract()
    {    	
    	if(!selectRecord()) return;
    	if (confirm(getBusinessMessage("936")))//确认转移该合同吗？
    	{				
			var sSerialNo = "";			
			var sFromOrgID = "";
			var sFromOrgName = "";
			var sFromUserID = "";
			var sFromUserName = "";
			var sToUserID = "";
			var sToUserName = "";
			//获取当前机构
			sSortNo = "<%=CurOrg.getSortNo()%>";
			sParaStr = "SortNo,"+sSortNo;
			sUserInfo = setObjectValue("SelectUserInOrg",sParaStr,"",0,0);	
		    if(sUserInfo == "" || sUserInfo == "_CANCEL_" || sUserInfo == "_NONE_" || sUserInfo == "_CLEAR_" || typeof(sUserInfo) == "undefined") 
		    {
			    alert(getBusinessMessage("937"));//请选择转移后的客户经理！
			    return;
		    }else
		    {
			    sUserInfo = sUserInfo.split('@');
			    sToUserID = sUserInfo[0];
			    sToUserName = sUserInfo[1];			    
		   
				//获取更新信息类型,对于同时选择多条记录交接的，此处选择只出现一次	
				sChangeObject = PopPage("/SystemManage/SynthesisManage/ContractShiftDialog.jsp","","dialogWidth=24;dialogHeight=16;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 													
				if(sChangeObject != "_CANCEL_" && typeof(sChangeObject) != "undefined")
				{
					//需判定是否至少有一个合同被选定待交接了。把有的找出来
					var b = getRowCount(0);				
					for(var i = 0 ; i < b ; i++)
					{
						var a = getItemValue(0,i,"BCFlag");
						if(a == "√")
						{
							sSerialNo = getItemValue(0,i,"SerialNo");	
							sFromOrgID = getItemValue(0,i,"ManageOrgID");
							sFromOrgName = getItemValue(0,i,"ManageOrgName");
							sFromUserID = getItemValue(0,i,"ManageUserID");
							sFromUserName = getItemValue(0,i,"ManageUserName");	
							if(sFromUserID == sToUserID)
							{
								alert(getBusinessMessage("938"));//不允许合同转移在同一客户经理间进行，请重新选择转移后的客户经理！
								return;
							}	
						
							//调用页面更新
							sReturn = PopPageAjax("/SystemManage/SynthesisManage/ContractShiftActionAjax.jsp?SerialNo="+sSerialNo+"&FromOrgID="+sFromOrgID+"&FromOrgName="+sFromOrgName+"&FromUserID="+sFromUserID+"&FromUserName="+sFromUserName+"&ToUserID="+sToUserID+"&ToUserName="+sToUserName+"&ChangeObject="+sChangeObject,"","dialogWidth=21;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 
							if(sReturn == "TRUE")
								alert("合同流水号("+sSerialNo+"),"+getBusinessMessage("939"));//合同转移成功！
							else if(sReturn == "FALSE")
								alert("合同流水号("+sSerialNo+"),"+getBusinessMessage("940"));//合同转移失败！
							else if(sReturn == "NOT")
								alert("合同流水号("+sSerialNo+"),"+getBusinessMessage("941"));//接受客户经理对该合同的客户没有业务办理权，不能转移！
						}
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
		sBCFlag = getItemValue(0,getRow(),"BCFlag") ;
		if (typeof(sBCFlag) == "undefined" || sBCFlag == "")
			setItemValue(0,getRow(),"BCFlag","√");
		else
			setItemValue(0,getRow(),"BCFlag","");

	}
	
	/*~[Describe=选择记录;InputParam=无;OutPutParam=无;]~*/
	function selectRecord()
	{
		var b = getRowCount(0);
		var iCount = 0;				
		for(var i = 0 ; i < b ; i++)
		{
			var a = getItemValue(0,i,"BCFlag");
			if(a == "√")
				iCount = iCount + 1;
		}
		
		if(iCount == 0)
		{
			alert(getHtmlMessage('24'));//请至少选择一条信息！
			return false;
		}
		
		return true;
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
