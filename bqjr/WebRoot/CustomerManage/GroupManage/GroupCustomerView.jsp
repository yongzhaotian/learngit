<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
    <%
    /*
        Author:   lyin 2012-12-28
        Tester: 
        Content: ���ſͻ���ѯ��Ϣ�б�
        Input Param:   
        Output Param:  
    */
    %>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
    <%
    String PG_TITLE = "���ſͻ���ѯ"   ; // ��������ڱ��� <title> PG_TITLE </title>  
    %>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sCurBranchOrg=""; //��ǰ�û����ڷ���
	String sUserID =CurUser.getUserID();
	String sOrgID=CurUser.getOrgID();
	String sCurBranchSortNo = ""; //��ǰ�û����ڷ��е�SortNo
	String sTempletNo = "";//ģ��
	String sRight="ReadOnly";
	String sRoleID="";

	//����������    ���ͻ�����
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));
	if(sCustomerType == null) sCustomerType = "";

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%    
    //000��ϵͳ����Ա��036�����м��ż��ײ�ѯ��
    //080: ���пͻ�����,280�����пͻ�����480��֧�пͻ����� 
    //236: ���м��ż��ײ�ѯ�ڣ�436��֧�м��ż��ײ�ѯ��

   	if(CurUser.hasRole("000")|| CurUser.hasRole("036")) sTempletNo="GroupCustomerList1";
   	else if(CurUser.hasRole("080")|| CurUser.hasRole("280")|| CurUser.hasRole("480")) sTempletNo="GroupCustomerList2";
   	else if(CurUser.hasRole("236")|| CurUser.hasRole("436")) sTempletNo="GroupCustomerList3";
    	
    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
    
    //���ӹ����� 
    doTemp.generateFilters(Sqlca);
    doTemp.parseFilterData(request,iPostChange);
    CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    
    //����DataWindow
    ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
    dwTemp.setPageSize(20); //������datawindows����ʾ������
    dwTemp.Style="1"; //����DW��� 1:Grid 2:Freeform
    dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    
    //����HTMLDataWindow
    Vector vTemp = dwTemp.genHTMLDataWindow(sUserID+","+sOrgID);	
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
        //6.��ԴͼƬ·��{"true","","Button","�ܻ�Ȩת��","�ܻ�Ȩת��","ManageUserIdChange()",sResourcesPath}
    String sButtons[][] = {
             {"true","","Button","��������","��������","viewGroupInfo()",sResourcesPath},
             };
    %> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
    <%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

   
<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script language=javascript>
   
    /*~[Describe=���Ÿſ�;InputParam=��;OutPutParam=��;]~*/
	function viewGroupInfo(){
      	var sGroupID = getItemValue(0,getRow(),"GroupID");
		var sMgtOrgID=getItemValue(0,getRow(),"MgtOrgID");
		var sMgtUserID=getItemValue(0,getRow(),"MgtUserID");
		var sKeyMemberCustomerID=getItemValue(0,getRow(),"KeyMemberCustomerID");
		var sGroupName=getItemValue(0,getRow(),"GroupName");
		var sGroupType2=getItemValue(0,getRow(),"GROUPTYPE2");
		
      	if (typeof(sGroupID)=="undefined" || sGroupID.length==0){
      	    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
      	
	    var sRightType="<%=sRight %>";
		
		//�򿪼�������ҳ��
		AsControl.PopView("/CustomerManage/CustomerDetailTab.jsp","GroupID="+sGroupID+"&GroupName="+sGroupName+"&GroupType2="+sGroupType2+"&MgtOrgID="+sMgtOrgID+"&MgtUserID="+sMgtUserID+"&KeyMemberCustomerID="+sKeyMemberCustomerID+"&RightType="+sRightType,"");
	    reloadSelf();	
	}  
    </script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
    AsOne.AsInit();
    init(); 
    var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
    my_load(2,0,'myiframe0');
</script>   
<%/*~END~*/%>

   
<%@ include file="/IncludeEnd.jsp"%>