package com.amarsoft.app.billions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class UpdateRetailRno {

	private String SerialNo = "";
	private String SerialNos = "";
	private String AllSerialNo = "";//是可以放在sql后面的【'a','b','c'】的格式
	private String PrimaryApproveStatus = "";
	private String Remark = "";
	private String PrimaryRefuseReason = "";
	private String PrimaryApproveTime = "";
	private String PrimaryApprovePerson = "";
	private String AgreementCode = "";
	private String AgreementApproveStatus ="";
	private String AgreementApproveTime = "";
	private String agreementapproveperson = ""; //门店协议审核人
	private String agreementapproveman = ""; //零售商协议审核人
	private String agreementapprovecode = ""; //协议审核代码
	
	public String getSerialNo() {
		return SerialNo;
	}
	public void setSerialNo(String serialNo) {
		SerialNo = serialNo;
	}
	public String getSerialNos() {
		return SerialNos;
	}
	public void setSerialNos(String serialNos) {
		SerialNos = serialNos;
	}
	public String getAllSerialNo() {
		return AllSerialNo;
	}
	public void setAllSerialNo(String allSerialNo) {
		AllSerialNo = allSerialNo;
	}
	public String getPrimaryApproveStatus() {
		return PrimaryApproveStatus;
	}
	public void setPrimaryApproveStatus(String primaryApproveStatus) {
		PrimaryApproveStatus = primaryApproveStatus;
	}
	public String getRemark() {
		return Remark;
	}
	public void setRemark(String remark) {
		Remark = remark;
	}
	public String getPrimaryRefuseReason() {
		return PrimaryRefuseReason;
	}
	public void setPrimaryRefuseReason(String primaryRefuseReason) {
		PrimaryRefuseReason = primaryRefuseReason;
	}
	public String getPrimaryApproveTime() {
		return PrimaryApproveTime;
	}
	public void setPrimaryApproveTime(String primaryApproveTime) {
		PrimaryApproveTime = primaryApproveTime;
	}
	public String getPrimaryApprovePerson() {
		return PrimaryApprovePerson;
	}
	public void setPrimaryApprovePerson(String primaryApprovePerson) {
		PrimaryApprovePerson = primaryApprovePerson;
	}
	public String getAgreementCode() {
		return AgreementCode;
	}
	public void setAgreementCode(String agreementCode) {
		AgreementCode = agreementCode;
	}
	public String getAgreementApproveStatus() {
		return AgreementApproveStatus;
	}
	public void setAgreementApproveStatus(String agreementApproveStatus) {
		AgreementApproveStatus = agreementApproveStatus;
	}
	public String getAgreementApproveTime() {
		return AgreementApproveTime;
	}
	public void setAgreementApproveTime(String agreementApproveTime) {
		AgreementApproveTime = agreementApproveTime;
	}
	public String AllSerialNoReplace(String AllSerialNo) {
		return AllSerialNo = "'"+AllSerialNo.replace("|", "','")+"'";
	}
	public String getAgreementapproveperson() {
		return agreementapproveperson;
	}
	public void setAgreementapproveperson(String agreementapproveperson) {
		this.agreementapproveperson = agreementapproveperson;
	}
	public String getAgreementapproveman() {
		return agreementapproveman;
	}
	public void setAgreementapproveman(String agreementapproveman) {
		this.agreementapproveman = agreementapproveman;
	}
	public String getAgreementapprovecode() {
		return agreementapprovecode;
	}
	public void setAgreementapprovecode(String agreementapprovecode) {
		this.agreementapprovecode = agreementapprovecode;
	}
	//商户新增后提交
	public void firstSubmitRetail(Transaction sqlca) throws SQLException, Exception{
		String sql = "update Retail_Info set Status='02',PrimaryApproveStatus='4',"
				+ "AgreementApproveStatus='4',SafDepApproveStatus='4' where serialNo = :serialNo";
		sqlca.executeSQL(new SqlObject(sql).setParameter("serialNo", SerialNo));
		sqlca.commit();
	}
	
	//门店新增后提交
	public void firstSubmitStore(Transaction sqlca) throws SQLException, Exception{
		String sql = "update Store_Info set Status='02',PrimaryApproveStatus='4',"
				+ "AgreementApproveStatus='4',SafDepApproveStatus='4' where serialNo = :serialNo";
		sqlca.executeSQL(new SqlObject(sql).setParameter("serialNo", SerialNo));
		sqlca.commit();
	}
	
	//门店初审提交
	public void PrimaryApproveStore(Transaction sqlca) throws SQLException, Exception{
		AllSerialNo = AllSerialNoReplace(AllSerialNo);
		String sql = "update Store_Info set PrimaryApproveStatus=:PrimaryApproveStatus,Remark=:Remark,"
				+ "PrimaryRefuseReason=:PrimaryRefuseReason,PrimaryApproveTime=:PrimaryApproveTime,"
				+ "PrimaryApprovePerson=:PrimaryApprovePerson where serialNo in ("+AllSerialNo+")";
		sqlca.executeSQL(new SqlObject(sql).setParameter("PrimaryApproveStatus", PrimaryApproveStatus)
				.setParameter("Remark", Remark)
				.setParameter("PrimaryRefuseReason", PrimaryRefuseReason)
				.setParameter("PrimaryApproveTime", PrimaryApproveTime)
				.setParameter("PrimaryApprovePerson", PrimaryApprovePerson));
		sqlca.commit();
	}
	
	/**
	 * 门店复审协议审核
	 * @Title AgreementApproveStore
	 * @Description 门店复审协议审核
	 * @return void
	 * @param sqlca
	 * @throws SQLException
	 * @throws Exception
	 */
	public void AgreementApproveStore(Transaction sqlca) throws SQLException, Exception{
		AllSerialNo = AllSerialNoReplace(AllSerialNo);
		
		/** add by tangyb 添加不通过二次协议审核需求 20151231 **/

		/* 修改成循环修改
		String sql = "update Store_Info set AgreementCode=:AgreementCode,"
				+ "AgreementApproveStatus=:AgreementApproveStatus,"
				+ "AgreementApproveTime=:AgreementApproveTime where serialNo in ("+AllSerialNo+")";
		sqlca.executeSQL(new SqlObject(sql).setParameter("AgreementCode", AgreementCode)
				.setParameter("AgreementApproveStatus", AgreementApproveStatus)
				.setParameter("AgreementApproveTime", AgreementApproveTime));
		*/
		
		String sql = "SELECT t.serialno, t.safdepapprovestatus FROM store_info t WHERE t.serialno IN ("+AllSerialNo+")";
		String usql = "update Store_Info set AgreementCode=:AgreementCode,AgreementApproveStatus=:AgreementApproveStatus,AgreementApproveTime=:AgreementApproveTime,"
				+ "status=:status,safdepapprovestatus=:safdepapprovestatus,agreementapproveperson=:agreementapproveperson where serialno=:serialno";
		
		String status = "02"; // 门店状态[01：新增；02：审核中；03：准入；04：拒绝；07：暂时关闭；05：激活；06：关闭]
		
		ASResultSet rs = sqlca.getASResultSet(new SqlObject(sql));
		while (rs.next()) {
			String serialno = rs.getString("serialno"); //门店序号
			String safdepapprovestatus = rs.getString("safdepapprovestatus"); //安全部审核状态
			if("1".equals(AgreementApproveStatus) && "2".equals(safdepapprovestatus)){
				safdepapprovestatus = "4"; //审核状态[1：通过；2：不通过；3：待处理；4：审核中]
			}
			sqlca.executeSQL(new SqlObject(usql).setParameter("AgreementCode", AgreementCode)
					.setParameter("AgreementApproveStatus", AgreementApproveStatus)
					.setParameter("AgreementApproveTime", AgreementApproveTime)
					.setParameter("status", status)
					.setParameter("safdepapprovestatus", safdepapprovestatus)
					.setParameter("agreementapproveperson", agreementapproveperson)
					.setParameter("serialno", serialno));
		}
		rs.getStatement().close();
		
		/** end **/
		sqlca.commit();
	}
	
	/**
	 * 更新零售商状态
	 * @Title selectRnoIsBuild
	 * @Description 更新零售商状态
	 * @return void
	 * @param sqlca
	 * @throws Exception
	 */
	public String selectRnoIsBuild(Transaction sqlca) throws Exception{
		String oldAllSerialNo = AllSerialNo;
		ARE.getLog().info("oldAllSerialNo============"+oldAllSerialNo);
		AllSerialNo = AllSerialNoReplace(AllSerialNo);
		ARE.getLog().info("AllSerialNo============"+AllSerialNo);
		//传入流水号控制查询记录范围AllSerialNo
		String selSql = " select serialNo,rno,city,status, "
				+ " primaryApproveStatus,agreementApproveStatus,safDepApproveStatus,regcode "
				+ " from retail_info where serialNo in ("+AllSerialNo+")";
		String updateSql = "update Retail_info set rno=:rno,status='05' where serialNo=:serialNo";
		String updateSql2 = "update Retail_info set status='04' where serialNo=:serialNo";
		Connection conn = null;
		Statement st = null;
		ResultSet rs=null;
		PreparedStatement ps = null;
		PreparedStatement ps2 = null;
		String serialNo = "",rno = "",city = "",status = "",new_rno = "",regcode = "",relativeNo = "",
				primaryApproveStatus = "",agreementApproveStatus = "",safDepApproveStatus = "";
		try{
			//一律用原始的jdbc
			conn = sqlca.getConnection();
			st = conn.createStatement();
			ps = conn.prepareStatement(updateSql);
			ps2 = conn.prepareStatement(updateSql2);
			rs = st.executeQuery(selSql);
			while(rs.next()){
				serialNo = rs.getString("serialNo");
				rno = rs.getString("rno");
				city = rs.getString("city");
				status = rs.getString("status");
				primaryApproveStatus = rs.getString("primaryApproveStatus");
				agreementApproveStatus = rs.getString("agreementApproveStatus");
				safDepApproveStatus = rs.getString("safDepApproveStatus");
				regcode = rs.getString("regcode");
				String sql = "select rno from Retail_info r where r.regcode='"+regcode+"' and r.company='BQJR' ";
				ASResultSet rs1 = sqlca.getASResultSet(new SqlObject(sql));
				if(rs1.next()){
					relativeNo = rs1.getString("rno");
					if(relativeNo == null ) relativeNo = "";
				}
				//三个审核都通过，且是02审核中
				if("1".equals(primaryApproveStatus) && "1".equals(agreementApproveStatus) 
						&& "1".equals(safDepApproveStatus) && "02".equals(status) 
							&& (rno==null || "".equals(rno.trim()))){
					GenerateSerialNo gs = new GenerateSerialNo ();
					gs.setCityCode(city);
					new_rno=gs.getRetailNo(sqlca);
					ps.setString(1, new_rno);
					if(relativeNo.length()==0) relativeNo = new_rno;
					ps.setString(2, serialNo);
					int i = ps.executeUpdate();
					sqlca.executeSQL(new SqlObject("update Retail_info i set i.relative_rno=:relativeNo where i.regcode=:regcode").
							setParameter("relativeNo", relativeNo).setParameter("regcode", regcode));
					ARE.getLog().info("商户serialNo【"+serialNo+"】【激活】更新结果:"+i);
					conn.commit();
					UpdateStoreInfoNetBankInfo(oldAllSerialNo,conn);
					//三个审核最少一个不通过，且是02审核中
				}else if(("2".equals(primaryApproveStatus) || "2".equals(agreementApproveStatus) 
						|| "2".equals(safDepApproveStatus)) && "02".equals(status)){
					ps2.setString(1, serialNo);
					int i = ps2.executeUpdate();
					ARE.getLog().info("商户serialNo【"+serialNo+"】【拒绝】更新结果:"+i);
					conn.commit();
				}else{
					continue;
				}
			}
		}catch(Exception e){
			e.printStackTrace();
			conn.rollback();
			return "F";
		}finally{
			if(ps != null){
				ps.close();
				ps = null;
			}
			if(ps2 != null){
				ps2.close();
				ps2 = null;
			}
			if(rs != null){
				rs.close();
				rs = null;
			}
			if(conn != null){
				conn.close();
				conn = null;
			}
		}
		return "S";
	}
	
	/**
	 * 复审协议审核
	 * @Title agreementApproveRetail
	 * @Description 复审协议审核 
	 * @author tangyb 20151231
	 * @param sqlca
	 * @throws Exception
	 */
	public void agreementApproveRetail(Transaction sqlca) throws Exception {
		AllSerialNo = AllSerialNoReplace(AllSerialNo);

		String sql = "SELECT t.serialno, t.safdepapprovestatus FROM retail_info t WHERE t.serialno IN (" + AllSerialNo + ")";
		String usql = "update retail_info set agreementapprovestatus=:agreementapprovestatus, agreementapprovetime=:agreementapprovetime, "
				+ "agreementapprovecode=:agreementapprovecode, agreementapproveman=:agreementapproveman, "
				+ "status=:status, safdepapprovestatus=:safdepapprovestatus where serialno=:serialno";
		
		String status = "02"; // 门店状态[01：新增；02：审核中；03：准入；04：拒绝；07：暂时关闭；05：激活；06：关闭]

		ASResultSet rs = sqlca.getASResultSet(new SqlObject(sql));
		while (rs.next()) {
			String serialno = rs.getString("serialno"); // 门店序号
			String safdepapprovestatus = rs.getString("safdepapprovestatus"); // 安全部审核状态
			
			// 协议审核同意，安全审核不同意（不通过状态数据）
			if ("1".equals(AgreementApproveStatus) && "2".equals(safdepapprovestatus)) {
				safdepapprovestatus = "4"; // 审核状态[1：通过；2：不通过；3：待处理；4：审核中]
			}
			
			sqlca.executeSQL(new SqlObject(usql)
					.setParameter("agreementapprovestatus", AgreementApproveStatus)
					.setParameter("agreementapprovetime", AgreementApproveTime)
					.setParameter("agreementapprovecode", agreementapprovecode)
					.setParameter("agreementapproveman", agreementapproveman)
					.setParameter("status", status)
					.setParameter("safdepapprovestatus", safdepapprovestatus)
					.setParameter("serialno", serialno));
		}
		rs.getStatement().close();

		sqlca.commit();
	}
	
	/**
	 * 更新门店状态
	 * @Title selectSnoIsBuild
	 * @Description TODO
	 * @return void
	 * @param sqlca
	 * @throws Exception
	 */
	public String selectSnoIsBuild(Transaction sqlca) throws Exception{
		AllSerialNo = AllSerialNoReplace(AllSerialNo);
		//传入流水号控制查询记录范围AllSerialNo
		String selSql = " select serialNo,sno,city,status, "
				+ " primaryApproveStatus,agreementApproveStatus,safDepApproveStatus "
				+ " from Store_info where serialNo in ("+AllSerialNo+")";
		String updateSql = "update Store_info set sno=:sno,relative_sno=:relativeNo,status='03' where serialNo=:serialNo";
		String updateSql2 = "update Store_info set status='04' where serialNo=:serialNo";
		Connection conn = null;
		Statement st = null;
		ResultSet rs=null;
		PreparedStatement ps = null;
		PreparedStatement ps2 = null;
		String serialNo = "",sno = "",city = "",status = "",new_sno = "",
				primaryApproveStatus = "",agreementApproveStatus = "",safDepApproveStatus = "";
		try{
			//一律用原始的jdbc
			conn = sqlca.getConnection();
			st = conn.createStatement();
			ps = conn.prepareStatement(updateSql);
			ps2 = conn.prepareStatement(updateSql2);
			rs = st.executeQuery(selSql);
			while(rs.next()){
				serialNo = rs.getString("serialNo");
				sno = rs.getString("sno");
				city = rs.getString("city");
				status = rs.getString("status");
				primaryApproveStatus = rs.getString("primaryApproveStatus");
				agreementApproveStatus = rs.getString("agreementApproveStatus");
				safDepApproveStatus = rs.getString("safDepApproveStatus");
				//三个审核都通过，且是02审核中
				if("1".equals(primaryApproveStatus) && "1".equals(agreementApproveStatus) 
						&& "1".equals(safDepApproveStatus) && "02".equals(status) 
							&& (sno==null || "".equals(sno.trim()))){
					GenerateSerialNo gs = new GenerateSerialNo ();
					gs.setCityCode(city);
					new_sno=gs.getStoreNo(sqlca);
					ps.setString(1, new_sno);
					ps.setString(2, new_sno);//由于门店无法判断关联号，所以门店关联号用本身数据。
					ps.setString(3, serialNo);
					int i = ps.executeUpdate();
					ARE.getLog().info("门店serialNo【"+serialNo+"】【准入】更新结果:"+i);
					conn.commit();
					//三个审核最少一个不通过，且是02审核中
				}else if(("2".equals(primaryApproveStatus) || "2".equals(agreementApproveStatus) 
						|| "2".equals(safDepApproveStatus)) && "02".equals(status)){
					ps2.setString(1, serialNo);
					int i = ps2.executeUpdate();
					ARE.getLog().info("门店serialNo【"+serialNo+"】【拒绝】更新结果:"+i);
					conn.commit();
				}else{
					continue;
				}
			}
		}catch(Exception e){
			e.printStackTrace();
			conn.rollback();
			return "F";
		}finally{
			if(ps != null){
				ps.close();
				ps = null;
			}
			if(ps2 != null){
				ps2.close();
				ps2 = null;
			}
			if(rs != null){
				rs.close();
				rs = null;
			}
			if(conn != null){
				conn.close();
				conn = null;
			}
		}
		return "S";
	}
	
	//同步商户网银信息到商户下门店
	public void UpdateStoreInfoNetBankInfo(String oldAllSerialNo,Connection conn) throws SQLException{
		PreparedStatement ps = null;
		String sql = " update store_info a set "
				+ " (a.ACCOUNT,a.ACCOUNTNAME,a.ACCOUNTBANK,a.ACCOUNTBANKCITY,a.BranchCode)= "
				+ " (select b.Account,b.AccountName,b.AccountBank,b.AccountbankCity,b.BranchCode from retail_info b where b.serialno=?) "  
				+ " where a.isnetbank='1' and a.rserialno =? ";
		ps = conn.prepareStatement(sql);
		//System.out.println("oldAllSerialNo==========================="+oldAllSerialNo);
		String[] sArray = oldAllSerialNo.split("\\|");
		int iBatch = 0;
		for(int i=0;i<sArray.length;i++){
			//System.out.println("sArray[i]==========================="+sArray[i]);
			ps.setString(1, sArray[i]);
			ps.setString(2, sArray[i]);
			ps.addBatch();
			iBatch++;
			if(iBatch > 5000){
				ps.executeBatch();
				conn.commit();
			}
		}
		if(iBatch>0){
			ps.executeBatch();
			conn.commit();
		}
		if(ps != null){
			ps.close();
			ps = null;
		}
	}
}
