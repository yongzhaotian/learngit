package com.amarsoft.app.lending.bizlets;

import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class GroupSearch
{
	public static String CustomerID;
	public static String FaRenID;
	public static Vector VSearchCustomer = new Vector();
	public static Hashtable myHashtable = new Hashtable();

	public GroupSearch(String sCustomerID,Transaction Sqlca)
	{
		CustomerID=sCustomerID;
		VSearchCustomer.removeAllElements();
		VSearchCustomer.addElement(sCustomerID);
        myHashtable.clear();
		myHashtable.put(sCustomerID,"00");

		String sSql="",sRelativeID="";
		ASResultSet rs=null;
		try{
			sSql = "select RelativeID from CUSTOMER_RELATIVE where CustomerID=:CustomerID and RelationShip='0100' ";
			SqlObject so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
			rs = Sqlca.getASResultSet(so);
			if(rs.next())
			{
				sRelativeID = rs.getString(1);
			}
			rs.getStatement().close();

		}catch(Exception e)
		{
			System.out.println("GroupSearch"+e.toString());
		}

		FaRenID=sRelativeID;

	}

	public static void SearchAction(Transaction Sqlca)
	{
		String sSql="",sRelativeID="",sRelativeShip="";
		int i = 0;
		ASResultSet rs;

		while(!VSearchCustomer.isEmpty())
		{
			String sCustomerID=(String)VSearchCustomer.firstElement();
			VSearchCustomer.removeElement(sCustomerID);
			VSearchCustomer.trimToSize();

			try{
				
				sSql =  " select RelativeID,'02' as RelativeShip,'07' as SelectOrder "+
				" from CUSTOMER_RELATIVE "+
				" where CustomerID =:CustomerID "+
				" and RelationShip = '99' "+
				" union "+
				" select RelativeID,'05' as RelativeShip,'03' as SelectOrder "+
				" from CUSTOMER_RELATIVE "+
				" where CustomerID =:CustomerID1 "+
				" and RelationShip like '02%'  "+
				" union "+
				" select RelativeID,'01' as RelativeShip,'02' as SelectOrder "+
				" from CUSTOMER_RELATIVE "+
				" where CustomerID =:CustomerID2 "+
				" and RelationShip like '52%'  "+
				" union "+
				" select CustomerID,'07' as RelativeShip,'01' as SelectOrder "+
				" from CUSTOMER_RELATIVE "+
				" where RelativeID =:RelativeID "+
				" and RelationShip = '0100' "+
				" order by SelectOrder ";
				SqlObject so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID).setParameter("CustomerID1", sCustomerID)
				.setParameter("CustomerID2", sCustomerID).setParameter("RelativeID", FaRenID);
				rs = Sqlca.getASResultSet(so);
				while(rs.next())
				{
					sRelativeID   = rs.getString(1);
					sRelativeShip = rs.getString(2);
					
					if(!myHashtable.containsKey(sRelativeID))
					{
						VSearchCustomer.addElement(sRelativeID);
						if(i==0)
						{
							myHashtable.put(sRelativeID,sRelativeShip);
						}else
						{
							myHashtable.put(sRelativeID,"02");
						}
					}
				}
				rs.getStatement().close();

			}catch(Exception e)
			{
				System.out.println("SearchAction"+e.toString());
			}

			i++;
		}
	}

	public static void deleteAction(Transaction Sqlca)
	{
		String sSql="";

		sSql = "delete from GROUP_SEARCH where CustomerID=:CustomerID and SearchFlag = '1' ";
		
		try{
			SqlObject so = new SqlObject(sSql).setParameter("CustomerID", CustomerID);
			Sqlca.executeSQL(so);
			Sqlca.commit();
		}catch(Exception e)
		{
			System.out.println("deleteAction"+e.toString());
		}
	}

	public static void insertAction(Transaction Sqlca)
	{
		String sKey="",sValue="",sSql="";
		String sToday=StringFunction.getToday();

		Enumeration enumer=myHashtable.keys() ;
		while(enumer.hasMoreElements())
		{
			sKey=(String)enumer.nextElement();
			sValue=(String)myHashtable.get(sKey);
			/*
			sSql = "insert into GROUP_SEARCH(CustomerID,RelativeID,RelativeType,SearchFlag,InputDate) "+
					"values('"+CustomerID+"','"+sKey+"','"+sValue+"','1','"+sToday+"')";
			*/
			sSql = "insert into GROUP_SEARCH(CustomerID,RelativeID,RelativeType,SearchFlag,InputDate) "+
			"values(:CustomerID,:RelativeID,:RelativeType,'1',:InputDate)";
			try{
				SqlObject so = new SqlObject(sSql);
				so.setParameter("CustomerID", CustomerID).setParameter("RelativeID", sKey).setParameter("RelativeType", sValue).setParameter("InputDate", sToday);
				Sqlca.executeSQL(so);
				Sqlca.commit();

			}catch(Exception e)
			{
				System.out.println("insertAction"+e.toString());
			}
		}
	}

	public static void getSearchResult(Transaction Sqlca)
	{		
		try{
			deleteAction(Sqlca);
			SearchAction(Sqlca);
			insertAction(Sqlca);			
		}catch(Exception e)
		{			
			System.out.println("getSearchResult"+e.toString());
		}		
	}



    public static void main(String args[])
	{
		
		try
		{
			
		}catch(Exception e)
		{
			
		}
	}

}