package com.amarsoft.app.als.flow.cfg.model;

public class Activity {

	private String id;        //����
	private String type;      //�����
	private String name;      //�����
	private String xCoordinate;   //ͼ��x����
	private String yCoordinate;   //ͼ��y����
	private String width;         //ͼ�ο��
	private String height;        //ͼ�θ߶�
	
	private String belongProcess; //�������̱��
	private String phaseType;     //�׶�����
	private String phaseNo;       //�׶α��
	private String phaseName;     //�׶�����
	private String initScript;    //�а��˳�ʼ���ű�
	private String choiceScript;  //������ɽű�
	private String actionScript;  //�������ɽű�
	private String postScript;    //�����ж�
	
	private String isInuse;        //�ڵ��Ƿ����(�Ƿ�����)
	private String realPostScript; //�ڵ㱻���κ��ֱ����ת�׶�(��֧��AmarScript,û�г���)
	private String editStatus;     //�ڵ�༭״̬(������|�ɱ༭�û�)
	private String tranPhaseNames; //��ת�׶�����
	
	public Activity(){
		
	}
	
	public Activity(String phaseNo){
		this.phaseNo = phaseNo;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getxCoordinate() {
		return xCoordinate;
	}

	public void setxCoordinate(String xCoordinate) {
		this.xCoordinate = xCoordinate;
	}

	public String getyCoordinate() {
		return yCoordinate;
	}

	public void setyCoordinate(String yCoordinate) {
		this.yCoordinate = yCoordinate;
	}

	public String getWidth() {
		return width;
	}

	public void setWidth(String width) {
		this.width = width;
	}

	public String getHeight() {
		return height;
	}

	public void setHeight(String height) {
		this.height = height;
	}

	public String getBelongProcess() {
		return belongProcess;
	}

	public void setBelongProcess(String belongProcess) {
		this.belongProcess = belongProcess;
	}

	public String getPhaseType() {
		return phaseType;
	}

	public void setPhaseType(String phaseType) {
		this.phaseType = phaseType;
	}

	public String getPhaseNo() {
		return phaseNo;
	}

	public void setPhaseNo(String phaseNo) {
		this.phaseNo = phaseNo;
	}

	public String getPhaseName() {
		return phaseName;
	}

	public void setPhaseName(String phaseName) {
		this.phaseName = phaseName;
	}

	public String getInitScript() {
		return initScript;
	}

	public void setInitScript(String initScript) {
		this.initScript = initScript;
	}

	public String getChoiceScript() {
		return choiceScript;
	}

	public void setChoiceScript(String choiceScript) {
		this.choiceScript = choiceScript;
	}

	public String getActionScript() {
		return actionScript;
	}

	public void setActionScript(String actionScript) {
		this.actionScript = actionScript;
	}

	public String getPostScript() {
		return postScript;
	}

	public void setPostScript(String postScript) {
		this.postScript = postScript;
	}

	public String getEditStatus() {
		return editStatus;
	}

	public void setEditStatus(String editStatus) {
		this.editStatus = editStatus;
	}

	public String getIsInuse() {
		return isInuse;
	}

	public void setIsInuse(String isInuse) {
		this.isInuse = isInuse;
	}

	public String getRealPostScript() {
		return realPostScript;
	}

	public void setRealPostScript(String realPostScript) {
		this.realPostScript = realPostScript;
	}

	public String getTranPhaseNames() {
		return tranPhaseNames;
	}

	public void setTranPhaseNames(String tranPhaseNames) {
		this.tranPhaseNames = tranPhaseNames;
	}

	public String toString() {
		return "Activity [id=" + id +
			   ", type=" + type + 
			   ", name=" + name + 
			   ", xCoordinate=" + xCoordinate + 
			   ", yCoordinate=" + yCoordinate +
			   ", width=" + width + 
			   ", height=" + height + 
			   ", belongProcess=" + belongProcess + 
			   ", phaseNo=" + phaseNo + 
			   ", phaseName=" + phaseName + 
			   ", phaseType=" + phaseType + 
			   ", initScript=" + initScript + 
			   ", choiceScript=" + choiceScript + 
			   ", actionScript=" + actionScript + 
			   ", postScript=" + postScript + 
			   ", status=" + editStatus + 
			   "]";
	}

	public boolean equals(Activity obj) {
		if (this == obj) return true;
		if (obj == null) return false;
		
		Activity other = obj;
		
		if (phaseNo == null) {
			if (other.phaseNo != null)
				return false;
		} else if (!phaseNo.equals(other.phaseNo))
			return false;
		
		return true;
	}

	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((phaseNo == null) ? 0 : phaseNo.hashCode());
		return result;
	}

	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Activity other = (Activity) obj;
		if (phaseNo == null) {
			if (other.phaseNo != null)
				return false;
		} else if (!phaseNo.equals(other.phaseNo))
			return false;
		return true;
	}
	
}
