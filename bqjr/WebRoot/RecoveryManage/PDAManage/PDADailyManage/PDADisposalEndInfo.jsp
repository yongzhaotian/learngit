<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:FSGong  2004.12.09
		Tester:
		Content:��ծ�ʲ������ܽ����
		Input Param:
			SerialNo����ծ�ʲ���ˮ��
			Type������
		Output param:	
			
		History Log: zywei 2005/09/07 �ؼ����
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ծ�ʲ���ֵ�����ܽ����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//����������
	String  sType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Type"));	
	//type=1 ��ζ�Ŵ�AppDisposingList��ִ�д����սᲢ�һ��ܡ�
	//type=2 ��ζ�Ŵ�PDADisposalEndList�в쿴����:��������button,����ֻ��
	//type=3 ��ζ�Ŵ�PDADisposalBookList�в쿴����:��������button,����ֻ��  2/3�Ĵ�����һ����,����Ϊ���պ����չ,���Ƿֿ�����.
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));	
	//����ֵת��Ϊ���ַ���
	if (sType == null) sType = "";	
	if(sSerialNo == null ) sSerialNo = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo ="PDADisposalEndInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	//�õ����ʲ��ı���/��/δ�����־,�Ѿ�����ʾ���
	String mySql = " select flag from ASSET_INFO where SerialNo = :SerialNo ";
	String myFlag = Sqlca.getString(new SqlObject(mySql).setParameter("SerialNo",sSerialNo));
	if(myFlag == null) myFlag = ""; 
	if(myFlag.equals("")) myFlag = "010";  //ȱʡ����		
	
	if (myFlag.equals("010")) //����
		doTemp.setVisible("EnterValue",true);		
	if (myFlag.equals("020"))  //����
		doTemp.setVisible("OutInitBalance",true);		

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //����DW��� 1:Grid 2:Freeform

	if (sType.equals("1"))  //ִ�д����ս�,��д
		dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	else					//�鿴������Ϣֻ��
		dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);	
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
   	  
	%>  	

<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
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
				{"false","","Button","�������","���������޸�","saveRecord()",sResourcesPath},
				{"true","","Button","�ر�","�رձ�ҳ��","goBack()",sResourcesPath}
			};
		//����sType�Ĳ�ͬ,�����Ƿ���ʾbutton
		if (sType.equals("1"))  sButtons[0][0]="true";
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function saveRecord()
	{
		var sType = "<%=sType%>";
		//����Ǵ�AppDisposingList�е��ã�����ִ�д����ܽᣬ���һ��ܡ������ط����ö��ǲ쿴���ܣ�Ҳ�����޸�������������
		if (sType == "1")  
		{
			if (confirm("��ȷ��ִ�д����ս���"))
			{
				beforeUpdate();
				as_save("myiframe0");		
			}
		}else   //���Ѿ��ս���ʲ������ܣ����ܻ��޸�������������
		{
			beforeUpdate();
			as_save("myiframe0");		
		}
	}	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">

	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		self.close();
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{				
		var sType = "<%=sType%>";
		if (sType == "1")  		
			setItemValue(0,0,"AssetStatus","04");//�����ս�
	}	

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		var sType = "<%=sType%>";
		if (sType == "1")  //�����ս�
			setItemValue(0,0,"PigeonholeDate","<%=StringFunction.getToday()%>");
		//ͳ�������Ϣ
		var sReturn = PopPageAjax("/RecoveryManage/PDAManage/PDADailyManage/PDADisposalEndStatisticsAjax.jsp?ObjectNo=<%=sSerialNo%>&ObjectType=ASSET_INFO","","");
		sReturn = sReturn.split("@");
		//ͳ���ۼƳ�����ս��
		setItemValue(0,0,"TotalRentValue",amarMoney(sReturn[0],2));
		//ͳ���ۼƳ��ۻ��ս��
		setItemValue(0,0,"TotalSaleValue",amarMoney(sReturn[1],2));
		//ͳ���ۼƷ���֧���ܶ�
		setItemValue(0,0,"TotalFeeValue",amarMoney(sReturn[2],2));
		//ͳ�ƴ�������
		setItemValue(0,0,"TotalNetValue",amarMoney(sReturn[3],2));
    }
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>

