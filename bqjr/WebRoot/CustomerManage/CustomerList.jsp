<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
    <%
    /*
        Author:   --cchang  2004.12.2
               
        Tester: 
        Content: 客户信息列表
        Input Param:
            CustomerType：客户类型
                01：公司客户；
                0110：大型企业客户；
                0120：中小型企业客户；
                02：集团客户；
                0210：实体集团客户；
                0220：虚拟集团客户；
                03：个人客户
                0310：个人客户；
                0320：个体经营户；
            CustomerListTemplet：客户列表模板代码          
        以上参数统一由代码表:--MainMenu主菜单得到配置
        Output param:
           CustomerID：客户编号
           CustomerType：客户类型                                        
           CustomerName：客户名称
           CertType：客户证件类型                                      
           CertID：客户证件号码
        History Log: 
            DATE    CHANGER     CONTENT
            2005-07-20  fbkang  页面重整
            2005/09/10 zywei 重检代码
            2009/08/13 djia 整合AmarOTI --> queryCusomerInfo()
            2009/10/12 pwang 修改本页面的涉及客户类型判断的内容。
    */
    %>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
    <%
    String PG_TITLE = "客户信息列表"   ; // 浏览器窗口标题 <title> PG_TITLE </title>  
    %>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
    //定义变量
    String sSql = "";//存放 sql语句 
    String sUserID = CurUser.getUserID(); //用户ID
    String sOrgID = CurOrg.getOrgID(); //机构ID
    
    //获得组件参数    ：客户类型、客户显示模版号
    String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));
    String sTempletNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerListTemplet"));
    String sCurItemID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CurItemID")); //用户点击的树图项ID，在集团客户管理时，由此来确定在页面上显示的按钮  add by cbsu 2009-10-21
    //将空值转化为空字符串
    if(sCustomerType == null) sCustomerType = "";
    if(sTempletNo == null) sTempletNo = "";
    if(sCurItemID == null) sCurItemID = ""; // add by cbsu 2009-10-21
    //获得页面参数
    
    //add by syang 2009/11/06 是否征信标准集团客户查询（集团客户查询为集团客户管理岗，可以查看机构辖内的集团客户信息）
    boolean bGroupAdmin = false;
    
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
    //通过显示模版产生ASDataObject对象doTemp
    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
    
    doTemp.setKeyFilter("CB.CustomerID");

    //增加过滤器 
    
    doTemp.generateFilters(Sqlca);
    doTemp.parseFilterData(request,iPostChange);
    CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    
    //产生datawindows
    ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
    //设置在datawindows中显示的行数
    dwTemp.setPageSize(20); //add by hxd in 2005/02/20 for 加快速度
    //设置DW风格 1:Grid 2:Freeform
    dwTemp.Style="1";      
    //设置是否只读 1:只读 0:可写
    dwTemp.ReadOnly = "1";
        
    //生成HTMLDataWindow
    Vector vTemp = dwTemp.genHTMLDataWindow(sUserID+","+sCustomerType+","+sOrgID+","+CurOrg.getSortNo());
    for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
    //out.println(doTemp.SourceSql); //调试datawindow的Sql常用方法
    
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
    <%
    String sbCustomerType = sCustomerType.substring(0,2);
    
    //依次为：
        //0.是否显示
        //1.注册目标组件号(为空则自动取当前组件)
        //2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
        //3.按钮文字
        //4.说明文字
        //5.事件 
        //6.资源图片路径{"true","","Button","管户权转移","管户权转移","ManageUserIdChange()",sResourcesPath}
    String sButtons[][] = {
            //在集团客户管理时，当用户点击"集团客户查询"则不显示"新增"按钮 add by cbsu 2009-10-21
            {(sCurItemID.equals("02")?"false":"true"),"","Button","新增","新增一条记录","newRecord()",sResourcesPath}, 
            {"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
            //在集团客户管理时，当用户点击"集团客户查询"则不显示"删除"按钮 add by cbsu 2009-10-21
            {(sCurItemID.equals("02")?"false":"true"),"","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}, 
            {(sbCustomerType.equals("01")?"true":"false"),"","Button","客户信息预警","客户信息预警","alarmCustInfo()",sResourcesPath},
            {(sbCustomerType.equals("02")?"false":"true"),"","Button","加入重点客户链接","加入重点客户链接","addUserDefine()",sResourcesPath},
            {(sbCustomerType.equals("02") || sCustomerType.equals("0320")?"false":"true"),"","Button","权限申请","权限申请","ApplyRole()",sResourcesPath},
            {(sbCustomerType.equals("02") && !sCurItemID.equals("02")?"true":"false"),"","Button","转移管户权","集团客户移交","transCust()",sResourcesPath},
            {(sbCustomerType.equals("01")?"true":"false"),"","Button","客户规模转换","改变客户企业规模","changeCustomerType()",sResourcesPath},
            {(sbCustomerType.equals("03")?"true":"false"),"","Button","客户类型转换","改变客户类型","changeCustomerType()",sResourcesPath},
            {(sbCustomerType.equals("01")?"true":"false"),"","Button","集团客户关联搜索","集团客户关联搜索","searchCustRela()",sResourcesPath},
            {(sbCustomerType.equals("01")?"false":"false"),"","Button","认定客户规模","认定客户规模","confirmScale()",sResourcesPath},
            {"false","","Button","客户概览","查看客户基本信息和授信业务信息","viewCustomerInfo()",sResourcesPath},
            {(sbCustomerType.equals("02")?"false":"true"),"","Button","客户开户查询","查询客户开户信息","queryCusomerInfo()",sResourcesPath}
        };
    %> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
    <%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
    <script type="text/javascript">

    //---------------------定义按钮事件------------------------------------
    /*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
    function newRecord(){
        var sCustomerType='<%=sCustomerType%>'; //--客户类型
        var sCustomerID ='';                                        //--客户代码
        var sReturn ='';                                                //--返回值，客户的录入信息是否成功
        var sReturnStatus = '';                                 //--存放客户信息检查结果
        var sStatus = '';                                               //--存放客户信息检查状态      
        var sReturnValue = '';                                  //--存放客户输入信息
        var sCustomerOrgType ='';                               //--客户类型性质
        var sHaveCustomerType = "";
        var sHaveCustomerTypeName = "";
        var sHaveStatus = "";

        //集团客户选择框：实体 集团  或  虚拟集团。但现在不区分集团客户的类型，因此将此段代码注释掉
        //if(sCustomerType == "02"){
        //    sCustomerType = selectCode("CustomerType","集团客户类型","0220","02.+");
        //    if(typeof(sCustomerType) == "undefined" || sCustomerType.length == 0 || sCustomerType == '_CANCEL_'){
        //        return;
        //    }
        // }
      
        //客户信息录入模态框调用   
        //这里区分客户类型，仅为控制对话框的展示大小
        if(sCustomerType.substring(0,2) == "01"||sCustomerType.substring(0,2) == "03")
            sReturnValue = PopPage("/CustomerManage/AddCustomerDialog.jsp?CustomerType="+sCustomerType,"","resizable=yes;dialogWidth=350px;dialogHeight=200px;center:yes;status:no;statusbar:no");
        else
        	sReturnValue = PopPage("/CustomerManage/AddCustomerDialog.jsp?CustomerType="+sCustomerType,"","resizable=yes;dialogWidth=350px;dialogHeight=150px;center:yes;status:no;statusbar:no");                
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
                }else{
                    alert("客户号："+sCustomerID+"已在"+sHaveCustomerTypeName+"客户管理页面被自己引入过，请确认！");
                }
                return;
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
                    if(sStatus == "05")
                    {
                        if(confirm("客户号："+sCustomerID+"已成功引入，要立即申请该客户的权限吗？")) //客户已成功引入，要立即申请该客户的管户权吗？
                            popComp("RoleApplyInfo","/CustomerManage/RoleApplyInfo.jsp","CustomerID="+sCustomerID+"&UserID=<%=CurUser.getUserID()%>&OrgID=<%=CurOrg.getOrgID()%>","");
                    }else if(sStatus == "04"){
                        alert("客户号："+sCustomerID+"已成功引入!");
                    }else if(sStatus == "01"){
                        alert("客户号："+sCustomerID+"新增成功!"); //新增客户成功
                    }                                   
                //当该客户没有与任何用户建立有效关联、当前用户以与该客户建立无效关联、该客户与其他用户建立有效关联（个人客户/个体工商户/农户/联保小组）已经引入客户
                }else if(sReturn == "2"){
                    alert("引入客户号："+sCustomerID+"的客户类型为"+sHaveCustomerTypeName+"，不能在本页面引入！");
                //已经新增客户
                }else{
                    alert("新增客户失败！"); //新增客户成功
                    return;
                }
            }           
            if(sStatus == "01" || sStatus == "04"){
                //如果是中小企业，要更新其认定状态为未认定.
                if(sCustomerType == "0120")
                    RunMethod("CustomerManage","UpdateCustomerStatus",sCustomerID+","+"0");             
            }
            openObject("Customer",sCustomerID,"001");
            reloadSelf();
        }
    }
    
    /*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
    function deleteRecord(){
    	var sCustomerID = getItemValue(0,getRow(),"CustomerID");        
        if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
            alert(getHtmlMessage('1')); //请选择一条信息！
            return;
        }
        
        if(confirm(getHtmlMessage('2'))){ //您真的想删除该信息吗？
            sReturn = PopPageAjax("/CustomerManage/DelCustomerBelongActionAjax.jsp?CustomerID="+sCustomerID+"","","");
            if(sReturn == "ExistApply"){
                alert(getBusinessMessage('113'));//该客户所属申请业务未终结，不能删除！
                return;
            }
            if(sReturn == "ExistApprove"){
                alert(getBusinessMessage('112'));//该客户所属最终审批意见业务未终结，不能删除！
                return;
            }
            if(sReturn == "ExistContract"){
                alert(getBusinessMessage('111'));//该客户所属合同业务未终结，不能删除！
                return;
            }
            if(sReturn == "DelSuccess"){
                alert(getBusinessMessage('110'));//该客户所属信息已删除！
                reloadSelf();
            }
        }
    }
    
    //客户信息预警
    function alarmCustInfo(){
    	var sCustomerID = getItemValue(0,getRow(),"CustomerID");
        if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
            alert(getHtmlMessage('1')); //请选择一条信息！
        }else {
            sReturn = autoRiskScan("005","ObjectType=Customer&ObjectNo="+sCustomerID);      
        }       
    }

    /*~[Describe=集团客户移交;InputParam=无;OutPutParam=无;]~*/
    function transCust(){
    	var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
    	var sManUserID   = getItemValue(0,getRow(),"UserID");
	    if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
	        alert(getHtmlMessage('1'));//请选择一条信息！
	        return;
	    }
	    if (typeof(sManUserID)=="undefined" || sManUserID.length==0){
	        alert("数据异常，当前客户未找到其管户客户经理编号");
	        return;
	    }
	
	    var sReturn = RunMethod("CustomerManage","CheckRolesAction",sCustomerID+",<%=CurUser.getUserID()%>");
	    if(typeof(sReturn) == "undefined" || sReturn.length == 0){
	        return;
	    }
	    var sReturnValue = sReturn.split("@");
	    sReturnValue1 = sReturnValue[0];    //客户主办权
	    sReturnValue2 = sReturnValue[1];    //信息查看权
	    sReturnValue3 = sReturnValue[2];    //信息维护权
      	if(sReturnValue1 != "Y"){
            alert("你没有该客户主办权");
            return;
       	}
			//检查集团客户未结清的授信业务
			//返回值：
   	 		//* 0 未结清的业务笔数为0(通过)<br/>
 			//* 1 有在途额度申请<br/>
 			//* 2 在未审批通过的最终审批意见<br/>
 			//* 3 有未登记完成的合同<br/>  
     	sReturn = RunMethod("BusinessManage","GroupCustBizCheck",sCustomerID);
     	if(sReturn == "1"){
				alert("有在途额度申请，不能转移");
				return ;
     	}else if(sReturn == "2"){
				alert("有未审批通过的最终审批意见，不能转移");
				return ;
     	}else if(sReturn == "3"){
				alert("有未登记完成的合同，不能转移");
				return ;
     	}
     	
     	 //集团客户管理岗的角色为总行：027，分行：227，支行：427，所以用通配27角色
       sParaString = "OrgID,<%=CurOrg.getSortNo()%>,RoleID,27";
       sReturn = selectObjectValue("UserInRoleAndOrg",sParaString);
       //如果用户关闭了此窗口或者什么也没选择时，就此中止
       if(typeof(sReturn) == 'undefined' 
           || sReturn == '_CANCEL_'
           || sReturn == '_NONE_'
           || sReturn == '_CLEAR_'
           || sReturn.length == 0
           ){
            return;
       }
       stdUID=sReturn.split("@")[0];           //选择的用户ID
       stdOrgID = sReturn.split("@")[1];
       if(stdUID == "<%=CurUser.getUserID()%>"){
           alert("移交目标用户为当前用户本人，移交无意义");
           return;
       }
       if(stdOrgID == null || stdOrgID.length == 0){
				alert("当前选择的用户数据异常，无机构号");
				return;
       }
       sReturn = RunMethod("CustomerManage","TransGroupCustMana",sCustomerID+","+stdUID);
       if(parseInt(sReturn) == 1){
           alert("客户号："+sCustomerID+"，管户权转移成功！");
           reloadSelf();
       }
    }
    /*~[Describe=改变客户类型;InputParam=无;OutPutParam=无;]~*/
    function changeCustomerType(){
    	var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
        var sType="<%=sCustomerType%>".substring(0,2);
        if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }

        var sReturn = RunMethod("CustomerManage","CheckRolesAction",sCustomerID+",<%=CurUser.getUserID()%>");
    	if (typeof(sReturn) == "undefined" || sReturn.length == 0){
        	return;
   		}
    	var sReturnValue = sReturn.split("@");
    	sReturnValue1 = sReturnValue[0];    //客户主办权
    	sReturnValue2 = sReturnValue[1];    //信息查看权
    	sReturnValue3 = sReturnValue[2];    //信息维护权
                        
        if(sReturnValue1 == "Y"){
			//在途业务检查
			sCount = RunMethod("BusinessManage","CustomerUnFinishedBiz",sCustomerID);
			if(sCount != "0"){
				alert("操作失败！该客户有在途申请，不能转换！");
				return;
			}
            
            sCustomerType = PopPage("/CustomerManage/ChangeCustomerTypeDialog.jsp?CustomerID="+sCustomerID+"&Type="+sType,"","dialogWidth=20;dialogHeight=8;resizable=no;scrollbars=no;status:no;maximize:no;help:no;");
            if(sCustomerType == "" || sCustomerType == "_CANCEL_" || typeof(sCustomerType) == "undefined") return;
            //参数说明：CustomerID,CustomerType,UserID,OrgID
            sReturn = RunMethod("CustomerManage","ChangeCustomerType",sCustomerID+","+sCustomerType+",<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>");
            if(sReturn == "1"){
                alert(getBusinessMessage('106'));//改变客户类型成功！"
                reloadSelf();
                return;
            }else{
                alert(getBusinessMessage('107'));//改变客户类型失败，请重新操作！
                return;
            }
        }else{
            alert(getBusinessMessage('249'));//你无权更改该客户的权限！
        }
    }
    
    /*~[Describe=集团客户关联搜索;InputParam=无;OutPutParam=无;]~*/
    function searchCustRela(){
        var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
        if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }

        var sReturn = RunMethod("CustomerManage","CheckRolesAction",sCustomerID+",<%=CurUser.getUserID()%>");
	    if (typeof(sReturn) == "undefined" || sReturn.length == 0){
	            return;
	    }
	    var sReturnValue = sReturn.split("@");
	    sReturnValue1 = sReturnValue[0];    //客户主办权
	    sReturnValue2 = sReturnValue[1];    //信息查看权
	    sReturnValue3 = sReturnValue[2];    //信息维护权
                        
        if(sReturnValue1 == "Y"){
            popComp("RelationSearchList","/CustomerManage/GroupManage/RelationSearchList.jsp","CustomerID="+sCustomerID,"","");
        }else{
			alert("你没有该客户主办权，不能进行搜索");
         	return;
        }
    }
    /*~[Describe=认定客户规模;InputParam=无;OutPutParam=无;]~*/
    function confirmScale(){
        var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
        if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }
        alert("待完成!");
    }

    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
    function viewAndEdit(){
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		var sCustomerType = "<%=sCustomerType%>";
		if (typeof(sCustomerID) == "undefined" || sCustomerID.length == 0){
		    alert(getHtmlMessage('1'));//请选择一条信息！
		    return;
		}

     	sReturn = RunMethod("CustomerManage","CheckRolesAction",sCustomerID+",<%=CurUser.getUserID()%>");
    	if (typeof(sReturn) == "undefined" || sReturn.length == 0){
        return;
    	}

	    var sReturnValue = sReturn.split("@");
	    sReturnValue1 = sReturnValue[0];
	    sReturnValue2 = sReturnValue[1];
	    sReturnValue3 = sReturnValue[2];
                        
		if(sReturnValue1 == "Y" || sReturnValue2 == "Y1" || sReturnValue3 == "Y2"){    
			openObject("Customer",sCustomerID,"001");
			reloadSelf();
		}else{
			//如果为集团客户管理岗，可以以只读形式查看
			<%if(bGroupAdmin){%>
				openObject("Customer",sCustomerID,"003");
			<%}else{%>
				alert(getBusinessMessage('115'));//对不起，你没有查看该客户的权限！
			<%}%>
		}
    }
    
    /*~[Describe=加入重点信息链接;InputParam=CustomerID,ObjectType=Customer;OutPutParam=无;]~*/
    function addUserDefine(){
        var sCustomerID = getItemValue(0,getRow(),"CustomerID");        
        if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }
        if(confirm(getBusinessMessage('114'))){ //把这个客户信息加入重点客户链接中吗?
            var sRvalue= PopPageAjax("/Common/ToolsB/AddUserDefineActionAjax.jsp?ObjectType=Customer&ObjectNo="+sCustomerID,"","");
            alert(getBusinessMessage(sRvalue));
        }
    }
        
    /*~[Describe=权限申请;InputParam=CustomerID,ObjectType=Customer;OutPutParam=无;]~*/          
    function ApplyRole(){
        //获得客户编号
        var sCustomerID = getItemValue(0,getRow(),"CustomerID");        
        if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
            alert(getHtmlMessage('1'));
            return;
        }
        //获得申请状态
        sApplyStatus = getItemValue(0,getRow(),"ApplyStatus");           
        if(sApplyStatus == "1"){
            alert(getBusinessMessage('116'));//已提交申请,不能再次提交！
            return;
        }
        //获得客户主办权、信息查看权、信息维护权、业务申办权
        var sBelongAttribute = getItemValue(0,getRow(),"BelongAttribute");        
        var sBelongAttribute1 = getItemValue(0,getRow(),"BelongAttribute1");
        var sBelongAttribute2 = getItemValue(0,getRow(),"BelongAttribute2");
        var sBelongAttribute3 = getItemValue(0,getRow(),"BelongAttribute3");        
        if(sBelongAttribute == "有" && sBelongAttribute1 == "有" && sBelongAttribute2 == "有" && sBelongAttribute3 == "有"){
            alert(getBusinessMessage('117'));//您已经拥有该客户的所有权限！
            return;
        }
        
        popComp("RoleApplyInfo","/CustomerManage/RoleApplyInfo.jsp","CustomerID="+sCustomerID+"&UserID=<%=CurUser.getUserID()%>&OrgID=<%=CurOrg.getOrgID()%>","");
        reloadSelf();
    }
    
    function viewCustomerInfo(){
        //获得客户编号
        var sCustomerID = getItemValue(0,getRow(),"CustomerID");        
        if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
            alert(getHtmlMessage('1'));
            return;
        }
        popComp("EntInfo","/CustomerManage/EntManage/EntInfo.jsp","CustomerID="+sCustomerID,"");
    }
    
    /*~[Describe=查询客户开户信息;InputParam=无;OutPutParam=无;]~*/
    function queryCusomerInfo(){
    	var sCustomerID = getItemValue(0,getRow(),"CustomerID");
    	var sCertID = getItemValue(0,getRow(),"CertID");
    	var sCertTypeName = getItemValue(0,getRow(),"CertTypeName");
        if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }
        
        var sReturn = PopPageAjax("/CustomerManage/QueryCustomerAjax.jsp?CertID="+sCertID,"","");
        if(typeof(sReturn) != "undefined"){
            sReturn=getSplitArray(sReturn);
            sStatus=sReturn[0];
            sMessage=sReturn[1];
            if(sStatus == "0"){
                sReturn = "操作成功！交易代码：" + "Q001" + "核心客户号为："+ sMessage + "更新数据库成功！";
            }else{
                sReturn = "核心提示："+"Q002"+" 交易失败！失败信息：" + sMessage;
            }
            alert(sReturn);
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
    /**
     * 
     * 代码选择框，传入一个代码编号，选择相应代码
     * 如果其它地方使用到选择代码比较频繁的情况，可考虑将此函数移至common.js
     * @author syang 2009/10/14
     * @param codeNo 代码编号
     * @param Caption 弹出对话框名称
     * @param defaultValue 选择框默认值
     * @param filterExpr 对ItemNo按照这个表达式进行匹配
     * @return 选择的ItemNo
     */
    function selectCode(codeNo,Caption,defaultValue,filterExpr){
        if(typeof(filterExpr) == "undefined"){
            filterExpr = "";
        }
        var codePage = "/CustomerManage/SelectCode.jsp";
        var sPara = "CodeNo="+codeNo
                        +"&Caption="+Caption
                        +"&DefaultValue="+defaultValue
                        +"&ItemNoExpr="+encodeURIComponent(filterExpr)  //这里需要作编码转换，否则形如&,%,+这类字符传输会有问题
                        ;
        style = "resizable=yes;dialogWidth=25;dialogHeight=10;center:yes;status:no;statusbar:no";
        sReturnValue = PopPage(codePage+"?"+sPara,"",style);
        return sReturnValue;
    }
    </script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
    AsOne.AsInit();
    init(); 
    var bHighlightFirst = true;//自动选中第一条记录
    my_load(2,0,'myiframe0');
</script>   
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>