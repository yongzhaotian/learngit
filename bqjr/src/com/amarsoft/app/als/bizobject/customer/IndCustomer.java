package com.amarsoft.app.als.bizobject.customer;

import java.io.Serializable;

/**
 * @author syang
 * @since 2011-6-11
 * @describe 个人客户
 */
public class IndCustomer extends Customer implements Serializable{
	
	private static final long serialVersionUID = 2534410926721543994L;
	private String sex = null;				//性别代码
	private String birthDay = null;			//出生日期
	private String marriage = null;			//婚姻状况代码
	private String certID18 = null;			//18位身份证号
	private String loancardNo = null;		//个人贷款卡编号
	private String eduExperience = null;	//最高学历代码
	/**
	 * @return 性别代码
	 */
	public String getSex() {
		return sex;
	}
	/**
	 * @param sex 性别代码
	 */
	public void setSex(String sex) {
		this.sex = sex;
	}
	/**
	 * @return 出生日期
	 */
	public String getBirthDay() {
		return birthDay;
	}
	/**
	 * @param birthDay 出生日期
	 */
	public void setBirthDay(String birthDay) {
		this.birthDay = birthDay;
	}
	/**
	 * @return 婚姻状况代码
	 */
	public String getMarriage() {
		return marriage;
	}
	/**
	 * @param marriage 婚姻状况代码
	 */
	public void setMarriage(String marriage) {
		this.marriage = marriage;
	}
	/**
	 * @return 18位身份证号
	 */
	public String getCertID18() {
		return certID18;
	}
	/**
	 * @param certID18 18位身份证号
	 */
	public void setCertID18(String certID18) {
		this.certID18 = certID18;
	}
	/**
	 * @return 个人贷款卡编号
	 */
	public String getLoancardNo() {
		return loancardNo;
	}
	/**
	 * @param loancardNo 个人贷款卡编号
	 */
	public void setLoancardNo(String loancardNo) {
		this.loancardNo = loancardNo;
	}
	/**
	 * @return 最高学历代码
	 */
	public String getEduExperience() {
		return eduExperience;
	}
	/**
	 * @param eduExperience 最高学历代码
	 */
	public void setEduExperience(String eduExperience) {
		this.eduExperience = eduExperience;
	}

}
