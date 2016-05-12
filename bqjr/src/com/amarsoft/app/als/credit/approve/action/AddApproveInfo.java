package com.amarsoft.app.als.credit.approve.action;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.als.credit.common.model.CreditConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.context.ASUser;

/**
 * 将申请基本信息及其关联信息复制到批复中,改写部分sqlca为jbo
 * @author jschen
 *
 */
public class AddApproveInfo {
	
	private BizObject applyObject = null;
	private ASUser curUser = null;
	private String approveSerialNo = "";
	
	//临时变量声明
	private String sFieldValue,sSql,sRelativeSerialNo1;
	private int iColumnCount,iFieldType;
	private SqlObject so = null;
	private ASResultSet rs = null;
	
	public String getApproveSerialNo() {
		return approveSerialNo;
	}

	public void setApproveSerialNo(String approveSerialNo) {
		this.approveSerialNo = approveSerialNo;
	}

	/**
	 * @param applyObject 申请对象
	 * @throws JBOException 
	 */
	public AddApproveInfo(BizObject applyObject,ASUser curUser) throws JBOException {
		this.applyObject = applyObject;
		this.curUser = curUser;
		this.applySerialNo = this.applyObject.getAttribute("SerialNo").getString();
	}

	private String approveOpinion = ""; //获取批复意见
	private String disagreeOpinion = ""; //获取否决意见
	private String oldObjectType = "CreditApply"; //设置对象类型 BA
	private String applySerialNo = ""; //对象编号 BA申请编号
	private String newObjectType = "ApproveApply"; //对象类型 newObjectType
	
	public String getApproveOpinion() {
		return approveOpinion;
	}

	public void setApproveOpinion(String approveOpinion) {
		this.approveOpinion = approveOpinion;
	}

	public String getDisagreeOpinion() {
		return disagreeOpinion;
	}

	public void setDisagreeOpinion(String disagreeOpinion) {
		this.disagreeOpinion = disagreeOpinion;
	}
	
	/**
	 * 
	 * @param tx
	 * @throws Exception
	 */
	public String transfer(JBOTransaction tx) throws Exception{
		approveSerialNo = transferBusinessApply(tx);
		Transaction areTrans = Transaction.createTransaction(tx);
		if(this.getApproveOpinion().equals(CreditConst.APPROVETYPE_AGREE)){//签署同意批复才从申请中拷贝其附属信息
			transferGuaranty(areTrans);
			transferApplicant(areTrans);
			transferDoc(areTrans);
			transferProject(areTrans);
			transferBill(areTrans);
			transferLCInfo(areTrans);
			transferContractInfo(areTrans);
			transferInvoice(areTrans);
			transferAgency(areTrans);
			transferRelative(areTrans);
			transferCLInfo(areTrans);
			transferCLDivide(tx);
			transferCLOccupy(tx);
			transferAccountNo(tx);
			transferRate(tx);
			transferRPT(tx);
			transferSPT(tx);
			transferFee(tx);
		}
		
		return this.getApproveSerialNo();
	}
	
