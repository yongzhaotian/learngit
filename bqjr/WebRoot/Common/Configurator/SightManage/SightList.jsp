<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zxu 2005-03-10
		Tester:
		Content: ��Ұ�б�
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ұ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	String sSortNo; //������
	
    //���ҳ�����	
	String sSightSetID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SightSetID"));
    	if (sSightSetID == null) 
        	sSightSetID = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	


	
    String sTempletNo = "SightList"; //ģ����
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);	

	//��ѯ

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	if(sSightSetID !=null && !sSightSetID.equals(""))
	{
		doTemp.WhereClause+=" And SightSetID='"+sSightSetID+"'";
	}
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";

    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(200);
    
	//��������¼�
	dwTemp.setEvent("BeforeDelete","!Configurator.DelSightRight(#SightSetID)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
    	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
    	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
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
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","��鲢����","�﷨��鲢ע���Ȩ�޵�","checkAndRegRight('Y')",sResourcesPath},
		{"true","","Button","ͣ��","ֹͣʹ��","checkAndRegRight('N')",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		// Del by wuxiong 2005-02-22 �򷵻���TreeView�л��д��� {"true","","Button","����","����","doReturn('N')",sResourcesPath}
		};

    %> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	var sCurSightSetID=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
            sReturn=popComp("SightInfo","/Common/Configurator/SightManage/SightInfo.jsp","SightSetID=<%=sSightSetID%>","");
            //�޸����ݺ�ˢ���б�
		reloadSelf();
/**
            if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
            {
                sReturnValues = sReturn.split("@");
                if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
                {
                    OpenPage("/Common/Configurator/SightManage/SightList.jsp?SightSetID="+sReturnValues[0],"_self","");           
                }
            }
***/        
	}
	
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
        sSightSetID = getItemValue(0,getRow(),"SightSetID");
        sSightID = getItemValue(0,getRow(),"SightID");
        if(typeof(sSightID)=="undefined" || sSightID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
        sReturn=popComp("SightInfo","/Common/Configurator/SightManage/SightInfo.jsp","SightSetID="+sSightSetID+"&SightID="+sSightID,"");
        //�޸����ݺ�ˢ���б�
	reloadSelf();
/**
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            sReturnValues = sReturn.split("@");
            if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
            {
                OpenPage("/Common/Configurator/SightManage/SightList.jsp?SightSetID="+sReturnValues[0],"_self","");           
            }
        }
**/
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSightID = getItemValue(0,getRow(),"SightID");
        	if(typeof(sSightID)=="undefined" || sSightID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            		return ;
		}
		
		if(confirm(getHtmlMessage('2'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
    /*~[Describe=����;InputParam=sOper("Y-��鲢���ã� N-ͣ��");OutPutParam=��;]~*/
	function checkAndRegRight(sOper){
		sSightSetID = getItemValue(0,getRow(),"SightSetID");
		sSightID = getItemValue(0,getRow(),"SightID");
		sSightWhereClause = getItemValue(0,getRow(),"SightWhereClause");
        	if(typeof(sSightSetID)=="undefined" || sSightSetID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            		return ;
		}
        	if(typeof(sSightID)=="undefined" || sSightID.length==0 || typeof(sSightWhereClause)=="undefined" || sSightWhereClause.length==0) {
			alert("��Ϣ��������������Ұ��ź������Ӿ��Ƿ���䣡");
            		return ;
		}
		sReturn = PopPage("/Common/Configurator/SightManage/ChkAndRegRight.jsp?SightSetID="+sSightSetID+"&SightID="+sSightID+"&Oper="+sOper,"","dialogLeft="+(sScreenWidth*0.3)+";dialogWidth="+(sScreenWidth*0.4)+"px;dialogHeight="+(sScreenHeight*0.3)+"px;resizable=yes;status:yes;maximize:yes;help:no;");
		if(sReturn=="succeeded"){
			reloadSelf();
		}
	}

    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"SightSetID");
        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	
	function mySelectRow()
	{
        
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
