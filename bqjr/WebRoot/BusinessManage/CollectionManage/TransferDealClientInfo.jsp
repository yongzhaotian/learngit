<%@ page contentType="text/html; charset=GBK"%>
<%@
 include file="/IncludeBegin.jsp"%><%

	String PG_TITLE = "�ʲ�ת��Э���б�ҳ��";
    String PG_CONTENT_TITLE = "&nbsp;&nbsp;�ʲ�ת��ɸѡ&nbsp;&nbsp;";
 %>
 <% 
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo = "";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject("TrustCompaniesInfo",Sqlca);
	doTemp.setKey("SERIALNO", true);
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"true","","Button","����","����","saveRecord()",sResourcesPath},
			//{"true","","Button","���沢����","���沢����","saveRecordAndReturn()",sResourcesPath},
			{"true","","Button","����","����","goBack()",sResourcesPath},
		};
	
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">


	var bIsInsert = false;
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(){
		if(!bIsInsert){
			beforeUpdate();
		}
		if(!validCheck())return;
		as_save("myiframe0");
	}
	
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEDATE","<%=StringFunction.getToday()%>");
	}
	
	function saveRecordAndReturn()
	{
		if(!validCheck())return;
		as_save("myiframe0");
		AsControl.OpenPage("/BusinessManage/CollectionManage/TransferDealClientList.jsp","","_self","");
	}
	
	function validCheck(){
		var companyName = getItemValue(0,getRow(),"SERVICEPROVIDERSNAME");
		var accoutNo = getItemValue(0,getRow(),"TURNACCOUNTNUMBER");
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		if(typeof(companyName)=="undefined"||companyName==""){
			alert("�����빫˾���ƣ�");
			return false;
		}
		if(typeof(accoutNo)=="undefined"||accoutNo==""){
			alert("�������ʺ�");
			return false;
		}
		var reg = new RegExp("^[0-9]*$");
		if(!reg.test(accoutNo)){
			alert("�ʺ����벻��ȷ�����������������ʺ�");
			return false;
		}

		var sReturn = RunMethod("���÷���","GetColValue","SERVICE_PROVIDERS,Count(*),SERVICEPROVIDERSNAME='"+companyName+"' and serialNo<>'"+serialNo+"'");
		if(typeof(sReturn)!="undefined"&&parseInt(sReturn)>0){
			alert("��˾���Ʋ����ظ�");
			return false;
		}
		return true;
	}
	
	// ���ؽ����б�
	function goBack()
	
	{
		AsControl.OpenPage("/BusinessManage/CollectionManage/TransferDealClientList.jsp","","_self","");
	}

	/*~[Describe=��ʼ�����ֲ���;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTORGID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"UPDATEORGID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"INPUTUSERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"UPDATEORGNAME","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"UPDATEUSERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UPDATEUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UPDATEDATE","<%=StringFunction.getToday()%>");
			initSerialNo();
			bIsInsert = true;
		}
	}
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "SERVICE_PROVIDERS";//����
		var sColumnName = "SERIALNO";//�ֶ���
		var sPrefix = "";//ǰ׺
		
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);//��ȡ��ˮ��
		
		setItemValue(0,getRow(),sColumnName,sSerialNo);//����ˮ�������Ӧ�ֶ�
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
		initRow();
		
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>