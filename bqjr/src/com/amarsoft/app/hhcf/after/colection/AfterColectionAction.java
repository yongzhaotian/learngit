package com.amarsoft.app.hhcf.after.colection;

import com.amarsoft.are.ARE;
import com.amarsoft.are.log.Log;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 
 * @author ygwu 2014/03/21
 *
 */
public class AfterColectionAction{
	private Log log = ARE.getLog();
	private String sSql = "";
	
	/**
	 * 合同流水号
	 */
	private String BCSerialNo = "";
	
	/**
	 * 催收任务编号
	 */
	private String ColSerialNo = "";
	
	/**
	 * 催收登记任务流水号
	 */
	private String RegistSerialNo = "";
	
	/**
	 * 城市
	 */
	private String City = "";
	
	/**
	 * 委外催收服务商编号
	 */
	private String ProviderSerialNo = "";
	
	private String ProviderName = "";
	
	private String SerialNo = "";//流水号
	private String TransferDealSerialNo="";//资产转让协议编号
	private String ProjectSerialNo="";//项目编号
	private String ContractSerialNo="";//合同编号
	private String TransferType="";//资产转让类型(0010:首次 转让;0020:再次转让)
	private String InputUserID="";//录入用户编号
	private String InputOrgID="";//录入机构编号
	private String InputDate="";//录入日期
	
	/**
	 * 资产转让项目项下关联合同时的执行脚本
	 * @param sSqlca
	 * @return String 
	 * @throws Exception
	 */
	public String projectRelationContract(Transaction sSqlca) throws Exception{
		//判断合同是否己经与项目关联,合同不允许关联至多个项目下.
		sSql = "select count(*) from transfer_project_contract where TransferType='"+TransferType+"' and ContractSerialNo='"+ContractSerialNo+"'";
		int rows = Integer.valueOf(sSqlca.getString(sSql));
		if(rows>0){
			return "ContractIsExist";
		}
		//执行关联操作
		String sSql = "insert into TRANSFER_PROJECT_CONTRACT(SerialNo,TransferDealSerialNo,ProjectSerialNo,ContractSerialNo,TransferType,InputUserID,InputOrgID,InputDate) "+
					"values('"+SerialNo+"','"
					+TransferDealSerialNo+"',"
					+"'"+ProjectSerialNo+"',"
					+"'"+ContractSerialNo+"',"
					+"'"+TransferType+"',"
					+"'"+InputUserID+"',"
					+"'"+InputOrgID+"',"
					+"'"+InputDate+"')";
		
		sSqlca.executeSQL(sSql);
		return "true";
	}
	
	/**
	 * 法务诉讼登记信息保存
	 * @param sSqlca
	 * @return String
	 * @throws Exception
	 */
	public String saveLawsInfo(Transaction sSqlca) throws Exception{
		String sCustomerID = "";
		String sPhaseType1 = "";
		String sPhaseType2 = "";
		
		sSql = "select c.phasetype1,c.phasetype2,b.customerid from car_collection_info c,business_contract b where "+
			   "b.serialno = c.contractserialno and c.serialno='"+ColSerialNo+"' and c.contractSerialNo='"+BCSerialNo+"'";
		ASResultSet rs = sSqlca.getASResultSet(sSql);
		if(rs.next()){
			sCustomerID = rs.getString("customerid");
			sPhaseType1 = rs.getString("phasetype1");
			sPhaseType2 = rs.getString("phasetype2");
		}
		rs.getStatement().close();
		sSql="update car_collectionregist_info set customerid = '"+sCustomerID+"',phasetype1='"+sPhaseType1+"',phasetype2='"+sPhaseType2+"'";
		System.out.println("靠执行SQL:"+sSql);
		sSqlca.executeSQL(sSql);
		return "true";
	}
	
	/**
	 * 委外催收任务移交法务
	 * @param sSqlca
	 * @return String
	 * @throws Exception 
	 */
	public String gotoLaws(Transaction sSqlca) throws Exception{
		//状态大类为法务阶段 ，状态小类为己分配状态
		sSql="update car_collection_info set phasetype1='0040' , phasetype2='0020' where serialno='"+ColSerialNo+"'";
		sSqlca.executeSQL(sSql);
		return "true";
	}
	
	
	/**
	 * 转核销
	 * @param sSqlca
	 * @return String
	 */
	public String gotoVerification(Transaction sSqlca) throws Exception{
		sSql="update car_collection_info set phasetype1='0050' , phasetype2='0020' where serialno='"+ColSerialNo+"'";
		sSqlca.executeSQL(sSql);
		return "true";
	}
	
	/**
	 * 实地催收任务的催收城市
	 * @param sSqlca
	 * @return String
	 * @throws Exception 
	 */
	public String changeCollectionCity(Transaction sSqlca) throws Exception{
		sSql="update car_collection_info set newadd='"+City+"' where serialno='"+ColSerialNo+"'";
		sSqlca.executeSQL(sSql);
		return "Success";
	}
	
