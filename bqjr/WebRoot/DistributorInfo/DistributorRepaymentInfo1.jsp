<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --����Ǽ�
			δ�õ��������ֶ���ʱ���أ������Ҫ��չʾ������
		Input Param:
        	TypeNo��    --���ͱ��
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����Ǽ� "; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//���ҳ�����
	String sRelativeSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("relativeSerialNo"));	
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("customerID"));	
	if(sCustomerID==null) sCustomerID="";
	if(sRelativeSerialNo==null) sRelativeSerialNo="";
	String sSql="";
	ASResultSet rs = null;
	String sOpenBranch="",sRepaymentBank="",sRepaymentNo="";//�տ�
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String sTempletNo = "DistributorRepaymentInfo1";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	sSql="select getBankName(OpenBranch) as OpenBranch,getitemname('BankCode',bankName) as bankName,accountNo from account_information where accountType='02' and relativeSerialNo =:relativeSerialNo";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("relativeSerialNo",sCustomerID));
	if(rs.next()){
		sOpenBranch = DataConvert.toString(rs.getString("OpenBranch"));//  �տ��֧��
		sRepaymentBank = DataConvert.toString(rs.getString("bankName"));// �տ����
		sRepaymentNo = DataConvert.toString(rs.getString("accountNo"));//  �տ���ʺ�
								
		//����ֵת���ɿ��ַ���
		if(sOpenBranch == null) sOpenBranch = "";
		if(sRepaymentBank == null) sRepaymentBank = "";	
		if(sRepaymentNo == null) sRepaymentNo = "";	
	}
	rs.getStatement().close();
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//����HTMLDataWindow
	Vector vTemp =dwTemp.genHTMLDataWindow(sRelativeSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
%>

<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
			{"true","","Button","ȷ��","ȷ��","determine()",sResourcesPath},
			{"true","","Button","ȡ��","ȡ��","doCance()",sResourcesPath}
		    };
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
    var sCurTypeNo=""; //��¼��ǰ��ѡ���еĴ����
    var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function determine()
	{
		var sSerialNo=getItemValue(0,getRow(),"serialNo");
		RunMethod("ModifyNumber","GetModifyNumber","car_info,carStatus='030',relativeSerialNo='"+sSerialNo+"' and carStatus='020'"); //�޸ĳ�����Ϣ״̬
		var sCount=RunMethod("Unique","uniques","car_info,count(1),carStatus='020' and relativeSerialNo='"+sSerialNo+"'");  //�ж��Ƿ���״̬�Ƿ��޸ĳɹ�
		if(sCount=="0.0"){
			alert("�տ�ɹ�������");
			AsControl.OpenView("/DistributorInfo/DistributorRepaymentList1.jsp","","_self");
		}
	}
   
    function doCance(){
		AsControl.OpenView("/DistributorInfo/DistributorRepaymentList1.jsp","","_self");		
    }
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	
	function initRow(){
		//��ͬ������������󻹿�״̬�ĳ���������֮�� ��������
		var sLoadMoney=RunMethod("GetElement","GetElementValue","sum(carPrice),car_info,relativeSerialNo='<%=sRelativeSerialNo %>' and carStatus='020'");
		var sBondSum=getItemValue(0,getRow(),"bondSum"); 
		sLoadMoney=parseFloat(sLoadMoney);//��ͬ���ý��
		var sBalance=parseFloat(sBondSum)-sLoadMoney;   //��ͬ���
		setItemValue(0,0,"loadMoney",sLoadMoney );
		setItemValue(0,0,"nextPayDate", "<%=StringFunction.getToday()%>");
		setItemValue(0,0,"balance", sBalance);
		setItemValue(0, 0, "OpenBranch", "<%=sOpenBranch %>");
		setItemValue(0, 0, "RepaymentBank", "<%=sRepaymentBank %>");
		setItemValue(0, 0, "RepaymentNo", "<%=sRepaymentNo %>");
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
