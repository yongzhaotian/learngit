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
 * 合同状态改变处理逻辑类
 * @author jiangyuanlin
 *
 */
public class ContractStatusChange {
	private String userId;
	private String serialNo;//合同号
	private String status;
	private double businesssum;//贷款金额
	private String putOutDate;//贷款日期
	private String sureType = "";//贷款类型
	private String isp2p = "";
	/**
	 * 修改合同状态处理
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
			//已注册
			if("050".equals(status)){
				//角色为修改合同状态(运营) 可修改已注册合同
				String query = "select count(1)  from user_role ur where ur.userid='"+getUserId()+"' and ur.roleid='1112'";
				double count = Sqlca.getDouble(query);
				if(count <= 0){
					return "false@你没有修改权限！";
				}
				int sDays = DateFunctions.getDays(putOutDate, SystemConfig.getBusinessDate());
				if(sDays >= 15){//计息超过十五天不允许做撤销！
					return "false@计息超过十五天不允许做撤销！";
				}
				return registerTocancel(Sqlca);
			}
			//超期超期未注册逻辑
			if("090".equals(status)){
				//添加一个"1113"的权限    by xiaoqing.fang 20151117
				String query = "select count(1)  from user_role ur where ur.userid='"+getUserId()+"' and ur.roleid in ('1112','1113')";
				double count = Sqlca.getDouble(query);
				if(count <= 0){
					return "false@你没有修改权限！";
				}
				return notRegisterToSign(Sqlca);
			}
			// 审批通过
			if("080".equals(status)){
				return approvedToCancel(Sqlca);
			}
			//已签署
			if("020".equals(status)){
				return signToApprovaled(Sqlca);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "false@操作失败！";
	}
	/**
	 * 已注册状态改变逻辑
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
			insertLog(Sqlca,getStatus(),"210","合同管理》修改合同状态》修改合同状态");
			return "true@操作成功！";
		} catch (Exception e) {
			e.printStackTrace();
			return "false@操作失败！";
		}
		
	}
	/**
	 * 已签署 > 审批通过
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
			insertLog(Sqlca,getStatus(),"080","合同管理》修改合同状态》修改合同状态");
			sql ="update flow_object set PhaseType='1040' where objecttype='BusinessContract' and objectno='"+getSerialNo()+"' ";
			Sqlca.executeSQL(sql);
		} catch (Exception e) {
			return "false@操作失败！";
		}
		return "true@操作成功！";
	}
	
	/**
	 * 超期未注册 》已签署
	 * @param Sqlca
	 * @return
	 */
	private String notRegisterToSign(Transaction Sqlca){
		try {
			//系统时间大于发放日加一个月-10天不允许做状态修改
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
				return "false@该笔合同超出限制天数，不能修改合同状态！";
			}
			String sql ="update business_contract bc set bc.ContractStatus='020',bc.editName='"+getUserId()+"',"
					+" bc.editDate='"+DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")+"',"
					+" bc.signeddate='"+SystemConfig.getBusinessDate()+"',"
					+" bc.shiftdocdescribe='"+DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")+"'"
					+" where bc.serialNo='"+getSerialNo()+"'";
			Sqlca.executeSQL(sql);
			insertLog(Sqlca,getStatus(),"020","合同管理》修改合同状态》修改合同状态");
			return  "true@操作成功！";
		} catch (Exception e) {
			e.printStackTrace();
			return "false@操作失败！";
		}
	}
	
	/**
	 * 审批通过>取消
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
			if(loanSerialNo!=null&&loanSerialNo.length()>0){//有借据号要 更新借据
				sql ="update acct_loan al set al.normalbalance='0',al.nextduedate='',al.loanstatus='6',al.nextinstalmentamt='0' where al.putoutno='"+getSerialNo()+"'";
				Sqlca.executeSQL(sql);
			}
			sql ="update business_contract bc set bc.ContractStatus='210',bc.editName='"+getUserId()+"',"
					+" bc.editDate='"+DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")+"'"
					+" where bc.serialNo='"+getSerialNo()+"'";
			Sqlca.executeSQL(sql);
	        insertLog(Sqlca,getStatus(),"210","合同管理》修改合同状态》修改合同状态");
	        //检查是否需要返回p2p额度
	        if( "1".equals(getIsp2p()) && ("PC".equals(getSureType()) || "APP".equals(getSureType())) && ( "070".equals(getStatus()) || "080".equals(getStatus()) ) ){
	        	P2PCredit credit = new P2PCredit();
	        	credit.returnP2pSum(getBusinesssum(), Sqlca);
	        }
			return "true@操作成功！";
		} catch (Exception e) {
			e.printStackTrace();
			return "false@操作失败！";
		}
	}
	
	/**
	 * 更新合同状态并写入操作日志
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
		so.setParameter("remark", "修改合同状态");
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
			insertLog(Sqlca,getStatus(),"020","合同管理》修改合同状态》修改合同状态");
			return "false@操作成功！";
		} catch (Exception e) {
			e.printStackTrace();
			return "false@操作失败！";
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
