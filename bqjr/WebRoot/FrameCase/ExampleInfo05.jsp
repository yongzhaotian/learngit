<div>
	<pre>
	
	setHTMLStyle ���������һЩ���ӵ�����
	doTemp.setHTMLStyle("ApplySum"," onChange=\"javascript:parent.updateRemark()\" ");
	�����иı�applySum��ֵ������������remark��ֵ
	</pre>
</div>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: �Զ���html�¼�ʾ��ҳ��
	 */
	String PG_TITLE = "�Զ���html�¼�ʾ��ҳ��";
	//���ҳ�����
	String sExampleId =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ExampleId"));
	if(sExampleId==null) sExampleId="";

	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ExampleInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//setHTMLStyle ���������һЩ���ӵ�����
	doTemp.setHTMLStyle("ApplySum"," onChange=\"javascript:parent.updateRemark()\" ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
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

	function updateRemark() {
		var remarkStr = "�����:"+getItemValue(0,getRow(),"ApplySum");
		setItemValue(0,getRow(),"Remark",remarkStr);
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