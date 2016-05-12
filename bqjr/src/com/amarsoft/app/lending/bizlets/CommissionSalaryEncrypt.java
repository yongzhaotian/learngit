package com.amarsoft.app.lending.bizlets;

import java.security.NoSuchAlgorithmException;

import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.security.MessageDigest;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 获取html文件相对路径
 * @author 黄烁
 */
public class CommissionSalaryEncrypt extends Bizlet {

	@Override
	public Object run(Transaction arg0) throws Exception {
		
		String userId = (String)this.getAttribute("userId");		// 用户ID
		String ym = (String)this.getAttribute("ym");
		String type = (String)this.getAttribute("type");
		String workid = (String)this.getAttribute("workid");
		String res = "";
		if ("MyCommission".equals(type)) {
			res = getCommissionFileName(userId, ym);
		} else {
			res = getSalaryFileName(workid, ym);
		}
		
		return res;
	}
	
	/**
	 * 获取提成文件名
	 * @param userId
	 * @param ym
	 * @return
	 * @throws NoSuchAlgorithmException
	 */
	private String getCommissionFileName(String userId, String ym) throws NoSuchAlgorithmException {
		
		String fileName = "COMMISSION" + "/" + ym + "/" 
					+ encrypt(ym + userId + "ymw") + ".html";
		return fileName;
	}
	
	/**
	 * 获取工资文件名
	 * @param workid
	 * @param ym
	 * @return
	 * @throws NoSuchAlgorithmException
	 */
	private String getSalaryFileName(String workid, String ym) throws NoSuchAlgorithmException {
		
		String fileName = "SALARY" + "/" + ym + "/" 
					+ encrypt(ym + workid + "ymw") + ".html";
		return fileName;
	}

	// 加密字符串
	private String encrypt(String param) throws NoSuchAlgorithmException {
		
		String str = StringX.bytesToHexString(MessageDigest.getDigest("MD5", param), true);
		return str;
	}
}
