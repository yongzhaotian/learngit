<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content:    ������ģ������
		Input Param:
                    ModelNo��    ģ����
                    GroupNo��   ����
                    ConditionNo���������
                    Status��״̬
	 */
	String PG_TITLE = "������ģ������"; // ��������ڱ��� <title> PG_TITLE </title>
	
	//����������	
	String sModelNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelNo"));
	String sGroupNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GroupNo"));
	String sConditionNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ConditionNo"));
	String sStatus =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Status"));
	if(sModelNo==null) sModelNo="";
	if(sGroupNo==null) sGroupNo="";

	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ClassifyModelInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	

	if (sModelNo.equals("")){
		//������
	   	doTemp.setRequired("ModelNo",true);
	}else{
		//ֻ����
		doTemp.setReadOnly("ModelNo",true);
	}

 	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sModelNo+","+sGroupNo+","+sConditionNo+","+sStatus);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","���沢����","�����޸Ĳ�����","saveRecordAndReturn()",sResourcesPath},
		{"true","","Button","���沢����","�����޸Ĳ�������һ����¼","saveRecordAndAdd()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function saveRecordAndReturn(){
		as_save("myiframe0","doReturn('Y');");
	}
    
	function saveRecordAndAdd(){
		as_save("myiframe0","newRecord()");
	}

    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"ModelNo");
		parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
    
	function newRecord(){
        sModelNo = getItemValue(0,getRow(),"ModelNo");
        OpenComp("ClassifyModelInfo","/Common/Configurator/ClassifyManage/ClassifyModelInfo.jsp","ModelNo="+sModelNo,"_self","");
	}

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			if ("<%=sModelNo%>" !=""){
				setItemValue(0,0,"ModelNo","<%=sModelNo%>");
            }
		    bIsInsert = true;
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>