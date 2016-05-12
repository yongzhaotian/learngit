<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
	  Author:   2005-7-25 fbkang 
	  Tester:
	  Content: --�����Ŀ��Ϣ
	  Input Param:
	           ObjectType��--��������(Enterprise,BusinessApply,BusinessApprove,BusinessContract)
	           ObjectNo: --������
	  Output param:
	            ObjectType��--��������
	       	    ObjectNo:--������
	            ProjectNo��--��Ŀ���
	                   
	  History Log:
 
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ŀ��Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sObjectNo="";//--������
	String sCustomerID="";//--�ͻ�����
	//���ҳ�����	
	
	//����������	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	if(sObjectType == null) sObjectType = "";
	if(sObjectType.equals("Customer"))
	{
	 	sObjectNo=  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	}else
	{
		sObjectNo   =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
		sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	}
		       
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ProjectList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo+","+sObjectType);
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
		{"true","All","Button","����","������Ŀ��Ϣ","newRecord()",sResourcesPath},
		{"true","All","Button","����","������Ŀ","doImport()",sResourcesPath},
		{"true","","Button","����","�鿴��Ŀ����","viewAndEdit()",sResourcesPath},
		{"true","All","Button","ɾ��","ɾ����Ŀ��Ϣ","deleteRecord()",sResourcesPath},
		};
	if(sObjectType!=null && sObjectType.equals("Customer"))
		sButtons[1][0]="false";
	
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	var thisObjectInfo = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>";
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{		
		var sProjectInfo = PopPage("/CustomerManage/EntManage/AddProjectDialog.jsp?"+thisObjectInfo,"","resizable=yes;dialogWidth=20;dialogHeight=11;center:yes;status:no;statusbar:no");
		if(typeof(sProjectInfo) != "undefined" && sProjectInfo.length != 0)
		{			
			sProjectInfo = sProjectInfo.split("@");
			sProjectType = sProjectInfo[0];
			sProjectName= sProjectInfo[1];
			var sReturnValue=PopPageAjax("/CustomerManage/EntManage/AddProjectActionAjax.jsp?"+thisObjectInfo+sProjectInfo,"","resizable=yes;dialogWidth=21;dialogHeight=19;center:yes;status:no;statusbar:no");
			if(typeof(sReturnValue) != "undefined" && sReturnValue.length != 0)	
			OpenComp("ProjectView","/CustomerManage/EntManage/ProjectView.jsp","ComponentName=��Ŀ��Ϣ��ͼ&ComponentType=MainWindow&ObjectNo="+sReturnValue+"&ObjectType=<%=sObjectType%>","_blank",OpenStyle)
		  	reloadSelf();
		}
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
	    sUserID=getItemValue(0,getRow(),"InputUserID");//--�û�����
		sProjectNo = getItemValue(0,getRow(),"ProjectNo");//--��Ŀ���	
	    //�ж��Ƿ���ɾ��Ȩ��
		var sReturnValue=PopPageAjax("/CustomerManage/EntManage/AddCheckProjectActionAjax.jsp?ObjectNo=<%=sObjectNo%>&ProjectNo="+sProjectNo,"","");
		//����ֵΪ��YES������ɾ��������ֵΪ'NO'����ɾ��
		if (sReturnValue=="NO")
		{
			 alert(getBusinessMessage('157'));//����Ŀ��ҵ����Ϣ���Ѿ�¼�룬����ɾ����
			 return;
		}
		if (typeof(sProjectNo)=="undefined" || sProjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else if(sUserID=='<%=CurUser.getUserID()%>')
		{
    		if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
    		{
    			as_del('myiframe0');
    			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
    		}
		}else alert(getHtmlMessage('3'));		
	}
	
	/*~[Describe=������Ŀ��Ϣ;InputParam=sObjectType,ObjectNo;OutPutParam=��;]~*/
	function doImport()
	{   
		//��ȡҵ���������Ŀ��ˮ��	
		sParaString = "ObjectType"+","+"Customer"+","+"ObjectNo"+","+"<%=sCustomerID%>";
		var sProjectInfo = setObjectValue("SelectProject",sParaString,"",0,0,"");
		if(typeof(sProjectInfo) != "undefined" && sProjectInfo != "") 
		{
			sProjectInfo = sProjectInfo.split('@');
			sProjectNo = sProjectInfo[0];
		}
		
		//���ѡ������Ŀ��Ϣ�����жϸ���Ŀ�Ƿ��Ѻ͵�ǰ��ҵ�����˹�����������������ϵ��
		if(typeof(sProjectNo) != "undefined" && sProjectNo != "" && sProjectNo != "_CLEAR_") 
		{
			sReturn = RunMethod("PublicMethod","GetColValue","ProjectNo,PROJECT_RELATIVE,String@ObjectNo@" + "<%=sObjectNo%>" + "@String@ObjectType@" + "<%=sObjectType%>" + "@String@ProjectNo@" + sProjectNo);
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{			
				sReturn = sReturn.split('~');
				var my_array = new Array();
				for(i = 0;i < sReturn.length;i++)
				{
					my_array[i] = sReturn[i];
				}
				
				for(j = 0;j < my_array.length;j++)
				{
					sReturnInfo = my_array[j].split('@');				
					if(typeof(sReturnInfo) != "undefined" && sReturnInfo != "")
					{						
						if(sReturnInfo[0] == "projectno")
						{
							if(typeof(sReturnInfo[1]) != "undefined" && sReturnInfo[1] != "" && sReturnInfo[1] == sProjectNo)
							{
								alert(getBusinessMessage('158'));//��ѡ��Ŀ�ѱ���ҵ������,�����ٴ����룡
								return;
							}
						}				
					}
				}			
			}
			else{
				//����ҵ������ѡ��Ŀ�Ĺ�����ϵ
				sReturn = RunMethod("ProjectManage","InsertProjectRelative","<%=sObjectNo%>"+","+"<%=sObjectType%>"+","+sProjectNo+",PROJECT_RELATIVE");
				if(typeof(sReturn) != "undefined" && sReturn != "")
				{
					alert(getBusinessMessage('159'));//���������Ŀ�ɹ���
					OpenPage("/CustomerManage/EntManage/ProjectList.jsp","right","");	
				}
				else
				{
					alert(getBusinessMessage('160'));//���������Ŀʧ�ܣ�
					return;
				}
			}
		}		
	}
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var currentType = "<%=sObjectType%>";
		sProjectNo   = getItemValue(0,getRow(),"ProjectNo");//--��Ŀ����
		if (typeof(sProjectNo)=="undefined" || sProjectNo.length==0)		
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{     
			if(currentType == "Customer" ){
				openObject("Project",sProjectNo,"000");			
			}else{
				openObject("Project",sProjectNo,"000");			
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