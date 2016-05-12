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
		// �Զ���ô���Ĳ���ֵ
		// ��ͬ��
		String sObjectNo = (String) this.getAttribute("ObjectNo");
		// ҵ������
		String sureType = Sqlca.getString(new SqlObject("select sureType from Business_Contract where SerialNo = :ObjectNo ").setParameter("ObjectNo", sObjectNo));
		// ����ֵת��Ϊ���ַ���
		if (sObjectNo == null) {
			sObjectNo = "";
		}
		if (sureType == null) {
			sureType = "";
		}
		// ���º�ͬ״̬
		updateContractStatus(Sqlca, sObjectNo);
		if ("APP".equals(sureType)) {
			// ����ҵ���ӱ�����Ƿ���Ҫ�ϴ����������ֶ�
			insertCheckCustomer(Sqlca, sObjectNo);
			// ����������Ϣ��PAD��
			sendMessage(Sqlca, sObjectNo);
		}
		ARE.getLog().debug("-----------sObjectNo-------------" + sObjectNo);
		return "success";
	}

	/**
	 * ����ҵ���ӱ�����Ƿ���Ҫ�ϴ����������ֶ�
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
				sUploadFlag = "3"; // ��Ʒ����Ϊ�գ��ϴ���������״̬����Ϊ�����ϴ�
			} else {
				String count = Sqlca.getString(new SqlObject("select count(1) from product_ecm_upload  where product_type_id = :product_type_id").setParameter("product_type_id", businessType1));
				if (new Integer(count).intValue() > 0) {
					sUploadFlag = "2"; // ��Ҫ�ϴ��������ϣ������ϴ�״̬Ϊδ�ϴ�
				} else {
					sUploadFlag = "3"; // �����ϴ��������ϣ������ϴ�״̬Ϊ�����ϴ�
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
	 * PAD�˷���������Ϣ
	 * 
	 * @param Sqlca
	 * @param sObjectNo
	 */
	@SuppressWarnings("deprecation")
	public void sendMessage(Transaction Sqlca, String sObjectNo) {
		// ֪ͨ��Ϣ�ӿڷ�������ַ
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
			// ��ȡ��ǰ�û������ᵥ��
			String sCustomerName = "";
			String sInputUserID = "";
			sSql = "select CustomerName, InputUserID from Business_Contract where SerialNo = :ObjectNo ";
			rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectNo", sObjectNo));
			if (rsTemp.next()) {
				sCustomerName = DataConvert.toString(rsTemp.getString("CustomerName"));
				sInputUserID = DataConvert.toString(rsTemp.getString("InputUserID"));
				// ����ֵת���ɿ��ַ���
				if (sCustomerName == null)
					sCustomerName = "";
				if (sInputUserID == null)
					sInputUserID = "";
			}
			sStatus = "���ͨ��";
			sMessage = "��ͬ[" + sObjectNo + "]��" + sYear + "��" + sMonth + "��" + sDay + "��" + ",״̬���Ϊ[" + sStatus + "]";
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
