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
 * 1�������������Ϣ���������Ϣ���Ƶ�������,��д����sqlcaΪjbo,�������ַ���������
 * 2��������ֱ�����ɺ�ͬ�Ĺ���
 * @author jschen
 *
 */
public class AddContractInfo{
	
	private ASUser curUser = null;
	private String newContractSerialNo = ""; //��ͬ��ˮ��
	private String newObjectType = "BusinessContract"; 
	private BizObject oldObject = null;
	private String oldObjectType = ""; 
	private String oldObjectSerialNo = ""; 
	private BizObject boContract=null; //�º�ͬjbo
	
	//��ʱ��������
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
	 * ����Ƕ�����º�ͬ����Ҫ�½������Ӧ�����ȵ�ռ�ù�ϵ
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
	 * ��������������Ϣ����ͬ
	 * @param tx
	 * @return
	 * @throws JBOException
	 */
	private String transferOldObject(JBOTransaction tx)throws JBOException{
		String contractSerialNo = "";
		JBOFactory f = JBOFactory.getFactory();
		
		//ȡ��ͬ�������ͬ������ֱ�ӷ��ظú�ͬ��ˮ
		BizObjectManager mContract = f.getManager("jbo.app.BUSINESS_CONTRACT");
		tx.join(mContract);
		
		boContract = mContract.newObject();
		boContract.setAttributesValue(oldObject);
		
		boContract.setAttributeValue("SerialNo", null);
		boContract.getAttribute("RelativeSerialNo").setValue(oldObject.getAttribute("SerialNo"));//���������ˮ��
		boContract.getAttribute("TempSaveFlag").setValue(CreditConst.SAVE_FLAG_TEMP);
		boContract.getAttribute("FreezeFlag").setValue("1");
		boContract.getAttribute("ReinforceFlag").setValue(CreditConst.REINFORCEFLAG_NORMAL); //���Ǳ�־
		boContract.getAttribute("PutOutOrgID").setValue(curUser.getOrgID()); //���÷Ŵ�����
		boContract.getAttribute("MANAGEORGID").setValue(oldObject.getAttribute("OperateOrgID")); //�ܻ�����
		boContract.getAttribute("MANAGEUSERID").setValue(oldObject.getAttribute("OperateUserID")); //�ܻ���
		boContract.getAttribute("OccurDate").setValue(DateX.format(new java.util.Date(), "yyyy/MM/dd"));
		boContract.getAttribute("InputOrgID").setValue(curUser.getOrgID());
		boContract.getAttribute("InputUserID").setValue(curUser.getUserID());
		boContract.getAttribute("InputDate").setValue(DateX.format(new java.util.Date(), "yyyy/MM/dd"));
		boContract.getAttribute("UpdateDate").setValue(DateX.format(new java.util.Date(), "yyyy/MM/dd"));
		
		boContract.getAttribute("PutOutDate").setValue(DateX.format(new java.util.Date(), "yyyy/MM/dd")); //��ͬ��ʼ��
		int iTermYear=oldObject.getAttribute("TermYear").getInt()*12;
		int iTermMonth=oldObject.getAttribute("TermMonth").getInt();
		int iTermDay=oldObject.getAttribute("TermDay").getInt();
		String sMaturity = StringFunction.getRelativeMonth(DateX.format(new java.util.Date(), "yyyy/MM/dd"),iTermYear+iTermMonth);
		sMaturity = StringFunction.getRelativeDate(sMaturity, iTermDay);  
		boContract.getAttribute("Maturity").setValue(sMaturity); //��ͬ������
		
		//���ñ���������
		//ȡ��ǰҵ�����������
		String sOffSheetFlag=BusinessType.getInstance(boContract.getAttribute("BusinessType").getString()).getOffSheetFlag();
		boContract.getAttribute("OffSheetFlag").setValue(sOffSheetFlag);
		//����BUSINESS_CONTRACT
		mContract.saveObject(boContract);
		contractSerialNo = boContract.getAttribute("SerialNo").getString(); //��ú�ͬ��ˮ��
		
		//�����������й����Ƿ�ǩ����ͬ�ı�ǩ
		BizObjectManager oldManager = f.getManager(oldObject.getBizObjectClass().toString());
		tx.join(oldManager);
		oldObject.getAttribute("Flag5").setValue(CreditConst.BAP_FLAG5_REGISTERED); //���������ֱ�Ӹ��Ƶ���ͬ���˴�valueֵ����
		oldManager.saveObject(oldObject);
		setNewContractSerialNo(contractSerialNo);
		return contractSerialNo;
	}

