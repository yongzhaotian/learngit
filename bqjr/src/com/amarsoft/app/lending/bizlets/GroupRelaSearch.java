package com.amarsoft.app.lending.bizlets;

import java.util.Hashtable;
import java.util.Vector;

import com.amarsoft.are.ARE;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 
 *Describe: <p>--���Ź�������.
 *			��������
 *			<li>1.	ͬһ���˴���</li>
 *			<li>2.	ֱ�ӿ�����������ҵ����50�����Ϲ�Ȩ�ġ�</li>
 *			<li>3.	ֱ�ӱ���������ҵ���˿ع�50%���Ϲ�Ȩ�ġ� </li>
 *			<li>4.	��ͬ������������ҵ���˿���50�����Ϲ�Ȩ�ġ�</li>
 *			<li>5.	��Ҫ�߹�Ϊ��ϵ���еļ�ͥ��Աֱ�ӿ��ơ�</li></p>
 * 	��ϵ����:  <p><li>���Լ��Ĺ�ϵΪ   0000</li>
 *	  	     <li> ��ͬ���˴���Ϊ    0100</li>
 *	  	        <li>  ����ع�Ϊ   0200</li>
 *	     	    <li>	���ع�Ϊ   5200</li>
 *	  	  <li> ��ͬ���������ع�Ϊ   0250</li>
 *	  	   <li>�����߹ܹ�����˾Ϊ   0300.</li></p>
 *Input Param:
 *		<p>CustomerID���ͻ�ID</p>
 *Output Param: <p>		
 *HistoryLog:<p>
 *@author pwang 2009-10-20
 *
 */
public class GroupRelaSearch{

	private  String sCustomerID;//����ԴCustomerID
	private  Vector VSearchCustomer = new Vector();//�洢�����õ���CustomerID
	private  Hashtable myHashtable = new Hashtable();//�洢�����õ���CustomerID��صĲ�����Ϣ����Ҫ����ҳ����ͼչ��
	private  String CustomerResult="";//����CustomerIDƴ���ַ���
	
	private  String tempCustomerID ="";//��������ݴ������
	private  String tempCustomerName ="";//��������ݴ������
	private  double tempInvestmentProp = 0.0;//Ͷ�ʱ���ֵ	
	private  Vector FcCustomerID =new Vector();//���˴���CustomerID
	private  Vector ManageCustomerID=new Vector();//�߹�CustomerID
	private  Vector entStoholderCustID = new Vector();//��˾�ɶ�CustomerID������������߹�CustomerID�͹ɶ�����CustomerID
	private  int rsLength = 0;	
	public String getCustomerResult() {
		return CustomerResult;
	}
		
	public Vector getVSearchCustomer() {
		return VSearchCustomer;
	}

	public Hashtable getMyHashtable() {
		return myHashtable;
	}
	
	/**
	 * 
	 * @param sCustomerID
	 * @param Sqlca
	 */
	public GroupRelaSearch(String sCustomerID){
		this.sCustomerID=sCustomerID;
		CustomerResult="";

		VSearchCustomer.removeAllElements();
		VSearchCustomer.addElement(sCustomerID);
        myHashtable.clear();
		myHashtable.put(sCustomerID,"0000@"+sCustomerID+"@00");
		//��@ƴ�ӵĲ���������һ�������������ͣ���������CustomerIDΪ�����ͻ�������������������������ʹ���á�00����	
		//�˴�Ϊ��ʼ����ϣ��
	}
	
