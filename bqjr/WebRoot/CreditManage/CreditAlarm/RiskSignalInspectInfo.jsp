<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: Ԥ���źż�鱨����Ϣ_info
		Input Param:
			  ObjectType:��������
			  ObjectNo��������   
	 */
	String PG_TITLE = "Ԥ���źż�鱨����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>

	//�������
	String sSql = "";

	//���ҳ�����	
	String sObjectType =  CurPage.getParameter("ObjectType");
	String sObjectNo =  CurPage.getParameter("ObjectNo");
	//����ֵת��Ϊ���ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	//	��ȡԤ���źż�鱨����ˮ��
	sSql ="select SerialNo from INSPECT_INFO where ObjectType =:ObjectType and ObjectNo =:ObjectNo";
	String sSerialNo = Sqlca.getString(new SqlObject(sSql).setParameter("ObjectType",sObjectType).setParameter("ObjectNo",sObjectNo));
	if(sSerialNo == null) sSerialNo = "";
	
	String[][] sHeaders = {
							{"Opinion1","ҵ��"},
							{"Opinion2","��״/����"},
							{"Opinion3","�����ж����"},
							{"Opinion4","������"},							
							{"Remark","��ע"},
							{"InspectOrgName","������"},
							{"InspectUserName","�����"},
							{"InspectDate","���ʱ��"},
							{"UpdateDate","����ʱ��"}
						};
		
	sSql =  " select SerialNo,ObjectType,ObjectNo,InspectType,UptoDate, "+
			" Opinion1,Opinion2,Opinion3,Opinion4,Remark,InspectOrgID, "+
			" getOrgName(InspectOrgID) as InspectOrgName,InspectUserID, "+
			" getUserName(InspectUserID) as InspectUserName,InspectDate, "+
			" InputOrgID,InputUserID,InputDate,FinishDate "+
			" from INSPECT_INFO "+
			" where ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sObjectNo+"' ";
			
	//ͨ��SQL������ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable="INSPECT_INFO";
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);

	//����ֻ������
	doTemp.setReadOnly("Opinion1,Opinion2,Opinion3,Opinion4,Remark,InspectOrgName,InspectUserName,InspectDate",true);
	if(sSerialNo.equals(""))doTemp.setReadOnly("Opinion1,Opinion2,Opinion3,Opinion4,Remark",false);
	//���ñ�������
	doTemp.setRequired("Opinion1,Opinion2",true);
	//���ò��ɼ�����
	doTemp.setVisible("SerialNo,ObjectType,ObjectNo,InspectType,UptoDate,InspectOrgID",false);
	doTemp.setVisible("InspectUserID,InputOrgID,InputUserID,InputDate,FinishDate",false);
	//���ò��ɸ���
	doTemp.setUpdateable("InspectOrgName,InspectUserName",false);
	//���ø�ʽ
	doTemp.setHTMLStyle("InspectUserName,InspectDate,UpdateDate"," style={width:80px;} ");
	doTemp.setHTMLStyle("Opinion1,Opinion2,Opinion3,Opinion4,Remark"," style={height:100px;width:400px;overflow:auto} ");
 	doTemp.setLimit("Opinion1,Opinion2,Opinion3,Opinion4,Remark",100);
 	doTemp.setEditStyle("Opinion1,Opinion2,Opinion3,Opinion4,Remark","3");
 	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
		
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//��ȡ����ֹ����
	sSql ="select NextCheckDate from RISKSIGNAL_OPINION where SerialNo =:SerialNo";
	String sUpToDate = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(sUpToDate == null) sUpToDate = "";
	
	String sButtons[][] = {
			{(sSerialNo.equals("")?"true":"false"),"","Button","����","����Ԥ����鱨�����Ϣ","saveRecord()",sResourcesPath},		
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
			
	/*~[Describe=�����б�ҳ��;]~*/
	function goBack(){
		top.close();
	}
	
	/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/
	function beforeInsert(){
		initSerialNo();//��ʼ����ˮ���ֶ�				
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;]~*/
	function initRow(){
		if (getRowCount(0)==0){ //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
			as_add("myiframe0");//������¼			
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"InspectType","05");  //01���״μ�飻02�����ڼ�飻03�������ڼ�飻04��ר���飻05��Ԥ���źż��
			setItemValue(0,0,"UptoDate","<%=sUpToDate%>");			
			setItemValue(0,0,"InspectUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InspectUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InspectOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InspectOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");			
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InspectDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"FinishDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;			
		}		
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;]~*/
	function initSerialNo(){
		var sTableName = "INSPECT_INFO";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "AL";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�		
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>