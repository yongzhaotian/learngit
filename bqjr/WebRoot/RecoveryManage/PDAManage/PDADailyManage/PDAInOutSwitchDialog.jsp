<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   FSGong  2005.01.28
		Content: ��ծ�ʲ������⻥��ʱ,�����޸����˼�ֵ/��Ŀ�����ߵ�ծʱ�������/��ǰ�������.
					  Ŀǰֻ�������������������޸�,�������Ǳ��������ʱ���.
		Input Param:
			        SerialNo����ծ�ʲ���ˮ��
					InOut��ת��������־.
		Output param:		
		History Log: 
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ծ�ʲ�������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//�������������ʲ���ˮ�š�ת��������־��
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sInOut = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("InOut"));
	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null ) sSerialNo = "";	
	if(sInOut == null ) sInOut = "";	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "PDAInOutSwitchDialog";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//���ݱ���/����/δ�����־,���������ʾAssetBalance,EnterValue,OutInitBalance,OutNowBalance,InAccontDate�ֶ�.
	if (sInOut.equals("In"))  
		doTemp.setVisible("AssetBalance,EnterValue,InAccontDate",true);		
	else
		doTemp.setVisible("OutInitBalance,OutNowBalance",true);		

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д	
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);	
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
 	//out.println(sSerialNo);
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
			{"false","","Button","ת�����","ȷ��ת�����","InTable()",sResourcesPath},
			{"false","","Button","ת�����","ȷ��ת�����","OutTable()",sResourcesPath}
		};
	if (sInOut.equals("In")) 
		sButtons[0][0]="true";
	else
		sButtons[1][0]="true";
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	
	//---------------------���尴ť�¼�------------------------------------
	
	/*~[Describe=ת����;InputParam=�����¼�;OutPutParam=��;]~*/
	function InTable()
	{
		if(confirm(getBusinessMessage("766"))) //��ȷ�ϸõ�ծ�ʲ�ת������
		{
			//����������ڱ�־
			var sSerialNo="<%=sSerialNo%>";
			var sFlag = "010";
			var sAssetStatus = "03";
			sReturnValue = RunMethod("PublicMethod","UpdateColValue","String@Flag@"+sFlag+"@String@AssetStatus@"+sAssetStatus+",ASSET_INFO,String@SerialNo@"+sSerialNo);
			if(sReturnValue == "TRUE")
			{
				alert(getBusinessMessage("767"));//�õ�ծ�ʲ�ת���ڳɹ���
				saveRecord();
				self.close();
			}else
			{
				alert(getBusinessMessage("768")); //�õ�ծ�ʲ�ת����ʧ�ܣ������²�����
				return;
			}			
		}
	}
	
	/*~[Describe=ת����;InputParam=�����¼�;OutPutParam=��;]~*/
	function OutTable()
	{
		if(confirm(getBusinessMessage("769"))) //��ȷ�ϸõ�ծ�ʲ�ת������
		{
			//������������־
			var sSerialNo="<%=sSerialNo%>";
			var sFlag = "020";
			var sAssetStatus = "03";
			sReturnValue = RunMethod("PublicMethod","UpdateColValue","String@Flag@"+sFlag+"@String@AssetStatus@"+sAssetStatus+",ASSET_INFO,String@SerialNo@"+sSerialNo);
			if(sReturnValue == "TRUE")
			{
				alert(getBusinessMessage("770"));//�õ�ծ�ʲ�ת����ɹ���
				saveRecord();
				self.close();
			}else
			{
				alert(getBusinessMessage("771")); //�õ�ծ�ʲ�ת����ʧ�ܣ������²�����
				return;
			}
		}
	}
	
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		beforeUpdate();
		as_save("myiframe0");		
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">

	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");		
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
    }
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	top.returnValue = "false";
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>