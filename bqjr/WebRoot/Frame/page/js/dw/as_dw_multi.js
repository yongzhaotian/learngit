var aDWResultInfo = new Array();
function getResultInfos(){
	return aDWResultInfo;
}
function as_save(frameNames,postevents){
	as_doAction(frameNames,undefined,postevents);
}
function as_doAction(frameNames,actions,postevents){
	var aFrameNames = frameNames.split(",");
	var aActions;
	if(actions){
		aActions = actions.split(",");
		if(aFrameNames.length!=aActions.length){
			alert('提交参数错误');
			return;
		}
	}
	
	var dataValid = true;
	//数据校验
	for(var i=0;i<aFrameNames.length;i++){
		var frameObj = window.frames[aFrameNames[i]];
		if(frameObj.iV_all(0)==false){
			dataValid = false;
			frameObj.showErrors(0);
		}
	}
	if(dataValid){
		//获得提交数据
		var postDataJson= new StringBuffer();
		postDataJson.append("{");
		for(var i=0;i<aFrameNames.length;i++){
			var frameObj = window.frames[aFrameNames[i]];
			if(i>0)postDataJson.append(",");
			if(frameObj.window.checkElementsChange)
				frameObj.window.checkElementsChange(0);//保存修改的字段
			as_getPostJsonData(postDataJson,frameObj,aActions?aActions[i]:'save');
		}
		postDataJson.append("}");
		//document.write(postDataJson.toString());
		//发起post提交
		as_PostData(postDataJson.toString(),postevents);
	}
}
function as_PostData(data,postevents){
	openDWDialog();
	$.ajax({
	   type: "POST",
	   url: sDWResourcePath + "/MultiPageSave.jsp",
	   processData: false,
	   data: "data=" + data,
	   success: function(msg){
		var result = eval("(" + msg + ")");
		if(result.status=="success"){
			msg = "操作成功";
			//alert("result.resultInfos=" + result.resultInfos.frame_info);
			for(var frameName in result.resultInfos){
				aDWResultInfo[frameName] = result.resultInfos[frameName];
				//alert("frameName=" + frameName + ",aDWResultInfo[frameName]=" + aDWResultInfo[frameName]);
			}
			//aDWResultInfo[tableIndex] = result.resultInfo;
			if(postevents==undefined) postevents="";
			resetDWDialog(msg,true);
			if(postevents.length>0)eval("("+postevents+")");
		}
		else{
			resetDWDialog(result.errors,false);
		}
	   }
	});
}
function as_getPostJsonData(postDataJson,frameObj,action){
	var framePostData = frameObj.window.as_createFormDatas();
	postDataJson.append('"'+frameObj.name+'":{');
	postDataJson.append('"serializedJbo":"'+framePostData.serializedJbo+'",');
	postDataJson.append('"serializedAsd":"'+framePostData.serializedAsd+'",');
	postDataJson.append('"type":"'+framePostData.type+'",');
	postDataJson.append('"action":"'+action+'",');
	
	if(framePostData.type=='info'){
		postDataJson.append('"updatedFields":{');
		//alert('framePostData.updatedFields='+ framePostData.updatedFields);
		for(var j=0;j<framePostData.updatedFields.length;j++){
			if(j>0){
				postDataJson.append(',');
			}
			//postDataJson.append('{');
			postDataJson.append('"'+framePostData.updatedFields[j]+'":"'+ replaceSpecialHtml(framePostData.fieldValues[framePostData.updatedFields[j]]) +'"');
			//postDataJson.append('{');
		}
		postDataJson.append('},');
		
		postDataJson.append('"allFieldValues":{');
		//alert('framePostData.updatedFields='+ framePostData.updatedFields);
		for(var j=0;j<framePostData.allFieldNames.length;j++){
			if(j>0){
				postDataJson.append(',');
			}
			//postDataJson.append('{');
			postDataJson.append('"'+framePostData.allFieldNames[j]+'":"'+ replaceSpecialHtml(framePostData.allFieldValues[framePostData.allFieldNames[j]]) +'"');
			//postDataJson.append('{');
		}
		postDataJson.append('}');
		
	}
	else if(framePostData.type=='list'){
		postDataJson.append('"updatedFields":"'+replaceSpecialHtml(framePostData.updatedFields)+'",');
		postDataJson.append('"selectedRows":"'+ framePostData.selectedRows +'",');
		postDataJson.append('"curpage":' + framePostData.curpage);
	}
	postDataJson.append('}');
}
function replaceSpecialHtml(html){
	html = html.replace(/&/g,"⊙≌□");
	html = html.replace(/"/g,'\"');
	return encodeURI(encodeURI(html));
}