package com.amarsoft.app.billions;

import com.amarsoft.are.ARE;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class CheckFormatDocID {
	
	
	private String objectNo;
	private String docID;


	public String getObjectNo() {
		return objectNo;
	}

	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}

	public String getDocID() {
		return docID;
	}

	public void setDocID(String docID) {
		this.docID = docID;
	}

	/**
	 * 根据当前合同关联的贷款人选择不同的模板
	 * @param Sqlca
	 * @return docID
	 */
	public String selectFormatDocID(Transaction Sqlca) {
//		处理逻辑如下：
//		1、	通过合同取门店
//		2、	通过门店取城市
//		3、	通过城市取贷款人
//		4、	通过合同取业务品种		
//		5、	通过贷款人和业务品种取对应报告
		try {
			String sSql = "";
			
			//获取门店城市
			sSql = "select city from store_info si "+
		    		" where si.identtype='01' and si.sno=(select STORES from Business_Contract where SerialNo = :SerialNo)";
		   String  sCity = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo", objectNo));
		   if(sCity==null) sCity="";
		    
		   //取贷款人
			sSql = "select SP.SerialNo "
					+ "from BaseDataSet_Info BI,Business_Contract BC,Service_Providers SP   where BI.ATTRSTR1 = BC.CREDITID and SP.SerialNo = BC.CREDITID and BI.ATTRSTR1 = SP.SerialNo  and BC.SerialNo ='"+objectNo+"'  and BI.BigValue like '%"+sCity+"%'  ";
			sSql = "select CreditID from Business_Contract where SerialNo = '"+objectNo+"'";
			String sSPSeialNoString = Sqlca.getString(new SqlObject(sSql));
			if(sSPSeialNoString==null) sSPSeialNoString="";
			ARE.getLog().info("贷款人编号："+sSPSeialNoString);
			
			//取业务品种
			sSql = "Select BusinessType From Business_Contract where SerialNo = '"+objectNo+"'";
			String  sBusinessType = Sqlca.getString(new SqlObject(sSql));
			if(sBusinessType==null) sBusinessType="";
			ARE.getLog().info("业务品种编号："+sBusinessType);
			
			//取模板编号
			sSql = "select DocID from FormatDoc_Version  where SPSerialNo= '"+sSPSeialNoString+"' and BusinessType = '"+sBusinessType+"' and isinuse = '1'";
			String sDocID =Sqlca.getString(new SqlObject(sSql));
			if(sDocID==null) sDocID="";
			ARE.getLog().info("模板编号："+sDocID);
			return sDocID;
		} catch (Exception e) { 
			e.printStackTrace(); 
			return "Failure";
		}
	}
	
	/**
	 * 根据格式化报告模板编号获取节点对应的jsp页面
	 * @param Sqlca
	 * @return docID
	 */
	public String selectFormatUrl(Transaction Sqlca) {

		try {
			//定义变量
			String sSql = "";
			ASResultSet rs = null;
			String  sUrl = "";
			//默认取第一个节点
			sSql = "select JspFileName  from FormatDoc_Def  "+
		    		" where DocID = '"+docID+"' order by dirid";
		    //获取jsp页面路径
			rs= Sqlca.getASResultSet(new SqlObject(sSql));
			if(rs.next()){
				sUrl = DataConvert.toString(rs.getString("JspFileName"));
			}
			rs.getStatement().close();
			return sUrl;
		} catch (Exception e) { 
			e.printStackTrace(); 
			return "Failure";
		}
	}
}
