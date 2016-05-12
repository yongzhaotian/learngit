<%@page import="javax.servlet.jsp.tagext.TryCatchFinally"%>
<%@page import="java.util.Date"%>
<%@page import="com.amarsoft.app.als.credit.model.CreditObjectAction"%>
<%@page import="com.amarsoft.app.als.product.PRDTreeViewNodeGenerator"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.app.bizmethod.*"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   jytian  2004-12-10
		Tester:
		Content: 业务申请主界面
		Input Param:
			 	SerialNo：业务申请流水号
		Output param:
			      
		History Log: 
				2005.08.09 王业罡 整理代码，去掉window.open打开方法,删除无用代码，整合逻辑
				2009.06.30 hwang 修改额度项下业务树图获取方式
				2011.06.03 qfang 增加流动资金贷款需求量测算模型
				2013.05.25 yzheng 修改树图节点生成方式, 针对CreditView
				2013.06.14 yzheng 合并CreditLineView
				2013.06.27 yzheng 合并InputCreditView
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "业务申请"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;基本信息&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View02;Describe=定义变量，获取参数;]~*/%>
	<%
// 	//定义变量
// 	String sBusinessType = "";
	String sCustomerID = "";
 	String sOccurType = "";  //发生类型—仅针对额度项下/单笔
// 	String sApplyType="";  //申请类型 —仅针对额度项下/单笔
// 	String sTable="";
 	String sCreditLineID = "";  //主综合授信编号—针对授信额度申请
 	int schemeType = 0;  //授信方案类型  0:授信额度申请 1: 额度项下/单笔授信申请
	
	//获得组件参数
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	//获取参数：一笔业务申请后，是否需要经过审批到合同阶段—针对额度项下/单笔授信
	String sApproveNeed =  CurConfig.getConfigure("ApproveNeed");
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View03;Describe=定义树图;]~*/%>
	<%
// 	//根据sObjectType的不同，得到不同的关联表名和模版名
// 	String sSql="select ObjectTable from OBJECTTYPE_CATALOG where ObjectType=:ObjectType";
// 	ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType",sObjectType));
// 	if(rs.next()){ 
// 		sTable=DataConvert.toString(rs.getString("ObjectTable"));
// 	}
// 	rs.getStatement().close(); 
	
