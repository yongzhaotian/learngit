package com.amarsoft.app.util;
import javax.servlet.ServletContext;

import com.amarsoft.app.util.MultiMailSender.MultiMailSenderInfo;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.awe.Configure;
import com.amarsoft.awe.util.Transaction;

public class BibMailTimer {

	public void findNum(ServletContext context) throws Exception {
		//获得连接对象
		String dbname = "";
		dbname = Configure.getInstance(context).getConfigure("DataSource");
		Transaction Sqlca = new Transaction(dbname);

		// 当前系统时间
		String dateTime = DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss");// 当前系统时间

		try {
			// 待审单量
			int AuditSum = Integer.parseInt(Sqlca.getString("select count(1) from FLOW_TASK FT, BUSINESS_CONTRACT BC where FT.ObjectType = 'BusinessContract' and FT.Objectno = BC.Serialno and (BC.cancelstatus <> '1' or BC.cancelstatus is null or BC.cancelstatus=' ' or BC.cancelstatus='') and FT.FlowNo in ('WF_MEDIUM02', 'WF_HARD02', 'WF_EASY02', 'WF_MEDIUM', 'WF_HARD',  'WF_EASY',  'WF_EASY03', 'WF_Fork', 'NCIIC_AUTO15', 'CreditFlow', 'CashLoanFlow', 'WF_NCL1', 'WF_CCCL','CE_RRefenrence_2','CE_REJECTINFERENCE1') and FT.GroupInfo like '%110%' and FT.UserID is null and (FT.EndTime is null or FT.EndTime = ' ' or FT.EndTime = '') and ft.phasetype ='1020'  and ft.phasename <> 'CE专家审核' "));
			// 单量最大等待时间值
			int MaxiMum = Integer.parseInt(Sqlca.getString("select trunc(nvl(max((sysdate - to_date(begintime, 'yyyy-mm-dd HH24:mi:ss')) * 60 * 24), 0), 0) from flow_task t, (select ft.objectno as objectno from flow_task ft, business_contract bc where bc.serialno = ft.objectno and (BC.cancelstatus <> '1' or BC.cancelstatus is null or BC.cancelstatus=' ' or BC.cancelstatus='') and ft.objecttype = 'BusinessContract' and ft.phasetype ='1020'  and (ft.UserID is null or ft.UserID = '') and (FT.EndTime is null or FT.EndTime = ' ' or FT.EndTime = '')  and ft.flowno <> 'CreditFlow'  and ft.phaseopinion1 is null  and CreditAttribute = '0002'  and ft.phasename <> 'CE专家审核'  ) a where t.objectno = a.objectno  and t.serialno = (select max(serialno) from flow_task where objectno = a.objectno) and t.phasetype ='1020' "));
			// 在线人数
			int OnLineSum = Integer.parseInt(Sqlca.getString("select count(1)  from (select count(1) from user_list ul  where ul.begintime <= to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') and ul.begintime >= to_char(sysdate - 1, 'yyyy/mm/dd HH24:MI:SS') and ul.endtime is null and ul.userid in (select userid from USER_INFO  where BelongOrg in (select OrgID from ORG_INFO where SortNo like '102%') and isCar = '02') group by userid)"));
			// 在线审核人数
			int OnLineWorkSum = Integer.parseInt(Sqlca.getString("select count(1) from (select distinct (userid) as UserID, (select beginTime from flow_task  where serialno =  (select max(serialno) from flow_task where userid = u.userid and taskState = '1' and (endTime = '' or endTime is null))) as Endtime from user_list u where begintime <= to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') and begintime >= to_char(sysdate - 1, 'yyyy/mm/dd HH24:MI:SS') and (endTime = '' or endTime is null) and u.userid in (select userid from USER_INFO where BelongOrg in (select OrgID  from ORG_INFO where SortNo in ('102') and isCar = '02'))) t where t.Endtime is not null"));
			// 最近10分钟单量
			int EndTimeTen = Integer.parseInt(Sqlca.getString("select count(1) from flow_task f, business_contract b where f.objectno = b.serialno and f.phaseopinion4 is not null and f.phasetype = '1010' and f.phaseopinion4 <= to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') and f.phaseopinion4 >= to_char(sysdate - 10 / 24 / 60, 'yyyy/mm/dd HH24:MI:SS')"));
			// 最近60分钟单量
			int EndTime = Integer.parseInt(Sqlca.getString("select count(1) from flow_task f, business_contract b where f.objectno = b.serialno and f.phaseopinion4 is not null and f.phasetype = '1010' and f.phaseopinion4 <= to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') and f.phaseopinion4 >= to_char(sysdate - 60 / 24 / 60, 'yyyy/mm/dd HH24:MI:SS')"));

			System.out.println("dateTime====" + dateTime + "==&&&&&&&&&EndTimeTen:" + EndTimeTen + "#########EndTime:" + EndTime + "@@@@@@@@@@@@MaxiMum=" + MaxiMum + "***********OnLineSum=" + OnLineSum+ "***********OnLineWorkSum=" + OnLineWorkSum);

			// 等待审核员处理的单量大于当前审核员登录系统人数的2倍-----AuditSum>=2*OnLineSum并且最长等待审核员处理单的时间已超过10分钟----------MaxiMum>=10min
			if ((AuditSum >= 2 * OnLineSum) && (MaxiMum >= 10)) {
				String dateString = "<table><tr><td>当前时间</td><td>" + dateTime + "</td></tr>";
				String maxSum = "<tr><td>等待审核的单量</td><td>" + AuditSum + "</td></tr>";
				String tenSum = "<tr><td>过去10分钟申请的单量</td><td>" + EndTimeTen + "</td> </tr>";
				String sixtitySum = "<tr><td>过去60分钟申请的单量</td><td>" + EndTime + "</td> </tr>";
				String maxTime = "<tr><td>最大等待时长</td><td>" + MaxiMum + "分</td></tr>";
				String onlinePeople = "<tr><td>当前正在审单的专员数量/当前在线的专员数量</td><td>" + OnLineWorkSum+"/"+OnLineSum + "</td></tr></table>";
				
				// 创建邮件信息
				MultiMailSenderInfo mailInfo2 = new MultiMailSenderInfo();
				mailInfo2.setMailServerHost("smtp.billionsfinance.cn");// 邮件服务器
				mailInfo2.setMailServerPort("25");// 邮件端口号
				mailInfo2.setValidate(true);
				mailInfo2.setUserName("ITHotline01@billionsfinance.cn");// 发件人邮件账号
				mailInfo2.setPassword("1234@abc");// 您的邮箱密码

				mailInfo2.setFromAddress("ITHotline01@billionsfinance.cn");// 发件人
				mailInfo2.setToAddress("hongli.zheng@billionsfinance.cn");//高级经理收件人
				
				
				mailInfo2.setSubject("运营审核部BIB报警邮件！");// 邮件主题
				mailInfo2.setContent(dateString + maxSum + tenSum + sixtitySum + maxTime + onlinePeople);// 邮件内容拼接
				String[] receivers = new String[] { "UW-Management@billionsfinance.cn" };// 抄送收件人数组列(审核管理群组)
				String[] ccs = receivers;
				mailInfo2.setReceivers(receivers);
				mailInfo2.setCcs(ccs);
				// MultiMailSender.sendMailtoMultiReceiver(mailInfo2);//发送多人方式
				MultiMailSender.sendMailtoMultiCC(mailInfo2);// 抄送方式
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
		}
	}
}
