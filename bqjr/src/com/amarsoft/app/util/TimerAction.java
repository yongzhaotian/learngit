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
		// 此处编写任务内容
		BibMailTimer bibMailTimer =new BibMailTimer();
		try {
			bibMailTimer.findNum(context);//调用bib邮件预警方法并定时扫描发送
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
