<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	 /*
		Author:
		Tester:
		Describe: ��Աת��
		Input Param:
		Output Param:
		HistoryLog: zywei on 2005/08/14 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Աת��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//���������sql���
	String sSql = "";			 
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
							{"Status","�Ƿ�ת��"},
							{"UserID","�û����"},							
							{"UserName","�û�����"},
							{"OrgName","��������"}							
					   	};

	sSql = " select '' as Status,UserID,UserName,BelongOrg,getOrgName(BelongOrg) as OrgName "+
           " from USER_INFO where BelongOrg in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%') ";
	              
    //��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ÿɸ���Ŀ���
	doTemp.UpdateTable = "USER_INFO";
	//��������
	doTemp.setKey("UserID",true);	
	
	//���ò��ɼ���
	doTemp.setVisible("BelongOrg",false);
	//���ֶ��Ƿ�ɸ��£���Ҫ���ⲿ���������ģ�����UserName\OrgName	    
	doTemp.setUpdateable("OrgName",false);
	//����html���
	doTemp.setAlign("Status","2");
	doTemp.setHTMLStyle("Status","style={width:60px}  ondblclick=\"javascript:parent.onDBClickStatus()\"");		
	//���ӹ�����
	doTemp.setColumnAttribute("UserID,UserName,OrgName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//����datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
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
		   {"true","","Button","ת��","ת���û���Ϣ","transferUser()",sResourcesPath},
		   {"true","","PlainText","(˫�����ѡ��/ȡ�� �Ƿ�ת��)","(˫�����ѡ���ȡ�� �Ƿ�ת��)","style={color:red}",sResourcesPath}		
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	/*~[Describe=�һ�ѡ���轻�ӵĿͻ�;InputParam=��;OutPutParam=��;]~*/
	function onDBClickStatus()
	{
		sStatus = getItemValue(0,getRow(),"Status") ;
		if (typeof(sStatus)=="undefined" || sStatus=="")
		{
			setItemValue(0,getRow(),"Status","��");
		}
		else
			setItemValue(0,getRow(),"Status","");

	}
	
	/*~[Describe=ѡ���¼;InputParam=��;OutPutParam=��;]~*/
	function selectRecord()
	{
		var b = getRowCount(0);
		var iCount = 0;				
		for(var i = 0 ; i < b ; i++)
		{
			var a = getItemValue(0,i,"Status");
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

	/*~[Describe=ת���û�;InputParam=��;OutPutParam=��;]~*/
	function transferUser()
    {    	
    	if(!selectRecord()) return;
    	if (confirm(getBusinessMessage('952')))//ȷ��ת�Ƹ���Ա��
    	{			
			var sUserID = "";
			var sFromOrgID = "";
			var sFromOrgName = "";			
			var sToOrgID = "";
			var sToOrgName = "";
			//��ȡ��ǰ�û�
			sOrgID = "<%=CurOrg.getOrgID()%>";			
			sParaStr = "OrgID,"+sOrgID;
			sOrgInfo = setObjectValue("SelectBelongOrg",sParaStr,"",0,0);	
		    if(sOrgInfo == "" || sOrgInfo == "_CANCEL_" || sOrgInfo == "_NONE_" || sOrgInfo == "_CLEAR_" || typeof(sOrgInfo) == "undefined") 
		    {
			    alert(getBusinessMessage('953'));//��ѡ��ת�ƺ�Ļ�����
			    return;
		    }else
		    {
			    sOrgInfo = sOrgInfo.split('@');
			    sToOrgID = sOrgInfo[0];
			    sToOrgName = sOrgInfo[1];				    	    
		   
				//���ж��Ƿ�������һ���û���ѡ����ת���ˡ����е��ҳ���
				var b = getRowCount(0);
				for(var i = 0 ; i < b ; i++)
				{
	
					var a = getItemValue(0,i,"Status");
					if(a == "��")
					{
						sUserID = getItemValue(0,i,"UserID");	
						sFromOrgID = getItemValue(0,i,"BelongOrg");
						sFromOrgName = getItemValue(0,i,"OrgName");	
						if(sFromOrgID == sToOrgID)	
						{
							alert(getBusinessMessage('954'));//��������Աת����ͬһ�����н��У�������ѡ��ת�ƺ������
							return;
						}														
						//����ҳ�����
						sReturn = PopPageAjax("/SystemManage/SynthesisManage/UserShiftActionAjax.jsp?UserID="+sUserID+"&FromOrgID="+sFromOrgID+"&FromOrgName="+sFromOrgName+"&ToOrgID="+sToOrgID+"&ToOrgName="+sToOrgName+"","","dialogWidth=21;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 
						if(sReturn == "TRUE")
							alert("��Ա���("+sUserID+"),"+getBusinessMessage("955"));//��Աת�Ƴɹ���
						else if(sReturn == "FALSE")
							alert("��Ա���("+sUserID+"),"+getBusinessMessage("956"));//��Աת��ʧ�ܣ�					
					}
				}				
			}
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