	/**-----------------------��ȡĿ��һ������˾�ͻ������ --------------------------
	 *  
	 * @throws Exception */	
	private void SearchSharedFc(Transaction Sqlca) throws Exception{
		String sSql = "";	
		ASResultSet rs = null;	
		FcCustomerID.removeAllElements();//���˴���CustomerID
		ManageCustomerID.removeAllElements();//����߹�CustomerID,������Ҫ����ɶ�����
		SqlObject so ;//��������
		//Ŀ��һ�Ĺ�����������һ�������ÿͻ�������߹ܲ����ݴ�
		try{
			sSql ="select distinct RelativeID,RelationShip from CUSTOMER_RELATIVE where RelationShip in ('0100','0101','0102','0103') " +
			  "and  CustomerID =:CustomerID";
			so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
			rs = Sqlca.getASResultSet(so);
			while(rs.next()){					
				tempCustomerID=rs.getString("RelativeID");
				if(rs.getString("RelationShip").equals("0100")){
					FcCustomerID.addElement(tempCustomerID);//���淨�˴��� CustomerID				
				}			
				ManageCustomerID.addElement(tempCustomerID) ;//����4��߹�CustomerID				
			}
		}catch(Exception e){
			ARE.getLog().error(e.getMessage());
		}finally{
			rs.getStatement().close(); 
			rs=null;
		}

		//ƴ�Ӳ�ѯ������ƴ���ѵõķ��˴���
		String whereClause="''";
		for(int j=0;j<FcCustomerID.size();j++)
		{			
			whereClause=whereClause+",'"+FcCustomerID.get(j)+"'";				
		}
		FcCustomerID= null;//����Vector����ʹ�á�
		
		//Ŀ��һ�Ĺ�����������������������õ��ķ��˴���������ͬ���˴���Ĺ����ͻ���
		try{
			sSql ="select CustomerID,getCustomerName(CustomerID) as CustomerName from CUSTOMER_RELATIVE where RelationShip ='0100' " +
			  "and RelativeID in ("+whereClause+") and CustomerID <>:CustomerID";
			so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
			rs = Sqlca.getASResultSet(so);
			rsLength =VSearchCustomer.size();
			
			while(rs.next()){
				tempCustomerID = rs.getString("CustomerID");	
				if(tempCustomerID == null || tempCustomerID.equals("")){
					continue;				
				}
				tempCustomerName = rs.getString("CustomerName");	
				CustomerResult +=tempCustomerID+"@";//ƴ�ӵõ�Ŀ��һ������˾�ͻ�.
				myHashtable.put(tempCustomerID, "0100@"+tempCustomerName+"@00");
				VSearchCustomer.addElement(tempCustomerID);
			}
			
			//����ĩ@����ȥ������.
			if(rsLength<VSearchCustomer.size())
			CustomerResult =CustomerResult.substring(0, CustomerResult.length()-1);
		}catch(Exception e){
			ARE.getLog().error(e.getMessage());
		}finally{
			rs.getStatement().close(); 
			rs=null;
		}
		//����ͻ�ID�����֮����#�ָ
		CustomerResult +="$";		
	}
	
	 /**-----------------------��ȡĿ���������˾�ͻ������ --------------------------*/	
	private void SearchInvestors(Transaction Sqlca) throws Exception{
		String sSql = "";	
		ASResultSet rs = null;
		
		try{
			sSql ="select RelativeID,getCustomerName(RelativeID) as CustomerName,InvestmentProp from CUSTOMER_RELATIVE " +
			  "where RelationShip like '02%' and length(RelationShip)>2 and InvestmentProp>50 and  CustomerID =:CustomerID ";
			SqlObject so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
			rs = Sqlca.getASResultSet(so);
			rsLength =VSearchCustomer.size();
			
			while (rs.next()){
				tempCustomerID=rs.getString("RelativeID");				
				if(tempCustomerID.equals("")){
					continue;				
				}
				else{			
					if(!myHashtable.containsKey(tempCustomerID)){
						tempInvestmentProp = rs.getDouble("InvestmentProp");//���ռ��ֵ��
						tempCustomerName = rs.getString("CustomerName");
						
						CustomerResult +=tempCustomerID+"@";//�õ�Ŀ���������˾�ͻ�.
						myHashtable.put(tempCustomerID, "0200@"+tempCustomerName+"@"+tempInvestmentProp);
						VSearchCustomer.addElement(tempCustomerID);
					}					
				}			
			}
			
			//����ĩ@����ȥ������.
			if(	rsLength<VSearchCustomer.size())
				CustomerResult =CustomerResult.substring(0, CustomerResult.length()-1);
		}catch(Exception e){
			ARE.getLog().error(e.getMessage());
		}finally{
			rs.getStatement().close(); 
			rs=null;
		}
		CustomerResult +="$";	
	}
	
