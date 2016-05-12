package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class AddProjectRelative extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//�Զ���ô���Ĳ���ֵ	    
	    ASResultSet rs = null;
		String sProjectNo    = (String)this.getAttribute("ProjectNo");
		String sObjectType   = (String)this.getAttribute("ObjectType");
		//String sObjectNo     = (String)this.getAttribute("ObjectNo");
		SqlObject so = null;
		int iCount = 0;
		String sSql1 = null,sSql2 = null,sSql3 = null,sObjectNoadd="",sObjectNonew="";
		if (sObjectType.equals("Customer"))
		{
		   
		}else//ҵ������ʹ����������ʱ������ͻ���û�д���Ϣ��Ҫ����һ���Ϳͻ���������Ϣ
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
	  	    	  ARE.getLog().info("����Ŀ��ҵ����Ϣ���Ѿ�¼�룬����Ҫ���������");
	  	      }
	  	      //����һ���Ϳͻ���������Ϣ
	  	      else
	  	      {
	  	    	//�����������Ż��ͬ��
	  	    	sSql3=" select ObjectNo from Project_Relative where ProjectNo=:ProjectNo order by ObjectNo DESC";
	  	    	  so = new SqlObject(sSql3).setParameter("ProjectNo", sProjectNo);
		          rs = Sqlca.getResultSet(so);
		  	      if(rs.next())
		  	      {
		  	    	sObjectNoadd = rs.getString(1);
		  	      }
		  	      rs.getStatement().close();	 
		  	      //���ȵ���������ҿͻ�����
		  	    sSql3=" select CustomerID from Business_Apply where SerialNo =:SerialNo";
		  	    so = new SqlObject(sSql3).setParameter("SerialNo", sObjectNoadd);
			          rs = Sqlca.getResultSet(so);
			  	      if(rs.next())
			  	      {
			  	    	sObjectNonew = rs.getString(1);
			  	      }
			  	      rs.getStatement().close();	 
			  	 //����������û�пͻ����뵽��ͬ������
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
