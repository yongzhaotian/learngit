<%@page import="com.amarsoft.app.util.ASUserObject"%>
<%@page import="com.amarsoft.app.als.customer.common.action.GetCustomer"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.are.jbo.JBOFactory"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   lyin 2012-12-20
		Tester:
		Content:  �������ų�Աҳ��
		Input Param:	  
		Output param:
	 */
	%>
<%/*~END~*/%> 


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ſͻ��ſ�"; // ��������ڱ���
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
		//��ȡ����  ���ű�ţ����ڵ㣬 ��Ա��ţ� �汾�� 
		String sGroupID= CurPage.getParameter("GroupID");
	    String sParentMemberID = CurPage.getParameter("ParentMemberID");
	    String sMemberCustomerID = CurPage.getParameter("MemberCustomerID");
		String sRefVersionSeq=CurPage.getParameter("RefVersionSeq");
	    
		if(sGroupID == null) sGroupID = "";
		if(sParentMemberID == null) sParentMemberID = "";
		if(sMemberCustomerID == null) sMemberCustomerID = "";
		if(sRefVersionSeq == null) sRefVersionSeq = "";
%>
<%/*~END~*/%> 
 
 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
<%	
		String sTempletNo = "MemberInfoViewInfo";
		String sTempletFilter = "1=1";
		
		ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		
		dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    
	    doTemp.setDefaultValue("ParentMemberID",sParentMemberID);
		doTemp.setDefaultValue("MemberCustomerID",sMemberCustomerID);
		doTemp.setDefaultValue("GroupID",sGroupID);
		doTemp.setDefaultValue("VersionSeq",sRefVersionSeq);
		
		int icount=JBOFactory.getBizObjectManager("jbo.app.GROUP_FAMILY_MEMBER")
								.createQuery("O.GroupID =:GroupID  AND O.VersionSeq =:VersionSeq  AND O.MemberCustomerID =:MemberCustomerID")
								.setParameter("GroupID",sGroupID)
								.setParameter("VersionSeq",sRefVersionSeq)
								.setParameter("MemberCustomerID",sMemberCustomerID)
								.getTotalCount();
		
	    //����HTMLDataWindow
	    Vector vTemp = dwTemp.genHTMLDataWindow(sGroupID+","+sRefVersionSeq+","+sMemberCustomerID);
	    for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));   
%>
<%/*~END~*/%> 
 
 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
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
	        {"true","","Button","����","���������޸�","doReturn()","","","",""},
	        {"false","","Button","����","�����б�ҳ��","goBack()","","","",""}
	        };
	%> 
<%/*~END~*/%>

 
<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
<script language=javascript>
    var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	icount=<%=icount%>;
	function doReturn(){
		initSerialNo();
		var sShareValue = getItemValue(0,getRow(),"ShareValue");
		if(parseFloat(sShareValue)>100 || parseFloat(sShareValue)<0){
			alert("�ֹɱ���������[0,100]");
			return;
		}
		var sParentRelationType = getItemValue(0,getRow(),"ParentRelationType");
		var sMemberCustomerID = getItemValue(0,getRow(),"MemberCustomerID");
		var sAddReason = getItemValue(0,getRow(),"ATT01");
		if(sMemberCustomerID=="" || sMemberCustomerID==""){
			alert("��ѡ��ͻ���");
			return;
		}

		if(sAddReason==""){
			alert("��ѡ������Աԭ��");
			return;
		}

		if(icount>0){ //����
			as_save("myiframe0","myReturn();");
		}else{ //����
			//����Ա�Ƿ�������������
			var sGroupID= getItemValue(0,getRow(),"GroupID");
			RunJavaMethod("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","forDeleteGroupmember","MemberCustomerID="+sMemberCustomerID+",GroupID="+sGroupID);
	 		var sReturn = RunJavaMethod("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","isGroupCustomer","MemberCustomerID="+sMemberCustomerID+",GroupID="+sGroupID);
	 		if(sReturn!="true"){
				alert(sReturn);
				return;
			}
	 		if(sShareValue==""){
	 		    alert("������ֹɱ���!");
	 		    return;
	 		}
	 	   // as_save("myiframe0","myReturn();");
	 	    alert("���ݱ���ɹ�");
 			myReturn();
		}
	}

	function goBack(){
		top.close();
	}
	
</script>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
<script language=javascript>
	function myReturn()
	{
		var oReturn = {};
		oReturn["MemberCustomerID"] = getItemValue(0,getRow(),"MemberCustomerID");
		oReturn["MemberName"] = getItemValue(0,getRow(),"MemberName");
		oReturn["ParentMemberID"] = getItemValue(0,getRow(),"ParentMemberID");
		oReturn["MemberCertType"] = getItemValue(0,getRow(),"MemberCertType");
		oReturn["MemberCertID"] = getItemValue(0,getRow(),"MemberCertID");
		oReturn["MemberType"] = getItemValue(0,getRow(),"MemberType");
		oReturn["ShareValue"] = getItemValue(0,getRow(),"ShareValue");
		oReturn["AddReason"] = getItemValue(0,getRow(),"ATT01");
		oReturn["ParentRelationType"] = getItemValue(0,getRow(),"ParentRelationType");
		top.returnValue = oReturn;
		top.close();  
	}
	
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer(){
		//���ؿͻ��������Ϣ���ͻ����롢�ͻ����ơ�֤�����͡��ͻ�֤������
		var sRet = AsDialog.OpenSelector("SelectKeyMemberCustomerID","","@MemberCustomerID@0@MemberName@1@MemberCertType@3@MemberCertID@4",0,0,"");
		if(sRet == "_CANCEL_") {sRet="@@@@"};
		if(sRet) {
        	sRet = sRet.split("@");
        	setItemValue(0,getRow(),"MemberCustomerID",sRet[0]);
        	setItemValue(0,getRow(),"MemberName",sRet[1]);
        	setItemValue(0,getRow(),"MemberCertType",sRet[2]);
        	setItemValue(0,getRow(),"MemberCertID",sRet[3]);
        }
	}
	
	function selectParentCustomer(){

	}
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "GROUP_FAMILY_MEMBER";//����
		var sColumnName = "MemberID";//�ֶ���
		var sPrefix = "";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0){ //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
			as_add("myiframe0");//������¼
			bIsInsert = true;
		}

    }
</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>