	/**
	 * ����������Ϣ����Ӧ�ĵ�����Ϣ����ͬ
	 * @param Sqlca
	 * @param oldObjectSerialNo
	 * @throws Exception
	 */
	private void transferGuaranty(Transaction Sqlca) throws Exception{
		/*��ע�⣺�������ĵ�����Ϣ�д��������ĵ�����Ϣ��������߶�ĵ�����Ϣ������ڽ��е�����Ϣ����ʱ��
		        ��������Ϣȫ����*/
		//���ҳ��������������߶����ͬ��Ϣ������������������
		//(��ͬ״̬��ContractStatus��010��δǩ��ͬ��020����ǩ��ͬ��030����ʧЧ)	
		sSql =  " select GC.SerialNo from GUARANTY_CONTRACT GC where exists (select AR.ObjectNo from APPROVE_RELATIVE AR "+
				" where AR.SerialNo =:sObjectNo and AR.ObjectType='GuarantyContract' and AR.ObjectNo = GC.SerialNo) "+
				" and ContractStatus = '020' ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectNo", oldObjectSerialNo));
		while(rs.next()){
			sSql =	" insert into CONTRACT_RELATIVE(SerialNo,ObjectType,ObjectNo,RelationStatus) "+
					" values(:sSerialNo ,'GuarantyContract','"+rs.getString("SerialNo")+"','010') ";
			Sqlca.executeSQL(new SqlObject(sSql).setParameter("sSerialNo", newContractSerialNo));
			
			//���������׶ε�����Ϣ����ˮ�Ų��ҵ���Ӧ�ĵ�������Ϣ
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
		
		//���ҳ�����������δǩ��ͬ�ĵ�����Ϣ���������׶������ĵ�����Ϣ����Ҫȫ��������	
		sSql =  " select GC.* from GUARANTY_CONTRACT GC where exists (select AR.ObjectNo from APPROVE_RELATIVE AR "+
				" where AR.SerialNo =:sObjectNo and AR.ObjectType='GuarantyContract' and AR.ObjectNo = GC.SerialNo) "+
				" and GC.ContractStatus = '010' ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectNo", oldObjectSerialNo));
		//��õ�����Ϣ������
		iColumnCount = rs.getColumnCount();
		while(rs.next()){
			//��õ�����Ϣ���
			sRelativeSerialNo1 = DBKeyHelp.getSerialNo("GUARANTY_CONTRACT","SerialNo",Sqlca);
			//���뵣����Ϣ
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
			
			//���ĵ�����ͬ״̬
			//sSql =	" update GUARANTY_CONTRACT set ContractStatus='020' where SerialNo = '"+sRelativeSerialNo1+"' ";
			//Sqlca.executeSQL(sSql);
			
			//���¿����ĵ�����Ϣ���ͬ��������
			sSql =	" insert into CONTRACT_RELATIVE(SerialNo,ObjectType,ObjectNo,RelationStatus) "+
					" values(:contractSerialNo ,'GuarantyContract',:sRelativeSerialNo1 ,'010')";
			Sqlca.executeSQL(new SqlObject(sSql).setParameter("contractSerialNo", newContractSerialNo).setParameter("sRelativeSerialNo1", sRelativeSerialNo1));
						
			//���������׶ε�����Ϣ����ˮ�Ų��ҵ���Ӧ�ĵ�������Ϣ
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
	 * ����������Ϣ����Ӧ�Ĺ�ͬ��������Ϣ����ͬ
	 * @param Sqlca
	 * @throws Exception
	 */
	private void transferApplicant(Transaction Sqlca) throws Exception{
		//��ѯ��������Ϣ��Ӧ�Ĺ�ͬ��������Ϣ
		sSql =  " select * from BUSINESS_APPLICANT where ObjectType =:sObjectType and ObjectNo =:sObjectNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectType", oldObjectType).setParameter("sObjectNo", oldObjectSerialNo));
		iColumnCount = rs.getColumnCount();
		while(rs.next()){
			//��ù�ͬ������Ϣ��ˮ��
			sRelativeSerialNo1 = DBKeyHelp.getSerialNo("BUSINESS_APPLICANT","SerialNo",Sqlca);
			//���빲ͬ��������Ϣ
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
	 * ����������Ϣ����Ӧ���ĵ���Ϣ����ͬ
	 * @param Sqlca
	 * @throws Exception
	 */
	private void  transferDoc(Transaction Sqlca) throws Exception{
		//ֻ��������Ϣ��Ӧ���ĵ�������Ϣ��������ͬ��
		sSql =  " insert into DOC_RELATIVE(DocNo,ObjectType,ObjectNo) "+
				" select DocNo,'"+newObjectType+"','"+newContractSerialNo+"' from DOC_RELATIVE "+
				" where ObjectType =:sObjectType and ObjectNo =:sObjectNo ";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("sObjectType", oldObjectType).setParameter("sObjectNo", oldObjectSerialNo));
	}
	
	/**
	 * ����������Ϣ����Ӧ����Ŀ��Ϣ����ͬ
	 * @param Sqlca
	 * @throws Exception
	 */
	private void  transferProject(Transaction Sqlca) throws Exception{ 
		//ֻ��������Ϣ��Ӧ����Ŀ������Ϣ��������ͬ��
		sSql =  " insert into PROJECT_RELATIVE(ProjectNo,ObjectType,ObjectNo) "+
				" select ProjectNo,'"+newObjectType+"','"+newContractSerialNo+"' from PROJECT_RELATIVE "+
				" where ObjectType =:sObjectType and ObjectNo =:sObjectNo ";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("sObjectType", oldObjectType).setParameter("sObjectNo", oldObjectSerialNo));

	}
	
	/**
	 * ����������Ϣ����Ӧ��Ʊ����Ϣ����ͬ
	 * @param Sqlca
	 * @throws Exception
	 */
	private void  transferBill(Transaction Sqlca) throws Exception{ 
		//��ѯ��������Ϣ��Ӧ��Ʊ����Ϣ
		sSql =  " select * from BILL_INFO where ObjectType =:sObjectType and ObjectNo =:sObjectNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectType", oldObjectType).setParameter("sObjectNo", oldObjectSerialNo));
		iColumnCount = rs.getColumnCount();
		while(rs.next()){
			//���Ʊ����Ϣ��ˮ��
			sRelativeSerialNo1 = DBKeyHelp.getSerialNo("BILL_INFO","SerialNo",Sqlca);
			//����Ʊ����Ϣ
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
	 * ����������Ϣ����Ӧ������֤��Ϣ����ͬ
	 * @param Sqlca
	 * @throws Exception
	 */
	private void  transferLCInfo(Transaction Sqlca) throws Exception{
		//��ѯ��������Ϣ��Ӧ������֤��Ϣ
		sSql =  " select * from LC_INFO where ObjectType =:sObjectType and ObjectNo =:sObjectNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectType", oldObjectType).setParameter("sObjectNo", oldObjectSerialNo));
		iColumnCount = rs.getColumnCount();
		while(rs.next()){
			//�������֤��Ϣ��ˮ��
			sRelativeSerialNo1 = DBKeyHelp.getSerialNo("LC_INFO","SerialNo",Sqlca);
			//��������֤��Ϣ
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
	 * ����������Ϣ����Ӧ��ó�׺�ͬ��Ϣ����ͬ
	 * @param Sqlca
	 * @throws Exception
	 */
	private void  transferContractInfo(Transaction Sqlca) throws Exception{  
		//��ѯ��������Ϣ��Ӧ��ó�׺�ͬ��Ϣ
		sSql =  " select * from CONTRACT_INFO where ObjectType =:sObjectType and ObjectNo =:sObjectNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectType", oldObjectType).setParameter("sObjectNo", oldObjectSerialNo));
		iColumnCount = rs.getColumnCount();
		while(rs.next()){
			//���ó�׺�ͬ��Ϣ��ˮ��
			sRelativeSerialNo1 = DBKeyHelp.getSerialNo("CONTRACT_INFO","SerialNo",Sqlca);
			//����ó�׺�ͬ��Ϣ
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
	 * ����������Ϣ����Ӧ����ֵ˰��Ʊ��Ϣ����ͬ
	 * @param Sqlca
	 * @throws Exception
	 */
	private void  transferInvoice(Transaction Sqlca) throws Exception{  
		//��ѯ��������Ϣ��Ӧ����ֵ˰��Ʊ��Ϣ
		sSql =  " select * from INVOICE_INFO where ObjectType =:sObjectType and ObjectNo =:sObjectNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectType", oldObjectType).setParameter("sObjectNo", oldObjectSerialNo));
		iColumnCount = rs.getColumnCount();
		while(rs.next()){
			//�����ֵ˰��Ʊ��Ϣ��ˮ��
			sRelativeSerialNo1 = DBKeyHelp.getSerialNo("INVOICE_INFO","SerialNo",Sqlca);
			//������ֵ˰��Ʊ��Ϣ
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
	 * ����������Ϣ����Ӧ�ı�����Ϣ����ͬ
	 * @param Sqlca
	 * @throws Exception
	 */
	
	/**
	 * ����������Ϣ����Ӧ���н���Ϣ����ͬ
	 * @param Sqlca
	 * @throws Exception
	 */
	private void  transferAgency(Transaction Sqlca) throws Exception{
		//����������Ϣ��ѯ�����Ӧ���н���Ϣ
		sSql =  " select * from AGENCY_INFO where SerialNo in (select ObjectNo from APPROVE_RELATIVE "+
				" where SerialNo =:sObjectNo and ObjectType='AGENCY_INFO') ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectNo", oldObjectSerialNo));
		//��õ�����Ϣ������
		iColumnCount = rs.getColumnCount();
		while(rs.next()){
			//����н���Ϣ���
			sRelativeSerialNo1 = DBKeyHelp.getSerialNo("AGENCY_INFO","SerialNo",Sqlca);
			//�����н���Ϣ
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
			
			//���¿������н���Ϣ���ͬ��������
			sSql =	" insert into CONTRACT_RELATIVE(SerialNo,ObjectType,ObjectNo,RelationStatus) "+
					" values(:contractSerialNo ,'AGENCY_INFO',:sRelativeSerialNo1 ,'010')";
			Sqlca.executeSQL(new SqlObject(sSql).setParameter("contractSerialNo", newContractSerialNo).setParameter("sRelativeSerialNo1", sRelativeSerialNo1));	
		}
		rs.getStatement().close();
	}
	
	/**
	 * ����������Ϣ����Ӧ���豸��Ϣ����ͬ
	 * @param Sqlca
	 * @throws Exception
	 */
	
	
	/**
	 * ����������Ϣ����Ӧ��ֱ�ӹ�����Ϣ����ͬ
	 * @param Sqlca
	 * @throws Exception
	 */
	private void  transferRelative(Transaction Sqlca) throws Exception{
		//��������������ֱ�ӹ�������Ϣ����ȥ������Ϣ����������ͬ��
		sSql =	" insert into CONTRACT_RELATIVE(SerialNo,ObjectType,ObjectNo,RelationStatus) "+
				" select '"+newContractSerialNo+"',ObjectType,ObjectNo,'010' from APPROVE_RELATIVE "+
				" where SerialNo =:sObjectNo and ObjectType <> 'GuarantyContract' ";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("sObjectNo", oldObjectSerialNo));
	}
	
	/**
	 * ���������Ϣ����ͬ
	 * @param Sqlca
	 * @throws Exception
	 */
	private void  transferCLInfo(Transaction Sqlca) throws Exception{ 
		//------------------------------�����ۺ�������������Ӧ�ķ�����ϸ��Ϣ����ͬ��--------------------------------------					
		sSql =  " update CL_INFO set BCSerialNo =:contractSerialNo where ApproveSerialNo =:sObjectNo ";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("contractSerialNo", newContractSerialNo).setParameter("sObjectNo", oldObjectSerialNo));
		
		//------------------------------��������������������Ӧ�ķ�����ϸ��Ϣ����ͬ��--------------------------------------					
		sSql =  " update GLINE_INFO set BCSerialNo =:contractSerialNo where ApproveSerialNo =:sObjectNo ";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("contractSerialNo", newContractSerialNo).setParameter("sObjectNo", oldObjectSerialNo));
		
		//------------------------------�������������ϸ��Ϣ����ͬ��--------------------------------------
		sSql =  " select LineNo,IsInUse,Flag,BusinessType from CREDITLINE_RELA where ObjectType =:sObjectType and ObjectNo =:sObjectNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectType", oldObjectType).setParameter("sObjectNo", oldObjectSerialNo));
		String sCRSerialNo,sLineNo,sIsInUse,sFlag,sBusinessType;
		while(rs.next()){
			//��ù�����ȱ���ˮ��
			sCRSerialNo = DBKeyHelp.getSerialNo("CREDITLINE_RELA","SerialNo",Sqlca);
			sLineNo=rs.getString("LineNo");
			sIsInUse=rs.getString("IsInUse");
			sFlag=rs.getString("Flag");
			sBusinessType=rs.getString("BusinessType");
			//������������Ϣ
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
	 * ������ȷ�����Ϣ����ͬ
	 * @param tx
	 * @throws JBOException
	 */
	private void transferCLDivide(JBOTransaction tx) throws JBOException{
		TransferCLDivide copyBusinessInfo=new TransferCLDivide(oldObjectSerialNo,oldObjectType,newContractSerialNo,newObjectType);
		copyBusinessInfo.copyCLDivide(tx);
	}

	/**
	 * �������ռ����Ϣ
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
	 * �������������Ӧ������
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
	 * �������������Ӧ�Ļ��ʽ
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
	 * �������������Ӧ�ķ���
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
	 * �������������Ӧ����Ϣ
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
	 * ����������Ϣ���˺���Ϣ
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
	
	
	//�ж��ֶ������Ƿ�Ϊ��������
	private static boolean isNumeric(int iType) {
		if (iType==java.sql.Types.BIGINT ||iType==java.sql.Types.INTEGER || iType==java.sql.Types.SMALLINT || iType==java.sql.Types.DECIMAL || iType==java.sql.Types.NUMERIC || iType==java.sql.Types.DOUBLE || iType==java.sql.Types.FLOAT ||iType==java.sql.Types.REAL)
			return true;
		return false;
	}

}
