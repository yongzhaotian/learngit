<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  --fbkang 2005.7.25
		Tester:
		Content: --Ȩ������ҳ��
		Input Param:
            CustomerID���ͻ���
            UserID���û�����
            OrgID����������
            Check������־
		Output param:
			               
		History Log: fwang on 2009/06/16 ���÷����Կͻ������ϵ���߼��ж�
		History Log: fwang on 2009/06/24 ���α��水ť
		
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ�Ȩ���������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//�������������ͻ���š��û�ID������ID������־
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sUserID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("UserID"));
	String sOrgID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgID"));
    String sCheck = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Check"));
    //����ֵת��Ϊ���ַ���
    if(sCustomerID == null) sCustomerID = "";
    if(sUserID == null) sUserID = "";
    if(sOrgID == null) sOrgID = "";
    if(sCheck == null) sCheck = "";
    
%>
<%/*~END~*/%>


<%
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "RoleApplyInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	if(sCheck.equals("Y"))
	   {
	      doTemp.setReadOnly("ApplyReason",true); 
	      doTemp.setRequired("",false);
	   }
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID+","+sUserID+","+sOrgID);//�������,���ŷָ�
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
			{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
			{"true","","Button","�ύ","�ύ����","Apply()",sResourcesPath},
			{"true","","Button","��׼","��׼����","Authorize()",sResourcesPath},
			{"true","","Button","���","�������","Overrule()",sResourcesPath}
		};
	if(sCheck.equals("Y"))
	{
	   sButtons[0][0]="false";
	   sButtons[1][0]="false";
	}
	else
	{
	   sButtons[2][0]="false"; 
	   sButtons[3][0]="false";
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		if(!checkOtherRoles())
		    return;
		as_save("myiframe0",sPostEvents);
	}
    /*~[Describe=�ύ;InputParam=��;OutPutParam=��;]~*/
    function Apply()
    {
        if(!checkOtherRoles())
		    return;
        var sApplyReason =  getItemValue(0,getRow(),"ApplyReason");
        if(sApplyReason=="")
        {
            alert("��Ϣ��ȫ���ύʧ�ܣ�(��������û��)");
            return;
        }
        var sApplyAttribute =  getItemValue(0,getRow(),"ApplyAttribute");//--����Ƿ�����ͻ�����Ȩ��־
        var sApplyAttribute1 = getItemValue(0,getRow(),"ApplyAttribute1");//--����Ƿ�������Ϣ�鿴Ȩ��־
        var sApplyAttribute2 = getItemValue(0,getRow(),"ApplyAttribute2");//--����Ƿ�������Ϣά��Ȩ��־
        var sApplyAttribute3 = getItemValue(0,getRow(),"ApplyAttribute3");//--����Ƿ�����ҵ�����Ȩ��־
        if(sApplyAttribute1=="" || sApplyAttribute2=="" || sApplyAttribute3=="")
        {
            alert("��Ϣ��ȫ���ύʧ�ܣ�(����Ȩ�޲���Ϊ��)");
            return;
        }
        sCustomerID=getItemValue(0,getRow(),"CustomerID");
        sUserID = getItemValue(0,getRow(),"UserID");
        sOrgID = getItemValue(0,getRow(),"OrgID");
        //�����жϿͻ������ϵ���෽��,�����жϿͻ������ϵ�Լ�����һ����־λ
        sReturnValue = RunMethod("CustomerManage","CheckRoleApply",sCustomerID+","+sUserID+","+sOrgID);
        
        if(sApplyAttribute == "1" || sApplyAttribute1=="1" || sApplyAttribute2 == "1" || sApplyAttribute3 == "1")
        {    
            setItemValue(0,0,"ApplyStatus","1"); 
            sReturnString = PopPageAjax("/CustomerManage/GetMessageActionAjax.jsp?CustomerID="+sCustomerID,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
           	alert(sReturnString);
           	saveRecord(self.close());
        }
        else
        {
            alert("����Ҫ�ύһ��Ȩ�޵����룡");
        }
    }
    
    function Authorize()
    {
        if(!checkOtherRoles())
		    return;
        if(confirm("ȷ��ͨ����������"))
        {
            var sApplyAttribute =  getItemValue(0,getRow(),"ApplyAttribute");//--����Ƿ�����ͻ�����Ȩ��־
            var sApplyAttribute1 = getItemValue(0,getRow(),"ApplyAttribute1");//--����Ƿ�������Ϣ�鿴Ȩ��־
            var sApplyAttribute2 = getItemValue(0,getRow(),"ApplyAttribute2");//--����Ƿ�������Ϣά��Ȩ��־
            var sApplyAttribute3 = getItemValue(0,getRow(),"ApplyAttribute3");//--����Ƿ�����ҵ�����Ȩ��־
            var sApplyAttribute4 = getItemValue(0,getRow(),"ApplyAttribute4");//--��ô�����Ȩ�ޱ�־
            var sApplyReason =  getItemValue(0,getRow(),"ApplyReason");
            
            sReturn = PopPageAjax("/CustomerManage/AuthorizeRoleActionAjax.jsp?CustomerID=<%=sCustomerID%>&UserID=<%=sUserID%>&ApplyAttribute="+sApplyAttribute+"&ApplyAttribute1="+sApplyAttribute1+"&ApplyAttribute2="+sApplyAttribute2+"&ApplyAttribute3="+sApplyAttribute3+"&ApplyAttribute4="+sApplyAttribute4,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
            sReturn =  getSplitArray(sReturn);
            sHave = sReturn[0];
            sOrgName = sReturn[1];
            sUserName = sReturn[2];
            sBelongUserID = sReturn[3];
            if(sHave == "_TRUE_")
            {
                if(confirm(sOrgName+" "+sUserName+" "+"�Ѿ�ӵ�иÿͻ�������Ȩ���Ƿ������׼���������Ȩת�ƣ�ԭ������Ȩ�����Զ�ɥʧһ�пͻ�Ȩ�����������������������룡"))
                {
                    var sReturn=PopPageAjax("/CustomerManage/ChangeRoleActionAjax.jsp?CustomerID=<%=sCustomerID%>&UserID=<%=sUserID%>&BelongUserID="+sBelongUserID,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
					if(typeof(sReturn) != "undefined" && sReturn == "true"){
	                    alert("��׼�ÿͻ�Ȩ�޳ɹ���");
						self.close();
					}else{
						alert("��׼�ÿͻ�Ȩ��ʧ�ܣ�");
					}
                }
            }else
            {
                alert("��׼�ÿͻ�Ȩ�޳ɹ���");
            }
            setItemValue(0,0,"ApplyStatus","2");
            setItemValue(0,0,"ApplyAttribute",sApplyAttribute);
            setItemValue(0,0,"ApplyAttribute1",sApplyAttribute1);
            setItemValue(0,0,"ApplyAttribute2",sApplyAttribute2);
            setItemValue(0,0,"ApplyAttribute3",sApplyAttribute3);
            setItemValue(0,0,"ApplyAttribute4",sApplyAttribute4);
            setItemValue(0,0,"ApplyReason",sApplyReason);
            saveRecord(self.close());                
        }
    }
    
    function Overrule()
    {
        if(confirm("ȷ�������������"))
        {
            setItemValue(0,0,"ApplyStatus","2");
            setItemValue(0,0,"ApplyAttribute","");
            setItemValue(0,0,"ApplyAttribute1","");
            setItemValue(0,0,"ApplyAttribute2","");
            setItemValue(0,0,"ApplyAttribute3","");
            setItemValue(0,0,"ApplyAttribute4","");
            setItemValue(0,0,"ApplyReason","");
            alert("�ѷ���ÿͻ�Ȩ�����룡");
            saveRecord(self.close());  
        }
    }
    
    function checkApplyAttribute()
    {
        var sApplyAttribute = getItemValue(0,getRow(),"ApplyAttribute");//--����Ƿ�����ͻ�����Ȩ��־
        if(sApplyAttribute == "1")
        {
            setItemValue(0,0,"ApplyAttribute1","1");
            setItemValue(0,0,"ApplyAttribute2","1");
            setItemValue(0,0,"ApplyAttribute3","1");
            setItemValue(0,0,"ApplyAttribute4","1");
        }
    }
    function checkOtherRoles()
    {
        var sApplyAttribute = getItemValue(0,getRow(),"ApplyAttribute");//--����Ƿ�����ͻ�����Ȩ��־
        var sApplyAttribute1 = getItemValue(0,getRow(),"ApplyAttribute1");//--����Ƿ�������Ϣ�鿴Ȩ��־
        var sApplyAttribute2 = getItemValue(0,getRow(),"ApplyAttribute2");//--����Ƿ�������Ϣά��Ȩ��־
        var sApplyAttribute3 = getItemValue(0,getRow(),"ApplyAttribute3");//--����Ƿ�����ҵ�����Ȩ��־
        var sApplyAttribute4 = getItemValue(0,getRow(),"ApplyAttribute4");//--δ��
        
        if(sApplyAttribute == "1")
        {
            if(sApplyAttribute == "2" || sApplyAttribute2 == "2" || sApplyAttribute3 == "2" || sApplyAttribute4 == "2")
            {
                alert("���Ѿ�ѡ��������Ȩ������Ȩ�����˸���Ȩ�����������ѡ��");
                return false;
            }
        }
        
        if(sApplyAttribute2 == "1" && sApplyAttribute1 == "2")
        {            
            alert("���Ѿ�ѡ������Ϣά��Ȩ����Ϣά��Ȩ��������Ϣ�鿴Ȩ����Ϣ�鿴Ȩ����ѡ��");
            return false;    
        }
        
        return true;
    }
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

    function initRow()
    {
        var sBelongAttribute =  getItemValue(0,getRow(),"BelongAttribute");//--����Ƿ�ͻ�����Ȩ��־
        var sBelongAttribute1 = getItemValue(0,getRow(),"BelongAttribute1");//--����Ƿ����õȼ�����Ȩ��־
        var sBelongAttribute2 = getItemValue(0,getRow(),"BelongAttribute2");//--����Ƿ���Ϣ�鿴Ȩ��־
        var sBelongAttribute3 = getItemValue(0,getRow(),"BelongAttribute3");//--����Ƿ���Ϣά��Ȩ��־
        var sBelongAttribute4 = getItemValue(0,getRow(),"BelongAttribute4");//--����Ƿ�ҵ�����Ȩ��־
        
        var sApplyStatus = getItemValue(0,getRow(),"ApplyStatus");//--����Ƿ��ύ�����־

		if(sApplyStatus != "1")
		{
	        if(sBelongAttribute == "1")
	        	setItemValue(0,0,"ApplyAttribute","1");
			else 
			 	setItemValue(0,0,"ApplyAttribute","2");
			
		    if(sBelongAttribute1 == "1")
	        	setItemValue(0,0,"ApplyAttribute1","1");
			else 
			 	setItemValue(0,0,"ApplyAttribute1","2");
			
			if(sBelongAttribute2 == "1")
	        	setItemValue(0,0,"ApplyAttribute2","1");
	    	else 
			 	setItemValue(0,0,"ApplyAttribute2","2");
		
	        if(sBelongAttribute3 == "1")
	        	setItemValue(0,0,"ApplyAttribute3","1");
	        else 
			 	setItemValue(0,0,"ApplyAttribute3","2");
		
	        if(sBelongAttribute4 == "1")
	        	setItemValue(0,0,"ApplyAttribute4","1");
	        else 
			 	setItemValue(0,0,"ApplyAttribute4","2"); 
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

<script type="text/javascript">	
    //����ʾҳ�����޸�
	function isModified(objname)
	{
		return false;
	}
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>
