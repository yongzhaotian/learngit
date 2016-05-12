/*==================================================
 * @module: jquery.treeTable.extends.js
 * @author: syang
 * @createDate: 2010/09/26 10:28
 * @refactDate: 2011/07/26 16:27
 * @purpose: TreeTable��չ��������addOperatorColumn��������⣬���෽����TreeTableRenderer.java���ܹ���
 *==================================================*/

/************************************
 * ��չ������̬����
 * ---------------------------------
 * @date: 2011/07/26
 * @version: 1.0
 ************************************/
jQuery.extend({
    // �ַ�����ʽ�����
    format : function(string){
            var args=arguments;
            var pattern = new RegExp("%([1-"+arguments.length+"])","g");
            return new String(string).replace(pattern,function(match,index){return args[index];});
    },
    //��JSON����תΪ�ִ����������Ϊ�༶JSON���󣬲����ݹ鴦����ֹ����ѭ�����ã���ջ���
    JSON2String : function (jsonObject){
        var stringBuffer = new Array();
        if(typeof(jsonObject) != "object")return s;
        for(var k in jsonObject){
            var v = jsonObject[k];
            if(typeof(v) != "number") v = "\""+v+"\"";
            stringBuffer.push("\""+k+"\":"+v);
        }
        return "{"+stringBuffer.join(",")+"}";
    }
});


/************************************
 * ���������
 * ---------------------------------
 * @date: 2011/07/26
 * @version: 1.0
 ************************************/
(function($){
    $.fn.tableLight = function(opts) {
        var defaults = {
                triggetSelector:"tr",
                lightClass:"highlight",
                selectedClass:"selected"
        };
        var options = $.extend(defaults, opts);
        return this.each(function(){
            var context = $(this);
            $(options.triggetSelector,context).click(function(){
                $("."+options.selectedClass,context).removeClass("selected");
                $(this).addClass(options.selectedClass);
            });
            $(options.triggetSelector,context).mouseover(function(){
                if($(this).hasClass(options.selectedClass))return;
                $(this).addClass(options.lightClass);
            });
            $(options.triggetSelector,context).mouseout(function(){
                $(this).removeClass(options.lightClass);
            });
        });
    };
})(jQuery);
/************************************
 * ����������
 * ---------------------------------
 * @date: 2011/07/28
 * @version: 1.0
 ************************************/
(function($){
    $.fn.searchText = function(opts){
        var defaults = {
                keyWord:undefined,  //�ؼ���
                excludeColumn:""    //����������
        };
        var options = $.extend(defaults, opts);
        
        var searchResult = [];//����������
        $("tbody tr",$(this)).each(function(){
          //�����ʽ
          $(this).click(function(){
              $("td.searchText",$(this)).removeClass("searchText");
          });
          $("td.searchText",$(this)).removeClass("searchText");//�Ƴ�֮ǰ������ʽ
          //��ʼ����
          if(options.keyWord){
              var r = $("td:contains('" + options.keyWord + "')",$(this));
              //����н���Ҳ����ų��У�����Ⱦ��ʽ
              var exclude = options.excludeColumn.split(",");
              var est = {};
              for(var i=0;i<exclude.length;i++) est[exclude[i]]=true;
              if(!est[r.attr("name")]&&r.size()>0){
                  searchResult.push(r);
                  r.addClass("searchText");
                  //�ҳ��������Ƚڵ㣬����չ��
                  $($(this).ancestors().reverse()).each(function(){
                    $(this).expand();
                  });
              }
          }
        });
        return searchResult;
    };
})(jQuery);
/************************************
 * TreeTable�����չ֧��
 * �ò����TreeTableRenderer.java�����Ƚϸ�
 * ---------------------------------
 * @date: 2011/07/26
 * @version: 1.0
 ************************************/
