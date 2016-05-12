<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   hxli 2005.8.11
		Content: ��ծ�ʲ�������ϢPDABasicInfo.jsp
					  �ʲ���ˮ����ѡ���ʲ����ͶԻ������Ѿ��������������ﲻ�������������⡣
		Input Param:
				SerialNo:��ծ�ʲ���ˮ��
				AssetType����ծ�ʲ�����				
				ObjectType����������						
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
	String sTempletNo ="";
			
	//����������(��ծ�ʲ���ˮ�š���ծ�ʲ����͡���������)
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sAssetType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AssetType"));//�ʲ����ͣ������޷���λģ��
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sAssetStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AssetStatus"));
	//out.println(sSerialNo);
	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null) sSerialNo = "";
	if(sAssetType == null) sAssetType = "";	
	if(sObjectType == null) sObjectType = "";
	if(sAssetStatus == null ) sAssetStatus = "";

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	if (sAssetType.equals("01"))
		sTempletNo="PDAHouseInfo"; //������
	if (sAssetType.equals("02"))
		sTempletNo="PDASoilInfo"; //������
	if (sAssetType.equals("03"))
		sTempletNo="PDAVehicleInfo"; //��ͨ���乤����
	if (sAssetType.equals("04"))
		sTempletNo="PDAMachineryInfo"; //�����豸��
	if (sAssetType.equals("05"))
		sTempletNo="PDAStockInfo"; //�м�֤ȯ��
	if (sAssetType.equals("06"))
		sTempletNo="PDAProceedsInfo"; //����Ȩ��
	if (sAssetType.equals("07"))
		sTempletNo="PDAMaterialsInfo"; //������
	if (sAssetType.equals("08"))
		sTempletNo="PDAOthersInfo"; //������
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//��ø��ʲ��ı���/����/δ�����־,�Ѿ�����ʾ���
	String mySql = " select flag from ASSET_INFO Where  SerialNo =:SerialNo ";
	String myFlag = Sqlca.getString(new SqlObject(mySql).setParameter("SerialNo",sSerialNo));
	if (myFlag == null) myFlag = "";

	if (myFlag.equals(""))   //δ����,�����
		doTemp.setVisible("AssetBalance,EnterValue,OutInitBalance,OutNowBalance,InAccontDate,TransferStatus,NotTransferStatus,NotTransferReasons",false);		
	if (myFlag.equals("010")) //����
	{
		doTemp.setVisible("OutInitBalance,OutNowBalance",false);		
		doTemp.setUpdateable("AssetBalance,EnterValue",true); 
	}
	if (myFlag.equals("020"))  //����:û����������.
	{
		doTemp.setVisible("AssetBalance,EnterValue,InAccontDate",false);		
		doTemp.setUpdateable("OutInitBalance,OutNowBalance",true); 
	}
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д	
		
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
			{sAssetStatus.equals("04")?"false":"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	
	//---------------------���尴ť�¼�------------------------------------

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
	function beforeUpdate(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=���ڱȽ�;InputParam=date1,data2,rule;OutPutParam=��;]~*/
	function compareDate(date1,date2,rule){
		if(typeof(date1) != "undefined" && date1 != "" && typeof(date2) != "undefined" && date2 != ""){
			if(rule == "1"){
				if(date1 > date2) return true;
			}
			if(rule == "2"){
				if(date1 >= date2) return true;
			}
			if(rule == "3"){
				if(date1 < date2) return true;
			}
			if(rule == "4"){
				if(date1 <= date2) return true;
			}
		}
		return false;
	}
	
	
	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');	
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>