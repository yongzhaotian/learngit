package com.amarsoft.app.util;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import java.util.Timer;//��ʱ���� 

public class SysContextListener implements ServletContextListener {

	private Timer timer = null;
	// ��дcontextInitialized
	public void contextInitialized(ServletContextEvent event) {
		// �������ʼ������������tomcat������ʱ�����������������������ʵ�ֶ�ʱ������
		timer = new Timer(true);
		// �����־������tomcat��־�в鿴��
		event.getServletContext().log("��ʱ��������");
		// ���ö�ʱ����0��ʾ�������ӳ٣�10*60000��ʾÿ��10����ִ�����񣬴�������Ժ�����㡣
		timer.schedule(new TimerAction(event.getServletContext()), 7* 60000, 10 * 60000);
		event.getServletContext().log("�Ѿ��������");
	}

	// ��дcontextDestroyed
	public void contextDestroyed(ServletContextEvent event) {
		// ������رռ��������������������ٶ�ʱ����
		timer.cancel();
		event.getServletContext().log("��ʱ������");
	}
}