(function($){
    //ȡ����name�ֶε�ֵ
    $.fn.getValue = function(name){
        if(!name) alert("����getValue(name)û�д������name");
        var jsonObject = $(this).nodeJSON();
        return jsonObject[name];
    };
    $.fn.nodeJSON = function(json){
        if(!json){
            return eval("("+$(this).attr("nodeData")+")");
        	//return ($(this).attr("nodeData"));
        }else{
            $(this).attr("nodeData",$.JSON2String(json));
        }
    };
    //��������name�ֶε�ֵ
    $.fn.setValue = function(name,value){
        if(!name) alert("����setValue(name,value)û�д������name");
        if(!value) alert("����setValue(name,value)û�д������value");
        var jsonObject = $(this).nodeJSON();                       //ȡ��JSON
        if(typeof(jsonObject[name])!="undefined"){
            jsonObject[name]=value;                                  //�޸�JSONֵ
            $("[name='"+name+"']",$(this)).text(value);               //�޸�DOM�ڵ�ֵ
            if(name=="id")$(this).attr("id",value);
            $(this).nodeJSON(jsonObject);                            //��дJSON
        }else{
            alert($.format("�ֶ�%1������",name));
        }
    },
    //�Ƴ�һ��
    $.fn.removeColumn = function(opts){
        var defaults = {
                name:"newcolumn"//�Ƴ��еĵ�����
                };
        var options = $.extend(defaults, opts);
        return this.each(function(){
            var context = $(this);
            var headerSelector = "thead tr th[name='"+options.name+"']";
            var bodySelector = "tbody tr td[name='"+options.name+"']";
            $(headerSelector,context).remove();
            $(bodySelector,context).each(function(){$(this).remove();});
        });
        
    };
    // ���һ��������
    $.fn.addExecuteColumn = function(opts) {
        var defaults = {
                colIndex:-1,                //��������-1��ʾֱ�������ĩβ
                name:"newcolumn",        //������
                headerText:"�µĲ�����",     //��ʾ����
                colClass:"button-cell",     //����ʽ
                buttons:[]
        };
        //Ĭ�ϰ�ť����
        var defaultButtonSetting = {
                filter:function(currentTr){return true;},
                text:"�°�ť",
                buttonClass:"",
                title:"",
                execute:function(){alert("δʵ�ֵĶ���");}
        };
        var options = $.extend(defaults, opts);
        return this.each(function(){
            var context = $(this);
            //����ͷ�������岿�ֱ��ʽ
            var newTHSelector = "<th name='"+options.name+"' class=\""+options.colClass+"\">"+defaults.headerText+"</th>";
            var newTDSelector = "<td name='"+options.name+"' class=\""+options.colClass+"\"></td>";
            //�ο��ڵ���ʽ
            var colCount = $("thead tr th",context).size();
            var appendEnd = ((parseInt(options.colIndex)<0)||parseInt(options.colIndex)>=colCount);//�Ƿ�Ϊ׷����ĩβ
            var headerRefSelector = "th:last";
            var bodyRefSelector = "td:last";
            if(!appendEnd){
                headerRefSelector = "th:eq("+options.colIndex+")";
                bodyRefSelector = "td:eq("+options.colIndex+")";
            }
            //������Ƿ��Ѵ���
            if($("thead tr th[name='"+options.name+"']",context).size()>0){
                //alert("����Ϊ:"+options.name+"�����Ѵ���");
                return;
            }
            if(appendEnd) $(newTHSelector).insertAfter($("thead tr "+headerRefSelector,context));
            else $(newTHSelector).insertBefore($("thead tr "+headerRefSelector,context));
            $("tbody tr",context).each(function(){//��������TD
                var newTD = $(newTDSelector);
                for(var i=0;i<options.buttons.length;i++){
                    var actionItem = $.extend(cloneObject(defaultButtonSetting),options.buttons[i]);
                    if(!$.isFunction(actionItem.filter))continue;
                    if(actionItem.filter($(this))==true){
                        //���ɰ�ť�ڵ�
                        var tipProperty = "";
                        if(actionItem.title)tipProperty="title="+actionItem.title;
                        var newButton=$('<a '+tipProperty+' class="'+actionItem.buttonClass+'" href="javascript:void(0);">'+actionItem.text+'</a>');
                        newButton.click(actionItem.execute);
                        newTD.append(newButton);
                    }
                }
                if(appendEnd) $(newTD).insertAfter($(bodyRefSelector,$(this)));
                else $(newTD).insertBefore($(bodyRefSelector,$(this)));
            });
        });
        function cloneObject(src){
            var dsc = {};
            for(var k in src){
                dsc[k]=src[k];
            }
            return dsc;
        }
    };
})(jQuery);

/************************************
 * TreeTable����֧��
 * ��TreeTableRenderer.java�����Ƚϸ�
 * ---------------------------------
 * @date: 2011/07/26
 * @version: 1.0
 ************************************/
