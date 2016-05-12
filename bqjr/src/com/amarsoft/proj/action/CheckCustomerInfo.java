package com.amarsoft.proj.action;

import java.sql.SQLException;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * ���ͻ���Ϣ
 * @author Dahl
 * @date 2015��5��30��
 */
public class CheckCustomerInfo {
	private String customerId;	//�ͻ�ID
	private String schoolName;	//ѧУȫ��
	private String schoolCollege;	//����ѧԺ
	private String schoolDepartment;	//ϵ
	private String schoolProfessionalName;	//רҵ����
	private String schoolClass;	//�༶
	private String schoolStudentNo;	//ѧ��
	private String schoolLearning;	//ѧϰ��ʽ
	private String schoolStatusStudent;	//ѧ��״̬
	private String schoolDegreeCategory;	//ѧ�����
	private String schoolLength;	//ѧ��
	private String schoolLevel;	//���
	private String schoolDormitoryTelephone;	//ѧԺ/����绰
	private String schoolCounselorTelephone;	//����Ա�绰
	private String schoolEnrollmentDate;	//��ѧ����
	private String schoolExpectedDate;	//Ԥ�Ʊ�ҵ����
	private String schoolAddress;	//ѧУ ʡ/ֱϽ��
	private String schoolTownship;	//��/��
	private String schoolStreet;	//�ֵ�/��
	private String schoolCommunity;	//С��/¥��
	private String schoolRoomNo;	//��/��Ԫ/�����
	
