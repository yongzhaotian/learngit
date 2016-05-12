<%@page import="com.amarsoft.app.util.ASUserObject"%>
<%@page import="com.amarsoft.app.als.customer.common.action.GetCustomer"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.are.jbo.JBOFactory"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   lyin 2012-12-20
		Tester:
		Content:  新增集团成员页面
		Input Param:	  
		Output param:
	 */
	%>
<%/*~END~*/%> 


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "集团客户概况"; // 浏览器窗口标题
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
		//获取参数  集团编号，父节点， 成员编号， 版本号 
		String sGroupID= CurPage.getParameter("GroupID");
	    String sParentMemberID = CurPage.getParameter("ParentMemberID");
	    String sMemberCustomerID = CurPage.getParameter("MemberCustomerID");
		String sRefVersionSeq=CurPage.getParameter("RefVersionSeq");
	    
		if(sGroupID == null) sGroupID = "";
		if(sParentMemberID == null) sParentMemberID = "";
		if(sMemberCustomerID == null) sMemberCustomerID = "";
		if(sRefVersionSeq == null) sRefVersionSeq = "";
%>
<%/*~END~*/%> 
 
 
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
<%	
		String sTempletNo = "MemberInfoViewInfo";
		String sTempletFilter = "1=1";
		
		ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		
		dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
    
	    doTemp.setDefaultValue("ParentMemberID",sParentMemberID);
		doTemp.setDefaultValue("MemberCustomerID",sMemberCustomerID);
		doTemp.setDefaultValue("GroupID",sGroupID);
		doTemp.setDefaultValue("VersionSeq",sRefVersionSeq);
		
		int icount=JBOFactory.getBizObjectManager("jbo.app.GROUP_FAMILY_MEMBER")
								.createQuery("O.GroupID =:GroupID  AND O.VersionSeq =:VersionSeq  AND O.MemberCustomerID =:MemberCustomerID")
								.setParameter("GroupID",sGroupID)
								.setParameter("VersionSeq",sRefVersionSeq)
								.setParameter("MemberCustomerID",sMemberCustomerID)
								.getTotalCount();
		
	    //生成HTMLDataWindow
	    Vector vTemp = dwTemp.genHTMLDataWindow(sGroupID+","+sRefVersionSeq+","+sMemberCustomerID);
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
	        {"true","","Button","保存","保存所有修改","doReturn()","","","",""},
	        {"false","","Button","返回","返回列表页面","goBack()","","","",""}
	        };
	%> 
<%/*~END~*/%>

 
<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
<script language=javascript>
    var bIsInsert = false; //标记DW是否处于“新增状态”
	icount=<%=icount%>;
	function doReturn(){
		initSerialNo();
		var sShareValue = getItemValue(0,getRow(),"ShareValue");
		if(parseFloat(sShareValue)>100 || parseFloat(sShareValue)<0){
			alert("持股比例必须在[0,100]");
			return;
		}
		var sParentRelationType = getItemValue(0,getRow(),"ParentRelationType");
		var sMemberCustomerID = getItemValue(0,getRow(),"MemberCustomerID");
		var sAddReason = getItemValue(0,getRow(),"ATT01");
		if(sMemberCustomerID=="" || sMemberCustomerID==""){
			alert("请选择客户！");
			return;
		}

		if(sAddReason==""){
			alert("请选择加入成员原因！");
			return;
		}

		if(icount>0){ //更新
			as_save("myiframe0","myReturn();");
		}else{ //新增
			//检查成员是否属于其他集团
			var sGroupID= getItemValue(0,getRow(),"GroupID");
			RunJavaMethod("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","forDeleteGroupmember","MemberCustomerID="+sMemberCustomerID+",GroupID="+sGroupID);
	 		var sReturn = RunJavaMethod("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","isGroupCustomer","MemberCustomerID="+sMemberCustomerID+",GroupID="+sGroupID);
	 		if(sReturn!="true"){
				alert(sReturn);
				return;
			}
	 		if(sShareValue==""){
	 		    alert("请输入持股比例!");
	 		    return;
	 		}
	 	   // as_save("myiframe0","myReturn();");
	 	    alert("数据保存成功");
 			myReturn();
		}
	}

	function goBack(){
		top.close();
	}
	
</script>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
<script language=javascript>
	function myReturn()
	{
		var oReturn = {};
		oReturn["MemberCustomerID"] = getItemValue(0,getRow(),"MemberCustomerID");
		oReturn["MemberName"] = getItemValue(0,getRow(),"MemberName");
		oReturn["ParentMemberID"] = getItemValue(0,getRow(),"ParentMemberID");
		oReturn["MemberCertType"] = getItemValue(0,getRow(),"MemberCertType");
		oReturn["MemberCertID"] = getItemValue(0,getRow(),"MemberCertID");
		oReturn["MemberType"] = getItemValue(0,getRow(),"MemberType");
		oReturn["ShareValue"] = getItemValue(0,getRow(),"ShareValue");
		oReturn["AddReason"] = getItemValue(0,getRow(),"ATT01");
		oReturn["ParentRelationType"] = getItemValue(0,getRow(),"ParentRelationType");
		top.returnValue = oReturn;
		top.close();  
	}
	
	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer(){
		//返回客户的相关信息、客户代码、客户名称、证件类型、客户证件号码
		var sRet = AsDialog.OpenSelector("SelectKeyMemberCustomerID","","@MemberCustomerID@0@MemberName@1@MemberCertType@3@MemberCertID@4",0,0,"");
		if(sRet == "_CANCEL_") {sRet="@@@@"};
		if(sRet) {
        	sRet = sRet.split("@");
        	setItemValue(0,getRow(),"MemberCustomerID",sRet[0]);
        	setItemValue(0,getRow(),"MemberName",sRet[1]);
        	setItemValue(0,getRow(),"MemberCertType",sRet[2]);
        	setItemValue(0,getRow(),"MemberCertID",sRet[3]);
        }
	}
	
	function selectParentCustomer(){

	}
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "GROUP_FAMILY_MEMBER";//表名
		var sColumnName = "MemberID";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0){ //如果没有找到对应记录，则新增一条，并设置字段默认值
			as_add("myiframe0");//新增记录
			bIsInsert = true;
		}

    }
</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>