package com.amarsoft.app.als.flow.cfg.model;

public class Transition {

	private String id;     //编号
	private String name;   //名称
	private String condition;      //跳转条件
	private Activity fromActivity;   //出端
	private Activity toActivity;     //入端
	
	public Transition(Activity fromActivity, Activity toActivity){
		this.fromActivity = fromActivity;
		this.toActivity = toActivity;
	}
	
	public String getId() {
		return id;
	}
	
	public void setId(String id) {
		this.id = id;
	}
	
	public String getName() {
		return name;
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	public String getCondition() {
		return condition;
	}
	
	public void setCondition(String condition) {
		this.condition = condition;
	}
	
	public Activity getFromActivity() {
		return fromActivity;
	}
	
	public void setFromActivity(Activity fromActivity) {
		this.fromActivity = fromActivity;
	}
	public Activity getToActivity() {
		return toActivity;
	}
	
	public void setToActivity(Activity toActivity) {
		this.toActivity = toActivity;
	}

	public String toString() {
		return "Transition [id=" + id + 
			   ", name=" + name + 
			   ", condition=" + condition + 
			   ", fromActivity=" + fromActivity.getId() + 
			   ", toActivity=" + toActivity.getId() + 
				"]";
	}
}
