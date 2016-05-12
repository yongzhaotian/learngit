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
 *Describe: <p>--集团关联搜索.
 *			搜索规则：
 *			<li>1.	同一法人代表。</li>
 *			<li>2.	直接控制其他企事业法人50％以上股权的。</li>
 *			<li>3.	直接被其他企事业法人控股50%以上股权的。 </li>
 *			<li>4.	共同被第三方企事业法人控制50％以上股权的。</li>
 *			<li>5.	主要高管为关系密切的家庭成员直接控制。</li></p>
 * 	关系参数:  <p><li>与自己的关系为   0000</li>
 *	  	     <li> 共同法人代表为    0100</li>
 *	  	        <li>  对外控股为   0200</li>
 *	     	    <li>	被控股为   5200</li>
 *	  	  <li> 共同被第三方控股为   0250</li>
 *	  	   <li>亲属高管关联公司为   0300.</li></p>
 *Input Param:
 *		<p>CustomerID：客户ID</p>
 *Output Param: <p>		
 *HistoryLog:<p>
 *@author pwang 2009-10-20
 *
 */
public class GroupRelaSearch{

	private  String sCustomerID;//搜索源CustomerID
	private  Vector VSearchCustomer = new Vector();//存储搜索得到的CustomerID
	private  Hashtable myHashtable = new Hashtable();//存储搜索得到的CustomerID相关的参数信息，主要用于页面树图展现
	private  String CustomerResult="";//五类CustomerID拼接字符串
	
