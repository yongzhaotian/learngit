<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   slliu 2004.11.22
		Tester:
		Content: ����ʲ�̨����Ϣ
		Input Param:
			    SerialNo������ʲ����
				ObjectNo�������Ż򰸼����
				ObjectType����������
				sBookType��̨������			       
		Output param:
		               
		History Log: zywei 2005/09/06 �ؼ����
		                 
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����ʲ�̨����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	String sRecoveryUserID = "";
	String sRecoveryUserName = "";
	String sAmbientName = "";
	String sPropertyOrg = "";
	ASResultSet rs = null;
	
	//���ҳ�����
	//��¼��ˮ�š�������š��������͡�̨������
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PageSerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sBookType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BookType"));
	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sBookType == null) sBookType = "";
		
	//��ò����ʲ��Ĺܻ��ˣ��Զ�Ĭ��Ϊ����ʲ��Ĳ����ܻ���
	sSql = " select BC.RecoveryUserID as RecoveryUserID,getUserName(BC.RecoveryUserID) as RecoveryUserName "+
		   " from BUSINESS_CONTRACT BC,LAWCASE_INFO LI,LAWCASE_RELATIVE LR "+
		   " where BC.Serialno=LR.ObjectNo "+
		   " and LR.ObjectType='BusinessContract' "+
		   " and LR.Serialno = :Serialno ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("Serialno",sObjectNo));	
	if(rs.next()){
		sRecoveryUserID = DataConvert.toString(rs.getString("RecoveryUserID"));
		sRecoveryUserName = DataConvert.toString(rs.getString("RecoveryUserName"));
	}
	//����ֵת��Ϊ���ַ���
	if(sRecoveryUserID == null) sRecoveryUserID = "";
	if(sRecoveryUserName == null) sRecoveryUserName = "";
	
	rs.getStatement().close();
	
	//��ð�����Ӧ�����²���ʲ��ķ�������š�����ʲ������˵ȣ�����Ϊ�±ʲ���ʲ���Ĭ��ֵ
	sSql = 	" select AmbientName,PropertyOrg "+
			" from ASSET_INFO "+
			" where ObjectNo = :ObjectNo1 "+
			" and ObjectType=:ObjectType1 "+
			" and Serialno = (select  max(Serialno) from ASSET_INFO where ObjectNo = :ObjectNo2 and  ObjectType=:ObjectType2)";
	SqlObject so = new SqlObject(sSql).setParameter("ObjectNo1",sObjectNo).setParameter("ObjectType1",sObjectType)
	.setParameter("ObjectNo2",sObjectNo).setParameter("ObjectType2",sObjectType);				
	rs = Sqlca.getASResultSet(so);
	if(rs.next()){
		sAmbientName = DataConvert.toString(rs.getString("AmbientName"));
		sPropertyOrg = DataConvert.toString(rs.getString("PropertyOrg"));	 
	}
	//����ֵת��Ϊ���ַ���
	if(sAmbientName == null) sAmbientName = "";
	if(sPropertyOrg == null) sPropertyOrg = "";
	
	rs.getStatement().close();
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "LawsuitInfo";
	String sTempletFilter = "1=1";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//ѡ���ֻ�������Ա
	doTemp.setUnit("OperateUserName"," <input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectUser(\""+CurOrg.getOrgID()+"\",\"OperateUserID\",\"OperateUserName\",\"OperateOrgID\",\"OperateOrgName\")>");
	//�ַ���������		
	 doTemp.appendHTMLStyle("LandownerNo"," onkeyup=\"value=value.replace(/[^0-9]/g,&quot;&quot;) \" onbeforepaste=\"clipboardData.setData(&quot;text&quot;,clipboardData.getData(&quot;text&quot;).replace(/[^0-9]/g,&quot;&quot;))\" ");

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);	
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
			{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};
	
	if(!(sBookType.equals("112")))  //�Ӳ����ʲ���Ϣ�б����鿴����ʲ���Ϣ
	{
		
		sButtons[0][0]="false";
		
	}
		
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	
	<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	
	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert)
		{
			beforeInsert();
			bIsInsert = false;			
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawsuitAssetsList.jsp","_self","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">
	
	/*~[Describe=�����û�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectUser(sParam,sUserID,sUserName,sOrgID,sOrgName)
	{		
		sParaString = "BelongOrg"+","+sParam;
		setObjectValue("SelectUserBelongOrg",sParaString,"@"+sUserID+"@0@"+sUserName+"@1@"+sOrgID+"@2@"+sOrgName+"@3",0,0,"");
	}	
	
	/*~[Describe=ִ����������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();//��ʼ����ˮ���ֶ�		
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
			
			//�ʲ�����Ϊ����ʲ���״̬Ϊδ�˳����
			setItemValue(0,0,"AssetAttribute","02");
			setItemValue(0,0,"AssetStatus","01");  
			
			//�����š���������
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			
			//��������š�����ʲ�������
			setItemValue(0,0,"AmbientName","<%=sAmbientName%>");
			setItemValue(0,0,"PropertyOrg","<%=sPropertyOrg%>");
			
			//����ʲ��ܻ��������ܻ���
			setItemValue(0,0,"OperateUserID","<%=sRecoveryUserID%>");
			setItemValue(0,0,"OperateUserName","<%=sRecoveryUserName%>");
		
			//�Ǽ��ˡ��Ǽ������ơ��Ǽǻ������Ǽǻ�������
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			
			//�Ǽ�����						
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		}	
		var sColName = "LawCaseName"+"~";
		var sTableName = "LAWCASE_INFO"+"~";
		var sWhereClause = "String@SerialNo@"+<%=sObjectNo%>+"~";
		
		sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{			
			sReturn = sReturn.split('~');
			var my_array = new Array();
			for(i = 0;i < sReturn.length;i++)
			{
				my_array[i] = sReturn[i];
			}
			
			for(j = 0;j < my_array.length;j++)
			{
				sReturnInfo = my_array[j].split('@');				
				if(typeof(sReturnInfo) != "undefined" && sReturnInfo != "")
				{					
					if(sReturnInfo[0] == "lawcasename" && sReturnInfo[1]!="null")//@jlwu��û�����밸������ʱ�������null
					{
						setItemValue(0,getRow(),"LawCaseName",sReturnInfo[1]);
						break;
					}else if(sReturnInfo[0] == "lawcasename" && sReturnInfo[1]=="null")
					{
						setItemValue(0,getRow(),"LawCaseName","");
						break;
					}					
				}
				
					
			}			
		}			
    }	

	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{		
		var sTableName = "ASSET_INFO";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}

	</script>
	
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

