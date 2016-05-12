package com.amarsoft.app.als.credit.contract.action;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.als.bizobject.BusinessType;
import com.amarsoft.app.als.credit.approve.action.TransferCLDivide;
import com.amarsoft.app.als.credit.cl.model.ContractEffect;
import com.amarsoft.app.als.credit.common.model.CreditConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
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
 * 1、将申请基本信息及其关联信息复制到批复中,改写部分sqlca为jbo,并整理部分方法、参数
 * 2、从申请直接生成合同的功能
 * @author jschen
 *
 */
public class AddContractInfo{
	
	private ASUser curUser = null;
	private String newContractSerialNo = ""; //合同流水号
	private String newObjectType = "BusinessContract"; 
	private BizObject oldObject = null;
	private String oldObjectType = ""; 
	private String oldObjectSerialNo = ""; 
	private BizObject boContract=null; //新合同jbo
	
	//临时变量声明
	private String sFieldValue,sSql,sRelativeSerialNo1;
	private int iColumnCount,iFieldType;
	private ASResultSet rs,rs1 = null;
	
	public AddContractInfo(BizObject oldObject, String oldObjectType, ASUser curUser) throws JBOException {
		this.oldObject = oldObject;
		this.oldObjectType = oldObjectType;
		this.curUser = curUser;
		this.oldObjectSerialNo = this.oldObject.getAttribute("SerialNo").getString();
	}

	public String getNewContractSerialNo() {
		return newContractSerialNo;
	}

	public void setNewContractSerialNo(String contractSerialNo) {
		this.newContractSerialNo = contractSerialNo;
	}
	
	/**
	 * 
	 * @param tx
	 * @throws Exception
	 */
	public String transfer(JBOTransaction tx) throws Exception{
		transferOldObject(tx);
		Transaction areTrans = Transaction.createTransaction(tx);
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
		generateNewOccupy(tx);
		transferAccountNo(tx);
		transferRate(tx);
		transferRPT(tx);
		transferSPT(tx);
		transferFee(tx);
		return this.getNewContractSerialNo();
	}
	
