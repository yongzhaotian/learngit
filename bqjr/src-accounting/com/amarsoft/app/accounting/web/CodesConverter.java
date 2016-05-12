package com.amarsoft.app.accounting.web;

import java.sql.SQLException;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * 
 * @author hyzhang1
 *将多选代码转换为对应名称
 */
public class CodesConverter {
	public static String Convert(Transaction Sqlca,String codeno,String codes,String spliter) throws SQLException{
		String sResult="";
		String sSql="";
		ASResultSet rs=null;
		if(codes==null) codes="";
		if(!"".equals(codes)){
			codes=codes.replace(spliter, "','");
		}
		if(codes.endsWith(",")){
			codes=codes.substring(0, codes.length()-1);
		}
		sSql="select ItemName from Code_library where codeno='"+codeno+"' and ItemNo in ('"+codes+"')";
		rs=Sqlca.getASResultSet(new SqlObject(sSql));
		int count=1;
		while(rs.next()){
			sResult+=(count++)+"."+rs.getString("ItemName")+";";
		}
		rs.getStatement().close();
		return sResult;
	}
}
