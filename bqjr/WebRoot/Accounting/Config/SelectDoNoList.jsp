<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "��¼ģ�������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	
	//�������
	String sSql = "";
	
	String inputparatemplete =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Inputparatemplete"));
    if(null==inputparatemplete|| "".equals(inputparatemplete)) inputparatemplete="ProductDefine";
	
	String sHeaders[][] = { 							
							{"DoNo","ģ����"},
							{"ColName","��������"},
							{"ColHeader","��������"}
						}; 
	
	sSql = " Select DoNo,ColName,ColHeader "+
		   " From dataobject_library "+
		   " Where dono='"+inputparatemplete+"' And ColType='Number' And colcheckformat='2' "+
		   " and colunit like '%Ԫ%' "+
		   " Order By colindex ";
	
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);

	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "dataobject_library";
	//���ùؼ���
	doTemp.setKey("DoNo",true);	 	

	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("ColHeader","style={width:180px} ");  	
	
	//���ö��뷽ʽ
	doTemp.setAlign("NormalBalance,OverDueBalance,PayInte","3");
	doTemp.setType("NormalBalance,OverDueBalance,PayInte","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("NormalBalance,OverDueBalance,PayInte","2");
	
	//	���ò��ɼ���
	doTemp.setVisible("ContractSerialNo,BusinessType,ReturnType,ReturnTypeName,CertID,BusinessSum",false);
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);  //��������ҳ
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
				{"true","","Button","ȷ��","ȷ��","confirm()",sResourcesPath},
				{"true","","Button","ȡ��","ȡ��","javaScript:self.close()",sResourcesPath}
			};
	%> 


	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>
	
	//---------------------���尴ť�¼�------------------------------------
	
	/*~[Describe=ȷ��;InputParam=��;OutPutParam=SerialNo;]~*/
	function confirm()
	{
		var colName = getItemValue(0,getRow(),"ColName");
		if(typeof(colName) == "undefined" || colName.length == 0 ) 
			self.returnValue = "_CANCEL_";
		else
			self.returnValue = colName;	
		self.close();
	}
	
	</script>
	

<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	


<%@ include file="/IncludeEnd.jsp"%>
