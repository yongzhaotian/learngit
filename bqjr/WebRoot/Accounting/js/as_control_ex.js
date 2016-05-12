AsControl.RunJavaMethod_EX = function (ClassName,MethodName,Args) {
	return AsControl.GetJavaMethodReturn(AsControl.CallJavaMethod(ClassName,MethodName,Args,"&ArgsObject=LAS"),ClassName);
};