// 	sSql="select CustomerID,OccurType,ApplyType,BusinessType from "+sTable+" where SerialNo=:SerialNo";
// 	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
// 	if(rs.next()){
// 		sCustomerID=DataConvert.toString(rs.getString("CustomerID"));
// 		sBusinessType=DataConvert.toString(rs.getString("BusinessType"));
// 		sOccurType=DataConvert.toString(rs.getString("OccurType"));  //针对额度项下/单笔
// 		sApplyType=DataConvert.toString(rs.getString("ApplyType"));  //针对额度项下/单笔
// 	}
// 	rs.getStatement().close(); 
	
	CreditObjectAction creditObjectAction = new CreditObjectAction(sObjectNo,sObjectType);
	sCustomerID = creditObjectAction.getCreditObjectBO().getAttribute("CustomerID").toString();
	sOccurType = creditObjectAction.getCreditObjectBO().getAttribute("OccurType").toString();
	
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"业务详情","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件
	
	//add by qfang 2011-06-03
	//String sSqlTreeView = "";
	//BizSort bs = new BizSort(Sqlca,sObjectType,sObjectNo,sApproveNeed,sBusinessType);
	
	/**added and modified by yzheng  2013/06/19**/
	PRDTreeViewNodeGenerator nodeGen = new PRDTreeViewNodeGenerator(sApproveNeed);
	String sSqlTreeView = nodeGen.generateSQLClause(Sqlca, sObjectType, sObjectNo);
	schemeType = nodeGen.getSchemeType();
	sCreditLineID = nodeGen.getCreditLineID();

	//添加控制条件：限制无预约现金贷查看“其他贷款信息”
	String sSubProductType = "";//产品子类型
	String contractstatus = "";
	String businesstype ="";
	String sSql="select SubProductType,contractstatus,businesstype from Business_Contract  where SerialNo=:SerialNo";
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
  	if(rs.next()){ 
  		sSubProductType=DataConvert.toString(rs.getString("SubProductType"));
  		contractstatus = DataConvert.toString(rs.getString("contractstatus"));
  		businesstype = DataConvert.toString(rs.getString("businesstype"));
 	}
 	rs.getStatement().close();  
 	if(sSubProductType==null) sSubProductType="";
 	//ARE.getLog().info("当前树图查询条件为："+sSqlTreeView);
 	if(!"2".equals(sSubProductType)){//非无预约现金贷
 		sSqlTreeView += " and PRD_NODECONFIG.NodeID <> '157'";
 		sSqlTreeView += " and PRD_NODECONFIG.NodeID <> '158'";
	} 
 	if(!"5".equals(sSubProductType)){//非学生贷
 		sSqlTreeView += " and nvl(PRD_NODECONFIG.NodeID,'999') <> '510'";
	} 


 	sSqlTreeView += " and PRD_NODECONFIG.NodeID not like '3%'";  //屏蔽小企业贷树图  add by hangcheng
	//System.out.println("@@@@@:" + sSqlTreeView);
	
	//新需求还款计划修正教育贷系列产品 合同  合同与可以做还款计划表修正的产品进行匹配条件，CCS-818 还款计划修正功能  add by jiangyuanlin
	if(CurUser.hasRole("1801")){//还款专员角色才能执行以下操作 2015、06、11修改
		 String mySql="select pt.revision_payment_schedule_flag  as revisionFlag   from business_type bt, product_businessType pb, product_types pt  where bt.typeNo = pb.bustypeid and pb.productseriesid = pt.productid  and bt.typeno=:typeno";
			ASResultSet myrs = Sqlca.getASResultSet(new SqlObject(mySql).setParameter("typeno",businesstype));
		  	String revisionFlag = "";
			if(myrs.next()){ 
				revisionFlag=DataConvert.toString(myrs.getString("revisionFlag"));
		 	}
			myrs.getStatement().close();  
		 	if("050".equals(contractstatus) && "1".equals(revisionFlag)){//还款计划修正要求已注册 合同
		 		String loanSerialNo = Sqlca.getString(new SqlObject("select serialno from acct_loan where putoutno =:ObjectNo").setParameter("ObjectNo", sObjectNo));
		 		String acc_Sql = "select min(aps.paydate) as paydate from acct_payment_schedule aps  where aps.seqid='1' and((aps.objectno=:ObjectNo and aps.objecttype='jbo.app.ACCT_LOAN') or (aps.relativeobjectno=:ObjectNo and aps.relativeobjecttype='jbo.app.ACCT_LOAN'))";
		 		ASResultSet acc_rs = Sqlca.getASResultSet(new SqlObject(acc_Sql).setParameter("ObjectNo",loanSerialNo));
		 		 long between_days =0;
		 		String d =SystemConfig.getBusinessDate();
		 		if(acc_rs.next()){ 
		 			String date = DataConvert.toString(acc_rs.getString("paydate"));
		 			String sdate = SystemConfig.getBusinessDate();
		 			if(!StringUtils.isEmpty(date)){
			 			try{
			 				Date payDate = null;
			 		    	Date sysdate= null ;
				 			SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");  
				 			payDate =sdf.parse(date); 
				 			sysdate = sdf.parse(sdate);
				 			between_days  = (payDate.getTime()-sysdate.getTime())/(24*60*60*1000);
			 			}catch(Exception e){
			 				
			 			}
			 	        
		 			}
		 	       
		 		}
		 		acc_rs.getStatement().close();  
		 		if(between_days<7){
		 		  sSqlTreeView += " and PRD_NODECONFIG.NodeID <> '135'";
		 		}
		 	}else{
		 		sSqlTreeView += " and PRD_NODECONFIG.NodeID <> '135'";
		 	}
	}else{
		sSqlTreeView += " and PRD_NODECONFIG.NodeID <> '135'";
	}
   
 	// CCS-818 	还款计划修正功能 END
 	
	//参数从左至右依次为: ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
	tviTemp.initWithSql("PRD_NODEINFO.NodeID as NodeID","PRD_NODECONFIG.NodeName as NodeName","ItemDescribe","","",sSqlTreeView,"Order By PRD_NODEINFO.SortNo",Sqlca);
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=View04;Describe=主体页面]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View05;]~*/%>
	<script type="text/javascript"> 
	function openChildComp(sCompID,sURL,sParameterString){
		//alert(sParameterString);
		sParaStringTmp = "";
		
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";
		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		sParaStringTmp=sParaStringTmp.replace("#ObjectType","<%=sObjectType%>");
		sParaStringTmp=sParaStringTmp.replace("#ObjectNo","<%=sObjectNo%>");
		sParaStringTmp=sParaStringTmp.replace("#CustomerID","<%=sCustomerID%>");
		
		if (<%=schemeType%> == 0){  //授信额度申请
			sParaStringTmp=sParaStringTmp.replace("#ParentLineID","<%=sCreditLineID%>");
			//sParaStringTmp=sParaStringTmp.replace("#ModelType","030");
		}
		else if(<%=schemeType%> == 1){  //额度项下/单笔授信申请
			sParaStringTmp=sParaStringTmp.replace("#OccurType", "<%=sOccurType%>");
		}
		//alert(sURL);
		//alert(sParaStringTmp);
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}

	//treeview单击选中事件
	function TreeViewOnClick(){
		var sSerialNo = getCurTVItem().id;
		if (sSerialNo == "root")	return;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe0=sCurItemDescribe[0];
		sCurItemDescribe1=sCurItemDescribe[1];
		sCurItemDescribe2=sCurItemDescribe[2];
		
		if(sCurItemDescribe1 == "GuarantyList"){
			openChildComp("GuarantyList","/CreditManage/GuarantyManage/GuarantyList.jsp","ObjectType=<%=sObjectType%>&WhereType=Business_Guaranty&ObjectNo=<%=sObjectNo%>");
			setTitle(getCurTVItem().name);
		}else if(sCurItemDescribe1 == "LiquidForcast"){
			openChildComp("EvaluateList","/Common/Evaluate/EvaluateList.jsp","ModelType=070&ObjectType=Customer&ObjectNo=<%=sCustomerID%>&CustomerID=<%=sCustomerID%>");
		}else if(sCurItemDescribe0 != "null"){
			openChildComp(sCurItemDescribe1,sCurItemDescribe0,"ComponentName="+sCurItemName+"&AccountType=ALL&"+sCurItemDescribe2);
			setTitle(getCurTVItem().name);
		}
	}
	
	function startMenu() {
		<%=tviTemp.generateHTMLTreeView()%>
	}
	</script> 
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View06;Describe=在页面装载时执行,初始化]~*/%>
	<script type="text/javascript">
	myleft.width=170;
	startMenu();
	expandNode('root');
	expandNode('01');
	expandNode('040');
	expandNode('041');	
	selectItem('010');
	setTitle("基本信息");
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
