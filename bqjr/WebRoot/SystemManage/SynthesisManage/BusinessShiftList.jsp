<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: ������ҵ��ת��Ȩ�б����
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������ҵ��ת��Ȩ"; // ��������ڱ��� <title> PG_TITLE </title>
	//���ҳ�����
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "BusinessShiftList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(100);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(CurOrg.getSortNo());
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	
	//out.println(doTemp.SourceSql); //������仰����datawindow
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
			{"true","","Button","�鿴ҵ������","�鿴ҵ������","viewAndEdit()",sResourcesPath},
			{"true","","Button","ת��Ȩ","������ҵ��ת��Ȩ��Ϣ","transferTask()",sResourcesPath}	,
		   {"true","","PlainText","(˫�����ѡ��/ȡ�� �Ƿ�ת��Ȩ)","(˫�����ѡ���ȡ�� �Ƿ�ת��Ȩ)","style={color:red}",sResourcesPath}			
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
		//����Ƿ������ѡ�еļ�¼
    	sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		//��ȡ�������ͺͶ�����
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
	  
		//modified by ttshao begin
		//��ȡObjectNo��Ӧ�Ľ����ˮ�źͻ���·�
		var sDuebillNo = RunMethod("Test","getDuebillNo",sObjectNo);
		var sAccountMonth = RunMethod("Test","getAccountMonth",sObjectNo);
	        
		if(sObjectType == "Classify"){
			 //���ObjectType(�弶����������ͣ�Ϊ"Classify")�� SerialNo(Classify_Record���SerialNo�����弶����������ˮ��)��sDuebillNo(��ݺŻ��ͬ��), 
	        //AccountMonth(����·�),ResultType(�弶�����ǽ�ݻ��ͬ��ֵΪ"BusinessDueBill"��"BusinessContract")
	        //sSerialNo = getItemValue(0,getRow(),"SerialNo");
	        //var sAccountMonth = getItemValue(0,getRow(),"2012/09");
	  
	        sClassifyType = "020";
	        sViewID = "002";//jschen@20100423 ����tabֻ��
	       
	        sCompID = "CreditTab";
	        sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
	        sParamString = "ComponentName=���շ���ο�ģ��"+
					       "&OpenType=Tab"+ 
	            		   "&Action=_DISPLAY_"+
	            		   "&ClassifyType="+sClassifyType+
	            		   "&ObjectType="+"Classify"+
	            		   "&ObjectNo="+sObjectNo+ //classify_record����ˮ�� ��Ҳ����fo��ft�е�objectno
	            		   "&SerialNo="+sDuebillNo+ //�����ˮ��
	            		   "&AccountMonth="+sAccountMonth+
	            		   "&ModelNo=Classify1"+
	            		   "&ResultType=BusinessDueBill"+
	            		   "&ViewID="+sViewID;
	        popComp(sCompID,sCompURL,sParamString,"");
	      
	        reloadSelf();
		}else if(sObjectType == "SMEApply"){
		//����������͡�������ˮ��
		//�ͻ���Ϣ¼��ģ̬�����	
		sReturnValue = PopComp("SMEApplyCreateInfo","/Common/WorkFlow/SMEApplyCreateInfo.jsp","ObjectNo="+sObjectNo,"");
		}
		else{
		//modified by ttshao enf
		OpenObject(sObjectType,sObjectNo,"002");	
		}
	}
	
	/*~[Describe=������ҵ��ת��Ȩ;InputParam=��;OutPutParam=��;]~*/	
	function transferTask()
    {    	
    	//����Ƿ������ѡ�еļ�¼
    	var j = 0;
		var a = getRowCount(0);
		for(var i = 0 ; i < a ; i++)
		{				
			var sStatus = getItemValue(0,i,"Status");
			if(sStatus == "��")
				j=j+1;
		}
		if(j <= 0)
		{
			alert(getBusinessMessage('918'));//��ѡ�������ҵ��
			return;
		}
    	if (confirm(getBusinessMessage('920')))//ȷ��ת�Ƹô�����ҵ����
    	{				
			var sSerialNo = "";			
			var sFromOrgID = "";
			var sFromOrgName = "";
			var sFromUserID = "";
			var sFromUserName = "";
			var sToUserID = "";
			var sToUserName = "";
			//��ȡ��ǰ����
			var sOrgID = "<%=CurOrg.getOrgID()%>";
			var sParaString = "BelongOrg"+","+sOrgID
			sUserInfo = setObjectValue("SelectUserBelongOrg",sParaString,"",0);	
		    if (sUserInfo == "" || sUserInfo == "_CANCEL_" || sUserInfo == "_NONE_" || sUserInfo == "_CLEAR_" || typeof(sUserInfo) == "undefined") 
		    {
			    alert(getBusinessMessage('921'));//��ѡ��ת��Ȩ����û���
			    return;
		    }else
		    {
			    sUserInfo = sUserInfo.split('@');
			    sToUserID = sUserInfo[0];
			    sToUserName = sUserInfo[1];			    
		   
				//���ж��Ƿ�������һ����ͬ��ѡ���������ˡ����е��ҳ���
				var b = getRowCount(0);				
				for(var i = 0 ; i < b ; i++)
				{
	
					var a = getItemValue(0,i,"Status");
					if(a == "��")
					{
						sSerialNo = getItemValue(0,i,"SerialNo");	
						sFromOrgID = getItemValue(0,i,"OrgID");
						sFromOrgName = getItemValue(0,i,"OrgName");
						sFromUserID = getItemValue(0,i,"UserID");
						sFromUserName = getItemValue(0,i,"UserName");	
						if(sFromUserID == sToUserID)
						{
							alert(getBusinessMessage('922'));//�����������ҵ��ת��Ȩ��ͬһ�û�����У�������ѡ��ת��Ȩ����û���
							return;
						}										
						//����ҳ�����
						sReturn = PopPageAjax("/SystemManage/SynthesisManage/BusinessShiftActionAjax.jsp?SerialNo="+sSerialNo+"&FromOrgID="+sFromOrgID+"&FromOrgName="+sFromOrgName+"&FromUserID="+sFromUserID+"&FromUserName="+sFromUserName+"&ToUserID="+sToUserID+"&ToUserName="+sToUserName+"","","dialogWidth=21;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 
						if(sReturn == "TRUE")
							alert("������ˮ��("+sSerialNo+"),"+"ҵ��ת��Ȩ�ɹ���");
						else if(sReturn == "FALSE")
							alert("������ˮ��("+sSerialNo+"),"+"ҵ��ת��Ȩʧ�ܣ�");						
					}
				}				
				reloadSelf();
				
			}
		}
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	
	/*~[Describe=�һ�ѡ���¼;InputParam=��;OutPutParam=��;]~*/
	function onDBClickStatus()
	{
		sStatus = getItemValue(0,getRow(),"Status") ;
		if (typeof(sStatus) == "undefined" || sStatus == "")
			setItemValue(0,getRow(),"Status","��");
		else
			setItemValue(0,getRow(),"Status","");

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
