package com.amarsoft.app.util;

import java.util.TimerTask;

import javax.servlet.ServletContext;

public class TimerAction extends TimerTask{
	private ServletContext context = null;
	public TimerAction(ServletContext context)
    {
        this.context = context;
    }
	public void run() {
		// �˴���д��������
		BibMailTimer bibMailTimer =new BibMailTimer();
		try {
			bibMailTimer.findNum(context);//����bib�ʼ�Ԥ����������ʱɨ�跢��
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
