package com.amarsoft.app.billions;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import  com.amarsoft.app.billions.UpdateMinanUtilXML;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.ARE;
import com.amarsoft.app.als.process.util.ConfigProvider;

/**
 * 
 * @author qulianmao
 *
 */
public class UpdateMinanSerialNo {
	
	public static final String INIT_CUSTOMERID = "10000000";

	private String serialNo;//合同号
	
	private String policyno;//保单号
	
	private String updateBy;//更新人
	
	private String r_type;//更新人
	
	public static final String DEFAULT_PROCESSENGINE_CONFIG_FILE = ARE.getProperty("APP_HOME")+"/etc/InsuranceInfo.properties";

	public String getR_type() {
		return r_type;
	}
	public void setR_type(String r_type) {
		this.r_type = r_type;
	}
	public String getUpdateBy() {
		return updateBy;
	}
	public void setUpdateBy(String updateBy) {
		this.updateBy = updateBy;
	}
	public String getPolicyno() {
		return policyno;
	}
	public void setPolicyno(String policyno) {
		this.policyno = policyno;
	}
	public String getSerialNo() {
		return serialNo;
	}
	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	/**
	 * 查询是否可以退保
	 * @param sqlca
	 * @return
	 * @throws Exception
	 */
	public String selctMinanSerialNo(Transaction sqlca) throws Exception {
		
		if (serialNo == null) {
			throw new RuntimeException("请传入合同号！");
		}
		System.out.println("查询是否可以退保");
		String status = sqlca.getString(new SqlObject("select status from batch_insurance_info t  WHERE  t.contract_no=:serialNo and status in ('2','8')").setParameter("serialNo", serialNo));
		if(status ==null||"".equals(status)){
			status = sqlca.getString(new SqlObject("select status from BATCH_MINGAN_INSURANCE    WHERE  serialno=:serialNo and status='1'").setParameter("serialNo", serialNo));
			if(status ==null||"".equals(status)){
				return "F";
			}
		}
		// 提前还款中
		status = sqlca.getString(new SqlObject("  select count(1) from acct_loan al, acct_trans_payment atp, acct_transaction at   where al.serialno = at.relativeobjectno"+
				"   and at.relativeobjecttype = 'jbo.app.ACCT_LOAN'"+
				"   and at.documentserialno = atp.serialno"+
				"   and at.documenttype = 'jbo.app.ACCT_TRANS_PAYMENT'"+
				"   and at.transcode = '0055'"+
				"   and atp.PrePayType is not null  and at.transstatus <>'4' "+
				"   and al.putoutno=:serialNo ").setParameter("serialNo", serialNo));
		if(!"0".equals(status)){
			return "F1";
		}
		/**
		 * 申请退货中的合同 不能退保
		 */
		status = sqlca.getString(new SqlObject("select count(1) coun from  REFUND_CARGO rc where rc.serialno=:serialNo").setParameter("serialNo", serialNo));
		if(!"0".equals(status)){
			return "F2";
		}
		/**
		 *   逾期超过90天并且系统已经汇总费用的合同
		 */
		status = sqlca.getString(new SqlObject("select count(1) from business_contract bc where bc.iscancelinstalments is not null and bc.serialno=:serialNo").setParameter("serialNo", serialNo));
		if(!"0".equals(status)){
			return "F3";
		}
		/**
		 *  已经结清的合同 
		 */
		status = sqlca.getString(new SqlObject(" select count(1) from business_contract con where con.contractstatus ='110'  and con.serialno=:serialNo").setParameter("serialNo", serialNo));
		if(!"0".equals(status)){
			return "F4";
		}
		/**
		 *  一个合同号对应多个保单，某个保单已经退保
		 */
		status = sqlca.getString(new SqlObject(" select count(1) from batch_insurance_info t  WHERE  t.contract_no=:serialNo and t.status='7'").setParameter("serialNo", serialNo));
		if(!"0".equals(status)){
			status = sqlca.getString(new SqlObject("select count(1) from BATCH_MINGAN_INSURANCE    WHERE  serialno=:serialNo and status='4'").setParameter("serialNo", serialNo));
			if(!"0".equals(status)){
				return "F5";
			}
		}
		
		return "S";
	}
	/**
	 * 更新民安保险状态(申请状态)
	 * @param sqlca
	 * @return
	 * @throws Exception
	 */
	public String updateMinanSerialNo(Transaction sqlca) throws Exception {
		
		if (serialNo == null) {
			throw new RuntimeException("请传入合同号！");
		}
		if(null == r_type){
			throw new RuntimeException("请传入合同号！");
		}
		if("1".equals(r_type)){
			sqlca.executeSQL(new SqlObject("update batch_insurance_info t  set t.status='4',t.applycan_date=to_date('"+getNewTimeStr()+"','yyyy/mm/dd'),t.updateby='"+updateBy+"',t.APPLYCANBY='"+updateBy+"' ,t.updatedate=to_date('"+getNewTimeStr()+"','yyyy/mm/dd') WHERE  t.contract_no=:serialNo and t.createdate = (select max(k.createdate) from batch_insurance_info k where k.contract_no = :serialNo)").setParameter("serialNo", serialNo));
			System.out.println("退保申请更新状态成功");
		}else{
			sqlca.executeSQL(new SqlObject("update BATCH_MINGAN_INSURANCE   set APPLYCANDATE='"+getNewTimeStr()+"',UPDATEBY='"+updateBy+"' ,cancellationBy='"+updateBy+"' WHERE  serialno=:serialNo").setParameter("serialNo", serialNo));
			System.out.println("退保申请更新状态成功");
		}
		
		return "S";
	}
	/**
	 * 更新民安保险状态（取消退保状态）
	 * @param sqlca
	 * @return
	 * @throws Exception
	 */
	public String updateMinanSerialN1(Transaction sqlca) throws Exception {
		
		if (policyno == null) {
			throw new RuntimeException("数据出错！");
		}
		String reStr="F";
		try {
			String[] pNos=	policyno.split("@");
			for (int i = 0; i < pNos.length; i++) {
				String pNo=pNos[i];
				String sSql = "";
				ASResultSet rs = null;
				
				String cont = sqlca.getString(new SqlObject("select count(1) as status from batch_insurance_info t  WHERE  t.policy_no=:policyno and status in('4','8')").setParameter("policyno", pNo));
				if(!"1".equals(cont)){
					return "保单号【"+pNo+"】，不能取消退保！";
				}
				sSql = "select mi.contract_no as serialno,mi.policy_no as policyno,"
						+ " mi.identity_id as certid,mi.customer_name as customername,mi.status as status,"
						+ " case when (trunc(sysdate) <= (trunc(to_date(SUBSTR(ta.putoutdate,0,10),'yyyy/MM/DD')) + 14)) AND  (trunc(sysdate) >= (trunc(to_date(SUBSTR(ta.putoutdate,0,10),'yyyy/MM/DD')))) then  'Y'  else  'N' END AS appStatus"
						+ " from batch_insurance_info mi, business_contract ta "
						+ "where  TA.serialno=mi.contract_no and mi.policy_no =:policyno";
				//根据保单号获取保单信息
				rs= sqlca.getASResultSet(new SqlObject(sSql).setParameter("policyno", pNo));
				if(rs.next()){
				String status =DataConvert.toString(rs.getString("status"));
					if(status != null&&("4".equals(status)||"8".equals(status))){
						if(pNo != null){//更新为投保状态
							sqlca.executeSQL(new SqlObject("update batch_insurance_info t   set t.status='2',t.updatedate= to_date('"+getNewTimeStr()+"','yyyy/mm/dd'),t.updateby='"+updateBy+"',t.commitBY='"+updateBy+"' WHERE  t.policy_no='"+pNo+"'"));	
							reStr="S";
						}
					}
				}
			}
			System.out.println("设置投保状态成功");
			
		} catch (Exception e) {
//			throw e;
		}
		return reStr;
	}
	/**
	 * 连接民安接口  发送数据给民安，民安实时返回退保信息
	 * 
	 */
	@SuppressWarnings("rawtypes")
	public String httpPostPolicyno(Transaction sqlca) throws Exception {
		
		
		if (policyno == null) {
			throw new RuntimeException("数据出错！");
		}
		String[] pNos=	policyno.split("@");
		for (int i = 0; i < pNos.length; i++) {
			String pNo=pNos[i];
			sqlca.executeSQL(new SqlObject("update batch_insurance_info t set t.status='5',t.issend='N',t.COMMIT_DATE=to_date('"+getNewTimeStr()+"','yyyy/mm/dd'),t.updateby='"+updateBy+"',t.commitBY='"+updateBy+"' ,t.updatedate=to_date('"+getNewTimeStr()+"','yyyy/mm/dd') WHERE  t.policy_no='"+pNo+"'"));
		}
		System.out.println("审批退保更新状态成功");
		
		return "S";
	}
	
