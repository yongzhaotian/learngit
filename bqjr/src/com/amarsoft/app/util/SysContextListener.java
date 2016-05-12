package com.amarsoft.app.util;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import java.util.Timer;//定时器类 

public class SysContextListener implements ServletContextListener {

	private Timer timer = null;
	// 重写contextInitialized
	public void contextInitialized(ServletContextEvent event) {
		// 在这里初始化监听器，在tomcat启动的时候监听器启动，可以在这里实现定时器功能
		timer = new Timer(true);
		// 添加日志，可在tomcat日志中查看到
		event.getServletContext().log("定时器已启动");
		// 调用定时任务，0表示任务无延迟，10*60000表示每隔10分钟执行任务，触发间隔以毫秒计算。
		timer.schedule(new TimerAction(event.getServletContext()), 7* 60000, 10 * 60000);
		event.getServletContext().log("已经添加任务");
	}

	// 重写contextDestroyed
	public void contextDestroyed(ServletContextEvent event) {
		// 在这里关闭监听器，所以在这里销毁定时器。
		timer.cancel();
		event.getServletContext().log("定时器销毁");
	}
}
