package com.amarsoft.app.lending.bizlets;
import com.amarsoft.app.als.sadre.util.DateUtil;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.dict.als.cache.CodeCache;

public class CPDFeeManage extends Bizlet {
	
	
	/**
	 * 引入已经定义的组件到产品中
	 * @return
	 * @throws Exception
	 */
	public  String run(Transaction Sqlca) throws Exception{
		String termID = DataConvert.toString((String) this.getAttribute("TermID"));
		String productID = DataConvert.toString((String) this.getAttribute("ProductID"));
		String versionID = DataConvert.toString((String) this.getAttribute("VersionID"));
		String parentTermID = DataConvert.toString((String) this.getAttribute("ParentTermID"));
		String SubTermType = DataConvert.toString((String) this.getAttribute("SubTermType"));
		String userid = DataConvert.toString((String) this.getAttribute("userid"));
		String OperateUserID = DataConvert.toString((String) this.getAttribute("OperateUserID"));
		
		String ObjectNo = productID+"-"+"V1.0";
		
		this.deleteTermFromProductCPD(Sqlca);//删除原有关联

		//插入组件
		String sql = "insert into PRODUCT_TERM_PARA " +
				"( ObjectType,ObjectNo,TERMID,PARAID,DATATYPE,VALUELIST,REFTABLENAME,REFCOLUMNNAME,DEFAULTVALUE,MAXVALUE,MINVALUE,APERMISSION,VALUECODE,PARANAME,STATUS," +
				"INPUTORGID,INPUTUSERID,INPUTDATE,UPDATEDATE,PPERMISSION,SORTNO,VALUELISTNAME,MATCHFLAG) " +
				"select 'Product','"+ObjectNo+"',TermID,PARAID,DATATYPE,VALUELIST,REFTABLENAME,REFCOLUMNNAME,DEFAULTVALUE,MAXVALUE,MINVALUE,APERMISSION,VALUECODE," +
				" PARANAME,STATUS,INPUTORGID,INPUTUSERID,INPUTDATE,UPDATEDATE,PPERMISSION,SORTNO,VALUELISTNAME,MATCHFLAG from PRODUCT_TERM_PARA " +
				" where ObjectType='Term' and ObjectNo = :termID and TermID like :termID1";
		Sqlca.executeSQL(new SqlObject(sql).setParameter("termID", termID).setParameter("termID1", termID+"%"));
		
		sql = "insert into PRODUCT_TERM_LIBRARY " +
				"(OBJECTTYPE,OBJECTNO,TERMID,TERMNAME,TERMTYPE,SETFLAG,PPERMISSION,APERMISSION,TERMTXT,STATUS,INPUTORGID,INPUTUSERID,INPUTDATE,UPDATEDATE,REMARK,SORTNO,BASETERMID,ACTIVEDATE,CLOSEDATE,SUBTERMTYPE) " +
				" select 'Product','"+ObjectNo+"',TermID,TermName,TERMTYPE,SETFLAG,PPERMISSION,APERMISSION,TERMTXT,STATUS,INPUTORGID,INPUTUSERID,INPUTDATE,UPDATEDATE,REMARK,SORTNO,BASETERMID,ACTIVEDATE,CLOSEDATE,SUBTERMTYPE" +
				" from PRODUCT_TERM_LIBRARY " +
				" where ObjectType='Term' and ObjectNo = :termID and TermID like :termID1";
		Sqlca.executeSQL(new SqlObject(sql).setParameter("termID", termID).setParameter("termID1", termID+"%"));
		
		if(SubTermType.equals("A10")){
			this.CPDDelayFine(productID,termID,userid,OperateUserID, Sqlca);//插入滞纳金 往code_library.codeno='DelayFine',一个产品关联一条code_library
		}
		
		return "true";
	}
	
