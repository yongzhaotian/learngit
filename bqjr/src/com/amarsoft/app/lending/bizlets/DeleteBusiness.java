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
		//自动获得传入的参数值		
		String sObjectType   = (String)this.getAttribute("ObjectType");
		String sObjectNo   = (String)this.getAttribute("ObjectNo");
		String sDeleteType = (String)this.getAttribute("DeleteType");
		
		SqlObject so ;//声明对象
		
		//将空值转化成空字符串		
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sDeleteType == null) sDeleteType = "";

		//获取配置文件的参数
		Configure CurConfig = Configure.getInstance();
		String sApproveNeed = (String)CurConfig.getConfigure("ApproveNeed");		
		//删除任务
		if(sDeleteType.equals("DeleteTask")){
			//在取消最终审批意见的时候，更改申请表中关于是否通过审批的标签
			if( sObjectType.equals("ApproveApply")){//在其他状态，不对BA表做更改 by qxu 2013/6/24
				String sSql = "update BUSINESS_APPLY set Flag5 = '010' where SerialNo = (select Relativeserialno from BUSINESS_APPROVE where SerialNo =:SerialNo)";
				so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
				Sqlca.executeSQL(so);
			}
			
			//删除申请和最终审批意见任务
			if(sObjectType.equals("CreditApply") || sObjectType.equals("ApproveApply")){
				//获取关联表
				getRelativeTable(sObjectType,Sqlca);
				//删除共同申请人
				deleteTableData("Business_Applicant",sObjectType,sObjectNo,Sqlca);
				//删除票据信息
				deleteTableData("Bill_Info",sObjectType,sObjectNo,Sqlca);
				//信用证信息
				deleteTableData("LC_Info",sObjectType,sObjectNo,Sqlca);
				//删除贸易合同信息
				deleteTableData("Contract_Info",sObjectType,sObjectNo,Sqlca);
				//删除增值税发票信息
				deleteTableData("Invoice_Info",sObjectType,sObjectNo,Sqlca);
				//删除中介信息
				deleteAgencyInfo(this.sRelativeTable,sObjectNo,Sqlca);
				//删除担保物信息
				deleteGuarantyInfo(sObjectType,sObjectNo,Sqlca);
				//删除担保物与业务关联关系
				deleteTableData("Guaranty_Relative",sObjectType,sObjectNo,Sqlca);
				//删除担保合同信息
				deleteGuarantyContract(this.sRelativeTable,sObjectNo,Sqlca);
				//删除风险度评估明细信息
				deleteTableData("Evaluate_Data",sObjectType,sObjectNo,Sqlca);
				//删除风险度评估信息
				deleteTableData("Evaluate_Record",sObjectType,sObjectNo,Sqlca);
				//删除格式化调查报告信息
				deleteTableData("FormatDoc_Data",sObjectType,sObjectNo,Sqlca);
				//删除文档信息
				deleteDocInfo(sObjectType,sObjectNo,Sqlca);	
				//删除项目信息
				deleteTableData("Project_Relative",sObjectType,sObjectNo,Sqlca);
				//删除授信方案明细信息
				deleteCLInfo(sObjectType,sObjectNo,Sqlca);	
				deleteNewCLInfo(sObjectType,sObjectNo,Sqlca);
				deleteGLineInfo(sObjectType,sObjectNo,Sqlca);//删除集团客户信息表
				//删除关联信息
				deleteRelativeInfo(this.sRelativeTable,sObjectNo,Sqlca);
				//删除主体对象信息
				deleteObjectInfo(this.sObjectTable,sObjectNo,Sqlca);
				//删除流程对象信息				
				deleteTableData("Flow_Object",sObjectType,sObjectNo,Sqlca);			
				//删除流程任务信息
				deleteTableData("Flow_Task",sObjectType,sObjectNo,Sqlca);				
			}

			//删除放贷任务
			if(sObjectType.equals("PutOutApply")){
				//获取关联表
				getRelativeTable(sObjectType,Sqlca);
				//删除主体对象信息
				deleteObjectInfo(this.sObjectTable,sObjectNo,Sqlca);
				//删除流程对象信息				
				deleteTableData("Flow_Object",sObjectType,sObjectNo,Sqlca);			
				//删除流程任务信息
				deleteTableData("Flow_Task",sObjectType,sObjectNo,Sqlca);
			}
			
			if(sObjectType.equals("TransactionApply"))
			{
				//获取关联表
				getRelativeTable(sObjectType,Sqlca);
				
				AbstractBusinessObjectManager bom = new DefaultBusinessObjectManager(Sqlca);
				BusinessObject bo = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.transaction,sObjectNo);
				BusinessObject documentBo = bom.loadObjectWithKey(bo.getString("DocumentType"),bo.getString("DocumentSerialNo"));
				bom.deleteBusinessObject(documentBo);
				bom.deleteBusinessObject(bo);
				bom.updateDB();
				//删除流程对象信息				
				deleteTableData("Flow_Object",sObjectType,sObjectNo,Sqlca);			
				//删除流程任务信息
				deleteTableData("Flow_Task",sObjectType,sObjectNo,Sqlca);
				
			}

		
		}
		
		if(sDeleteType.equals("UpdateBusiness")){
			if(sApproveNeed.equals("true")){
				//在取消最终合同的时候，如果需要最终批复意见登记模块，更改批复表中关于是否签订合同的标签
				String sSql = "update BUSINESS_APPROVE set Flag5 = '010' where SerialNo =:SerialNo ";
				so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
				Sqlca.executeSQL(so);
			}else{
				//在取消最终合同的时候，如果不需要最终批复意见登记模块，更改申请表中关于是否签订合同的标签
				String sSql = "update BUSINESS_APPLY set Flag5 = '010' where SerialNo =:SerialNo";
				so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
				Sqlca.executeSQL(so);
			}
		}

		if(sDeleteType.equals("DeleteBusiness")){
			//删除合同信息或者补登合同信息
			if(sObjectType.equals("BusinessContract")  || sObjectType.equals("ReinforceContract")){
				//获取关联表
				getRelativeTable(sObjectType,Sqlca);
				//删除共同申请人
				deleteTableData("Business_Applicant",sObjectType,sObjectNo,Sqlca);
				//删除票据信息
				deleteTableData("Bill_Info",sObjectType,sObjectNo,Sqlca);
				//信用证信息
				deleteTableData("LC_Info",sObjectType,sObjectNo,Sqlca);
				//删除贸易合同信息
				deleteTableData("Contract_Info",sObjectType,sObjectNo,Sqlca);
				//删除增值税发票信息
				deleteTableData("Invoice_Info",sObjectType,sObjectNo,Sqlca);
				//删除中介信息
				deleteAgencyInfo(this.sRelativeTable,sObjectNo,Sqlca);
				//删除担保物信息
				deleteGuarantyInfo(sObjectType,sObjectNo,Sqlca);
				//删除担保物与业务关联关系
				deleteTableData("Guaranty_Relative",sObjectType,sObjectNo,Sqlca);
				//删除担保合同信息
				deleteGuarantyContract(this.sRelativeTable,sObjectNo,Sqlca);
				//删除风险度评估明细信息
				deleteTableData("Evaluate_Data",sObjectType,sObjectNo,Sqlca);
				//删除风险度评估信息
				deleteTableData("Evaluate_Record",sObjectType,sObjectNo,Sqlca);
				//删除格式化调查报告信息
				deleteTableData("FormatDoc_Data",sObjectType,sObjectNo,Sqlca);
				//删除文档信息
				deleteDocInfo(sObjectType,sObjectNo,Sqlca);				
				//删除项目信息
				deleteTableData("Project_Relative",sObjectType,sObjectNo,Sqlca);
				//删除授信方案明细信息
				deleteCLInfo(sObjectType,sObjectNo,Sqlca);	
				deleteNewCLInfo(sObjectType,sObjectNo,Sqlca);
				deleteGLineInfo(sObjectType,sObjectNo,Sqlca);//删除集团客户信息表
				//删除关联信息
				deleteRelativeInfo(this.sRelativeTable,sObjectNo,Sqlca);
				//删除主体对象信息
				deleteObjectInfo(this.sObjectTable,sObjectNo,Sqlca);
			}

			//删除重组方案信息
			if(sObjectType.equals("NPAReformApply")){
				//获取关联表
				getRelativeTable(sObjectType,Sqlca);
				//删除关联信息
				deleteRelativeInfo(this.sRelativeTable,sObjectNo,Sqlca);
				//删除主体对象信息
				deleteObjectInfo(this.sObjectTable,sObjectNo,Sqlca);
			}
			//add by fhuang 2006.11.29 删除法律事务的关联信息
			if(sObjectType.equals("LawcaseInfo")){
				//删除关联合同的关联关系
				deleteRelativeInfo("LAWCASE_RELATIVE",sObjectNo,Sqlca);
				//删除案件当事人、案件受理人员、代理人信息
				deleteTableData("Lawcase_Persons",sObjectType,sObjectNo,Sqlca);
				//删除案件相关文档
				deleteDocInfo(sObjectType,sObjectNo,Sqlca);
				//删除台帐信息
				deleteTableData("Lawcase_Book",sObjectType,sObjectNo,Sqlca);
				//删除庭审记录
				deleteTableData("Lawcase_Cognizance",sObjectType,sObjectNo,Sqlca);
				//删除费用台帐
				deleteTableData("Cost_Info",sObjectType,sObjectNo,Sqlca);
				//删除查封资产台帐
				deleteTableData("Asset_Info",sObjectType,sObjectNo,Sqlca);

			}
			//add by fhuang 2006.11.30 删除抵债资产的关联信息
			if(sObjectType.equals("AssetInfo")){
				//删除关联合同的关联关系				
				deleteAssetContract(sObjectNo,Sqlca);
				//删除相关保险信息
				deleteTableData("Insurance_Info",sObjectType,sObjectNo,Sqlca);
				//删除价值评估记录
				deleteTableData("Evaluate_Info",sObjectType,sObjectNo,Sqlca);
				//删除价值变动记录
				deleteTableData("OtherChange_Info",sObjectType,sObjectNo,Sqlca);
				//删除案件相关文档
				deleteDocInfo(sObjectType,sObjectNo,Sqlca);				
			}
		}
		//add by syang 2009/10/10  删除减值准备的申请，流水等信息
		if(sDeleteType.equals("DeleteReserve")){
			deleteTableData("FLOW_TASK",sObjectType,sObjectNo,Sqlca);	//Delete FLOW_TASK
			deleteTableData("FLOW_OBJECT",sObjectType,sObjectNo,Sqlca);	//Delete FLOW_OBJECT
			deleteObjectInfo("RESERVE_APPLY",sObjectNo,Sqlca);			//DELETE RESERVE_APPLY
		}
		//add by cbsu 2009/10/12  删除五级分类的申请，流水等信息
		if(sDeleteType.equals("DeleteClassify")){
			deleteTableData("FLOW_OBJECT",sObjectType,sObjectNo,Sqlca);		//Delete FLOW_OBJECT
			deleteTableData("FLOW_TASK",sObjectType,sObjectNo,Sqlca);		//Delete FLOW_TASK
			deleteTableData("FLOW_OPINION",sObjectType,sObjectNo,Sqlca);    //Delete FLOW_OPINION
			deleteObjectInfo("CLASSIFY_RECORD",sObjectNo,Sqlca);			//DELETE CLASSIFY_RECORD
			deleteObjectInfo("CLASSIFY_DATA",sObjectNo,Sqlca);				//Delete CLASSIFY_DATA
		}
		//add by ccxie 2010/03/20 删除担保合同变更的申请，流水等信息
		if(sDeleteType.equals("DeleteGuarantyTransform")){
			deleteTableData("FLOW_TASK",sObjectType,sObjectNo,Sqlca);		//Delete FLOW_TASK
			deleteTableData("FLOW_OPINION",sObjectType,sObjectNo,Sqlca);    //Delete FLOW_OPINION
			deleteObjectInfo("GUARANTY_TRANSFORM",sObjectNo,Sqlca);			//DELETE GUARANTY_TRANSFORM
			deleteObjectInfo("TRANSFORM_RELATIVE",sObjectNo,Sqlca);			//Delete TRANSFORM_RELATIVE
		}
		//取消放贷申请   wqchen 2010.03.18修改
		if(sDeleteType.equals("DeletePutoutTask")){
			//String sSql = "delete from BUSINESS_PUTOUT WHERE SerialNo = '"+sObjectNo+"'";
			//删除出账记录
			deleteObjectInfo("BUSINESS_PUTOUT", sObjectNo, Sqlca);
			//在流程中删除放贷申请
			deleteTableData("FLOW_OBJECT", sObjectType, sObjectNo, Sqlca);
			deleteTableData("FLOW_TASK", sObjectType, sObjectNo, Sqlca);
			deleteTableData("FLOW_OPINION", sObjectType, sObjectNo, Sqlca);
		}
		
		//取消支付申请  qfang 2011-6-8
		if(sDeleteType.equals("DeletePaymentApply")){
			//删除支付申请记录
			deleteObjectInfo("PAYMENT_INFO", sObjectNo, Sqlca);
			//在流程中删除支付申请
			deleteTableData("FLOW_OBJECT", sObjectType, sObjectNo, Sqlca);
			deleteTableData("FLOW_TASK", sObjectType, sObjectNo, Sqlca);
			deleteTableData("FLOW_OPINION", sObjectType, sObjectNo, Sqlca);	
		}

		return "1";
	}

	//获取关联表名
	private void getRelativeTable(String sObjectType,Transaction Sqlca) throws Exception {
		String sSql = "";	 
		ASResultSet rs = null;
		//根据sObjectType的不同，得到不同的关联表名
		sSql = "select ObjectTable,RelativeTable from OBJECTTYPE_CATALOG where ObjectType=:ObjectType ";	 
		SqlObject so = new SqlObject(sSql).setParameter("ObjectType", sObjectType);
		rs = Sqlca.getASResultSet(so);
		if(rs.next()){
			this.sObjectTable = rs.getString("ObjectTable");
			this.sRelativeTable = rs.getString("RelativeTable");
		}
		rs.getStatement().close();	 	 
	}