	/**
	 * 委外催收任务退回操作
	 * @param sSqlca
	 * @return
	 * @throws Exception
	 */
	public String goBackProvider(Transaction sSqlca) throws Exception{
		sSql = "update car_collection_info set phasetype2='0050' where serialno='"+ColSerialNo+"'";
		sSqlca.executeSQL(sSql);
		return "Success";
	}
	/**
	 * 委外催收任务与服务商进行关联，将委外催收任务状态变更为己分配
	 * @param sSqlca
	 * @return String
	 * @throws Exception 
	 */
	public String updateCollectionProviderAndStatus(Transaction sSqlca) throws Exception{
		sSql="update car_collection_info set phasetype2='0020',serviceprovidersname='"+ProviderName+
			 "' , serviceproviderserialno='"+ProviderSerialNo+"' where serialno='"+ColSerialNo+"'";
		sSqlca.executeSQL(sSql);
		return "Success";
	}
	/**
	 * 实地催收任务状态变更为委外催收且待分配服务商状态；
	 * @param sSqlca
	 * @return
	 * @throws Exception
	 */
	public String gotoProviderCollection(Transaction sSqlca) throws Exception{
		sSql="update car_collection_info set phasetype1='0030' ,phasetype2='0010' where serialno='"+ColSerialNo+"'";
		sSqlca.executeSQL(sSql);
		return "Success";
		
	}
	
	/**
	 * 委外催收服务商编号关联至委外催收任务中
	 * @param sSqlca
	 * @return
	 * @throws Exception 
	 */
	public String updateCollectionWithProvider(Transaction sSqlca) throws Exception{
		sSql="update car_collection_info set phasetype1='0030',phasetype2='0010' ,serviceproviderserialno='"+
			 ProviderSerialNo+"' , serviceprovidersname='"+ProviderName+"' where serialno='"+ColSerialNo+"'";
		sSqlca.executeSQL(sSql);
		return "Success";
	}
	
	/**
	 * 
	 * @return
	 */
	public String updateCollectionStatus(){
		sSql="";
		return "";
	}
	
	/**
	 * 获取催收任务的催收城市
	 * @param sSqlca
	 * @return String
	 * @throws Exception
	 */
	public String getCollectionCity(Transaction sSqlca) throws Exception{
		sSql="select itemno from (select * from (select itemno from code_library where codeno='AreaCode' and "+
			 "length(itemno)>=4 and substr(itemno,1,4) =substr('"+City+"',1,4) order by itemno asc)T where rownum=1 "+
			 "union select itemno from code_library where codeno='AreaCode' AND length(itemno)>=4 and itemno in('110000',"+
			 "'120000','310000','500000') AND itemno='"+City+"') AreaCode";
		ASResultSet rs = sSqlca.getASResultSet(sSql);
		if(rs.next())	return rs.getString("itemno");
		if (rs != null) 
		rs.getStatement().close();
		return "Falture";
	}
	
	/**
	 * 汽车贷本地催收任务获取功能，将催收任务状态为本地催收，且子状态为待分配任务的子状态变更为己分配。
	 * @param sSqlca
	 * @return String
	 */
	public String getCarColectionTask(Transaction sSqlca){
		//将催收任务状态为本地催收(0020)，且子状态为待分配(0010)任务的子状态变更为己分配(0020)
		sSql = "update car_collection_info set phasetype2='0020' where serialno='"+ColSerialNo+"'";
		try {
			sSqlca.executeSQL(new SqlObject(sSql));
			return "Success";
		} catch (Exception e) {
			e.printStackTrace();
			log.error("数据任务状态更新异常",e);
		}
		return "Falture";
	}

	/**
	 * 催收任务phasetype1,phasetype2的催收状态更新
	 * @param sSqlca
	 * @return String
	 */
	public String updateCarColectionRegist(Transaction sSqlca){
		//将催收登记记录的状态变更为任务阶段标识大类phasetype1为实地催收 and 阶段标识小类phasetype2为己分配
		sSql = "update car_collectionregist_info set phasetype1='0020',phasetype2='0020' where serialno='"+RegistSerialNo+"'";
		
		try {
			sSqlca.executeSQL(sSql);
			log.info("催收跟进登记结果状态更新成功!");
			
			sSql = "select customerid from business_contract where serialno=(select contractserialno from "+
					"car_collectionregist_info where serialno='"+RegistSerialNo+"')";
			ASResultSet rs = sSqlca.getASResultSet(sSql);
			if(rs.next()){
				sSql = "update car_collectionregist_info set customerid = '"+rs.getString("customerid")+"' where serialno='"+RegistSerialNo+"'";
			}
			sSqlca.executeSQL(sSql);
			log.info("催收跟进登记结果的客户号更新成功!");
			if (rs != null) rs.close();
			return "Success";
		} catch (Exception e) {
			e.printStackTrace();
			log.error("催收跟进登记结果状态更新失败!",e);
		}
		return "Falture";
	}
	
