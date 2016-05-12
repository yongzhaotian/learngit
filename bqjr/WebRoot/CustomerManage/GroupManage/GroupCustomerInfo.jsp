<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   lyin 2012-12-11
		Tester:
		Content:  集团客户概况页面
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
	//定义变量
    String sTempletNo = "";//显示模板编号
    String sTempletFilter = "1=1";
    
    //获得组件参数    ：客户类型、集团客户编号、集团客户名称、业务主办机构、业务主办客户经理、核心企业客户编号
    String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));
	if(sCustomerType==null) sCustomerType="";
	
    String sGroupID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GroupID"));
	if(sGroupID==null) sGroupID="";
	
	String groupName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GroupName"));
	if(sCustomerType==null) sCustomerType="";
	
	String sOldGroupType2 = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GroupType2"));
	if(sOldGroupType2==null) sOldGroupType2="";
	
	String sOldMgtOrgID=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("MgtOrgID"));
	if(sOldMgtOrgID==null) sOldMgtOrgID="";
	
	String sOldMgtUserID=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("MgtUserID"));
	if(sOldMgtUserID==null) sOldMgtUserID="";
	
	String sOldKeyMemberCustomerID=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("KeyMemberCustomerID"));
	if(sOldKeyMemberCustomerID==null) sOldKeyMemberCustomerID="";
	
	String sRightType=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RightType"));
	if(sRightType==null) sRightType="";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	sTempletNo = "GroupCustomerInfo1";
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
    dwTemp.setEvent("BeforeInsert","!CustomerManage.AddGroupCustomerAction(#GROUPID,"+CurOrg.getOrgID()+","+CurUser.getUserID()+")");//初始化客户信息
    dwTemp.setEvent("AfterInsert","!CustomerManage.InitGroupCustomerAction(#GROUPID,"+sCustomerType+","+CurUser.getUserID()+")");//初始化集团家谱等信息 
    
    //生成HTMLDataWindow
    Vector vTemp = dwTemp.genHTMLDataWindow(sGroupID);
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
			{(sRightType.equals("ReadOnly")?"false":"true"),"All","Button","保存","保存","saveRecord()","","","",""},
			{"false","","Button","集团核心企业信息","集团核心企业信息","viewParent()","","","",""},
			{"false","","Button","取消","取消","cancel()","","","",""}
	};
	
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
	function saveRecord(sPostEvents)
	{ 	
		var sGroupID = getItemValue(0,getRow(),"GROUPID");
		var sGroupName = getItemValue(0,getRow(),"GROUPNAME");
		var groupName= "<%=groupName%>";  
		var sCurrentVersionSeq = getItemValue(0,getRow(),"CURRENTVERSIONSEQ");      
		//验证集团名称是否重复
		if(groupName==null || groupName==""){
			//新增时
			var Return = RunJavaMethodTrans("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","checkGroupName","GroupName="+sGroupName);
			if(Return != "true"){
					alert("该集团名称已存在,请输入其他名称");
					return;
				}
			}else{
			//修改集团概况时
			var Return = RunJavaMethodTrans("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","checkGroupName1","GroupName="+sGroupName+",GroupID="+sGroupID);
			if(Return != "true"){
					alert("该集团名称已存在,请输入其他名称");
					return;
				}
			}
		
		//检查核心企业是否属于其他集团成员
		var sKeyMemberCustomerID = getItemValue(0,getRow(),"KEYMEMBERCUSTOMERID");
 		var sReturn = RunJavaMethodTrans("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","checkMember","keyMemberCustomerID="+sKeyMemberCustomerID+",GroupID="+sGroupID);
 		if(sReturn!="true"){
			alert(sReturn);
			return;
		}
 		
 		var sFamilyMapStatus=getItemValue(0,getRow(),"FAMILYMAPSTATUS");
		if(sFamilyMapStatus=="1"){
			alert("该集团正在审核中，不能进行修改!");
			return ;
		}

        //判断核心企业是否变动，取到旧的核心企业客户编号
        var sOldKeyMemberCustomerID = RunJavaMethodTrans("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","checkKeyMemberCustomerID","GroupID="+sGroupID);
       	if(sFamilyMapStatus!="0"&&sKeyMemberCustomerID!=sOldKeyMemberCustomerID){//不为草稿、核心企业改动
			if(!confirm("您确认要修改吗？修改后集团家谱将变更为[草稿]状态，并需重新提交复核后生效！")) return ;
			var sRefVersionSeq=RunJavaMethodTrans("com.amarsoft.app.als.customer.group.action.FamilyMaintain","getNewRefVersionSeq","userID=<%=CurUser.getUserID()%>,groupID="+sGroupID+",currentVersionSeq="+sCurrentVersionSeq+"");
			if(typeof(sRefVersionSeq)!="undefined" && sRefVersionSeq.length !=0 && sRefVersionSeq!="ERROR"){
				//家谱状态设置为0(草稿)
				setItemValue(0,getRow(),"FAMILYMAPSTATUS","0");
			}
		}
		as_save("myiframe0",sPostEvents);	
		
		updateGroupFamilyMember();
		
		var sMgtOrgID=getItemValue(0,getRow(),"MGTORGID");
		var sMgtUserID=getItemValue(0,getRow(),"MGTUSERID");
		var sKeyMemberCustomerID=getItemValue(0,getRow(),"KEYMEMBERCUSTOMERID");
		var sGroupType2=getItemValue(0,getRow(),"GROUPTYPE2");
		var sParam="GroupID="+sGroupID+"&GroupName="+sGroupName+"&GroupType2="+sGroupType2+"&MgtOrgID="+sMgtOrgID+"&MgtUserID="+sMgtUserID+"&KeyMemberCustomerID="+sKeyMemberCustomerID+"&RightType=All";
		AsControl.PopView("/CustomerManage/CustomerDetailTab.jsp",sParam,"");
		cancel();
	}
	
	function cancel(){
		top.close();
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	var isAdd=false;//当前是否为新增,默认为否
    /*~[Describe=弹出选择核心企业窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/   
    function selectKeyMemberCustomerName(){
    	var sKeyMemberCustomerID = getItemValue(0,getRow(),"KEYMEMBERCUSTOMERID");
    	var sGroupID = getItemValue(0,getRow(),"GROUPID");
    	//检查集团客户是否有在途申请
    	var sReturn = RunJavaMethodTrans("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","getBusinessMessage","GroupID="+sGroupID);
    	if(sReturn != "NO"){
    		alert("客户有在途申请，不允许修改核心企业！");
    		return;
    	}
    	//检查集团客户是否有已认定的家谱版本
    	var sReturn = RunJavaMethodTrans("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","checkKeyMemberCustomer","GroupID="+sGroupID);
    	var selName="";
    	var sParaString ="";
    	var sCol="";
    	if(sReturn == "NOTPAST"){//当前集团无已认定的家谱版本
    		selName="SelectKeyMemberCustomerID";
    		sCol="@CustomerID@0@CustomerName@1";
    	}else{					 //当前家谱有已认定的家谱版本，弹出对话框内容为当前集团家谱已认定成员列表
    		var sGroupID = getItemValue(0,getRow(),"GROUPID");
    		selName="SelectKeyMember";
    		sParaString = "GroupID"+","+sGroupID;
    		sCol="@MemberCustomerID@0@MemberName@1";
    	}
        var sRet = AsDialog.OpenSelector(selName,sParaString,sCol,0,0,"");
    	if(!isNull(sRet)){
	    	if(sRet=="_CLEAR_"){//清空
	        	setItemValue(0,getRow(),"KEYMEMBERCUSTOMERID","");
	        	setItemValue(0,getRow(),"KEYMEMBERCUSTOMERNAME","");
	        }else{
	        	sRet = sRet.split("@");
	        	setItemValue(0,getRow(),"KEYMEMBERCUSTOMERID",sRet[0]);
	        	setItemValue(0,getRow(),"KEYMEMBERCUSTOMERNAME",sRet[1]);
	        }
    	}
        
    }
	
    
    /*~[Describe=弹出选择主办客户经理窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/   
    function selectMgtUserID(){
    	var sGroupID = getItemValue(0,getRow(),"GROUPID");
      	//检查集团客户是否有在途申请
    	var sReturn = RunJavaMethodTrans("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","getBusinessMessage","GroupID="+sGroupID);
    	if(sReturn != "NO"){
    		alert("客户有在途申请，不允许修改主办客户经理！");
    		return;
    	}
    	var paraString="";
        var selName="";
    	if(<%=CurUser.hasRole("016")%>){
    		paraString = "UserID"+","+"<%=CurUser.getUserID()%>"; 
        	selName="selectMgtUserID";
    	}else{
        	selName="selectMgtUserID1";
    	}
   		var sRet = AsDialog.OpenSelector(selName,paraString,"@UserID@0@UserName@1@BelongOrg@2@OrgName@3",0,0,"");
        if(!isNull(sRet)) {
	        if(sRet=="_CLEAR_"){//清空
	        	setItemValue(0,getRow(),"MGTUSERID","");
	        	setItemValue(0,getRow(),"MGTUSERNAME","");
	        	setItemValue(0,getRow(),"MGTORGID","");
	        	setItemValue(0,getRow(),"MGTORGNAME","");
	        }else{
	        	sRet = sRet.split("@");
	        	setItemValue(0,getRow(),"MGTUSERID",sRet[0]);
	        	setItemValue(0,getRow(),"MGTUSERNAME",sRet[1]);
	        	setItemValue(0,getRow(),"MGTORGID",sRet[2]);
	        	setItemValue(0,getRow(),"MGTORGNAME",sRet[3]);
	        }
        }
    }
    
	/*~[Describe=校验集团简称长度;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function checkGroupAbbName(sGroupAbbName,n){
		var sFieldLength = 0;
		for(var i = 0; i < sGroupAbbName.length; i++){
			if(sGroupAbbName.charCodeAt(i)> 255){
				sFieldLength += 2;
		    }else{
		    	sFieldLength += 1;
		    }

		    if(sFieldLength > n){ 
				$("#GroupAbbNameMessage").text("集团简称长度限制为"+(n/2)+"个汉字(2个字母=1个汉字)，请重新命名！");
				return false;
			}
		}
		
		$("#GroupAbbNameMessage").text("");
		return true;
	}
	
	/*~[Describe=检验主办客户经理和主办机构;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function checkGroupType(sGroupType){
		sGroupType1 = getItemValue(0,0,"GroupType1");
		sMgtUserID = getItemValue(0,0,"MgtUserID");
		sMgtOrgID = getItemValue(0,0,"MgtOrgID");
		sGroupType4 = getItemValue(0,0,"GroupType4"); //是否自动建立额度分配
		if(sGroupType1 == "02" && (sMgtUserID == "" || sMgtOrgID == "")){
			$("#MgtUserMessage").text("该集团为地区性集团客户，请选择主办客户经理和主办机构！");
			return false;
		}

		if(sGroupType == "1"){
			if(sMgtUserID == "" || sMgtOrgID == ""){
				$("#MgtUserMessage").text("该集团客户在总行集中管理名单内，请选择主办客户经理和主办机构！");
				return false;
			}else if(sGroupType1 == "01" && sMgtOrgID != "10130"){
				$("#MgtUserMessage").text("该集团为跨分行集团客户，并在总行集中管理名单内，主办机构应为总行公司银行部，请重新做选择！");
				return false;
			}
		}

		$("#MgtUserMessage").text("");
		return true;
	}

	/*~[Describe=集团概况变更后的后续操作;InputParam=无;OutPutParam=无;]~*/
	function updateGroupFamilyMember(){
		var sMgtOrgID=getItemValue(0,getRow(),"MGTORGID");
		var sKeyMemberCustomerID=getItemValue(0,getRow(),"KEYMEMBERCUSTOMERID");
		var sMgtUserID=getItemValue(0,getRow(),"MGTUSERID");
		var sGroupType2=getItemValue(0,getRow(),"GROUPTYPE2");
		var oldGroupType2="<%=sOldGroupType2%>";
		var oldMgtOrgID="<%=sOldMgtOrgID%>";
		var oldMgtUserID="<%=sOldMgtUserID%>";
		var oldKeyMemberCustomerID="<%=sOldKeyMemberCustomerID%>";
		var sGroupID="<%=sGroupID%>";
		var sUserID="<%=CurUser.getUserID()%>";
		//检查核心企业是否已是自身集团成员
 		var sIsGroupMember = RunJavaMethod("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","isGroupCustomer1","memberCustomerID="+sKeyMemberCustomerID+",GroupID="+sGroupID);
		RunMethod("CustomerManage","UpdateGroupCustomerAction",sMgtOrgID+","+sKeyMemberCustomerID+","+sMgtUserID+","+sGroupType2+","+oldGroupType2+","+oldMgtOrgID+","+oldMgtUserID+","+oldKeyMemberCustomerID+","+sGroupID+","+sUserID+","+sIsGroupMember);

	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		isAdd=false;
		if (getRowCount(0)==0){ //如果没有找到对应记录，则新增一条，并设置字段默认值
			as_add("myiframe0");//新增记录
			isAdd=true;
			initSerialNo();	
			setItemValue(0,getRow(),"INPUTORGID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,getRow(),"INPUTORGNAME","<%=CurOrg.getOrgName()%>");
			setItemValue(0,getRow(),"INPUTUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
		}
		setItemValue(0,getRow(),"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
    }

	function isNull(value){
		if(typeof(value)=="undefined" || value==""){
			return true;
		}
		return false;
	}
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "GROUP_INFO";//表名
		var sColumnName = "GROUPID";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
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
