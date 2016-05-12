<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*	Author: djia 2010-09-06
*	Tester:
*	Describe: ��ծ�����˱����¼�б�;
*	Input Param:
*		ObjectType��Asset_info
*		ObjectNo����ծ�ʲ���ˮ���
*	Output Param:     
*		SerialNo	:�����¼��ˮ��       
*	HistoryLog:
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ծ�����˱����¼�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%


	//����������
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo")); //�ʲ���ˮ��
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType")); //asset_info
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	String sHeaders[][] = {								
							{"OldUserName","ԭ������"},
							{"OldOrgName","ԭ�������"},
							{"NewUserName","�ֹ�����"},
							{"NewOrgName","�ֹ������"},
							{"ChangeUserName","�����"},
							{"ChangeOrgName","�������"},
							{"ChangeTime","�������"}
						};

	String sSql = " select SerialNo, "+				  
				  " OldUserName, "+ 
				  " OldOrgName, "+
				  " NewUserName, "+ 
				  " NewOrgName, "+ 
				  " getUserName(ChangeUserID) as ChangeUserName, "+ 
				  " getOrgName(ChangeOrgID) as ChangeOrgName, "+ 
				  " ChangeTime  as ChangeTime "+
				  " from MANAGE_CHANGE "+
				  " where ObjectType = '"+sObjectType+"' "+
				  " and ObjectNo = '"+sObjectNo+"' "+
				  " order by ChangeTime desc";

	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);

	doTemp.UpdateTable = "MANAGE_CHANGE";	
	doTemp.setKey("SerialNo,ObjectNo,ObjectType",true);	 //���ùؼ���

	//���ò��ɼ���
	doTemp.setVisible("SerialNo",false);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
	doTemp.setHTMLStyle("OldUserName"," style={width:67px} ");
	doTemp.setHTMLStyle("OldOrgName"," style={width:90px} ");
	doTemp.setHTMLStyle("NewUserName"," style={width:67px} ");
	doTemp.setHTMLStyle("NewOrgName"," style={width:90px} ");
	doTemp.setHTMLStyle("ChangeUserName"," style={width:65px} ");
	doTemp.setHTMLStyle("ChangeOrgName,AssetNo,AssetName"," style={width:90px} ");
	doTemp.setHTMLStyle("ChangeTime"," style={width:70px} ");

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);	
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
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
		{"true","","Button","����","�鿴��¼��ϸ��Ϣ","viewAndEdit()",sResourcesPath},
		{"true","","Button","����","����","goBack()",sResourcesPath},
		};
	%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else
		{
			sObjectNo="<%=sObjectNo%>";
			sObjectType="<%=sObjectType%>";
			OpenPage(	"/LAP/RepayAssetManage/PDAManagerChange/RepayAssetChangeInfo.jsp?"+
				"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&SerialNo="+sSerialNo+"&GoBackType=2","right");
		}
	}
	
	function goBack()
	{
		OpenComp("RepayAssetList","/LAP/RepayAssetManage/PDAManagerChange/RepayAssetList.jsp","ComponentName=��ծ�ʲ������˱��&ComponentType=ListWindow","right");
	}
</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@include file="/IncludeEnd.jsp"%>
