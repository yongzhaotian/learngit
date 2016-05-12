package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;
import com.amarsoft.awe.Configure;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DeleteBusiness extends Bizlet {
	private String sObjectTable = "";
	private String sRelativeTable = ""; 
	public Object  run(Transaction Sqlca) throws Exception {
		//�Զ���ô���Ĳ���ֵ		
		String sObjectType   = (String)this.getAttribute("ObjectType");
		String sObjectNo   = (String)this.getAttribute("ObjectNo");
		String sDeleteType = (String)this.getAttribute("DeleteType");
		
		SqlObject so ;//��������
		
		//����ֵת���ɿ��ַ���		
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sDeleteType == null) sDeleteType = "";

		//��ȡ�����ļ��Ĳ���
		Configure CurConfig = Configure.getInstance();
		String sApproveNeed = (String)CurConfig.getConfigure("ApproveNeed");		
		//ɾ������
		if(sDeleteType.equals("DeleteTask")){
			//��ȡ���������������ʱ�򣬸���������й����Ƿ�ͨ�������ı�ǩ
			if( sObjectType.equals("ApproveApply")){//������״̬������BA�������� by qxu 2013/6/24
				String sSql = "update BUSINESS_APPLY set Flag5 = '010' where SerialNo = (select Relativeserialno from BUSINESS_APPROVE where SerialNo =:SerialNo)";
				so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
				Sqlca.executeSQL(so);
			}
			
			//ɾ����������������������
			if(sObjectType.equals("CreditApply") || sObjectType.equals("ApproveApply")){
				//��ȡ������
				getRelativeTable(sObjectType,Sqlca);
				//ɾ����ͬ������
				deleteTableData("Business_Applicant",sObjectType,sObjectNo,Sqlca);
				//ɾ��Ʊ����Ϣ
				deleteTableData("Bill_Info",sObjectType,sObjectNo,Sqlca);
				//����֤��Ϣ
				deleteTableData("LC_Info",sObjectType,sObjectNo,Sqlca);
				//ɾ��ó�׺�ͬ��Ϣ
				deleteTableData("Contract_Info",sObjectType,sObjectNo,Sqlca);
				//ɾ����ֵ˰��Ʊ��Ϣ
				deleteTableData("Invoice_Info",sObjectType,sObjectNo,Sqlca);
				//ɾ���н���Ϣ
				deleteAgencyInfo(this.sRelativeTable,sObjectNo,Sqlca);
				//ɾ����������Ϣ
				deleteGuarantyInfo(sObjectType,sObjectNo,Sqlca);
				//ɾ����������ҵ�������ϵ
				deleteTableData("Guaranty_Relative",sObjectType,sObjectNo,Sqlca);
				//ɾ��������ͬ��Ϣ
				deleteGuarantyContract(this.sRelativeTable,sObjectNo,Sqlca);
				//ɾ�����ն�������ϸ��Ϣ
				deleteTableData("Evaluate_Data",sObjectType,sObjectNo,Sqlca);
				//ɾ�����ն�������Ϣ
				deleteTableData("Evaluate_Record",sObjectType,sObjectNo,Sqlca);
				//ɾ����ʽ�����鱨����Ϣ
				deleteTableData("FormatDoc_Data",sObjectType,sObjectNo,Sqlca);
				//ɾ���ĵ���Ϣ
				deleteDocInfo(sObjectType,sObjectNo,Sqlca);	
				//ɾ����Ŀ��Ϣ
				deleteTableData("Project_Relative",sObjectType,sObjectNo,Sqlca);
				//ɾ�����ŷ�����ϸ��Ϣ
				deleteCLInfo(sObjectType,sObjectNo,Sqlca);	
				deleteNewCLInfo(sObjectType,sObjectNo,Sqlca);
				deleteGLineInfo(sObjectType,sObjectNo,Sqlca);//ɾ�����ſͻ���Ϣ��
				//ɾ��������Ϣ
				deleteRelativeInfo(this.sRelativeTable,sObjectNo,Sqlca);
				//ɾ�����������Ϣ
				deleteObjectInfo(this.sObjectTable,sObjectNo,Sqlca);
				//ɾ�����̶�����Ϣ				
				deleteTableData("Flow_Object",sObjectType,sObjectNo,Sqlca);			
				//ɾ������������Ϣ
				deleteTableData("Flow_Task",sObjectType,sObjectNo,Sqlca);				
			}

			//ɾ���Ŵ�����
			if(sObjectType.equals("PutOutApply")){
				//��ȡ������
				getRelativeTable(sObjectType,Sqlca);
				//ɾ�����������Ϣ
				deleteObjectInfo(this.sObjectTable,sObjectNo,Sqlca);
				//ɾ�����̶�����Ϣ				
				deleteTableData("Flow_Object",sObjectType,sObjectNo,Sqlca);			
				//ɾ������������Ϣ
				deleteTableData("Flow_Task",sObjectType,sObjectNo,Sqlca);
			}
			
			if(sObjectType.equals("TransactionApply"))
			{
				//��ȡ������
				getRelativeTable(sObjectType,Sqlca);
				
				AbstractBusinessObjectManager bom = new DefaultBusinessObjectManager(Sqlca);
				BusinessObject bo = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.transaction,sObjectNo);
				BusinessObject documentBo = bom.loadObjectWithKey(bo.getString("DocumentType"),bo.getString("DocumentSerialNo"));
				bom.deleteBusinessObject(documentBo);
				bom.deleteBusinessObject(bo);
				bom.updateDB();
				//ɾ�����̶�����Ϣ				
				deleteTableData("Flow_Object",sObjectType,sObjectNo,Sqlca);			
				//ɾ������������Ϣ
				deleteTableData("Flow_Task",sObjectType,sObjectNo,Sqlca);
				
			}

		
		}
		
		if(sDeleteType.equals("UpdateBusiness")){
			if(sApproveNeed.equals("true")){
				//��ȡ�����պ�ͬ��ʱ�������Ҫ������������Ǽ�ģ�飬�����������й����Ƿ�ǩ����ͬ�ı�ǩ
				String sSql = "update BUSINESS_APPROVE set Flag5 = '010' where SerialNo =:SerialNo ";
				so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
				Sqlca.executeSQL(so);
			}else{
				//��ȡ�����պ�ͬ��ʱ���������Ҫ������������Ǽ�ģ�飬����������й����Ƿ�ǩ����ͬ�ı�ǩ
				String sSql = "update BUSINESS_APPLY set Flag5 = '010' where SerialNo =:SerialNo";
				so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
				Sqlca.executeSQL(so);
			}
		}

		if(sDeleteType.equals("DeleteBusiness")){
			//ɾ����ͬ��Ϣ���߲��Ǻ�ͬ��Ϣ
			if(sObjectType.equals("BusinessContract")  || sObjectType.equals("ReinforceContract")){
				//��ȡ������
				getRelativeTable(sObjectType,Sqlca);
				//ɾ����ͬ������
				deleteTableData("Business_Applicant",sObjectType,sObjectNo,Sqlca);
				//ɾ��Ʊ����Ϣ
				deleteTableData("Bill_Info",sObjectType,sObjectNo,Sqlca);
				//����֤��Ϣ
				deleteTableData("LC_Info",sObjectType,sObjectNo,Sqlca);
				//ɾ��ó�׺�ͬ��Ϣ
				deleteTableData("Contract_Info",sObjectType,sObjectNo,Sqlca);
				//ɾ����ֵ˰��Ʊ��Ϣ
				deleteTableData("Invoice_Info",sObjectType,sObjectNo,Sqlca);
				//ɾ���н���Ϣ
				deleteAgencyInfo(this.sRelativeTable,sObjectNo,Sqlca);
				//ɾ����������Ϣ
				deleteGuarantyInfo(sObjectType,sObjectNo,Sqlca);
				//ɾ����������ҵ�������ϵ
				deleteTableData("Guaranty_Relative",sObjectType,sObjectNo,Sqlca);
				//ɾ��������ͬ��Ϣ
				deleteGuarantyContract(this.sRelativeTable,sObjectNo,Sqlca);
				//ɾ�����ն�������ϸ��Ϣ
				deleteTableData("Evaluate_Data",sObjectType,sObjectNo,Sqlca);
				//ɾ�����ն�������Ϣ
				deleteTableData("Evaluate_Record",sObjectType,sObjectNo,Sqlca);
				//ɾ����ʽ�����鱨����Ϣ
				deleteTableData("FormatDoc_Data",sObjectType,sObjectNo,Sqlca);
				//ɾ���ĵ���Ϣ
				deleteDocInfo(sObjectType,sObjectNo,Sqlca);				
				//ɾ����Ŀ��Ϣ
				deleteTableData("Project_Relative",sObjectType,sObjectNo,Sqlca);
				//ɾ�����ŷ�����ϸ��Ϣ
				deleteCLInfo(sObjectType,sObjectNo,Sqlca);	
				deleteNewCLInfo(sObjectType,sObjectNo,Sqlca);
				deleteGLineInfo(sObjectType,sObjectNo,Sqlca);//ɾ�����ſͻ���Ϣ��
				//ɾ��������Ϣ
				deleteRelativeInfo(this.sRelativeTable,sObjectNo,Sqlca);
				//ɾ�����������Ϣ
				deleteObjectInfo(this.sObjectTable,sObjectNo,Sqlca);
			}

			//ɾ�����鷽����Ϣ
			if(sObjectType.equals("NPAReformApply")){
				//��ȡ������
				getRelativeTable(sObjectType,Sqlca);
				//ɾ��������Ϣ
				deleteRelativeInfo(this.sRelativeTable,sObjectNo,Sqlca);
				//ɾ�����������Ϣ
				deleteObjectInfo(this.sObjectTable,sObjectNo,Sqlca);
			}
			//add by fhuang 2006.11.29 ɾ����������Ĺ�����Ϣ
			if(sObjectType.equals("LawcaseInfo")){
				//ɾ��������ͬ�Ĺ�����ϵ
				deleteRelativeInfo("LAWCASE_RELATIVE",sObjectNo,Sqlca);
				//ɾ�����������ˡ�����������Ա����������Ϣ
				deleteTableData("Lawcase_Persons",sObjectType,sObjectNo,Sqlca);
				//ɾ����������ĵ�
				deleteDocInfo(sObjectType,sObjectNo,Sqlca);
				//ɾ��̨����Ϣ
				deleteTableData("Lawcase_Book",sObjectType,sObjectNo,Sqlca);
				//ɾ��ͥ���¼
				deleteTableData("Lawcase_Cognizance",sObjectType,sObjectNo,Sqlca);
				//ɾ������̨��
				deleteTableData("Cost_Info",sObjectType,sObjectNo,Sqlca);
				//ɾ������ʲ�̨��
				deleteTableData("Asset_Info",sObjectType,sObjectNo,Sqlca);

			}
			//add by fhuang 2006.11.30 ɾ����ծ�ʲ��Ĺ�����Ϣ
			if(sObjectType.equals("AssetInfo")){
				//ɾ��������ͬ�Ĺ�����ϵ				
				deleteAssetContract(sObjectNo,Sqlca);
				//ɾ����ر�����Ϣ
				deleteTableData("Insurance_Info",sObjectType,sObjectNo,Sqlca);
				//ɾ����ֵ������¼
				deleteTableData("Evaluate_Info",sObjectType,sObjectNo,Sqlca);
				//ɾ����ֵ�䶯��¼
				deleteTableData("OtherChange_Info",sObjectType,sObjectNo,Sqlca);
				//ɾ����������ĵ�
				deleteDocInfo(sObjectType,sObjectNo,Sqlca);				
			}
		}
		//add by syang 2009/10/10  ɾ����ֵ׼�������룬��ˮ����Ϣ
		if(sDeleteType.equals("DeleteReserve")){
			deleteTableData("FLOW_TASK",sObjectType,sObjectNo,Sqlca);	//Delete FLOW_TASK
			deleteTableData("FLOW_OBJECT",sObjectType,sObjectNo,Sqlca);	//Delete FLOW_OBJECT
			deleteObjectInfo("RESERVE_APPLY",sObjectNo,Sqlca);			//DELETE RESERVE_APPLY
		}
		//add by cbsu 2009/10/12  ɾ���弶��������룬��ˮ����Ϣ
		if(sDeleteType.equals("DeleteClassify")){
			deleteTableData("FLOW_OBJECT",sObjectType,sObjectNo,Sqlca);		//Delete FLOW_OBJECT
			deleteTableData("FLOW_TASK",sObjectType,sObjectNo,Sqlca);		//Delete FLOW_TASK
			deleteTableData("FLOW_OPINION",sObjectType,sObjectNo,Sqlca);    //Delete FLOW_OPINION
			deleteObjectInfo("CLASSIFY_RECORD",sObjectNo,Sqlca);			//DELETE CLASSIFY_RECORD
			deleteObjectInfo("CLASSIFY_DATA",sObjectNo,Sqlca);				//Delete CLASSIFY_DATA
		}
		//add by ccxie 2010/03/20 ɾ��������ͬ��������룬��ˮ����Ϣ
		if(sDeleteType.equals("DeleteGuarantyTransform")){
			deleteTableData("FLOW_TASK",sObjectType,sObjectNo,Sqlca);		//Delete FLOW_TASK
			deleteTableData("FLOW_OPINION",sObjectType,sObjectNo,Sqlca);    //Delete FLOW_OPINION
			deleteObjectInfo("GUARANTY_TRANSFORM",sObjectNo,Sqlca);			//DELETE GUARANTY_TRANSFORM
			deleteObjectInfo("TRANSFORM_RELATIVE",sObjectNo,Sqlca);			//Delete TRANSFORM_RELATIVE
		}
		//ȡ���Ŵ�����   wqchen 2010.03.18�޸�
		if(sDeleteType.equals("DeletePutoutTask")){
			//String sSql = "delete from BUSINESS_PUTOUT WHERE SerialNo = '"+sObjectNo+"'";
			//ɾ�����˼�¼
			deleteObjectInfo("BUSINESS_PUTOUT", sObjectNo, Sqlca);
			//��������ɾ���Ŵ�����
			deleteTableData("FLOW_OBJECT", sObjectType, sObjectNo, Sqlca);
			deleteTableData("FLOW_TASK", sObjectType, sObjectNo, Sqlca);
			deleteTableData("FLOW_OPINION", sObjectType, sObjectNo, Sqlca);
		}
		
		//ȡ��֧������  qfang 2011-6-8
		if(sDeleteType.equals("DeletePaymentApply")){
			//ɾ��֧�������¼
			deleteObjectInfo("PAYMENT_INFO", sObjectNo, Sqlca);
			//��������ɾ��֧������
			deleteTableData("FLOW_OBJECT", sObjectType, sObjectNo, Sqlca);
			deleteTableData("FLOW_TASK", sObjectType, sObjectNo, Sqlca);
			deleteTableData("FLOW_OPINION", sObjectType, sObjectNo, Sqlca);	
		}

		return "1";
	}

	//��ȡ��������
	private void getRelativeTable(String sObjectType,Transaction Sqlca) throws Exception {
		String sSql = "";	 
		ASResultSet rs = null;
		//����sObjectType�Ĳ�ͬ���õ���ͬ�Ĺ�������
		sSql = "select ObjectTable,RelativeTable from OBJECTTYPE_CATALOG where ObjectType=:ObjectType ";	 
		SqlObject so = new SqlObject(sSql).setParameter("ObjectType", sObjectType);
		rs = Sqlca.getASResultSet(so);
		if(rs.next()){
			this.sObjectTable = rs.getString("ObjectTable");
			this.sRelativeTable = rs.getString("RelativeTable");
		}
		rs.getStatement().close();	 	 
	}