var TreeTableContext = {
        formObjectContextId:"backProcess",          //��̨����form��IDֵ����ֵ��Render���ɣ�����������Ҫ����Ҫ�޸�
        serialFieldContextId:"contextSerial",       //�洢���л�����ʹ�õ���ID����ֵ��Render���ɣ�����������Ҫ����Ҫ�޸�
        redirector:"TreeTableContextHelper.jsp",    //ҳ��ת������ַ��������Ŀʵ������޸�Ϊ��Ӧ��Redirectorҳ��
        contextHelperURL:"TreeTableContextHelper.jsp",//��ҳ�����ڿ���ǰ̨DOM,js���̨javaͬ��
        treeNodeClassName:"",                       //��ͼ�ڵ�ʵ���࣬����Ŀ�����У���չ��TreeNode�࣬����Ҫ����Ϊ������ȫ·��
        postCharset:"UTF-8",                        //post��������ʱ��ʹ�õ��ַ���
        // ���л�����
        serialize : function(s){
            var serialField = $("#"+this.serialFieldContextId,$("#"+this.formObjectContextId));
            if(s)serialField.val(s);
            else return serialField.val();
        },
        // �����½ڵ�
        addNode : function(json){
            var ret = this.postSynData("addNode",$.JSON2String(json));
            if(ret)return true;
            return false;
        },
        // �Ƴ��ڵ�
        removeNode : function(json){
            var ret = this.postSynData("removeNode",$.JSON2String(json));
            if(ret)return true;
            return false;
        },
        // ����ֵ
        setValue : function(arg){
            var errorMessage="TreeTableContext.setValue()������������ʹ��json��json����";
            var data = [];
            if($.isArray(arg)){  //json����
                for(var i=0;i<arg.length;i++){
                    var inst = arg[i];
                    if(!inst)continue;//������ֿ�����ֱ������
                    if(typeof(inst)=="object"){
                        data.push($.JSON2String(inst));
                    }else{
                        alert(errorMessage);
                    }
                }
            }else if(typeof(arg)=="object"){//����json
                data.push($.JSON2String(arg));
            }else{
                alert(errorMessage);
            }
            //ͬ���ɹ����򷵻�true,ʧ�ܣ��򷵻�false
            var ret = this.postSynData("setValue",data.join("|"));
            if(ret)return true;
            else return false;
        },
        // ��������ͬ����̨����
        postSynData : function(action,parameter){
            var returnObject = null;
            //�����̨�Ĳ���
            if(!this.treeNodeClassName||this.treeNodeClassName.length==0){
                alert("TreeTableContext.treeNodeClassName���Բ���Ϊ�գ��ұ���Ϊ��ȷ��className��");
                return;
            }
            parameter = encodeURI(encodeURI(parameter));
            var parameters = new Array(
                "action="+action
                ,"ComponentURL="+this.contextHelperURL
                ,"parameter="+parameter
                ,"treeNodeClassName="+this.treeNodeClassName
                ,this.serialFieldContextId+"="+TreeTableContext.serialize()
                );
            var oWindow = self||top;
            if(oWindow.sCompClientID){
                var parentParam = "OpenerClientID="+oWindow.sCompClientID;
                parameters.push(parentParam);
            }
            //ͬ����̨����
            var charset = "charset=GBK";
            if(this.postCharset)charset = "charset="+this.postCharset;
            var context = this;
            $.ajax({
                async: false,
                type: "POST",
                contentType:"application/x-www-form-urlencoded;"+charset,        
                url: this.redirector,
                cache: false,
                data: parameters.join("&"),
                success: function(msg){
                    try{
                        returnObject = eval("("+msg+")");
                        if(returnObject["status"] != "true"&&returnObject["status"] != true){
                            var msg = "����ʧ�ܣ���鿴��������־";
                            if(returnObject["message"])msg = returnObject["message"];
                            returnObject = null;
                        }else{
                            TreeTableContext.serialize(returnObject[context.serialFieldContextId]);//��д���ͻ���
                        }
                    }catch(e){
                        alert("��ȡ���������ص�JSON�������json�ִ�ֵ��["+msg+"]\r\n������Ϣ��\r\n"+e.toLocaleString());
                    }
                }
            });
            return returnObject;
    }
};