<div>
	<pre>
	
 	DataWindowǰ��/�����¼�,List��Info��������:
	��һ��������"BeforeInsert","AfterInsert","BeforeDelete","AfterDelete","BeforeUpdate","AfterUpdate"
	�ڶ�������: !��������.������(����ֵ1,����ֵ2,...);
				 �෽������ֵ����ȡ��ǰDataWindow�ֶε�ֵ�������� #�ֶ��� ���룬
				 ������ʾȡ��ǰģ��ExampleIdֵ��Ϊ���������෽��
	Ӧ�ó���:��DataWindow����ɾ�ĺ�����������Ҫͬʱ�ɹ���ʧ��ʱ,��setEvent����.
	�����У�dwTemp.setEvent("AfterUpdate","!ʾ��.UpdateCustomerType(0110,#ExampleId)");//��DW�����,���¿ͻ�����,��������һ��������.
	</pre>
</div>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: DataWindow�¼�ʾ��ҳ��
	 */
	String PG_TITLE = "DataWindow�¼�ʾ��ҳ��";

	//���ҳ�����
	String sExampleId =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ExampleId"));
	if(sExampleId==null) sExampleId="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ExampleInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//DataWindowǰ��/�����¼�,List��Info��������:
	//��һ��������"BeforeInsert","AfterInsert","BeforeDelete","AfterDelete","BeforeUpdate","AfterUpdate"
	//�ڶ�������: !��������.������(����ֵ1,����ֵ2,...);
	//			 �෽������ֵ����ȡ��ǰDataWindow�ֶε�ֵ�������� #�ֶ��� ���룬
	//			 ������ʾȡ��ǰģ��ExampleIdֵ��Ϊ���������෽��
	//Ӧ�ó���:��DataWindow����ɾ�ĺ�����������Ҫͬʱ�ɹ���ʧ��ʱ,��setEvent����.
	dwTemp.setEvent("AfterUpdate","!ʾ��.UpdateCustomerType(0110,#ExampleId)");//��DW�����,���¿ͻ�����,��������һ��������.
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sExampleId);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		var serialNo = getSerialNo("EXAMPLE_INFO","ExampleId");// ��ȡ��ˮ��
		setItemValue(0,getRow(),"ExampleId",serialNo);
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
	}
	
	function initRow(){
		if(getRowCount(0)==0){
			as_add("myiframe0");
			bIsInsert = true;
		}
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>