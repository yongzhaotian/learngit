<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: ҵ�����˻���ת���б����
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ҵ�����˻���ת��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%		
	//�������
	String sSql;
	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	String sHeaders[][] = {
			                    {"BCFlag","�Ƿ�ת��"},
			                    {"SerialNo","��ͬ��ˮ��"},				                                    
						        {"CustomerName","�ͻ�����"},
						        {"StatOrgName","��ͬ���ʻ���"},
						        {"BusinessTypeName","ҵ��Ʒ��"},
						        {"CurrencyName","����"},
						        {"BusinessSum","���"},
						        {"PutOutDate","��ʼ��"},
						        {"Maturity","������"}	
			               };
		
	sSql = sSql = " select '' as BCFlag,SerialNo,CustomerName,getOrgName(StatOrgID) as StatOrgName, "+
				  " StatOrgID,getBusinessName(BusinessType) as BusinessTypeName, "+
	              " getItemName('Currency',BusinessCurrency) as CurrencyName,BusinessSum, "+
	              " PutOutDate,Maturity from BUSINESS_CONTRACT where ManageOrgID in "+
	              " (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%') ";

	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ÿɸ���Ŀ���
	doTemp.UpdateTable = "BUSINESS_CONTRACT";
	doTemp.setKey("SerialNo",true);
	doTemp.setType("BusinessSum","Number");
    doTemp.setAlign("BusinessSum","3");
	doTemp.setAlign("BCFlag","2");
	//�����ֶβ��ɼ�
	doTemp.setVisible("StatOrgID",false);
	//�����ֶ���ʾ���
	doTemp.setHTMLStyle("BusinessTypeName,CustomerName,StatOrgName"," style={width:200px} ");	
	doTemp.setHTMLStyle("CurrencyName"," style={width:80px} ");	
	doTemp.setHTMLStyle("BCFlag","style={width:60px}  ondblclick=\"javascript:parent.onDBClickStatus()\"");

	//���ֶ��Ƿ�ɸ���
	doTemp.setUpdateable("BusinessTypeName,StatOrgName,CurrencyName",false);
	
	//���ɲ�ѯ����	
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","SerialNo","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");
		
	doTemp.parseFilterData(request,iPostChange);
	doTemp.haveReceivedFilterCriteria();
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));		
	
	//����ASDataWindow����
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	//����ΪGrid���
	dwTemp.Style="1";
	//����Ϊֻ��
	dwTemp.ReadOnly = "1";

	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
		{"true","","Button","ת��","ת�����˻�����Ϣ","transferContract()",sResourcesPath}	,	
		{"true","","PlainText","(˫�����ѡ��/ȡ�� �Ƿ�ת��)","(˫�����ѡ���ȡ�� �Ƿ�ת��)","style={color:red}",sResourcesPath}		
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
    	if (confirm(getBusinessMessage('926')))//ȷ��ת�Ƹú�ͬ�����˻�����
    	{			
			var iCount = 0;
			var sSerialNo = "";			
			var sFromOrgID = "";
			var sFromOrgName = "";			
			var sToOrgID = "";
			var sToOrgName = "";
			//��ȡ��ǰ����
			sOrgID = "<%=CurOrg.getOrgID()%>";
			sParaStr = "OrgID,"+sOrgID;
			sOrgInfo = setObjectValue("SelectBelongOrg",sParaStr,"",0,0);	
		    if(sOrgInfo == "" || sOrgInfo == "_CANCEL_" || sOrgInfo == "_NONE_" || sOrgInfo == "_CLEAR_" || typeof(sOrgInfo) == "undefined") 
		    {
			    alert(getBusinessMessage('927'));//��ѡ��ת�ƺ�����˻�����
			    return;
		    }else
		    {
			    sOrgInfo = sOrgInfo.split('@');
			    sToOrgID = sOrgInfo[0];
			    sToOrgName = sOrgInfo[1];			    
		   
				//���ж��Ƿ�������һ����ͬ��ѡ���������ˡ����е��ҳ���
				var b = getRowCount(0);				
				for(var i = 0 ; i < b ; i++)
				{
	
					var a = getItemValue(0,i,"BCFlag");
					if(a == "��")
					{
						sSerialNo = getItemValue(0,i,"SerialNo");	
						sFromOrgID = getItemValue(0,i,"StatOrgID");
						sFromOrgName = getItemValue(0,i,"StatOrgName");
						if(sFromOrgID == sToOrgID)	
						{
							alert(getBusinessMessage('928'));//������ҵ�����˻���ת����ͬһ�����н��У�������ѡ��ת�ƺ�����˻�����
							return;
						}														
						//����ҳ�����
						sReturn = PopPageAjax("/SystemManage/SynthesisManage/ChangeStatOrgIDActionAjax.jsp?SerialNo="+sSerialNo+"&FromOrgID="+sFromOrgID+"&FromOrgName="+sFromOrgName+"&ToOrgID="+sToOrgID+"&ToOrgName="+sToOrgName+"","","dialogWidth=21;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 
						if(sReturn == "TRUE")
							alert("��ͬ��ˮ��("+sSerialNo+"),"+getBusinessMessage("929"));//���˻���ת�Ƴɹ���
						else if(sReturn == "FALSE")
							alert("��ͬ��ˮ��("+sSerialNo+"),"+getBusinessMessage("930"));//���˻���ת��ʧ�ܣ�
						
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