//	ɾ���н���Ϣ
	private void deleteAgencyInfo(String sRelativeTable,String sObjectNo,Transaction Sqlca) throws Exception {
		String sSql = " delete from AGENCY_INFO where SerialNo in (select ObjectNo from "+
		" "+sRelativeTable+" where SerialNo =:SerialNo and ObjectType = 'AgencyInfo') ";
		SqlObject so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);	
	}

//	ɾ����������Ϣ(δ���)
	private void deleteGuarantyInfo(String sObjectType,String sObjectNo,Transaction Sqlca) throws Exception {
		String sSql = " delete from GUARANTY_INFO where GuarantyID in (select GuarantyID "+
		" from GUARANTY_RELATIVE where ObjectType =:ObjectType  "+
		" and ObjectNo =:ObjectNo  and Channel = 'New') "+
		" and GuarantyStatus = '01' ";	 
		SqlObject so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		Sqlca.executeSQL(so);
	}
	
//	ɾ��������Ϣ
	private void deleteGuarantyContract(String sRelativeTable,String sObjectNo,Transaction Sqlca) throws Exception {
		String sSql = "";
		sSql = " delete from GUARANTY_CONTRACT "+
		" where SerialNo in (select ObjectNo "+
		" from "+sRelativeTable+" "+
		" where ObjectType = 'GuarantyContract' "+
		" and SerialNo =:SerialNo) "+
		" and (ContractStatus = '010' or ContractType <> '020')";
		SqlObject so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);	 
	}

