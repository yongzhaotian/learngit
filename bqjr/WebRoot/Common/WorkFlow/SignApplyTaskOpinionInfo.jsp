<%@ page contentType="text/html; charset=GBK"%>
<jsp:directive.page import="com.amarsoft.app.als.credit.apply.action.AddOpinionInfo"/>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
	Author:   CChang 2003.8.25
	Tester:
	Content: ǩ�����
	Input Param:
		TaskNo��������ˮ��
		ObjectNo��������
		ObjectType����������
	Output param:
	History Log: zywei 2005/07/31 �ؼ�ҳ��
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ǩ�����";
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%	
	//�������
	String sSql = "";
	String sCustomerID = "",sCustomerName = "",sBusinessCurrency = "",sProductVersion="",sLoanRateTermID = "",sRPTTermID = "";
	String sBailCurrency = "",sRateFloatType = "",sBusinessType = "";
	String sApplyType = "",sApproveType = "",sOccurType = "",sBusinessSum = "",sExposureSum = "";
	double dBusinessSum = 0.0,dExposureSum = 0.0,dBaseRate = 0.0,dRateFloat = 0.0,dBusinessRate = 0.0;
	double dBailSum = 0.0,dBailRatio = 0.0,dPdgRatio = 0.0,dPdgSum = 0.0;
	int iTermYear = 0,iTermMonth = 0,iTermDay = 0;
	ASResultSet rs = null;
	
	//��ȡ���������������ˮ�š������š���������
	String sSerialNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("TaskNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sFlowNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	String sPhaseNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	sApproveType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApproveType"));

	
	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";

	//��ʼ�����
	AddOpinionInfo api = new AddOpinionInfo(sObjectNo,sObjectType,sSerialNo,CurUser);
	String opinionNo = api.transfer(tx);
	tx.commit();
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
	<%
	//���ݶ������ͺͶ����Ż�ȡ���̺�
	sSql = 	" select PhaseNo from FLOW_OBJECT "+
			" where ObjectType =:ObjectType "+
			" and ObjectNo =:ObjectNo ";
	sPhaseNo = Sqlca.getString(new SqlObject(sSql).setParameter("ObjectType",sObjectType).setParameter("ObjectNo",sObjectNo));
	if(sPhaseNo == null) sPhaseNo = "";
				
	//���ݶ������ͺͶ����Ż�ȡ��Ӧ��ҵ����Ϣ
	sSql = 	" select CustomerID,CustomerName,BusinessCurrency,BusinessSum,ExposureSum, "+
			" BaseRate,RateFloatType,RateFloat,BusinessRate,BailCurrency, "+
			" BailSum,BailRatio,PdgRatio,PdgSum,BusinessType,TermYear, "+
			" TermMonth,TermDay,OccurType,ApplyType,ProductVersion,LoanRateTermID,RPTTermID "+
			" from BUSINESS_APPLY "+
			" where SerialNo =:SerialNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(rs.next()){
		sCustomerID = rs.getString("CustomerID");
		sCustomerName = rs.getString("CustomerName");
		sBusinessCurrency = rs.getString("BusinessCurrency");
		dBusinessSum = rs.getDouble("BusinessSum");
		dExposureSum = rs.getDouble("ExposureSum");
		dBaseRate = rs.getDouble("BaseRate");
		sRateFloatType = rs.getString("RateFloatType");
		dRateFloat = rs.getDouble("RateFloat");
		dBusinessRate = rs.getDouble("BusinessRate");
		sBailCurrency = rs.getString("BailCurrency");
		dBailSum = rs.getDouble("BailSum");
		dBailRatio = rs.getDouble("BailRatio");
		dPdgRatio = rs.getDouble("PdgRatio");
		dPdgSum = rs.getDouble("PdgSum");
		sBusinessType = rs.getString("BusinessType");
		iTermYear = rs.getInt("TermYear");
		iTermMonth = rs.getInt("TermMonth");
		iTermDay = rs.getInt("TermDay");
		sOccurType = rs.getString("OccurType");
		sApplyType = rs.getString("ApplyType");
		sProductVersion = rs.getString("ProductVersion");
		sLoanRateTermID = rs.getString("LoanRateTermID");
		sRPTTermID = rs.getString("RPTTermID");
		
		//����ֵת��Ϊ���ַ���
		if(sCustomerID == null) sCustomerID = "";
		if(sCustomerName == null) sCustomerName = "";
		if(sBusinessCurrency == null) sBusinessCurrency = "";
		if(sRateFloatType == null) sRateFloatType = "";
		if(sBailCurrency == null) sBailCurrency = "";
		if(sBusinessType == null) sBusinessType = "";
		if(sOccurType == null) sOccurType = "";
		if(sLoanRateTermID == null) sLoanRateTermID = "";
		if(sRPTTermID == null) sRPTTermID = "";
	}
	rs.getStatement().close();
	
	String sHeaders[][]={                       
	                        {"CustomerID","�ͻ����"},
	                        {"CustomerName","�ͻ�����"},
	                        {"BusinessCurrency","ҵ�����"},
	                        {"BusinessSum","������"},
	                        {"ExposureSum","���ڽ��"},
	                        {"TermMonth","����"},
	                        {"TermDay","��"},
	                        {"BaseRate","��׼������(%)"},
	                        {"RateFloatType","���ʸ�����ʽ"},
	                        {"RateFloat","���ʸ���ֵ"},
	                        {"BusinessRate","ִ��������(��)"},
	                        {"LoanRateTermID","������Ϣ"},
	                        {"RPTTermID","���ʽ"},
	                        {"BailCurrency","��֤�����"},
	                        {"BailSum","��֤����"},
	                        {"BailRatio","��֤�����(%)"},	                        
	                        {"PdgRatio","��������(��)"},
	                        {"PdgSum","�����ѽ��(Ԫ)"},
	                        {"PhaseOpinion","���"},
	                        {"InputOrgName","�Ǽǻ���"}, 
	                        {"InputUserName","�Ǽ���"}, 
	                        {"InputTime","�Ǽ�����"}                      
                        };                    
	String sHeaders1[][]={                       
	                        {"CustomerID","�ͻ����"},
	                        {"CustomerName","�ͻ�����"},
	                        {"BusinessCurrency","ҵ�����"},
	                        {"BusinessSum","������"},
	                        {"ExposureSum","���ڽ��"},
	                        {"TermMonth","����"},
	                        {"TermDay","��"},
	                        {"BaseRate","��׼������(%)"},
	                      //������ӻ��޸�-start
		                      {"LoanRateTermID","������Ϣ"},
		                        {"RPTTermID","���ʽ"},
		                      //������ӻ��޸�-end
	                        {"RateFloatType","���ʸ�����ʽ"},
	                        {"RateFloat","���ʸ���ֵ"},
	                        {"BusinessRate","ִ��������(��)"},
	                        {"BailCurrency","��֤�����"},
	                        {"BailSum","��֤����"},
	                        {"BailRatio","��֤�����(%)"},	                        
	                        {"PdgRatio","��������(��)"},
	                        {"PdgSum","�����ѽ��(Ԫ)"},
	                        {"PhaseOpinion","���"},
	                        {"InputOrgName","�Ǽǻ���"}, 
	                        {"InputUserName","�Ǽ���"}, 
	                        {"InputTime","�Ǽ�����"}                      
                        }; 	
    String sHeaders2[][]={                       
	                        {"CustomerID","�ͻ����"},
	                        {"CustomerName","�ͻ�����"},
	                        {"BusinessCurrency","չ�ڱ���"},
	                        {"BusinessSum","չ�ڽ��"},
	                        {"TermMonth","չ������"},
	                        {"TermDay","��"},
	                        {"BaseRate","��׼������(%)"},
	                        {"RateFloatType","���ʸ�����ʽ"},
	                        {"RateFloat","���ʸ���ֵ"},
	                        {"BusinessRate","չ��ִ��������(��)"},
	                      //������ӻ��޸�-start
		                    {"LoanRateTermID","������Ϣ"},
		                    {"RPTTermID","���ʽ"},
		                      //������ӻ��޸�-end
	                        {"BailCurrency","��֤�����"},
	                        {"BailSum","��֤����"},
	                        {"BailRatio","��֤�����(%)"},	                        
	                        {"PdgRatio","��������(��)"},
	                        {"PdgSum","�����ѽ��(Ԫ)"},
	                        {"PhaseOpinion","���"},
	                        {"InputOrgName","�Ǽǻ���"}, 
	                        {"InputUserName","�Ǽ���"}, 
	                        {"InputTime","�Ǽ�����"}                      
                        }; 	
    String sHeaders3[][]={                       
	                        {"PhaseOpinion","���"},
	                        {"InputOrgName","�Ǽǻ���"}, 
	                        {"InputUserName","�Ǽ���"}, 
	                        {"InputTime","�Ǽ�����"}                      
                        };  
	//����SQL���
	sSql = 	" select SerialNo,OpinionNo,ObjectType,ObjectNo,CustomerID, "+
			" CustomerName,BusinessCurrency,BusinessSum,ExposureSum,TermYear,TermMonth, "+
			" TermDay,BaseRate,RateFloatType,RateFloat,BusinessRate,LoanRateTermID,RPTTermID,BailCurrency, "+
			" BailSum,BailRatio,PdgRatio,PdgSum,PhaseOpinion,InputOrg, "+
			" getOrgName(InputOrg) as InputOrgName,InputUser, "+
			" getUserName(InputUser) as InputUserName,InputTime, "+
			" UpdateUser,UpdateTime "+
			" from FLOW_OPINION " +
			" where SerialNo='"+sSerialNo+"' ";

	//ͨ��SQL��������ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sSql);
	
	//�����б��ͷ	
	if(sPhaseNo.equals("0010") || sPhaseNo.equals("3000")) //�����ʼ�׶κͷ��ز������Ͻ׶�
	{
		doTemp.setHeader(sHeaders3); 
	}else
	{
		if(sOccurType.equals("015"))//��������Ϊչ��
		{
			doTemp.setHeader(sHeaders2); 
		}else
		{
			
			//ҵ��Ʒ��Ϊ��ҵ�жһ�Ʊ���֡�Э�鸶ϢƱ�����֡����˾�Ӫѭ�����������Ѻ���
			//���˱�֤������˵�Ѻ�������Ӫ��������������������������ҵ��ѧ���
			//������ѧ������гжһ�Ʊ���֡�����ס��װ�޴�����˸���������˾�Ӫ���
			//���˵�Ѻѭ���������С�����ô������������Ѻ��������ٽ�����ҵ�÷����
			//������ҵ�÷�����������ٽ���ס���������ס��������뷵��ҵ�񡢸���ί�д���
			//��ִ��������
			if(sBusinessType.equals("1020020") || sBusinessType.equals("1020030")
			 || sBusinessType.equals("1110080") || sBusinessType.equals("1110090")
			 || sBusinessType.equals("1110100") || sBusinessType.equals("1110110")
			 || sBusinessType.equals("1110120") || sBusinessType.equals("1110130")
			 || sBusinessType.equals("1110140") || sBusinessType.equals("1110150")
			 || sBusinessType.equals("1020010") || sBusinessType.equals("1110160")	 
			 || sBusinessType.equals("1110200") || sBusinessType.equals("1110170")
			 || sBusinessType.equals("1110070") || sBusinessType.equals("1110060")
			 || sBusinessType.equals("1110050") || sBusinessType.equals("1110040")
			 || sBusinessType.equals("1110030") || sBusinessType.equals("1110020")
			 || sBusinessType.equals("1110010") || sBusinessType.equals("2100")
			 || sBusinessType.equals("1110190")){
				doTemp.setHeader(sHeaders1); 
			}else{ //��ִ֮��������
				doTemp.setHeader(sHeaders);
			}
			//�Ƕ������,���س��ڽ���ֶ�,����BusinessSum��������Ϊ������
			if(!"CreditLineApply".equals(sApplyType)){
				doTemp.setVisible("ExposureSum",false);
				doTemp.setHeader("BusinessSum","������");
			}
			else
			{
				doTemp.setVisible("ExposureSum",true);
				doTemp.setRequired("ExposureSum",true);
			}
		}
		doTemp.setReadOnly("LoanRateTermID", true); //by qzhang1 20131203
		doTemp.setReadOnly("RPTTermID",true);
	}
	
	//�Ա���и��¡����롢ɾ������ʱ��Ҫ������������   
	doTemp.UpdateTable = "FLOW_OPINION";
	doTemp.setKey("SerialNo,OpinionNo",true);		
	doTemp.setUnit("TermMonth","��");
	doTemp.setUnit("TermDay","��");
	doTemp.setVisible("BaseRate,RateFloatType,RateFloat,BusinessRate,PdgRatio,PdgSum",false);
	//�����ֶ��Ƿ�ɼ��ͱ�����	
	if(sPhaseNo.equals("0010") || sPhaseNo.equals("3000")) //�����ʼ�׶κͷ��ز������Ͻ׶�
	{
		doTemp.setVisible("CustomerName,BusinessCurrency,BusinessSum,ExposureSum,BusinessRate,TermMonth,TermDay,BaseRate,RateFloatType,RateFloat,BailSum,BailRatio,PdgRatio,PdgSum",false);
		doTemp.setRequired("PhaseOpinion",true);
	}else
	{
		if(sOccurType.equals("015"))//��������Ϊչ��
		{
			doTemp.setVisible("BailSum,BailRatio,PdgRatio,PdgSum",false);
			doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,PhaseOpinion",true);
			doTemp.setReadOnly("BusinessSum",true);
			doTemp.setHTMLStyle("BaseRate,RateFloatType,RateFloat"," onchange=parent.getBusinessRate(\\'Y\\') ");	
		}else if(sBusinessType.length()>1 && "2".equals(sBusinessType.substring(0,1))){//���ӶԱ���ҵ�����
			doTemp.setVisible("BaseRate,RateFloatType,RateFloat,BusinessRate",false);
			doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,PdgRatio,PdgSum,PhaseOpinion,BailSum,BailRatio",true);	
			doTemp.setHTMLStyle("PdgRatio"," onchange=parent.getpdgsum() ");
			doTemp.setHTMLStyle("PdgSum"," onchange=parent.getPdgRatio() ");
			doTemp.setHTMLStyle("BailRatio"," onchange=parent.getBailSum() ");
			doTemp.setHTMLStyle("BailSum"," onchange=parent.getBailRatio() ");
		}else{
			//ҵ��Ʒ��Ϊ���˸����������ծȯת�������ί�д��������㴢��ת�������ת���
			//ת�����ʽ�����֯���ת�����Ŵ���ת�������������
			if(sBusinessType.equals("1110200") || sBusinessType.equals("2060050")
			 || sBusinessType.equals("1110190") || sBusinessType.equals("2060030")
			 || sBusinessType.equals("2060060") || sBusinessType.equals("2060020")
			 || sBusinessType.equals("2060040") || sBusinessType.equals("2060010"))  
			{
				doTemp.setVisible("BailSum,BailRatio",false);	
				doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,PdgRatio,PdgSum,PhaseOpinion",true);
				if(sBusinessType.equals("1110200") || sBusinessType.equals("1110190"))
					doTemp.setHTMLStyle("BaseRate,RateFloatType,RateFloat"," onchange=parent.getBusinessRate(\\'M\\') ");
				else
					doTemp.setHTMLStyle("BaseRate,RateFloatType,RateFloat"," onchange=parent.getBusinessRate(\\'Y\\') ");
				doTemp.setHTMLStyle("PdgRatio"," onchange=parent.getpdgsum() ");
				doTemp.setHTMLStyle("PdgSum"," onchange=parent.getPdgRatio() ");	
			}
			//ҵ��Ʒ��Ϊ��������֤������ó�ױ����������ࣩ������ó�ױ������������ࣩ���а����̱���
			//�����ŵ��������������������顢���������˰������������������֤��
			//���±������ӹ�װ��ҵ����ڱ�����������������������֤�����ý𱣺�����Լ������
			//�����������Ա��������������Ա��������ϱ��������������Ͷ�걣����͸֧�黹������
			//���гжһ�Ʊ�������Ŵ�֤�����м�֤ȯ���е�����Ԥ�����������ά�ޱ�������𳥻�����
			else if(sBusinessType.equals("1080007") || sBusinessType.equals("2030050")
			 || sBusinessType.equals("2040070") || sBusinessType.equals("2040040")
			 || sBusinessType.equals("2080010") || sBusinessType.equals("2090010")
			 || sBusinessType.equals("2080020")
			 || sBusinessType.equals("2030060") || sBusinessType.equals("2030040")
			 || sBusinessType.equals("1090010") || sBusinessType.equals("2040060")
			 || sBusinessType.equals("2040100") || sBusinessType.equals("2030010")	 
			 || sBusinessType.equals("1080005") || sBusinessType.equals("2040090")
			 || sBusinessType.equals("2040020") || sBusinessType.equals("2040110")
			 || sBusinessType.equals("2030070") || sBusinessType.equals("2040080")
			 || sBusinessType.equals("1080410") || sBusinessType.equals("2040010")	 
			 || sBusinessType.equals("2030030") || sBusinessType.equals("2010")
			 || sBusinessType.equals("2080030") || sBusinessType.equals("2090020")
			 || sBusinessType.equals("2040030") || sBusinessType.equals("2040050")
			 || sBusinessType.equals("2030020"))  
			{
				doTemp.setVisible("BaseRate,RateFloatType,RateFloat,BusinessRate",false);
				doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,BailSum,BailRatio,PdgRatio,PdgSum,PhaseOpinion",true);	
				doTemp.setHTMLStyle("PdgRatio"," onchange=parent.getpdgsum() ");
				doTemp.setHTMLStyle("PdgSum"," onchange=parent.getPdgRatio() ");
				doTemp.setHTMLStyle("BailRatio"," onchange=parent.getBailSum() ");
				doTemp.setHTMLStyle("BailSum"," onchange=parent.getBailRatio() ");
			}
			//ҵ��Ʒ��Ϊ�������������̡����˷��ݴ��������Ŀ���������Ѵ������������	
			else if(sBusinessType.equals("3030030") || sBusinessType.equals("3030010")
			 || sBusinessType.equals("3030020")) 
			{
				doTemp.setVisible("BaseRate,RateFloatType,RateFloat,BusinessRate,PdgRatio,PdgSum",false);
				doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,BailSum,BailRatio,PhaseOpinion",true);	
				doTemp.setHTMLStyle("BailRatio"," onchange=parent.getBailSum() ");
				doTemp.setHTMLStyle("BailSum"," onchange=parent.getBailRatio() ");
			}	
			//ҵ��Ʒ��Ϊ���˾�Ӫ���������ѧ�����ҵ��ѧ����
			else if(sBusinessType.equals("1110170") || sBusinessType.equals("1110150")
			 || sBusinessType.equals("1110140"))
			{
				doTemp.setVisible("PdgRatio,PdgSum",false);
				doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,BailSum,BailRatio,PhaseOpinion",true);	
				doTemp.setHTMLStyle("BaseRate,RateFloatType,RateFloat"," onchange=parent.getBusinessRate(\\'M\\') ");
				doTemp.setHTMLStyle("BailRatio"," onchange=parent.getBailSum() ");
				doTemp.setHTMLStyle("BailSum"," onchange=parent.getBailRatio() ");
			}	
			else if(sBusinessType.equals("1110180"))  //ҵ��Ʒ��Ϊ����ס�����������
			{
				doTemp.setVisible("RateFloatType,RateFloat,BusinessRate,PdgRatio,PdgSum",false);	
				doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,BailSum,BailRatio,PhaseOpinion",true);	
				doTemp.setHTMLStyle("BailRatio"," onchange=parent.getBailSum() ");
				doTemp.setHTMLStyle("BailSum"," onchange=parent.getBailRatio() ");
			}
			else if(sBusinessType.equals("2070"))  //ҵ��Ʒ��Ϊί�д���
			{
				doTemp.setVisible("BailSum,BailRatio,PdgSum",false);
				doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,PdgRatio,PhaseOpinion",true);	
				doTemp.setHTMLStyle("BaseRate,RateFloatType,RateFloat"," onchange=parent.getBusinessRate(\\'Y\\') ");
			}
			else //��֮
			{
				if(sBusinessType.startsWith("3") || sBusinessType.startsWith("20"))//���Ŷ��ҵ�񡢱���ҵ��
					doTemp.setVisible("BusinessRate,BailSum,BailRatio,PdgRatio,PdgSum,BaseRate,RateFloatType,RateFloat",false);
				else
					doTemp.setVisible("BailSum,BailRatio,PdgRatio,PdgSum",false);
				/************add by hwang ���Ӷ�����ҵ����*************/
				//����ҵ��û�����ޣ���������		��ҵ�жһ�Ʊ���֡�Э�鸶ϢƱ�����֡����гжһ�Ʊ���֡�����֤���³���Ѻ�㡢�������³���Ѻ��
				if(sBusinessType.equals("1020020") || sBusinessType.equals("1020030")
				 || sBusinessType.equals("1020010")	|| sBusinessType.equals("1080040")
				 || sBusinessType.equals("1080030") ){
					doTemp.setVisible("TermMonth,TermDay",false);
					doTemp.setRequired("BusinessCurrency,BusinessSum,PhaseOpinion",true);
				}else{
					doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,PhaseOpinion",true);
				}
				//ҵ��Ʒ��Ϊ��ҵ�жһ�Ʊ���֡�Э�鸶ϢƱ�����֡����гжһ�Ʊ���֡����뷵��ҵ��
				//����ס����������ٽ���ס�����������ҵ�÷�����������ٽ�����ҵ�÷����
				//����������Ѻ�������С�����ô�����˵�Ѻѭ��������˾�Ӫѭ�����
				//������Ѻ������˱�֤������˵�Ѻ�������Ӫ�������������������������
				//����ס��װ�޴�����ִ��������
				if(sBusinessType.equals("1020020") || sBusinessType.equals("1020030")
				 || sBusinessType.equals("1020010")	|| sBusinessType.equals("2100")
				 || sBusinessType.equals("1110010") || sBusinessType.equals("1110020")
				 || sBusinessType.equals("1110030") || sBusinessType.equals("1110040")
				 || sBusinessType.equals("1110050") || sBusinessType.equals("1110060")
				 || sBusinessType.equals("1110070") || sBusinessType.equals("1110080")
				 || sBusinessType.equals("1110090") || sBusinessType.equals("1110100") 
				 || sBusinessType.equals("1110110") || sBusinessType.equals("1110120") 
				 || sBusinessType.equals("1110130") || sBusinessType.equals("1110160"))
					doTemp.setHTMLStyle("BaseRate,RateFloatType,RateFloat"," onchange=parent.getBusinessRate(\\'M\\') ");
				else//��ִ֮��������
					doTemp.setHTMLStyle("BaseRate,RateFloatType,RateFloat"," onchange=parent.getBusinessRate(\\'Y\\') ");	
			}	
		}
	}
	
	doTemp.setVisible("SerialNo,OpinionNo,ObjectType,ObjectNo,CustomerID,TermYear,BailCurrency,InputOrg,InputUser,UpdateUser,UpdateTime",false);		
	//���ò��ɸ����ֶ�
	doTemp.setUpdateable("InputOrgName,InputUserName",false);
	//��������������
	doTemp.setDDDWCode("BusinessCurrency,BailCurrency","Currency");
	doTemp.setDDDWCode("RateFloatType","RateFloatType");
	//����ֻ������
	doTemp.setReadOnly("CustomerName,BusinessRate,InputOrgName,InputUserName,InputTime,PdgSum",true);
	//�༭��ʽΪ��ע��
	doTemp.setEditStyle("PhaseOpinion","3");
	//��������ԭ����������� // add by cbsu 2009-11-06
    doTemp.setLimit("PhaseOpinion",400);
	//�����ֶθ�ʽ
	doTemp.setType("BusinessSum,ExposureSum,BaseRate,RateFloat,BusinessRate,BailSum,BailRatio,PdgRatio,PdgSum","Number");
	doTemp.setCheckFormat("BusinessSum,ExposureSum,BaseRate,RateFloat,BusinessRate,BailSum,BailRatio,PdgRatio,PdgSum","2");
	doTemp.setAlign("BusinessSum,ExposureSum,BaseRate,RateFloat,BusinessRate,BailSum,BailRatio,PdgRatio,PdgSum","3");	
	doTemp.setType("TermMonth,TermDay","Number");
	doTemp.setCheckFormat("TermMonth,TermDay","5");
	doTemp.setAlign("TermMonth,TermDay","3");
	//����html��ʽ
	doTemp.setHTMLStyle("PhaseOpinion"," style={height:100px;width:30%;overflow:auto;font-size:9pt;} ");
	doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����������ڵ���0,С�ڵ���100��\" ");
	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"�������ʱ�����ڵ���0,С�ڵ���1000��\" ");
	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��׼�����ʱ�����ڵ���0,С�ڵ���100��\" ");
	doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"���ʸ���ֵ������ڵ���0,С�ڵ���100��\" ");
	doTemp.setHTMLStyle("TermDay"," onchange=parent.getTermDay() ");	
	doTemp.setReadOnly("BailSum",true);
	
	
	/*--------------------------���º��㹦�����Ӵ���-----------------*/
	doTemp.setDDDWSql("LoanRateTermID","select termid,termname from product_term_library where termtype = 'RAT' and objecttype='Product' and objectno='"+sBusinessType+"-"+sProductVersion+"' and status='1' order by TermID desc ");
	doTemp.setDDDWSql("RPTTermID","select termid,termname from product_term_library where termtype='RPT' and objecttype='Product' and objectno='"+sBusinessType+"-"+sProductVersion+"' and status='1'");
	doTemp.setEditStyle("LoanRateTermID,RPTTermID","5");
	doTemp.setHTMLStyle("LoanRateTermID"," onchange=parent.calcLoanRateTermID(\""+BUSINESSOBJECT_CONSTATNTS.flow_opinion+"\",\""+opinionNo+"\") ");
	doTemp.setHTMLStyle("RPTTermID"," onchange=parent.calcRPTTermID(\""+BUSINESSOBJECT_CONSTATNTS.flow_opinion+"\",\""+opinionNo+"\") ");
	StringBuilder sDockOptions = (new StringBuilder()).append("DockID=RatePart").append(";ColSpan=;PositionType=;BlankColsAhead=;BlankColsAfter=");
    doTemp.setColumnAttribute("LoanRateTermID", "DockOptions", sDockOptions.toString());
    sDockOptions = (new StringBuilder()).append("DockID=RPTPart").append(";ColSpan=;PositionType=;BlankColsAhead=;BlankColsAfter=");
    doTemp.setColumnAttribute("RPTTermID", "DockOptions", sDockOptions.toString());
    sDockOptions = (new StringBuilder()).append("DockID=UserPart").append(";ColSpan=;PositionType=;BlankColsAhead=;BlankColsAfter=");
    doTemp.setColumnAttribute("InputOrgName,InputUserName,InputTime,UpdateUser,UpdateTime", "DockOptions", sDockOptions.toString());
	/*--------------------------���º��㹦�����Ӵ���-----------------*/
	
	String bVisibleFlag = doTemp.getColumnAttribute("BusinessSum","Visible");
	if(bVisibleFlag!=null && bVisibleFlag.equals("1")){ //�ɼ�
		//ת��������ʾ��ʽ		
		if(dBusinessSum > 0) {
			sBusinessSum = DataConvert.toMoney(dBusinessSum);
			sExposureSum = DataConvert.toMoney(dExposureSum);
		}
	}
	
	//����ASDataWindow����		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);	
	dwTemp.Style="2";//freeform��ʽ
	
	dwTemp.setHarborTemplate(DWExtendedFunctions.getDWDockHTMLTemplate(Sqlca.getString("select ApplyDetailNo from BUSINESS_TYPE where TypeNo = '"+sBusinessType+"' "),"DockID IN('FEEPart','FINPart','RPTPart','RatePart','SPTPart','UserPart')",Sqlca));
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
			{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ�����","deleteRecord()",sResourcesPath},
			{"true","","Button","�ύ","�ύ����","commitTask()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	function commitTask()
	{
		//����������͡�������ˮ�š��׶α��
		var sObjectType = "<%=sObjectType%>";
		var sObjectNo = "<%=sObjectNo%>";
		var sPhaseNo = "<%=sPhaseNo%>";
		var sUserID = "<%=CurUser.getUserID()%>";
		var sFlowNo = "<%=sFlowNo%>";
		
		//���������ˮ��
		var sSerialNo = "<%=sSerialNo%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ�� 
			return;
		}
		
		//����ҵ���Ƿ��Ѿ��ύ�ˣ�����û��򿪶����������ظ������������Ĵ���
		var sEndTime=RunMethod("WorkFlowEngine","GetEndTime",sSerialNo);
		if(typeof(sEndTime)=="undefined" || sEndTime.trim().length >0) {
			alert("��ҵ����׶������Ѿ��ύ�������ٴ��ύ��");//��ҵ����׶������Ѿ��ύ�������ٴ��ύ��
			reloadSelf();
			return;
		}
				

		//���������ύѡ�񴰿�	     ���Ӳ������ݣ���ֹ�ظ��ύ by yzheng,qxu 2013/6/28	
		//var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sSerialNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		var sPhaseInfo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","AutoCommit","SerialNo="+sSerialNo+",objectType="+sObjectType+",objectNo="+sObjectNo+",oldPhaseNo="+sPhaseNo+",userID="+sUserID);
		if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		else if (sPhaseInfo == "Success"){
			//alert(getHtmlMessage('18'));//�ύ�ɹ���	// comment by tbzeng 2014/05/03 ȡ���ύʱ��������ʾ�ύ�ɹ���Ϣ��
			//top.close();
			
			var sSerialNo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getSerialNo","objectNo="+sObjectNo+",objectType="+sObjectType);
			var sPhaseNo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getPhaseNo","objectNo="+sObjectNo+",objectType="+sObjectType);
			
			var sCompID = "CheckOpinionTab";
			var sCompURL = "/Common/WorkFlow/CheckOpinionTab.jsp";
			OpenComp(sCompID,sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"_blank",OpenStyle);



			//ˢ�¼�����ҳ��
		}else if (sPhaseInfo == "Failure"){
			alert(getHtmlMessage('9'));//�ύʧ�ܣ�
			return;
		}else if (sPhaseInfo == "Working"){//by yzheng,qxu 2013/6/28
			alert(getBusinessMessage('486'));//�������Ѿ��ύ�ˣ������ٴ��ύ��
			reloadSelf();
			return;
		}else{
			sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sSerialNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			//����ύ�ɹ�����ˢ��ҳ��
			if (sPhaseInfo == "Success"){
				alert(getHtmlMessage('18'));//�ύ�ɹ���
				//ˢ�¼�����ҳ��
				}else if (sPhaseInfo == "Failure"){
				alert(getHtmlMessage('9'));//�ύʧ�ܣ�
				return;
			}
		}
	}
	
	
	/*~[Describe=����ǩ������;InputParam=��;OutPutParam=��;]~*/
	function saveRecord()
	{
		sOpinionNo = getItemValue(0,getRow(),"OpinionNo");		
		if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0)
		{
			initOpinionNo();
		}
		//�������������޲���Ϊ0
		dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
		var dExposureSum = getItemValue(0,getRow(),"ExposureSum");
		iTermMonth = getItemValue(0,getRow(),"TermMonth");
		sBusinessType = "<%=sBusinessType%>";
		if("<%=sPhaseNo%>"!="0010"&&"<%=sPhaseNo%>"!="3000")
		{
			//����ҵ��û�����޸�����д�����ҵ�жһ�Ʊ���֡�Э�鸶ϢƱ�����֡����гжһ�Ʊ���֡�����֤���³���Ѻ�㡢�������³���Ѻ��
			if(sBusinessType == "1020020" || sBusinessType=="1020030"  || sBusinessType=="1020010"	|| sBusinessType=="1080040"	 || sBusinessType=="1080030" ){
				if(dBusinessSum<=0)
				{
					alert("�������������0��");
					return;
				}
			}else{//������ҵ��
				if(dBusinessSum<=0 || iTermMonth<=0)
				{
					alert(getBusinessMessage('679'));//�������������޲���Ϊ0��
					//alert("�������޺��������������0��");
					return;
				}
			}
			if (dBusinessSum > "<%=sBusinessSum%>" || dExposureSum > "<%=sExposureSum%>") {
			    alert("�������ܴ��������");
			    return;
			}
			
		}
		//������ǩ������Ϊ�հ��ַ�
		if(/^\s*$/.exec(getItemValue(0,0,"PhaseOpinion"))){
			alert("��ǩ�������");
			setItemValue(0,0,"PhaseOpinion","");
			return;
		}
		saveSubItem();
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		as_save("myiframe0","afterLoad('<%=BUSINESSOBJECT_CONSTATNTS.flow_opinion%>','<%=opinionNo%>')");
	}
	
	/*~[Describe=ɾ����ɾ�����;InputParam=��;OutPutParam=��;]~*/
    function deleteRecord()
    {
	    sSerialNo=getItemValue(0,getRow(),"SerialNo");
	    sOpinionNo = getItemValue(0,getRow(),"OpinionNo");
	    
	    if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0){
	   		alert("����û��ǩ�������������ɾ�����������");
	 	}
	 	else if(confirm("��ȷʵҪɾ�������"))
	 	{
	   		sReturn= RunMethod("BusinessManage","DeleteSignOpinion",sSerialNo+","+sOpinionNo);
	   		if (sReturn==1)
	   		{
	    		alert("���ɾ���ɹ�!");
	  		}
	   		else
	   		{
	    		alert("���ɾ��ʧ�ܣ�");
	   		}
			reloadSelf();
		}
	} 
	
	function getTermDay()
	{
		sBusinessType = "<%=sBusinessType%>";
	    dTermDay = getItemValue(0,getRow(),"TermDay");
	    if(parseInt(dTermDay) > 30 || parseInt(dTermDay) < 0)
	    {
	    	if(!(sBusinessType=="1080005") || !(sBusinessType=="1090010"))
	        alert("���㡱����������ڵ���0,С�ڵ���30��");
	    }
	}
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initOpinionNo() 
	{
		/** --update Object_Maxsnȡ���Ż� tangyb 20150817 start-- 
		var sTableName = "FLOW_OPINION";//����
		var sColumnName = "OpinionNo";//�ֶ���
		var sPrefix = "";//��ǰ׺
		//��ȡ��ˮ��
		var sOpinionNo = getSerialNo(sTableName,sColumnName,sPrefix);*/
		var sOpinionNo = '<%=DBKeyUtils.getSerialNo("FO")%>';
		/** --end --*/
		
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),"OpinionNo",sOpinionNo);
	}
	
	/*~[Describe=����һ���¼�¼;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		//���û���ҵ���Ӧ��¼��������һ���������������ֶ�Ĭ��ֵ
		if (getRowCount(0)==0) 
		{
			as_add("myiframe0");//������¼
			setItemValue(0,getRow(),"SerialNo","<%=sSerialNo%>");
			setItemValue(0,getRow(),"ObjectType","<%=sObjectType%>");
			setItemValue(0,getRow(),"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,getRow(),"CustomerID","<%=sCustomerID%>");
			setItemValue(0,getRow(),"CustomerName","<%=sCustomerName%>");
			setItemValue(0,getRow(),"BusinessCurrency","<%=sBusinessCurrency%>");
			setItemValue(0,getRow(),"BusinessSum","<%=sBusinessSum%>");
			setItemValue(0,getRow(),"ExposureSum","<%=sExposureSum%>");
			setItemValue(0,getRow(),"TermMonth","<%=iTermMonth%>");
			setItemValue(0,getRow(),"TermDay","<%=iTermDay%>");
			setItemValue(0,getRow(),"BaseRate","<%=DataConvert.toMoney(dBaseRate)%>");
			setItemValue(0,getRow(),"RateFloatType","<%=sRateFloatType%>");
			setItemValue(0,getRow(),"RateFloat","<%=DataConvert.toMoney(dRateFloat)%>");
			setItemValue(0,getRow(),"BusinessRate","<%=dBusinessRate%>");
			setItemValue(0,getRow(),"BailCurrency","<%=sBailCurrency%>");
			setItemValue(0,getRow(),"BailRatio","<%=dBailRatio%>");
			setItemValue(0,getRow(),"BailSum","<%= DataConvert.toMoney(dBailSum)%>");
			setItemValue(0,getRow(),"PdgRatio","<%=dPdgRatio%>");
			setItemValue(0,getRow(),"PdgSum","<%=DataConvert.toMoney(dPdgSum)%>");
			setItemValue(0,getRow(),"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,getRow(),"InputOrg","<%=CurOrg.getOrgID()%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,getRow(),"InputTime","<%=StringFunction.getToday()%>");			
			setItemValue(0,getRow(),"LoanRateTermID","<%=sLoanRateTermID%>");
			setItemValue(0,getRow(),"RPTTermID","<%=sRPTTermID%>");
		}        
	}
	
	/*~[Describe=���ݻ�׼���ʡ����ʸ�����ʽ�����ʸ���ֵ����ִ����(��)����;InputParam=��;OutPutParam=��;]~*/
	function getBusinessRate(sFlag)
	{		
		//��׼����
		dBaseRate = getItemValue(0,getRow(),"BaseRate");
		//���ʸ�����ʽ
		sRateFloatType = getItemValue(0,getRow(),"RateFloatType");
		//���ʸ���ֵ
		dRateFloat = getItemValue(0,getRow(),"RateFloat");		
		if(typeof(sRateFloatType) != "undefined" && sRateFloatType != "" 
		&& parseFloat(dBaseRate) >= 0 && parseFloat(dRateFloat) >= 0)
		{					
			if(sRateFloatType=="0")	//�����ٷֱ�
			{	
				if(sFlag == 'Y') //ִ��������
					dBusinessRate = parseFloat(dBaseRate) * (1 + parseFloat(dRateFloat)/100 );
				if(sFlag == 'M') //ִ��������
					dBusinessRate = parseFloat(dBaseRate) * (1 + parseFloat(dRateFloat)/100 ) / 1.2;
			}else	//1:��������
			{
				if(sFlag == 'Y') //ִ��������
					dBusinessRate = parseFloat(dBaseRate) + parseFloat(dRateFloat);
				if(sFlag == 'M') //ִ��������
					//dBusinessRate = (parseFloat(dBaseRate) + parseFloat(dRateFloat)) / 1.2;
					dBusinessRate = parseFloat(dBaseRate)/1.2 + parseFloat(dRateFloat); // �޸�ִ�������ʵļ��㹫ʽ add by cbsu 2009-10-22
			}
			
			dBusinessRate = roundOff(dBusinessRate,6);
			setItemValue(0,getRow(),"BusinessRate",dBusinessRate);			
		}else
		{
			setItemValue(0,getRow(),"BusinessRate","");
		}
	}
	
	/*~[Describe=�����������ʼ���������;InputParam=��;OutPutParam=��;]~*/
	function getpdgsum()
	{
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dPdgRatio = getItemValue(0,getRow(),"PdgRatio");
	        dPdgRatio = roundOff(dPdgRatio,2);
	        if(parseFloat(dPdgRatio) >= 0)
	        {
	            dPdgSum = parseFloat(dBusinessSum)*parseFloat(dPdgRatio)/1000;
	            dPdgSum = roundOff(dPdgSum,2);
	            setItemValue(0,getRow(),"PdgSum",dPdgSum);
	        }
	    }
	}
	
	/*~[Describe=���������Ѽ�����������;InputParam=��;OutPutParam=��;]~*/
	function getPdgRatio()
	{
	   // sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
	   // sBailCurrency = getItemValue(0,getRow(),"BailCurrency");
		//if (sBusinessCurrency != sBailCurrency)
		//	return;
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dPdgSum = getItemValue(0,getRow(),"PdgSum");
	        dPdgSum = roundOff(dPdgSum,2);
	        if(parseFloat(dPdgSum) >= 0)
	        {	       
	            dPdgRatio = parseFloat(sPdgSum)/parseFloat(dBusinessSum)*1000;
	            dPdgRatio = roundOff(dPdgRatio,2);
	            setItemValue(0,getRow(),"PdgRatio",dPdgRatio);
	        }
	    }
	}
	
	/*~[Describe=���ݱ�֤��������㱣֤����;InputParam=��;OutPutParam=��;]~*/
	function getBailSum()
	{
	   // sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
	    //sBailCurrency = getItemValue(0,getRow(),"BailCurrency");
		//if (sBusinessCurrency != sBailCurrency)
		//	return;
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dBailRatio = getItemValue(0,getRow(),"BailRatio");
	        dBailRatio = roundOff(dBailRatio,2);
	        if(parseFloat(dBailRatio) >= 0)
	        {	        
	            dBailSum = parseFloat(dBusinessSum)*parseFloat(dBailRatio)/100;
	            dBailSum = roundOff(dBailSum,2);
	            setItemValue(0,getRow(),"BailSum",dBailSum);
	        }
	    }
	}
	
	/*~[Describe=���ݱ�֤������㱣֤�����;InputParam=��;OutPutParam=��;]~*/
	function getBailRatio()
	{
	  //  sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
	  //  sBailCurrency = getItemValue(0,getRow(),"BailCurrency");
		//if (sBusinessCurrency != sBailCurrency)
		//	return;
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dBailSum = getItemValue(0,getRow(),"BailSum");
	        if(parseFloat(dBailSum) >= 0)
	        {	        
				dBailSum = roundOff(dBailSum,2);
	            dBailRatio = parseFloat(dBailSum)/parseFloat(dBusinessSum)*100;
	            dBailRatio = roundOff(dBailRatio,2);
	            setItemValue(0,getRow(),"BailRatio",dBailRatio);
	        }
	    }
	}
	</script>
<%/*~END~*/%>

<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/loan/loaninfo.js"></script>

<script type="text/javascript">	
	AsOne.AsInit();
	init();
	var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
	/*------------------�������JS����---------------*/
	afterLoad("<%=BUSINESSOBJECT_CONSTATNTS.flow_opinion%>","<%=opinionNo%>"); 
	/*------------------�������JS����---------------*/
</script>	
<%@ include file="/IncludeEnd.jsp"%>