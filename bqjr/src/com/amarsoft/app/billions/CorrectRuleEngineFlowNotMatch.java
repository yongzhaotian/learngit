package com.amarsoft.app.billions;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.Arrays;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpMethod;
import org.apache.commons.httpclient.methods.GetMethod;

import com.amarsoft.are.ARE;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.cache.CodeCache;

	/*
		Author:  
		Tester:
		Content: 
		Input Param:
		Output param:
		History Log: xswang 2015/05/25 CCS-808 系统全流程电子化改造：文件质量检查
	*/

public class CorrectRuleEngineFlowNotMatch {
	
	/** phaseNOFlag -- 是否更新PHASENO标识，0-不需要；1-需要 **/
	private String phaseNOFlag;
	
	/**
	 * 提交申请时， 判断如果因为重复调用了规则引擎，则
	 * 以最后一次调用的规则引擎为准
	 * @param Sqlca
	 * @return Success 表示只调用了一次， Failure表示多次调用
	 */
	public String correctFlowNotMatch(Transaction Sqlca) {
		
		try {
			
			//String sActionSctrip = Sqlca.getString(new SqlObject("SELECT ACTIONSCRIPT FROM FLOW_MODEL WHERE FLOWNO=:FLOWNO").setParameter("FLOWNO", "WF_EASY"));
			//String[] userIDArray = Expression.getExpressionValue(sActionSctrip, Sqlca).toStringArray();
			//sObjectNo = "10517203001";
			String sObjectType = "BusinessContract";
			double dCount = Sqlca.getDouble(new SqlObject("SELECT COUNT(1) FROM FLOW_TASK WHERE OBJECTNO=:OBJECTNO AND OBJECTTYPE=:OBJECTTYPE")
				.setParameter("OBJECTNO", sObjectNo).setParameter("OBJECTTYPE", sObjectType));
			
			if (dCount <= 2.0) {
				System.out.println("开始检查流程是否一致！");
				// 判断是否重复调用规则引擎
				String firFlowNo = Sqlca.getString(new SqlObject("SELECT FLOWNO FROM FLOW_TASK WHERE OBJECTNO=:OBJECTNO AND OBJECTTYPE=:OBJECTTYPE AND RELATIVESERIALNO IS NULL")
					.setParameter("OBJECTNO", sObjectNo).setParameter("OBJECTTYPE", sObjectType));
				String sndFlowNo = Sqlca.getString(new SqlObject("SELECT FLOWNO FROM FLOW_TASK WHERE OBJECTNO=:OBJECTNO AND OBJECTTYPE=:OBJECTTYPE AND RELATIVESERIALNO IS NOT NULL")
					.setParameter("OBJECTNO", sObjectNo).setParameter("OBJECTTYPE", sObjectType));
				
				// 开始必修正流程
				if (firFlowNo!=null && sndFlowNo!=null && !firFlowNo.equals(sndFlowNo)) {
					String sSndPhaseNo = Sqlca.getString(new SqlObject("SELECT PHASENO FROM FLOW_TASK WHERE OBJECTNO=:OBJECTNO AND OBJECTTYPE=:OBJECTTYPE AND RELATIVESERIALNO IS NOT NULL")
						.setParameter("OBJECTNO", sObjectNo).setParameter("OBJECTTYPE", sObjectType));
					if (Arrays.asList("9000","1000","8000").contains(sSndPhaseNo)) {
						return "Failure";
					}
					// 规则引擎流程编号
					String sFlowNo = Sqlca.getString(new SqlObject("SELECT WORKFLOWCODE FROM PRE_DATA WHERE SERIALNO=(SELECT max(SERIALNO) FROM PRE_DATA where IDCREDIT=:IDCREDIT)")
							.setParameter("IDCREDIT", sObjectNo));
					
					if (Arrays.asList("REJECT15","APPROVE15","RuleError").contains(sFlowNo)) {
						return "Success";
					}
					
					// 获取流程名称
					String sFlowName = Sqlca.getString(new SqlObject("SELECT FLOWNAME FROM FLOW_CATALOG WHERE FLOWNO=:FLOWNO").setParameter("FLOWNO", sFlowNo));
					
					// 流程第一阶段数据
					ASResultSet rs = Sqlca.getASResultSet(new SqlObject("SELECT PHASENO, PHASETYPE, PHASENAME FROM FLOW_MODEL WHERE FLOWNO=:FLOWNO AND ROWNUM=1 ORDER BY PHASENO")
						.setParameter("FLOWNO", sFlowNo));
					String firPhaseNo = "", firPhaseType="", firPhaseName="", sndPhaseNo="", sndPhaseType="", sndPhaseName="";
					
					if (rs.next()) {
						
						firPhaseNo = rs.getString("PHASENO");
						firPhaseType = rs.getString("PHASETYPE");
						firPhaseName = rs.getString("PHASENAME");
						rs.close();
					}
					// 流程第二阶段数据
					rs = Sqlca.getASResultSet(new SqlObject("SELECT PHASENO, PHASETYPE, PHASENAME FROM FLOW_MODEL WHERE FLOWNO=:FLOWNO AND PHASENO=(SELECT MAX(T.PHASENO) FROM (SELECT PHASENO FROM FLOW_MODEL WHERE FLOWNO=:FLOWNO AND ROWNUM<=2 ORDER BY PHASENO) T)")
							.setParameter("FLOWNO", sFlowNo));
					
					if (rs.next()) {
						
						sndPhaseNo = rs.getString("PHASENO");
						sndPhaseType = rs.getString("PHASETYPE");
						sndPhaseName = rs.getString("PHASENAME");
						rs.getStatement().close();
					}
					
					// 修正FLOW_TASK中记录
					String firSerialNo = Sqlca.getString(new SqlObject("SELECT SERIALNO FROM FLOW_TASK WHERE OBJECTNO=:OBJECTNO AND OBJECTTYPE=:OBJECTTYPE AND RELATIVESERIALNO IS NULL")
						.setParameter("OBJECTNO", sObjectNo).setParameter("OBJECTTYPE", sObjectType));
					String sndSerialNo = Sqlca.getString(new SqlObject("SELECT SERIALNO FROM FLOW_TASK WHERE OBJECTNO=:OBJECTNO AND OBJECTTYPE=:OBJECTTYPE AND RELATIVESERIALNO IS NOT NULL")
						.setParameter("OBJECTNO", sObjectNo).setParameter("OBJECTTYPE", sObjectType));
					
					// 修正FLOW_TASK第一阶段数据
					Sqlca.executeSQL(new SqlObject("UPDATE FLOW_TASK SET FLOWNO=:FLOWNO, FLOWNAME=:FLOWNAME, PHASENO=:PHASENO, PHASENAME=:PHASENAME, PHASETYPE=:PHASETYPE WHERE SERIALNO=:SERIALNO")
						.setParameter("FLOWNO", sFlowNo).setParameter("FLOWNAME", sFlowName).setParameter("PHASENO", firPhaseNo).setParameter("PHASENAME", firPhaseName).setParameter("PHASETYPE", firPhaseType).setParameter("SERIALNO", firSerialNo));
					
					// 修正FLOW_TASK第二阶段中数据
					Sqlca.executeSQL(new SqlObject("UPDATE FLOW_TASK SET FLOWNO=:FLOWNO, FLOWNAME=:FLOWNAME, PHASENO=:PHASENO, PHASENAME=:PHASENAME, PHASETYPE=:PHASETYPE WHERE SERIALNO=:SERIALNO")
							.setParameter("FLOWNO", sFlowNo).setParameter("FLOWNAME", sFlowName).setParameter("PHASENO", sndPhaseNo).setParameter("PHASENAME", sndPhaseName).setParameter("PHASETYPE", sndPhaseType).setParameter("SERIALNO", sndSerialNo));
					
					// 修正FLOW_OBJECTNO 中数据
					Sqlca.executeSQL(new SqlObject("UPDATE FLOW_OBJECT SET FLOWNO=:FLOWNO, FLOWNAME=:FLOWNAME, PHASENO=:PHASENO, PHASENAME=:PHASENAME, PHASETYPE=:PHASETYPE WHERE OBJECTNO=:OBJECTNO AND OBJECTTYPE=:OBJECTTYPE")
							.setParameter("FLOWNO", sFlowNo).setParameter("FLOWNAME", sFlowName).setParameter("PHASENO", sndPhaseNo).setParameter("PHASENAME", sndPhaseName).setParameter("PHASETYPE", sndPhaseType).setParameter("OBJECTNO", sObjectNo).setParameter("OBJECTTYPE", sObjectType));
					
				}
				
			}
			
			
			/*ASResultSet rs = Sqlca.getASResultSet(new SqlObject("SELECT FM.FLOWNO, FC.FLOWNAME,FM.PHASETYPE,PHASENO,FM.PHASENAME, FM.POSTSCRIPT FROM FLOW_MODEL FM JOIN FLOW_CATALOG FC ON FM.FLOWNO=FC.FLOWNO WHERE FC.FLOWNO=:FLOWNO")
					.setParameter("FLOWNO", sRuleRetFlowNo)); 
			
			if (rs == null) throw new RuntimeException("该流程：" + sRuleRetFlowNo + " 未配置， 请核查！");
			else {
				rs.next();
				String[] sPostScriptArray = rs.getString("POSTSCRIPT").split(",");
				String sNextPhaseNo = 
				
			}*/ // 直接根据流程配置来修正流程
			
					
		} catch (Exception e) { 
			e.printStackTrace(); 
			return "Failure";
		}
		
		return "Success";
	}
	
