package com.amarsoft.app.billions;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.util.DBKeyUtils;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class IsRepeatEducationInfo {
private String putoutno;	


public String getPutoutno() {
	return putoutno;
}
public void setPutoutno(String putoutno) {
	this.putoutno = putoutno;
}
/**
 * 判断是否有相同的电话号码
 * @param sqlca
 * @return
 */
public String InserOrupdateEducationInfoByServerNo(Transaction sqlca){
	if (putoutno == null) {
		throw new RuntimeException("请传入合同号！");
	}
	try {
		/** --update Object_Maxsn取号优化 tangyb 20150817 start-- 
		String sRelativeSerialNo1 = DBKeyHelp.getSerialNo("Phone_Info","SerialNo",sqlca);*/
		String sRelativeSerialNo1 = DBKeyUtils.getSerialNo("PI");
		/** --end --*/
	} catch (Exception e1) {
		
	}
	String isFlase="K";
	ASResultSet rs = null;
	try {
		List list = new ArrayList();
		String sql = "select con.phone,"+
		       "  ii.family_parents_companytel,"+
		       "  ii.family_parents_telephone,"+
		       "  info.school_counselor_telephone,"+
		       "  info.course_consultant_phone1,"+
		       "  info.school_dormitory_telephone,"+
		       "  info.other_contact_telephone,"+
		       "  info.family_parents_companytel,"+
		       /*"  ii.phonevalidate,"+*/
		       "  ii.familytel,"+
		       "  ii.mobiletelephone,"+
		       "  ii.worktel,"+
		       "  ii.worktelmain,"+
		       "  ii.spousetel,"+
		       "  ii.spouseworktel,"+
		       "  ii.kinshiptel,"+
		       "  ii.contacttel,"+
		       "  ii.spouse_is_tel"+
		       "  from business_education_info info, business_contract con, ind_info ii"+
		  " where con.serialno = info.putoutno"+
		  "  and con.serialno = "+putoutno+
		  " and ii.customerid = con.customerid";
		rs= sqlca.getASResultSet(new SqlObject(sql));
		if(rs.next()){
		String phone =DataConvert.toString(rs.getString("phone"));
		String family_parents_telephone =DataConvert.toString(rs.getString("family_parents_telephone"));
		String school_counselor_telephone =DataConvert.toString(rs.getString("school_counselor_telephone"));
		String course_consultant_phone1 =DataConvert.toString(rs.getString("course_consultant_phone1"));
		String school_dormitory_telephone =DataConvert.toString(rs.getString("school_dormitory_telephone"));
		String other_contact_telephone =DataConvert.toString(rs.getString("other_contact_telephone"));
		String family_parents_companytel =DataConvert.toString(rs.getString("family_parents_companytel"));
		//String phonevalidate =DataConvert.toString(rs.getString("phonevalidate"));
		String familytel =DataConvert.toString(rs.getString("familytel"));
		String mobiletelephone =DataConvert.toString(rs.getString("mobiletelephone"));
		String worktel =DataConvert.toString(rs.getString("worktel"));
		String worktelmain =DataConvert.toString(rs.getString("worktelmain"));
		String spousetel =DataConvert.toString(rs.getString("spousetel"));
		String spouseworktel =DataConvert.toString(rs.getString("spouseworktel"));
		String kinshiptel =DataConvert.toString(rs.getString("kinshiptel"));
		String contacttel =DataConvert.toString(rs.getString("contacttel"));
		String spouse_is_tel =DataConvert.toString(rs.getString("spouse_is_tel"));
	    String customerId=putoutno.substring(0,8);
		list.add(phone);
		list.add(school_counselor_telephone);
		edurun(sqlca,customerId,family_parents_telephone,"130");///父/母联系电话 
		list.add(course_consultant_phone1);
		edurun(sqlca,customerId,course_consultant_phone1,"160");//课程顾问电话
		list.add(school_dormitory_telephone);
		list.add(other_contact_telephone);
		list.add(family_parents_companytel);
		edurun(sqlca,customerId,family_parents_companytel,"150");//父母单位电话
		//list.add(phonevalidate);
		list.add(familytel);
//		edurun(sqlca,customerId,familytel,"140");//家庭固话
		list.add(mobiletelephone);
		list.add(worktel);
		list.add(worktelmain);
		list.add(spousetel);
		list.add(spouseworktel);
		list.add(kinshiptel);
		list.add(contacttel);
		list.add(spouse_is_tel);

		}
		
		/**
		 * 第一个和第二个对比
		 */
		for (int i = 0; i < list.size(); i++) {
			for (int j = i+1; j < list.size(); j++) {
				if(list.get(i) !=null &&list.get(j)!=null&&!"".equals(list.get(i))&&!"".equals(list.get(j))){
					if(list.get(i).equals(list.get(j))){
						isFlase="F";
						break;
					}
				}
			}
		}
		
	} catch (Exception e) {
		e.printStackTrace();
	}finally{
		try {
			if(rs!=null){
			rs.close();
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return isFlase;
	}
	
}
/**
 * 插入电话创库
 * @param Sqlca
 * @param st2 客户号
 * @param st3 电话号码
 * @param st4 code
 * @throws Exception
 */
private void edurun(Transaction Sqlca,String st2,String st3,String st4) throws Exception{
	/** --update Object_Maxsn取号优化 tangyb 20150817 start-- 
	String st1 = DBKeyHelp.getSerialNo("PHONE_INFO","SerialNo",Sqlca);*/
	String st1 = DBKeyUtils.getSerialNo("PI");
	/** --end --*/
	//将空值转化为空字符串
	if(st1 == null) st1 = "";
	if(st2 == null) st2 = "";
	if(st3 == null) st3 = "";
	if(st4 == null) st4 = "";
	
	String sSql = "";
	ASResultSet rs = null;
	SqlObject so;
	//
	sSql = "select serialno from phone_info where phonecode=:phonecode and relation=:relation and customerid=:customerid ";
	so = new SqlObject(sSql).setParameter("phonecode", st3).setParameter("customerid", st2).setParameter("relation",st4);
	rs = Sqlca.getASResultSet(so);
	if(rs.next()) 
	{
		String serialno=rs.getString("serialno");
		if(serialno == null) serialno = "";
		
        //如果存在数据，更新
		sSql=" update phone_info set phonecode=:phonecode,customerid=:customerid where serialno=:serialno ";
		so = new SqlObject(sSql);
		so.setParameter("phonecode", st3).setParameter("customerid", st2).setParameter("serialno", serialno);
		Sqlca.executeSQL(so);
	}else{//不存在，插入数据
		sSql = "insert into phone_info(serialno,customerid,phonecode,relation) values(:SerialNo,:CustomerID,:PhoneCode,:Relation)";
		so = new SqlObject(sSql);
		so.setParameter("SerialNo", st1).setParameter("CustomerID", st2).setParameter("PhoneCode", st3).setParameter("Relation", st4);
		Sqlca.executeSQL(so);	
	}
	rs.getStatement().close();

}	

}