	/**
	 * ���ݿͻ�ID�������student_school_info�����Ƿ���ڴ˿ͻ�,����������롣
	 * @author Dahl
	 * @date 2015��5��30��
	 */
	public void checkStuCusExists(Transaction Sqlca) throws Exception{
		String sSql = "insert when (not exists (select 1 from student_school_info where customerId = :customerId)) then into student_school_info(customerId) select :customerId from dual";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("customerId", customerId));
	}
	
	/**
	 * ����customerId������student_school_info��
	 * @author Dahl
	 * @date 2015��5��30��
	 */
	public void updateStudentCchoolInfo(Transaction Sqlca) throws Exception{
		String sSql = "update student_school_info set school_name=:schoolName,school_college=:schoolCollege,school_department=:schoolDepartment,school_professional_name=:schoolProfessionalName,school_class=:schoolClass,school_student_no=:schoolStudentNo,school_learning=:schoolLearning,school_status_student=:schoolStatusStudent,school_Degree_category=:schoolDegreeCategory,school_length=:schoolLength,school_level=:schoolLevel,school_dormitory_telephone=:schoolDormitoryTelephone,school_counselor_telephone=:schoolCounselorTelephone,school_enrollment_date=:schoolEnrollmentDate,school_expected_date=:schoolExpectedDate,school_address=:schoolAddress,school_township=:schoolTownship,school_street=:schoolStreet,school_community=:schoolCommunity,school_room_no=:schoolRoomNo where customerId=:customerId";
		Sqlca.executeSQL(new SqlObject(sSql)
				.setParameter("customerId", customerId)
				.setParameter("schoolName", schoolName)
				.setParameter("schoolCollege", schoolCollege)
				.setParameter("schoolDepartment", schoolDepartment)
				.setParameter("schoolProfessionalName", schoolProfessionalName)
				.setParameter("schoolClass", schoolClass)
				.setParameter("schoolStudentNo", schoolStudentNo)
				.setParameter("schoolLearning", schoolLearning)
				.setParameter("schoolStatusStudent", schoolStatusStudent)
				.setParameter("schoolDegreeCategory", schoolDegreeCategory)
				.setParameter("schoolLength", schoolLength)
				.setParameter("schoolLevel", schoolLevel)
				.setParameter("schoolDormitoryTelephone", schoolDormitoryTelephone)
				.setParameter("schoolCounselorTelephone", schoolCounselorTelephone)
				.setParameter("schoolEnrollmentDate",schoolEnrollmentDate )
				.setParameter("schoolExpectedDate", schoolExpectedDate)
				.setParameter("schoolAddress", schoolAddress)
				.setParameter("schoolTownship", schoolTownship)
				.setParameter("schoolStreet", schoolStreet)
				.setParameter("schoolCommunity", schoolCommunity)
				.setParameter("schoolRoomNo", schoolRoomNo));
	}
	
	
	public String getCustomerId() {
		return customerId;
	}

	public void setCustomerId(String customerId) {
		this.customerId = customerId;
	}

	public String getSchoolName() {
		return schoolName;
	}

	public void setSchoolName(String schoolName) {
		this.schoolName = schoolName;
	}

	public String getSchoolCollege() {
		return schoolCollege;
	}

	public void setSchoolCollege(String schoolCollege) {
		this.schoolCollege = schoolCollege;
	}

	public String getSchoolDepartment() {
		return schoolDepartment;
	}

	public void setSchoolDepartment(String schoolDepartment) {
		this.schoolDepartment = schoolDepartment;
	}

	public String getSchoolProfessionalName() {
		return schoolProfessionalName;
	}

	public void setSchoolProfessionalName(String schoolProfessionalName) {
		this.schoolProfessionalName = schoolProfessionalName;
	}

	public String getSchoolClass() {
		return schoolClass;
	}

	public void setSchoolClass(String schoolClass) {
		this.schoolClass = schoolClass;
	}

	public String getSchoolStudentNo() {
		return schoolStudentNo;
	}

	public void setSchoolStudentNo(String schoolStudentNo) {
		this.schoolStudentNo = schoolStudentNo;
	}

	public String getSchoolLearning() {
		return schoolLearning;
	}

	public void setSchoolLearning(String schoolLearning) {
		this.schoolLearning = schoolLearning;
	}

	public String getSchoolStatusStudent() {
		return schoolStatusStudent;
	}

	public void setSchoolStatusStudent(String schoolStatusStudent) {
		this.schoolStatusStudent = schoolStatusStudent;
	}

	public String getSchoolDegreeCategory() {
		return schoolDegreeCategory;
	}

	public void setSchoolDegreeCategory(String schoolDegreeCategory) {
		this.schoolDegreeCategory = schoolDegreeCategory;
	}

	public String getSchoolLength() {
		return schoolLength;
	}

	public void setSchoolLength(String schoolLength) {
		this.schoolLength = schoolLength;
	}

	public String getSchoolLevel() {
		return schoolLevel;
	}

	public void setSchoolLevel(String schoolLevel) {
		this.schoolLevel = schoolLevel;
	}

	public String getSchoolDormitoryTelephone() {
		return schoolDormitoryTelephone;
	}

	public void setSchoolDormitoryTelephone(String schoolDormitoryTelephone) {
		this.schoolDormitoryTelephone = schoolDormitoryTelephone;
	}

	public String getSchoolCounselorTelephone() {
		return schoolCounselorTelephone;
	}

	public void setSchoolCounselorTelephone(String schoolCounselorTelephone) {
		this.schoolCounselorTelephone = schoolCounselorTelephone;
	}

	public String getSchoolEnrollmentDate() {
		return schoolEnrollmentDate;
	}
	public void setSchoolEnrollmentDate(String schoolEnrollmentDate) {
		this.schoolEnrollmentDate = schoolEnrollmentDate;
	}

	public String getSchoolExpectedDate() {
		return schoolExpectedDate;
	}

	public void setSchoolExpectedDate(String schoolExpectedDate) {
		this.schoolExpectedDate = schoolExpectedDate;
	}

	public String getSchoolAddress() {
		return schoolAddress;
	}

	public void setSchoolAddress(String schoolAddress) {
		this.schoolAddress = schoolAddress;
	}

	public String getSchoolTownship() {
		return schoolTownship;
	}

	public void setSchoolTownship(String schoolTownship) {
		this.schoolTownship = schoolTownship;
	}

	public String getSchoolStreet() {
		return schoolStreet;
	}

	public void setSchoolStreet(String schoolStreet) {
		this.schoolStreet = schoolStreet;
	}

	public String getSchoolCommunity() {
		return schoolCommunity;
	}

	public void setSchoolCommunity(String schoolCommunity) {
		this.schoolCommunity = schoolCommunity;
	}

	public String getSchoolRoomNo() {
		return schoolRoomNo;
	}

	public void setSchoolRoomNo(String schoolRoomNo) {
		this.schoolRoomNo = schoolRoomNo;
	}
	
	
}
