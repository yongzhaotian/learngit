<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	 /*
		Author:
		Tester:
		Describe: �û���ɫת��
		Input Param:
		Output Param:
		HistoryLog: zywei on 2005/08/14 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�û���ɫת��"; // ��������ڱ��� <title> PG_TITLE </title>
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
		   {"true","","Button","ת��","ת���û���ɫ��Ϣ","transferRole()",sResourcesPath},
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

	/*~[Describe=ת���û���ɫ;InputParam=��;OutPutParam=��;]~*/
	function transferRole()
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
			alert(getBusinessMessage('948'));//��ѡ���û���
			return;
		}
    	if (confirm(getBusinessMessage('949')))//ȷ��ת�Ƹ��û���ɫ��
    	{			
			var sUserID = "";
			var sFromOrgID = "";			
			var sFromUserID = "";
			var sFromUserName = "";			
			var sToUserID = "";	
			
			//��ȡ��ǰ�û�
			var sOrgID = "<%=CurOrg.getOrgID()%>";
			var sParaString = "BelongOrg"+","+sOrgID
			sUserInfo = setObjectValue("SelectUserBelongOrg",sParaString,"",0);	
		    if (sUserInfo == "" || sUserInfo == "_CANCEL_" || sUserInfo == "_NONE_" || sUserInfo == "_CLEAR_" || typeof(sUserInfo) == "undefined") 
		    {
			    alert(getBusinessMessage('950'));//��ѡ��ת�ƺ���û���
			    return;
		    }else
		    {
			    sUserInfo = sUserInfo.split('@');
			    sToUserID = sUserInfo[0];			   			    	    
		   
				//���ж��Ƿ�������һ���û���ѡ����ת���ˡ����е��ҳ���
				var b = getRowCount(0);
				for(var i = 0 ; i < b ; i++)
				{
	
					var a = getItemValue(0,i,"Status");
					if(a == "��")
					{
						sFromUserID = getItemValue(0,i,"UserID");	
						sFromUserName = getItemValue(0,i,"UserName");	
						sFromOrgID = getItemValue(0,i,"BelongOrg");
						if(sFromUserID == sToUserID)	
						{
							alert(getBusinessMessage('951'));//�������û���ɫת����ͬһ�û�����У�������ѡ��ת�����û���
							return;
						}														
						//����ҳ�����
						sReturn = PopPage("/SystemManage/SynthesisManage/RoleSetting.jsp?Action=UserRole&FromOrgID="+sFromOrgID+"&UserID="+sFromUserID+"&ToUserID="+sToUserID+"&UserName="+sFromUserName+"&rand="+randomNumber(),"","dialogWidth=45;dialogheight=17;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");	
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
