package com.amarsoft.app.als.bizobject.customer;

import java.io.Serializable;

/**
 * @author syang
 * @since 2011-6-11
 * @describe ���˿ͻ�
 */
public class IndCustomer extends Customer implements Serializable{
	
	private static final long serialVersionUID = 2534410926721543994L;
	private String sex = null;				//�Ա����
	private String birthDay = null;			//��������
	private String marriage = null;			//����״������
	private String certID18 = null;			//18λ���֤��
	private String loancardNo = null;		//���˴�����
	private String eduExperience = null;	//���ѧ������
	/**
	 * @return �Ա����
	 */
	public String getSex() {
		return sex;
	}
	/**
	 * @param sex �Ա����
	 */
	public void setSex(String sex) {
		this.sex = sex;
	}
	/**
	 * @return ��������
	 */
	public String getBirthDay() {
		return birthDay;
	}
	/**
	 * @param birthDay ��������
	 */
	public void setBirthDay(String birthDay) {
		this.birthDay = birthDay;
	}
	/**
	 * @return ����״������
	 */
	public String getMarriage() {
		return marriage;
	}
	/**
	 * @param marriage ����״������
	 */
	public void setMarriage(String marriage) {
		this.marriage = marriage;
	}
	/**
	 * @return 18λ���֤��
	 */
	public String getCertID18() {
		return certID18;
	}
	/**
	 * @param certID18 18λ���֤��
	 */
	public void setCertID18(String certID18) {
		this.certID18 = certID18;
	}
	/**
	 * @return ���˴�����
	 */
	public String getLoancardNo() {
		return loancardNo;
	}
	/**
	 * @param loancardNo ���˴�����
	 */
	public void setLoancardNo(String loancardNo) {
		this.loancardNo = loancardNo;
	}
	/**
	 * @return ���ѧ������
	 */
	public String getEduExperience() {
		return eduExperience;
	}
	/**
	 * @param eduExperience ���ѧ������
	 */
	public void setEduExperience(String eduExperience) {
		this.eduExperience = eduExperience;
	}

}