	private String getNewTimeStr(){
		
		String str =new SimpleDateFormat("yyyy/MM/dd").format(new Date());
		return str;
	}	
	
	private  Map getHttpMinAnUrl() throws Exception{
		
		Properties property = new Properties();
    	ConfigProvider cp = ConfigProvider.getProvider(DEFAULT_PROCESSENGINE_CONFIG_FILE);
		String url = cp.getProperty("url");
		String userCode = cp.getProperty("userCode");
		String password = cp.getProperty("password");
		String businessCode = cp.getProperty("businessCode2");
		String riskPlanCode = cp.getProperty("riskPlanCode");
		String param="";
		Map map = new HashMap();
		param="userCode="+userCode+"&password="+password+"&businessCode="+businessCode+"&riskPlanCode="+riskPlanCode+"&";
		map.put("httpminanurl", url);
		map.put("param", param);
		return map;
		
	}
	
	/**
	 * 连接民安接口  发送数据给民安，民安实时返回退保信息
	 * 
	 */
	@SuppressWarnings("rawtypes")
	public String httpPostPolicynoRealTime(Transaction sqlca) throws Exception {
		
		String restr1="";
		String restr2="";
		String restr3="";
		
		if (policyno == null) {
			throw new RuntimeException("保单号为空！");
		}
		 Map  httpmap  =  new HashMap();
		 httpmap=getHttpMinAnUrl();
		 String httpminanurl=(String)httpmap.get("httpminanurl");
		 String param= (String)httpmap.get("param");
		if(httpmap==null||"".equals(httpminanurl) || "".equals(param)){
			throw new RuntimeException("民安接口为空，联请系IT！");
		}
		String[] pNos=	policyno.split("@");
			for (int i = 0; i < pNos.length; i++) {
				String pNo=pNos[i];
				if(pNo ==null ||"".equals(pNo)){
					continue;
				}
				
				//定义变量
				String sSql = "";
				ASResultSet rs = null;
				ASResultSet rs1 = null;
				try {
					sSql = "select mi.serialno as serialno,mi.policyno as policyno,mi.changepremium as changepremium,"
							+ " mi.certid as certid,mi.customername as customername,mi.status as status,"
							+ " case when (trunc(sysdate) <= (trunc(to_date(SUBSTR(ta.putoutdate,0,10),'yyyy/MM/DD')) + 14)) AND  (trunc(sysdate) >= (trunc(to_date(SUBSTR(ta.putoutdate,0,10),'yyyy/MM/DD')))) then  'Y'  else  'N' END AS appStatus"
							+ " from batch_mingan_insurance mi, business_contract ta "
							+ "where  TA.serialno=mi.serialno and mi.policyno =:policyno";
					//根据保单号获取保单信息
					rs= sqlca.getASResultSet(new SqlObject(sSql).setParameter("policyno", pNo));
					if(rs.next()){
						BatchMingAninsuranceVo  vo = new BatchMingAninsuranceVo();
						vo.setPolicyNo(DataConvert.toString(rs.getString("POLICYNO")));
						vo.setContractNo(DataConvert.toString(rs.getString("SERIALNO")));
						vo.setCertid(DataConvert.toString(rs.getString("CERTID")));
						vo.setCustomerName(DataConvert.toString(rs.getString("CUSTOMERNAME")));
						vo.setStatus(DataConvert.toString(rs.getString("status")));
						vo.setAppStatus(DataConvert.toString(rs.getString("appStatus")));
						String pm =DataConvert.toString(rs.getString("changepremium"));
						if(pm==null || "".equals(pm)){
							pm="0";
						}
						vo.setChangePremium(new BigDecimal(pm));
						if("1".equals(vo.getStatus())||"5".equals(vo.getStatus())){ //退保失败可以继续申请update by huanghui 20151231 PRM-728 取消退保审批和临时代扣审批的功能
							//拼装数据xml 
							// 拼装数据
							String xml="xmlData="+UpdateMinanUtilXML.httpPostTuiBao(vo);
							ARE.getLog().info("调用退保接口开始xml:"+xml);
							Map  map  =  new HashMap();
							map=BatchMingHttpRequest.sendPost(httpminanurl, param+xml);// 调用post 方法
							ARE.getLog().info("调用退保接口结束返回值:"+map);
							String retrInfo=(String)map.get("retResult");//0000代表成功
							String info = (String)map.get("retrInfo");
							if("0000".equals(retrInfo)||"该保单已退保，请不要重复操作".equals(info)){
								if("".equals(restr1)){
									restr1=vo.getContractNo();
								}else{
									restr1=restr1+","+vo.getContractNo();
								}
								vo.setStatus("4");
								if(map.get("changepremium") != null&&!"".equals(map.get("changepremium") )){
									vo.setChangePremium(new BigDecimal((String)map.get("changepremium")));//退保费
								}
								// 判断是否为犹豫期
								String addSQL= " AND 1=1";
								if("N".equals(vo.getAppStatus())){
									addSQL=" and TO_CHAR(ADD_MONTHS(SYSDATE,1),'YYYY/MM/DD') <= APS.PAYDATE ";
								}
								// 国金建议的还款计划日志 
								sqlca.executeSQL(new SqlObject("insert into ACCT_minan_SCHEDULE_his" 
										+"  (SERIALNO," 
										+"   OBJECTNO," 
										+"   SEQID," 
										+"   PAYDATE," 
										+"   PAYTYPE," 
										+"   INTEDATE," 
										+"   PAYPRINCIPALAMT," 
										+"   PAYINTEAMT," 
										+"   PRINCIPALBALANCE," 
										+"   ACTUALPAYPRINCIPALAMT," 
										+"   ACTUALPAYINTEAMT," 
										+"   FINISHDATE," 
										+"   REMARK," 
										+"   PAYFINEAMT," 
										+"   ACTUALPAYFINEAMT," 
										+"   PAYCOMPDINTEAMT," 
										+"   ACTUALPAYCOMPDINTEAMT," 
										+"   OBJECTTYPE," 
										+"   AUTOPAYFLAG," 
										+"   SETTLEDATE," 
										+"   HOLIDAYINTEDATE," 
										+"   GRACEINTEDATE," 
										+"   WAIVECOMPDINTEAMT," 
										+"   WAIVEFINEAMT," 
										+"   WAIVEINTEAMT," 
										+"   WAIVEPRINCIPALAMT," 
										+"   FIXPRINCIPALAMT," 
										+"   FIXINSTALLMENTAMT," 
										+"   RELATIVEOBJECTTYPE," 
										+"   RELATIVEOBJECTNO," 
										+"   SEQIDTRANSFER,    " 
										+"   PAYINTEAMTTRANSFER)" 
										+"  select aps.SERIALNO," 
										+"         aps.OBJECTNO," 
										+"         aps.SEQID," 
										+"         aps.PAYDATE," 
										+"         aps.PAYTYPE," 
										+"         aps.INTEDATE," 
										+"         aps.PAYPRINCIPALAMT," 
										+"         aps.PAYINTEAMT," 
										+"         aps.PRINCIPALBALANCE," 
										+"         aps.ACTUALPAYPRINCIPALAMT," 
										+"         aps.ACTUALPAYINTEAMT," 
										+"         aps.FINISHDATE," 
										+"         aps.REMARK," 
										+"         aps.PAYFINEAMT," 
										+"         aps.ACTUALPAYFINEAMT," 
										+"         aps.PAYCOMPDINTEAMT," 
										+"         aps.ACTUALPAYCOMPDINTEAMT," 
										+"         aps.OBJECTTYPE," 
										+"         aps.AUTOPAYFLAG," 
										+"         aps.SETTLEDATE," 
										+"         aps.HOLIDAYINTEDATE," 
										+"         aps.GRACEINTEDATE," 
										+"         aps.WAIVECOMPDINTEAMT," 
										+"         aps.WAIVEFINEAMT," 
										+"         aps.WAIVEINTEAMT," 
										+"         aps.WAIVEPRINCIPALAMT," 
										+"         aps.FIXPRINCIPALAMT," 
										+"         aps.FIXINSTALLMENTAMT," 
										+"         aps.RELATIVEOBJECTTYPE," 
										+"         aps.RELATIVEOBJECTNO," 
										+"         aps.SEQIDTRANSFER," 
										+"         aps.PAYINTEAMTTRANSFER" 
										+"    FROM acct_payment_schedule APS, acct_loan AL" 
										+"   WHERE aps.paytype = 'A12'" 
										+"     AND al.serialno = aps.relativeobjectno" 
										+"     and aps.relativeobjecttype = 'jbo.app.ACCT_LOAN'" 
										+"     and al.putoutno =:serialNo                " 
										+addSQL).setParameter("serialNo", vo.getContractNo()));
								
								StringBuilder query1 = new StringBuilder();
								StringBuilder inCondition = new StringBuilder();
								
								// 查询出还款计划表需要更新的数据的主键
								query1.append("select aps.serialno from acct_payment_schedule aps,acct_loan al ")
										.append("where al.serialno = aps.relativeobjectno and al.putoutno='")
										.append(vo.getContractNo())
										.append("' and aps.relativeobjecttype='jbo.app.ACCT_LOAN' and aps.paytype = 'A12' ")
										.append(addSQL);
								rs1= sqlca.getASResultSet(new SqlObject(query1.toString()));
								while (rs1.next()) {
									inCondition.append("'").append(DataConvert.toString(rs1.getString("serialno"))).append("',");
								}
								
								// 根据主键更新增值费（还款计划表）
								String inConditonStr = inCondition.toString();
								if (inConditonStr != null && inConditonStr.length() > 0) {
									inConditonStr = inConditonStr.substring(0, inConditonStr.length() - 1);
								
									// 更新增值费（还款计划表）
									sqlca.executeSQL(new SqlObject(" update acct_payment_schedule aps "+
											" set APS.payprincipalamt = '0' ,aps.finishdate='"+getNewTimeStr()+"',aps.settledate='"+getNewTimeStr()+"'"+
											" where aps.serialno in (" + inConditonStr + ")"));
								}
									
								/**
								 * 更新民安保险退保合同状态,应退保费
								 */
								sqlca.executeSQL(new SqlObject("update BATCH_MINGAN_INSURANCE   set status='4',FAIL='"+info+"',cancellationdate='"+getNewTimeStr()+"' ,changepremium='"+vo.getChangePremium()+"' ,UPDATEDATE= '"+getNewTimeStr()+"',UPDATEBY='"+updateBy+"' WHERE  Policyno=:policyno").setParameter("policyno", vo.getPolicyNo()));	
								
							}else{
								/**
								 * 更新失败原因
								 */
								if("".equals(restr2)){
									restr2=vo.getContractNo();
								}else{
									restr2=restr2+","+vo.getContractNo();
								}
								//update by huanghui CCS-1185	PRM-728 取消退保审批和临时代扣审批的功能。退保失败可以继续申请 1申请成功2申请失败3申请退保4退保成功5退保失败
								String status="5";
								sqlca.executeSQL(new SqlObject("update BATCH_MINGAN_INSURANCE   set status='"+status+"',FAIL='"+info+"'  ,UPDATEDATE='"+getNewTimeStr()+"' ,UPDATEBY='"+updateBy+"' WHERE  policyno= :policyno").setParameter("policyno", vo.getPolicyNo()));
							}
						}else{
							if("".equals(restr3)){
								restr3=vo.getContractNo();
							}else{
								restr3=restr3+","+vo.getContractNo();
							}
						}
					}
					
				} catch (Exception e) { 
					e.printStackTrace(); 
					throw new RuntimeException("申请退保数据失败");
				} finally {
					rs.getStatement().close();
					if (rs1 != null) {
						rs1.getStatement().close();
					}
				}
			}
			
		if(!"".equals(restr1)){
			restr1=restr1+"退保成功 \n";
		}
		if(!"".equals(restr2)){
			restr2=restr2+"退保失败 \n";
		}
		if(!"".equals(restr3)){
			restr3=restr3+"不能申请退保 \n";
		}
		return restr1+restr2+restr3;
	}
	
