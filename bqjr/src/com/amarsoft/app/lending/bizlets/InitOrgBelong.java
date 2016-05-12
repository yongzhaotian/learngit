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
	 * �޲ι��캯��
	 * modify by xjzhao 2011/01/25
	 */
	public InitOrgBelong(){}

	public Object run(Transaction Sqlca) throws Exception {
		// TODO Auto-generated method stub
		
		// ɾ��Org_Belong���е�ȫ���ϼ�¼,���д��³�ʼ��
		Sqlca.executeSQL(" delete from ORG_BELONG ") ;
		
		//���������Ӧ��ϵMap
		ArrayList<String[]> OrgList = new ArrayList<String[]>();
        //��Ż���������ϼ����������ڲ���ORG_BELONG������
		ArrayList<String[]> OrgBelong = new ArrayList<String[]>() ;
		
		//��ȡ����������Ϣ�����ջ�������ͻ����������򣬴����������С�����������
		String sSql = "select OrgID,RelativeOrgID,OrgLevel,OrgCode from Org_Info order by OrgLevel,OrgCode " ;
		ASResultSet rs = Sqlca.getASResultSet(sSql) ;
		
		while(rs.next()){
			String sOrgID = rs.getString("OrgID");	if(null==sOrgID) throw new Exception("����δ���������ŵĻ��������ܳ�ʼ������Ȩ�ޣ�");
			String sRelativeOrgID = rs.getString("RelativeOrgID");	if(null==sRelativeOrgID) throw new Exception("����δ�����ϼ������Ļ��������ܳ�ʼ������Ȩ�ޣ�");
			String sOrgLevel = rs.getString("OrgLevel");	if(null==sOrgLevel) throw new Exception("����δ�����������Ļ��������ܳ�ʼ������Ȩ�ޣ�");
			String sOrgCode = rs.getString("OrgCode");	if(null==sOrgCode) throw new Exception("����δ����������͵Ļ��������ܳ�ʼ������Ȩ�ޣ�");
			//����������飺������š��ϼ�������š����������ϼ�����
			String[] OrgArray = new String[4];
			OrgArray[0] = sOrgID;
			OrgArray[1] = sRelativeOrgID;
			OrgArray[2] = sOrgLevel;
			OrgArray[3] = sOrgCode;
			
			OrgList.add(OrgArray);
		}
		rs.getStatement().close() ;
		
		
		/*
		 * ���ݹ���ϵͳ���г�ʼ������Ȩ��
		 */
		for(int i=0; i < OrgList.size(); i ++)
		{
			String[] OrgArray = OrgList.get(i);
			String sOrgID = OrgArray[0];
			String sRelativeOrgID = OrgArray[1];
			String sOrgLevel = OrgArray[2];
			String sOrgCode = OrgArray[3];
			
			//����������¼���ϵ�嵥
			ArrayList<String> LowOrgArray =  getNextOrgArray(OrgList,OrgArray);
			for(int m = 0; m < LowOrgArray.size(); m ++)
			{
				OrgBelong.add(new String[]{sOrgID,LowOrgArray.get(m)});
			}
			
			ArrayList<String> UpOrgArray = getLastOrgArray(OrgList,OrgArray);
			
			System.out.println();
			//�������������Լ���Ȩ�޺�����ز��ң�ͬ���𣩵Ĺ�ϵ
			for(int j = 0; j < OrgList.size(); j ++)
			{
				if(i == j) //������ͬ�����ţ���¼һ����¼
				{
					OrgBelong.add(new String[]{OrgList.get(j)[0],sOrgID});
				}
				else if(sOrgLevel.equals(OrgList.get(j)[2]) && !sOrgCode.equals(OrgList.get(j)[3]) && sOrgID.equals(OrgList.get(j)[1]))	
					//����ͬ�������𡢲�ͬ�������ͻ����Ҵ������¼���ϵ�ģ���¼������¼
				{
					OrgBelong.add(new String[]{sOrgID,OrgList.get(j)[0]});
					OrgBelong.add(new String[]{OrgList.get(j)[0],sOrgID});
					//��ͬ�����������ͬ��������
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
	
	//��ȡ�û������¼�����
	public static ArrayList<String> getNextOrgArray(ArrayList<String[]> OrgList,String[] OrgArray)
	{
		ArrayList<String> LowOrgArray = new ArrayList<String>();
		for(int i = 0; i < OrgList.size() ; i ++)
		{
			//����û������ϼ�������ָ���������Ǹû��������ϼ��������ӻ�����������ͬ�������𡢲�ͬ�������ͻ����ͻ�������Ȩ�޿���
			if(!(OrgArray[2].equals(OrgList.get(i)[2]) && !OrgArray[3].equals(OrgList.get(i)[3])) && OrgArray[0].equals(OrgList.get(i)[1]) && !OrgArray[0].equals(OrgList.get(i)[0]))
			{
				LowOrgArray.add(OrgList.get(i)[0]);
				//ȡ���¼�����
				ArrayList<String> TempOrgArray = getNextOrgArray(OrgList,OrgList.get(i));	
				for(int j = 0; j < TempOrgArray.size(); j ++)
					LowOrgArray.add(TempOrgArray.get(j));
			}
		}
		
		return LowOrgArray;
	}
	
	//��ȡ�û������ϼ�����
	public static ArrayList<String> getLastOrgArray(ArrayList<String[]> OrgList,String[] OrgArray)
	{
		ArrayList<String> LowOrgArray = new ArrayList<String>();
		for(int i = 0; i < OrgList.size() ; i ++)
		{
			if(OrgArray[1].equals(OrgList.get(i)[0]) && !OrgArray[0].equals(OrgList.get(i)[0]))
			{
				LowOrgArray.add(OrgList.get(i)[0]);
				//ȡ���ϼ�����
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