//	�����ĵ���Ϣ
	private void deleteDocInfo(String sObjectType,String sObjectNo,Transaction Sqlca) throws Exception {
		String sSql = "";
		//ɾ���ĵ��ĸ���
		sSql = "delete from  Doc_Relative where ObjectType ='BusinessContract' and ObjectNo=:ObjectNo ";
		SqlObject so = new SqlObject(sSql).setParameter("ObjectNo", sObjectNo);
		Sqlca.executeSQL(so);
	}
	
	/**�ɶ����ϵ��ر���ʱ���� jschen@20121224*/
	//	ɾ�����ŷ�����ϸ��Ϣ
	private void deleteCLInfo(String sObjectType,String sObjectNo,Transaction Sqlca) throws Exception {
		String sSql = "";
		SqlObject so = null;//��������
		//���ݶ������ͽ���ɾ����������
		if(sObjectType.equals("CreditApply")){
			sSql = " select LineID from CL_INFO where ApplySerialNo =:ApplySerialNo ";
			so = new SqlObject(sSql).setParameter("ApplySerialNo", sObjectNo);
			String sLineID = Sqlca.getString(so);
			sSql = " delete from CL_LIMITATION_SET where LineID =:LineID ";
			so = new SqlObject(sSql).setParameter("LineID", sLineID);
			Sqlca.executeSQL(so);
			sSql = " delete from CL_LIMITATION where LineID =:LineID ";
			so = new SqlObject(sSql).setParameter("LineID", sLineID);
			Sqlca.executeSQL(so);
			sSql = " delete from CL_INFO where LineID =:LineID ";
			so = new SqlObject(sSql).setParameter("LineID", sLineID);
			Sqlca.executeSQL(so);
		}else if(sObjectType.equals("ReinforceContract")){
			sSql = " select LineID from CL_INFO where BCSerialNo =:BCSerialNo ";
			so = new SqlObject(sSql).setParameter("BCSerialNo", sObjectNo);
			String sLineID = Sqlca.getString(so);
			sSql = " delete from CL_LIMITATION_SET where LineID =:LineID ";
			so = new SqlObject(sSql).setParameter("LineID", sLineID);
			Sqlca.executeSQL(so);
			sSql = " delete from CL_LIMITATION where LineID =:LineID  ";
			so = new SqlObject(sSql).setParameter("LineID", sLineID);
			Sqlca.executeSQL(so);
			sSql = " delete from CL_INFO where LineID =:LineID ";
			so = new SqlObject(sSql).setParameter("LineID", sLineID);
			Sqlca.executeSQL(so);	
		}else {
			//���������������¼������ŷ�����ϸû��ɾ��
			if(sObjectType.equals("ApproveApply")){
				sSql = " update CL_INFO set ApproveSerialNo = null "+
				" where ApproveSerialNo =:ApproveSerialNo ";
				so = new SqlObject(sSql).setParameter("ApproveSerialNo", sObjectNo);
				Sqlca.executeSQL(so);				
			}
			//�ں�ͬ��¼������ŷ�����ϸû��ɾ��
			if(sObjectType.equals("BusinessContract")){
				sSql = " update CL_INFO set BCSerialNo = null,LineContractNo = null "+
				" where BCSerialNo =:BCSerialNo ";
				so = new SqlObject(sSql).setParameter("BCSerialNo", sObjectNo);
				//ִ��ɾ�����
				Sqlca.executeSQL(so);
			}
		}
	}
	
	/**�¶����ϵ��ر� jschen@20121224
	 * @throws Exception */
	private void deleteNewCLInfo(String sObjectType,String sObjectNo,Transaction Sqlca) throws Exception{
		String sSql = "";
		SqlObject so = null;//��������
		//ɾ����ȷ����
		sSql = "delete from CL_DIVIDE where ObjectType =:ObjectType and ObjectNo =:ObjectNo";
		so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		Sqlca.executeSQL(so);
		//ɾ�����ռ�ñ�
		sSql = "delete from CL_OCCUPY where ObjectType =:ObjectType and ObjectNo =:ObjectNo";
		so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		Sqlca.executeSQL(so);
	}
	
