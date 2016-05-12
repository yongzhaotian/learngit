package com.amarsoft.app.billions;

import java.sql.SQLException;

import com.amarsoft.are.ARE;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * ������Ҫ���ڻ�ȡ��ʽ����������
 * @author zhangying
 *
 */
public class DocCommon {
	private String serialNo="";//��ͬ��ˮ��
	private String type = "";//��ӡ����  0 �����  1 ������Э�� 2������ 3  ����С��ʿ

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
	
	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	/**
	 * �������ͻ�ȡdocID
	 * @param Sqlca
	 * @return
	 * @throws SQLException
	 */
	public String getDocID(Transaction Sqlca) throws SQLException{
		//  						 �����      	 ����Э��	    ������    	  ����С��ʿ    	
			//p2p		0
			//���Ѵ�		1
			//ѧ��������	2
			//���˽�����	3
			//�ֽ��		4
			//�����ֽ��	5
			//С��ҵ��		6
			//��Ǯô�ֽ��	7
			//��Ǯô������	8
			//�װ۷�		9
			//ѧ�����Ѵ�	10
		//  "7011@/FormatDoc/CashLoanReport/CashApplyReport.jsp"     ---->   DocId@Url  ע��  DocId��Ҫ�ظ�   �����õ�����ͬһ��ģ�� 	
		String[][] s = new String[][]{
				{"7020@/FormatDoc/Report17/p2p_01.jsp",									"7021@/FormatDoc/Report17/p2p_00.jsp",								"7022@/FormatDoc/Report17/p2p_02.jsp",									"7023@/FormatDoc/Report17/p2p_03.jsp"},
				{"7006@/FormatDoc/Report17/03.jsp",										"7007@/FormatDoc/Report17/04.jsp",									"7003@/FormatDoc/Report14/ApproveReport.jsp",							"7005@/FormatDoc/Report17/01.jsp"},
				{"E004@/FormatDoc/Report17/studentEducationReport.jsp",					"E001@/FormatDoc/Report17/eduThirdReport.jsp",						"7003@/FormatDoc/Report14/ApproveReportEducation.jsp",					"E002@/FormatDoc/Report17/eduTips.jsp"},
				{"E005@/FormatDoc/Report17/aduEduApplyReport.jsp",						"E001@/FormatDoc/Report17/eduThirdReport.jsp",						"7003@/FormatDoc/Report14/ApproveReportEducation.jsp",					"E002@/FormatDoc/Report17/eduTips.jsp"},
				{"L001@/FormatDoc/CashLoanReport/00.jsp",								"7006@/FormatDoc/CashLoanReport/04.jsp",							"L003@/FormatDoc/CashLoanReport/02.jsp",								"L005@/FormatDoc/CashLoanReport/01.jsp"},
				{"7011@/FormatDoc/CashLoanReport/CashApplyReport.jsp",					"7012@/FormatDoc/CashLoanReport/CashThirdReport.jsp",				"7010@/FormatDoc/CashLoanReport/CashCreApproveReport.jsp",				"L005@/FormatDoc/CashLoanReport/01.jsp"},
				{"7013@/FormatDoc/Report17/SmallElectronicContract.jsp", 				"E006@/FormatDoc/Report17/SmallBusReport.jsp",	 					"", 																	""},
				{"JQ00@/FormatDoc/Report18/jieqianmeCash.jsp",							"",																	"",																		"JQ03@/FormatDoc/Report18/jieqianme03.jsp"},
				{"JQ10@/FormatDoc/Report18/jieqianmeCar.jsp",							"",																	"",																		"JQ03@/FormatDoc/Report18/jieqianme03.jsp"},
				{"EBF0@/FormatDoc/Report18/ebaifenApply.jsp",							"7021@/FormatDoc/Report17/p2p_00.jsp",								"7022@/FormatDoc/Report17/p2p_02.jsp",									"7023@/FormatDoc/Report17/p2p_03.jsp"},
				{"STU0@/FormatDoc/Report18/stuPosApply.jsp",							"STU1@/FormatDoc/Report18/stuPosThird.jsp",							"STU2@/FormatDoc/Report18/stuPosApprove.jsp",							"STU3@/FormatDoc/Report18/stuPosCredit.jsp"},
		};
		System.out.println(serialNo+","+type);
		String sObjectType = "";
		if(type.equals("0")) sObjectType = "ApplySettle";  //�����   
		if(type.equals("1")) sObjectType = "ThirdSettle";		//����Э��
		if(type.equals("2")) sObjectType = "ApproveSettle";  //������ 
		if(type.equals("3")) sObjectType = "CreditSettle";		//����С��ʿ 
		
		int i = 1;//��������     0-->p2p	1-->���Ѵ�  	2-->ѧ�������� 		3-->���˽�����		4-->�ֽ��		5-->�����ֽ��  
		int j = 1;//  ��ӡ�������ͣ������      	 ����Э��	    ������    	С��ʿ   
		String isP2P ="";  //�Ƿ�P2P��ͬCode:YesNo
		String subProductType="";//��Ʒ������  Code��SubProductType
		String ProductID = "";//��Ʒ����    Code:BusinessType
		String sureType = "";//ҵ����Դ
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select isP2P,ProductID,subProductType,sureType from business_contract where SerialNo='"+serialNo+"'"));
		if(rs.next()){
			isP2P = DataConvert.toString(rs.getString("isP2P"));
			subProductType = DataConvert.toString(rs.getString("subProductType"));
			ProductID = DataConvert.toString(rs.getString("ProductID"));
			sureType = DataConvert.toString(rs.getString("sureType"));
		}
		rs.getStatement().close();
		
		if(  "1".equals(isP2P) && "030".equals(ProductID) && "EBF".equals(sureType) ){//�װ۷�
			i = 9; 
			j = Integer.parseInt(type); 
			return s[i][j]+"@"+sObjectType;
		}
		
		if( "1".equals(isP2P) && "030".equals(ProductID) ){//��ͨPOS��p2p
			i = 0;  //�����p2p
			j = Integer.parseInt(type); 
			return s[i][j]+"@"+sObjectType;
		}
		
		//�����P2P����ԤԼ�ֽ��������ǮôԤԼ�ֽ��
		if( "1".equals(isP2P) && "020".equals(ProductID) && "1".equals(subProductType) ){
			i = 7;  //�����p2p
			j = Integer.parseInt(type); 
			return s[i][j]+"@"+sObjectType;
		}
		
		//�����P2P���ǳ����ֽ��������Ǯô�����ֽ��
		if( "1".equals(isP2P) && "020".equals(ProductID) && "3".equals(subProductType) ){
			i = 8;  //�����p2p
			j = Integer.parseInt(type); 
			return s[i][j]+"@"+sObjectType;
		}
		
		if(ProductID.equals("030")){//��������Ѵ�
			if((subProductType.equals("4") )){//����ǳ��˽�����
				i = 3;
			}else if(subProductType.equals("5")){ //�����ѧ��������
				i = 2;
			}else if("7".equals(subProductType)){ //�����ѧ�����Ѵ�  add by dahl
				i = 10;
			}else{
				i=1;//���Ѵ�
			}
			j = Integer.parseInt(type);
		}
		
		if(ProductID.equals("020")){  //������ֽ��
			if(subProductType.equals("3") ){  //����ǳ����ֽ�� 
				i=5;  
			}else{
				i = 4;
			}
			j = Integer.parseInt(type);
		}
		
		//�����С��ҵ��������ҳ�洫���ӡ����Э��
		if(ProductID.equals("090")){
			i=6;
			j = Integer.parseInt(type);
		}
		
		return s[i][j]+"@"+sObjectType;
	}
	
	
	/**
	 * ���ݴ����˻�ȡ��ͬ��docID
	 * @param Sqlca
	 * @return
	 * @throws SQLException
	 */
	public String getDocIDAndUrl(Transaction Sqlca) throws SQLException{
		String sSql = "";
		String sDocSql = "";
		String sDocID = "";
		String sUrl = "";
		String sLoanSerialNo = "";//�����˱��
		String sCity = "";
		String sSubProductType = "";//��Ʒ������
		String sSureType = ""; //ҵ����Դ
		String sInputDate = "";
		
		sSql = " select bc.CreditID,si.City,bc.SubProductType,bc.suretype,bc.inputdate from Business_Contract bc,Store_Info si "+
			   " where bc.stores=si.sno and bc.serialno=:SerialNo ";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", this.serialNo));
		if(rs.next()){
			sLoanSerialNo = rs.getString("CreditID");
			sCity = rs.getString("City");
			sSubProductType = rs.getString("SubProductType");
			sSureType = rs.getString("suretype");
			sInputDate = rs.getString("InputDate");
		}
		rs.getStatement().close();
		if(sLoanSerialNo==null||sLoanSerialNo.length()==0){
			sLoanSerialNo = "";
			ARE.getLog().info("sLoanSerialNo is Null");
			return "False";
		}
		if(sCity==null||sCity.length()==0){
			sCity = "";
			ARE.getLog().info("sCity is Null");
			return "False";
		}
		if(sSubProductType==null||sSubProductType.length()==0){
			sSubProductType = "";
			ARE.getLog().info("sSubProductType is Null");
			return "False";
		}
		
		String sSpSerialNo = "";//ģ�������
		//�۳�ģ����ʱ��д���ķ�ʽȡֵ�������������޸�--zhangzhi
		if ("JCC".equals(sSureType)){
			sSpSerialNo = sLoanSerialNo+sCity+sSubProductType;
			ARE.getLog().info("sSpSerialNo is :"+sSpSerialNo);
			sDocSql = " select fv.docid,fd.jspfilename from JCCF_Formatdoc_Version fv,Formatdoc_Def fd "+
					  " where fv.docid=fd.docid and fv.SpSerialNo=:SpSerialNo and fd.dirid='00'"+
					  " and fv.businesstype=:Type and to_date(to_char(sysdate,'yyyy/MM/dd'),'yyyy/MM/dd') "+
					  " between to_date(fv.begintime,'yyyy/MM/dd') and to_date(fv.endtime,'yyyy/MM/dd')";
			rs = Sqlca.getASResultSet(new SqlObject(sDocSql).setParameter("SpSerialNo", sSpSerialNo)
									.setParameter("Type", this.type));
			if(rs.next()){
				sDocID = rs.getString("docid");
				sUrl = rs.getString("jspfilename");
			}
			rs.getStatement().close();
			
		}else if(sSureType.equals("EBF")){
			if("RishSettle".equals(type)){
				if("4".equals(sSubProductType)||"5".equals(sSubProductType)){
					sDocID = "XF002";
					sUrl = "/FormatDoc/Report17/eduRisk.jsp";
				}else if("1".equals(sSubProductType)||"2".equals(sSubProductType)||"3".equals(sSubProductType)){
					sDocID = "XF004";
					sUrl = "/FormatDoc/CashLoanReport/03.jsp";
				}else{
					sDocID = "XF001";
					sUrl = "/FormatDoc/RiskTip.jsp";
				}
			}else{
				// add by xswang CCS-889 �װ۷����ϽӿڶԽӰ�˶ϵͳ:�װ۷�ѧ�����Ѵ���ѧ�����Ѵ�ģ��
				if("7".equals(sSubProductType)){
					sDocSql = " select fc.docid,fd.jspfilename from Formatdoc_Catalog fc,Formatdoc_Def fd  where fc.docid=fd.docid  and fd.dirid='00' "+
							  " and fc.doctype=:Type and fc.docid in ('STUO','EBF2','EBF3','EBF4','XS001') ";
				// end by xswang
				}else{
					sDocSql = " select fc.docid,fd.jspfilename from Formatdoc_Catalog fc,Formatdoc_Def fd  where fc.docid=fd.docid  and fd.dirid='00' "+
					  " and fc.doctype=:Type and fc.docid in ('EBF0','EBF2','EBF3','EBF4','XS001') ";
				}
				rs = Sqlca.getASResultSet(new SqlObject(sDocSql).setParameter("Type", this.type));
				if(rs.next()){
					sDocID = rs.getString("docid");
					sUrl = rs.getString("jspfilename");
				}
				rs.getStatement().close();
				if(sDocID==null||sDocID.length()==0){
					sDocID = "";
					ARE.getLog().info("EBF sDocID is Null");
					return "False";
				}
				if(sUrl==null||sUrl.length()==0){
					sUrl = "";
					ARE.getLog().info("EBF sUrl is Null");
					return "False";
				}
			}
		}else{
			boolean checkLog = true;//�Ƿ���Ҫ��ѯ��ʷ��¼��
			sSpSerialNo = sLoanSerialNo+sCity+sSubProductType;
			ARE.getLog().info("sSpSerialNo is :"+sSpSerialNo);
			sDocSql = " select fv.docid,fd.jspfilename from Formatdoc_Version fv,Formatdoc_Def fd "+
					  " where fv.docid=fd.docid and fv.SpSerialNo=:SpSerialNo and fd.dirid='00'   "+
					  " and fv.businesstype=:Type and to_date(to_char(sysdate,'yyyy/MM/dd'),'yyyy/MM/dd') "+
					  " between to_date(fv.begintime,'yyyy/MM/dd') and to_date(fv.endtime,'yyyy/MM/dd')";
			rs = Sqlca.getASResultSet(new SqlObject(sDocSql).setParameter("SpSerialNo", sSpSerialNo)
									.setParameter("Type", this.type));
			if(rs.next()){
				checkLog = false;
				sDocID = rs.getString("docid");
				sUrl = rs.getString("jspfilename");
			}
			rs.getStatement().close();
			//��Ҫ��ѯ��ʷ��¼��
			if(checkLog){
				sDocSql = " select fv.docid,fd.jspfilename from Formatdoc_Version_log fv,Formatdoc_Def fd "+
						" where fv.docid=fd.docid and fv.SpSerialNo=:SpSerialNo and fd.dirid='00'   "+
						" and fv.businesstype=:Type and :InputDate between fv.begintime and fv.endtime ";
				rs = Sqlca.getASResultSet(new SqlObject(sDocSql).setParameter("SpSerialNo", sSpSerialNo)
						.setParameter("Type", this.type).setParameter("InputDate", sInputDate));
				if(rs.next()){
					sDocID = rs.getString("docid");
					sUrl = rs.getString("jspfilename");
				}
				rs.getStatement().close();
			}
			
			if(sDocID==null||sDocID.length()==0){
				sDocID = "";
				ARE.getLog().info("sDocID is Null");
				return "False";
			}
			if(sUrl==null||sUrl.length()==0){
				sUrl = "";
				ARE.getLog().info("sUrl is Null");
				return "False";
			}
		}
		return sDocID+"@"+sUrl;
	}
	
	
}