	private  String tempCustomerID ="";//搜索结果暂存变量。
	private  String tempCustomerName ="";//搜索结果暂存变量。
	private  double tempInvestmentProp = 0.0;//投资比例值	
	private  Vector FcCustomerID =new Vector();//法人代表CustomerID
	private  Vector ManageCustomerID=new Vector();//高管CustomerID
	private  Vector entStoholderCustID = new Vector();//公司股东CustomerID，包括：四类高管CustomerID和股东个人CustomerID
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
		//用@拼接的参数：参数一、搜索关联类型；参数二、CustomerID为关联客户；参数三、其他参数，不作使用置“00”。	
		//此处为初始化哈希表。
	}
	
	/**-----------------------获取目标一关联公司客户结果集 --------------------------
	 *  
	 * @throws Exception */	
	private void SearchSharedFc(Transaction Sqlca) throws Exception{
		String sSql = "";	
		ASResultSet rs = null;	
		FcCustomerID.removeAllElements();//法人代表CustomerID
		ManageCustomerID.removeAllElements();//四类高管CustomerID,后续还要加入股东个人
		SqlObject so ;//声明对象
		//目标一的关联搜索步骤一：搜索该客户的四类高管并做暂存
		try{
			sSql ="select distinct RelativeID,RelationShip from CUSTOMER_RELATIVE where RelationShip in ('0100','0101','0102','0103') " +
			  "and  CustomerID =:CustomerID";
			so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
			rs = Sqlca.getASResultSet(so);
			while(rs.next()){					
				tempCustomerID=rs.getString("RelativeID");
				if(rs.getString("RelationShip").equals("0100")){
					FcCustomerID.addElement(tempCustomerID);//保存法人代表 CustomerID				
				}			
				ManageCustomerID.addElement(tempCustomerID) ;//保存4类高管CustomerID				
			}
		}catch(Exception e){
			ARE.getLog().error(e.getMessage());
		}finally{
			rs.getStatement().close(); 
			rs=null;
		}

		//拼接查询条件，拼入搜得的法人代表。
		String whereClause="''";
		for(int j=0;j<FcCustomerID.size();j++)
		{			
			whereClause=whereClause+",'"+FcCustomerID.get(j)+"'";				
		}
		FcCustomerID= null;//将该Vector放弃使用。
		
		//目标一的关联搜索步骤二：依据搜索得到的法人代表，搜索共同法人代表的关联客户。
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
				CustomerResult +=tempCustomerID+"@";//拼接得到目标一关联公司客户.
				myHashtable.put(tempCustomerID, "0100@"+tempCustomerName+"@00");
				VSearchCustomer.addElement(tempCustomerID);
			}
			
			//做串末@符号去除处理.
			if(rsLength<VSearchCustomer.size())
			CustomerResult =CustomerResult.substring(0, CustomerResult.length()-1);
		}catch(Exception e){
			ARE.getLog().error(e.getMessage());
		}finally{
			rs.getStatement().close(); 
			rs=null;
		}
		//五类客户ID结果集之间用#分割。
		CustomerResult +="$";		
	}
	
	 /**-----------------------获取目标二关联公司客户结果集 --------------------------*/	
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
						tempInvestmentProp = rs.getDouble("InvestmentProp");//获得占比值。
						tempCustomerName = rs.getString("CustomerName");
						
						CustomerResult +=tempCustomerID+"@";//得到目标二关联公司客户.
						myHashtable.put(tempCustomerID, "0200@"+tempCustomerName+"@"+tempInvestmentProp);
						VSearchCustomer.addElement(tempCustomerID);
					}					
				}			
			}
			
			//做串末@符号去除处理.
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
	
	 /**-----------------------获取目标三关联公司客户结果集 --------------------------*/
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
								tempInvestmentProp = rs.getDouble("InvestmentProp");//获得占比值。
								
								CustomerResult +=tempCustomerID+"@";//得到目标三关联公司客户.
								myHashtable.put(tempCustomerID, "5200@"+tempCustomerName+"@"+tempInvestmentProp);
								VSearchCustomer.addElement(tempCustomerID);
							}
						}
				}				
			}
			if(rsLength<VSearchCustomer.size())
				CustomerResult =CustomerResult.substring(0, CustomerResult.length()-1);//做串末@符号去除处理.
		}catch(Exception e){
			ARE.getLog().error(e.getMessage());
		}finally{
			rs.getStatement().close(); 
			rs=null;
		}
		CustomerResult +="$";
	}
	
	/**-----------------------获取目标四关联公司客户结果集 --------------------------*/			
	private void SearchSharedHolder(Transaction Sqlca) throws Exception{
		String sSql = "";	
		ASResultSet rs = null;	
		
		String whereClause="''";		
		for(int j=0;j<entStoholderCustID.size();j++){			
			whereClause=whereClause+",'"+entStoholderCustID.get(j)+"'";				
		}
		entStoholderCustID= null;//该Vector放弃使用。
		
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
						
						CustomerResult +=tempCustomerID+"@";//得到目标四关联公司客户.						
						myHashtable.put(tempCustomerID, "0250@"+tempCustomerName+"@"+tempInvestmentProp);
						VSearchCustomer.addElement(tempCustomerID);
					}	
				}			
			}
			if(rsLength<VSearchCustomer.size())
				CustomerResult =CustomerResult.substring(0, CustomerResult.length()-1);//做串末@符号去除处理.
		}catch(Exception e){
			ARE.getLog().error(e.getMessage());
		}finally{
			rs.getStatement().close(); 
			rs=null;
		}	
		CustomerResult +="$";		
	}
	
	/**-----------------------获取目标五关联公司客户结果集 --------------------------*/		
	private void SearchSharedFamily(Transaction Sqlca) throws Exception{
		String sSql = "";	
		ASResultSet rs = null;	
		
		//目标五的关联搜索步骤一：
		String whereClause="''";
		for(int j=0;j<ManageCustomerID.size();j++){			
			whereClause=whereClause+",'"+ManageCustomerID.get(j)+"'";				
		}
		ManageCustomerID.removeAllElements();//重新利用该Vector.
	
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
		
		//目标五的关联搜索步骤二：
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

						CustomerResult +=tempCustomerID+"@";//得到目标五关联公司客户.
						myHashtable.put(tempCustomerID, "0300@"+tempCustomerName+"@"+tempInvestmentProp);
						VSearchCustomer.addElement(tempCustomerID);
					}	
				}
			}
			if(rsLength<VSearchCustomer.size())
				CustomerResult =CustomerResult.substring(0, CustomerResult.length()-1);//做串末@符号去除处理.
		}catch(Exception e){
			ARE.getLog().error(e.getMessage());
		}finally{
			rs.getStatement().close(); 
			rs=null;
		}	
		CustomerResult +="$";
	}
	
	/**
	 * 关联搜索，分五类规则。

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
	 * 用于保存本次搜索的结果数据，作为一条记录。减少后续申请认定书制作和生成时的数据交互。
	 * 本次该方法不作使用。该逻辑移至一个同包的Bizlet名为SaveRelaResult.java中。
	 * @param Sqlca
	 * @param sCustomerResult
	 * @param sUserID
	 * @return
	 * @throws Exception
	 */
	public String SaveAction(Transaction Sqlca,String sCustomerResult,String sUserID) throws Exception {

		String sSql ="";
		String[] terms = sCustomerResult.split("#");//拆分字符串为五类规则的搜索结果。
		String sSerialNo ="";

		sSerialNo = DBKeyHelp.getSerialNo("GROUP_RESULT","SerialNo",Sqlca);//生成流水号
		
		if(sSerialNo != "" && sSerialNo != null){
			try{
				sSql ="INSERT INTO GROUP_RESULT VALUES (:SerialNo,'2009101200000012',:T0,:T1,:T2,:T3,T4:,'','',:UpdateDate,:UpdateUser)";//一条insert语句就行。
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
