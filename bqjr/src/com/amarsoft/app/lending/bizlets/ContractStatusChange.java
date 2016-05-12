package com.amarsoft.app.lending.bizlets;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.proj.action.P2PCredit;

/**
 * ��ͬ״̬�ı䴦���߼���
 * @author jiangyuanlin
 *
 */
public class ContractStatusChange {
	private String userId;
	private String serialNo;//��ͬ��
	private String status;
	private double businesssum;//������
	private String putOutDate;//��������
	private String sureType = "";//��������
	private String isp2p = "";
	/**
	 * �޸ĺ�ͬ״̬����
	 * @param Sqlca
	 * @return
	 */
	public String statusChange(Transaction Sqlca){
		String sql = "select bc.Businesssum,bc.putOutDate,bc.SureType,bc.ContractStatus,bc.isp2p from business_contract bc  where  bc.serialno='" + getSerialNo() + "'";
		try {
			ASResultSet bc = Sqlca.getASResultSet(sql);
			if(bc.next()){
				this.putOutDate = bc.getString("putOutDate");
				this.status  = bc.getString("ContractStatus");
			   	this.businesssum = bc.getDouble("Businesssum");
	        	this.sureType = bc.getString("SureType");
	        	this.isp2p = DataConvert.toString(bc.getString("isp2p"));
			}
			bc.getStatement().close();
			//��ע��
			if("050".equals(status)){
				//��ɫΪ�޸ĺ�ͬ״̬(��Ӫ) ���޸���ע���ͬ
				String query = "select count(1)  from user_role ur where ur.userid='"+getUserId()+"' and ur.roleid='1112'";
				double count = Sqlca.getDouble(query);
				if(count <= 0){
					return "false@��û���޸�Ȩ�ޣ�";
				}
				int sDays = DateFunctions.getDays(putOutDate, SystemConfig.getBusinessDate());
				if(sDays >= 15){//��Ϣ����ʮ���첻������������
					return "false@��Ϣ����ʮ���첻������������";
				}
				return registerTocancel(Sqlca);
			}
			//���ڳ���δע���߼�
			if("090".equals(status)){
				//���һ��"1113"��Ȩ��    by xiaoqing.fang 20151117
				String query = "select count(1)  from user_role ur where ur.userid='"+getUserId()+"' and ur.roleid in ('1112','1113')";
				double count = Sqlca.getDouble(query);
				if(count <= 0){
					return "false@��û���޸�Ȩ�ޣ�";
				}
				return notRegisterToSign(Sqlca);
			}
			// ����ͨ��
			if("080".equals(status)){
				return approvedToCancel(Sqlca);
			}
			//��ǩ��
			if("020".equals(status)){
				return signToApprovaled(Sqlca);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "false@����ʧ�ܣ�";
	}
	/**
	 * ��ע��״̬�ı��߼�
	 * @param Sqlca
	 * @param bom
	 * @return
	 * @throws Exception
	 */
	private String  registerTocancel(Transaction Sqlca) throws Exception{
		try{
			String sql ="update acct_loan al set al.normalbalance='0',al.nextduedate='',al.loanstatus='6',al.nextinstalmentamt='0' where al.putoutno='"+getSerialNo()+"'";
			Sqlca.executeSQL(sql);
			sql ="update business_contract bc set bc.ContractStatus='210',bc.editName='"+getUserId()+"',"
					+" bc.editDate='"+DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")+"'"
					+" where bc.serialNo='"+getSerialNo()+"'";
			Sqlca.executeSQL(sql);
			insertLog(Sqlca,getStatus(),"210","��ͬ�����޸ĺ�ͬ״̬���޸ĺ�ͬ״̬");
			return "true@�����ɹ���";
		} catch (Exception e) {
			e.printStackTrace();
			return "false@����ʧ�ܣ�";
		}
		
	}
	/**
	 * ��ǩ�� > ����ͨ��
	 * @param Sqlca
	 * @return
	 */
	private String signToApprovaled(Transaction Sqlca){
		try {
			String sql ="update business_contract bc set bc.ContractStatus='080',bc.editName='"+getUserId()+"',"
					+" bc.editDate='"+DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")+"',"
					+" bc.signeddate=''"
					+" where bc.serialNo='"+getSerialNo()+"'";
			Sqlca.executeSQL(sql);
			insertLog(Sqlca,getStatus(),"080","��ͬ�����޸ĺ�ͬ״̬���޸ĺ�ͬ״̬");
			sql ="update flow_object set PhaseType='1040' where objecttype='BusinessContract' and objectno='"+getSerialNo()+"' ";
			Sqlca.executeSQL(sql);
		} catch (Exception e) {
			return "false@����ʧ�ܣ�";
		}
		return "true@�����ɹ���";
	}
	
	/**
	 * ����δע�� ����ǩ��
	 * @param Sqlca
	 * @return
	 */
	private String notRegisterToSign(Transaction Sqlca){
		try {
			//ϵͳʱ����ڷ����ռ�һ����-10�첻������״̬�޸�
			SimpleDateFormat format = new SimpleDateFormat("yyyy/MM/dd");
			Date date = format.parse(getPutOutDate());
			Calendar cal = Calendar.getInstance();
			cal.setTime(date);
			cal.add(Calendar.MONTH, 1);
			cal.add(Calendar.DATE, -10);
			Date newdate = cal.getTime();
			String sBeginDate = format.format(newdate);
			String sEndDate =format.format(format.parse(SystemConfig.getBusinessDate()));
			int day = DateFunctions.getDays(sBeginDate, sEndDate);
			if(day>0){
				return "false@�ñʺ�ͬ�������������������޸ĺ�ͬ״̬��";
			}
			String sql ="update business_contract bc set bc.ContractStatus='020',bc.editName='"+getUserId()+"',"
					+" bc.editDate='"+DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")+"',"
					+" bc.signeddate='"+SystemConfig.getBusinessDate()+"',"
					+" bc.shiftdocdescribe='"+DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")+"'"
					+" where bc.serialNo='"+getSerialNo()+"'";
			Sqlca.executeSQL(sql);
			insertLog(Sqlca,getStatus(),"020","��ͬ�����޸ĺ�ͬ״̬���޸ĺ�ͬ״̬");
			return  "true@�����ɹ���";
		} catch (Exception e) {
			e.printStackTrace();
			return "false@����ʧ�ܣ�";
		}
	}
	
	/**
	 * ����ͨ��>ȡ��
	 * @param Sqlca
	 * @param bom
	 * @return
	 */
	private String approvedToCancel(Transaction Sqlca){
		String sql = "select al.serialno as LoanSerialNo from acct_loan al where al.putoutno='"+getSerialNo()+"'";
		String loanSerialNo ="";
		try {
			ASResultSet result = Sqlca.getASResultSet(sql);
			if(result.next()){
				loanSerialNo = result.getString("LoanSerialNo");
			}
			result.getStatement().close();
			if(loanSerialNo!=null&&loanSerialNo.length()>0){//�н�ݺ�Ҫ ���½��
				sql ="update acct_loan al set al.normalbalance='0',al.nextduedate='',al.loanstatus='6',al.nextinstalmentamt='0' where al.putoutno='"+getSerialNo()+"'";
				Sqlca.executeSQL(sql);
			}
			sql ="update business_contract bc set bc.ContractStatus='210',bc.editName='"+getUserId()+"',"
					+" bc.editDate='"+DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")+"'"
					+" where bc.serialNo='"+getSerialNo()+"'";
			Sqlca.executeSQL(sql);
	        insertLog(Sqlca,getStatus(),"210","��ͬ�����޸ĺ�ͬ״̬���޸ĺ�ͬ״̬");
	        //����Ƿ���Ҫ����p2p���
	        if( "1".equals(getIsp2p()) && ("PC".equals(getSureType()) || "APP".equals(getSureType())) && ( "070".equals(getStatus()) || "080".equals(getStatus()) ) ){
	        	P2PCredit credit = new P2PCredit();
	        	credit.returnP2pSum(getBusinesssum(), Sqlca);
	        }
			return "true@�����ɹ���";
		} catch (Exception e) {
			e.printStackTrace();
			return "false@����ʧ�ܣ�";
		}
	}
	
	/**
	 * ���º�ͬ״̬��д�������־
	 * @param Sqlca
	 * @param oldStatus
	 * @param newStatus
	 * @param source
	 * @throws Exception
	 */
	private void insertLog(Transaction Sqlca,String oldStatus,String newStatus,String source) throws Exception{
		String sql = " insert into CONTRACTSTATUS_CHANGE_EVENT(SERIALNO, OLD_CONTRACTSTATUS, NEW_CONTRACTSTATUS, SOURCE_MODULE, REMARK, UPDATER)"
				+"values(:serialno,:old_contractstatus,:new_contractstatus,:source_module,:remark,:updater)";
		SqlObject so = new SqlObject(sql);
		so.setParameter("serialno", getSerialNo());
		so.setParameter("old_contractstatus", oldStatus);
		so.setParameter("new_contractstatus", newStatus);
		so.setParameter("source_module", source);
		so.setParameter("remark", "�޸ĺ�ͬ״̬");
		so.setParameter("updater", getUserId());
		Sqlca.executeSQL(so);
	}
	
	public String approvedToRegister(Transaction Sqlca){
		String sql = "select bc.Businesssum,bc.putOutDate,bc.SureType,bc.ContractStatus,bc.isp2p from business_contract bc where bc.serialno='" + getSerialNo() + "'";
		ASResultSet bc;
		try {
			bc = Sqlca.getASResultSet(sql);
			if(bc.next()){
				this.putOutDate = bc.getString("putOutDate");
				this.status  = bc.getString("ContractStatus");
				this.businesssum = bc.getDouble("Businesssum");
				this.sureType = bc.getString("SureType");
				this.isp2p = DataConvert.toString(bc.getString("isp2p"));
			}
			bc.getStatement().close();
			sql ="update business_contract bc set bc.ContractStatus='020',bc.editName='"+getUserId()+"',"
					+" bc.editDate='"+DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")+"',"
					+" bc.signeddate='"+SystemConfig.getBusinessDate()+"'"
					+" where bc.serialNo='"+getSerialNo()+"'";
			Sqlca.executeSQL(sql);
			insertLog(Sqlca,getStatus(),"020","��ͬ�����޸ĺ�ͬ״̬���޸ĺ�ͬ״̬");
			return "false@�����ɹ���";
		} catch (Exception e) {
			e.printStackTrace();
			return "false@����ʧ�ܣ�";
		}
	}

	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getSerialNo() {
		return serialNo;
	}
	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
	
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getPutOutDate() {
		return putOutDate;
	}
	public void setPutOutDate(String putOutDate) {
		this.putOutDate = putOutDate;
	}
	public String getSureType() {
		return sureType;
	}
	public void setSureType(String sureType) {
		this.sureType = sureType;
	}
	public String getIsp2p() {
		return isp2p;
	}
	public void setIsp2p(String isp2p) {
		this.isp2p = isp2p;
	}
	public double getBusinesssum() {
		return businesssum;
	}
	public void setBusinesssum(double businesssum) {
		this.businesssum = businesssum;
	}
}
