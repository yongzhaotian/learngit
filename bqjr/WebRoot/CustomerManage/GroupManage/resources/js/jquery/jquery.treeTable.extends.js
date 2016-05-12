/*==================================================
 * @module: jquery.treeTable.extends.js
 * @author: syang
 * @createDate: 2010/09/26 10:28
 * @refactDate: 2011/07/26 16:27
 * @purpose: TreeTable扩展操作，除addOperatorColumn插件方法外，其余方法与TreeTableRenderer.java紧密关联
 *==================================================*/

/************************************
 * 扩展两个静态方法
 * ---------------------------------
 * @date: 2011/07/26
 * @version: 1.0
 ************************************/
jQuery.extend({
    // 字符串格式化输出
    format : function(string){
            var args=arguments;
            var pattern = new RegExp("%([1-"+arguments.length+"])","g");
            return new String(string).replace(pattern,function(match,index){return args[index];});
    },
    //把JSON对象转为字串，这里如果为多级JSON对象，不作递归处理，防止对象循环调用，堆栈溢出
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
 * 表格高亮插件
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
 * 表格搜索插件
 * ---------------------------------
 * @date: 2011/07/28
 * @version: 1.0
 ************************************/
(function($){
    $.fn.searchText = function(opts){
        var defaults = {
                keyWord:undefined,  //关键字
                excludeColumn:""    //不搜索的列
        };
        var options = $.extend(defaults, opts);
        
        var searchResult = [];//存放搜索结果
        $("tbody tr",$(this)).each(function(){
          //清除样式
          $(this).click(function(){
              $("td.searchText",$(this)).removeClass("searchText");
          });
          $("td.searchText",$(this)).removeClass("searchText");//移除之前搜索样式
          //开始搜索
          if(options.keyWord){
              var r = $("td:contains('" + options.keyWord + "')",$(this));
              //如果有结果且不是排除列，则渲染样式
              var exclude = options.excludeColumn.split(",");
              var est = {};
              for(var i=0;i<exclude.length;i++) est[exclude[i]]=true;
              if(!est[r.attr("name")]&&r.size()>0){
                  searchResult.push(r);
                  r.addClass("searchText");
                  //找出所有祖先节点，依次展开
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
 * TreeTable插件扩展支持
 * 该插件与TreeTableRenderer.java关联度较高
 * ---------------------------------
 * @date: 2011/07/26
 * @version: 1.0
 ************************************/
(function($){
    //取行上name字段的值
    $.fn.getValue = function(name){
        if(!name) alert("函数getValue(name)没有传入参数name");
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
    //设置行上name字段的值
    $.fn.setValue = function(name,value){
        if(!name) alert("函数setValue(name,value)没有传入参数name");
        if(!value) alert("函数setValue(name,value)没有传入参数value");
        var jsonObject = $(this).nodeJSON();                       //取出JSON
        if(typeof(jsonObject[name])!="undefined"){
            jsonObject[name]=value;                                  //修改JSON值
            $("[name='"+name+"']",$(this)).text(value);               //修改DOM节点值
            if(name=="id")$(this).attr("id",value);
            $(this).nodeJSON(jsonObject);                            //回写JSON
        }else{
            alert($.format("字段%1不存在",name));
        }
    },
    //移除一列
    $.fn.removeColumn = function(opts){
        var defaults = {
                name:"newcolumn"//移除列的的名称
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
    // 添加一个操作列
    $.fn.addExecuteColumn = function(opts) {
        var defaults = {
                colIndex:-1,                //列索引，-1表示直接添加至末尾
                name:"newcolumn",        //列名称
                headerText:"新的操作列",     //显示名称
                colClass:"button-cell",     //列样式
                buttons:[]
        };
        //默认按钮设置
        var defaultButtonSetting = {
                filter:function(currentTr){return true;},
                text:"新按钮",
                buttonClass:"",
                title:"",
                execute:function(){alert("未实现的动作");}
        };
        var options = $.extend(defaults, opts);
        return this.each(function(){
            var context = $(this);
            //新行头部及主体部分表达式
            var newTHSelector = "<th name='"+options.name+"' class=\""+options.colClass+"\">"+defaults.headerText+"</th>";
            var newTDSelector = "<td name='"+options.name+"' class=\""+options.colClass+"\"></td>";
            //参考节点表达式
            var colCount = $("thead tr th",context).size();
            var appendEnd = ((parseInt(options.colIndex)<0)||parseInt(options.colIndex)>=colCount);//是否为追加至末尾
            var headerRefSelector = "th:last";
            var bodyRefSelector = "td:last";
            if(!appendEnd){
                headerRefSelector = "th:eq("+options.colIndex+")";
                bodyRefSelector = "td:eq("+options.colIndex+")";
            }
            //检查列是否已存在
            if($("thead tr th[name='"+options.name+"']",context).size()>0){
                //alert("名称为:"+options.name+"的列已存在");
                return;
            }
            if(appendEnd) $(newTHSelector).insertAfter($("thead tr "+headerRefSelector,context));
            else $(newTHSelector).insertBefore($("thead tr "+headerRefSelector,context));
            $("tbody tr",context).each(function(){//生成数据TD
                var newTD = $(newTDSelector);
                for(var i=0;i<options.buttons.length;i++){
                    var actionItem = $.extend(cloneObject(defaultButtonSetting),options.buttons[i]);
                    if(!$.isFunction(actionItem.filter))continue;
                    if(actionItem.filter($(this))==true){
                        //生成按钮节点
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
 * TreeTable容器支持
 * 与TreeTableRenderer.java关联度较高
 * ---------------------------------
 * @date: 2011/07/26
 * @version: 1.0
 ************************************/
var TreeTableContext = {
        formObjectContextId:"backProcess",          //后台处理form的ID值，该值由Render生成，若无特殊需要，不要修改
        serialFieldContextId:"contextSerial",       //存储序列化对象使用的域ID，该值由Render生成，若无特殊需要，不要修改
        redirector:"TreeTableContextHelper.jsp",    //页面转向器地址，根据项目实际情况修改为相应的Redirector页面
        contextHelperURL:"TreeTableContextHelper.jsp",//该页面用于控制前台DOM,js与后台java同步
        treeNodeClassName:"",                       //树图节点实现类，若项目开发中，扩展了TreeNode类，则需要配置为相关类的全路径
        postCharset:"UTF-8",                        //post传输数据时，使用的字符集
        // 序列化容器
        serialize : function(s){
            var serialField = $("#"+this.serialFieldContextId,$("#"+this.formObjectContextId));
            if(s)serialField.val(s);
            else return serialField.val();
        },
        // 创建新节点
        addNode : function(json){
            var ret = this.postSynData("addNode",$.JSON2String(json));
            if(ret)return true;
            return false;
        },
        // 移除节点
        removeNode : function(json){
            var ret = this.postSynData("removeNode",$.JSON2String(json));
            if(ret)return true;
            return false;
        },
        // 更改值
        setValue : function(arg){
            var errorMessage="TreeTableContext.setValue()函数，参数请使用json或json数组";
            var data = [];
            if($.isArray(arg)){  //json数组
                for(var i=0;i<arg.length;i++){
                    var inst = arg[i];
                    if(!inst)continue;//如果出现空数据直接跳过
                    if(typeof(inst)=="object"){
                        data.push($.JSON2String(inst));
                    }else{
                        alert(errorMessage);
                    }
                }
            }else if(typeof(arg)=="object"){//单个json
                data.push($.JSON2String(arg));
            }else{
                alert(errorMessage);
            }
            //同步成功，则返回true,失败，则返回false
            var ret = this.postSynData("setValue",data.join("|"));
            if(ret)return true;
            else return false;
        },
        // 发送请求，同步后台数据
        postSynData : function(action,parameter){
            var returnObject = null;
            //传入后台的参数
            if(!this.treeNodeClassName||this.treeNodeClassName.length==0){
                alert("TreeTableContext.treeNodeClassName属性不能为空，且必需为正确的className类");
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
            //同步后台数据
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
                            var msg = "操作失败，请查看服务器日志";
                            if(returnObject["message"])msg = returnObject["message"];
                            returnObject = null;
                        }else{
                            TreeTableContext.serialize(returnObject[context.serialFieldContextId]);//回写至客户端
                        }
                    }catch(e){
                        alert("获取服务器返回的JSON对象出错，json字串值：["+msg+"]\r\n出错消息：\r\n"+e.toLocaleString());
                    }
                }
            });
            return returnObject;
    }
};