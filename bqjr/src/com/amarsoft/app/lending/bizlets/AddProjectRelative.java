package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class AddProjectRelative extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//自动获得传入的参数值	    
	    ASResultSet rs = null;
		String sProjectNo    = (String)this.getAttribute("ProjectNo");
		String sObjectType   = (String)this.getAttribute("ObjectType");
		//String sObjectNo     = (String)this.getAttribute("ObjectNo");
		SqlObject so = null;
		int iCount = 0;
		String sSql1 = null,sSql2 = null,sSql3 = null,sObjectNoadd="",sObjectNonew="";
		if (sObjectType.equals("Customer"))
		{
		   
		}else//业务申请和贷后插入数据时候，如果客户中没有此信息需要插入一条和客户关联的信息
		{
			sSql1=" select count(ProjectNo) from Project_Relative where ProjectNo=:ProjectNo and " +
		      " ObjectType ='Customer' ";
			  so = new SqlObject(sSql1).setParameter("ProjectNo", sProjectNo);
	          rs = Sqlca.getResultSet(so);
	  	      if(rs.next())
	  	      {
	  	    	iCount = rs.getInt(1);
	  	      }	  	      
	  	      rs.getStatement().close();
	  	      if (iCount>0)
	  	      {
	  	    	  ARE.getLog().info("此项目在业务信息中已经录入，不需要插入关联！");
	  	      }
	  	      //插入一条和客户关联的信息
	  	      else
	  	      {
	  	    	//查找申请书编号或合同号
	  	    	sSql3=" select ObjectNo from Project_Relative where ProjectNo=:ProjectNo order by ObjectNo DESC";
	  	    	  so = new SqlObject(sSql3).setParameter("ProjectNo", sProjectNo);
		          rs = Sqlca.getResultSet(so);
		  	      if(rs.next())
		  	      {
		  	    	sObjectNoadd = rs.getString(1);
		  	      }
		  	      rs.getStatement().close();	 
		  	      //首先到申请表中找客户代码
		  	    sSql3=" select CustomerID from Business_Apply where SerialNo =:SerialNo";
		  	    so = new SqlObject(sSql3).setParameter("SerialNo", sObjectNoadd);
			          rs = Sqlca.getResultSet(so);
			  	      if(rs.next())
			  	      {
			  	    	sObjectNonew = rs.getString(1);
			  	      }
			  	      rs.getStatement().close();	 
			  	 //如果申请表中没有客户代码到合同表中找
			  	 if (sObjectNonew==null || sObjectNonew.equals(""))
			  	 {
			  		sSql3=" select CustomerID from Business_Contract where SerialNo =:SerialNo";
			  		so = new SqlObject(sSql3).setParameter("SerialNo", sObjectNoadd);
			          rs = Sqlca.getResultSet(so);
			  	      if(rs.next())
			  	      {
			  	    	sObjectNonew = rs.getString(1);
			  	      }
			  	      rs.getStatement().close();	
			  		 
			  	 }
			  	sSql2="  insert into Project_Relative(ProjectNo,ObjectType,ObjectNo,Remark)" +
	    		  " values (:ProjectNo,'Customer',:ObjectNo,:Remark)";
			  	so = new SqlObject(sSql2).setParameter("ProjectNo", sProjectNo).setParameter("ObjectNo", sObjectNonew).setParameter("Remark", sObjectType);
			  	Sqlca.executeSQL(so);
	  	    	
	  	      }
		}
		return "aa";
	}

}
