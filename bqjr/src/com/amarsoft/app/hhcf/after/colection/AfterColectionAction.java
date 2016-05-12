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
	 * ��ͬ��ˮ��
	 */
	private String BCSerialNo = "";
	
	/**
	 * ����������
	 */
	private String ColSerialNo = "";
	
	/**
	 * ���յǼ�������ˮ��
	 */
	private String RegistSerialNo = "";
	
	/**
	 * ����
	 */
	private String City = "";
	
	/**
	 * ί����շ����̱��
	 */
	private String ProviderSerialNo = "";
	
	private String ProviderName = "";
	
	private String SerialNo = "";//��ˮ��
	private String TransferDealSerialNo="";//�ʲ�ת��Э����
	private String ProjectSerialNo="";//��Ŀ���
	private String ContractSerialNo="";//��ͬ���
	private String TransferType="";//�ʲ�ת������(0010:�״� ת��;0020:�ٴ�ת��)
	private String InputUserID="";//¼���û����
	private String InputOrgID="";//¼��������
	private String InputDate="";//¼������
	
	/**
	 * �ʲ�ת����Ŀ���¹�����ͬʱ��ִ�нű�
	 * @param sSqlca
	 * @return String 
	 * @throws Exception
	 */
	public String projectRelationContract(Transaction sSqlca) throws Exception{
		//�жϺ�ͬ�Ƿ񼺾�����Ŀ����,��ͬ����������������Ŀ��.
		sSql = "select count(*) from transfer_project_contract where TransferType='"+TransferType+"' and ContractSerialNo='"+ContractSerialNo+"'";
		int rows = Integer.valueOf(sSqlca.getString(sSql));
		if(rows>0){
			return "ContractIsExist";
		}
		//ִ�й�������
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
	 * �������ϵǼ���Ϣ����
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
		System.out.println("��ִ��SQL:"+sSql);
		sSqlca.executeSQL(sSql);
		return "true";
	}
	
	/**
	 * ί����������ƽ�����
	 * @param sSqlca
	 * @return String
	 * @throws Exception 
	 */
	public String gotoLaws(Transaction sSqlca) throws Exception{
		//״̬����Ϊ����׶� ��״̬С��Ϊ������״̬
		sSql="update car_collection_info set phasetype1='0040' , phasetype2='0020' where serialno='"+ColSerialNo+"'";
		sSqlca.executeSQL(sSql);
		return "true";
	}
	
	
	/**
	 * ת����
	 * @param sSqlca
	 * @return String
	 */
	public String gotoVerification(Transaction sSqlca) throws Exception{
		sSql="update car_collection_info set phasetype1='0050' , phasetype2='0020' where serialno='"+ColSerialNo+"'";
		sSqlca.executeSQL(sSql);
		return "true";
	}
	
	/**
	 * ʵ�ش�������Ĵ��ճ���
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
	 * ί����������˻ز���
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
	 * ί���������������̽��й�������ί���������״̬���Ϊ������
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
	 * ʵ�ش�������״̬���Ϊί������Ҵ����������״̬��
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
	 * ί����շ����̱�Ź�����ί�����������
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
	 * ��ȡ��������Ĵ��ճ���
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
	 * ���������ش��������ȡ���ܣ�����������״̬Ϊ���ش��գ�����״̬Ϊ�������������״̬���Ϊ�����䡣
	 * @param sSqlca
	 * @return String
	 */
	public String getCarColectionTask(Transaction sSqlca){
		//����������״̬Ϊ���ش���(0020)������״̬Ϊ������(0010)�������״̬���Ϊ������(0020)
		sSql = "update car_collection_info set phasetype2='0020' where serialno='"+ColSerialNo+"'";
		try {
			sSqlca.executeSQL(new SqlObject(sSql));
			return "Success";
		} catch (Exception e) {
			e.printStackTrace();
			log.error("��������״̬�����쳣",e);
		}
		return "Falture";
	}

	/**
	 * ��������phasetype1,phasetype2�Ĵ���״̬����
	 * @param sSqlca
	 * @return String
	 */
	public String updateCarColectionRegist(Transaction sSqlca){
		//�����յǼǼ�¼��״̬���Ϊ����׶α�ʶ����phasetype1Ϊʵ�ش��� and �׶α�ʶС��phasetype2Ϊ������
		sSql = "update car_collectionregist_info set phasetype1='0020',phasetype2='0020' where serialno='"+RegistSerialNo+"'";
		
		try {
			sSqlca.executeSQL(sSql);
			log.info("���ո����Ǽǽ��״̬���³ɹ�!");
			
			sSql = "select customerid from business_contract where serialno=(select contractserialno from "+
					"car_collectionregist_info where serialno='"+RegistSerialNo+"')";
			ASResultSet rs = sSqlca.getASResultSet(sSql);
			if(rs.next()){
				sSql = "update car_collectionregist_info set customerid = '"+rs.getString("customerid")+"' where serialno='"+RegistSerialNo+"'";
			}
			sSqlca.executeSQL(sSql);
			log.info("���ո����Ǽǽ���Ŀͻ��Ÿ��³ɹ�!");
			if (rs != null) rs.close();
			return "Success";
		} catch (Exception e) {
			e.printStackTrace();
			log.error("���ո����Ǽǽ��״̬����ʧ��!",e);
		}
		return "Falture";
	}
	
	/**
	 * ί����ո�������Ǽ�״̬����
	 * @param sSqlca
	 * @return String
	 */
	public String updateCarColectionRegist2(Transaction sSqlca){
		//�����յǼǼ�¼��״̬���Ϊ����׶α�ʶ����phasetype1Ϊʵ�ش��� and �׶α�ʶС��phasetype2Ϊ������
		sSql = "update car_collectionregist_info set phasetype1='0030',phasetype2='0020' where serialno='"+ColSerialNo+"'";
		
		try {
			sSqlca.executeSQL(sSql);
			log.info("���ո����Ǽǽ��״̬���³ɹ�!");
			
			sSql = "select customerid from business_contract where serialno=(select contractserialno from "+
					"car_collectionregist_info where serialno='"+RegistSerialNo+"')";
			ASResultSet rs = sSqlca.getASResultSet(sSql);
			if(rs.next()){
				sSql = "update car_collectionregist_info set customerid = '"+rs.getString("customerid")+"' where serialno='"+RegistSerialNo+"'";
			}
			sSqlca.executeSQL(sSql);
			if (rs != null) 
			rs.getStatement().close();
			log.info("���ո����Ǽǽ���Ŀͻ��Ÿ��³ɹ�!");
			return "Success";
		} catch (Exception e) {
			e.printStackTrace();
			log.error("���ո����Ǽǽ��״̬����ʧ��!",e);
		}
		return "Falture";
	}
	
	
	/**
	 * ���������˻�״̬����
	 * @param sSqlca
	 * @return String
	 */
	public String updateCarColectionStatus(Transaction sSqlca){
		sSql="update car_collection_info set phasetype2='0050' where serialno='"+ColSerialNo+"'";
		try {
			sSqlca.executeSQL(sSql);
			log.info("���������˻�״̬���³ɹ�!");
			return "Success";
		} catch (Exception e) {
			e.printStackTrace();
			log.error("���������˻�״̬����ʧ��!",e);
		}
		return "Falture";
	}
	
	
	
	/**
	 * ��ί����д�������Ϊί�⼺����
	 * @param sSqlca
	 * @return
	 */
	public String assignService(Transaction sSqlca){
		sSql="update car_collection_info set  phasetype2='0020' where serialno='"+ColSerialNo+"'";
		try {
			sSqlca.executeSQL(sSql);
			log.info("��������ί��״̬���³ɹ�!");
			return "Success";
		} catch (Exception e) {
			e.printStackTrace();
			log.error("��������ί��״̬����ʧ��!",e);
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
