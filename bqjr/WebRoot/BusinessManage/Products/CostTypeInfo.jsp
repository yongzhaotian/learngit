<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --��Ʒ��������
			δ�õ��������ֶ���ʱ���أ������Ҫ��չʾ������
		Input Param:
        	TypeNo��    --���ͱ��
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	
	//���ҳ�����
	String sProductCategoryID    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("productCategoryID"));	
	if(sProductCategoryID==null) sProductCategoryID="";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//ASDataObject doTemp = new ASDataObject("CostTypeInfo3",Sqlca);
	ASDataObject doTemp = new ASDataObject("FeeTypePreserve",Sqlca);
    
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

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
			//{"true","","Button","����","����","saveRecord()",sResourcesPath},
			{"true","","Button","����","����","saveRecordAndBack()",sResourcesPath},
			{"true","","Button","����","����","saveRecord1()",sResourcesPath},
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
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		bIsInsert = false;
	    as_save("myiframe0");
	    saveAndOpenPage();
	}
    
	//����
	function saveRecord1(){
		
	    var termID = getItemValue(0,getRow(),"TermID");
	    var TermName = getItemValue(0,getRow(),"TermName");
	    var FeeType = getItemValue(0,getRow(),"FeeType");
	    
	    	if(typeof(termID)=="undefined" || termID.length==0)return;
		    setItemValue(0,0,"ObjectNo",termID);
			var existsFlag = RunMethod("PublicMethod","GetColValue","1,PRODUCT_TERM_LIBRARY,String@ObjectType@Term~String@TermID@"+termID);
			if(existsFlag =="1"){
				alert("���ô����ظ�����ȷ�ϣ�");
				return;
			}
			//if(confirm('ȷ��������')){//�������ݿⱣ��ʱ�����޸���ȷ��
				var targetTermID = "";
				if(FeeType=="A9"){//A9����ǰ�������
					targetTermID = "TQHKSXF";
				}else if(FeeType=="A11"){//A11��ӡ��˰
					targetTermID = "C300";
				}else if(FeeType=="A12"){//���շ�
					targetTermID = "BXF";
				}else if(FeeType=="A10"){//���ɽ�
					targetTermID = "ZNJ";
			} else if (FeeType == "A18") {	// ���Ļ������
				targetTermID = "SXH001";
			}
			sReturn = RunMethod("ProductManage","CopyTerm","copyTerm,"+termID+","+TermName+","+targetTermID);
			var SortNo = getSerialNo("product_term_library","SortNo","");
			var ActiveDate = getItemValue(0,getRow(),"ActiveDate");//��Ч��
			var CloseDate = getItemValue(0,getRow(),"CloseDate");//ʧЧ��
			var InputDate = getItemValue(0,getRow(),"InputDate");//����ʱ��
			var UpdateDate = getItemValue(0,getRow(),"UpdateDate");//�޸�ʱ��
				//if(FeeType=="A9"||FeeType=="A11"){//A9����ǰ�������,A11��ӡ��˰
					RunMethod("PublicMethod","UpdateColValue","String@SortNo@"+SortNo+",PRODUCT_TERM_LIBRARY,String@ObjectType@Term@String@TermID@"+termID);
					RunMethod("PublicMethod","UpdateColValue","String@SubTermType@"+FeeType+",PRODUCT_TERM_LIBRARY,String@ObjectType@Term@String@TermID@"+termID);
					RunMethod("PublicMethod","UpdateColValue","String@ActiveDate@"+ActiveDate+",PRODUCT_TERM_LIBRARY,String@ObjectType@Term@String@TermID@"+termID);
					RunMethod("PublicMethod","UpdateColValue","String@CloseDate@"+CloseDate+",PRODUCT_TERM_LIBRARY,String@ObjectType@Term@String@TermID@"+termID);
					RunMethod("PublicMethod","UpdateColValue","String@InputDate@"+InputDate+",PRODUCT_TERM_LIBRARY,String@ObjectType@Term@String@TermID@"+termID);
					RunMethod("PublicMethod","UpdateColValue","String@UpdateDate@"+UpdateDate+",PRODUCT_TERM_LIBRARY,String@ObjectType@Term@String@TermID@"+termID);
					/* if(FeeType=="A11"){
						//ӡ��˰�������׷�ΧΪ һ������:0020
						RunMethod("PublicMethod","UpdateColValue","String@valueslist@'',PRODUCT_TERM_LIBRARY,String@PARAID@FeeTransactionCode@String@ObjectType@Term@String@TermID@"+termID);
					} */
				//}else if(FeeType=="A12"){//���շ�
					/* RunMethod("PublicMethod","UpdateColValue","String@SortNo@"+SortNo+",PRODUCT_TERM_LIBRARY,String@ObjectType@Term@String@TermID@"+termID);
					RunMethod("PublicMethod","UpdateColValue","String@SubTermType@"+FeeType+",PRODUCT_TERM_LIBRARY,String@ObjectType@Term@String@TermID@"+termID);
					RunMethod("PublicMethod","UpdateColValue","String@ActiveDate@"+ActiveDate+",PRODUCT_TERM_LIBRARY,String@ObjectType@Term@String@TermID@"+termID);
					RunMethod("PublicMethod","UpdateColValue","String@CloseDate@"+CloseDate+",PRODUCT_TERM_LIBRARY,String@ObjectType@Term@String@TermID@"+termID);
					RunMethod("PublicMethod","UpdateColValue","String@InputDate@"+InputDate+",PRODUCT_TERM_LIBRARY,String@ObjectType@Term@String@TermID@"+termID);
					RunMethod("PublicMethod","UpdateColValue","String@UpdateDate@"+UpdateDate+",PRODUCT_TERM_LIBRARY,String@ObjectType@Term@String@TermID@"+termID); */
					
				//}
			/* //���·������������ 20121126 dxu1
				var TermName = getItemValue(0,getRow(),"TermName");
				if(typeof(TermName) !="undefined" && TermName.length !=0){
					RunMethod("ProductManage","UpdateTermName",termID+","+TermName);
			    }
				as_save("myiframe0"); */
			//}
			
			//reloadSelf();	    
	    
		AsControl.OpenView("/BusinessManage/Products/FeeLibraryInfo.jsp","ObjectNo="+termID+"&ObjectType=Term&TermID="+termID+"&FeeType="+FeeType,"_blank",OpenStyle);
		window.close();
	}
   
    function saveAndOpenPage(){
		var sFeeType  = getItemValue(0,getRow(),"feeType");
		var sSerialNo  = getItemValue(0,getRow(),"serialNo");
		if(sFeeType == "3" || sFeeType == "1"){
			AsControl.OpenView("/BusinessManage/Products/CostTypeInfo1.jsp","serialNo="+sSerialNo,"_blank");
			window.close();
		}else if(sFeeType == "4"){
			AsControl.OpenView("/BusinessManage/Products/CostTypeInfo2.jsp","serialNo="+sSerialNo,"_blank");
			window.close();
		}else if(sFeeType == "040"){
			AsControl.OpenView("","","_blank");
		}else{
			window.close();
	        reloadSelf();
		}

    }

    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndBack()
	{ 
       	window.close();
	}
    
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">	
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"SortNo", getSerialNo("PRODUCT_TERM_LIBRARY", "SortNo", " "));
			setItemValue(0,0,"InputOrgID", "<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputUserID", "<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgName", "<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputUserName", "<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UpdateDate", "<%=StringFunction.getToday()%>");
			setItemValue(0,0,"InputDate", "<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
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
