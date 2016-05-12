<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   djia 2010-09-06
		Tester:
		Content: ��ծ�ʲ������˱��
		Input Param:
				���в�����Ϊ�����������
				ComponentName	������ƣ��ѵ���/�����е��ʲ��б�
			    ComponentType		������ͣ� ListWindow
		Output param:
				ObjectNo				��ծ�ʲ����
				ObjectType			LAP_REPAYASSETINFO
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ծ�ʲ������˱��---�ʲ��б�"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ծ�ʲ������˱��---�ʲ��б�&nbsp;&nbsp;";
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";
	
	//����������	
	String sComponentType	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentType"));	
	
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//�����ͷ�ļ�
	String sHeaders[][] = { 							
							{"SerialNo","�ʲ����"},
							{"ObjectNo","������"},
							{"ApplyNo","������"},							
							{"AssetName","�ʲ�����"},
							{"AssetType","�ʲ����"},	
							{"AssetTypeName","�ʲ����"},	
							{"AssetSum","��ծ�ʲ��ܶ�(Ԫ)"},
							{"AssetBalance","��ծ�ʲ����(Ԫ)"},
							{"ManageUserID","������"},
							{"ManageUserName","������"},
							{"ManageOrgID","�������"},
							{"ManageOrgName","�������"}
						}; 
				
		//�ӵ�ծ�ʲ���Ϣ��LAP_REPAYASSETINFO��ѡ����ǰ�����˵��ʲ�
		sSql = "  select SerialNo,"+
					" ObjectNo,"+
					" ApplyNo,"+
					" AssetNo,"+
					" AssetName,"+
					" AssetType,"+
					" getItemName('PDAType',trim(AssetType)) as AssetTypeName,"+
					" AssetSum," +	
					" AssetBalance," +	
					" ManageUserID, " +	
					" ManageOrgID, " +	
					" getUserName(ManageUserID) as ManageUserName, " +	
					" getOrgName(ManageOrgID) as ManageOrgName"+			
					" from LAP_REPAYASSETINFO" +
					" where ManageOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%') "+
					" and AssetAttribute='01' and ManageUserID='"+CurUser.getUserID()+"' order by AssetName desc";
					//AssetAttribute��01����ծ�ʲ���02������ʲ�
	
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);

	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "LAP_REPAYASSETINFO";
	
	//���ùؼ���
	doTemp.setKey("SerialNo",true);	 

	//���ò��ɼ���
	doTemp.setVisible("ApplyNo,ObjectNo,AssetType,ManageUserID,ManageOrgID,AssetNo",false);

	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("SerialNo","style={width:100px} ");  
	doTemp.setHTMLStyle("AssetTypeName,AssetNo","style={width:80px} ");  
	doTemp.setHTMLStyle("AssetName,ManageUserName,ManageOrgName,AssetSum,AssetBalance"," style={width:100px} ");
	doTemp.setUpdateable("AssetTypeName",false); 
	doTemp.setCheckFormat("AssetSum,AssetBalance","2");	
	
	//���ö��뷽ʽ
	doTemp.setAlign("AssetSum,AssetBalance","3");
	doTemp.setType("AssetSum,AssetBalance","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("AssetSum,AssetBalance","2");
		
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("AssetName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);  //��������ҳ
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
				{"true","","Button","�ʲ�����","�鿴��ծ�ʲ�����","viewAndEdit()",sResourcesPath},
				{"true","","Button","���������","���������","Change_Manager()",sResourcesPath},
				{"true","","Button","�鿴�����¼","�鿴�����¼","Change_History()",sResourcesPath}
			};
			
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=�鿴��¼;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//��õ�ծ�ʲ���ˮ��
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��			
		}else
		{
			openObject("AssetInfo",sSerialNo,"002");				
			reloadSelf();
		}
	}

	/*~[Describe=�����������Ϣ;InputParam=��;OutPutParam=SerialNo;]~*/
	function Change_Manager()
	{
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	  //��õ�ծ�ʲ���ˮ��
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��			
		}else
		{
			var sManageOrgID=getItemValue(0,getRow(),"ManageOrgID");	
			var sManageOrgName=getItemValue(0,getRow(),"ManageOrgName");	
			var sManageUserID=getItemValue(0,getRow(),"ManageUserID");	
			var sManageUserName=getItemValue(0,getRow(),"ManageUserName");	
			OpenPage("/LAP/RepayAssetManage/PDAManagerChange/RepayAssetChangeInfo.jsp?"+
					"ObjectType=AssetInfo&ObjectNo="+sSerialNo+
					"&OldOrgID="+sManageOrgID+
					"&OldOrgName="+sManageOrgName+
					"&OldUserID="+sManageUserID+
					"&OldUserName="+sManageUserName+"&GoBackType=1","right");
		}
	}

	/*~[Describe=�鿴�����������ʷ;InputParam=��;OutPutParam=SerialNo;]~*/	
	function Change_History()
	{
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	  //��õ�ծ�ʲ���ˮ��
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��			
		}else
		{ 
			OpenComp("PDAManagerChangeHistory",
					"/LAP/RepayAssetManage/PDAManagerChange/RepayAssetChangeHistory.jsp",
					"ComponentName=��ծ�ʲ������˱����¼&ComponentType=ListWindow"+
					"&ObjectType=AssetInfo&ObjectNo="+sSerialNo,"right");
		}
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

<%@ include file="/IncludeEnd.jsp"%>
