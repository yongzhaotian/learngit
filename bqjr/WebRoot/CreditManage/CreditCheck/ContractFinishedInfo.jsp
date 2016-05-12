<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   --CChang 2003.8.25
		Tester:
		Content:    --��ͬ�ս� 			
		Input Param:
        	SerialNo��    --��ͬ��ˮ��
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ͬ�ֹ��ս���Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//-���sql���
		
	//����������	����ͬ��ˮ��
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sSerialNo == null) sSerialNo = "";

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String sHeaders[][]={
                        {"SerialNo","��ͬ��ˮ��"},
                        {"BusinessName","ҵ��Ʒ��"},
                        {"Balance","��ͬ���"},
                        {"FinishTypeName","�ս᷽ʽ"},
                        {"FinishDate","�ս�����"}
                        };                       

	sSql = " select SerialNo,BusinessType,getBusinessName(BusinessType) as BusinessName,Balance,"+
		   " FinishType,getItemName('FinishType',FinishType) as FinishTypeName,FinishDate "+
	  	   " from BUSINESS_CONTRACT " +
		   " where SerialNo = '"+sSerialNo+"' ";
	//ͨ��SQL��������ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sSql);
	//�����б��ͷ
	doTemp.setHeader(sHeaders); 
	//�Ա���и��¡����롢ɾ������ʱ��Ҫ������������   
	doTemp.UpdateTable = "BUSINESS_CONTRACT";
	doTemp.setKey("SerialNo",true);	
	//����ֻ������
	doTemp.setReadOnly("SerialNo,BusinessName,Balance",true);
	//�����ֶ��Ƿ�ɸ���
	doTemp.setUpdateable("BusinessName,FinishTypeName",false); 
	//�����ֶ��Ƿ�ɼ�  
	doTemp.setVisible("BusinessType,FinishType",false);
	//������������ʾֵ
	doTemp.setDDDWCode("FinishType","FinishType");
	//���ö����ʽ
	doTemp.setAlign("Balance","3");
	//���ü���ʽ
	doTemp.setCheckFormat("FinishDate","3");
	doTemp.setCheckFormat("Balance","2");
	//����ֵ����  
	doTemp.setType("Balance","number");
	doTemp.setHTMLStyle("FinishDate"," style={width:80px}");
	//�����ֶα�������
	doTemp.setRequired("FinishTypeName,FinishDate",true);
	
	//�����ս�����ѡ���
	doTemp.setUnit("FinishTypeName"," <input type=button value=.. onclick=parent.selectFinishedType()>");
			
	//����ASDataWindow����		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);	
	dwTemp.Style="2";//freeform��ʽ
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath}
		};
		
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">
	
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function saveRecord()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		as_save("myiframe0");				
	}
	
	/*~[Describe=ѡ���ս�����;InputParam=��;OutPutParam=��;]~*/
	function selectFinishedType()
	{
		sParaString = "CodeNo"+",FinishType";		
		setObjectValue("SelectCode",sParaString,"@FinishType@0@FinishTypeName@1",0,0,"");
		
	}
	
</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>