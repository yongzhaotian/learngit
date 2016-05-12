<%
/* Copyright 2001-2014 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: 	jli5   P2PInfoҳ��
 * Tester:
 * Content: 
 * Input Param:
 * 				ObjectNo��	��ͬ��ˮ��
 * Output param:
 *				sReturnValue:	  
 * History Log:
 */%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --ҳ��˵��: ʾ������ҳ��-- */
	String PG_TITLE = "P2PInfoҳ��";
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
	String sSql="";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sHeaders[][] = { 
	        {"SERIALNO","��ˮ��"},
	        {"TOTALSUM","�ܶ��"},
	        {"HAVEUSESUM","���ö��"},
	        {"UNSIGNEDTOTALSUM","δǩ����"},
	        {"CAPITALSOURCE","�ʽ���Դ"},
	        {"EFFECTIVEDATE","��Ч��"},
	        {"INPUTUSERID","�Ǽ���"},
	        {"INPUTUSERIDNAME","�Ǽ���"},
	        {"INPUTORGID","�Ǽǻ���"},
	        {"INPUTORGIDNAME","�Ǽǻ���"},
	        {"INPUTDATE","�Ǽ�����"},
	        {"UPDATEUSERID","������"},
	        {"UPDATEUSERIDNAME","������"},
	        {"UPDATEDATE","��������"},
	        {"UPDATEORGID","���»���"},
	        {"UPDATEORGIDNAME","���»���"},
		}; 
	
	sSql = "SELECT SERIALNO,TOTALSUM,HAVEUSESUM,UNSIGNEDTOTALSUM,CAPITALSOURCE,EFFECTIVEDATE,GETUSERNAME(INPUTUSERID) as  INPUTUSERIDNAME,GETORGNAME(INPUTORGID) as INPUTORGIDNAME,INPUTUSERID,INPUTORGID,INPUTDATE,UPDATEUSERID,UPDATEDATE,UPDATEORGID,GETUSERNAME(UPDATEUSERID) as UPDATEUSERIDNAME,GETORGNAME(UPDATEORGID) as UPDATEORGIDNAME    FROM P2PCREDIT_INFO  WHERE SERIALNO='"+sSerialNo+"'";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "P2PCREDIT_INFO";
	doTemp.setKey("SERIALNO", true);
	
	doTemp.setHeader(sHeaders);
	doTemp.setReadOnly("SERIALNO,CAPITALSOURCE,HAVEUSESUM,UNSIGNEDTOTALSUM,INPUTUSERID,INPUTORGID,INPUTDATE,UPDATEUSERID,UPDATEDATE,UPDATEORGID,INPUTUSERIDNAME,INPUTORGIDNAME,UPDATEUSERIDNAME,UPDATEORGIDNAME", true);
	doTemp.setRequired("SERIALNO,TOTALSUM,CAPITALSOURCE,EFFECTIVEDATE", true);
	doTemp.setCheckFormat("TOTALSUM,HAVEUSESUM,UNSIGNEDTOTALSUM", "2");
	doTemp.setAlign("TOTALSUM,HAVEUSESUM,UNSIGNEDTOTALSUM", "3");
	doTemp.setAlign("CAPITALSOURCE,EFFECTIVEDATE,INPUTUSERID,INPUTORGID,INPUTDATE,UPDATEUSERID,UPDATEDATE,UPDATEORGID,INPUTUSERIDNAME,INPUTORGIDNAME,UPDATEUSERIDNAME,UPDATEORGIDNAME", "1");

	doTemp.setCheckFormat("EFFECTIVEDATE", "3");
	doTemp.setUnit("TOTALSUM,HAVEUSESUM,UNSIGNEDTOTALSUM", "&nbspԪ");
	doTemp.setColumnType("TOTALSUM,HAVEUSESUM,UNSIGNEDTOTALSUM", "1");
	doTemp.setVisible("INPUTUSERID,INPUTORGID,UPDATEUSERID,UPDATEORGID", false);
	doTemp.setUpdateable("UNSIGNEDTOTALSUM,INPUTUSERIDNAME,INPUTORGIDNAME,UPDATEUSERIDNAME,UPDATEORGIDNAME", false);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
	        {"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInset = false;
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		var EFFECTIVEDATE = getItemValue(0,0,"EFFECTIVEDATE");
		var SERIALNO = getItemValue(0,0,"SERIALNO")
		
		if( EFFECTIVEDATE < "<%=StringFunction.getToday()%>"){
			alert("��Ч�ձ�����ڵ��ڽ���");
			return;
		}
		
		var TableName="P2PCREDIT_INFO";
		var ColName = "count(1) ";
		var WhereClause = "EFFECTIVEDATE='" + EFFECTIVEDATE + "'";
		if( !bIsInset ){	//�༭����
			WhereClause += " and SERIALNO not in ('" + SERIALNO + "')";//�ų���ǰ��ˮ��
		}
		var returnValue =	RunMethod("���÷���","GetColValue",TableName+","+ColName+","+WhereClause);
		
		if((bIsInset&&returnValue>0) || !bIsInset&&returnValue>0){
			alert("����:"+EFFECTIVEDATE+"�Ѵ���P2P��ȣ���ѡ��������Ч���ڣ���");
			return;
		}
		
		setItemValue(0,getRow(),"UPDATEORGID","<%=CurOrg.getOrgID()%>");
		setItemValue(0,getRow(),"UPDATEORGNAME","<%=CurOrg.getOrgName()%>");
		setItemValue(0,getRow(),"UPDATEUSERID","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(),"UPDATEUSERNAME","<%=CurUser.getUserName()%>");	
		setItemValue(0,getRow(),"UPDATEDATE","<%=StringFunction.getTodayNow()%>");		
		if(bIsInset){
			setItemValue(0,getRow(),"HAVEUSESUM",0);		
			//setItemValue(0,getRow(),"AVAILABLESUM",getItemValue(0,0,"TOTALSUM"));
		}
		as_save("myiframe0");		
	}
		
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/SystemManage/P2PManage/P2PList.jsp","_self","");
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");
			initSerialNo();
			setItemValue(0,getRow(),"INPUTORGID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,getRow(),"INPUTORGNAME","<%=CurOrg.getOrgName()%>");
			setItemValue(0,getRow(),"INPUTUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"INPUTUSERNAME","<%=CurUser.getUserName()%>");	
			setItemValue(0,getRow(),"INPUTDATE","<%=StringFunction.getTodayNow()%>");
			setItemValue(0,getRow(),"CAPITALSOURCE","P2Pƽ̨");
			bIsInset = true; 
		} 
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "P2PCREDIT_INFO";//����
		var sColumnName = "SERIALNO";//�ֶ���
		var sPrefix = "";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		bFreeFormMultiCol = true;
		init();
		my_load(2,0,'myiframe0');
		initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
