<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: ybwei  2009-06-18
*
*	Tester:
*	Describe: ÿ��У������ѯ
*	Input Param:
*	Output Param:     
*	HistoryLog:
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "У����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%/*~END~*/%>         
                      
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
							{"checkflow","��κ�"},
							{"Occurdate","��������"},
							{"Loanaccount","�ʺ�"},
							{"Subject","��Ŀ"},
							{"Orgname","��������"},
							{"errorcode","������"},
							{"ErrorDescribe","����"}
						}; 


 	String sSql = "select Serialno,checkflow,Occurdate,Loanaccount,Subject,getOrgName(orgid) as Orgname,errorcode,ErrorDescribe from Check_log " +
 				  "where 1=1 and orgid in (select orgid from org_info where SortNo like '"+CurOrg.getSortNo()+"%') order by Occurdate desc";


	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);	
	doTemp.setKey("Serialno",true);
	doTemp.setVisible("Serialno",false);	
	doTemp.setHTMLStyle("Loanaccount,Subject,Orgname"," style={width:120px} ");
	doTemp.setHTMLStyle("ErrorDescribe"," style={width:350px} ");
	doTemp.setCheckFormat("Occurdate","3");
	//doTemp.setAlign("Loanaccount","3");  //���ֿ���
	//���ÿɸ���Ŀ���
	doTemp.UpdateTable = "Check_log";   
	
	//���ɲ�ѯ����
	doTemp.setColumnAttribute("checkflow,Subject,Loanaccount,ErrorDescribe,Orgname,Occurdate","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
	dwTemp.setPageSize(40); 	//��������ҳ
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
				

	//String sCriteriaAreaHTML = ""; //��ѯ����ҳ�����
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
		{"true","","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath},
		{"true","","PlainText","���ڱ�ҳ��������������ͨ����ѯ������ѯ","���ڱ�ҳ��������������ͨ����ѯ������ѯ","style={color:red}",sResourcesPath}			
	};
%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">

	//---------------------ɾ���¼�------------------------------------
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"Serialno");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}
	}	
	
</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	showFilterArea();
</script>
<%/*~END~*/%>

<%@include file="/IncludeEnd.jsp"%>
