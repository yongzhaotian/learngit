<%
/* Copyright 2001-2014 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: 	jli5   P2PListҳ��
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
	String PG_TITLE = "P2PListҳ��";

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
	        {"INPUTORGID","�Ǽǻ���"},
	        {"INPUTDATE","�Ǽ�����"},
	        {"UPDATEUSERID","������"},
	        {"UPDATEDATE","��������"},
	        {"UPDATEORGID","���»���"},
		}; 
	sSql = "SELECT SERIALNO,TOTALSUM,HAVEUSESUM,UNSIGNEDTOTALSUM,CAPITALSOURCE,EFFECTIVEDATE,getUserName(INPUTUSERID) as  INPUTUSERID,getOrgName(INPUTORGID) as INPUTORGID,INPUTDATE,getUserName(UPDATEUSERID) as UPDATEUSERID,UPDATEDATE,getOrgName(UPDATEORGID) as UPDATEORGID FROM P2PCREDIT_INFO order by EFFECTIVEDATE desc";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "P2PCREDIT_INFO";
	doTemp.setKey("SERIALNO", true);
	doTemp.setHeader(sHeaders);
	doTemp.setReadOnly("*", false);
	doTemp.setRequired("*", false);
// 	doTemp.setCheckFormat("TOTALSUM,HAVEUSESUM", "2");
// 	doTemp.setType("TOTALSUM,HAVEUSESUM", "String");
	doTemp.setCheckFormat("EFFECTIVEDATE", "3");
	doTemp.setAlign("TOTALSUM,HAVEUSESUM,CAPITALSOURCE,EFFECTIVEDATE,INPUTUSERID,INPUTORGID,INPUTDATE,UPDATEUSERID,UPDATEDATE,UPDATEORGID", "3");
	//���ӹ�����			
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca, "10", "SERIALNO", "");
	doTemp.setFilter(Sqlca, "20", "TOTALSUM", "");
	doTemp.setFilter(Sqlca, "30", "HAVEUSESUM", "");
	doTemp.setFilter(Sqlca, "32", "UNSIGNEDTOTALSUM", "");
	doTemp.setFilter(Sqlca, "35", "CAPITALSOURCE", "");
	doTemp.setFilter(Sqlca, "40", "INPUTDATE", "");
	doTemp.setFilter(Sqlca, "50", "UPDATEDATE", "");
	doTemp.setFilter(Sqlca, "60", "EFFECTIVEDATE", "");
	
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
	    	{"true", "", "Button", "����", "����һ����¼", "newRecord()",	sResourcesPath},
			{"true", "", "Button", "����", "�鿴/�޸�����","viewAndEdit()", sResourcesPath},
			{"true", "", "Button", "ɾ��", "ɾ����ѡ�еļ�¼","deleteRecord()", sResourcesPath}
			};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>

/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord() {
		OpenPage("/SystemManage/P2PManage/P2PInfo.jsp", "_self", "");
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord() {
		sSerialNo = getItemValue(0, getRow(), "SERIALNO");
		if (typeof (sSerialNo) == "undefined" || sSerialNo.length == 0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
	
		if (confirm(getHtmlMessage('2'))) //�������ɾ������Ϣ��
		{
			as_del("myiframe0");
			as_save("myiframe0"); //�������ɾ������Ҫ���ô����
		}
	}
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit() {
		sSerialNo = getItemValue(0, getRow(), "SERIALNO");
		if (typeof (sSerialNo) == "undefined" || sSerialNo.length == 0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		OpenPage("/SystemManage/P2PManage/P2PInfo.jsp?SerialNo="+ sSerialNo, "_self", "");
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
// 		showFilterArea();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
