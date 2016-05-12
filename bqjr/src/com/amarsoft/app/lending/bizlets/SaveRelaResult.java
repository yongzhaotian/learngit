package com.amarsoft.app.lending.bizlets;

import java.util.Hashtable;

import com.amarsoft.are.ARE;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;

/**  
 *    Describe: --集团关联搜索.
 *			      关系参数:  <li>与自己的关系为      0000</li>
 *      				  	<li>共同法人代表为      0100</li> 
 *				  	        <li>对外控股为          0200</li> 
 *					     	<li>被控股为            5200</li> 
 *					  		<li>共同被第三方控股为   0250</li> 
 *					  		<li>亲属高管关联公司为   0300</li><p>
 *   HistoryLog:
 * @Author  pwang 2009-10-20
*/
public class SaveRelaResult  extends Bizlet {
	/** 
	 * @param  		   <li>CustomerID：	源客户ID</li>
	 *			<li>GroupRelaCustStr1：关联公司ID</li>
	 *			<li>GroupRelaCustStr2：关联关系参数</li>
	 *		 		  <li>CustomerStr：	搜索得到的拼接字符串</li>
	 * @return    SerialNo  流水号
	 */
	public Object  run(Transaction Sqlca) throws Exception{
		//定义传入参数变量
		/**录入用户ID*/
		String sInputUser         = (String)this.getAttribute("InputUser");
		/**源客户ID */
		String sCustomerID   	  = (String)this.getAttribute("CustomerID");
		/**关联公司ID*/
		String sGroupRelaCustStr1 = (String)this.getAttribute("GroupRelaCustStr1");
		/**关联关系代码*/
		String sGroupRelaCustStr2 = (String)this.getAttribute("GroupRelaCustStr2");
		/**搜索得客户ID串*/
		String sCustomerStr 	  = (String)this.getAttribute("CustomerStr");
		
		if(sInputUser == null) sInputUser = "";
		if(sGroupRelaCustStr1 == null) sGroupRelaCustStr1 = "";
		if(sGroupRelaCustStr2 == null) sGroupRelaCustStr2 = "";
				
		/**
		 * 定义变量:
		 *       <li>user :当前用户.</li>
		 *       <li>sSql </li>
		 *       <li>rs :当前用户.</li>
		 *       <li>sSerialNo :搜索关联表GROUP_RESULT流水号.</li>
		 *       <li>sCurDate :当前日期.</li>
		 *       <li>RelaSearchht :保存原有关联记录的关联客户.</li>
		 *       <li>RelaSearchht2 :保存原有关联记录反向的关联客户.</li>
		 *       <li>ResultCust1 :循环过程中暂存CustomerID.</li>
		 *       <li>ResultCust2 :循环过程中暂存关联关系代码.</li>
		 *       <li>CustomerIDbuffer :暂存CustomerID.</li>		
		 */
		ASUser user = ASUser.getUser(sInputUser,Sqlca);	
		String sSql ="";	
		ASResultSet rs =null;	
		String sSerialNo ="";
		String sCurDate = "";
		Hashtable RelaSearchht = new Hashtable(); 
		Hashtable RelaSearchht2 = new Hashtable(); 
		String[] ResultCust1 ;
		String[] ResultCust2 ;
		String CustomerIDbuffer ="";
		SqlObject so;
				
		try{
			/**搜索得到原有关联公司，以便后续做更新还是新插入的判断。*/
			sSql ="select RelativeID from GROUP_SEARCH where CustomerID =:CustomerID "; 
			so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
			rs = Sqlca.getASResultSet(so);	
			while (rs.next()){
				CustomerIDbuffer =rs.getString("RelativeID");
				if(!RelaSearchht.containsKey(CustomerIDbuffer))
					RelaSearchht.put(CustomerIDbuffer,"");//保存原有关联公司。
			}		
		}catch(Exception e){
			ARE.getLog().error(e.getMessage());
		}finally{
			rs.getStatement().close(); 
			rs=null;
		}
		CustomerIDbuffer="";
		try{
			//搜索得到原有反向关联公司，以便后续做更新还是新插入的判断。
			sSql ="select CustomerID from GROUP_SEARCH where RelativeID =:RelativeID ";
			so = new SqlObject(sSql).setParameter("RelativeID", sCustomerID);
			rs = Sqlca.getASResultSet(so);
			while (rs.next()){
				CustomerIDbuffer =rs.getString("CustomerID");
				if(!RelaSearchht2.containsKey(CustomerIDbuffer))
					RelaSearchht2.put(CustomerIDbuffer,"");//保存原有关联公司。
			}			

		}catch(Exception e){
			ARE.getLog().error(e.getMessage());
		}finally{
			rs.getStatement().close(); 
			rs=null;
		}

		sCurDate = StringFunction.getToday();
		//更新或插入本次搜索的关联关系。
		ResultCust1 =sGroupRelaCustStr1.split("@");
		ResultCust2 =sGroupRelaCustStr2.split("@");
		for(int i=0;i<ResultCust1.length;i++){
			if(ResultCust1[i]!=""&&!ResultCust2[i].equals("0000")){
				//正向插入.
				if(RelaSearchht.containsKey(ResultCust1[i])){
					try{//已有的记录做更新。
						sSql ="update GROUP_SEARCH SET Relativetype =:Relativetype ,updatedate =:updatedate ," +
						"updateorgid =:updateorgid ,updateuserid =:updateuserid where CustomerID =:CustomerID and RelativeID =:RelativeID " ;
						so = new SqlObject(sSql);
						so.setParameter("Relativetype", ResultCust2[i]).setParameter("updatedate", sCurDate).setParameter("updateorgid", user.getOrgID())
						.setParameter("updateuserid", sInputUser).setParameter("CustomerID", sCustomerID).setParameter("RelativeID", ResultCust1[i]);
						Sqlca.executeSQL(so);
					}
					catch(Exception e){
						ARE.getLog().error(e.getMessage());
						throw new Exception(e);
					}						
				}else{
					try{//未有的记录做填入。
						sSql ="INSERT INTO GROUP_SEARCH VALUES (:CustomerID,:R1,:R2,'1',:OrgID,:UserID,:Date,'','','')";
						so =  new SqlObject(sSql).setParameter("CustomerID", sCustomerID).setParameter("R1", ResultCust1[i]).setParameter("R2", ResultCust2[i])
						.setParameter("OrgID", user.getOrgID()).setParameter("UserID", sInputUser).setParameter("Date", sCurDate);
						Sqlca.executeSQL(so);
					}
					catch(Exception e){
						ARE.getLog().error(e.getMessage());
						throw new Exception(e);
					}	
				}
				
				//反向插入.
				//更换控股关系值.
				if(ResultCust2[i].equals("0200"))
					ResultCust2[i]="5200";
				else{
					if(ResultCust2[i].equals("5200"))
						ResultCust2[i]="0200";
				}				
				if(RelaSearchht2.containsKey(ResultCust1[i])){
					try{//已有的记录做更新。
						sSql ="update GROUP_SEARCH SET Relativetype =:Relativetype,updatedate =:updatedate ," +
						"updateorgid =:updateorgid ,updateuserid =:updateuserid where CustomerID =:CustomerID and RelativeID =:RelativeID " ;
						so = new SqlObject(sSql);
						so.setParameter("Relativetype", ResultCust2[i]).setParameter("updatedate", sCurDate).setParameter("updateorgid", user.getOrgID())
						.setParameter("updateuserid", sInputUser).setParameter("CustomerID", ResultCust1[i]).setParameter("RelativeID", sCustomerID);
						Sqlca.executeSQL(so);
					}
					catch(Exception e){
						ARE.getLog().error(e.getMessage());
						throw new Exception(e);
					}		
				}else{
					try{//未有的记录做填入。
						sSql ="INSERT INTO GROUP_SEARCH VALUES (:R1,:CustomerID,:R2,'1',:OrgID,:UserID,:Date,'','','')";
						so = new SqlObject(sSql);
						so.setParameter("R1", ResultCust1[i]).setParameter("CustomerID", sCustomerID).setParameter("R2", ResultCust2[i])
						.setParameter("OrgID", user.getOrgID()).setParameter("UserID", sInputUser).setParameter("Date", sCurDate);
						Sqlca.executeSQL(so);
					}
					catch(Exception e){
						ARE.getLog().error(e.getMessage());
						throw new Exception(e);
					}	
				}
			}
		}		

		String[] terms = sCustomerStr.split("\\$");//拆分字符串为五类规则的搜索结果。
		String NullStrLength ="";
		String termString ="";

		sSerialNo = DBKeyHelp.getSerialNo("GROUP_RESULT","SerialNo",Sqlca);//生成流水号		
		if(sSerialNo != "" && sSerialNo != null){
			if(terms.length>=5){
				try{
					sSql ="INSERT INTO GROUP_RESULT VALUES (:SerialNo,:CustomerID,:T0,:T1,:T2,:T3,:T4,'','',:Date,:UserID)";//一条insert语句就行。
					so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo).setParameter("CustomerID", sCustomerID).setParameter("T0", terms[0])
					.setParameter("T1", terms[1]).setParameter("T2", terms[2]).setParameter("T3", terms[3]).setParameter("T4", terms[4])
					.setParameter("Date", StringFunction.getToday()).setParameter("UserID", sInputUser);
					Sqlca.executeSQL(so);
				}
				catch(Exception e){
					ARE.getLog().error(e.getMessage());
					throw new Exception(e);
				}
			}else{
				//做SQL语句的空值字符串拼接.
				for(int j=4;j>=terms.length;j--)
					NullStrLength+="'',";
				for(int j = 0;j<terms.length;j++){
					termString+="'"+terms[j]+"',";
				}
				try{
					sSql ="INSERT INTO GROUP_RESULT VALUES (:SerialNo,:CustomerID," + termString+NullStrLength + "'','',:Date,:UserID)";//一条insert语句就行。
					so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo).setParameter("CustomerID", sCustomerID)
					.setParameter("Date", StringFunction.getToday()).setParameter("UserID", sInputUser);
					 Sqlca.executeSQL(so);
				}
				catch(Exception e){
					ARE.getLog().error(e.getMessage());
					throw new Exception(e);
				}
				ARE.getLog().info("-------------terms.length:"+terms.length+"-----------------");
			}
		}	
		return sSerialNo;
		
	}

}
