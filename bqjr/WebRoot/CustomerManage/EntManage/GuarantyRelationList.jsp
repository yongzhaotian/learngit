<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View00;Describe=ע����;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-3
		Tester:
		Describe: ������ϵ��������;
		Input Param:
			CustomerID����ǰ�ͻ����
		Output Param:
			GuarantorID�������ͻ����

		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������ϵ��������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ϸ��Ϣ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "2000";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	String sSerialNo = "";
	String sOldCustomerID = "";
	String sCustomerName = "";
	String sGuarantorID = "";
	String sRelationName = "";
	String sBusinessSerialNo="";
	String sSql;
	ASResultSet rs=null;

	//Hash��ͬ�Ŀͻ��ţ�����ʾͬһ�ͻ��ڹ������ϵĶ�γ���
	Hashtable myHashtable = new Hashtable();
	//����ÿ������������ϵ������CustomerId���ϣ���һ������ֻ�б��ͻ�һ����¼
	Vector lastCustomer=new Vector();
	//����ÿ��Ҫ������ϵ��ϵ�Ŀͻ�������ÿ���ɼ���lastCustomer����
	String whereClause="";
	//������Σ��������ò�ξͽ���
	int iLayerNum=3;

	//����������	
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sGCustomerID=sCustomerID;
	//���ҳ�����	

	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/%>
	<%
	//ȡ�ÿͻ�����
	sSql="select CustomerName  from CUSTOMER_INFO where CustomerID=:CustomerID";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	if(rs.next()){
	   sCustomerName=DataConvert.toString(rs.getString("CustomerName"));
	}
	rs.getStatement().close(); 

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(sCustomerName+"��������ϵͼ��","_top");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//����Item�˵������
	int num=1;

	//���ӽ��ܵ������ṩ������Ŀ¼
	tviTemp.insertFolder("accept","root",sCustomerName+"�������ܵ�����ϵͼ��","","",1);
	tviTemp.insertFolder("offer", "root",sCustomerName+"�����ṩ������ϵͼ��","","",2);

	//���ܵ�����������
	myHashtable.put(sCustomerID,"0");
	lastCustomer.add(sCustomerID);
	for(int i=0;i<iLayerNum;i++){
		//���ɱ��������Ŀͻ�����
		for(int j=0;j<lastCustomer.size();j++){
			if (j==0) {
				whereClause="'"+lastCustomer.get(j)+"'";
			}else{
				whereClause+=",'"+lastCustomer.get(j)+"'";
			}
		}
		lastCustomer.removeAllElements();

		//���ɱ���������Sql���,�����߶����ͬ��������������
		sSql = "select BC.SerialNo as BusinessSerialNo,GC.SerialNo,BC.CustomerID,GC.GuarantorID,GC.GuarantorName,GC.GuarantyType,getItemName('GuarantyType',GC.GuarantyType) as GuarantyTypeName from GUARANTY_CONTRACT GC, BUSINESS_CONTRACT BC, CONTRACT_RELATIVE CR where BC.CustomerID in ("+whereClause+") and GC.ContractStatus='020' and GC.SerialNo=CR.ObjectNo and CR.ObjectType='GuarantyContract' and CR.SerialNo=BC.SerialNo order by BC.CustomerID,GC.GuarantorID";
		rs=Sqlca.getASResultSet(new SqlObject(sSql));
		while(rs.next()){
			sCustomerID = rs.getString("CustomerID");
			sBusinessSerialNo= rs.getString("BusinessSerialNo");

			//����Item�˵�����ţ������¿ͻ�����Ƿ�;;ɿͻ������ͬ
			if(sOldCustomerID.equals(sCustomerID)){
				num++;
			}else{
				num=1;
				sOldCustomerID=sCustomerID;
			}

			sGuarantorID = rs.getString("GuarantorID");
			if (sGuarantorID == null) sGuarantorID ="";
			if(!myHashtable.containsKey(sGuarantorID)){
				lastCustomer.add(sGuarantorID);
				myHashtable.put(sGuarantorID,"0");
			}else{
				String temp=(String)myHashtable.get(sGuarantorID);
				myHashtable.put(sGuarantorID,String.valueOf((Integer.parseInt(temp)+1)));
			}

			sCustomerName = rs.getString("GuarantorName");
			sSerialNo = rs.getString("SerialNo");
			sRelationName = rs.getString("GuarantyTypeName");

			//�����ǵ�һ����������IdΪaccept
			if(i==0){
				tviTemp.insertFolder(sBusinessSerialNo+"@"+sGuarantorID+"@"+myHashtable.get(sGuarantorID),"accept",sCustomerName+"��"+sRelationName,sSerialNo,"",num);
			}else if(i==iLayerNum-1){
				tviTemp.insertPage(sBusinessSerialNo+"@"+sGuarantorID+"@"+myHashtable.get(sGuarantorID),sCustomerID+"@0",sCustomerName+"��"+sRelationName,sSerialNo,"",num);
			}else{
				tviTemp.insertFolder(sBusinessSerialNo+"@"+sGuarantorID+"@"+myHashtable.get(sGuarantorID),sCustomerID+"@0",sCustomerName+"��"+sRelationName,sSerialNo,"",num);
			}
		}
		rs.getStatement().close();
	}

	//�ṩ������������
	sCustomerID=sGCustomerID;
	myHashtable.clear();
	myHashtable.put(sCustomerID,"0");
	lastCustomer.removeAllElements();
	lastCustomer.add(sCustomerID);
	for(int i=0;i<iLayerNum;i++){
		//���ɱ��������Ŀͻ�����
		for(int j=0;j<lastCustomer.size();j++){
			if (j==0) {
				whereClause="'"+lastCustomer.get(j)+"'";
			}else{
				whereClause+=",'"+lastCustomer.get(j)+"'";
			}
		}
		lastCustomer.removeAllElements();

		//���ɱ���������Sql���
		sSql = "select BC.SerialNo as BusinessSerialNo,GC.SerialNo,BC.CustomerID,GC.GuarantorID,getCustomerName(BC.CustomerID) as CustomerName,GC.GuarantyType,getItemName('GuarantyType',GC.GuarantyType) as GuarantyTypeName from GUARANTY_CONTRACT GC, BUSINESS_CONTRACT BC, CONTRACT_RELATIVE CR where GC.GuarantorID in ("+whereClause+") and GC.ContractStatus='020' and GC.SerialNo=CR.ObjectNo and CR.ObjectType='GuarantyContract' and CR.SerialNo=BC.SerialNo order by GC.GuarantorID, BC.CustomerID";
		rs=Sqlca.getASResultSet(new SqlObject(sSql));
		while(rs.next()){
			sCustomerID = rs.getString("GuarantorID");
			sBusinessSerialNo=rs.getString("BusinessSerialNo");

			//����Item�˵�����ţ������¿ͻ�����Ƿ�;;ɿͻ������ͬ
			if(sOldCustomerID.equals(sCustomerID)){
				num++;
			}else{
				num=1;
				sOldCustomerID=sCustomerID;
			}
			sGuarantorID = rs.getString("CustomerID");
			if (sGuarantorID == null) sGuarantorID ="";
			if(!myHashtable.containsKey(sGuarantorID)){
				lastCustomer.add(sGuarantorID);
				myHashtable.put(sGuarantorID,"0");
			}else{
				String temp=(String)myHashtable.get(sGuarantorID);
				myHashtable.put(sGuarantorID,String.valueOf((Integer.parseInt(temp)+1)));
			}

			sCustomerName = rs.getString("CustomerName");
			sSerialNo = rs.getString("SerialNo");
			sRelationName = rs.getString("GuarantyTypeName");

			//�����ǵ�һ����������IdΪoffer
			if(i==0){
				tviTemp.insertFolder(sBusinessSerialNo+"@"+sGuarantorID+"@@"+myHashtable.get(sGuarantorID),"offer",sCustomerName+"��"+sRelationName,sSerialNo,"",num);
			}else if(i==iLayerNum-1){
				tviTemp.insertPage(sBusinessSerialNo+"@"+sGuarantorID+"@@"+myHashtable.get(sGuarantorID),sCustomerID+"@@0",sCustomerName+"��"+sRelationName,sSerialNo,"",num);
			}else{
				tviTemp.insertFolder(sBusinessSerialNo+"@"+sGuarantorID+"@@"+myHashtable.get(sGuarantorID),sCustomerID+"@@0",sCustomerName+"��"+sRelationName,sSerialNo,"",num);
			}
		}
		rs.getStatement().close();
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��]~*/%>
	<%@include file="/Resources/CodeParts/View05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View05;]~*/%>
	<script type="text/javascript"> 
	//treeview����ѡ���¼�
	function TreeViewOnClick()
	{
		var sCurItemID = getCurTVItem().id;
		if (sCurItemID == "root" || sCurItemID == "accept" || sCurItemID == "offer")
			return;
		var sCurItemName = getCurTVItem().name;
		var sss = sCurItemID.split("@");
		var sBusinessSerialNo=sss[0];
		var sCustomerID=sss[1];		
		sSerialNo = getCurTVItem().value;		
		AsControl.PopPage("/CreditManage/CreditPutOut/ContractAssureMain.jsp","SerialNo="+sSerialNo+"&BusinessSerialNo="+sBusinessSerialNo,"");
	}

	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
	
	</script> 
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View06;Describe=��ҳ��װ��ʱִ��,��ʼ��]~*/%>
	<script type="text/javascript">
	startMenu();
	expandNode('root');
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>