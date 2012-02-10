make
java -cp .:antlrworks-1.4.2.jar Compiler test.flang
java -jar jasmin.jar a.j
java A >> output 2>&1