	/**
	 * 更新合同状态
	 * @param Sqlca
	 * @return
	 */
	public String correctBCStatus(Transaction Sqlca) {
		String sObjectType = "BusinessContract";
		
 		try {
			String sPhaseNo = Sqlca.getString(new SqlObject("SELECT PHASENO FROM FLOW_OBJECT WHERE OBJECTNO=:OBJECTNO AND OBJECTTYPE=:OBJECTTYPE")
					.setParameter("OBJECTNO", sObjectNo).setParameter("OBJECTTYPE", sObjectType));
			String sureType = Sqlca.getString(new SqlObject("select sureType from Business_Contract where SerialNo = :ObjectNo ").setParameter("ObjectNo", sObjectNo));
			
			if(sureType == null) sureType = "";
			String sSql = "";
			//获取当前用户名和提单名
			String sCustomerName = "";
			String sInputUserID = "";
			ASResultSet rsTemp = null;
			sSql = "select CustomerName, InputUserID from Business_Contract where SerialNo = :ObjectNo ";
			rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectNo",sObjectNo));
			if (rsTemp.next()){
				sCustomerName = DataConvert.toString(rsTemp.getString("CustomerName"));
				sInputUserID = DataConvert.toString(rsTemp.getString("InputUserID"));
				//将空值转化成空字符串
				if(sCustomerName == null) sCustomerName = "";
				if(sInputUserID == null) sInputUserID = "";
			}
			rsTemp.getStatement().close();
			
			String s = "";
			if ("1".equals(phaseNOFlag)) {
				if ("1000".equals(sPhaseNo)) {
					s = ", phaseno='1000' ";
				} else if ("8000".equals(sPhaseNo)) {
					s = ", phaseno='8000' ";
				} else if ("9000".equals(sPhaseNo)) {
					s = ", phaseno='9000' ";
				}
			}
			
			//下阶段为批准、附条件批准，更新合同状态
			if(sPhaseNo.equals("1000")){//已批准 080
				sSql = "update business_contract set contractstatus = '080'" + s + " where SerialNo = :Serialno";
			}else if(sPhaseNo.equals("8000")){//已否决 010
				sSql = "update business_contract set contractstatus = '010'" + s + " where SerialNo = :Serialno";
			}else if(sPhaseNo.equals("9000")){//已取消
				sSql = "update business_contract set contractstatus = '100'" + s + " where SerialNo = :Serialno";
			}else{//新发生
				if (!sPhaseNo.equals("0010")) {
					sSql = "update business_contract set contractstatus = '070'" + s + " where SerialNo = :Serialno";
				} else {
					sSql = "update business_contract set contractstatus = '060'" + s + " where SerialNo = :Serialno";
				}
			}
			Sqlca.executeSQL(new SqlObject(sSql).setParameter("Serialno", sObjectNo));
			if("APP".equals(sureType) || "FC".equals(sureType)){
				sendMessage(Sqlca, sPhaseNo);
			}
			// 更新最终处理人
//			if (Arrays.asList("1000", "2000", "8000", "9000").contains(sPhaseNo)) {
//				String sFinalUserId = Sqlca.getString(new SqlObject("select userid from flow_task where serialno=(select max(relativeserialno) from flow_task where objectno=:objectno and objecttype='BusinessContract')")
//						.setParameter("objectno", sObjectNo));
//				Sqlca.executeSQL(new SqlObject("UPDATE FLOW_OBJECT SET OBJATTRIBUTE4=:DEALUSER WHERE OBJECTNO=:OBJECTNO AND OBJECTTYPE=:OBJECTTYPE")
//					.setParameter("DEALUSER", sFinalUserId).setParameter("OBJECTNO", sObjectNo).setParameter("OBJECTTYPE", sObjectType));
//			}
			
		} catch (Exception e) {
			e.printStackTrace();
			try {
				Sqlca.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			return "Failure";
		} 
		
		return "Success";
		
	}

	private String sObjectNo;

	public String getSObjectNo() {
		return sObjectNo;
	}
	public void setSObjectNo(String sObjectNo) {
		this.sObjectNo = sObjectNo;
	}
	
	//PAD端发送推送消息	
	@SuppressWarnings("deprecation")
	public void sendMessage(Transaction Sqlca, String sPhaseNo){
		//通知消息接口服务器地址
//		String ipAddr = "http://10.26.1.157:8080";
		String ipAddr = "";
		String sToday = StringFunction.getTodayNow();
		String tmpToday = StringFunction.getToday();
		String[] strTime = tmpToday.split("/");
		String sYear = strTime[0];
		String sMonth = strTime[1];
		String sDay = strTime[2];
		String sStatus = "";
		String sMessage = "";
		String urlStr = "";
		String sSql = "";
		ASResultSet rsTemp = null;
		HttpClient httpClient = null;
		HttpMethod get = null;
		String tmpStr = null;
		String htmlRet = "";
		try{
			//获取当前用户名和提单名
			String sCustomerName = "";
			String sInputUserID = "";
			String sSureType = "";
			sSql = "select CustomerName, InputUserID, SureType from Business_Contract where SerialNo = :ObjectNo ";
			rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectNo",sObjectNo));
			if (rsTemp.next()){
				sCustomerName = DataConvert.toString(rsTemp.getString("CustomerName"));
				sInputUserID = DataConvert.toString(rsTemp.getString("InputUserID"));
				sSureType = DataConvert.toString(rsTemp.getString("SureType"));
				//将空值转化成空字符串
				if(sCustomerName == null) sCustomerName = "";
				if(sInputUserID == null) sInputUserID = "";
				if(sSureType == null) sSureType = "";
			}
			if("APP".equals(sSureType)){
				ipAddr = CodeCache.getItem("PushMessageUrl","0020").getItemAttribute();
			}else{
				ipAddr = CodeCache.getItem("PushMessageUrl","0010").getItemAttribute();
			}
			if(sPhaseNo.equals("1000")){
				sStatus = "审核通过";
				sMessage = "合同["+sObjectNo+"]于"+sYear+"年"+sMonth+"月"+sDay+"日"+",状态变更为["+sStatus+"]";
	//			urlStr = ipAddr+"/PushManager/push.do?cno="+sObjectNo+"&cname="+URLEncoder.encode(sCustomerName,"UTF-8")+"&msg="+URLEncoder.encode(sMessage, "UTF-8")+"&datetime="+URLEncoder.encode(sToday)+"&cid="+sInputUserID+"&state="+URLEncoder.encode(sStatus, "UTF-8");
			}else if(sPhaseNo.equals("8000")){
				sStatus = "已否决";
				sMessage = "合同["+sObjectNo+"]于"+sYear+"年"+sMonth+"月"+sDay+"日"+",状态变更为["+sStatus+"]"+",原因为审核否决";
//				urlStr = ipAddr+"/PushManager/push.do?cno="+sObjectNo+"&cname="+URLEncoder.encode(sCustomerName,"UTF-8")+"&msg="+URLEncoder.encode(sMessage, "UTF-8")+"&datetime="+URLEncoder.encode(sToday)+"&cid="+sInputUserID+"&state="+URLEncoder.encode(sStatus, "UTF-8");
			}else if(sPhaseNo.equals("9000")){
				sStatus = "已取消";
				String cancelReason = "";
				String cancelRemark = "";
				sSql = "select getcancelcause(serialno) as CancelReason, getcancelremarks('BusinessContract',serialno) as CancelRemark from BUSINESS_CONTRACT where SerialNo = :Serialno";
				rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("Serialno",sObjectNo));
				if (rsTemp.next()){
					cancelReason = DataConvert.toString(rsTemp.getString("CancelReason"));
					cancelRemark = DataConvert.toString(rsTemp.getString("CancelRemark"));
				}
				sMessage = "合同["+sObjectNo+"]于"+sYear+"年"+sMonth+"月"+sDay+"日"+",状态变更为["+sStatus+"]"+",原因为审核取消"+","+cancelReason+",备注:["+cancelRemark+"]";
//				urlStr = ipAddr+"/PushManager/push.do?cno="+sObjectNo+"&cname="+URLEncoder.encode(sCustomerName,"UTF-8")+"&msg="+URLEncoder.encode(sMessage, "UTF-8")+"&datetime="+URLEncoder.encode(sToday)+"&cid="+sInputUserID+"&state="+URLEncoder.encode(sStatus, "UTF-8");
			}else{
				return;
			}
//			sCustomerName = new String(sCustomerName.getBytes("UTF-8"), "ISO-8859-1");
//			sCustomerName = new String(sCustomerName.getBytes("ISO-8859-1"), "UTF-8");
			sCustomerName = URLEncoder.encode(sCustomerName, "UTF-8");
//			sMessage = new String(sMessage.getBytes("UTF-8"), "ISO-8859-1");
//			sMessage = new String(sMessage.getBytes("ISO-8859-1"), "UTF-8");
			sMessage = URLEncoder.encode(sMessage, "UTF-8");
//			sStatus = new String(sStatus.getBytes("UTF-8"), "ISO-8859-1");
//			sStatus = new String(sStatus.getBytes("ISO-8859-1"), "UTF-8");
			sStatus = URLEncoder.encode(sStatus, "UTF-8");
			urlStr = ipAddr+"?cno="+sObjectNo+"&cname="+sCustomerName+"&msg="+sMessage+"&datetime="+URLEncoder.encode(sToday)+"&cid="+sInputUserID+"&state="+sStatus+"&pushType="+sSureType;
			System.out.println(urlStr);
			httpClient = new HttpClient();
			get = new GetMethod(urlStr);
			httpClient.executeMethod(get);
			BufferedReader reader = new BufferedReader(new InputStreamReader(
					get.getResponseBodyAsStream(), "UTF-8"));
			while ((tmpStr = reader.readLine()) != null) {
				htmlRet += tmpStr + "\r\n";
			}
			System.out.println(new String(htmlRet));
			  
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			try{
				rsTemp.getStatement().close();
			}catch(Exception ignore){
			}
		}
	}
	
	public String getPhaseNOFlag() {
		return phaseNOFlag;
	}

	public void setPhaseNOFlag(String phaseNOFlag) {
		this.phaseNOFlag = phaseNOFlag;
	}
	
}
