<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String sCustomerID = request.getParameter("CustomerID"); 
	String sAccountMonth = request.getParameter("AccountMonth");
	String sReportNo = request.getParameter("ReportNo");
	String excelData2 = request.getParameter("excelData2");
	String excelData1 = request.getParameter("excelData1");
	String sDisPlayMethod = request.getParameter("DisPlayMethod");
	String ItemNo1[] = StringFunction.toStringArray(excelData1,"@");
	String ItemNo2[] = StringFunction.toStringArray(excelData2,"@");
	SqlObject so = null;
	String sNewSql = "";
	double dCol1Value = 0.00;
	double dCol3Value = 0.00;
	int iRowCount = Integer.parseInt(request.getParameter("iRowCount")); 
	String sSql = "";
	if(sDisPlayMethod.equals("2"))
		iRowCount = iRowCount/2*2;
	
	String sTmpRowNo ="",sTmpRowNo1="";
	int i=1;
	try
	{
		for(i=1;i<=iRowCount;i++)
		{
			//ItemNo1��ʽΪRowNo@ColValue...
			if(ItemNo1[i*2]==null || ItemNo1[i*2].equals("")) ItemNo1[i*2]="0";
			sTmpRowNo = ItemNo1[i*2-1];
			dCol1Value = Double.parseDouble(ItemNo1[i*2]);
			
			//-----------------���ִ���ͬ��DisPlayMethod, modefied by xhgao 
			if(sDisPlayMethod.equals("1") 				//����˫ֵDisPlayMethod=1
					|| sDisPlayMethod.equals("2")){		//˫��˫ֵDisPlayMethod=2,����Col1Value,Col2Value
				
				//-------------����/˫��˫ֵʱItemNo2��Ϊ��
				if(ItemNo2[i*2]==null || ItemNo2[i*2].equals("")) ItemNo2[i*2]="0";
				sTmpRowNo1 = ItemNo2[i*2-1];
				dCol3Value = Double.parseDouble(ItemNo2[i*2]);
				
				if(sDisPlayMethod.equals("1")){
					sNewSql = "update REPORT_DATA set Col1Value=:Col1Value where ReportNo =:ReportNo and RowNo=:RowNo";
					so = new SqlObject(sNewSql);
					so.setParameter("Col1Value",dCol1Value).setParameter("ReportNo",sReportNo).setParameter("RowNo",sTmpRowNo);
					Sqlca.executeSQL(so);
					sNewSql = "update REPORT_DATA set Col2Value=:Col2Value where ReportNo =:ReportNo and RowNo=:RowNo";
					so = new SqlObject(sNewSql);
					so.setParameter("Col2Value",dCol3Value).setParameter("ReportNo",sReportNo).setParameter("RowNo",sTmpRowNo1);
					Sqlca.executeSQL(so);
				}else if(sDisPlayMethod.equals("2")){
					//Ŀǰ˫��˫ֵ��ֻ���ʲ���ծ����������ģ��ʱ��Col1Value���Ϊ�ڳ�ֵ��Col2ValueΪ��ĩֵ
					//ʵ�ʴӵ����ļ���ȡ����dCol1ValueΪ��ĩֵ��dCol3ValueΪ���ֵ
					sNewSql = "update REPORT_DATA set Col1Value=:Col1Value where ReportNo =:ReportNo and RowNo=:RowNo";
					so = new SqlObject(sNewSql);
					so.setParameter("Col1Value",dCol3Value).setParameter("ReportNo",sReportNo).setParameter("RowNo",sTmpRowNo);
					Sqlca.executeSQL(so);
					sNewSql = "update REPORT_DATA set Col2Value=:Col2Value where ReportNo =:ReportNo and RowNo=:RowNo";
					so = new SqlObject(sNewSql);
					so.setParameter("Col2Value",dCol1Value).setParameter("ReportNo",sReportNo).setParameter("RowNo",sTmpRowNo);
					Sqlca.executeSQL(so);
				}
			}
			
			if(sDisPlayMethod.equals("3")){			//���е�ֵDisPlayMethod=3ʱ����Col2Value
				sNewSql = "update REPORT_DATA set Col2Value=:Col2Value where ReportNo =:ReportNo and RowNo=:RowNo";
				so = new SqlObject(sNewSql);
				so.setParameter("Col2Value",dCol1Value).setParameter("ReportNo",sReportNo).setParameter("RowNo",sTmpRowNo);
				Sqlca.executeSQL(so);
			}
		}

	%>
	<script type="text/javascript">
		alert("���ݸ��³ɹ�");
		self.close();
		window.opener.location.reload();
	</script>
	<%	
	}catch(Exception e)
	{
	%>
	<script type="text/javascript">
		alert("���ݸ���ʧ�ܣ�����ԭ��"+"<%=e.toString()%>");
		self.close();
	</script>
	<%
	}
%>
<%@ include file="/IncludeEnd.jsp"%>

