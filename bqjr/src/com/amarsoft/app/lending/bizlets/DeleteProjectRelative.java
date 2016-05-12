package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DeleteProjectRelative extends Bizlet 
{

	 public Object  run(Transaction Sqlca) throws Exception
	 {
		//自动获得传入的参数值
	    //传入的参数不需要加入单引号，非传入的变量和原来的参数变量做同样的处理
	    ASResultSet rs = null;
		String sProjectNo    = (String)this.getAttribute("ProjectNo");
		String sObjectType   = (String)this.getAttribute("ObjectType");
		String sObjectNo     = (String)this.getAttribute("ObjectNo");
		
		//将空值转化成空字符串
		if(sProjectNo == null) sProjectNo = "";
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		
		//定义变量
	    String sSql = "";
	    SqlObject so ;//声明对象
	    int iCount = 0;
		if (sObjectType.equals("Customer"))
		 {
			sSql = " select count(ProjectNo) from Project_Relative where ProjectNo=:ProjectNo and " +
    		 " (ObjectType ='CreditApply' or ObjectType ='AfterLoan') and ObjectNo =:ObjectNo ";
			so = new SqlObject(sSql).setParameter("ProjectNo", sProjectNo).setParameter("ObjectNo", sObjectNo);
            rs = Sqlca.getResultSet(so);
	  	      if(rs.next())
	  	      {
	  	    	iCount = rs.getInt(1);
	  	      }
	  	    
	  	      rs.getStatement().close();
	  	      if (iCount>0)
	  	      {
	  	    	  ARE.getLog().info("此项目已经与业务信息相关联，不能删除！");
	  	      }
	  	      else
	  	      {
	  	    	//执行删除语句
	  	    	//删除主信息
	  	    	sSql = " delete from  Project_Info where PROJECTNO =:PROJECTNO ";
	  	    	so = new SqlObject(sSql).setParameter("PROJECTNO", sProjectNo);
	  	    	Sqlca.executeSQL(so);
	  			//删除项目进展情况
	  	    	sSql = " delete from  PROJECT_PROGRESS where PROJECTNO =:PROJECTNO ";
	  	    	so = new SqlObject(sSql).setParameter("PROJECTNO", sProjectNo);
	  	    	Sqlca.executeSQL(so);
	  			//删除项目资金来源
	  	    	sSql = " delete from  PROJECT_FUNDS where PROJECTNO =:PROJECTNO ";
	  	    	so = new SqlObject(sSql).setParameter("PROJECTNO", sProjectNo);
	  			Sqlca.executeSQL(so);
	  			//删除项目投资概算
	  			sSql =" delete from  PROJECT_BUDGET where PROJECTNO =:PROJECTNO ";
	  			so = new SqlObject(sSql).setParameter("PROJECTNO", sProjectNo);
	  			Sqlca.executeSQL(so);	
	  	      }
		 }
		//如果是业务申请和贷后进行删除，只能是删除关联不能删除信息
		else
		{
			sSql = " delete from Project_Relative  where PROJECTNO =:PROJECTNO " +
			   " and ObjectType =:ObjectType and  ObjectNo =:ObjectNo ";
			so = new SqlObject(sSql).setParameter("PROJECTNO", sProjectNo).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		    Sqlca.executeSQL(so);
		}
	    return "aa"; 
	 }

}