	private void CPDDelayFine(String productID,String termID,String userid,String OperateUserID,Transaction Sqlca) throws Exception {
		ASResultSet rs_CPDOPara = null;
		ASResultSet rs_DelayFine = null;
		ASResultSet rs_CPDFeeCalType = null;
		SqlObject so;
		String ObjectNo = productID+"-"+"V1.0";
		String itemNo = productID+"-"+termID;
		int codecount = 0;
		
		String CPDparas = "";
		String select_CPDPara = "select paraid,defaultvalue,termid from product_term_para where objectno=:ObjectNo and termid=:termID and objecttype='Product' and sortno like 'B%' order by sortno ";
		String select_CPDFeeCalType = "select defaultvalue from product_term_para where objectno=:ObjectNo and termid=:termID and PARAID='CPDFeeCalType' and objecttype='Product' and sortno like 'A%' order by sortno ";
		
		String Sql_insert = "insert into code_library (CODENO, ITEMNO, ITEMNAME, BANKNO, SORTNO, ISINUSE,ITEMDESCRIBE,ATTRIBUTE1,ATTRIBUTE2,INPUTUSER, INPUTORG, INPUTTIME, UPDATEUSER, UPDATETIME) "
											+ "values ('DelayFine', :ITEMNO, '滞纳金', '01', '01','1',:ITEMDESCRIBE,:ATTRIBUTE1,:ATTRIBUTE2,'"+userid+"', '"+OperateUserID+"', '"+DateUtil.getToday()+"', '"+userid+"','"+DateUtil.getToday()+"') ";
			
		String Sql_update = "update code_library set ITEMDESCRIBE=:ITEMDESCRIBE,ISINUSE='1',ATTRIBUTE1=:ATTRIBUTE1,ATTRIBUTE2=:ATTRIBUTE2,UPDATEUSER='"+userid+"',UPDATETIME='"+DateUtil.getToday()+"' where codeno='DelayFine' and ITEMNO=:ITEMNO ";
		
		String Sql_DelayFine = "select count(*) as codecount from code_library where codeno='DelayFine' and ITEMNO=:ITEMNO ";

		so = new SqlObject(select_CPDPara).setParameter("ObjectNo", ObjectNo).setParameter("termID", termID);
		rs_CPDOPara = Sqlca.getASResultSet(so);
		int j = 1;
		while(rs_CPDOPara.next()){
			String paraid = rs_CPDOPara.getString("paraid");
			String defaultvalue = rs_CPDOPara.getString("defaultvalue");
		    
			if(paraid==null&&defaultvalue==null) continue;
			
			if(j%2==0){
				CPDparas += defaultvalue + "@";
			}else{
				CPDparas += defaultvalue + ",";
			}
			
			j++;
		}
		
		rs_CPDOPara.getStatement().close();
		
		//取出原有的滞纳金逾期参数
		so = new SqlObject(Sql_DelayFine).setParameter("ITEMNO", productID);
		rs_DelayFine = Sqlca.getASResultSet(so);
		
		while(rs_DelayFine.next()){
			codecount = rs_DelayFine.getInt(1);
		}
		rs_DelayFine.getStatement().close();
		
		so = new SqlObject(select_CPDFeeCalType).setParameter("ObjectNo", ObjectNo).setParameter("termID", termID);
		rs_CPDFeeCalType = Sqlca.getASResultSet(so);
		String CPDFeeCalType = "";//默认为01
		while(rs_CPDFeeCalType.next()){
			CPDFeeCalType = rs_CPDFeeCalType.getString("defaultvalue");
			if(CPDFeeCalType==null) CPDFeeCalType = "01";
		}
		rs_CPDFeeCalType.getStatement().close();
		
		if(codecount>0){
			so = new SqlObject(Sql_update).setParameter("ITEMNO", productID).setParameter("ITEMDESCRIBE", CPDparas).setParameter("ATTRIBUTE1", termID).setParameter("ATTRIBUTE2", CPDFeeCalType);
			Sqlca.executeSQL(so);
		}else{
			so = new SqlObject(Sql_insert).setParameter("ITEMNO", productID).setParameter("ITEMDESCRIBE", CPDparas).setParameter("ATTRIBUTE1", termID).setParameter("ATTRIBUTE2", CPDFeeCalType);
			Sqlca.executeSQL(so);
		}
		
	}

	public String deleteTermFromProductCPD(Transaction Sqlca) throws Exception{
		String termID = DataConvert.toString((String) this.getAttribute("TermID"));
		String productID = DataConvert.toString((String) this.getAttribute("ProductID"));
		String versionID = DataConvert.toString((String) this.getAttribute("VersionID"));
		String ObjectNo = productID+"-"+"V1.0";
		//删除之前的组件参数,以免无法引入
		String sql="delete from PRODUCT_TERM_PARA where TermID like :termID and ObjectType = 'Product' and  ObjectNo = :ObjectNo";
		Sqlca.executeSQL(new SqlObject(sql).setParameter("termID", termID+"%").setParameter("ObjectNo", ObjectNo));
		
		//删除组件本身
		sql="delete from PRODUCT_TERM_LIBRARY where TermID like :termID and ObjectType = 'Product' and  ObjectNo = :ObjectNo";
		Sqlca.executeSQL(new SqlObject(sql).setParameter("termID", termID+"%").setParameter("ObjectNo", ObjectNo));
		
		//删除组件关联
		sql="delete from PRODUCT_TERM_RELATIVE where TermID like :termID and ObjectType = 'Product' and  ObjectNo = :ObjectNo";
		Sqlca.executeSQL(new SqlObject(sql).setParameter("termID", termID+"%").setParameter("ObjectNo", ObjectNo));
		
		return "success";
	}

}
