<%!
	/*
	����������ͨ����Ӧ�Ĳ���������������չ����ʽ
	����˵����
		String sStyle         �ı������� 0��Input 1��textarea
        String sMethodInput   ����Method��ֵ 1:display;2:save;3:preview;4:export
        String sControlName   �ı�������ƺ���ʽ
        String sContent       �ı�����
    */
	//���ݳ�����ˮ��ȡ�ñ�֤������
	public String getGuarantyNameByBP(String sSerailNo,Transaction Sqlca) throws Exception {
		String sSql = "select ContractSerialNo from BUSINESS_PUTOUT where SerialNo ='"+sSerailNo+"'";
		String sContractSerialNo = Sqlca.getString(sSql);
		return getGuarantyName(sContractSerialNo,Sqlca);
	}
	
	//���ݺ�ͬ��ˮ��ȡ�ñ�֤������
	String getGuarantyName(String sSerailNo,Transaction Sqlca) throws Exception {
		String sSql = " select GC.GuarantorID||','||GC.GuarantorName from Guaranty_Contract GC,Contract_Relative CR where CR.ObjectNo=GC.SerialNo "+
			   " and GC.Guarantytype like '0100%' and CR.ObjectType = 'GUARANTY_CONTRACT' and CR.SerialNo = '"+sSerailNo+"'  and GC.Guarantorid<>'' and GC.Guarantorid is not null "+
			   " order by GC.GuarantorID ";
		return DataConvert.toString(Sqlca.getString(sSql));
	}
%>

<%   
	//����Ĳ���	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")); 
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType")); 
	String sDocID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DocID")); 
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo")); 
	
	//��ѡ�Ĳ���
	String sMethod = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Method")); //1:display;2:save;3:preview;4:export
	String sFirstSection = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FirstSection")); //�ж��Ƿ�Ϊ����ĵ�һҳ,1:��ʾ�ļ��ĵ�һ�Σ�0:��
	String sEndSection = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EndSection")); 
	if(sMethod==null) sMethod = "1";
	if(sFirstSection==null)  sFirstSection = "0"; //���Ϊ�գ���˵������βҳ
	if(sEndSection==null)  sEndSection = "0"; //���Ϊ�գ���˵������βҳ  added by yzheng

	String sReportData="";
	String sDelim = "��";
	//out.println(" where SerialNo='"+sSerialNo+"' and ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"' ");
	//�����������

	String sDescribeCount = "";
	int ii = 1;
	String sUpdate0 = "";
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	String sButtons[][] = {
			//{"true","","Button","����","����","my_save()",sResourcesPath},
			{"true","","Button","Ԥ��","Ԥ��","my_preview()",sResourcesPath}
			//,{"true","","Button","����","����","my_export()",sResourcesPath}  
		};

	%> 
<%/*~END~*/%>