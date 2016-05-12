<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: XXGe 2004-11-22
 * Tester:
 * Content: �ڰ��������Ա��Ϣ���в����ʼ��Ϣ
 * Input Param:
 *		  
 * Output param:
 *			
 * History Log:
 *
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	String sSql = "",sReturnValue="";
	String sSql1 = "";	 
	ASResultSet rs = null;
	SqlObject so = null;
	String sAgentName = "",sBelongAgency = "",sPractitionerTime = "";
	String sCompetenceNo = "",sPersistNo = "",sSelfOrgName = "";
	String sDuty = "",sDegree = "",sSpecialty = "",sTypicalCase = "";
	String sAddress = "",sPostNo = "",sRelationTel = "",sRelationMode = "";
	int sAge = 0;
   	
	//��ü�¼��ˮ�š���Ա���02��Ժ����Ա��03������
	String 	sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String 	sPersonType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PersonType"));
	//��ô��������ͣ�010����Ա����020��Ƹ��ʦ
	String 	sAgentType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AgentType"));
	if(sAgentType == null) sAgentType = "";
	//�����Ա��Ϣ��š�������š��������
	String 	sContractInfo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ContractInfo"));
	String 	sBelongNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BelongNo"));
	String 	sDepartType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DepartType"));
	if(sDepartType == null) sDepartType = "";
	String 	sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	
	try{
	   	 sSql =  "  select AgentName,BelongAgency,PractitionerTime,CompetenceNo,SelfOrgName,"+
		   	 	 "  PersistNo,Duty,Age,Degree,Specialty,TypicalCase,AgentAdd,PostNo,RelationTel,RelationMode "+
		   	 	 "  from AGENT_INFO "+
	             "  where SerialNo =:SerialNo ";
	 	so = new SqlObject(sSql).setParameter("SerialNo",sContractInfo);
	   	rs = Sqlca.getASResultSet(so);    	  	
	   	if(rs.next())
		 {
		        //��Ժ��Ա���ơ�������Ժ����ҵʱ�䡢�ʸ�֤��š�ִҵ֤���
		        sAgentName = DataConvert.toString(rs.getString("AgentName"));		
		        sBelongAgency = DataConvert.toString(rs.getString("BelongAgency"));
		        sPractitionerTime = DataConvert.toString(rs.getString("PractitionerTime"));		
		        sCompetenceNo = DataConvert.toString(rs.getString("CompetenceNo")); 
		        sPersistNo = DataConvert.toString(rs.getString("PersistNo")); 
		        sSelfOrgName=DataConvert.toString(rs.getString("SelfOrgName")); 
		        //ְ�����䡢ѧ����ר�������Ͱ�������ַ���ʱࡢ��ϵ�绰��������ϵ��ʽ
		        sDuty = DataConvert.toString(rs.getString("Duty")); 
		        sAge = rs.getInt("Age"); 
		        sDegree = DataConvert.toString(rs.getString("Degree")); 
		        sSpecialty = DataConvert.toString(rs.getString("Specialty")); 
		        sTypicalCase = DataConvert.toString(rs.getString("TypicalCase")); 
		        sAddress = DataConvert.toString(rs.getString("AgentAdd")); 
		        sPostNo = DataConvert.toString(rs.getString("PostNo")); 
		        sRelationTel = DataConvert.toString(rs.getString("RelationTel")); 
		        sRelationMode = DataConvert.toString(rs.getString("RelationMode")); 
		        if (sPersonType.equals("02")) //��Ժ����Ա��Ϣ
				{
			    	sSql1 = " insert into LAWCASE_PERSONS(SerialNo,ObjectNo,ObjectType,DepartType,PersonType,PersonNo,PersonName,OrgNo,OrgName, "+
			    			" Duty,ContactTel,OrgAddress,PostalCode,OtherContactType,InputOrgID,InputUserID,InputDate) "+
					        " values(:SerialNo,:ObjectNo,'LAWCASE_INFO',:DepartType,:PersonType,:PersonNo,:PersonName,"+
					        " :OrgNo,:OrgName,:Duty,:ContactTel,:OrgAddress,:PostalCode,"+
					        " :OtherContactType,:InputOrgID,:InputUserID,:InputDate)";
			    	so = new SqlObject(sSql).setParameter("SerialNo",sSerialNo).setParameter("ObjectNo",sObjectNo)
			    	.setParameter("DepartType",sDepartType).setParameter("PersonType","02")
			    	.setParameter("PersonNo",sContractInfo).setParameter("PersonName",sAgentName)
			    	.setParameter("OrgNo",sBelongNo).setParameter("OrgName",sBelongAgency)
			    	.setParameter("Duty",sDuty).setParameter("ContactTel",sRelationTel)
			    	.setParameter("OrgAddress",sAddress).setParameter("PostalCode",sPostNo)
			    	.setParameter("OtherContactType",sRelationMode).setParameter("InputOrgID",CurOrg.getOrgID())
			    	.setParameter("InputUserID",CurUser.getUserID()).setParameter("InputDate",StringFunction.getToday());
				}
			
			if (sPersonType.equals("03")) //��������Ϣ
			{
			     if(sAge == 0)
			     {
			       	sSql1 = " insert into LAWCASE_PERSONS(SerialNo,ObjectNo,ObjectType,PersonType,PersonNo,PersonName,"+
	      				   	" AgentType,SelfOrgName,OrgNo,OrgName,PractitionerTime,CompetenceNo,PersistNo,Duty,Degree,Specialty,TypicalCase,ContactTel,"+
	      				   	" OrgAddress,PostalCode,OtherContactType,InputOrgID,InputUserID,InputDate) "+
				           	" values(:SerialNo,:ObjectNo,'LAWCASE_INFO',:PersonType,:PersonNo,:PersonName,:AgentType,:SelfOrgName,:OrgNo,:OrgName,:PractitionerTime,"+
				           	" :CompetenceNo,:PersistNo,:Duty,:Degree,:Specialty,:TypicalCase,:ContactTel,:OrgAddress,:PostalCode,"+
					       	" :OtherContactType,:InputOrgID,:InputUserID,:InputDate)";
			       	so = new SqlObject(sSql1).setParameter("SerialNo",sSerialNo).setParameter("ObjectNo",sObjectNo)
			       	.setParameter("PersonType","03").setParameter("PersonNo",sContractInfo)
			       	.setParameter("PersonName",sAgentName).setParameter("AgentType",sAgentType)
			       	.setParameter("SelfOrgName",sSelfOrgName).setParameter("OrgNo",sBelongNo)
			       	.setParameter("OrgName",sBelongAgency).setParameter("PractitionerTime",sPractitionerTime)
			       	.setParameter("CompetenceNo",sCompetenceNo).setParameter("PersistNo",sPersistNo)
			       	.setParameter("Duty",sDuty).setParameter("Degree",sDegree)
			       	.setParameter("Specialty",sSpecialty).setParameter("TypicalCase",sTypicalCase)
			       	.setParameter("ContactTel",sRelationTel).setParameter("OrgAddress",sAddress)
			       	.setParameter("PostalCode",sPostNo).setParameter("OtherContactType",sRelationMode)
			       	.setParameter("InputOrgID",CurOrg.getOrgID()).setParameter("InputUserID",CurUser.getUserID())
			       	.setParameter("InputDate",StringFunction.getToday());
			     }else
			     {
			     	sSql1 = " insert into LAWCASE_PERSONS(SerialNo,ObjectNo,ObjectType,PersonType,PersonNo,PersonName,"+
	      					" AgentType,SelfOrgName,OrgNo,OrgName,PractitionerTime,CompetenceNo,PersistNo,Duty,Age,Degree,Specialty,TypicalCase,ContactTel,"+
	      					" OrgAddress,PostalCode,OtherContactType,InputOrgID,InputUserID,InputDate) "+
				         	" values(:SerialNo,:ObjectNo,'LAWCASE_INFO',:PersonType,:PersonNo,:PersonName,:AgentType,:SelfOrgName,:OrgNo,:OrgName,:PractitionerTime,"+
				         	" :CompetenceNo,:PersistNo,:Duty,:Age,:Degree,:Specialty,:TypicalCase,:ContactTel,:OrgAddress,:PostalCode,"+
					        " :OtherContactType,:InputOrgID,:InputUserID,:InputDate)";
					        
			       	so = new SqlObject(sSql1).setParameter("SerialNo",sSerialNo).setParameter("ObjectNo",sObjectNo)
			       	.setParameter("PersonType","03").setParameter("PersonNo",sContractInfo)
			       	.setParameter("PersonName",sAgentName).setParameter("AgentType",sAgentType)
			       	.setParameter("SelfOrgName",sSelfOrgName).setParameter("OrgNo",sBelongNo)
			       	.setParameter("OrgName",sBelongAgency).setParameter("PractitionerTime",sPractitionerTime)
			       	.setParameter("CompetenceNo",sCompetenceNo).setParameter("PersistNo",sPersistNo)
			       	.setParameter("Duty",sDuty).setParameter("Age",sAge).setParameter("Degree",sDegree)
			       	.setParameter("Specialty",sSpecialty).setParameter("TypicalCase",sTypicalCase)
			       	.setParameter("ContactTel",sRelationTel).setParameter("OrgAddress",sAddress)
			       	.setParameter("PostalCode",sPostNo).setParameter("OtherContactType",sRelationMode)
			       	.setParameter("InputOrgID",CurOrg.getOrgID()).setParameter("InputUserID",CurUser.getUserID())
			       	.setParameter("InputDate",StringFunction.getToday());
			     }	
			}		
			Sqlca.executeSQL(so);
		}
		rs.getStatement().close();
		sReturnValue="true";
	}catch(Exception e){
		e.fillInStackTrace();
		sReturnValue="false";
	}
	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sReturnValue);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>
<%@ include file="/IncludeEndAJAX.jsp"%>