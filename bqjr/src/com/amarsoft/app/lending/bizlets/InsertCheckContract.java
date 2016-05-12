package com.amarsoft.app.lending.bizlets;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URLEncoder;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpMethod;
import org.apache.commons.httpclient.methods.GetMethod;

import com.amarsoft.are.ARE;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class InsertCheckContract extends Bizlet {
	public Object run(Transaction Sqlca) throws Exception {
		// 自动获得传入的参数值
		// 合同号
		String sObjectNo = (String) this.getAttribute("ObjectNo");
		// 业务类型
		String sureType = Sqlca.getString(new SqlObject("select sureType from Business_Contract where SerialNo = :ObjectNo ").setParameter("ObjectNo", sObjectNo));
		// 将空值转化为空字符串
		if (sObjectNo == null) {
			sObjectNo = "";
		}
		if (sureType == null) {
			sureType = "";
		}
		// 更新合同状态
		updateContractStatus(Sqlca, sObjectNo);
		if ("APP".equals(sureType)) {
			// 插入业务子表，添加是否需要上传贷后资料字段
			insertCheckCustomer(Sqlca, sObjectNo);
			// 发送推送消息至PAD端
			sendMessage(Sqlca, sObjectNo);
		}
		ARE.getLog().debug("-----------sObjectNo-------------" + sObjectNo);
		return "success";
	}

	/**
	 * 插入业务子表，添加是否需要上传贷后资料字段
	 * 
	 * @param Sqlca
	 * @param sObjectNo
	 */
	@SuppressWarnings("deprecation")
	public void insertCheckCustomer(Transaction Sqlca, String sObjectNo) {
		ARE.getLog().debug("-----------insertCheckContract begin-------------");
		String sToday = StringFunction.getTodayNow();
		String sUploadFlag = "";
		try {
			String businessType1 = Sqlca.getString(new SqlObject("select businessType1 from Business_Contract where SerialNo = :ObjectNo ").setParameter("ObjectNo", sObjectNo));
			if (businessType1 == null || "".equals(businessType1)) {
				sUploadFlag = "3"; // 商品类型为空，上传贷后资料状态设置为无需上传
			} else {
				String count = Sqlca.getString(new SqlObject("select count(1) from product_ecm_upload  where product_type_id = :product_type_id").setParameter("product_type_id", businessType1));
				if (new Integer(count).intValue() > 0) {
					sUploadFlag = "2"; // 需要上传贷后资料，设置上传状态为未上传
				} else {
					sUploadFlag = "3"; // 无需上传贷后资料，设置上传状态为无需上传
				}
			}
			String count2 = Sqlca.getString(new SqlObject("select count(1) from Check_Contract  where contractSerialNo = :ObjectNo ").setParameter("ObjectNo", sObjectNo));
			String sql = "";
			if (new Integer(count2).intValue() > 0) {
				sql = "update Check_Contract set CHECKDOCSTATUS = '1', PASSTIME = '" + sToday + "', UPLOADFLAG = '" + sUploadFlag + "' where CONTRACTSERIALNO = '" + sObjectNo + "'";
			} else {
				sql = "insert into Check_Contract (CONTRACTSERIALNO, CHECKDOCSTATUS, PASSTIME, UPLOADFLAG) " + "values ('" + sObjectNo + "', '1','" + sToday + "','" + sUploadFlag + "')";
			}
			ARE.getLog().debug("insertCheckContract sql:" + sql);
			Sqlca.executeSQL(sql);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			ARE.getLog().debug("Error------------:" + e.getMessage());
		}
		ARE.getLog().debug("-----------insertCheckContract end-------------");
	}

	/**
	 * PAD端发送推送消息
	 * 
	 * @param Sqlca
	 * @param sObjectNo
	 */
	@SuppressWarnings("deprecation")
	public void sendMessage(Transaction Sqlca, String sObjectNo) {
		// 通知消息接口服务器地址
		String ipAddr = "http://10.26.1.157:8080";
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
		try {
			// 获取当前用户名和提单名
			String sCustomerName = "";
			String sInputUserID = "";
			sSql = "select CustomerName, InputUserID from Business_Contract where SerialNo = :ObjectNo ";
			rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectNo", sObjectNo));
			if (rsTemp.next()) {
				sCustomerName = DataConvert.toString(rsTemp.getString("CustomerName"));
				sInputUserID = DataConvert.toString(rsTemp.getString("InputUserID"));
				// 将空值转化成空字符串
				if (sCustomerName == null)
					sCustomerName = "";
				if (sInputUserID == null)
					sInputUserID = "";
			}
			sStatus = "审核通过";
			sMessage = "合同[" + sObjectNo + "]于" + sYear + "年" + sMonth + "月" + sDay + "日" + ",状态变更为[" + sStatus + "]";
			urlStr = ipAddr + "/PushManager/push.do?cno=" + sObjectNo + "&cname=" + URLEncoder.encode(sCustomerName, "UTF-8") + "&msg=" + URLEncoder.encode(sMessage, "UTF-8") + "&datetime="
					+ URLEncoder.encode(sToday) + "&cid=" + sInputUserID + "&state=" + URLEncoder.encode(sStatus, "UTF-8");
			System.out.println("-----------------------:sStatus=" + sStatus);
			System.out.println("-----------------------:urlStr=" + urlStr);
			httpClient = new HttpClient();
			get = new GetMethod(urlStr);
			httpClient.executeMethod(get);
			BufferedReader reader = new BufferedReader(new InputStreamReader(get.getResponseBodyAsStream(), "UTF-8"));
			while ((tmpStr = reader.readLine()) != null) {
				htmlRet += tmpStr + "\r\n";
			}
			System.out.println(new String(htmlRet));
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				rsTemp.getStatement().close();
			} catch (Exception ignore) {
			}
		}
	}

	public void updateContractStatus(Transaction Sqlca, String sObjectNo) {
		try {
			String sSql = "Update Business_Contract set ContractStatus='080' where SerialNo ='" + sObjectNo + "' ";
			Sqlca.executeSQL(sSql);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
