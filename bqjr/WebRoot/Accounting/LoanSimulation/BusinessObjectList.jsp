<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ҵ������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	BusinessObject simulationObject = (BusinessObject)session.getAttribute("SimulationObject_Loan");
	if(simulationObject==null) simulationObject = (BusinessObject)session.getAttribute("SimulationObject_BusinessPutOut");
	
	String templeteNo =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TempleteNo")));
	String objectType =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType")));
	String parentObjectType =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParentObjectType")));
	String parentObjectNo =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParentObjectNo")));
	
	BusinessObject parentObject=null;
	if(parentObjectType!=null&&parentObjectType.length()>0){
		parentObject = simulationObject.getRelativeObject(parentObjectType, parentObjectNo);
		if(parentObject==null){
			throw new Exception("δ�ҵ�����{"+parentObjectType+"-"+parentObjectNo+"}!");
		}
	}
	else{
		parentObject=simulationObject;
	}
	List<BusinessObject> list =parentObject.getRelativeObjects(objectType);
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(templeteNo,Sqlca);
	//����datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	//������datawindows����ʾ������
	dwTemp.setPageSize(20); 
	//doTemp.setHTMLStyle(""," style={cursor:hand;} onDblClick=\"javascript:parent.viewRecord()\" ");
	//����DW��� 1:Grid 2:Freeform
	dwTemp.Style="1";      
	//�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.ReadOnly = "1"; 
		
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
		//6.��ԴͼƬ·��{"true","","Button","�ܻ�Ȩת��","�ܻ�Ȩת��","ManageUserIdChange()",sResourcesPath}
	String sButtons[][] = {
			//{"true","","Button","����","����","viewRecord()",sResourcesPath},
	};

		
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<script language="javascript">
	function viewRecord(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		PopComp("ACCT_LoanSimulationBusinessInfo","","SerialNo="+serialNo+"&InfoTempleteNo=&DisplayObjectType=",OpenStyle);
	}
</script>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
<%
out.print(DWExtendedFunctions.setDataWindowValues(parentObject,list, dwTemp,Sqlca) );
%>

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');

</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>