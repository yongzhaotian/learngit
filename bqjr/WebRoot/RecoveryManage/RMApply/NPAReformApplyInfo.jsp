<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: ҵ�������Ϣ
		Input Param:
				 SerialNo��ҵ��������ˮ��
	 */
	String PG_TITLE = "ҵ�������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	//�������
	String sTable="";
	
	//���ҳ�����	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));	
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType"));
	
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sApplyType == null) sApplyType="";
	
	//2010/08/03 sxjiang ����������ҳ��鿴��ʱ�򣬲鿴�ñ�ҵ������ĸ�ծ������
	//��Ҫ����Ϊծ���������Ϣ�����Business_Apply�У�����ʱ�鿴��ҵ��������ϢҲ�Ǵ����Business_Apply��
	//����listҳ��ֻ�ܴ�һ��serialNo�����������ڴ���Ҫ������ҵ���Ƿ��й�����ծ��������Ϣ
	if(sApplyType.indexOf("Apply") > -1 && sObjectType.equalsIgnoreCase("NPAReformApply")){
		String ObjectNo_temp = "";
		String sSql = "select ObjectNo from Apply_Relative where ObjectType = 'NPAReformApply' and SerialNo = :SerialNo ";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
		while(rs.next()){
			ObjectNo_temp = rs.getString(1);
		}
		rs.getStatement().close();
		if(!"".equals(ObjectNo_temp)){   //����ڹ�����Apply_Relative�в鵽�й�����ծ��������Ϣ��������ObjectNo_temp��sObjectNo���к�������
			sObjectNo = ObjectNo_temp;
		}
	}

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "";
	if(sApplyType.equals("01"))
		sTempletNo = "NPAReformApplyInfo";
	else
		sTempletNo = "NPAReformApplyInfo2";
		
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
		
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	/*~[Describe=����;]~*/
	function saveRecord(sPostEvents){	
		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
		
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"OperateOrgID","<%=CurOrg.getOrgID()%>");		
		setItemValue(0,0,"OperateUserID","<%=CurUser.getUserID()%>");					
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>