//	ɾ�����ſͻ���Ϣ
	private void deleteGLineInfo(String sObjectType,String sObjectNo,Transaction Sqlca) throws Exception {
		String sSql = "";
		SqlObject so ;//��������
		//���ݶ������ͽ���ɾ����������
		if(sObjectType.equals("CreditApply")){
			sSql = " select LineID from GLINE_INFO where ApplySerialNo =:ApplySerialNo ";
			so = new SqlObject(sSql).setParameter("ApplySerialNo", sObjectNo);
			String sLineID = Sqlca.getString(so);
			
			sSql = " delete from GLINE_INFO where LineID =:LineID ";
			so = new SqlObject(sSql).setParameter("LineID", sLineID);
			Sqlca.executeSQL(so);
		}else if(sObjectType.equals("ReinforceContract")){
			sSql = " select LineID from GLINE_INFO where BCSerialNo =:BCSerialNo ";
			so = new SqlObject(sSql).setParameter("BCSerialNo", sObjectNo);
			String sLineID = Sqlca.getString(so);
			sSql = " delete from GLINE_INFO where LineID =:LineID ";
			so = new SqlObject(sSql).setParameter("LineID", sLineID);
			Sqlca.executeSQL(so);
		}else{
			//���������������¼������ŷ�����ϸû��ɾ��
			if(sObjectType.equals("ApproveApply")){
				sSql = " update GLINE_INFO set ApproveSerialNo = null "+
				" where ApproveSerialNo =:ApproveSerialNo ";
			    so = new SqlObject(sSql).setParameter("ApproveSerialNo", sObjectNo);
			    Sqlca.executeSQL(so);
			}
			//�ں�ͬ��¼������ŷ�����ϸû��ɾ��
			if(sObjectType.equals("BusinessContract")){
				sSql = " update GLINE_INFO set BCSerialNo = null,LineContractNo = null "+
				" where BCSerialNo =:BCSerialNo ";
			    so = new SqlObject(sSql).setParameter("BCSerialNo", sObjectNo);
			    Sqlca.executeSQL(so);
			}
		}
	}

//	ɾ��������Ϣ
	private void deleteRelativeInfo(String sRelativeTable,String sObjectNo,Transaction Sqlca) throws Exception {
		String sSql = " delete from "+sRelativeTable+"  where SerialNo =:SerialNo ";
		SqlObject so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);
	}

//	ɾ�����������Ϣ
	private void deleteObjectInfo(String sObjectTable,String sObjectNo,Transaction Sqlca) throws Exception {
		String sSql = " delete from "+sObjectTable+" where SerialNo =:SerialNo ";
		SqlObject so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);	
	}
//	ɾ��������ͬ�Ĺ�����ϵ	
	private void deleteAssetContract(String sObjectNo,Transaction Sqlca) throws Exception {
		String sSql = " delete from Asset_Contract where SerialNo =:SerialNo ";
		SqlObject so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);	 
	} 
	//ɾ����ObjectType,ObjectNo��Ϊ����ı�
	private void deleteTableData(String sTableName,String sObjectType,String sObjectNo,Transaction Sqlca)
	throws Exception {
		String sSql = " delete from "+sTableName+" where ObjectType =:ObjectType and ObjectNo =:ObjectNo ";
		SqlObject so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		Sqlca.executeSQL(so); 
	}
	
}
