package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DelDocFile extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception
	{
		//自动获得传入的参数值;
		String sTableName = (String)this.getAttribute("TableName");//--表名
		String sWhereClause = (String)this.getAttribute("WhereClause");
		
		if(sTableName == null) sTableName = "";
		if(sWhereClause == null) sWhereClause = "1=2";

		//定义变量
		ASResultSet rs = null;	
		String sFullPath = "";
		String sSql = "";
		//获得文件存储路径
		sSql = " select fullpath from " + sTableName + " where "+ sWhereClause ; 	
		
		rs = Sqlca.getASResultSet(sSql);
		//可删除多选
		while(rs.next())
		{
			sFullPath = rs.getStringValue(1);				
			if(sFullPath==null) sFullPath="";		
			java.io.File file = new java.io.File(sFullPath);
			try{
				file.delete();
			}catch(Exception e){
				ARE.getLog().error(e.getMessage(),e);
			}
		}
		rs.getStatement().close();
		return null;
	}
}