//	删除中介信息
	private void deleteAgencyInfo(String sRelativeTable,String sObjectNo,Transaction Sqlca) throws Exception {
		String sSql = " delete from AGENCY_INFO where SerialNo in (select ObjectNo from "+
		" "+sRelativeTable+" where SerialNo =:SerialNo and ObjectType = 'AgencyInfo') ";
		SqlObject so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);	
	}

//	删除担保物信息(未入库)
	private void deleteGuarantyInfo(String sObjectType,String sObjectNo,Transaction Sqlca) throws Exception {
		String sSql = " delete from GUARANTY_INFO where GuarantyID in (select GuarantyID "+
		" from GUARANTY_RELATIVE where ObjectType =:ObjectType  "+
		" and ObjectNo =:ObjectNo  and Channel = 'New') "+
		" and GuarantyStatus = '01' ";	 
		SqlObject so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		Sqlca.executeSQL(so);
	}
	
//	删除担保信息
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

//	更新文档信息
	private void deleteDocInfo(String sObjectType,String sObjectNo,Transaction Sqlca) throws Exception {
		String sSql = "";
		//删除文档的附件
		sSql = "delete from  Doc_Relative where ObjectType ='BusinessContract' and ObjectNo=:ObjectNo ";
		SqlObject so = new SqlObject(sSql).setParameter("ObjectNo", sObjectNo);
		Sqlca.executeSQL(so);
	}
	
	/**旧额度体系相关表暂时保留 jschen@20121224*/
	//	删除授信方案明细信息
	private void deleteCLInfo(String sObjectType,String sObjectNo,Transaction Sqlca) throws Exception {
		String sSql = "";
		SqlObject so = null;//声明对象
		//根据对象类型进行删除操作处理
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
			//在最终审批意见中录入的授信方案明细没有删除
			if(sObjectType.equals("ApproveApply")){
				sSql = " update CL_INFO set ApproveSerialNo = null "+
				" where ApproveSerialNo =:ApproveSerialNo ";
				so = new SqlObject(sSql).setParameter("ApproveSerialNo", sObjectNo);
				Sqlca.executeSQL(so);				
			}
			//在合同中录入的授信方案明细没有删除
			if(sObjectType.equals("BusinessContract")){
				sSql = " update CL_INFO set BCSerialNo = null,LineContractNo = null "+
				" where BCSerialNo =:BCSerialNo ";
				so = new SqlObject(sSql).setParameter("BCSerialNo", sObjectNo);
				//执行删除语句
				Sqlca.executeSQL(so);
			}
		}
	}
	
	/**新额度体系相关表 jschen@20121224
	 * @throws Exception */
	private void deleteNewCLInfo(String sObjectType,String sObjectNo,Transaction Sqlca) throws Exception{
		String sSql = "";
		SqlObject so = null;//声明对象
		//删除额度分配表
		sSql = "delete from CL_DIVIDE where ObjectType =:ObjectType and ObjectNo =:ObjectNo";
		so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		Sqlca.executeSQL(so);
		//删除额度占用表
		sSql = "delete from CL_OCCUPY where ObjectType =:ObjectType and ObjectNo =:ObjectNo";
		so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		Sqlca.executeSQL(so);
	}
	
