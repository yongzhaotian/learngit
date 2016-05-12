package com.amarsoft.app.check;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.amarsoft.app.util.DBKeyUtils;
import com.amarsoft.are.ARE;
import com.amarsoft.are.sql.Connection;
import com.amarsoft.awe.Configure;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.scoreport.service.idcheck.BankCardCheckResult;
import com.scoreport.service.idcheck.ValidateAccount;
import com.scoreport.service.idcheck.ValidateAccountPortType;

public class BankCardCheck {
	
	public BankCardCheck(String serialno, String realname, String certno,
			String bankcardtype, String xfbankcode, String dkbankcode,
			String servicetype, String bankcardno, String mobileno,
			String infotype, String customerid) {
		super();
		this.serialno = serialno;
		this.realname = realname;
		this.certno = certno;
		this.bankcardtype = bankcardtype;
		this.xfbankcode = xfbankcode;
		this.dkbankcode = dkbankcode;
		this.servicetype = servicetype;
		this.bankcardno = bankcardno;
		this.mobileno = mobileno;
		this.infotype = infotype;
		this.customerid = customerid;
	}
	
	
	public BankCardCheck() {
		super();
	}


	/**
	 * 校验卡Bin
	 * @param Sqlca
	 * @return 0 不存在卡bin 1 存在卡bin且为借记卡 2 存在卡bin且为信用卡
	 * @throws SQLException 
	 */
	public String checkCardBin(Transaction Sqlca) throws Exception{
		String flag = "0";
		String type = "";
		String cardNo = bankcardno;
		String sql = "select t.bank_mark,t.type from bank_code_like t where t.bank_code=:xfbankcode";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sql).setParameter("xfbankcode", xfbankcode));
		while (rs.next()){
			if(cardNo.startsWith(rs.getString("bank_mark"))){
				type = rs.getString("type");
				if("1".equals(type)){
					flag = "1";
				}else{
					flag = "2";
				}
				
				break;
			}
		}
		
		return flag;
	}
	/**
	 * 校验是否在业务系统表中存在校验过的信息s
	 * @param Sqlca
	 * @return
	 * @throws Exception 
	 */
	public String isHadChecked(Transaction Sqlca) throws Exception{
		
		String returnStr = "fail"; 
		String sql = "select t.applyno,t.applytime,t.resultcode,t.resultinfo,t.success,t.reqstatus from CARDVALIDATE_INFO t where t.realname="
				+ ":realname and t.certno=:certno and t.xfbankcode=:xfbankcode and t.bankcardno=:bankcardno"
						+ " and t.reqstatus not in ('03','04','05') and to_date(t.applytime,'yyyy/MM/dd HH24 mi ss') > sysdate -30";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sql).setParameter("realname", realname).setParameter("certno", certno).setParameter("xfbankcode", xfbankcode).setParameter("bankcardno", bankcardno));
		
		if(rs.next()){
			returnStr = rs.getString("resultcode") + "@" + rs.getString("resultinfo") + "@" + rs.getString("success") + "@" + rs.getString("reqstatus") + "@" + rs.getString("applyno") + "@" + rs.getString("applytime");
			
			String count = Sqlca.getString(new SqlObject("select count(1) from CARDVALIDATE_INFO t where t.serialno = :serialno").setParameter("serialno", serialno));
			if(!"0".equals(count)){
//				sql = "update CARDVALIDATE_INFO t set t.remark = :applytime  where t.serialno = :serialno";//this is a promblom
//				Sqlca.executeSQL(new SqlObject(sql).setParameter("applytime", rs.getString("applytime")).setParameter("serialno", serialno));
			}else{
				sql = "insert into CARDVALIDATE_INFO (serialno,applycount) values(:serialno,0)";
				Sqlca.executeSQL(new SqlObject(sql).setParameter("serialno", serialno));
			}
			
		}
		
		
		return returnStr;
	}
	
	/**
	 * 哈行账号，不发送代扣平台，先插入数据到数据库
	 * @param Sqlca
	 * @return
	 * @throws Exception 
	 */
	public void insertCardvalidateInfo(Transaction Sqlca) throws Exception{
		
		String count = Sqlca.getString(new SqlObject("select count(1) from CARDVALIDATE_INFO t where t.serialno = :serialno").setParameter("serialno", serialno));
		if(!"0".equals(count)){
			
		}else{
			Sqlca.executeSQL(new SqlObject("insert into CARDVALIDATE_INFO (serialno,applycount) values(:serialno,0)").setParameter("serialno", serialno));
		}
		
	}
	/**
	 * 判断当天的校验次数
	 * @param Sqlca
	 * @return
	 * @throws SQLException 
	 */
	public String getCheckTimes(Transaction Sqlca) throws SQLException{
		String sql = "select t.applycount from CARDVALIDATE_INFO t where t.serialno = :serialno and to_char(t.lastdealdate, 'yyyy-MM-dd') = to_char(sysdate, 'yyyy-MM-dd')";
		SqlObject so = new SqlObject(sql);
		so.setParameter("serialno", serialno);
		String applycount = Sqlca.getString(so);
		if(applycount == null || "".equals(applycount)){
			applycount = "0";
		}
		return applycount;
	}

	/**
	 * 平台校验卡信息
	 * @return
	 * @throws Exception 
	 */
	@SuppressWarnings("deprecation")
	public String platfromValidate(String ouid) throws Exception{
		String user_pwd  = Configure.getInstance().getConfigure("id_check_user_pwd");
		String user_name = Configure.getInstance().getConfigure("id_check_user_name");
		String xmlData = getXML(ouid);
		
		ValidateAccount va = new ValidateAccount();
		ValidateAccountPortType vap = va.getValidateAccountHttpPort();
		
		String vaReturn = vap.validate(user_pwd, user_name, xmlData);
		
		return vaReturn;
	}
	/**
	 * 平台查询卡校验信息
	 * @return
	 * @throws Exception 
	 */
	@SuppressWarnings("deprecation")
	public String platformQuery(String ouid) throws Exception{
		String user_pwd  = Configure.getInstance().getConfigure("id_check_user_pwd");
		String user_name = Configure.getInstance().getConfigure("id_check_user_name");
		
		ValidateAccount va = new ValidateAccount();
		ValidateAccountPortType vap = va.getValidateAccountHttpPort();
		
		String queryReturn = vap.query(user_pwd, user_name, ouid);
		return queryReturn;
	}
	
	private String getXML(String ouid){
		
		StringBuffer sb = new StringBuffer();
		sb.append("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>"); 
		sb.append("<validate>"); 
		sb.append("<outid>"+ouid+"</outid>"); 
		sb.append("<realname>"+realname+"</realname>"); 
		sb.append("<certno>"+certno+"</certno>"); 
		sb.append("<bankcardtype>"+bankcardtype+"</bankcardtype>"); //1 银行卡类型
		sb.append("<bankcode>"+dkbankcode+"</bankcode>"); // 从对照表查询
		sb.append("<servicetype>"+servicetype+"</servicetype>"); //INSTALLMENT 服务类型
		sb.append("<bankcardno>"+bankcardno+"</bankcardno>");
		sb.append("<mobileno>"+mobileno+"</mobileno>");
		sb.append("<infotype>"+infotype+"</infotype>");//1 数据来源
		sb.append("<customerid>"+customerid+"</customerid>");
		sb.append("</validate>");

		return sb.toString();
		
	}
	/**
	 * 获取消费贷银行编码对应的代扣平台的银行编码
	 * @param Sqlca
	 * @return
	 * @throws SQLException
	 */
	public String getBankCodeDK(Transaction Sqlca) throws SQLException{
		String sql = "select t.bank_code_dk from bank_code_compare t where t.bank_code_xf = :bank_code_xf";
		SqlObject so = new SqlObject(sql);
		so.setParameter("bank_code_xf", xfbankcode);
		String bankCodeDK = Sqlca.getString(so);
		return bankCodeDK;
	}
	
	public String genarateOutid(String businessCode){
		return businessCode + DBKeyUtils.getTimeNo();
		
	}
	/**
	 * 调用validate后操作数据库 此处更新序列号可能有问题
	 * @param operatore ,
	 * @return
	 */
	public String operateCardvalidateInfo(int number){
		
		String sql1 = "select count(1) as count from CARDVALIDATE_INFO t where t.serialno = ?";
		String sql2 = "insert into CARDVALIDATE_INFO (serialno,applycount) values(?,?)";
		String sql3 = "update CARDVALIDATE_INFO t set t.applycount = decode(to_char(t.lastdealdate, 'yyyy-MM-dd'),to_char(sysdate, 'yyyy-MM-dd'),to_number(t.applycount) + ?,1)  where t.serialno = ?";
		
		Connection conn = null;
		PreparedStatement  ps1 = null,ps2 = null,ps3 = null;
		ResultSet rs = null;
		String ds = null;
		try {
			ds = Configure.getInstance().getDataSource();
			conn = ARE.getDBConnection(ds==null?"als":ds);
			conn.setAutoCommit(false);
		} catch (Exception e) {
			ARE.getLog().error("获得awe config中的datasource配置出错", e);
		}
		
		try {
			ps1 = conn.prepareStatement(sql1);
			ps1.setString(1, serialno);
			rs = ps1.executeQuery();
			if(rs.next()){
				int count = rs.getInt("count");
				if(count == 0){
					ps2 = conn.prepareStatement(sql2);
					ps2.setString(1, serialno);
					ps2.setString(2, ""+number);
					ps2.execute();
				}else{
					ps3 = conn.prepareStatement(sql3);
					ps3.setInt(1, number);
					ps3.setString(2, serialno);
					ps3.execute();
				}
			}
			conn.commit();
		} catch (Exception e) {
			ARE.getLog().fatal("调用代扣平台后更新数据库时报",e);
			//returnMsg = "false-"+e.getMessage();
		}finally{
			try {
				if(rs!=null) rs.close();
				if(ps1!=null) ps1.close();
				if(ps2!=null) ps2.close();
				if(ps3!=null) ps3.close();
				if(conn!=null) conn.close();
			} catch (SQLException e) {
				ARE.getLog().error("关闭数据库连接出错",e); 
				//returnMsg = "false-"+e.getMessage();
			  }
		}
		
		return null;
	}
	
	/**
	 * 页面点击确认变更后更新数据库
	 * @param Sqlca
	 * @return
	 * @throws Exception 
	 */
	public void operateCardQueryInfo(Transaction Sqlca) throws Exception{
//		String sql = "select t.bank_code_dk from bank_code_compare t where t.bank_code_xf = :bank_code_xf";
		String sql = "update CARDVALIDATE_INFO t set t.CUSTOMERID = :customerid ,t.REALNAME = :realname "
								+ ",t.CERTNO = :certno ,t.BANKCARDTYPE = :bankcardtype ,t.SERVICETYPE = :servicetype "
								+ ",t.BANKCARDNO = :bankcardno ,t.MOBILENO = :mobileno ,t.XFBANKCODE = :xfbankcode "
								+ ",t.DKBANKCODE = :dkbankcode ,t.SUCCESS = :success ,t.RESULTINFO = :resultinfo "
								+ ",t.RESULTCODE = :resultcode ,t.REQSTATUS = :reqstatus ,t.APPLYNO=:ouid ,t.applytime=:applytime"
								+ " where t.SERIALNO = :serialno";
		

		SqlObject so = new SqlObject(sql);
		so.setParameter("customerid", customerid);
		so.setParameter("realname", realname);
		so.setParameter("certno", certno);
		so.setParameter("bankcardtype", bankcardtype);
		so.setParameter("servicetype", servicetype);
		so.setParameter("bankcardno", bankcardno);
		so.setParameter("mobileno", mobileno);
		so.setParameter("xfbankcode", xfbankcode);
		so.setParameter("dkbankcode", dkbankcode);
		so.setParameter("success", success);
		so.setParameter("resultinfo", resultinfo);
		so.setParameter("resultcode", resultcode);
		so.setParameter("reqstatus", reqstatus);
		so.setParameter("ouid", ouid); 
		so.setParameter("applytime", applytime);
		
		so.setParameter("serialno", serialno); 
		Sqlca.executeSQL(so);
	}
	
	
	private String serialno;//合同号
	private String realname;//真实姓名
	private String certno;//身份证号
	private String bankcardtype;//银行卡类型
	private String xfbankcode;//银行编码
	private String dkbankcode;//代扣银行编码
	private String servicetype;//服务类型
	private String bankcardno;//银行卡号
	private String mobileno;//手机号码
	private String infotype;//数据来源
	private String customerid;//客户ID
	private String ouid;
	private String applytime;
	public String getRealname() {
		return realname;
	}
	public void setRealname(String realname) {
		this.realname = realname;
	}
	public String getCertno() {
		return certno;
	}
	public void setCertno(String certno) {
		this.certno = certno;
	}
	public String getBankcardtype() {
		return bankcardtype;
	}
	public void setBankcardtype(String bankcardtype) {
		this.bankcardtype = bankcardtype;
	}
	public String getXfbankcode() {
		return xfbankcode;
	}
	public void setXfbankcode(String xfbankcode) {
		this.xfbankcode = xfbankcode;
	}

	public String getServicetype() {
		return servicetype;
	}
	public void setServicetype(String servicetype) {
		this.servicetype = servicetype;
	}
	public String getBankcardno() {
		return bankcardno;
	}
	public void setBankcardno(String bankcardno) {
		this.bankcardno = bankcardno;
	}
	public String getMobileno() {
		return mobileno;
	}
	public void setMobileno(String mobileno) {
		this.mobileno = mobileno;
	}
	public String getInfotype() {
		return infotype;
	}
	public void setInfotype(String infotype) {
		this.infotype = infotype;
	}
	public String getCustomerid() {
		return customerid;
	}
	public void setCustomerid(String customerid) {
		this.customerid = customerid;
	}
	
	public String getSerialno() {
		return serialno;
	}
	public void setSerialno(String serialno) {
		this.serialno = serialno;
	}
	public String getDkbankcode() {
		return dkbankcode;
	}
	public void setDkbankcode(String dkbankcode) {
		this.dkbankcode = dkbankcode;
	}
	public String getOuid() {
		return ouid;
	}
	public void setOuid(String ouid) {
		this.ouid = ouid;
	}
	public String getApplytime() {
		return applytime;
	}
	public void setApplytime(String applytime) {
		this.applytime = applytime;
	}


	private String success;
	private String resultinfo;
	private String resultcode;
	private String reqstatus;
	public String getSuccess() {
		return success;
	}
	public void setSuccess(String success) {
		this.success = success;
	}
	public String getResultinfo() {
		return resultinfo;
	}
	public void setResultinfo(String resultinfo) {
		this.resultinfo = resultinfo;
	}
	public String getResultcode() {
		return resultcode;
	}
	public void setResultcode(String resultcode) {
		this.resultcode = resultcode;
	}
	public String getReqstatus() {
		return reqstatus;
	}
	public void setReqstatus(String reqstatus) {
		this.reqstatus = reqstatus;
	}
	/**
	 * 获取是否可以保存的标志 0 可以保存 1 不能保存
	 * @throws SQLException 
	 */
	public String getSaveFlag(Transaction Sqlca) throws SQLException{
		if(null == resultcode || "".equals(resultcode)){//传入的返回码为空，连接代扣平台失败
			return "1";
		}
		String sql = "select t.is_fault_tolerant from bank_card_check_info t where t.return_code=:resultcode";
		SqlObject so = new SqlObject(sql);
		so.setParameter("resultcode", resultcode);
		String flag = Sqlca.getString(so);
		//如果没有查询到数据，有可能是易极付那边新增了返回信息  容错返回1
		if(null == flag || "".equals(flag)){
			flag = "1";
		}
		return flag;
		//return BankCardCheckResult.getFlagByCode(resultcode);
	}
	

}
