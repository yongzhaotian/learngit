<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "��������ʲ��б�";
	//���ҳ�����
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	String sObjectType	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));

	//����ֵת��Ϊ���ַ���
	if(sObjectType == null) sObjectType = "";

	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "AppNoDisposalList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);
	
	//ɾ����ծ�ʲ���ɾ��������Ϣ
    dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(AssetInfo,#SerialNo,DeleteBusiness)");

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+CurUser.getUserID());
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));	
	String sButtons[][] = {
			{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
			{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
			{"true","","Button","����ת����","����ת����","my_Intable()",sResourcesPath},
			{"true","","Button","����ת����","����ת����","my_Outtable()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=SerialNo;]~*/
	function newRecord()
	{
		var sAssetInfo =PopPage("/RecoveryManage/PDAManage/PDADailyManage/PDATypeDialog.jsp","","resizable=yes;dialogWidth=21;dialogHeight=10;center:yes;status:no;statusbar:no");
		sAssetInfo = sAssetInfo.split("@");
		var sSerialNo=sAssetInfo[1];
		if(typeof(sSerialNo) != "undefined" && sSerialNo.length != 0)
		{			
			popComp("PDABasicView","/RecoveryManage/PDAManage/PDADailyManage/PDABasicView.jsp","ObjectNo="+sSerialNo,"");
			reloadSelf();
		} 		
	}
			
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		if(confirm(getHtmlMessage(2))) //�������ɾ������Ϣ��
		{
			as_del("myiframe0");			
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//��õ�ծ�ʲ���ˮ��
		sSerialNo = getItemValue(0,getRow(),"SerialNo");					
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		popComp("PDABasicView","/RecoveryManage/PDAManage/PDADailyManage/PDABasicView.jsp","ObjectNo="+sSerialNo,"");
		reloadSelf();
	}	
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	
	/*~[Describe=����ת������Ϣ;InputParam=��;OutPutParam=SerialNo;]~*/
	function my_Intable()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{			
			//������Ϣ����,��ʾ�û������µ����˼�ֵ��������ծ�ʲ���Ŀ���
			popComp("PDAInOutSwitchDialog","/RecoveryManage/PDAManage/PDADailyManage/PDAInOutSwitchDialog.jsp","SerialNo="+sSerialNo+"&InOut=In","dialogWidth:600px;dialogheight:440px","");
			reloadSelf();
		}
	}

	/*~[Describe=����ת������Ϣ;InputParam=��;OutPutParam=SerialNo;]~*/
	function my_Outtable()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{			
			//������Ϣ����,��ʾ�û������µĵ�ծʱ��������뵱ǰ�������
			popComp("PDAInOutSwitchDialog","/RecoveryManage/PDAManage/PDADailyManage/PDAInOutSwitchDialog.jsp","SerialNo="+sSerialNo+"&InOut=Out","dialogWidth:600px;dialogheight:440px","");
			reloadSelf();
		}
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