	/**
	 * 委外催收跟进结果登记状态更新
	 * @param sSqlca
	 * @return String
	 */
	public String updateCarColectionRegist2(Transaction sSqlca){
		//将催收登记记录的状态变更为任务阶段标识大类phasetype1为实地催收 and 阶段标识小类phasetype2为己分配
		sSql = "update car_collectionregist_info set phasetype1='0030',phasetype2='0020' where serialno='"+ColSerialNo+"'";
		
		try {
			sSqlca.executeSQL(sSql);
			log.info("催收跟进登记结果状态更新成功!");
			
			sSql = "select customerid from business_contract where serialno=(select contractserialno from "+
					"car_collectionregist_info where serialno='"+RegistSerialNo+"')";
			ASResultSet rs = sSqlca.getASResultSet(sSql);
			if(rs.next()){
				sSql = "update car_collectionregist_info set customerid = '"+rs.getString("customerid")+"' where serialno='"+RegistSerialNo+"'";
			}
			sSqlca.executeSQL(sSql);
			if (rs != null) 
			rs.getStatement().close();
			log.info("催收跟进登记结果的客户号更新成功!");
			return "Success";
		} catch (Exception e) {
			e.printStackTrace();
			log.error("催收跟进登记结果状态更新失败!",e);
		}
		return "Falture";
	}
	
	
	/**
	 * 催收任务退回状态更新
	 * @param sSqlca
	 * @return String
	 */
	public String updateCarColectionStatus(Transaction sSqlca){
		sSql="update car_collection_info set phasetype2='0050' where serialno='"+ColSerialNo+"'";
		try {
			sSqlca.executeSQL(sSql);
			log.info("催收任务退回状态更新成功!");
			return "Success";
		} catch (Exception e) {
			e.printStackTrace();
			log.error("催收任务退回状态更新失败!",e);
		}
		return "Falture";
	}
	
	
	
	/**
	 * 从委外队列待分配变更为委外己分配
	 * @param sSqlca
	 * @return
	 */
	public String assignService(Transaction sSqlca){
		sSql="update car_collection_info set  phasetype2='0020' where serialno='"+ColSerialNo+"'";
		try {
			sSqlca.executeSQL(sSql);
			log.info("催收任务委外状态更新成功!");
			return "Success";
		} catch (Exception e) {
			e.printStackTrace();
			log.error("催收任务委外状态更新失败!",e);
		}
		return "Falture";
	}
	
	
	
	

	public String getSerialNo() {
		return SerialNo;
	}

	public void setSerialNo(String serialNo) {
		SerialNo = serialNo;
	}

	public String getTransferDealSerialNo() {
		return TransferDealSerialNo;
	}

	public void setTransferDealSerialNo(String transferDealSerialNo) {
		TransferDealSerialNo = transferDealSerialNo;
	}

	public String getProjectSerialNo() {
		return ProjectSerialNo;
	}

	public void setProjectSerialNo(String projectSerialNo) {
		ProjectSerialNo = projectSerialNo;
	}

	public String getContractSerialNo() {
		return ContractSerialNo;
	}

	public void setContractSerialNo(String contractSerialNo) {
		ContractSerialNo = contractSerialNo;
	}

	public String getTransferType() {
		return TransferType;
	}

	public void setTransferType(String transferType) {
		TransferType = transferType;
	}

	public String getInputUserID() {
		return InputUserID;
	}

	public void setInputUserID(String inputUserID) {
		InputUserID = inputUserID;
	}

	public String getInputOrgID() {
		return InputOrgID;
	}

	public void setInputOrgID(String inputOrgID) {
		InputOrgID = inputOrgID;
	}

	public String getInputDate() {
		return InputDate;
	}

	public void setInputDate(String inputDate) {
		InputDate = inputDate;
	}

	public String getColSerialNo() {
		return ColSerialNo;
	}

	public void setColSerialNo(String colSerialNo) {
		ColSerialNo = colSerialNo;
	}

	public String getRegistSerialNo() {
		return RegistSerialNo;
	}

	public void setRegistSerialNo(String registSerialNo) {
		RegistSerialNo = registSerialNo;
	}

	public String getBCSerialNo() {
		return BCSerialNo;
	}

	public void setBCSerialNo(String bCSerialNo) {
		BCSerialNo = bCSerialNo;
	}

	public String getCity() {
		return City;
	}

	public void setCity(String city) {
		City = city;
	}

	public String getProviderSerialNo() {
		return ProviderSerialNo;
	}

	public void setProviderSerialNo(String providerSerialNo) {
		ProviderSerialNo = providerSerialNo;
	}

	public String getProviderName() {
		return ProviderName;
	}

	public void setProviderName(String providerName) {
		ProviderName = providerName;
	}
}
