<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author: wlu 2009-2-17
		Tester:
		Content:    --��Ȩ��������
			
		Input Param:
        	
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ȩ��������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//-���sql���
	
	//����������	,��Ʒ���
	String sSubjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SubjectNo"));
	if(sSubjectNo == null) sSubjectNo = "";

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
    //����ASDataObject����doTemp
	  String sTempletNo = "SubjectInfo"; //ģ����
	 ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);	

 	//�����Ŀ��Ų�Ϊ�գ��������޸�
 	//if(!sSubjectNo.equals(""))
 		//doTemp.setReadOnly("SubjectNo,SubjectName",true);

	 //���ò��ɼ���
	//doTemp.setVisible("",false);		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style = "2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSubjectNo);	
	for(int i=0;i<vTemp.size();i++) 
	out.print((String)vTemp.get(i));
	
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
			{"true","","Button","���沢����","�����޸Ĳ�����","saveRecordAndBack()",sResourcesPath},
			{"true","","Button","���沢����","�����޸Ĳ�������һ����¼","saveRecordAndAdd()",sResourcesPath}
		    };
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
    var sCurTypeNo=""; //��¼��ǰ��ѡ���еĴ����
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	//---------------------���尴ť�¼�------------------------------------
	
	/*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
	   OpenComp("SubjectInfo","/Common/Configurator/SubjectPolicy/SubjectInfo.jsp","","_self","");	   
	}
	
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndBack()
	{				
		if(bIsInsert){
			//¼��������Ч�Լ��
			if (!ValidityCheck()) return;
			beforeInsert();
		}		
	    as_save("myiframe0","doReturn('Y');");
	}

    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndAdd()
	{
		//¼��������Ч�Լ��		
		if(bIsInsert){
			if (!ValidityCheck()) return;
			beforeInsert();
		}	
		as_save("myiframe0","newRecord()");      
	}
    
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn(sIsRefresh)
    {
		sSubjectNo = getItemValue(0,getRow(),"SubjectNo");
	    parent.sObjectInfo = sSubjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
	}
	
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼	
			bIsInsert = true;		
		}
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{		
		//���¼��Ŀ�Ŀ����Ƿ����,Ҳ�����Լ�д���ֱ࣬�Ӳ����޼�¼
		sSubjectNo = getItemValue(0,0,"SubjectNo");	//�û����
		if(typeof(sSubjectNo) != "undefined" && sSubjectNo != "")
		{
	        //������̱��
	        var sColName = "SubjectNo";
			var sTableName = "SUBJECT_INFO";
			var sWhereClause = "String@SubjectNo@"+sSubjectNo;
			
			sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{			
				sReturn = sReturn.split('~');
				var my_array1 = new Array();
				for(i = 0;i < sReturn.length;i++)
				{
					my_array1[i] = sReturn[i];
				}
				
				for(j = 0;j < my_array1.length;j++)
				{
					sReturnInfo = my_array1[j].split('@');	
					var my_array2 = new Array();
					for(m = 0;m < sReturnInfo.length;m++)
					{
						my_array2[m] = sReturnInfo[m];
					}
					
					for(n = 0;n < my_array2.length;n++)
					{									
						//��ѯ��Ŀ��
						if(my_array2[n] == "subjectno")
							sSubjectNo = sReturnInfo[n+1];				
					}
				}
				if(typeof(sSubjectNo)!="undefined" && sSubjectNo != "")
				{
					alert("�Բ����Ѵ��ڸÿ�Ŀ�ţ�");
					return false;
				}						
			} 
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
	initRow();
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
