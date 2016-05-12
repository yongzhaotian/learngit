package com.amarsoft.app.util;
import javax.servlet.ServletContext;

import com.amarsoft.app.util.MultiMailSender.MultiMailSenderInfo;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.awe.Configure;
import com.amarsoft.awe.util.Transaction;

public class BibMailTimer {

	public void findNum(ServletContext context) throws Exception {
		//������Ӷ���
		String dbname = "";
		dbname = Configure.getInstance(context).getConfigure("DataSource");
		Transaction Sqlca = new Transaction(dbname);

		// ��ǰϵͳʱ��
		String dateTime = DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss");// ��ǰϵͳʱ��

		try {
			// ������
			int AuditSum = Integer.parseInt(Sqlca.getString("select count(1) from FLOW_TASK FT, BUSINESS_CONTRACT BC where FT.ObjectType = 'BusinessContract' and FT.Objectno = BC.Serialno and (BC.cancelstatus <> '1' or BC.cancelstatus is null or BC.cancelstatus=' ' or BC.cancelstatus='') and FT.FlowNo in ('WF_MEDIUM02', 'WF_HARD02', 'WF_EASY02', 'WF_MEDIUM', 'WF_HARD',  'WF_EASY',  'WF_EASY03', 'WF_Fork', 'NCIIC_AUTO15', 'CreditFlow', 'CashLoanFlow', 'WF_NCL1', 'WF_CCCL','CE_RRefenrence_2','CE_REJECTINFERENCE1') and FT.GroupInfo like '%110%' and FT.UserID is null and (FT.EndTime is null or FT.EndTime = ' ' or FT.EndTime = '') and ft.phasetype ='1020'  and ft.phasename <> 'CEר�����' "));
			// �������ȴ�ʱ��ֵ
			int MaxiMum = Integer.parseInt(Sqlca.getString("select trunc(nvl(max((sysdate - to_date(begintime, 'yyyy-mm-dd HH24:mi:ss')) * 60 * 24), 0), 0) from flow_task t, (select ft.objectno as objectno from flow_task ft, business_contract bc where bc.serialno = ft.objectno and (BC.cancelstatus <> '1' or BC.cancelstatus is null or BC.cancelstatus=' ' or BC.cancelstatus='') and ft.objecttype = 'BusinessContract' and ft.phasetype ='1020'  and (ft.UserID is null or ft.UserID = '') and (FT.EndTime is null or FT.EndTime = ' ' or FT.EndTime = '')  and ft.flowno <> 'CreditFlow'  and ft.phaseopinion1 is null  and CreditAttribute = '0002'  and ft.phasename <> 'CEר�����'  ) a where t.objectno = a.objectno  and t.serialno = (select max(serialno) from flow_task where objectno = a.objectno) and t.phasetype ='1020' "));
			// ��������
			int OnLineSum = Integer.parseInt(Sqlca.getString("select count(1)  from (select count(1) from user_list ul  where ul.begintime <= to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') and ul.begintime >= to_char(sysdate - 1, 'yyyy/mm/dd HH24:MI:SS') and ul.endtime is null and ul.userid in (select userid from USER_INFO  where BelongOrg in (select OrgID from ORG_INFO where SortNo like '102%') and isCar = '02') group by userid)"));
			// �����������
			int OnLineWorkSum = Integer.parseInt(Sqlca.getString("select count(1) from (select distinct (userid) as UserID, (select beginTime from flow_task  where serialno =  (select max(serialno) from flow_task where userid = u.userid and taskState = '1' and (endTime = '' or endTime is null))) as Endtime from user_list u where begintime <= to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') and begintime >= to_char(sysdate - 1, 'yyyy/mm/dd HH24:MI:SS') and (endTime = '' or endTime is null) and u.userid in (select userid from USER_INFO where BelongOrg in (select OrgID  from ORG_INFO where SortNo in ('102') and isCar = '02'))) t where t.Endtime is not null"));
			// ���10���ӵ���
			int EndTimeTen = Integer.parseInt(Sqlca.getString("select count(1) from flow_task f, business_contract b where f.objectno = b.serialno and f.phaseopinion4 is not null and f.phasetype = '1010' and f.phaseopinion4 <= to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') and f.phaseopinion4 >= to_char(sysdate - 10 / 24 / 60, 'yyyy/mm/dd HH24:MI:SS')"));
			// ���60���ӵ���
			int EndTime = Integer.parseInt(Sqlca.getString("select count(1) from flow_task f, business_contract b where f.objectno = b.serialno and f.phaseopinion4 is not null and f.phasetype = '1010' and f.phaseopinion4 <= to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') and f.phaseopinion4 >= to_char(sysdate - 60 / 24 / 60, 'yyyy/mm/dd HH24:MI:SS')"));

			System.out.println("dateTime====" + dateTime + "==&&&&&&&&&EndTimeTen:" + EndTimeTen + "#########EndTime:" + EndTime + "@@@@@@@@@@@@MaxiMum=" + MaxiMum + "***********OnLineSum=" + OnLineSum+ "***********OnLineWorkSum=" + OnLineWorkSum);

			// �ȴ����Ա����ĵ������ڵ�ǰ���Ա��¼ϵͳ������2��-----AuditSum>=2*OnLineSum������ȴ����Ա������ʱ���ѳ���10����----------MaxiMum>=10min
			if ((AuditSum >= 2 * OnLineSum) && (MaxiMum >= 10)) {
				String dateString = "<table><tr><td>��ǰʱ��</td><td>" + dateTime + "</td></tr>";
				String maxSum = "<tr><td>�ȴ���˵ĵ���</td><td>" + AuditSum + "</td></tr>";
				String tenSum = "<tr><td>��ȥ10��������ĵ���</td><td>" + EndTimeTen + "</td> </tr>";
				String sixtitySum = "<tr><td>��ȥ60��������ĵ���</td><td>" + EndTime + "</td> </tr>";
				String maxTime = "<tr><td>���ȴ�ʱ��</td><td>" + MaxiMum + "��</td></tr>";
				String onlinePeople = "<tr><td>��ǰ�����󵥵�רԱ����/��ǰ���ߵ�רԱ����</td><td>" + OnLineWorkSum+"/"+OnLineSum + "</td></tr></table>";
				
				// �����ʼ���Ϣ
				MultiMailSenderInfo mailInfo2 = new MultiMailSenderInfo();
				mailInfo2.setMailServerHost("smtp.billionsfinance.cn");// �ʼ�������
				mailInfo2.setMailServerPort("25");// �ʼ��˿ں�
				mailInfo2.setValidate(true);
				mailInfo2.setUserName("ITHotline01@billionsfinance.cn");// �������ʼ��˺�
				mailInfo2.setPassword("1234@abc");// ������������

				mailInfo2.setFromAddress("ITHotline01@billionsfinance.cn");// ������
				mailInfo2.setToAddress("hongli.zheng@billionsfinance.cn");//�߼������ռ���
				
				
				mailInfo2.setSubject("��Ӫ��˲�BIB�����ʼ���");// �ʼ�����
				mailInfo2.setContent(dateString + maxSum + tenSum + sixtitySum + maxTime + onlinePeople);// �ʼ�����ƴ��
				String[] receivers = new String[] { "UW-Management@billionsfinance.cn" };// �����ռ���������(��˹���Ⱥ��)
				String[] ccs = receivers;
				mailInfo2.setReceivers(receivers);
				mailInfo2.setCcs(ccs);
				// MultiMailSender.sendMailtoMultiReceiver(mailInfo2);//���Ͷ��˷�ʽ
				MultiMailSender.sendMailtoMultiCC(mailInfo2);// ���ͷ�ʽ
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
		}
	}
}