	private String transferBusinessApply(JBOTransaction tx) throws JBOException{
		String approveSerialNo = "";
		//JBO临时变量
		BizObjectQuery q = null;
		JBOFactory f = JBOFactory.getFactory();
		BizObject boApprove=null;
		
		//取批复，如果批复存在则直接返回该批复流水
		BizObjectManager mApprove = f.getManager("jbo.app.BUSINESS_APPROVE");
		tx.join(mApprove);
		q = mApprove.createQuery("RelativeSerialNo=:SerialNo").setParameter("SerialNo",applyObject.getAttribute("SerialNo").getString()); 
		boApprove = q.getSingleResult(false);
		if(boApprove != null) return boApprove.getAttribute("SerialNo").getString();
		
		
		//获取最后终审的任务流水号
		BizObjectManager mFinalOpinion = f.getManager("jbo.app.FLOW_OPINION");
		BizObject bo = mFinalOpinion.createQuery("select max(SerialNo) as V.SerialNo from O where ObjectType = 'CreditApply' and ObjectNo =:ObjectNo").setParameter("ObjectNo", applySerialNo).getSingleResult(false);
		String finalTaskSerialNo = bo.getAttribute("SerialNo").getString();
		//根据最后终审的任务流水号和对象编号获取相应的业务信息
		BizObject boFinalOpinion = mFinalOpinion.createQuery("SerialNo =:SerialNo and ObjectNo =:ObjectNo").
										setParameter("SerialNo", finalTaskSerialNo).
										setParameter("ObjectNo", applySerialNo).
										getSingleResult(false);
		boApprove = mApprove.newObject();
		boApprove.setAttributesValue(applyObject);
		boApprove.setAttributeValue("SerialNo", null);
		
		//特殊处理部分字段
		boApprove.getAttribute("BusinessCurrency").setValue(boFinalOpinion.getAttribute("BusinessCurrency")); //自动匹配字段类型
		boApprove.getAttribute("BusinessSum").setValue(boFinalOpinion.getAttribute("BusinessSum"));
		boApprove.getAttribute("BaseRate").setValue(boFinalOpinion.getAttribute("BaseRate"));
		boApprove.getAttribute("RateFloatType").setValue(boFinalOpinion.getAttribute("RateFloatType"));
		boApprove.getAttribute("RateFloat").setValue(boFinalOpinion.getAttribute("RateFloat"));
		boApprove.getAttribute("BusinessRate").setValue(boFinalOpinion.getAttribute("BusinessRate"));
		boApprove.getAttribute("BailCurrency").setValue(boFinalOpinion.getAttribute("BailCurrency"));
		boApprove.getAttribute("BailSum").setValue(boFinalOpinion.getAttribute("BailSum"));
		boApprove.getAttribute("BailRatio").setValue(boFinalOpinion.getAttribute("BailRatio"));
		boApprove.getAttribute("PdgRatio").setValue(boFinalOpinion.getAttribute("PdgRatio"));
		boApprove.getAttribute("PdgSum").setValue(boFinalOpinion.getAttribute("PdgSum"));
		boApprove.getAttribute("TermYear").setValue(boFinalOpinion.getAttribute("TermYear"));
		boApprove.getAttribute("TermMonth").setValue(boFinalOpinion.getAttribute("TermMonth"));
		boApprove.getAttribute("TermDay").setValue(boFinalOpinion.getAttribute("TermDay"));
		boApprove.getAttribute("LoanRateTermID").setValue(boFinalOpinion.getAttribute("LoanRateTermID"));
		boApprove.getAttribute("RPTTermID").setValue(boFinalOpinion.getAttribute("RPTTermID"));
		
		boApprove.setAttributeValue("RelativeSerialNo", applyObject.getAttribute("SerialNo").getString());
		boApprove.setAttributeValue("InputOrgID", curUser.getOrgID());
		boApprove.setAttributeValue("InputUserID",curUser.getUserID());
		boApprove.setAttributeValue("InputDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));
		boApprove.setAttributeValue("UpdateDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));
		boApprove.setAttributeValue("OccurDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));
		boApprove.setAttributeValue("ApproveType",approveOpinion);
		boApprove.setAttributeValue("ApproveOpinion",disagreeOpinion);
		boApprove.setAttributeValue("TempSaveFlag",CreditConst.SAVE_FLAG_TEMP);
		boApprove.setAttributeValue("Flag5",CreditConst.BAP_FLAG5_UNREGISTER);
		
		//保存BUSINESS_APPROVE
		mApprove.saveObject(boApprove);
		approveSerialNo = boApprove.getAttribute("SerialNo").getString(); //获得批复流水号
	
		//在初始化最终审批意见的同时，更改申请表中关于是否通过审批的标签
		BizObjectManager mApply = f.getManager("jbo.app.BUSINESS_APPLY");
		tx.join(mApply);
		applyObject.setAttributeValue("Flag5", CreditConst.BA_FLAG5_APPROVED);
		mApply.saveObject(applyObject);
		setApproveSerialNo(approveSerialNo);
		return approveSerialNo;
	}
	
	/**
	 * 拷贝申请信息所对应的担保信息到批复
	 * @param Sqlca
	 * @param approveSerialNo
	 * @throws Exception
	 */
	private void transferGuaranty(Transaction Sqlca) throws Exception{
		/*请注意：在申请的担保信息中存在新增的担保信息和引入最高额的担保信息，因此在进行担保信息拷贝时，
        	将担保信息全拷贝*/
		//查找出申请中引入的最高额担保合同信息，并与批复建立关联
		//(合同状态：ContractStatus－010：未签合同；020－已签合同；030－已失效)	
		String sSql =  " select GC.SerialNo from GUARANTY_CONTRACT GC where exists (select AR.ObjectNo from APPLY_RELATIVE AR "+
		" where AR.SerialNo =:SerialNo  and AR.ObjectType='GuarantyContract' and AR.ObjectNo = GC.SerialNo) "+
		" and ContractStatus = '020' ";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", applySerialNo));
		//变量声明
		ASResultSet rs1 = null;
		SqlObject so = null;
		String sFieldValue = "";
		int iFieldType ;
		while(rs.next()){
			sSql =	" insert into APPROVE_RELATIVE(SerialNo,ObjectType,ObjectNo) "+
			" values(:SerialNo,'GuarantyContract',:ObjectNo) ";
			Sqlca.executeSQL(new SqlObject(sSql).setParameter("SerialNo", approveSerialNo).setParameter("ObjectNo", rs.getString("SerialNo")));
			
			//根据申请阶段担保信息的流水号查找到相应的担保物信息
			sSql =  " select GuarantyID,Status,Type from GUARANTY_RELATIVE "+
			" where ObjectType =:ObjectType "+
			" and ObjectNo =:ObjectNo "+
			" and ContractNo =:ContractNo ";
			rs1 = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType", this.oldObjectType).setParameter("ObjectNo", applySerialNo).setParameter("ContractNo", rs.getString("SerialNo")));
			while(rs1.next()){
				sSql =	" insert into GUARANTY_RELATIVE(ObjectType,ObjectNo,ContractNo,GuarantyID,Channel,Status,Type) "+
				" values(:ObjectType,:ObjectNo,:ContractNo, "+
				" :GuarantyID,'Copy',:Status,:Type) ";
				so = new SqlObject(sSql);
				so.setParameter("ObjectType", newObjectType);
				so.setParameter("ObjectNo", approveSerialNo);
				so.setParameter("ContractNo", rs.getString("SerialNo"));
				so.setParameter("GuarantyID", rs1.getString("GuarantyID"));
				so.setParameter("Status", rs1.getString("Status"));
				so.setParameter("Type", rs1.getString("Type"));
				Sqlca.executeSQL(so);
			}
			rs1.getStatement().close();
		}
		rs.getStatement().close();
		
		//查找出申请关联的未签合同的担保信息，即申请阶段新增的担保信息，需要全部拷贝。		
		sSql =  " select GC.* from GUARANTY_CONTRACT GC where exists (select AR.ObjectNo from APPLY_RELATIVE AR "+
		" where AR.SerialNo =:SerialNo  and AR.ObjectType='GuarantyContract' and AR.ObjectNo = GC.SerialNo) "+
		" and GC.ContractStatus = '010' ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", applySerialNo));
		//获得担保信息总列数
		int iColumnCount = rs.getColumnCount();
		while(rs.next()){
			//获得担保信息编号
			String sRelativeSerialNo1 = DBKeyHelp.getSerialNo("GUARANTY_CONTRACT","SerialNo",Sqlca);				
			//插入担保信息
			sSql = " insert into GUARANTY_CONTRACT values(:sRelativeSerialNo1";
			for(int i=2;i<= iColumnCount;i++){
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType)){
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}
			}
			sSql= sSql + ")";
			Sqlca.executeSQL(new SqlObject(sSql).setParameter("sRelativeSerialNo1", sRelativeSerialNo1));
			
			//将新拷贝的担保信息与批复建立关联
			sSql =	" insert into APPROVE_RELATIVE(SerialNo,ObjectType,ObjectNo) "+
			" values(:SerialNo,'GuarantyContract',:ObjectNo)";
			Sqlca.executeSQL(new SqlObject(sSql).setParameter("SerialNo", approveSerialNo).setParameter("ObjectNo", sRelativeSerialNo1));
			
			//根据申请阶段担保信息的流水号查找到相应的担保物信息
		   sSql =  " select GuarantyID,Status,Type from GUARANTY_RELATIVE "+
			" where ObjectType =:ObjectType "+
			" and ObjectNo =:ObjectNo "+
			" and ContractNo =:ContractNo ";
		   so = new SqlObject(sSql);
			so.setParameter("ObjectType", this.oldObjectType);
			so.setParameter("ObjectNo", applySerialNo);
			so.setParameter("ContractNo", rs.getString("SerialNo"));
		   rs1 = Sqlca.getASResultSet(so);
			while(rs1.next()){
				sSql =	" insert into GUARANTY_RELATIVE(ObjectType,ObjectNo,ContractNo,GuarantyID,Channel,Status,Type) "+
				" values(:ObjectType,:ObjectNo,:ContractNo,:GuarantyID,'Copy',:Status,:Type) ";
				 so = new SqlObject(sSql);
				 so.setParameter("ObjectType", newObjectType);
				 so.setParameter("ObjectNo", approveSerialNo);
				 so.setParameter("ContractNo",sRelativeSerialNo1);
				 so.setParameter("GuarantyID", rs1.getString("GuarantyID"));
				 so.setParameter("Status", rs1.getString("Status"));
				 so.setParameter("Type", rs1.getString("Type"));
		       Sqlca.executeSQL(so);
			}
			rs1.getStatement().close();
		}
		rs.getStatement().close();
	}
	
	/**
	 * 拷贝申请信息所对应的共同申请人信息到批复
	 * @param Sqlca
	 * @param approveSerialNo
	 * @throws Exception
	 */
	private void transferApplicant(Transaction Sqlca) throws Exception{
		String sSql =  " select * from BUSINESS_APPLICANT where ObjectType =:ObjectType  and ObjectNo =:ObjectNo  ";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType", this.oldObjectType).setParameter("ObjectNo", applySerialNo));
		int iColumnCount = rs.getColumnCount();
		//变量声明
		String sFieldValue;
		int iFieldType;
		SqlObject so = null;
		while(rs.next()){
			//获得共同申请信息流水号
			String sRelativeSerialNo1 = DBKeyHelp.getSerialNo("BUSINESS_APPLICANT","SerialNo",Sqlca);
			//插入共同申请人信息
			sSql = " insert into BUSINESS_APPLICANT values(:sApproveObjectType,:sSerialNo,:sRelativeSerialNo1";
			for(int i=4;i<= iColumnCount;i++){
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType)){
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}
			}
			sSql= sSql + ")";
			so = new SqlObject(sSql);
			so.setParameter("sApproveObjectType", newObjectType);
			so.setParameter("sSerialNo", approveSerialNo);
			so.setParameter("sRelativeSerialNo1", sRelativeSerialNo1);
			Sqlca.executeSQL(so);
		}
		rs.getStatement().close();
	}
	
	/**
	 * 拷贝申请信息所对应的文档信息到批复
	 * @param Sqlca
	 * @param approveSerialNo
	 * @throws Exception
	 */
	private void transferDoc(Transaction Sqlca) throws Exception{
		//只将申请信息对应的文档关联信息拷贝到批复中
		String sSql =  " insert into DOC_RELATIVE(DocNo,ObjectType,ObjectNo) "+
		" select DocNo,'"+newObjectType+"','"+approveSerialNo+"' from DOC_RELATIVE "+
		" where ObjectType = :ObjectType and ObjectNo = :ObjectNo ";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("ObjectType", this.oldObjectType).setParameter("ObjectNo", applySerialNo));
	}
	
	/**
	 * 拷贝申请信息所对应的项目信息到批复
	 * @param Sqlca
	 * @param approveSerialNo
	 * @throws Exception
	 */
	private void transferProject(Transaction Sqlca) throws Exception{
		//只将申请信息对应的项目关联信息拷贝到批复中
		String sSql =  " insert into PROJECT_RELATIVE(ProjectNo,ObjectType,ObjectNo) "+
		"select ProjectNo,'"+newObjectType+"','"+approveSerialNo+"' from PROJECT_RELATIVE"+
		" where ObjectType =:ObjectType  and ObjectNo =:ObjectNo ";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("ObjectType", this.oldObjectType).setParameter("ObjectNo", applySerialNo));
		
	}
	
	/**
	 * 拷贝申请信息所对应的票据信息到批复
	 * @param Sqlca
	 * @param approveSerialNo
	 * @throws Exception
	 */
	private void transferBill(Transaction Sqlca) throws Exception{
		//查询出申请信息对应的票据信息
		String sSql =  " select * from BILL_INFO where ObjectType =:ObjectType  and ObjectNo =:ObjectNo ";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType", this.oldObjectType).setParameter("ObjectNo", applySerialNo));
		int iColumnCount = rs.getColumnCount();
		//变量声明
		String sFieldValue;
		int iFieldType;
		SqlObject so = null;
		while(rs.next()){
			//获得票据信息流水号
			String sRelativeSerialNo1 = DBKeyHelp.getSerialNo("BILL_INFO","SerialNo",Sqlca);
			//插入票据信息
			sSql = " insert into BILL_INFO values(:sApproveObjectType,:sSerialNo,:sRelativeSerialNo1";
			for(int i=4;i<= iColumnCount;i++){
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType)){
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}
			}
			sSql= sSql + ")";
			so = new SqlObject(sSql);
			so.setParameter("sApproveObjectType", newObjectType);
			so.setParameter("sSerialNo", approveSerialNo);
			so.setParameter("sRelativeSerialNo1", sRelativeSerialNo1);
			Sqlca.executeSQL(so);
		}
		rs.getStatement().close();
	}
	
	/**
	 * 拷贝申请信息所对应的信用证信息到批复
	 * @param Sqlca
	 * @param approveSerialNo
	 * @throws Exception
	 */
	private void transferLCInfo(Transaction Sqlca) throws Exception{
		//查询出申请信息对应的信用证信息
		String sSql =  " select * from LC_INFO where ObjectType =:ObjectType  and ObjectNo =:ObjectNo ";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType", this.oldObjectType).setParameter("ObjectNo", applySerialNo));
		int iColumnCount = rs.getColumnCount();
		//变量声明
		String sFieldValue;
		int iFieldType;
		SqlObject so = null;
		while(rs.next()){
			//获得信用证信息流水号
			String sRelativeSerialNo1 = DBKeyHelp.getSerialNo("LC_INFO","SerialNo",Sqlca);
			//插入信用证信息
			sSql = " insert into LC_INFO values(:sApproveObjectType,:sSerialNo,:sRelativeSerialNo1";
			for(int i=4;i<= iColumnCount;i++){
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType)){
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}
			}
			sSql= sSql + ")";
			so = new SqlObject(sSql);
			so.setParameter("sApproveObjectType", newObjectType);
			so.setParameter("sSerialNo", approveSerialNo);
			so.setParameter("sRelativeSerialNo1", sRelativeSerialNo1);
			Sqlca.executeSQL(so);
		}
		rs.getStatement().close();
	}
	
	/**
	 * 拷贝申请信息所对应的贸易合同信息到批复
	 * @param Sqlca
	 * @param approveSerialNo
	 * @throws Exception
	 */
	private void transferContractInfo(Transaction Sqlca) throws Exception{
		//查询出申请信息对应的贸易合同信息
		String sSql =  " select * from CONTRACT_INFO where ObjectType =:ObjectType  and ObjectNo =:ObjectNo ";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType", this.oldObjectType).setParameter("ObjectNo", applySerialNo));
		int iColumnCount = rs.getColumnCount();
		//变量声明
		String sFieldValue;
		int iFieldType;
		SqlObject so = null;
		while(rs.next()){
			//获得贸易合同信息流水号
			String sRelativeSerialNo1 = DBKeyHelp.getSerialNo("CONTRACT_INFO","SerialNo",Sqlca);
			//插入贸易合同信息
			sSql = " insert into CONTRACT_INFO values(:sApproveObjectType,:sSerialNo,:sRelativeSerialNo1";
			for(int i=4;i<= iColumnCount;i++){
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType)){
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}
			}
			sSql= sSql + ")";
			so = new SqlObject(sSql);
			so.setParameter("sApproveObjectType", newObjectType);
			so.setParameter("sSerialNo", approveSerialNo);
			so.setParameter("sRelativeSerialNo1", sRelativeSerialNo1);
			Sqlca.executeSQL(so);
		}
		rs.getStatement().close();
	}
	
	/**
	 * 拷贝申请信息所对应的增值税发票信息到批复
	 * @param Sqlca
	 * @param approveSerialNo
	 * @throws Exception
	 */
	private void transferInvoice(Transaction Sqlca) throws Exception{
		//查询出申请信息对应的增值税发票信息
		String sSql =  " select * from INVOICE_INFO where ObjectType =:ObjectType  and ObjectNo =:ObjectNo ";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType", this.oldObjectType).setParameter("ObjectNo", applySerialNo));
		int iColumnCount = rs.getColumnCount();
		//变量声明
		String sFieldValue;
		int iFieldType;
		SqlObject so = null;
		while(rs.next()){
			//获得增值税发票信息流水号
			String sRelativeSerialNo1 = DBKeyHelp.getSerialNo("INVOICE_INFO","SerialNo",Sqlca);
			//插入增值税发票信息
			sSql = " insert into INVOICE_INFO values(:sApproveObjectType,:sSerialNo,:sRelativeSerialNo1";
			for(int i=4;i<= iColumnCount;i++){
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType)){
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}
			}
			sSql= sSql + ")";
			so = new SqlObject(sSql);
			so.setParameter("sApproveObjectType", newObjectType);
			so.setParameter("sSerialNo", approveSerialNo);
			so.setParameter("sRelativeSerialNo1", sRelativeSerialNo1);
			Sqlca.executeSQL(so);
		}
		rs.getStatement().close();
	}
	
	/**
	 * 拷贝申请信息所对应的保函信息到批复
	 * @param Sqlca
	 * @param approveSerialNo
	 * @throws Exception
	 */
	
	/**
	 * 拷贝申请信息所对应的中介信息到批复
	 * @param Sqlca
	 * @param approveSerialNo
	 * @throws Exception
	 */
	private void transferAgency(Transaction Sqlca) throws Exception{
		//根据申请信息查询出相对应的中介信息
		String sSql =  " select * from AGENCY_INFO where SerialNo in (select ObjectNo from APPLY_RELATIVE "+
		" where SerialNo =:SerialNo and ObjectType='AgencyInfo') ";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", applySerialNo));
		//获得担保信息总列数
		int iColumnCount = rs.getColumnCount();
		//变量声明
		String sFieldValue;
		int iFieldType;
		while(rs.next()){
			//获得中介信息编号
			String sRelativeSerialNo1 = DBKeyHelp.getSerialNo("AGENCY_INFO","SerialNo",Sqlca);
			//插入中介信息
			sSql = " insert into AGENCY_INFO values(:sRelativeSerialNo1";
			for(int i=2;i<= iColumnCount;i++){
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType)){
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}
			}
			sSql= sSql + ")";
			Sqlca.executeSQL(new SqlObject(sSql).setParameter("sRelativeSerialNo1", sRelativeSerialNo1));
			
			//将新拷贝的中介信息与批复建立关联
			sSql =	" insert into APPROVE_RELATIVE(SerialNo,ObjectType,ObjectNo) "+
			" values(:SerialNo,'AGENCY_INFO',:ObjectNo)";
			Sqlca.executeSQL(new SqlObject(sSql).setParameter("SerialNo", approveSerialNo).setParameter("ObjectNo", sRelativeSerialNo1));
		}
		rs.getStatement().close();
	}
	
	/**
	 * 拷贝申请信息所对应的设备信息到批复
	 * @param Sqlca
	 * @param approveSerialNo
	 * @throws Exception
	 */
	
	
	
	/**
	 * 拷贝申请信息所对应的直接关联信息到批复
	 * @param Sqlca
	 * @param approveSerialNo
	 * @throws Exception
	 */
	private void transferRelative(Transaction Sqlca) throws Exception{
		//将与申请关联表直接关联的信息（除去担保信息）拷贝到批复中
		sSql =	" insert into APPROVE_RELATIVE(SerialNo,ObjectType,ObjectNo) "+
		" select '"+approveSerialNo+"',ObjectType,ObjectNo from APPLY_RELATIVE "+
		" where SerialNo =:SerialNo and ObjectType <> 'GuarantyContract' ";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("SerialNo", applySerialNo));
	}
	
	/**
	 * 拷贝额度信息到批复
	 * @param Sqlca
	 * @param approveSerialNo
	 * @throws Exception
	 */
	private void transferCLInfo(Transaction Sqlca) throws Exception{
		//------------------------------拷贝综合授信申请所对应的方案明细信息到批复中--------------------------------------					
    	sSql =  " update CL_INFO set ApproveSerialNo =:ApproveSerialNo where ApplySerialNo =:ApplySerialNo ";
    	Sqlca.executeSQL(new SqlObject(sSql).setParameter("ApproveSerialNo", approveSerialNo).setParameter("ApplySerialNo", applySerialNo));
		
		//------------------------------拷贝集团授信申请所对应的方案明细信息到批复中--------------------------------------					
		sSql =  " update GLINE_INFO set ApproveSerialNo =:ApproveSerialNo where ApplySerialNo =:ApplySerialNo ";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("ApproveSerialNo", approveSerialNo).setParameter("ApplySerialNo", applySerialNo));

		//------------------------------拷贝关联额度明细信息到批复中--------------------------------------
		sSql =  " select LineNo,IsInUse,Flag,BusinessType from CREDITLINE_RELA where ObjectType =:ObjectType and ObjectNo =:ObjectNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType", this.oldObjectType).setParameter("ObjectNo", applySerialNo));
		String sCRSerialNo,sLineNo,sIsInUse,sFlag,sBusinessType;
		while(rs.next()){
			//获得关联额度表流水号
			sCRSerialNo = DBKeyHelp.getSerialNo("CREDITLINE_RELA","SerialNo",Sqlca);
			sLineNo=rs.getString("LineNo");
			sIsInUse=rs.getString("IsInUse");
			sFlag=rs.getString("Flag");
			sBusinessType=rs.getString("BusinessType");
			//插入关联额度信息
			sSql = " insert into CREDITLINE_RELA(SerialNo,ObjectType,ObjectNo,LineNo,IsInuse,Flag,BusinessType,"+
			"InputDate,InputUser,InputOrg,UpdateDate,UpdateUser,UpdateOrg)"+
			" values(:SerialNo,'ApproveApply',:ObjectNo,:LineNo,:IsInuse,"+
			"        :Flag,:BusinessType,:InputDate,:InputUser,:InputOrg,"+
			"        :UpdateDate,:UpdateUser,:UpdateOrg)  ";
			so = new SqlObject(sSql).setParameter("SerialNo", sCRSerialNo).setParameter("ObjectNo", approveSerialNo).setParameter("LineNo", sLineNo)
			.setParameter("IsInuse", sIsInUse).setParameter("Flag", sFlag).setParameter("BusinessType", sBusinessType)
			.setParameter("InputDate", StringFunction.getToday()).setParameter("InputUser", curUser.getUserID()).setParameter("InputOrg", curUser.getOrgID())
			.setParameter("UpdateDate", StringFunction.getToday()).setParameter("UpdateUser", curUser.getUserID()).setParameter("UpdateOrg", curUser.getOrgID());
			Sqlca.executeSQL(so);
		}
		rs.getStatement().close();
	}
	
	/**
	 * 拷贝额度切分明细信息到批复
	 * @param tx
	 * @param approveSerialNo
	 * @throws Exception
	 */
	private void transferCLDivide(JBOTransaction tx) throws JBOException{
		TransferCLDivide copyBusinessInfo=new TransferCLDivide(applySerialNo,this.oldObjectType,approveSerialNo,newObjectType);
		copyBusinessInfo.copyCLDivide(tx);
	}

	/**
	 * 拷贝额度占用信息
	 * @param tx
	 * @throws JBOException
	 */
	private void transferCLOccupy(JBOTransaction tx) throws JBOException{
		BizObjectManager m=JBOFactory.getBizObjectManager("jbo.app.CL_OCCUPY");
		tx.join(m);
		List<BizObject> lstbiz=m.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType")
		                .setParameter("ObjectNo", this.applySerialNo)
		                .setParameter("ObjectType", this.oldObjectType)
		                .getResultList(false);
		for(BizObject biz:lstbiz){
			BizObject newCO = m.newObject();
			newCO.setAttributesValue(biz);
			newCO.setAttributeValue("SerialNo", null);
			newCO.setAttributeValue("ObjectType", this.newObjectType);
			newCO.setAttributeValue("ObjectNo", getApproveSerialNo());
			m.saveObject(newCO);
		}
	}
	
	
	/**
	 * 拷贝审批意见对应的利率
	 * @param tx
	 * @param approveSerialNo
	 * @throws Exception
	 */
	private void transferRate(JBOTransaction tx) throws Exception{
		BizObjectManager m=JBOFactory.getBizObjectManager(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment);
		tx.join(m);
		List<BizObject> lstbiz=m.createQuery("ObjectType='"+BUSINESSOBJECT_CONSTATNTS.flow_opinion+"' and ObjectNo in(select max(FO.OpinionNo) as V.SerialNo from jbo.app.FLOW_OPINION FO where FO.ObjectNo = :ObjectNo and FO.ObjectType='CreditApply'  )")
		                .setParameter("ObjectNo", this.applySerialNo)
		                .getResultList(false);
		for(BizObject biz:lstbiz){
			BizObject newCO = m.newObject();
			newCO.setAttributesValue(biz);
			newCO.setAttributeValue("SerialNo", null);
			newCO.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_approve);
			newCO.setAttributeValue("ObjectNo", getApproveSerialNo());
			m.saveObject(newCO);
		}
	}
	
	
	/**
	 * 拷贝审批意见对应的还款方式
	 * @param tx
	 * @param approveSerialNo
	 * @throws Exception
	 */
	private void transferRPT(JBOTransaction tx) throws Exception{
		BizObjectManager m=JBOFactory.getBizObjectManager(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
		tx.join(m);
		List<BizObject> lstbiz=m.createQuery("ObjectType='"+BUSINESSOBJECT_CONSTATNTS.flow_opinion+"' and ObjectNo in(select max(FO.OpinionNo) as V.SerialNo from jbo.app.FLOW_OPINION FO where FO.ObjectNo = :ObjectNo and FO.ObjectType='CreditApply'  )")
		                .setParameter("ObjectNo", this.applySerialNo)
		                .getResultList(false);
		for(BizObject biz:lstbiz){
			BizObject newCO = m.newObject();
			newCO.setAttributesValue(biz);
			newCO.setAttributeValue("SerialNo", null);
			newCO.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_approve);
			newCO.setAttributeValue("ObjectNo", getApproveSerialNo());
			m.saveObject(newCO);
		}
	}
	
	
	/**
	 * 拷贝审批意见对应的费用
	 * @param tx
	 * @param approveSerialNo
	 * @throws Exception
	 */
	private void transferFee(JBOTransaction tx) throws Exception{
		BizObjectManager m=JBOFactory.getBizObjectManager(BUSINESSOBJECT_CONSTATNTS.fee);
		BizObjectManager ms=JBOFactory.getBizObjectManager(BUSINESSOBJECT_CONSTATNTS.fee_waive);
		BizObjectManager ma=JBOFactory.getBizObjectManager(BUSINESSOBJECT_CONSTATNTS.loan_accounts);
		tx.join(m);
		tx.join(ms);
		tx.join(ma);
		List<BizObject> lstbiz=m.createQuery("ObjectType='"+BUSINESSOBJECT_CONSTATNTS.flow_opinion+"' and ObjectNo in(select max(FO.OpinionNo) as V.SerialNo from jbo.app.FLOW_OPINION FO where FO.ObjectNo = :ObjectNo and FO.ObjectType='CreditApply'  )")
		                .setParameter("ObjectNo", this.applySerialNo)
		                .getResultList(false);
		for(BizObject biz:lstbiz){
			BizObject newCO = m.newObject();
			newCO.setAttributesValue(biz);
			newCO.setAttributeValue("SerialNo", null);
			newCO.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_approve);
			newCO.setAttributeValue("ObjectNo", getApproveSerialNo());
			m.saveObject(newCO);
			
			String oldFeeSerialNo = biz.getAttribute("SerialNo").getString();
			String feeSerialNo = newCO.getAttribute("SerialNo").getString();
			List<BizObject> feeWaive = ms.createQuery("ObjectType=:ObjectType and ObjectNo=:ObjectNo")
											.setParameter("ObjectNo", oldFeeSerialNo)
											.setParameter("ObjectType", BUSINESSOBJECT_CONSTATNTS.fee)
											.getResultList(false);
			for(BizObject boWaive : feeWaive)
			{
				BizObject newWaive = ms.newObject();
				newWaive.setAttributesValue(boWaive);
				newWaive.setAttributeValue("SerialNo", null);
				newWaive.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.fee);
				newWaive.setAttributeValue("ObjectNo", feeSerialNo);
				ms.saveObject(newWaive);
			}
			
			List<BizObject> boAccounts=ma.createQuery("ObjectType = :ObjectType and ObjectNo = :ObjectNo ")
										.setParameter("ObjectType", BUSINESSOBJECT_CONSTATNTS.fee)
							            .setParameter("ObjectNo", oldFeeSerialNo)
							            .getResultList(false);
			for(BizObject boAccount:boAccounts){
				BizObject newAccount = ma.newObject();
				newAccount.setAttributesValue(boAccount);
				newAccount.setAttributeValue("SerialNo", null);
				newAccount.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.fee);
				newAccount.setAttributeValue("ObjectNo", feeSerialNo);
				ma.saveObject(newAccount);
			}
		}
	}
	
	/**
	 * 拷贝审批意见对应的贴息
	 * @param tx
	 * @param approveSerialNo
	 * @throws Exception
	 */
	private void transferSPT(JBOTransaction tx) throws Exception{
		BizObjectManager m=JBOFactory.getBizObjectManager(BUSINESSOBJECT_CONSTATNTS.loan_spt_segment);
		tx.join(m);
		List<BizObject> lstbiz=m.createQuery("ObjectType='"+BUSINESSOBJECT_CONSTATNTS.flow_opinion+"' and ObjectNo in(select max(FO.OpinionNo) as V.SerialNo from jbo.app.FLOW_OPINION FO where FO.ObjectNo = :ObjectNo and FO.ObjectType='CreditApply'  )")
		                .setParameter("ObjectNo", this.applySerialNo)
		                .getResultList(false);
		for(BizObject biz:lstbiz){
			BizObject newCO = m.newObject();
			newCO.setAttributesValue(biz);
			newCO.setAttributeValue("SerialNo", null);
			newCO.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_approve);
			newCO.setAttributeValue("ObjectNo", getApproveSerialNo());
			m.saveObject(newCO);
		}
	}
	
	/**
	 * 拷贝申请信息的账号信息
	 * @param tx
	 * @param approveSerialNo
	 * @throws Exception
	 */
	private void transferAccountNo(JBOTransaction tx) throws Exception{
		BizObjectManager m=JBOFactory.getBizObjectManager(BUSINESSOBJECT_CONSTATNTS.loan_accounts);
		tx.join(m);
		List<BizObject> lstbiz=m.createQuery("ObjectType='"+BUSINESSOBJECT_CONSTATNTS.business_apply+"' and ObjectNo = :ObjectNo ")
		                .setParameter("ObjectNo", this.applySerialNo)
		                .getResultList(false);
		for(BizObject biz:lstbiz){
			BizObject newCO = m.newObject();
			newCO.setAttributesValue(biz);
			newCO.setAttributeValue("SerialNo", null);
			newCO.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_approve);
			newCO.setAttributeValue("ObjectNo", getApproveSerialNo());
			m.saveObject(newCO);
		}
	}
	
	
	//判断字段类型是否为数字类型
	private static boolean isNumeric(int iType){
		if (iType==java.sql.Types.BIGINT ||iType==java.sql.Types.INTEGER || iType==java.sql.Types.SMALLINT || iType==java.sql.Types.DECIMAL || iType==java.sql.Types.NUMERIC || iType==java.sql.Types.DOUBLE || iType==java.sql.Types.FLOAT ||iType==java.sql.Types.REAL)
			return true;
		return false;
	}

}
