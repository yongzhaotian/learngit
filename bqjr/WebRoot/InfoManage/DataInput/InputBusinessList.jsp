<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%> 

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: jschen  2010.03.17
		Tester:
		Describe: 信贷业务补登列表;
		Input Param:
			ReinforceFlag：110 需补登信贷业务
			               120 已补登信贷业务
		Output Param:
			
		HistoryLog:
			    
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "信贷业务补登列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql="";
	String sClauseWhere="";
	//获得页面参数
	
	//获得组件参数
	String sReinforceFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReinforceFlag"));
	if(sReinforceFlag==null) sReinforceFlag="";


%>
<%/*~END~*/%>
	
	
	
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//由SQL语句生成窗体对象。
	String sTempletNo="InputBusinessList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	if(sReinforceFlag.equals("010")){  //需补登信贷业务
		doTemp.WhereClause += " and ManageOrgID ='"+CurOrg.getOrgID()+"'";
	}
	if(sReinforceFlag.equals("020")){  //补登完成信贷业务
		doTemp.WhereClause += " and ManageUserID ='"+CurUser.getUserID()+"'";
	}
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20); 	//服务器分页
	
	Vector vTemp = dwTemp.genHTMLDataWindow(sReinforceFlag);
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
				{"true","","Button","补登","补登一笔信贷业务和客户基本信息","InputInfo()",sResourcesPath},
				{"true","","Button","关联已有客户","关联已有客户","ChangeCustomer()",sResourcesPath},
				{"false","","Button","详情","打开合同详情页面,可以关联一笔额度","CreditBusinessInfo()",sResourcesPath},
				{"true","","Button","合并合同","进行合同合并操作","UnitContract()",sResourcesPath},
				{"true","","Button","修改业务品种","修改所选中的信贷业务的业务品种","ChangeBizType()",sResourcesPath},
				{"true","","Button","补登完成","将所选中的信贷业务置为完成状态","FinishCreditBusiness()",sResourcesPath},
				{"true","","Button","重新补登","将所选中的信贷业务置为需补登状态","secondFinishCreditBusiness()",sResourcesPath},
			};
	
	//需补登信贷业务
	if(sReinforceFlag.equals("010")){
		sButtons[6][0] = "false";
	}
	//补登完成信贷业务
	if(sReinforceFlag.equals("020")){
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[3][0] = "false";
		sButtons[4][0] = "false";
		sButtons[5][0] = "false";
		sButtons[2][0] = "true";
	}
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=补登客户和业务信息;InputParam=无;OutPutParam=无;]~*/
	function InputInfo(){
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");	
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");	
		var sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		var sCustomerName = getItemValue(0,getRow(),"CustomerName");
		var sCustomer = "";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			//业务未关联客户
			if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
				/*----------------------------------新增客户begin----------------------------*/
				//选择客户类型
				var sReturnValue = PopPage("/InfoManage/DataInput/UpdateInputCustomerDialog.jsp","_self","dialogWidth=24;dialogHeight=12;resizable=no;scrollbars=no;status:no;maximize:no;help:no;");
				if(typeof(sReturnValue)=="undefined" || sReturnValue.length==0 || sReturnValue == '_CANCEL_'){
					return;
				}
				var sCustomerType = sReturnValue;
				
			    //客户信息录入模态框调用   
			    //这里区分客户类型，仅为控制对话框的展示大小
			    if(sCustomerType.substring(0,2) == "01"||sCustomerType.substring(0,2) == "03") 
			        sReturnValue = PopPage("/CustomerManage/AddCustomerDialog.jsp?CustomerType="+sCustomerType,"","resizable=yes;dialogWidth=25;dialogHeight=14;center:yes;status:no;statusbar:no");
			    else
			        sReturnValue = PopPage("/CustomerManage/AddCustomerDialog.jsp?CustomerType="+sCustomerType,"","resizable=yes;dialogWidth=25;dialogHeight=10;center:yes;status:no;statusbar:no");
			    //判断是否返回有效信息
			    if(typeof(sReturnValue) != "undefined" && sReturnValue.length != 0 && sReturnValue != '_CANCEL_'){
			        sReturnValue = sReturnValue.split("@");
			        //得到客户输入信息
			        sCustomerOrgType = sReturnValue[0];
			        sCustomerName = sReturnValue[1];
			        sCertType = sReturnValue[2];
			        sCertID = sReturnValue[3];
			    
			        //检查客户信息存在状态
			        sReturnStatus = RunMethod("CustomerManage","CheckCustomerAction",sCustomerType+","+sCustomerName+","+sCertType+","+sCertID+",<%=CurUser.getUserID()%>");
			        //得到客户信息检查结果和客户号
			        sReturnStatus = sReturnStatus.split("@");
			        sStatus = sReturnStatus[0];
			        sCustomerID = sReturnStatus[1];
			        sHaveCustomerType = sReturnStatus[2];
			        sHaveCustomerTypeName = sReturnStatus[3];
			        sHaveStatus = sReturnStatus[4];
					//由于是公共页面，检查当前引入的客户客户类型是否与当前页面操作的客户类型一致
					if(sStatus != "01"){
						if(sCustomerType != sHaveCustomerType){
							alert("客户号："+sCustomerID+"，属于："+sHaveCustomerTypeName+"，不能在此引入");
							return;
						}
					}
			        
			        //02为当前用户以与该客户建立有效关联
			        if(sStatus == "02"){
			            if(sHaveCustomerType == sCustomerType){
			                alert(getBusinessMessage('105')); //该客户已被自己引入过，请确认！
			                sCustomer = sCustomerID+"@"+sCustomerName+"@";
			            }else{
			                alert("客户号："+sCustomerID+"已在"+sHaveCustomerTypeName+"客户管理页面被自己引入过，请确认！");
			            }
			            //return;
			        }

			        //01为该客户不存在本系统中
			        if(sStatus == "01"){                
			            //取得客户编号
			            sCustomerID = getNewCustomerID();
			        }
			        //01 当检查结果为无该客户
			        //04 没有和任何客户建立主办权
			        //05 和其他客户建立主办权时进行对数据库操作
			        if(sStatus == "01" || sStatus == "04" || sStatus == "05"){
			            //参数说明CustomerID,CustomerName,CustomerType,CertType,CertID,Status,CustomerOrgType,UserID,OrgID
			            var sParam = "";
			            sParam = sCustomerID+","+sCustomerName+","+sCustomerType+","+sCertType+","+sCertID+
			                     ","+sStatus+","+sCustomerOrgType+",<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>,"+sHaveCustomerType;
			            sReturn = RunMethod("CustomerManage","AddCustomerAction",sParam);
			            //当该客户与其他用户建立有效关联且为企业客户和关联集团 ,需要向系统管理员申请权限
			            if(sReturn == "1"){
			                if(sStatus == "05"){
			                    if(confirm("客户号："+sCustomerID+"已成功引入，要立即申请该客户的权限吗？")) //客户已成功引入，要立即申请该客户的管户权吗？
			                        popComp("RoleApplyInfo","/CustomerManage/RoleApplyInfo.jsp","CustomerID="+sCustomerID+"&UserID=<%=CurUser.getUserID()%>&OrgID=<%=CurOrg.getOrgID()%>","");
			                }else if(sStatus == "04"){
			                    alert("客户号："+sCustomerID+"已成功引入!");
			                }else if(sStatus == "01"){
			                    alert("客户号："+sCustomerID+"新增成功!"); //新增客户成功
			                }  
			                sCustomer = sCustomerID+"@"+sCustomerName+"@";                                 
			            //当该客户没有与任何用户建立有效关联、当前用户已与该客户建立无效关联、该客户与其他用户建立有效关联（个人客户/个体工商户/农户/联保小组）已经引入客户
			            }else if(sReturn == "2"){
			                //alert("引入客户号："+sCustomerID+"的客户类型为"+sHaveCustomerTypeName+"，不能在本页面引入！");
			                alert("引入客户号："+sCustomerID+"的客户类型为"+sHaveCustomerTypeName+"，不能在本页面引入！\r\n该客户只能做为"+sHaveCustomerTypeName+"引入，引入后可以进行客户规模转换");
			            //已经新增客户
			            }else{
			                alert("新增客户失败！"); //新增客户失败
			                return;
			            }
			        } 
			        if(sStatus == "01" || sStatus == "04"){
			            //与客户管理新增客户信息功能不同，如果是中小企业，要更新其认定状态为已认定.
			            if(sCustomerType == "0120")
			                RunMethod("CustomerManage","UpdateCustomerStatus",sCustomerID+","+"1");  
			        }
		    	}
			    /*----------------------------------新增客户end----------------------------*/				
			    
				if (typeof(sCustomer)=="undefined" || sCustomer.length==0) {
					alert("要补登的客户信息不存在,请先选择客户！");	
					return;
				}else{
					sCustomer = sCustomer.split("@");
					sCustomerID = sCustomer[0];
					sCustomerName = sCustomer[1];
					//将客户信息更新到BUSINESS_CONTRACT
					RunMethod("信息补登","UpdateBCCustomer",sSerialNo+","+sCustomerID+","+sCustomerName+","+"<%=StringFunction.getToday()%>");  
				}
			}

			//选择业务品种
			if(typeof(sBusinessType)=="undefined" || sBusinessType.length==0){
				//选择业务品种
				var sReturn = selectBusinessType(sCustomerID,sSerialNo);
				//未选择业务品种时直接返回
				if(sReturn == "false"){
					return;
				}
			}
			
		    //根据合同流水号，打开详情界面
			sCompID = "CreditTab";
			sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
			sParamString = "ObjectType=ReinforceContract&ObjectNo="+sSerialNo;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			//补登未完成之前，归档日期强制置为空
			sReturn = PopPageAjax("/Common/WorkFlow/AddPigeonholeActionAjax.jsp?Pigeonholed=Y&ObjectType=ReinforceContract&ObjectNo="+sSerialNo,"","");
			reloadSelf();	
		}
	}

	/*~[Describe=弹出业务品种选择窗口，并置将返回的值设置到指定的域;InputParam=客户号sCustomerID，合同流水号sSerialNo;OutPutParam=无;]~*/
	function selectBusinessType(sCustomerID,sSerialNo){
		var sBusinessType = "";
		sReturn = RunMethod("PublicMethod","GetColValue","CustomerType,CUSTOMER_INFO,String@CustomerID@"+sCustomerID);
		sReturn = sReturn.split("@");
		//如果为个人客户
		if(sReturn[1].substr(0,2) == "03"){
			if(sReturn[1] == "0310"){
				sBusinessType = setObjectValue("SelectIndBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");			
			}else if(sReturn[1] == "0320"){
				sBusinessType = setObjectValue("SelectIndEntBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");			
			}else{
				alert("请选择个人客户或者个体经营户！");
				return "false";
			}
		}	
		//如果为公司客户		
		else if(sReturn[1].substr(0,2) == "01"){
			if(sReturn[1] == "0110"){ 
				sBusinessType = setObjectValue("SelectInputEntBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");			
			}else if(sReturn[1] == "0120"){
				sBusinessType = setObjectValue("SelectInputSMEBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");			
			}else{
				alert("请选择大型企业客户或者中小企业客户！");
				return "false";
			}
		}

		if (!(sBusinessType=='_CANCEL_' || typeof(sBusinessType)=="undefined" || sBusinessType.length==0 || sBusinessType=='_CLEAR_' || sBusinessType=='_NONE_'))
		{
			sBusinessType = sBusinessType.split("@");
			RunMethod("信息补登","UpdateBusinessType",sSerialNo+","+sBusinessType[0]+","+"<%=StringFunction.getToday()%>");
		}else{
				return "false";
		}
	}

	/*~[Describe=关联已有客户;InputParam=无;OutPutParam=无;]~*/
	function ChangeCustomer(){
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");	
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		var sCustomerName   = getItemValue(0,getRow(),"CustomerName");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			if(typeof(sCustomerID) != "")
				if(!confirm("该业务已关联客户"+sCustomerName+"，是否重新关联?"))return;
			sParaString = "OrgID,"+"<%=CurUser.getOrgID()%>";
			sCustomer = setObjectValue("SelectAllCustomer",sParaString,"@CustomerID@0@CustomerName@1",0,0,"");
			if(sCustomer == "_CLEAR_"){
				alert("清空操作无效！");
				return;
			}
			if (typeof(sCustomer)=="undefined" || sCustomer.length==0 || sCustomer == "_CANCEL_" || sCustomer == "_NONE_"){
				return;
			}else{
				sCustomer = sCustomer.split("@");
				sCustomerID = sCustomer[0];
				sCustomerName = sCustomer[1];
				//将客户信息更新到BUSINESS_CONTRACT
				RunMethod("信息补登","UpdateBCCustomer",sSerialNo+","+sCustomerID+","+sCustomerName+","+"<%=StringFunction.getToday()%>");  
			}
		}
		reloadSelf();
	}

	/*~[Describe=合并合同;InputParam=无;OutPutParam=无;]~*/
	function UnitContract(){
		//合同流水号、客户编号、合同编号
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		var sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			var sReturn = popComp("UniteContractSelectList","/InfoManage/DataInput/UniteContractSelectList.jsp","ContractNo="+sSerialNo+"&CustomerID="+sCustomerID+"&BusinessType="+sBusinessType,"dialogWidth=50;dialogHeight=40;","resizable=yes;scrollbars=yes;status:no;maximize:yes;help:no;");
			if(sReturn=="true"){
				reloadSelf();
			}
		}
	}
	
	/*~[Describe=修改业务品种;InputParam=无;OutPutParam=无;]~*/
	function ChangeBizType(){
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");	
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("要补登的客户信息不存在,请先选择客户！");
			return;	
		}
		//选择业务品种
		var sReturn = selectBusinessType(sCustomerID,sSerialNo);
		if(sReturn == "false")
			return ;
		reloadSelf();
	}

	/*~[Describe=详情;InputParam=无;OutPutParam=无;]~*/
	function CreditBusinessInfo(){
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sReinforceFlag = "<%=sReinforceFlag%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			sCompID = "CreditTab";
			sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
			if(sReinforceFlag=="010"){
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
	
	/*~[Describe=置信贷完成补登标志;InputParam=无;OutPutParam=无;]~*/
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
			if(typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
				alert("客户编号为空，请先补登客户！");
				return;
			}else{
				if(typeof(sBusinessType)=="undefined" || sBusinessType.length==0){
					alert("业务品种为空，请先补登业务品种！");
					return;
				}else{
					sReturn = autoRiskScan("012","ObjectNo="+sSerialNo+"&CustomerID="+sCustomerID,10);	
					if(sReturn != true){
						return;
					}	
					RunMethod("信息补登","UpdateReinforceFlag",sSerialNo+","+sReinforceFlag+","+sBusinessType);
					sReturn = PopPageAjax("/Common/WorkFlow/AddPigeonholeActionAjax.jsp?ObjectType=ReinforceContract&ObjectNo="+sSerialNo,"","");
					if(sReturn == "true"){
						alert("补登完成，该业务已转到补登完成授信业务列表!");
					}
				}
				reloadSelf();	
			}
		}
	}

	/*~[Describe=重新补登;InputParam=无;OutPutParam=无;]~*/
	function secondFinishCreditBusiness(){
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sReinforceFlag = "<%=sReinforceFlag%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		} else {
			RunMethod("信息补登","UpdateReinforceFlag",sSerialNo+","+sReinforceFlag+"");
			sReturn = PopPageAjax("/Common/WorkFlow/AddPigeonholeActionAjax.jsp?ObjectType=ReinforceContract&Pigeonholed=Y&ObjectNo="+sSerialNo,"","");
			if(sReturn == "true"){
				alert("该笔信贷业务已返回需补登授信信贷列表，请重新补登!");
			}			
			reloadSelf();
		}
	}

    /*~[Describe=生成新客户ID;InputParam=无;OutPutParam=无;]~*/
    function getNewCustomerID(){
    	var sTableName = "CUSTOMER_INFO";//表名
		var sColumnName = "CustomerID";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
        return sSerialNo;
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
