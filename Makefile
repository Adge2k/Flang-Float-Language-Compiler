
all:Compiler

Compiler:Flang.g Compiler.java
	java -cp .:antlrworks-1.4.2.jar org.antlr.Tool Flang.g
	javac -cp .:antlrworks-1.4.2.jar FlangLexer.java
	javac -cp .:antlrworks-1.4.2.jar FlangParser.java
	javac -cp .:antlrworks-1.4.2.jar Compiler.java

clean:
	#Cleaning
	rm *.tokens
	rm *.class
	rm FlangLexer.java
	rm FlangParser.java
	rm *.j
	rm output

