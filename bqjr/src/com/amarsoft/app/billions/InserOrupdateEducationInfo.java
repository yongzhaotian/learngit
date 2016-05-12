package com.amarsoft.app.billions;

import java.sql.SQLException;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class InserOrupdateEducationInfo {
private String putoutno;	
private String course_education_training1;
private String course_education_training2;
private String course_start_time1        ;
private String course_start_time2        ;
private String course_consultant_name1   ;
private String course_consultant_phone1  ; 
private String is_probation1             ;
private String probation_time1           ;
private String course_remarks1           ;
private String course_consultant_name2   ;
private String course_consultant_phone2  ;
private String is_probation2             ;
private String probation_time2           ;
private String course_remarks2           ;
private String school_name               ;
private String school_college            ;
private String school_department         ;
private String school_professional_name  ;
private String school_class              ;
private String school_student_no         ;
private String school_learning           ;
private String school_status_student     ;
private String school_length             ;
private String school_level              ;
private String school_dormitory_telephone;
private String school_counselor_telephone;
private String school_enrollment_date    ;
private String school_expected_date      ;
private String school_address            ;
private String school_township           ;
private String school_street             ;
private String school_community          ;
private String school_room_no            ;
private String school_mailing_address    ;
private String family_parents_name       ;
private String family_parents_relations  ;
private String family_parents_telephone  ;
private String family_parents_fixedline  ;
private String family_parents_company    ;
private String family_parents_companytel ;
private String family_parents_position   ;
private String family_parents_city       ;
private String family_parents_xiang      ;
private String family_parents_village    ;
private String family_parents_community  ;
private String family_parents_room_no    ;
private String family_parents_isloan     ;
private String family_other_name         ;
private String family_other_relations    ;
private String family_other_telephone    ;
private String other_contact_name        ;
private String other_contact_relations   ;
private String other_contact_telephone   ;
private String monthly_income_total      ;
private String monthly_income_source     ;
private String monthly_income_payments   ;
private String monthly_income_other      ;
private String monthly_income_expenditure;
private String monthly_income_record     ;
private String createby                  ;
private String createdate                ;
private String updateby                  ;
private String updatedate                ;
private String school_degree_category    ;
public String getPutoutno() {
	return putoutno;
}
public void setPutoutno(String putoutno) {
	this.putoutno = putoutno;
}
public String getCourse_education_training1() {
	return course_education_training1;
}
public void setCourse_education_training1(String course_education_training1) {
	this.course_education_training1 = course_education_training1;
}
public String getCourse_education_training2() {
	return course_education_training2;
}
public void setCourse_education_training2(String course_education_training2) {
	this.course_education_training2 = course_education_training2;
}
public String getCourse_start_time1() {
	return course_start_time1;
}
public void setCourse_start_time1(String course_start_time1) {
	this.course_start_time1 = course_start_time1;
}
public String getCourse_start_time2() {
	return course_start_time2;
}
public void setCourse_start_time2(String course_start_time2) {
	this.course_start_time2 = course_start_time2;
}
public String getCourse_consultant_name1() {
	return course_consultant_name1;
}
public void setCourse_consultant_name1(String course_consultant_name1) {
	this.course_consultant_name1 = course_consultant_name1;
}
public String getCourse_consultant_phone1() {
	return course_consultant_phone1;
}
public void setCourse_consultant_phone1(String course_consultant_phone1) {
	this.course_consultant_phone1 = course_consultant_phone1;
}
public String getIs_probation1() {
	return is_probation1;
}
public void setIs_probation1(String is_probation1) {
	this.is_probation1 = is_probation1;
}
public String getProbation_time1() {
	return probation_time1;
}
public void setProbation_time1(String probation_time1) {
	this.probation_time1 = probation_time1;
}
public String getCourse_remarks1() {
	return course_remarks1;
}
public void setCourse_remarks1(String course_remarks1) {
	this.course_remarks1 = course_remarks1;
}
public String getCourse_consultant_name2() {
	return course_consultant_name2;
}
public void setCourse_consultant_name2(String course_consultant_name2) {
	this.course_consultant_name2 = course_consultant_name2;
}
public String getCourse_consultant_phone2() {
	return course_consultant_phone2;
}
public void setCourse_consultant_phone2(String course_consultant_phone2) {
	this.course_consultant_phone2 = course_consultant_phone2;
}
public String getIs_probation2() {
	return is_probation2;
}
public void setIs_probation2(String is_probation2) {
	this.is_probation2 = is_probation2;
}
public String getProbation_time2() {
	return probation_time2;
}
public void setProbation_time2(String probation_time2) {
	this.probation_time2 = probation_time2;
}
public String getCourse_remarks2() {
	return course_remarks2;
}
public void setCourse_remarks2(String course_remarks2) {
	this.course_remarks2 = course_remarks2;
}
public String getSchool_name() {
	return school_name;
}
public void setSchool_name(String school_name) {
	this.school_name = school_name;
}
public String getSchool_college() {
	return school_college;
}
public void setSchool_college(String school_college) {
	this.school_college = school_college;
}
public String getSchool_department() {
	return school_department;
}
public void setSchool_department(String school_department) {
	this.school_department = school_department;
}
public String getSchool_professional_name() {
	return school_professional_name;
}
public void setSchool_professional_name(String school_professional_name) {
	this.school_professional_name = school_professional_name;
}
public String getSchool_class() {
	return school_class;
}
public void setSchool_class(String school_class) {
	this.school_class = school_class;
}
public String getSchool_student_no() {
	return school_student_no;
}
public void setSchool_student_no(String school_student_no) {
	this.school_student_no = school_student_no;
}
public String getSchool_learning() {
	return school_learning;
}
public void setSchool_learning(String school_learning) {
	this.school_learning = school_learning;
}
public String getSchool_status_student() {
	return school_status_student;
}
public void setSchool_status_student(String school_status_student) {
	this.school_status_student = school_status_student;
}
public String getSchool_length() {
	return school_length;
}
public void setSchool_length(String school_length) {
	this.school_length = school_length;
}
public String getSchool_level() {
	return school_level;
}
public void setSchool_level(String school_level) {
	this.school_level = school_level;
}
public String getSchool_dormitory_telephone() {
	return school_dormitory_telephone;
}
public void setSchool_dormitory_telephone(String school_dormitory_telephone) {
	this.school_dormitory_telephone = school_dormitory_telephone;
}
public String getSchool_counselor_telephone() {
	return school_counselor_telephone;
}
public void setSchool_counselor_telephone(String school_counselor_telephone) {
	this.school_counselor_telephone = school_counselor_telephone;
}
public String getSchool_enrollment_date() {
	return school_enrollment_date;
}
public void setSchool_enrollment_date(String school_enrollment_date) {
	this.school_enrollment_date = school_enrollment_date;
}
public String getSchool_expected_date() {
	return school_expected_date;
}
public void setSchool_expected_date(String school_expected_date) {
	this.school_expected_date = school_expected_date;
}
public String getSchool_address() {
	return school_address;
}
public void setSchool_address(String school_address) {
	this.school_address = school_address;
}
public String getSchool_township() {
	return school_township;
}
public void setSchool_township(String school_township) {
	this.school_township = school_township;
}
public String getSchool_street() {
	return school_street;
}
public void setSchool_street(String school_street) {
	this.school_street = school_street;
}
public String getSchool_community() {
	return school_community;
}
public void setSchool_community(String school_community) {
	this.school_community = school_community;
}
public String getSchool_room_no() {
	return school_room_no;
}
public void setSchool_room_no(String school_room_no) {
	this.school_room_no = school_room_no;
}
public String getSchool_mailing_address() {
	return school_mailing_address;
}
public void setSchool_mailing_address(String school_mailing_address) {
	this.school_mailing_address = school_mailing_address;
}
public String getFamily_parents_name() {
	return family_parents_name;
}
public void setFamily_parents_name(String family_parents_name) {
	this.family_parents_name = family_parents_name;
}
public String getFamily_parents_relations() {
	return family_parents_relations;
}
public void setFamily_parents_relations(String family_parents_relations) {
	this.family_parents_relations = family_parents_relations;
}
public String getFamily_parents_telephone() {
	return family_parents_telephone;
}
public void setFamily_parents_telephone(String family_parents_telephone) {
	this.family_parents_telephone = family_parents_telephone;
}
public String getFamily_parents_fixedline() {
	return family_parents_fixedline;
}
public void setFamily_parents_fixedline(String family_parents_fixedline) {
	this.family_parents_fixedline = family_parents_fixedline;
}
public String getFamily_parents_company() {
	return family_parents_company;
}
public void setFamily_parents_company(String family_parents_company) {
	this.family_parents_company = family_parents_company;
}
public String getFamily_parents_companytel() {
	return family_parents_companytel;
}
public void setFamily_parents_companytel(String family_parents_companytel) {
	this.family_parents_companytel = family_parents_companytel;
}
public String getFamily_parents_position() {
	return family_parents_position;
}
public void setFamily_parents_position(String family_parents_position) {
	this.family_parents_position = family_parents_position;
}
public String getFamily_parents_city() {
	return family_parents_city;
}
public void setFamily_parents_city(String family_parents_city) {
	this.family_parents_city = family_parents_city;
}
public String getFamily_parents_xiang() {
	return family_parents_xiang;
}
public void setFamily_parents_xiang(String family_parents_xiang) {
	this.family_parents_xiang = family_parents_xiang;
}
public String getFamily_parents_village() {
	return family_parents_village;
}
public void setFamily_parents_village(String family_parents_village) {
	this.family_parents_village = family_parents_village;
}
public String getFamily_parents_community() {
	return family_parents_community;
}
public void setFamily_parents_community(String family_parents_community) {
	this.family_parents_community = family_parents_community;
}
public String getFamily_parents_room_no() {
	return family_parents_room_no;
}
public void setFamily_parents_room_no(String family_parents_room_no) {
	this.family_parents_room_no = family_parents_room_no;
}
public String getFamily_parents_isloan() {
	return family_parents_isloan;
}
public void setFamily_parents_isloan(String family_parents_isloan) {
	this.family_parents_isloan = family_parents_isloan;
}
public String getFamily_other_name() {
	return family_other_name;
}
public void setFamily_other_name(String family_other_name) {
	this.family_other_name = family_other_name;
}
public String getFamily_other_relations() {
	return family_other_relations;
}
public void setFamily_other_relations(String family_other_relations) {
	this.family_other_relations = family_other_relations;
}
public String getFamily_other_telephone() {
	return family_other_telephone;
}
public void setFamily_other_telephone(String family_other_telephone) {
	this.family_other_telephone = family_other_telephone;
}
public String getOther_contact_name() {
	return other_contact_name;
}
public void setOther_contact_name(String other_contact_name) {
	this.other_contact_name = other_contact_name;
}
public String getOther_contact_relations() {
	return other_contact_relations;
}
public void setOther_contact_relations(String other_contact_relations) {
	this.other_contact_relations = other_contact_relations;
}
public String getOther_contact_telephone() {
	return other_contact_telephone;
}
public void setOther_contact_telephone(String other_contact_telephone) {
	this.other_contact_telephone = other_contact_telephone;
}
public String getMonthly_income_total() {
	return monthly_income_total;
}
public void setMonthly_income_total(String monthly_income_total) {
	this.monthly_income_total = monthly_income_total;
}
public String getMonthly_income_source() {
	return monthly_income_source;
}
public void setMonthly_income_source(String monthly_income_source) {
	this.monthly_income_source = monthly_income_source;
}
public String getMonthly_income_payments() {
	return monthly_income_payments;
}
public void setMonthly_income_payments(String monthly_income_payments) {
	this.monthly_income_payments = monthly_income_payments;
}
public String getMonthly_income_other() {
	return monthly_income_other;
}
public void setMonthly_income_other(String monthly_income_other) {
	this.monthly_income_other = monthly_income_other;
}
public String getMonthly_income_expenditure() {
	return monthly_income_expenditure;
}
public void setMonthly_income_expenditure(String monthly_income_expenditure) {
	this.monthly_income_expenditure = monthly_income_expenditure;
}
public String getMonthly_income_record() {
	return monthly_income_record;
}
public void setMonthly_income_record(String monthly_income_record) {
	this.monthly_income_record = monthly_income_record;
}
public String getCreateby() {
	return createby;
}
public void setCreateby(String createby) {
	this.createby = createby;
}
public String getCreatedate() {
	return createdate;
}
public void setCreatedate(String createdate) {
	this.createdate = createdate;
}
public String getUpdateby() {
	return updateby;
}
public void setUpdateby(String updateby) {
	this.updateby = updateby;
}
public String getUpdatedate() {
	return updatedate;
}
public void setUpdatedate(String updatedate) {
	this.updatedate = updatedate;
}
public String getSchool_degree_category() {
	return school_degree_category;
}
public void setSchool_degree_category(String school_degree_category) {
	this.school_degree_category = school_degree_category;
}

public String InserOrupdateEducationInfoByServerNo(Transaction sqlca){
	if (putoutno == null) {
		throw new RuntimeException("请传入合同号！");
	}
	try {
		String sql = "insert  into BUSINESS_EDUCATION_INFO INFO1  (info1.putoutno  "
				+",info1.course_education_training1"
				+",info1.course_education_training2"
				+",info1.course_start_time1        "
				+",info1.course_start_time2        "
				+",info1.course_consultant_name1   "
				+",info1.course_consultant_phone1  "
				+",info1.is_probation1             "
				+",info1.probation_time1           "
				+",info1.course_remarks1           "
				+",info1.course_consultant_name2   "
				+",info1.course_consultant_phone2  "
				+",info1.is_probation2             "
				+",info1.probation_time2           "
				+",info1.course_remarks2           "
				+",info1.createby                  "
				+",info1.createdate                "
				+",info1.updateby                  "
				+",info1.updatedate                "
				+",info1.school_degree_category    "
				+ ") VALUES ("+getvalus(putoutno)                      
				+","+getvalus(course_education_training1)    
				+","+getvalus(course_education_training2)  
				+","+getvalus(course_start_time1)          
				+","+getvalus(course_start_time2)            
				+","+getvalus(course_consultant_name1)      
				+","+getvalus(course_consultant_phone1)     
				+","+getvalus(is_probation1 )                
				+","+getvalus(probation_time1)           
				+","+getvalus(course_remarks1)              
				+","+getvalus(course_consultant_name2 )     
				+","+getvalus(course_consultant_phone2 )     
				+","+getvalus(is_probation2  )               
				+","+getvalus(probation_time2)             
				+","+getvalus(course_remarks2  )             
				+","+getvalus(createby )                     
				+",to_char(sysdate,'yyyy/MM/dd')"    
				+","+getvalus(updateby)                       
				+",to_char(sysdate,'yyyy/MM/dd')"    
				+","+getvalus(school_degree_category )    
				+ ")";
		sqlca.executeSQL(new SqlObject(sql));
	} catch (SQLException e) {
		
		e.printStackTrace();
	} catch (Exception e) {
		e.printStackTrace();
	}
	System.out.println("退保申请成功");
	
	return "";
}
public String updateEducationInfoByServerNo(Transaction sqlca){
	if (putoutno == null) {
		throw new RuntimeException("请传入合同号！");
	}
	try {
		String sql ="UPDATE BUSINESS_EDUCATION_INFO INFO1 set"
				+" info1.putoutno                     = "+getvalus(putoutno)                                  
				+",info1.course_education_training1     ="+getvalus(course_education_training1) 
				+",info1.course_education_training2     ="+getvalus(course_education_training2) 
				+",info1.course_start_time1             ="+getvalus(course_start_time1 )        
				+",info1.course_start_time2             ="+getvalus(course_start_time2 )       
				+",info1.course_consultant_name1        ="+getvalus(course_consultant_name1 )  
				+",info1.course_consultant_phone1       ="+getvalus(course_consultant_phone1 )  
				+",info1.is_probation1                  ="+getvalus(is_probation1 )             
				+",info1.probation_time1                ="+getvalus(probation_time1)           
				+",info1.course_remarks1                ="+getvalus(course_remarks1 )           
				+",info1.course_consultant_name2        ="+getvalus(course_consultant_name2 )  
				+",info1.course_consultant_phone2       ="+getvalus(course_consultant_phone2)   
				+",info1.is_probation2                  ="+getvalus(is_probation2 )            
				+",info1.probation_time2                ="+getvalus(probation_time2)           
				+",info1.course_remarks2                ="+getvalus(course_remarks2)            
				+",info1.updateby                       ="+getvalus(updateby)                  
				+",info1.updatedate                     =to_char(sysdate,'yyyy/MM/dd')"
				+"WHERE INFO1.PUTOUTNO = "+getvalus(putoutno);
		sqlca.executeSQL(new SqlObject(sql));
	} catch (SQLException e) {
		
		e.printStackTrace();
	} catch (Exception e) {
		e.printStackTrace();
	}
	return "";
	}
	private String getvalus(String val){
		if(null==val){
			return val;
		}
		if("undefined".equals(val)){
			return null;
		}
		
		return "'"+val+"'";
	}
}
