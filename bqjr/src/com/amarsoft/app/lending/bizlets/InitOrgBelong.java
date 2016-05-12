package com.amarsoft.app.lending.bizlets;

import java.util.ArrayList;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class InitOrgBelong  extends Bizlet {

	/**
	 * @param args
	 */
	/*
	 * 无参构造函数
	 * modify by xjzhao 2011/01/25
	 */
	public InitOrgBelong(){}

	public Object run(Transaction Sqlca) throws Exception {
		// TODO Auto-generated method stub
		
		// 删除Org_Belong表中的全部老记录,进行从新初始化
		Sqlca.executeSQL(" delete from ORG_BELONG ") ;
		
		//定义机构对应关系Map
		ArrayList<String[]> OrgList = new ArrayList<String[]>();
        //存放机构本身和上级机构，用于插入ORG_BELONG表数据
		ArrayList<String[]> OrgBelong = new ArrayList<String[]>() ;
		
		//抽取机构基本信息，按照机构级别和机构类型排序，从上至下总行——网点排序
		String sSql = "select OrgID,RelativeOrgID,OrgLevel,OrgCode from Org_Info order by OrgLevel,OrgCode " ;
		ASResultSet rs = Sqlca.getASResultSet(sSql) ;
		
		while(rs.next()){
			String sOrgID = rs.getString("OrgID");	if(null==sOrgID) throw new Exception("存在未定义机构编号的机构，不能初始化机构权限！");
			String sRelativeOrgID = rs.getString("RelativeOrgID");	if(null==sRelativeOrgID) throw new Exception("存在未定义上级机构的机构，不能初始化机构权限！");
			String sOrgLevel = rs.getString("OrgLevel");	if(null==sOrgLevel) throw new Exception("存在未定义机构级别的机构，不能初始化机构权限！");
			String sOrgCode = rs.getString("OrgCode");	if(null==sOrgCode) throw new Exception("存在未定义机构类型的机构，不能初始化机构权限！");
			//定义机构数组：机构编号、上级机构编号、机构级别、上级机构
			String[] OrgArray = new String[4];
			OrgArray[0] = sOrgID;
			OrgArray[1] = sRelativeOrgID;
			OrgArray[2] = sOrgLevel;
			OrgArray[3] = sOrgCode;
			
			OrgList.add(OrgArray);
		}
		rs.getStatement().close() ;
		
		
		/*
		 * 根据关联系统进行初始化机构权限
		 */
		for(int i=0; i < OrgList.size(); i ++)
		{
			String[] OrgArray = OrgList.get(i);
			String sOrgID = OrgArray[0];
			String sRelativeOrgID = OrgArray[1];
			String sOrgLevel = OrgArray[2];
			String sOrgCode = OrgArray[3];
			
			//处理机构上下级关系清单
			ArrayList<String> LowOrgArray =  getNextOrgArray(OrgList,OrgArray);
			for(int m = 0; m < LowOrgArray.size(); m ++)
			{
				OrgBelong.add(new String[]{sOrgID,LowOrgArray.get(m)});
			}
			
			ArrayList<String> UpOrgArray = getLastOrgArray(OrgList,OrgArray);
			
			System.out.println();
			//处理机构本身对自己的权限和其相关部室（同级别）的关系
			for(int j = 0; j < OrgList.size(); j ++)
			{
				if(i == j) //对于相同机构号，记录一条记录
				{
					OrgBelong.add(new String[]{OrgList.get(j)[0],sOrgID});
				}
				else if(sOrgLevel.equals(OrgList.get(j)[2]) && !sOrgCode.equals(OrgList.get(j)[3]) && sOrgID.equals(OrgList.get(j)[1]))	
					//对于同机构级别、不同机构类型机构且存在上下级关系的，记录两条记录
				{
					OrgBelong.add(new String[]{sOrgID,OrgList.get(j)[0]});
					OrgBelong.add(new String[]{OrgList.get(j)[0],sOrgID});
					//将同级别机构、不同机构类型
					for(int m = 0; m < LowOrgArray.size(); m ++)
					{
						OrgBelong.add(new String[]{OrgList.get(j)[0],LowOrgArray.get(m)});
					}
					for(int n = 0; n < UpOrgArray.size(); n ++)
					{
						OrgBelong.add(new String[]{UpOrgArray.get(n),OrgList.get(j)[0]});
					}
				}
			}
		}
		
		for(int n = 0; n < OrgBelong.size(); n ++)
		{
			Sqlca.executeSQL(" insert into ORG_BELONG(OrgID,BelongOrgID) values('"+OrgBelong.get(n)[0]+"','"+OrgBelong.get(n)[1]+"')  ");
		}
		
		
			
		return "true" ;
	}
	
	//获取该机构的下级机构
	public static ArrayList<String> getNextOrgArray(ArrayList<String[]> OrgList,String[] OrgArray)
	{
		ArrayList<String> LowOrgArray = new ArrayList<String>();
		for(int i = 0; i < OrgList.size() ; i ++)
		{
			//如果该机构的上级机构是指定机构，那该机构就是上级机构的子机构，不包含同机构级别、不同机构类型机构和机构本身权限控制
			if(!(OrgArray[2].equals(OrgList.get(i)[2]) && !OrgArray[3].equals(OrgList.get(i)[3])) && OrgArray[0].equals(OrgList.get(i)[1]) && !OrgArray[0].equals(OrgList.get(i)[0]))
			{
				LowOrgArray.add(OrgList.get(i)[0]);
				//取下下级机构
				ArrayList<String> TempOrgArray = getNextOrgArray(OrgList,OrgList.get(i));	
				for(int j = 0; j < TempOrgArray.size(); j ++)
					LowOrgArray.add(TempOrgArray.get(j));
			}
		}
		
		return LowOrgArray;
	}
	
	//获取该机构的上级机构
	public static ArrayList<String> getLastOrgArray(ArrayList<String[]> OrgList,String[] OrgArray)
	{
		ArrayList<String> LowOrgArray = new ArrayList<String>();
		for(int i = 0; i < OrgList.size() ; i ++)
		{
			if(OrgArray[1].equals(OrgList.get(i)[0]) && !OrgArray[0].equals(OrgList.get(i)[0]))
			{
				LowOrgArray.add(OrgList.get(i)[0]);
				//取上上级机构
				ArrayList<String> TempOrgArray = getLastOrgArray(OrgList,OrgList.get(i));	
				for(int j = 0; j < TempOrgArray.size(); j ++)
					LowOrgArray.add(TempOrgArray.get(j));
			}
			else if((OrgArray[1].equals(OrgList.get(i)[1]) &&  OrgList.get(i)[3].equals("1")) && !OrgArray[0].equals("1") && !OrgArray[0].equals(OrgList.get(i)[0]))
			{
				LowOrgArray.add(OrgList.get(i)[0]);
			}
		}
		
		return LowOrgArray;
	}
}
