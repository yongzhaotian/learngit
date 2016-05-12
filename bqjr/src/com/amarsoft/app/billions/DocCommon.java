package com.amarsoft.app.billions;

import java.sql.SQLException;

import com.amarsoft.are.ARE;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 该类主要用于获取格式化报告类型
 * @author zhangying
 *
 */
public class DocCommon {
	private String serialNo="";//合同流水号
	private String type = "";//打印类型  0 申请表  1 第三方协议 2批复函 3  还款小贴士

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
	 * 根据类型获取docID
	 * @param Sqlca
	 * @return
	 * @throws SQLException
	 */
	public String getDocID(Transaction Sqlca) throws SQLException{
		//  						 申请表      	 三方协议	    批复函    	  还款小贴士    	
			//p2p		0
			//消费贷		1
			//学生教育贷	2
			//成人教育贷	3
			//现金贷		4
			//车主现金贷	5
			//小企业贷		6
			//借钱么现金贷	7
			//借钱么车主贷	8
			//易佰分		9
			//学生消费贷	10
		//  "7011@/FormatDoc/CashLoanReport/CashApplyReport.jsp"     ---->   DocId@Url  注意  DocId不要重复   除非用到的是同一套模板 	
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
		if(type.equals("0")) sObjectType = "ApplySettle";  //申请表   
		if(type.equals("1")) sObjectType = "ThirdSettle";		//三方协议
		if(type.equals("2")) sObjectType = "ApproveSettle";  //批复函 
		if(type.equals("3")) sObjectType = "CreditSettle";		//还款小贴士 
		
		int i = 1;//贷款类型     0-->p2p	1-->消费贷  	2-->学生教育贷 		3-->成人教育贷		4-->现金贷		5-->车主现金贷  
		int j = 1;//  打印报告类型：申请表      	 三方协议	    批复函    	小贴士   
		String isP2P ="";  //是否P2P合同Code:YesNo
		String subProductType="";//产品子类型  Code：SubProductType
		String ProductID = "";//产品类型    Code:BusinessType
		String sureType = "";//业务来源
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select isP2P,ProductID,subProductType,sureType from business_contract where SerialNo='"+serialNo+"'"));
		if(rs.next()){
			isP2P = DataConvert.toString(rs.getString("isP2P"));
			subProductType = DataConvert.toString(rs.getString("subProductType"));
			ProductID = DataConvert.toString(rs.getString("ProductID"));
			sureType = DataConvert.toString(rs.getString("sureType"));
		}
		rs.getStatement().close();
		
		if(  "1".equals(isP2P) && "030".equals(ProductID) && "EBF".equals(sureType) ){//易佰分
			i = 9; 
			j = Integer.parseInt(type); 
			return s[i][j]+"@"+sObjectType;
		}
		
		if( "1".equals(isP2P) && "030".equals(ProductID) ){//普通POS贷p2p
			i = 0;  //如果是p2p
			j = Integer.parseInt(type); 
			return s[i][j]+"@"+sObjectType;
		}
		
		//如果是P2P且是预约现金贷，即借钱么预约现金贷
		if( "1".equals(isP2P) && "020".equals(ProductID) && "1".equals(subProductType) ){
			i = 7;  //如果是p2p
			j = Integer.parseInt(type); 
			return s[i][j]+"@"+sObjectType;
		}
		
		//如果是P2P且是车主现金贷，即借钱么车主现金贷
		if( "1".equals(isP2P) && "020".equals(ProductID) && "3".equals(subProductType) ){
			i = 8;  //如果是p2p
			j = Integer.parseInt(type); 
			return s[i][j]+"@"+sObjectType;
		}
		
		if(ProductID.equals("030")){//如果是消费贷
			if((subProductType.equals("4") )){//如果是成人教育贷
				i = 3;
			}else if(subProductType.equals("5")){ //如果是学生教育贷
				i = 2;
			}else if("7".equals(subProductType)){ //如果是学生消费贷  add by dahl
				i = 10;
			}else{
				i=1;//消费贷
			}
			j = Integer.parseInt(type);
		}
		
		if(ProductID.equals("020")){  //如果是现金贷
			if(subProductType.equals("3") ){  //如果是车主现金贷 
				i=5;  
			}else{
				i = 4;
			}
			j = Integer.parseInt(type);
		}
		
		//如果是小企业贷，根据页面传入打印三方协议
		if(ProductID.equals("090")){
			i=6;
			j = Integer.parseInt(type);
		}
		
		return s[i][j]+"@"+sObjectType;
	}
	
	
	/**
	 * 根据贷款人获取不同的docID
	 * @param Sqlca
	 * @return
	 * @throws SQLException
	 */
	public String getDocIDAndUrl(Transaction Sqlca) throws SQLException{
		String sSql = "";
		String sDocSql = "";
		String sDocID = "";
		String sUrl = "";
		String sLoanSerialNo = "";//贷款人编号
		String sCity = "";
		String sSubProductType = "";//产品子类型
		String sSureType = ""; //业务来源
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
		
		String sSpSerialNo = "";//模板关联号
		//聚诚模板暂时用写死的方式取值，后续再做新修改--zhangzhi
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
				// add by xswang CCS-889 易佰分线上接口对接安硕系统:易佰分学生消费贷用学生消费贷模板
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
			boolean checkLog = true;//是否需要查询历史记录表
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
			//需要查询历史记录表
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