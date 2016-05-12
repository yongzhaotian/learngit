<%@page import="javax.servlet.jsp.tagext.TryCatchFinally"%>
<%@page import="java.util.Date"%>
<%@page import="com.amarsoft.app.als.credit.model.CreditObjectAction"%>
<%@page import="com.amarsoft.app.als.product.PRDTreeViewNodeGenerator"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.app.bizmethod.*"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   jytian  2004-12-10
		Tester:
		Content: ҵ������������
		Input Param:
			 	SerialNo��ҵ��������ˮ��
		Output param:
			      
		History Log: 
				2005.08.09 ��ҵ� ������룬ȥ��window.open�򿪷���,ɾ�����ô��룬�����߼�
				2009.06.30 hwang �޸Ķ������ҵ����ͼ��ȡ��ʽ
				2011.06.03 qfang ���������ʽ��������������ģ��
				2013.05.25 yzheng �޸���ͼ�ڵ����ɷ�ʽ, ���CreditView
				2013.06.14 yzheng �ϲ�CreditLineView
				2013.06.27 yzheng �ϲ�InputCreditView
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ҵ������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;������Ϣ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/%>
	<%
// 	//�������
// 	String sBusinessType = "";
	String sCustomerID = "";
 	String sOccurType = "";  //�������͡�����Զ������/����
// 	String sApplyType="";  //�������� ������Զ������/����
// 	String sTable="";
 	String sCreditLineID = "";  //���ۺ����ű�š�������Ŷ������
 	int schemeType = 0;  //���ŷ�������  0:���Ŷ������ 1: �������/������������
	
	//����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	//��ȡ������һ��ҵ��������Ƿ���Ҫ������������ͬ�׶Ρ���Զ������/��������
	String sApproveNeed =  CurConfig.getConfigure("ApproveNeed");
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/%>
	<%
// 	//����sObjectType�Ĳ�ͬ���õ���ͬ�Ĺ���������ģ����
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
// 		sOccurType=DataConvert.toString(rs.getString("OccurType"));  //��Զ������/����
// 		sApplyType=DataConvert.toString(rs.getString("ApplyType"));  //��Զ������/����
// 	}
// 	rs.getStatement().close(); 
	
	CreditObjectAction creditObjectAction = new CreditObjectAction(sObjectNo,sObjectType);
	sCustomerID = creditObjectAction.getCreditObjectBO().getAttribute("CustomerID").toString();
	sOccurType = creditObjectAction.getCreditObjectBO().getAttribute("OccurType").toString();
	
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"ҵ������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�
	
	//add by qfang 2011-06-03
	//String sSqlTreeView = "";
	//BizSort bs = new BizSort(Sqlca,sObjectType,sObjectNo,sApproveNeed,sBusinessType);
	
	/**added and modified by yzheng  2013/06/19**/
	PRDTreeViewNodeGenerator nodeGen = new PRDTreeViewNodeGenerator(sApproveNeed);
	String sSqlTreeView = nodeGen.generateSQLClause(Sqlca, sObjectType, sObjectNo);
	schemeType = nodeGen.getSchemeType();
	sCreditLineID = nodeGen.getCreditLineID();

	//��ӿ���������������ԤԼ�ֽ���鿴������������Ϣ��
	String sSubProductType = "";//��Ʒ������
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
 	//ARE.getLog().info("��ǰ��ͼ��ѯ����Ϊ��"+sSqlTreeView);
 	if(!"2".equals(sSubProductType)){//����ԤԼ�ֽ��
 		sSqlTreeView += " and PRD_NODECONFIG.NodeID <> '157'";
 		sSqlTreeView += " and PRD_NODECONFIG.NodeID <> '158'";
	} 
 	if(!"5".equals(sSubProductType)){//��ѧ����
 		sSqlTreeView += " and nvl(PRD_NODECONFIG.NodeID,'999') <> '510'";
	} 


 	sSqlTreeView += " and PRD_NODECONFIG.NodeID not like '3%'";  //����С��ҵ����ͼ  add by hangcheng
	//System.out.println("@@@@@:" + sSqlTreeView);
	
	//�����󻹿�ƻ�����������ϵ�в�Ʒ ��ͬ  ��ͬ�����������ƻ��������Ĳ�Ʒ����ƥ��������CCS-818 ����ƻ���������  add by jiangyuanlin
	if(CurUser.hasRole("1801")){//����רԱ��ɫ����ִ�����²��� 2015��06��11�޸�
		 String mySql="select pt.revision_payment_schedule_flag  as revisionFlag   from business_type bt, product_businessType pb, product_types pt  where bt.typeNo = pb.bustypeid and pb.productseriesid = pt.productid  and bt.typeno=:typeno";
			ASResultSet myrs = Sqlca.getASResultSet(new SqlObject(mySql).setParameter("typeno",businesstype));
		  	String revisionFlag = "";
			if(myrs.next()){ 
				revisionFlag=DataConvert.toString(myrs.getString("revisionFlag"));
		 	}
			myrs.getStatement().close();  
		 	if("050".equals(contractstatus) && "1".equals(revisionFlag)){//����ƻ�����Ҫ����ע�� ��ͬ
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
   
 	// CCS-818 	����ƻ��������� END
 	
	//����������������Ϊ: ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
	tviTemp.initWithSql("PRD_NODEINFO.NodeID as NodeID","PRD_NODECONFIG.NodeName as NodeName","ItemDescribe","","",sSqlTreeView,"Order By PRD_NODEINFO.SortNo",Sqlca);
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View05;]~*/%>
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
		
		if (<%=schemeType%> == 0){  //���Ŷ������
			sParaStringTmp=sParaStringTmp.replace("#ParentLineID","<%=sCreditLineID%>");
			//sParaStringTmp=sParaStringTmp.replace("#ModelType","030");
		}
		else if(<%=schemeType%> == 1){  //�������/������������
			sParaStringTmp=sParaStringTmp.replace("#OccurType", "<%=sOccurType%>");
		}
		//alert(sURL);
		//alert(sParaStringTmp);
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}

	//treeview����ѡ���¼�
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


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View06;Describe=��ҳ��װ��ʱִ��,��ʼ��]~*/%>
	<script type="text/javascript">
	myleft.width=170;
	startMenu();
	expandNode('root');
	expandNode('01');
	expandNode('040');
	expandNode('041');	
	selectItem('010');
	setTitle("������Ϣ");
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