	/**
	 * 如果是额度项下合同，需要新建立与对应分项额度的占用关系
	 * @param tx
	 * @throws JBOException
	 */
	private void generateNewOccupy(JBOTransaction tx)throws JBOException{
		if(boContract.getAttribute("ApplyType").equals(CreditConst.APPLYTYPE_DEPENDENT)){
			ContractEffect coe=new ContractEffect(boContract); 
			try {
				coe.newCLOccupy(tx);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	/**
	 * 拷贝批复基本信息到合同
	 * @param tx
	 * @return
	 * @throws JBOException
	 */
	private String transferOldObject(JBOTransaction tx)throws JBOException{
		String contractSerialNo = "";
		JBOFactory f = JBOFactory.getFactory();
		
		//取合同，如果合同存在则直接返回该合同流水
		BizObjectManager mContract = f.getManager("jbo.app.BUSINESS_CONTRACT");
		tx.join(mContract);
		
		boContract = mContract.newObject();
		boContract.setAttributesValue(oldObject);
		
		boContract.setAttributeValue("SerialNo", null);
		boContract.getAttribute("RelativeSerialNo").setValue(oldObject.getAttribute("SerialNo"));//相关批复流水号
		boContract.getAttribute("TempSaveFlag").setValue(CreditConst.SAVE_FLAG_TEMP);
		boContract.getAttribute("FreezeFlag").setValue("1");
		boContract.getAttribute("ReinforceFlag").setValue(CreditConst.REINFORCEFLAG_NORMAL); //补登标志
		boContract.getAttribute("PutOutOrgID").setValue(curUser.getOrgID()); //设置放贷机构
		boContract.getAttribute("MANAGEORGID").setValue(oldObject.getAttribute("OperateOrgID")); //管户机构
		boContract.getAttribute("MANAGEUSERID").setValue(oldObject.getAttribute("OperateUserID")); //管户人
		boContract.getAttribute("OccurDate").setValue(DateX.format(new java.util.Date(), "yyyy/MM/dd"));
		boContract.getAttribute("InputOrgID").setValue(curUser.getOrgID());
		boContract.getAttribute("InputUserID").setValue(curUser.getUserID());
		boContract.getAttribute("InputDate").setValue(DateX.format(new java.util.Date(), "yyyy/MM/dd"));
		boContract.getAttribute("UpdateDate").setValue(DateX.format(new java.util.Date(), "yyyy/MM/dd"));
		
		boContract.getAttribute("PutOutDate").setValue(DateX.format(new java.util.Date(), "yyyy/MM/dd")); //合同起始日
		int iTermYear=oldObject.getAttribute("TermYear").getInt()*12;
		int iTermMonth=oldObject.getAttribute("TermMonth").getInt();
		int iTermDay=oldObject.getAttribute("TermDay").getInt();
		String sMaturity = StringFunction.getRelativeMonth(DateX.format(new java.util.Date(), "yyyy/MM/dd"),iTermYear+iTermMonth);
		sMaturity = StringFunction.getRelativeDate(sMaturity, iTermDay);  
		boContract.getAttribute("Maturity").setValue(sMaturity); //合同到期日
		
		//设置表内外属性
		//取当前业务表内外属性
		String sOffSheetFlag=BusinessType.getInstance(boContract.getAttribute("BusinessType").getString()).getOffSheetFlag();
		boContract.getAttribute("OffSheetFlag").setValue(sOffSheetFlag);
		//保存BUSINESS_CONTRACT
		mContract.saveObject(boContract);
		contractSerialNo = boContract.getAttribute("SerialNo").getString(); //获得合同流水号
		
		//更改审批表中关于是否签订合同的标签
		BizObjectManager oldManager = f.getManager(oldObject.getBizObjectClass().toString());
		tx.join(oldManager);
		oldObject.getAttribute("Flag5").setValue(CreditConst.BAP_FLAG5_REGISTERED); //如果是申请直接复制到合同，此处value值不变
		oldManager.saveObject(oldObject);
		setNewContractSerialNo(contractSerialNo);
		return contractSerialNo;
	}

	/**
	 * 拷贝批复信息所对应的担保信息到合同
	 * @param Sqlca
	 * @param oldObjectSerialNo
	 * @throws Exception
	 */
	private void transferGuaranty(Transaction Sqlca) throws Exception{
		/*请注意：在批复的担保信息中存在新增的担保信息和引入最高额的担保信息，因此在进行担保信息拷贝时，
		        将担保信息全拷贝*/
		//查找出批复中引入的最高额担保合同信息，并与批复建立关联
		//(合同状态：ContractStatus－010：未签合同；020－已签合同；030－已失效)	
		sSql =  " select GC.SerialNo from GUARANTY_CONTRACT GC where exists (select AR.ObjectNo from APPROVE_RELATIVE AR "+
				" where AR.SerialNo =:sObjectNo and AR.ObjectType='GuarantyContract' and AR.ObjectNo = GC.SerialNo) "+
				" and ContractStatus = '020' ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectNo", oldObjectSerialNo));
		while(rs.next()){
			sSql =	" insert into CONTRACT_RELATIVE(SerialNo,ObjectType,ObjectNo,RelationStatus) "+
					" values(:sSerialNo ,'GuarantyContract','"+rs.getString("SerialNo")+"','010') ";
			Sqlca.executeSQL(new SqlObject(sSql).setParameter("sSerialNo", newContractSerialNo));
			
			//根据批复阶段担保信息的流水号查找到相应的担保物信息
			sSql =  " select GuarantyID,Status,Type from GUARANTY_RELATIVE "+
					" where ObjectType =:sObjectType "+
					" and ObjectNo =:sObjectNo "+
					" and ContractNo = '" +rs.getString("SerialNo")+"' ";
			rs1 = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectType", oldObjectType).setParameter("sObjectNo", oldObjectSerialNo));				
			while(rs1.next()){
				sSql =	" insert into GUARANTY_RELATIVE(ObjectType,ObjectNo,ContractNo,GuarantyID,Channel,Status,Type) "+
						" values(:newObjectType ,:sSerialNo ,'"+rs.getString("SerialNo")+"', "+
						" '"+rs1.getString("GuarantyID")+"','Copy','"+rs1.getString("Status")+"','"+rs1.getString("Type")+"') ";
				Sqlca.executeSQL(new SqlObject(sSql).setParameter("newObjectType", newObjectType).setParameter("sSerialNo", newContractSerialNo));	
			}
			rs1.getStatement().close();
		}
		rs.getStatement().close();
		
		//查找出批复关联的未签合同的担保信息，即批复阶段新增的担保信息，需要全部拷贝。	
		sSql =  " select GC.* from GUARANTY_CONTRACT GC where exists (select AR.ObjectNo from APPROVE_RELATIVE AR "+
				" where AR.SerialNo =:sObjectNo and AR.ObjectType='GuarantyContract' and AR.ObjectNo = GC.SerialNo) "+
				" and GC.ContractStatus = '010' ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectNo", oldObjectSerialNo));
		//获得担保信息总列数
		iColumnCount = rs.getColumnCount();
		while(rs.next()){
			//获得担保信息编号
			sRelativeSerialNo1 = DBKeyHelp.getSerialNo("GUARANTY_CONTRACT","SerialNo",Sqlca);
			//插入担保信息
			sSql = " insert into GUARANTY_CONTRACT values('"+sRelativeSerialNo1+"'";
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
			Sqlca.executeSQL(new SqlObject(sSql));
			
			//更改担保合同状态
			//sSql =	" update GUARANTY_CONTRACT set ContractStatus='020' where SerialNo = '"+sRelativeSerialNo1+"' ";
			//Sqlca.executeSQL(sSql);
			
			//将新拷贝的担保信息与合同建立关联
			sSql =	" insert into CONTRACT_RELATIVE(SerialNo,ObjectType,ObjectNo,RelationStatus) "+
					" values(:contractSerialNo ,'GuarantyContract',:sRelativeSerialNo1 ,'010')";
			Sqlca.executeSQL(new SqlObject(sSql).setParameter("contractSerialNo", newContractSerialNo).setParameter("sRelativeSerialNo1", sRelativeSerialNo1));
						
			//根据批复阶段担保信息的流水号查找到相应的担保物信息
			sSql =  " select GuarantyID,Status,Type from GUARANTY_RELATIVE "+
					" where ObjectType =:sObjectType "+
					" and ObjectNo =:sObjectNo "+
					" and ContractNo = '" +rs.getString("SerialNo")+"' ";
			rs1 = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectType", oldObjectType).setParameter("sObjectNo", oldObjectSerialNo));				
			while(rs1.next()){
				sSql =	" insert into GUARANTY_RELATIVE(ObjectType,ObjectNo,ContractNo,GuarantyID,Channel,Status,Type) "+
						" values(:newObjectType ,:contractSerialNo ,:sRelativeSerialNo1 , "+
						" '"+rs1.getString("GuarantyID")+"','Copy','"+rs1.getString("Status")+"','"+rs1.getString("Type")+"') ";
				Sqlca.executeSQL(new SqlObject(sSql).setParameter("newObjectType", newObjectType).setParameter("contractSerialNo", newContractSerialNo)
						.setParameter("sRelativeSerialNo1", sRelativeSerialNo1));	
			}
			rs1.getStatement().close();
		}
		rs.getStatement().close();
	}
	/**
	 * 拷贝批复信息所对应的共同申请人信息到合同
	 * @param Sqlca
	 * @throws Exception
	 */
	private void transferApplicant(Transaction Sqlca) throws Exception{
		//查询出批复信息对应的共同申请人信息
		sSql =  " select * from BUSINESS_APPLICANT where ObjectType =:sObjectType and ObjectNo =:sObjectNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectType", oldObjectType).setParameter("sObjectNo", oldObjectSerialNo));
		iColumnCount = rs.getColumnCount();
		while(rs.next()){
			//获得共同申请信息流水号
			sRelativeSerialNo1 = DBKeyHelp.getSerialNo("BUSINESS_APPLICANT","SerialNo",Sqlca);
			//插入共同申请人信息
			sSql = " insert into BUSINESS_APPLICANT values('"+newObjectType+"','"+newContractSerialNo+"','"+sRelativeSerialNo1+"'";
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
			Sqlca.executeSQL(new SqlObject(sSql));
		}
		rs.getStatement().close();
	}
	
	/**
	 * 拷贝批复信息所对应的文档信息到合同
	 * @param Sqlca
	 * @throws Exception
	 */
	private void  transferDoc(Transaction Sqlca) throws Exception{
		//只将批复信息对应的文档关联信息拷贝到合同中
		sSql =  " insert into DOC_RELATIVE(DocNo,ObjectType,ObjectNo) "+
				" select DocNo,'"+newObjectType+"','"+newContractSerialNo+"' from DOC_RELATIVE "+
				" where ObjectType =:sObjectType and ObjectNo =:sObjectNo ";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("sObjectType", oldObjectType).setParameter("sObjectNo", oldObjectSerialNo));
	}
	
	/**
	 * 拷贝批复信息所对应的项目信息到合同
	 * @param Sqlca
	 * @throws Exception
	 */
	private void  transferProject(Transaction Sqlca) throws Exception{ 
		//只将批复信息对应的项目关联信息拷贝到合同中
		sSql =  " insert into PROJECT_RELATIVE(ProjectNo,ObjectType,ObjectNo) "+
				" select ProjectNo,'"+newObjectType+"','"+newContractSerialNo+"' from PROJECT_RELATIVE "+
				" where ObjectType =:sObjectType and ObjectNo =:sObjectNo ";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("sObjectType", oldObjectType).setParameter("sObjectNo", oldObjectSerialNo));

	}
	
	/**
	 * 拷贝批复信息所对应的票据信息到合同
	 * @param Sqlca
	 * @throws Exception
	 */
	private void  transferBill(Transaction Sqlca) throws Exception{ 
		//查询出批复信息对应的票据信息
		sSql =  " select * from BILL_INFO where ObjectType =:sObjectType and ObjectNo =:sObjectNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectType", oldObjectType).setParameter("sObjectNo", oldObjectSerialNo));
		iColumnCount = rs.getColumnCount();
		while(rs.next()){
			//获得票据信息流水号
			sRelativeSerialNo1 = DBKeyHelp.getSerialNo("BILL_INFO","SerialNo",Sqlca);
			//插入票据信息
			sSql = " insert into BILL_INFO values('"+newObjectType+"','"+newContractSerialNo+"','"+sRelativeSerialNo1+"'";
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
			Sqlca.executeSQL(new SqlObject(sSql));
		}
		rs.getStatement().close();	
	}
	
	/**
	 * 拷贝批复信息所对应的信用证信息到合同
	 * @param Sqlca
	 * @throws Exception
	 */
	private void  transferLCInfo(Transaction Sqlca) throws Exception{
		//查询出批复信息对应的信用证信息
		sSql =  " select * from LC_INFO where ObjectType =:sObjectType and ObjectNo =:sObjectNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectType", oldObjectType).setParameter("sObjectNo", oldObjectSerialNo));
		iColumnCount = rs.getColumnCount();
		while(rs.next()){
			//获得信用证信息流水号
			sRelativeSerialNo1 = DBKeyHelp.getSerialNo("LC_INFO","SerialNo",Sqlca);
			//插入信用证信息
			sSql = " insert into LC_INFO values('"+newObjectType+"','"+newContractSerialNo+"','"+sRelativeSerialNo1+"'";
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
			Sqlca.executeSQL(new SqlObject(sSql));
		}
		rs.getStatement().close();
	}
	
	/**
	 * 拷贝批复信息所对应的贸易合同信息到合同
	 * @param Sqlca
	 * @throws Exception
	 */
	private void  transferContractInfo(Transaction Sqlca) throws Exception{  
		//查询出批复信息对应的贸易合同信息
		sSql =  " select * from CONTRACT_INFO where ObjectType =:sObjectType and ObjectNo =:sObjectNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectType", oldObjectType).setParameter("sObjectNo", oldObjectSerialNo));
		iColumnCount = rs.getColumnCount();
		while(rs.next()){
			//获得贸易合同信息流水号
			sRelativeSerialNo1 = DBKeyHelp.getSerialNo("CONTRACT_INFO","SerialNo",Sqlca);
			//插入贸易合同信息
			sSql = " insert into CONTRACT_INFO values('"+newObjectType+"','"+newContractSerialNo+"','"+sRelativeSerialNo1+"'";
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
			Sqlca.executeSQL(new SqlObject(sSql));
		}
		rs.getStatement().close();	
	}
	
	/**
	 * 拷贝批复信息所对应的增值税发票信息到合同
	 * @param Sqlca
	 * @throws Exception
	 */
	private void  transferInvoice(Transaction Sqlca) throws Exception{  
		//查询出批复信息对应的增值税发票信息
		sSql =  " select * from INVOICE_INFO where ObjectType =:sObjectType and ObjectNo =:sObjectNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectType", oldObjectType).setParameter("sObjectNo", oldObjectSerialNo));
		iColumnCount = rs.getColumnCount();
		while(rs.next()){
			//获得增值税发票信息流水号
			sRelativeSerialNo1 = DBKeyHelp.getSerialNo("INVOICE_INFO","SerialNo",Sqlca);
			//插入增值税发票信息
			sSql = " insert into INVOICE_INFO values('"+newObjectType+"','"+newContractSerialNo+"','"+sRelativeSerialNo1+"'";
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
			Sqlca.executeSQL(new SqlObject(sSql));
		}
		rs.getStatement().close();		
	}
	
	
	/**
	 * 拷贝批复信息所对应的保函信息到合同
	 * @param Sqlca
	 * @throws Exception
	 */
	
	/**
	 * 拷贝批复信息所对应的中介信息到合同
	 * @param Sqlca
	 * @throws Exception
	 */
	private void  transferAgency(Transaction Sqlca) throws Exception{
		//根据批复信息查询出相对应的中介信息
		sSql =  " select * from AGENCY_INFO where SerialNo in (select ObjectNo from APPROVE_RELATIVE "+
				" where SerialNo =:sObjectNo and ObjectType='AGENCY_INFO') ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectNo", oldObjectSerialNo));
		//获得担保信息总列数
		iColumnCount = rs.getColumnCount();
		while(rs.next()){
			//获得中介信息编号
			sRelativeSerialNo1 = DBKeyHelp.getSerialNo("AGENCY_INFO","SerialNo",Sqlca);
			//插入中介信息
			sSql = " insert into AGENCY_INFO values('"+sRelativeSerialNo1+"'";
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
			Sqlca.executeSQL(new SqlObject(sSql));
			
			//将新拷贝的中介信息与合同建立关联
			sSql =	" insert into CONTRACT_RELATIVE(SerialNo,ObjectType,ObjectNo,RelationStatus) "+
					" values(:contractSerialNo ,'AGENCY_INFO',:sRelativeSerialNo1 ,'010')";
			Sqlca.executeSQL(new SqlObject(sSql).setParameter("contractSerialNo", newContractSerialNo).setParameter("sRelativeSerialNo1", sRelativeSerialNo1));	
		}
		rs.getStatement().close();
	}
	
	/**
	 * 拷贝批复信息所对应的设备信息到合同
	 * @param Sqlca
	 * @throws Exception
	 */
	
	
	/**
	 * 拷贝批复信息所对应的直接关联信息到合同
	 * @param Sqlca
	 * @throws Exception
	 */
	private void  transferRelative(Transaction Sqlca) throws Exception{
		//将与批复关联表直接关联的信息（除去担保信息）拷贝到合同中
		sSql =	" insert into CONTRACT_RELATIVE(SerialNo,ObjectType,ObjectNo,RelationStatus) "+
				" select '"+newContractSerialNo+"',ObjectType,ObjectNo,'010' from APPROVE_RELATIVE "+
				" where SerialNo =:sObjectNo and ObjectType <> 'GuarantyContract' ";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("sObjectNo", oldObjectSerialNo));
	}
	
	/**
	 * 拷贝额度信息到合同
	 * @param Sqlca
	 * @throws Exception
	 */
	private void  transferCLInfo(Transaction Sqlca) throws Exception{ 
		//------------------------------拷贝综合授信批复所对应的方案明细信息到合同中--------------------------------------					
		sSql =  " update CL_INFO set BCSerialNo =:contractSerialNo where ApproveSerialNo =:sObjectNo ";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("contractSerialNo", newContractSerialNo).setParameter("sObjectNo", oldObjectSerialNo));
		
		//------------------------------拷贝集团授信批复所对应的方案明细信息到合同中--------------------------------------					
		sSql =  " update GLINE_INFO set BCSerialNo =:contractSerialNo where ApproveSerialNo =:sObjectNo ";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("contractSerialNo", newContractSerialNo).setParameter("sObjectNo", oldObjectSerialNo));
		
		//------------------------------拷贝关联额度明细信息到合同中--------------------------------------
		sSql =  " select LineNo,IsInUse,Flag,BusinessType from CREDITLINE_RELA where ObjectType =:sObjectType and ObjectNo =:sObjectNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectType", oldObjectType).setParameter("sObjectNo", oldObjectSerialNo));
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
				   " values(:sCRSerialNo ,'BusinessContract',:contractSerialNo ,:sLineNo ,:sIsInUse ,"+
				   "        :sFlag ,:sBusinessType ,'"+StringFunction.getToday()+"','"+curUser.getUserID()+"','"+curUser.getOrgID()+"',"+
				   "        '"+StringFunction.getToday()+"','"+curUser.getUserID()+"','"+curUser.getOrgID()+"')  ";
			Sqlca.executeSQL(new SqlObject(sSql).setParameter("sCRSerialNo", sCRSerialNo).setParameter("contractSerialNo", newContractSerialNo)
					.setParameter("sLineNo", sLineNo).setParameter("sIsInUse", sIsInUse).setParameter("sFlag", sFlag).setParameter("sBusinessType", sBusinessType));
		}
		rs.getStatement().close();
	}
	
	/**
	 * 拷贝额度分配信息到合同
	 * @param tx
	 * @throws JBOException
	 */
	private void transferCLDivide(JBOTransaction tx) throws JBOException{
		TransferCLDivide copyBusinessInfo=new TransferCLDivide(oldObjectSerialNo,oldObjectType,newContractSerialNo,newObjectType);
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
		                .setParameter("ObjectNo", this.oldObjectSerialNo).setParameter("ObjectType", this.oldObjectType)
		                .getResultList(true);
		for(BizObject biz:lstbiz){
			BizObject newCO = m.newObject();
			newCO.setAttributesValue(biz);
			newCO.setAttributeValue("SerialNo", null);
			newCO.setAttributeValue("ObjectType", this.newObjectType);
			newCO.setAttributeValue("ObjectNo", getNewContractSerialNo());
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
		List<BizObject> lstbiz=m.createQuery("ObjectType = :ObjectType and ObjectNo = :ObjectNo")
						.setParameter("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_approve)
		                .setParameter("ObjectNo", this.oldObjectSerialNo)
		                .getResultList(false);
		for(BizObject biz:lstbiz){
			BizObject newCO = m.newObject();
			newCO.setAttributesValue(biz);
			newCO.setAttributeValue("SerialNo", null);
			newCO.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_contract);
			newCO.setAttributeValue("ObjectNo", getNewContractSerialNo());
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
		List<BizObject> lstbiz=m.createQuery("ObjectType = :ObjectType and ObjectNo = :ObjectNo")
									.setParameter("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_approve)
							        .setParameter("ObjectNo", this.oldObjectSerialNo)
							        .getResultList(false);
		for(BizObject biz:lstbiz){
			BizObject newCO = m.newObject();
			newCO.setAttributesValue(biz);
			newCO.setAttributeValue("SerialNo", null);
			newCO.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_contract);
			newCO.setAttributeValue("ObjectNo", getNewContractSerialNo());
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
		List<BizObject> lstbiz=m.createQuery("ObjectType = :ObjectType and ObjectNo = :ObjectNo")
								.setParameter("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_approve)
						        .setParameter("ObjectNo", this.oldObjectSerialNo)
						        .getResultList(false);
		for(BizObject biz:lstbiz){
			BizObject newCO = m.newObject();
			newCO.setAttributesValue(biz);
			newCO.setAttributeValue("SerialNo", null);
			newCO.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_contract);
			newCO.setAttributeValue("ObjectNo", getNewContractSerialNo());
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
		List<BizObject> lstbiz=m.createQuery("ObjectType = :ObjectType and ObjectNo = :ObjectNo")
								.setParameter("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_approve)
						        .setParameter("ObjectNo", this.oldObjectSerialNo)
						        .getResultList(false);
		for(BizObject biz:lstbiz){
			BizObject newCO = m.newObject();
			newCO.setAttributesValue(biz);
			newCO.setAttributeValue("SerialNo", null);
			newCO.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_contract);
			newCO.setAttributeValue("ObjectNo", getNewContractSerialNo());
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
		List<BizObject> lstbiz=m.createQuery("ObjectType = :ObjectType and ObjectNo = :ObjectNo")
								.setParameter("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_approve)
						        .setParameter("ObjectNo", this.oldObjectSerialNo)
						        .getResultList(false);
		for(BizObject biz:lstbiz){
			BizObject newCO = m.newObject();
			newCO.setAttributesValue(biz);
			newCO.setAttributeValue("SerialNo", null);
			newCO.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_contract);
			newCO.setAttributeValue("ObjectNo", getNewContractSerialNo());
			m.saveObject(newCO);
		}
	}
	
	
	//判断字段类型是否为数字类型
	private static boolean isNumeric(int iType) {
		if (iType==java.sql.Types.BIGINT ||iType==java.sql.Types.INTEGER || iType==java.sql.Types.SMALLINT || iType==java.sql.Types.DECIMAL || iType==java.sql.Types.NUMERIC || iType==java.sql.Types.DOUBLE || iType==java.sql.Types.FLOAT ||iType==java.sql.Types.REAL)
			return true;
		return false;
	}

}
