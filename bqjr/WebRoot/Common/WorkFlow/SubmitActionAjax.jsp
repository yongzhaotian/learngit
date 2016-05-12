<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMDAJAX.jsp"%><%@
 page import="com.amarsoft.biz.workflow.*" %><%@
 page import="com.amarsoft.amarscript.*" %><%
	/*
		Content: ��ʾ��һ�׶���Ϣ
		Input Param:
			SerialNo����ǰ�������ˮ��
			PhaseAction����ѡ����һ������
			PhaseOpinion1�����
		Output param:
			sReturnValue:	����ֵCommit��ʾ��ɲ���
	 */
	String sSerialNo = CurPage.getParameter("SerialNo");//���ϸ�ҳ��õ������������ˮ��
	String oldPhaseNo = CurPage.getParameter("oldPhaseNo");//��ǰ���ύҵ�������׶�
	String objectType = CurPage.getParameter("objectType");//��ǰ���ύҵ�����������е����̶�������
	String objectNo = CurPage.getParameter("objectNo");//��ǰ���ύҵ�����������е����̶�����
	String sPhaseAction = CurPage.getParameter("PhaseAction");//���ϸ�ҳ��õ�����Ķ�����Ϣ
	String sPhaseOpinion1 = CurPage.getParameter("PhaseOpinion1");//���ϸ�ҳ��õ�����������Ϣ
	//����ֵת���ɿ��ַ���
	if(sSerialNo == null) sSerialNo = "";
	if(oldPhaseNo == null) oldPhaseNo = "";
	if(objectType == null) objectType = "";
	if(objectNo == null) objectNo = "";
	if(sPhaseAction == null) sPhaseAction = "";
	if(sPhaseOpinion1 == null) sPhaseOpinion1 = "";
	String sReturnValue="";
	
	//������������ؽ׶���Ϣ���׶�����
	String sPhaseInfo = "",sNextPhaseName = "",sNextPhaseNo = "",sNextPhaseNameStr="";
	String sToday = StringFunction.getTodayNow();

	//����ҵ���Ƿ��Ѿ��ύ�ˣ�����û��򿪶����������ظ������������Ĵ��󣩡� 
	ASMethod	asm = new ASMethod("WorkFlowEngine","GetEndTime",Sqlca);//����endtime��ΪУ���ֶ� by qxu 2013/6/28
	Any anyValue  = asm.execute(sSerialNo);
	String endTime = anyValue.toString();
	
	if(endTime.length() > 0){
		sReturnValue= "Working";//�÷Ŵ������Ѿ��ύ�ˣ������ٴ��ύ��
	}else{
		//��ʼ���������
		FlowTask ftBusiness = new FlowTask(sSerialNo,Sqlca);
		//ִ���ύ����
		FlowPhase flowphase = null;
		FlowPhase[] fpFlow = ftBusiness.commitAction(sPhaseAction,sPhaseOpinion1);
		
		for(int i=0;i<fpFlow.length;i++)
		{
			flowphase = fpFlow[i];
			//��ȡ��һ�׶εĽ׶�����
			sNextPhaseName = flowphase.PhaseName;
			sNextPhaseNo = flowphase.PhaseNo;
			sNextPhaseNameStr += sNextPhaseName+";";
		}
		
		//ƴ����ʾ��Ϣ
		sPhaseInfo="��һ�׶�:";
		sPhaseInfo = sPhaseInfo+" " + sNextPhaseNameStr;		
		if (sPhaseInfo!=null && sPhaseInfo.trim().length()>0){
			sReturnValue="Success";
		}else{
			sReturnValue="Failure";
		}
		if("8000".equals(sNextPhaseNo)&&"TransFeeFlow".equals(ftBusiness.FlowNo)){//���ü��� �ѷ�� 010�����·��ü���ѱ�״̬
			String updateSql = "update acct_fee_waive afw set afw.status='0' where afw.remark=:serialno and afw.status='1'";
			Sqlca.executeSQL(new SqlObject(updateSql).setParameter("serialno", ftBusiness.ObjectNo));
		}//add by jiangyuanlin 20150805 �޸ķ��ü������󣬲����ٴ�����
		// add by tbzeng 2014/07/11
		//�½׶�Ϊ��׼����������׼�����º�ͬ״̬
		String sSql = "";
		if(sNextPhaseNo.equals("1000") || sNextPhaseNo.equals("2000")){//����׼ 080
			sSql = "update business_contract set contractstatus = '080' where SerialNo = :Serialno";
		}else if(sNextPhaseNo.equals("8000")){//�ѷ�� 010
			sSql = "update business_contract set contractstatus = '010' where SerialNo = :Serialno";
		}else if(sNextPhaseNo.equals("9000")){//��ȡ��
			sSql = "update business_contract set contractstatus = '100' where SerialNo = :Serialno";
		}else{//�·���
			if (!sNextPhaseNo.equals("0010")) {
				sSql = "update business_contract set contractstatus = '070' where SerialNo = :Serialno";
			} else {
				sSql = "update business_contract set contractstatus = '060' where SerialNo = :Serialno";
			}
		}
		
		if (sSql!=null && sSql.length() > 0) {
			Sqlca.executeSQL(new SqlObject(sSql).setParameter("Serialno", objectNo));
			Sqlca.commit();
		}
		// end 2014/07/11
	}
	out.println(sReturnValue);
%><%@ include file="/IncludeEndAJAX.jsp"%>