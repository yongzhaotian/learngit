<%@ page contentType="text/html; charset=GBK"%>
<div>
	<pre>
	
	����ѡ���б�һ����¼���ᴥ������mySelectRow()
	function mySelectRow(){
		viewAndEdit();//ѡ��ĳ��¼�Զ�չ������
    	}
    </pre>
</div>
<%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: DW�����¼�ʾ��ҳ��
	 */
	String PG_TITLE = "DW�����¼�ʾ��ҳ��";

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "ExampleList"; //ģ����
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);
 
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function viewAndEdit(){
		var sExampleId=getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/FrameCase/ExampleInfo.jsp","ExampleId="+sExampleId+"&PrevUrl=/FrameCase/ExampleList04.jsp","_self","");
	}

	<%/*ѡ���б�һ����¼���ᴥ������mySelectRow()*/%>
	function mySelectRow(){
		viewAndEdit();//ѡ��ĳ��¼�Զ�չ������
    }

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>