	/**
	 * 更新民安保险状态（取消退保状态）
	 * @param sqlca
	 * @return
	 * @throws Exception
	 */
	public String updateMinanSerialN1RealTime(Transaction sqlca) throws Exception {
		
		if (policyno == null) {
			throw new RuntimeException("数据出错！");
		}
		String reStr="F";
		try {
			String[] pNos=	policyno.split("@");
			for (int i = 0; i < pNos.length; i++) {
				String pNo=pNos[i];
				String sSql = "";
				ASResultSet rs = null;
				
				String cont = sqlca.getString(new SqlObject("select count(1) as status from BATCH_MINGAN_INSURANCE    WHERE  policyno=:policyno and status in('3','5')").setParameter("policyno", pNo));
				if(!"1".equals(cont)){
					return "保单号【"+pNo+"】，不能取消退保！";
				}
				sSql = "select mi.serialno as serialno,mi.policyno as policyno,"
						+ " mi.certid as certid,mi.customername as customername,mi.status as status,"
						+ " case when (trunc(sysdate) <= (trunc(to_date(SUBSTR(ta.putoutdate,0,10),'yyyy/MM/DD')) + 14)) AND  (trunc(sysdate) >= (trunc(to_date(SUBSTR(ta.putoutdate,0,10),'yyyy/MM/DD')))) then  'Y'  else  'N' END AS appStatus"
						+ " from batch_mingan_insurance mi, business_contract ta "
						+ "where  TA.serialno=mi.serialno and policyno =:policyno";
				//根据保单号获取保单信息
				rs= sqlca.getASResultSet(new SqlObject(sSql).setParameter("policyno", pNo));
				if(rs.next()){
				String status =DataConvert.toString(rs.getString("status"));
					if(status != null&&("3".equals(status)||"5".equals(status))){
						if(pNo != null){//更新为投保状态
							sqlca.executeSQL(new SqlObject("update BATCH_MINGAN_INSURANCE   set status='1',UPDATEDATE= '"+getNewTimeStr()+"',UPDATEBY='"+updateBy+"' WHERE  Policyno='"+pNo+"'"));	
							reStr="S";
						}
					}
				}
			}
			System.out.println("设置投保状态成功");
			
		} catch (Exception e) {
//			throw e;
		}
		return reStr;
	}
	
//public String getReturnApplyChannel(Transaction sqlca) throws Exception {
//		
//		if (serialNo == null) {
//			throw new RuntimeException("请传入合同号！");
//		}
//		System.out.println("查询退保渠道");
//		String status = sqlca.getString(new SqlObject("select status from batch_insurance_info t  WHERE  t.contract_no=:serialNo and status in ('2','8')").setParameter("serialNo", serialNo));
//		if(status ==null||"".equals(status)){
//			return "01";
//		}else{
//			return "02";
//		}
//	}
}