	 /**-----------------------��ȡĿ����������˾�ͻ������ --------------------------*/
	private void SearchHolders(Transaction Sqlca) throws Exception{
		String sSql = "";	
		ASResultSet rs = null;	
		try{
			sSql ="select RelativeID,getCustomerName(RelativeID) as CustomerName,Certtype,InvestmentProp from CUSTOMER_RELATIVE " +
			  "where RelationShip like '52%'  and length(RelationShip)>2  and InvestmentProp>50 and  CustomerID =:CustomerID ";
			SqlObject so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
			rs = Sqlca.getASResultSet(so);
			rsLength =VSearchCustomer.size();
			
			while (rs.next()){
				tempCustomerID=rs.getString("RelativeID");
				if(tempCustomerID.equals("")){
					continue;				
				}else{
						if (rs.getString("Certtype").startsWith("Ind")){
							ManageCustomerID.addElement(tempCustomerID) ;	
						}
						else{
							entStoholderCustID.addElement(tempCustomerID);
							if(!myHashtable.containsKey(tempCustomerID)){
								tempCustomerName = rs.getString("CustomerName");
								tempInvestmentProp = rs.getDouble("InvestmentProp");//���ռ��ֵ��
								
								CustomerResult +=tempCustomerID+"@";//�õ�Ŀ����������˾�ͻ�.
								myHashtable.put(tempCustomerID, "5200@"+tempCustomerName+"@"+tempInvestmentProp);
								VSearchCustomer.addElement(tempCustomerID);
							}
						}
				}				
			}
			if(rsLength<VSearchCustomer.size())
				CustomerResult =CustomerResult.substring(0, CustomerResult.length()-1);//����ĩ@����ȥ������.
		}catch(Exception e){
			ARE.getLog().error(e.getMessage());
		}finally{
			rs.getStatement().close(); 
			rs=null;
		}
		CustomerResult +="$";
	}
	
	/**-----------------------��ȡĿ���Ĺ�����˾�ͻ������ --------------------------*/			
	private void SearchSharedHolder(Transaction Sqlca) throws Exception{
		String sSql = "";	
		ASResultSet rs = null;	
		
		String whereClause="''";		
		for(int j=0;j<entStoholderCustID.size();j++){			
			whereClause=whereClause+",'"+entStoholderCustID.get(j)+"'";				
		}
		entStoholderCustID= null;//��Vector����ʹ�á�
		
		try{
			sSql ="select RelativeID,getCustomerName(RelativeID) as CustomerName,InvestmentProp from CUSTOMER_RELATIVE " +
				  "where RelationShip like '02%' and length(RelationShip)>2 and InvestmentProp>50 and CustomerID in ("+whereClause+") "; 
			rs = Sqlca.getASResultSet(sSql);
			rsLength =VSearchCustomer.size();
			
			while (rs.next()){
				tempCustomerID=rs.getString("RelativeID");
				if(tempCustomerID.equals("")){
					continue;				
				}
				else{
					if(!myHashtable.containsKey(tempCustomerID)){
						tempCustomerName = rs.getString("CustomerName");
						tempInvestmentProp = rs.getDouble("InvestmentProp");
						
						CustomerResult +=tempCustomerID+"@";//�õ�Ŀ���Ĺ�����˾�ͻ�.						
						myHashtable.put(tempCustomerID, "0250@"+tempCustomerName+"@"+tempInvestmentProp);
						VSearchCustomer.addElement(tempCustomerID);
					}	
				}			
			}
			if(rsLength<VSearchCustomer.size())
				CustomerResult =CustomerResult.substring(0, CustomerResult.length()-1);//����ĩ@����ȥ������.
		}catch(Exception e){
			ARE.getLog().error(e.getMessage());
		}finally{
			rs.getStatement().close(); 
			rs=null;
		}	
		CustomerResult +="$";		
	}
	
