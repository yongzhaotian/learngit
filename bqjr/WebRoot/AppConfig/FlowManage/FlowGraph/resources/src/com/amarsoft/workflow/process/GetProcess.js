
/**
 * <p>Title:  </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) amarsoft.com 2011</p>
 * @author
 */
function GetProcess(wrapper, tableViewer, toolbar) {
    this.base = Ajax;
    this.base();
    this.wrapper = wrapper;
    this.toolbar = toolbar;
    this.tableViewer = tableViewer;
}
GetProcess.prototype = new Ajax();
GetProcess.prototype.setButtonEnable = function (b) {
    if (this.toolbar) {
        this.toolbar.setButtonEnable(b);
    }
};

//
GetProcess.prototype.getProcess = function (name) {
    if (!name) {
        this.name = null;
    	//����ʧ�ܣ���������ͼ����Ϊ�գ�
        alert("\u52a0\u8f7d\u5931\u8d25\uff0c\u5de5\u4f5c\u6d41\u7a0b\u56fe\u540d\u5b57\u4e3a\u7a7a\uff01");
        return false;
    }
    this.name = name;

    //
    this.setButtonEnable(false);

    //
    var url = WorkFlowWorkSpace.URL_GET_PROCESS;
    var method = "POST";
    var params = "name=" + name;

    //
    this.loadXMLHttpRequest(url, method, params);
};

//
GetProcess.prototype.getProcessInst = function (name, curacts) {
    if (!name) {
        this.name = null;
    	//����ʧ�ܣ���������ͼ����Ϊ�գ�
        alert("\u52a0\u8f7d\u5931\u8d25\uff0c\u5de5\u4f5c\u6d41\u7a0b\u56fe\u540d\u5b57\u4e3a\u7a7a\uff01");
        return false;
    }
    this.name = name;

    //
    this.setButtonEnable(false);

    //
    var url = WorkFlowWorkSpace.URL_GET_PROCESS;
    var method = "POST";
    var params = "name=" + name + "&curActs="+curacts;

    //
    this.loadXMLHttpRequest(url, method, params);
};

GetProcess.prototype.onReadyStateChange = function (httpRequest) {
    if (httpRequest.readyState == 4) {
        if (httpRequest.status == 200) {
            this.processXMLHttpRequest(httpRequest);
        } else {
        	//������̳��ִ���
            alert("\u5904\u7406\u8fc7\u7a0b\u51fa\u73b0\u9519\u8bef\uff01");
            this.setButtonEnable(true);
        }
    }
};
GetProcess.prototype.processXMLHttpRequest = function (httpRequest) {
    var doc = httpRequest.responseXML;
    if (!doc) {
    	//����������δ֪��������������
        alert("\u64cd\u4f5c\u7ed3\u675f\uff0c\u672a\u77e5\u670d\u52a1\u5668\u5904\u7406\u7ed3\u679c\uff01");
        this.setButtonEnable(true);
        return false;
    }

    //
    var responseNodes = doc.getElementsByTagName("Response");
    if ((responseNodes != null) && (responseNodes.length > 0)) {
        var responseNode = responseNodes[0];
        var statusValue = eval(responseNode.getAttribute("status"));
        var alertStr = "";
        switch (statusValue) {
          case WorkFlowWorkSpace.STATUS_FAIL:
      		//��ȡʧ�ܡ�
            alertStr = "\u83b7\u53d6\u5931\u8d25\u3002";
            break;
          case WorkFlowWorkSpace.STATUS_XML_PARSER_ERROR:
      		//��ȡʧ�ܣ�xml��������
            alertStr = "\u83b7\u53d6\u5931\u8d25\uff0cxml\u89e3\u6790\u51fa\u9519\u3002";
            break;
          case WorkFlowWorkSpace.STATUS_IO_ERROR:
      		//��ȡʧ�ܣ�IO����
            alertStr = "\u83b7\u53d6\u5931\u8d25\uff0cIO\u9519\u8bef\u3002";
            break;
          case WorkFlowWorkSpace.STATUS_FILE_NOT_FOUND:
      		//��ȡʧ�ܣ��ļ�δ�ҵ���
            alertStr = "\u83b7\u53d6\u5931\u8d25\uff0c\u6587\u4ef6\u672a\u627e\u5230\u3002";
            break;
          default:
        	//��ȡʧ�ܣ�δ֪����
            alertStr = "\u83b7\u53d6\u5931\u8d25\uff0c\u672a\u77e5\u9519\u8bef\u3002";
            break;
        }
        this.setButtonEnable(true);
        alert(alertStr);
    } else {
        var editable = this.wrapper.getModel().isEditable();
        var model = WorkFlowModelConverter.convertXMLToModel(doc);
        model.setName(this.name);
        model.setEditable(editable);
        this.wrapper.setModel(model);
        this.wrapper.setChanged(false);
        if (this.tableViewer) {
            this.tableViewer.setModel(model);
        }
        this.setButtonEnable(true);
    }
};

