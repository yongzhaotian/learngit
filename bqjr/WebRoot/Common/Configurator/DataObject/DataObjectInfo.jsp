<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: ���ݶ���Ŀ¼����
		Input Param:
                    DoNo��      ���ݶ�����
	 */
	String PG_TITLE = "���ݶ���Ŀ¼����"; // ��������ڱ��� <title> PG_TITLE </title>
	
	//����������	
	String sDoNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DoNo"));
	if(sDoNo==null) sDoNo="";
	
	//ͨ����ʾģ�����ASDataObject����doTemp
 	String sTempletNo = "DataObjectInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	if (sDoNo.equals("") || sDoNo.equals("null")) {
 	  	doTemp.setRequired("DONO",true);
		doTemp.setReadOnly("DONO",false);
	}else{
		doTemp.setRequired("DONO",false);
		doTemp.setReadOnly("DONO",true);
	}
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//��������¼�
	dwTemp.setEvent("AfterUpdate","!Configurator.UpdateDOUpdateTime("+StringFunction.getTodayNow()+","+CurUser.getUserID()+","+sDoNo+")");

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sDoNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","�����޸�","saveRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function saveRecord(){
	    as_save("myiframe0","");
	}
    
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			setItemValue(0,0,"DOCLASS","10");
			setItemValue(0,0,"ISINUSE","1");
            
			bIsInsert = true;
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>