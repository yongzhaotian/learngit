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
		//�Զ���ô���Ĳ���ֵ
	    //����Ĳ�������Ҫ���뵥���ţ��Ǵ���ı�����ԭ���Ĳ���������ͬ���Ĵ���
	    ASResultSet rs = null;
		String sProjectNo    = (String)this.getAttribute("ProjectNo");
		String sObjectType   = (String)this.getAttribute("ObjectType");
		String sObjectNo     = (String)this.getAttribute("ObjectNo");
		
		//����ֵת���ɿ��ַ���
		if(sProjectNo == null) sProjectNo = "";
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		
		//�������
	    String sSql = "";
	    SqlObject so ;//��������
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
	  	    	  ARE.getLog().info("����Ŀ�Ѿ���ҵ����Ϣ�����������ɾ����");
	  	      }
	  	      else
	  	      {
	  	    	//ִ��ɾ�����
	  	    	//ɾ������Ϣ
	  	    	sSql = " delete from  Project_Info where PROJECTNO =:PROJECTNO ";
	  	    	so = new SqlObject(sSql).setParameter("PROJECTNO", sProjectNo);
	  	    	Sqlca.executeSQL(so);
	  			//ɾ����Ŀ��չ���
	  	    	sSql = " delete from  PROJECT_PROGRESS where PROJECTNO =:PROJECTNO ";
	  	    	so = new SqlObject(sSql).setParameter("PROJECTNO", sProjectNo);
	  	    	Sqlca.executeSQL(so);
	  			//ɾ����Ŀ�ʽ���Դ
	  	    	sSql = " delete from  PROJECT_FUNDS where PROJECTNO =:PROJECTNO ";
	  	    	so = new SqlObject(sSql).setParameter("PROJECTNO", sProjectNo);
	  			Sqlca.executeSQL(so);
	  			//ɾ����ĿͶ�ʸ���
	  			sSql =" delete from  PROJECT_BUDGET where PROJECTNO =:PROJECTNO ";
	  			so = new SqlObject(sSql).setParameter("PROJECTNO", sProjectNo);
	  			Sqlca.executeSQL(so);	
	  	      }
		 }
		//�����ҵ������ʹ������ɾ����ֻ����ɾ����������ɾ����Ϣ
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
