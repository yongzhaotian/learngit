<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zxu 2005-03-10
		Tester:
		Content: ��Ұ���б�
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ұ���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	String sSortNo; //������
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	  String sTempletNo = "SightSetList"; //ģ����
	 ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);	

	//��ѯ
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

/*** ������Ұ������ begin by zxu 2005/03/11 ******
	//������Ұ
	ASDataSight ads = new ASDataSight("OrgSight",Sqlca,CurARE);
	ads.setAttribute("orgid","����������Ұ");
	ads.setAttribute("userid","OrgSight");
	doTemp.WhereClause+= ads.getSightWhereClause();
******** end by zxu 2005/03/11 ******************/

	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(200);

	//��������¼�
	dwTemp.setEvent("BeforeDelete","!Configurator.DelSightSet(#SightSetID)");
	
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
		{"true","","Button","��Ұ�б�","�鿴/�޸���Ұ�б�","viewAndEdit2()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
    var sCurCodeNo=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
        sReturn=popComp("SightSetInfo","/Common/Configurator/SightManage/SightSetInfo.jsp","","");
	reloadSelf();
/**
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            //�������ݺ�ˢ���б�
            if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
            {
                sReturnValues = sReturn.split("@");
                if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
                {
                    OpenPage("/Common/Configurator/SightManage/SightSetInfo.jsp","_self","");    
                }
            }
        }
**/        
	}
	
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
            sSightSetID = getItemValue(0,getRow(),"SightSetID");
            if(typeof(sSightSetID)=="undefined" || sSightSetID.length==0) {
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
                return ;
	    }
            //openObject("SightSetView",sSightSetID,"001");
	sReturn=popComp("SightSetInfo","/Common/Configurator/SightManage/SightSetInfo.jsp","SightSetID="+sSightSetID,"");
	reloadSelf();
/*
	if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
	{
		//�������ݺ�ˢ���б�
		if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
		{
			sReturnValues = sReturn.split("@");
			if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
			{
				OpenPage("/Common/Configurator/SightManage/SightSetInfo.jsp?SightSetID="+sReturnValues[0],"_self","");    
			}
		}
	}
*/        
	}
    
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit2()
	{
        	sSightSetID = getItemValue(0,getRow(),"SightSetID");
        	if(typeof(sSightSetID)=="undefined" || sSightSetID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            		return ;
		}
        	popComp("SightList","/Common/Configurator/SightManage/SightList.jsp","SightSetID="+sSightSetID,"");
        	
	}

    
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSightSetID = getItemValue(0,getRow(),"SightSetID");
        	if(typeof(sSightSetID)=="undefined" || sSightSetID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            		return ;
		}
		
		if(confirm(getHtmlMessage('45'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
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