	/**-----------------------��ȡĿ���������˾�ͻ������ --------------------------*/		
	private void SearchSharedFamily(Transaction Sqlca) throws Exception{
		String sSql = "";	
		ASResultSet rs = null;	
		
		//Ŀ����Ĺ�����������һ��
		String whereClause="''";
		for(int j=0;j<ManageCustomerID.size();j++){			
			whereClause=whereClause+",'"+ManageCustomerID.get(j)+"'";				
		}
		ManageCustomerID.removeAllElements();//�������ø�Vector.
	
		try{
			sSql ="select RelativeID from CUSTOMER_RELATIVE where RelationShip in ('0301','0302','0303') and CustomerID in ("+whereClause+") " +
			  "and CustomerID <> :CustomerID";
			SqlObject so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
			rs = Sqlca.getASResultSet(so);
			while (rs.next()){
				tempCustomerID=rs.getString("RelativeID");
				if(tempCustomerID.equals("")){
					continue;				
				}
				else
					ManageCustomerID.addElement(tempCustomerID) ;		
			}
		}catch(Exception e){
			ARE.getLog().error(e.getMessage());
		}finally{
			rs.getStatement().close(); 
			rs=null;
		}	
		
		//Ŀ����Ĺ��������������
		whereClause="''";
		for(int j=0;j<ManageCustomerID.size();j++){			
			whereClause=whereClause+",'"+ManageCustomerID.get(j)+"'";				
		}
		ManageCustomerID= null;

		try{
			sSql ="select CustomerID,getCustomerName(CustomerID) as CustomerName,InvestmentProp from CUSTOMER_RELATIVE " +
				  "where  RelationShip like '52%' and length(RelationShip)>2 and InvestmentProp>50 and RelativeID in ("+whereClause+") " +
				  "union select CustomerID,getCustomerName(CustomerID) as CustomerName,InvestmentProp from CUSTOMER_RELATIVE " +
				  "where  RelationShip in ('0100','0101','0102','0103') and  RelativeID in ("+whereClause+")"; 
			rs = Sqlca.getASResultSet(sSql);
			rsLength =VSearchCustomer.size();
			
			while (rs.next()){
				tempCustomerID=rs.getString("CustomerID");
				if(tempCustomerID.equals("")){
					continue;				
				}
				else{
					if(!myHashtable.containsKey(tempCustomerID)){
						tempCustomerName = rs.getString("CustomerName");
						tempInvestmentProp = rs.getDouble("InvestmentProp");

						CustomerResult +=tempCustomerID+"@";//�õ�Ŀ���������˾�ͻ�.
						myHashtable.put(tempCustomerID, "0300@"+tempCustomerName+"@"+tempInvestmentProp);
						VSearchCustomer.addElement(tempCustomerID);
					}	
				}
			}
			if(rsLength<VSearchCustomer.size())
				CustomerResult =CustomerResult.substring(0, CustomerResult.length()-1);//����ĩ@����ȥ������.
		}catch(Exception e){
			ARE.getLog().error(e.getMessage());
		}finally{
			rs.getStatement().close(); 
			rs=null;
		}	
		CustomerResult +="$";
	}
	
	/**
	 * �������������������

	 * @throws Exception
	 */
	public void SearchAction(Transaction Sqlca) throws Exception {		
			
		SearchSharedFc(Sqlca);
		SearchInvestors(Sqlca);
		SearchHolders(Sqlca);
		SearchSharedHolder(Sqlca);
		SearchSharedFamily(Sqlca);
		
	}
	
	/**
	 * ���ڱ��汾�������Ľ�����ݣ���Ϊһ����¼�����ٺ��������϶�������������ʱ�����ݽ�����
	 * ���θ÷�������ʹ�á����߼�����һ��ͬ����Bizlet��ΪSaveRelaResult.java�С�
	 * @param Sqlca
	 * @param sCustomerResult
	 * @param sUserID
	 * @return
	 * @throws Exception
	 */
	public String SaveAction(Transaction Sqlca,String sCustomerResult,String sUserID) throws Exception {

		String sSql ="";
		String[] terms = sCustomerResult.split("#");//����ַ���Ϊ�����������������
		String sSerialNo ="";

		sSerialNo = DBKeyHelp.getSerialNo("GROUP_RESULT","SerialNo",Sqlca);//������ˮ��
		
		if(sSerialNo != "" && sSerialNo != null){
			try{
				sSql ="INSERT INTO GROUP_RESULT VALUES (:SerialNo,'2009101200000012',:T0,:T1,:T2,:T3,T4:,'','',:UpdateDate,:UpdateUser)";//һ��insert�����С�
				SqlObject so = new SqlObject(sSql);
				so.setParameter("SerialNo", sSerialNo).setParameter("T0", terms[0]).setParameter("T1", terms[1]).setParameter("T2", terms[2])
				.setParameter("T3", terms[3]).setParameter("T4",terms[4]).setParameter("UpdateDate", StringFunction.getToday()).setParameter("UpdateUser", sUserID);
				Sqlca.executeSQL(so);
			}
			catch(Exception e){
				ARE.getLog().error(e.getMessage());
				throw new Exception(e);
			}
		}	
		return sSerialNo;
	}
	
}
