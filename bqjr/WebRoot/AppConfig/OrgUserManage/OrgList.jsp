<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ���������б�
	 */
	String PG_TITLE = "���������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	
	//��ȡ�������
	String sOrgID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgID"));
	if(sOrgID == null) sOrgID = "";
	String sSortNo="";
	sSortNo=Sqlca.getString(new SqlObject("select SortNo from Org_Info where OrgID=:OrgID").setParameter("OrgID",sOrgID));
	if(sSortNo==null)sSortNo="";

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "OrgList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
    //���ӹ�����	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	    
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(200);

	//��������¼�
	//dwTemp.setEvent("AfterDelete","!SystemManage.DeleteOrgBelong(#OrgID)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSortNo+"%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		//{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"true","","Button","ͣ��","ͣ��","deleteRecord()",sResourcesPath},
		{"true","","Button","����","����","enableRecord()",sResourcesPath},
		//{"true","","Button","��ʼ������Ȩ��","��ʼ������Ȩ��","initialOrgBelong()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
        OpenPage("/AppConfig/OrgUserManage/OrgInfo.jsp","_self","");            
	}
	
	function viewAndEdit(){
        var sOrgID = getItemValue(0,getRow(),"OrgID");
        if(typeof(sOrgID)=="undefined" || sOrgID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		
		OpenPage("/AppConfig/OrgUserManage/OrgInfo.jsp?CurOrgID="+sOrgID,"_self","");        
	}
    
	function deleteRecord(){
		var sOrgID = getItemValue(0,getRow(),"OrgID");
        if(typeof(sOrgID) == "undefined" || sOrgID.length == 0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		
		//if(confirm(getHtmlMessage('2'))){ //�������ɾ������Ϣ��
		/* if(confirm("�����Ҫͣ�øû�����")){ //�������ɾ������Ϣ��
			//ȡ���鵵����
			sReturn = RunMethod("PublicMethod","UpdateColValue","String@SignalStatus@15,RISK_SIGNAL,String@SerialNo@"+sSerialNo);
			if(typeof(sReturn) == "undefined" || sReturn.length == 0) {					
				alert(getHtmlMessage('9'));//�ύʧ�ܣ�
				return;
			}else
			{
				reloadSelf();
				alert(getHtmlMessage('18'));//�ύ�ɹ���
			}
		} */
	}
	
	
	/*~[Describe=��ʼ������Ȩ��;InputParam=��;OutPutParam=��;]~*/
	function initialOrgBelong(){
		if(confirm("��ȷ����ʼ������Ȩ����")){
			var returnValue = PopPage("/AppConfig/OrgUserManage/InitialOrgBelongAction.jsp","","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
			if("true"==returnValue)
			{
				alert("��ʼ������Ȩ�޳ɹ���") ;
			}else{
				alert("��ʼ������Ȩ��ʧ�ܣ�") ;
			}
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>