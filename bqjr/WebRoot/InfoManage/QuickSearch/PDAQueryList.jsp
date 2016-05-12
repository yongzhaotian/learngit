<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   FSGong 2004.12.07
		Tester:
		Content: �ѵ���/�����е��ʲ��б�AppDisposingList.jsp
		Input Param:
				���в�����Ϊ�����������
				--ObjectType			�������ͣ�ASSET_INFO
									����������Ŀ���Ǳ�����չ��,�������ܻ��ῼ�ǲ���ʲ���
				--sObjectNo         ������
			          
		Output param:
				--SerialNo   : ��ծ�ʲ����
				--AssetType: ��ծ�ʲ����� 
		History Log: 		                  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ѵ���/�����е��ʲ��б�"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�ѵ���/�����е��ʲ��б�&nbsp;&nbsp;";
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql;//--���sql���

	String sObjectType;//--��������	
	String sObjectNo;//--������
	
	//����������	
	sObjectType	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));

	//�ӵ�ծ�ʲ���Ϣ��ASSET_INFO��ѡ���ѵ���/�����е��ʲ�
	//�����ͷ�ļ�
	String sHeaders[][] = { 							
										{"SerialNo","�ʲ����"},
										{"AssetNo","�ʲ����"},
										{"AssetName","�ʲ�����"},
										{"Flag","�������/����"},
										{"FlagName","�������/����"},
										{"AssetType","�ʲ����"},	
										{"AssetTypeName","�ʲ����"},	
										{"AssetSum","��ծ���(Ԫ)"},
										{"AssetBalance","�ʲ����(Ԫ)"},
										{"ManageUserID","������"},
										{"ManageOrgID","�������"}
									}; 
	

	    sSql =  "  select SerialNo,AssetNo,"+
				" AssetName,AssetType,"+
				" getItemName('PDAType',rtrim(ltrim(AssetType))) as AssetTypeName,"+
				" Flag ,"+
				" getItemName('Flag',Flag) as FlagName,"+
				" AssetSum, " +	
				" AssetBalance, " +	
				" getUserName(ManageUserID) as ManageUserID, " +	
				" getOrgName(ManageOrgID) as ManageOrgID"+			
	       		" from ASSET_INFO" +
				" where ManageUserID='"+CurUser.getUserID()+
				"' and AssetStatus='03'  and AssetAttribute='01' and PigeonholeDate is null  and  ObjectType='"+sObjectType+"' order by AssetName desc";
				//�ܻ���Ϊ��ǰ�û�
				//��ծ�ʲ�������״��03���ѵ���
				//AssetAttribute��01����ծ�ʲ���02������ʲ�
				//�鵵����Ϊ��
	

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);

	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "ASSET_INFO";
	
	//���ùؼ���
	doTemp.setKey("SerialNo",true);	 

	//���ò��ɼ���
	doTemp.setVisible("SerialNo,AssetType,Flag",false);

	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("SerialNo","style={width:100px} ");  
	doTemp.setHTMLStyle("AssetTypeName,FlagName","style={width:85px} ");  
	doTemp.setHTMLStyle("AssetName,ManageUserID,ManageOrgID,AssetSum,AssetBalance,AssetNo"," style={width:80px} ");
	doTemp.setUpdateable("AssetTypeName",false); 
	
	//���ö��뷽ʽ
	doTemp.setAlign("AssetSum,AssetBalance","3");
	doTemp.setType("AssetSum,AssetBalance","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("AssetSum,AssetBalance","2");
	
	//ָ��˫���¼�
//	doTemp.setHTMLStyle("DunLetterNo,DunObjectName,DunDate,DunForm,ServiceMode,DunCurrency,DunSum,Corpus,InterestInSheet,InterestOutSheet"," style={width:100px} ondblclick=\"javascript:parent.onDBLClick()\" ");  	
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("AssetName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);  //��������ҳ

	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //��ѯ����ҳ�����
	
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
		{"true","","Button","��ϸ��Ϣ","��ϸ��Ϣ","viewAndEdit()",sResourcesPath}
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//��õ�ծ�ʲ���ˮ�š���ծ�ʲ�����
		sSerialNo=getItemValue(0,getRow(),"SerialNo");	
		sAssetType=getItemValue(0,getRow(),"AssetType");
		sObjectType="<%=sObjectType%>";
		var sAssetName=getItemValue(0,getRow(),"AssetName");
		var sAssetNo=getItemValue(0,getRow(),"AssetNo");
	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		OpenComp("PDABasicView",
			"/RecoveryManage/PDAManage/PDADailyManage/PDABasicView.jsp",
			"ComponentName=��ծ�ʲ���ϸ��Ϣ&ComponentType=MainWindow&SerialNo="+
			sSerialNo+"&AssetType="+sAssetType+"&ObjectType="+sObjectType+
			"&ObjectNo="+"&AssetName="+sAssetName+"&AssetNo="+sAssetNo+"&EnterPath=2","_blank",OpenStyle);
			//EnterPath=1��ζ�Ŵ�����׼��������,�����޷���������̨��;�˴�Ϊ2���Կ�������̨��
		reloadSelf();
	}	
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
