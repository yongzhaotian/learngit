<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: �������ݲ�ѯ
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������ݲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�������ݲ�ѯ&nbsp;&nbsp;";
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//--���sql���
	String doWhere="";
    ASResultSet rs = null;
    ASResultSet rs1 = null;
    ASResultSet rs2 = null;
    String roleID="";
	//����������	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
//	String userID=CurUser.getUserID();
	String userID="200548";
	StringBuffer sb=new StringBuffer();
	StringBuffer snos=new StringBuffer();//�ŵ� ƴ�� 
	rs=Sqlca.getASResultSet(new SqlObject("select roleid from user_role where userid=:userid order by roleid").setParameter("userid", userID));
	while(rs.next()){
		roleID=rs.getString("roleid");
		//�����½��ԱΪ���о���
		if("1004".equals(roleID)){
			//�ŵ���г��о���ά���������۾�����ϼ�ȡ�� edit by Dahl 2015-3-20
	 	    doWhere =" and exists (select sno from store_info si ,user_info ui where si.salesmanager=ui.userId and ui.superid='"+userID+"' and si.sno=bc.stores)";
	//		rs2=Sqlca.getASResultSet(new SqlObject("select sno from store_info where citymanager=:citymanager").setParameter("citymanager", userID));
	//		while(rs2.next()){
	//			snos.append("'"+rs2.getString("sno")+"',");
	//		}
	//		if(snos.toString().equals("")){
    //	        doWhere=" and 1=2 ";
	//       }else{
	//	      doWhere=" and stores in("+snos.toString().substring(0,snos.toString().length()-1)+")";
	//       }
	//		rs2.getStatement().close();
		    break;
		}
		
		//�����½��ԱΪ���۾��� 
		if("1005".equals(roleID)){
			doWhere =" and exists (select sno from store_info si where salesmanager='"+userID+"' and si.sno=bc.stores)";
//			rs1=Sqlca.getASResultSet(new SqlObject("select sno from store_info where salesmanager=:salesmanager").setParameter("salesmanager", userID));
//			while(rs1.next()){
//		    		snos.append("'"+rs1.getString("sno")+"',");
//		    	}
//		  	    if(snos.toString().equals("")){
//	    	        doWhere=" and 1=2 ";
//		        }else{
//		 	       doWhere=" and stores in("+snos.toString().substring(0,snos.toString().length()-1)+")";
//		        }
//			    	rs1.getStatement().close();
		         break;
		}
	
		//�����¼��Ϊ���۴��� 
	    if("1006".equals(roleID)){
	    	sb.append("'"+userID+"'");
	    	doWhere=" and inputuserid in ("+sb.toString()+")";
	    }
		
	}
	rs.getStatement().close();

     
	//����sSql�������ݶ���

	String sTempletNo = "SalesQueryList"; //ģ����
    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//doTemp.setKeyFilter("SerialNo");
	//���ɲ�ѯ��
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	
	if(!doTemp.haveReceivedFilterCriteria()){
		 doTemp.WhereClause+=" and 1=2";
	}else{
		doTemp.WhereClause+=doWhere;
	}
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
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
			{"true","","Button","��ϸ��Ϣ","��ϸ��Ϣ","viewAndEdit()",sResourcesPath},

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
		//���ҵ����ˮ��
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		
	    sObjectType = "BusinessContract";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			sCompID = "CreditTab";
    		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
    		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sSerialNo;
    		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}

	}
	
	function CreditSettle(){
		sObjectNo =getItemValue(0,getRow(),"SerialNo");	
		sObjectType = "CreditSettle";
		sExchangeType = "";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		//������֪ͨ���Ƿ��Ѿ�����
		var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if (sReturn == "false"){ //δ���ɳ���֪ͨ��
			//���ɳ���֪ͨ��	
			PopPage("/FormatDoc/Report13/7001.jsp?DocID=7001&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sObjectNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		}
		//��ü��ܺ�ĳ�����ˮ��
		var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
		
		//ͨ����serverlet ��ҳ��
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
		//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
		OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
		
		
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
