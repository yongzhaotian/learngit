<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: sjchuan 2009-10-20
		Tester:
		Describe: ������Ϣ�е�Ʊ����Ϣ�б�
		Input Param:
		Output Param:		
		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ʒ���� "; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//���ҳ�����

	//����������
	String sBusinessType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BusinessType"));
    if(sBusinessType == null) sBusinessType = ""; 
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>

<%

	String sSql1="";
	String sProductcategory="";
	String[] sProductcategorys;
	
	StringBuffer sb=new StringBuffer();
	ASResultSet rs =null;
	SqlObject so;
	//������ϼ���ת��������������ˮ�ţ��ڱ�RESERVE_COMPTOSINȡ�û���·ݺͽ�ݺ�
	sSql1 = "select productcategory from business_type where typeno=:BusinessType";
	so = new SqlObject(sSql1).setParameter("BusinessType", sBusinessType);
	rs = Sqlca.getASResultSet(so);
	if (rs.next()){
		sProductcategory = rs.getString("productcategory");
		sProductcategorys=sProductcategory.split(",");
		for(int i=0;i<sProductcategorys.length;i++){
			sb.append("'");
			sb.append(sProductcategorys[i]);
			sb.append("'");
			sb.append(",");
		}
	}
	rs.getStatement().close();
	sProductcategory=sb.toString().substring(0, sb.toString().lastIndexOf(","));    


	String sHeaders[][] = {	{"productcategoryid","������"},
							{"productcategoryname","��������"}
	                       }; 
	String sSql = " select productcategoryid,productcategoryname from product_category where "
			   +"productcategoryid in ("+sProductcategory+")";

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.setKey("SerialNo,PutoutNo",true);	 //Ϊ�����ɾ��
//	doTemp.multiSelectionEnabled=true;
	
	//���ý��Ϊ��λһ������
//	doTemp.setType("BillSum","Number");

	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
//	doTemp.setCheckFormat("BillSum","2");
	
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
//	doTemp.setAlign("BillSum","3");
	
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
    
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
		{"true","","Button","ȷ��","ȷ��","doSubmit()",sResourcesPath},
		{"true","","Button","ȡ�� ","ȡ��","doNo()",sResourcesPath},
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/CreditManage/CreditApply/BillInfo.jsp","_self","");
	}

	function doSubmit(){
		var sProductcategoryid = getItemValue(0,getRow(),"productcategoryid");
		var sProductcategoryname = getItemValue(0,getRow(),"productcategoryname");
		if(typeof(sProductcategoryid) == "undefined" || sProductcategoryid == "")
		{
			alert("��ѡ��һ��!");
			return;
		}
		top.returnValue=sProductcategoryid+"@"+sProductcategoryname;
		top.close();
	}
	
	function doNo(){
		top.returnValue = "_CANCEL_";
		top.close();
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>
