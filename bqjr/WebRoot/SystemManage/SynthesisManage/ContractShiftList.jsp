<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: ��ͬת���б����
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ͬת��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%//���ҳ�����
//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
//if(sInputUser==null) sInputUser="";

//ͨ��DWģ�Ͳ���ASDataObject����doTemp
String sTempletNo = "ContractShiftList";//ģ�ͱ��
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
for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));%>
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
		{"true","","Button","ת��","ת�ƺ�ͬ��Ϣ","transferContract()",sResourcesPath}	,
		{"true","","PlainText","(˫�����ѡ��/ȡ�� �Ƿ�ת��)","(˫�����ѡ��/ȡ�� �Ƿ�ת��)","style={color:red}",sResourcesPath}		
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=ת�ƺ�ͬ;InputParam=��;OutPutParam=��;]~*/	
	function transferContract()
    {    	
    	if(!selectRecord()) return;
    	if (confirm(getBusinessMessage("936")))//ȷ��ת�Ƹú�ͬ��
    	{				
			var sSerialNo = "";			
			var sFromOrgID = "";
			var sFromOrgName = "";
			var sFromUserID = "";
			var sFromUserName = "";
			var sToUserID = "";
			var sToUserName = "";
			//��ȡ��ǰ����
			sSortNo = "<%=CurOrg.getSortNo()%>";
			sParaStr = "SortNo,"+sSortNo;
			sUserInfo = setObjectValue("SelectUserInOrg",sParaStr,"",0,0);	
		    if(sUserInfo == "" || sUserInfo == "_CANCEL_" || sUserInfo == "_NONE_" || sUserInfo == "_CLEAR_" || typeof(sUserInfo) == "undefined") 
		    {
			    alert(getBusinessMessage("937"));//��ѡ��ת�ƺ�Ŀͻ�����
			    return;
		    }else
		    {
			    sUserInfo = sUserInfo.split('@');
			    sToUserID = sUserInfo[0];
			    sToUserName = sUserInfo[1];			    
		   
				//��ȡ������Ϣ����,����ͬʱѡ�������¼���ӵģ��˴�ѡ��ֻ����һ��	
				sChangeObject = PopPage("/SystemManage/SynthesisManage/ContractShiftDialog.jsp","","dialogWidth=24;dialogHeight=16;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 													
				if(sChangeObject != "_CANCEL_" && typeof(sChangeObject) != "undefined")
				{
					//���ж��Ƿ�������һ����ͬ��ѡ���������ˡ����е��ҳ���
					var b = getRowCount(0);				
					for(var i = 0 ; i < b ; i++)
					{
						var a = getItemValue(0,i,"BCFlag");
						if(a == "��")
						{
							sSerialNo = getItemValue(0,i,"SerialNo");	
							sFromOrgID = getItemValue(0,i,"ManageOrgID");
							sFromOrgName = getItemValue(0,i,"ManageOrgName");
							sFromUserID = getItemValue(0,i,"ManageUserID");
							sFromUserName = getItemValue(0,i,"ManageUserName");	
							if(sFromUserID == sToUserID)
							{
								alert(getBusinessMessage("938"));//�������ͬת����ͬһ�ͻ��������У�������ѡ��ת�ƺ�Ŀͻ�����
								return;
							}	
						
							//����ҳ�����
							sReturn = PopPageAjax("/SystemManage/SynthesisManage/ContractShiftActionAjax.jsp?SerialNo="+sSerialNo+"&FromOrgID="+sFromOrgID+"&FromOrgName="+sFromOrgName+"&FromUserID="+sFromUserID+"&FromUserName="+sFromUserName+"&ToUserID="+sToUserID+"&ToUserName="+sToUserName+"&ChangeObject="+sChangeObject,"","dialogWidth=21;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 
							if(sReturn == "TRUE")
								alert("��ͬ��ˮ��("+sSerialNo+"),"+getBusinessMessage("939"));//��ͬת�Ƴɹ���
							else if(sReturn == "FALSE")
								alert("��ͬ��ˮ��("+sSerialNo+"),"+getBusinessMessage("940"));//��ͬת��ʧ�ܣ�
							else if(sReturn == "NOT")
								alert("��ͬ��ˮ��("+sSerialNo+"),"+getBusinessMessage("941"));//���ܿͻ�����Ըú�ͬ�Ŀͻ�û��ҵ�����Ȩ������ת�ƣ�
						}
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
		sBCFlag = getItemValue(0,getRow(),"BCFlag") ;
		if (typeof(sBCFlag) == "undefined" || sBCFlag == "")
			setItemValue(0,getRow(),"BCFlag","��");
		else
			setItemValue(0,getRow(),"BCFlag","");

	}
	
	/*~[Describe=ѡ���¼;InputParam=��;OutPutParam=��;]~*/
	function selectRecord()
	{
		var b = getRowCount(0);
		var iCount = 0;				
		for(var i = 0 ; i < b ; i++)
		{
			var a = getItemValue(0,i,"BCFlag");
			if(a == "��")
				iCount = iCount + 1;
		}
		
		if(iCount == 0)
		{
			alert(getHtmlMessage('24'));//������ѡ��һ����Ϣ��
			return false;
		}
		
		return true;
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
