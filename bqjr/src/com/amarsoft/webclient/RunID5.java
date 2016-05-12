package com.amarsoft.webclient;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.oti.client.hhcf.id5.DESBASE64;

public class RunID5 {

	/**
	 * 返回值， 首部010 已经存在，020不存在
	 * @param Sqlca
	 * @return
	 */
	public String runParserId5(Transaction Sqlca) {
		
		String sRet = "";
		try {
			//CurConfig.getConfigure("ImageFolder");
			sRet = ID5Util.parseID5Info(Sqlca, customerId,
								reqHeader,
								reqData,
								savepath, stype,imgpath);//imgpath 用于头像保存路径  by linhai 20150519 CCS-757
			System.out.println("Return Value: " + sRet);
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		
		return sRet;
	}
	
	/**
	 * 返回值， 首部010 已经存在，020不存在
	 * @param Sqlca
	 * @return
	 */
	public static String runParserId5(Transaction Sqlca, String customerId, String reqHeader, String reqData, String savepath, String stype,String imgpath) {
		
		String sRet = "";
		try {
			//CurConfig.getConfigure("ImageFolder");
			sRet = ID5Util.parseID5Info(Sqlca, customerId, reqHeader,reqData,savepath, stype,imgpath);//imgpath 用于头像保存路径  by linhai 20150519 CCS-757
			System.out.println("Return Value: " + sRet);
		} catch (Exception e) {
			
			e.printStackTrace();
			sRet = "error";
		}
		
		return sRet;
	}
	
	private String reqHeader;
	private String reqData;
	private String stype;
	private String savepath;
	private String customerId;
	private String  imgpath;//imgpath 用于头像保存路径  by linhai 20150519 CCS-757
	
	

	public RunID5() {
		// TODO Auto-generated constructor stub
	}
	
	public RunID5(String reqHeader, String reqData, String stype, String savepath,String imgpath) {
		this.reqHeader = reqHeader;
		this.reqData = reqData;
		this.stype = stype;
		this.savepath = savepath;
		this.customerId = customerId;
		this.imgpath= imgpath;
	}
	
	public String getReqHeader() {
		return reqHeader;
	}
	public void setReqHeader(String reqHeader) {
		this.reqHeader = reqHeader;
	}
	public String getReqData() {
		return reqData;
	}
	public void setReqData(String reqData) {
		this.reqData = reqData;
	}
	public String getStype() {
		return stype;
	}
	public void setStype(String stype) {
		this.stype = stype;
	}
	public String getSavepath() {
		return savepath;
	}
	public void setSavepath(String savepath) {
		this.savepath = savepath;
	}

	public String getCustomerId() {
		return customerId;
	}

	public void setCustomerId(String customerId) {
		this.customerId = customerId;
	}
	
	public String getImgpath() {
		return imgpath;
	}

	public void setImgpath(String imgpath) {
		this.imgpath = imgpath;
	}
}