//	删除集团客户信息
	private void deleteGLineInfo(String sObjectType,String sObjectNo,Transaction Sqlca) throws Exception {
		String sSql = "";
		SqlObject so ;//声明对象
		//根据对象类型进行删除操作处理
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
			//在最终审批意见中录入的授信方案明细没有删除
			if(sObjectType.equals("ApproveApply")){
				sSql = " update GLINE_INFO set ApproveSerialNo = null "+
				" where ApproveSerialNo =:ApproveSerialNo ";
			    so = new SqlObject(sSql).setParameter("ApproveSerialNo", sObjectNo);
			    Sqlca.executeSQL(so);
			}
			//在合同中录入的授信方案明细没有删除
			if(sObjectType.equals("BusinessContract")){
				sSql = " update GLINE_INFO set BCSerialNo = null,LineContractNo = null "+
				" where BCSerialNo =:BCSerialNo ";
			    so = new SqlObject(sSql).setParameter("BCSerialNo", sObjectNo);
			    Sqlca.executeSQL(so);
			}
		}
	}

//	删除关联信息
	private void deleteRelativeInfo(String sRelativeTable,String sObjectNo,Transaction Sqlca) throws Exception {
		String sSql = " delete from "+sRelativeTable+"  where SerialNo =:SerialNo ";
		SqlObject so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);
	}

//	删除主体对象信息
	private void deleteObjectInfo(String sObjectTable,String sObjectNo,Transaction Sqlca) throws Exception {
		String sSql = " delete from "+sObjectTable+" where SerialNo =:SerialNo ";
		SqlObject so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);	
	}
//	删除关联合同的关联关系	
	private void deleteAssetContract(String sObjectNo,Transaction Sqlca) throws Exception {
		String sSql = " delete from Asset_Contract where SerialNo =:SerialNo ";
		SqlObject so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);	 
	} 
	//删除有ObjectType,ObjectNo作为外键的表
	private void deleteTableData(String sTableName,String sObjectType,String sObjectNo,Transaction Sqlca)
	throws Exception {
		String sSql = " delete from "+sTableName+" where ObjectType =:ObjectType and ObjectNo =:ObjectNo ";
		SqlObject so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		Sqlca.executeSQL(so); 
	}
	
}
