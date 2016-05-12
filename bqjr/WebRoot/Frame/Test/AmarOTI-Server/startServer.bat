@echo off

set JAVA_HOME=C:\Program Files\Java\jdk1.5.0_10

set CLASSPATH=.;.\WebRoot\WEB-INF\classes;%JAVA_HOME%\lib
set COMPILER=javac
set COMPILE_OPTION= -sourcepath .\src -d WebRoot\WEB-INF\classes src\demo\XJServerPutOut.java
%COMPILER% %COMPILE_OPTION%

set JAVA_RUN="%JAVA_HOME%\bin\java"
set RUN_CLASS=demo.XJServerPutOut
%JAVA_RUN% %RUN_CLASS% 
@echo on
@pause