package com.amarsoft.app.billions;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URLEncoder;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpMethod;
import org.apache.commons.httpclient.methods.GetMethod;

import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.cache.CodeCache;
/**
 * 文件质量检查和贷后资料检查初审、复审后向PAD前端推送消息
 * @author yongxu 
 * @date 2015-07-10
 */
public class SendMessageUtil {
	
//	private static String ipAddr = "http://10.26.1.157:8080"; //通知消息接口服务器地址
	
	private String sToday = StringFunction.getTodayNow(); //当前日期
	
	private String tmpToday = StringFunction.getToday(); 
	
	private String[] strTime = tmpToday.split("/");
	
	private String sYear = strTime[0];
	
	private String sMonth = strTime[1];
	
	private String sDay = strTime[2];
	
	/*
	 * 向PAD端发送通知消息需要传递的参数
	 */
	private String sSendType = ""; //发送类别{1：文件质量检查初审，2：文件质量检查复审，3：贷后资料检查初审，4：贷后资料检查复审}
	
	private String sObjectNo = ""; //合同号
	
	private String sSureType = ""; //合同来源
	
	public String getSSureType() {
		return sSureType;
	}

	public void setSSureType(String sSureType) {
		this.sSureType = sSureType;
	}

	public void sendMessage(Transaction Sqlca){
		String sUrlStr = "";
		HttpClient httpClient = null;
		HttpMethod get = null;
		String tmpStr = null;
		String htmlRet = "";
		ASResultSet rsTemp = null;
		String sSql = "";
		String sMessage = ""; //消息内容
		String sStatus = ""; //初审、复审
		try{
			//获取当前用户名和提单用户ID
			String sCustomerName = "";
			String sInputUserID = "";
			String ipAddr = CodeCache.getItem("PushMessageUrl","0010").getItemAttribute(); //通知消息接口服务器地址
			sSql = "select CustomerName, InputUserID from Business_Contract where SerialNo = :ObjectNo ";
			rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectNo",sObjectNo));
			if (rsTemp.next()){
				sCustomerName = DataConvert.toString(rsTemp.getString("CustomerName"));
				sInputUserID = DataConvert.toString(rsTemp.getString("InputUserID"));
				//将空值转化成空字符串
				if(sCustomerName == null) sCustomerName = "";
				if(sInputUserID == null) sInputUserID = "";
			}
			if("1".equals(sSendType)){
				sStatus = "初审";
				sSql = "select getImageTypeName(TYPENO) as typeName, getitemname('Opinion',opinion1) as opinion, qualitymark1 as qualityMark from ecm_image_opinion eio  where objectno = :ObjectNo and opinion1 is not null";
			}else if("2".equals(sSendType)){
				sStatus = "复审";	
				sSql = "select getImageTypeName(TYPENO) as typeName, getitemname('Opinion',opinion2) as opinion, qualitymark2 as qualityMark from ecm_image_opinion eio  where objectno = :ObjectNo and opinion2 is not null";
			}else if("3".equals(sSendType)){
				sStatus = "初审";
				sSql = "select getImageTypeName(TYPENO) as typeName, getitemname('Opinion',checkopinion1) as opinion, qualitymarkLoan1 as qualityMark from ecm_image_opinion eio  where objectno = :ObjectNo and checkopinion1 is not null";
			}else if("4".equals(sSendType)){
				sStatus = "复审";
				sSql = "select getImageTypeName(TYPENO) as typeName, getitemname('Opinion',checkopinion2) as opinion, qualitymarkLoan2 as qualityMark from ecm_image_opinion eio  where objectno = :ObjectNo and checkopinion2 is not null";
			}
			rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectNo",sObjectNo));
			int count = 1;
			while (rsTemp.next()){
				String typeName = rsTemp.getString("typeName");
				String opinion = rsTemp.getString("opinion");
				String qualityMark = rsTemp.getString("qualityMark");
				sMessage += new Integer(count).toString()+"."+typeName+","+opinion;
				if(qualityMark!=null && !"".equals(qualityMark)){
					sMessage += ","+qualityMark;
				}
				sMessage += "\n";
				count++;
			}
			sUrlStr = ipAddr+"?cno="+sObjectNo+"&cname="+URLEncoder.encode(sCustomerName,"UTF-8")+"&msg="+URLEncoder.encode(sMessage, "UTF-8")+"&datetime="+URLEncoder.encode(sToday)+"&cid="+sInputUserID+"&state="+URLEncoder.encode(sStatus, "UTF-8")+"&pushType="+sSureType;
			System.out.println("推送消息："+sUrlStr);
			httpClient = new HttpClient();
			get = new GetMethod(sUrlStr);
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

	public String getSSendType() {
		return sSendType;
	}

	public void setSSendType(String sSendType) {
		this.sSendType = sSendType;
	}

	public String getSObjectNo() {
		return sObjectNo;
	}

	public void setSObjectNo(String sObjectNo) {
		this.sObjectNo = sObjectNo;
	}

}
