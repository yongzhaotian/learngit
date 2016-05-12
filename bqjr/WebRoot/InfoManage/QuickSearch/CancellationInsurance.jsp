<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "退保申请"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//获得组件参数	：合同号
	String SerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("sSerialNo"));
	
	//将空值转化成空字符串
	if(SerialNo == null) SerialNo = "";	
	
    //add  wlq  20140905  通过门店编号所在城市查询到对应城市所在的保险公司编号
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "CancellationInsuranceInfo";
	
	//根据模板编号设置数据对象	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//定义变量：查询结果集
	ASResultSet rs = null;
	String sCreditId = "";
	String sCreditPerson = "";
	//设置必输背景色
	//doTemp.setHTMLStyle("CustomerType","style={background=\"#EEEEff\"} ");
	//当客户类型发生改变时，系统自动清空已录入的信息
	//doTemp.appendHTMLStyle("CustomerType"," onClick=\"javascript:parent.clearData()\" ");
	doTemp.WhereClause+=" and PUTOUTNO="+SerialNo;
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(SerialNo);
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
			{"true","","Button","确认","确认退保申请","doCreation()",sResourcesPath},
			{"true","","Button","取消","取消退保申请","doCancel()",sResourcesPath}	
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">


	

		   
    /*~[Describe=取消新增授信方案;InputParam=无;OutPutParam=取消标志;]~*/
	function doCancel()
	{		
		top.returnValue = "_CANCEL_";
		top.close();
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script type="text/javascript">

	/*~[Describe=新增一笔授信申请记录;InputParam=无;OutPutParam=无;]~*/
	function doCreation(){
		var  status = getItemValue(0,0,"status");//民安保险状态
		var PUTOUTNO = getItemValue(0,0,"PUTOUTNO");	
		var r_type = getItemValue(0,0,"R_TYPE");	
		if("1"==r_type){
			if(status =='2'){
			var updateBy = "<%=CurUser.getUserID()%>";
			var str=	RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateMinanSerialNo", "updateMinanSerialNo","serialNo="+PUTOUTNO+",updateBy="+updateBy+",r_type="+r_type);
				if(str=="S"){
					alert("退保申请成功！");
					top.close();
				}
			}else{
				alert("该合同不能做退保申请");
			}
			
		}else{
			if(status =='1' || status =='5'){	//退保失败可以继续申请.'1','投保','2','投保失败','3','退保申请','4','退保成功','5','退保失败','6','审批通过待跑批'
				if(!confirm("申请成功后将无法取消，是否确认申请？")){
					return;
				}
				//update by huanghui 20151231 PRM-728 取消退保审批和临时代扣审批的功能
				var updateBy = "<%=CurUser.getUserID()%>";
				/* var str=	 */RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateMinanSerialNo", "updateMinanSerialNo","serialNo="+PUTOUTNO+",updateBy="+updateBy+",r_type="+r_type);
					/* if(str=="S"){
						alert("退保申请成功！");
						top.close();
					}  */
				//保单号
		    	policynos =getItemValue(0,getRow(),"policyno");
		    	if(policynos){
					var sUserID = "<%=CurUser.getUserID()%>";
					ShowMessage("退保一条记录大约3秒，请等待....",true,false);
					var str=	RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateMinanSerialNo", "httpPostPolicynoRealTime","policyno="+policynos+",updateBy="+sUserID);
					hideMessage();
					if(str=="S"){
							alert("退保数据与民安数据对接成功！");
					}else{
						alert(str);
					}
					top.close();	
				}
			}else{
				alert("该合同不能做退保申请");
			}
		}
	}

							


	
	
	</script>
	

<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>