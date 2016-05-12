package com.amarsoft.app.lending.bizlets;

/**
 * ���̳�ʼ����
 * @history fhuang 2007.01.08 ������С��ҵ����ѡ��
 * 			syang 2009/10/26 ����ע��
 */

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class InsertContractInfo extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {			
		//��������
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sObjectType = (String)this.getAttribute("ObjectType");
		
		System.out.println(sObjectNo+","+sObjectType);
		//�������:�û����ơ��������ơ��������ơ��׶����ơ��׶����͡���ʼʱ�䡢������ˮ�š�SQL
		String sSql = "";
		//�����������ѯ�����
		ASResultSet rs=null;
		SqlObject so;
		String sColumnName="";       //һ���ֶ�����
		String sColumnNames="";      //�ֶ�ƴ������
	    String findColumnValues="";  //���ҵ�����
	    String sNewObjectNo = "";  //��������ˮ��
	    String sArtificialNo="";   //������ĺ�ͬ���
		String[] sColumnList;
		StringBuffer  sb=new StringBuffer();
		
		//��ѯ����ͬ��Ϣ�������ֶε����
		sSql =  "select colName from DATAOBJECT_LIBRARY where DONo = 'ContractInfo1211'";
	    rs = Sqlca.getASResultSet(sSql);
		while(rs.next()){
			sColumnName=rs.getString("colName");
		    if(sColumnName.equals("InputOrgName") || sColumnName.equals("OperateOrgName") || sColumnName.equals("OperateUserName")
		    	|| sColumnName.equals("OpenBankName") || sColumnName.equals("OpenBranchName") || sColumnName.equals("SerialNo") ||sColumnName.equals("ExhibitionHallName")){
		    	continue;
		    }
		    sb.append(sColumnName);
		    sb.append(",");
		}
		sColumnNames=sb.toString().substring(0, sb.lastIndexOf(","));
		findColumnValues=sColumnNames.substring(sColumnNames.indexOf(",")+1, sColumnNames.length());
		System.out.println(findColumnValues);
		rs.close();
		
		//��ѯ����ͬ��ţ������ɳ������µĺ�ͬ���
		sSql =  "select artificialno from business_contract where serialNo =:serialNo";
		so = new SqlObject(sSql).setParameter("serialNo", sObjectNo);
		System.out.println(sSql);
	    rs = Sqlca.getASResultSet(so);
	    if(rs.next()){
	    	sArtificialNo=rs.getString("artificialno")+"0";
	    }
		rs.close();
		
		//�ں�ͬ���в��� �µ�����
		sNewObjectNo = DBKeyHelp.getSerialNo("BUSINESS_CONTRACT","SerialNo",Sqlca);
		System.out.println(sArtificialNo+"------------");
		System.out.println(sNewObjectNo+"------------++++++++++++++");
		sSql =  "insert into  business_contract (serialNo,"+ sColumnNames+ ") select '"+sNewObjectNo+"','"+sArtificialNo+"',"+ findColumnValues +" from business_contract where serialNo='"+sObjectNo+"'";
		System.out.println(sSql);
		SqlObject so1 = new SqlObject(sSql);
	    //ִ�в������
		Sqlca.executeSQL(so1);
	   
	    
	    
		//��ó�ʼ�������Ϣ
		String sApplyType = "",sFlowNo = "",sUserID = "",sOrgID = "",sPhaseNo = "";
		sSql = "select ObjectType,ObjectNo,ApplyType,UserID,OrgID,FlowNo,PhaseNo from FLOW_OBJECT where ObjectNo=:ObjectNo and ObjectType=:ObjectType ";
		so = new SqlObject(sSql).setParameter("ObjectNo", sObjectNo).setParameter("ObjectType", sObjectType);
		rs = Sqlca.getASResultSet(so);
		if(rs.next())
		{
			sApplyType = rs.getString("ApplyType");
			sUserID = rs.getString("UserID");
			sOrgID = rs.getString("OrgID");
			sFlowNo = rs.getString("FlowNo");
			sPhaseNo = rs.getString("PhaseNo");
		}
		rs.getStatement().close();
		
		//��ʼ��������Ϣ
		Bizlet bzInitFlow = new InitializeFlow();
		bzInitFlow.setAttribute("ObjectType",sObjectType); 
		bzInitFlow.setAttribute("ObjectNo",sNewObjectNo); 
		bzInitFlow.setAttribute("ApplyType",sApplyType); 
		bzInitFlow.setAttribute("UserID",sUserID); 
		bzInitFlow.setAttribute("OrgID",sOrgID); 
		bzInitFlow.setAttribute("FlowNo",sFlowNo); 
		bzInitFlow.setAttribute("PhaseNo",sPhaseNo); 
		bzInitFlow.run(Sqlca);
		System.out.println(sNewObjectNo+"------------");
	    return sNewObjectNo;
	 }

  
}
