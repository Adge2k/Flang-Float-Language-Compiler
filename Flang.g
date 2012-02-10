grammar Flang;

@header {
	import org.antlr.runtime.*;
	import java.io.*;
	import java.util.Map;
	import java.util.HashMap;
}
@members {
	public PrintWriter out;
	public int loopCounter = 0;
	public Map<String, Integer> variables = new HashMap<String, Integer>();

	public int flag=0;
	public String operation="";

	/* assume integer valued values */
	public void j(String s) {
	  out.println(s);
	}
	public void j_assign(int var) {
		out.println("fstore " + var);
	}
	public void j_print_loop(int var, int repeat) {
		loopCounter ++;
		int loopVar = 10 - loopCounter;
		if(loopVar < variables.size()) {
			System.out.println("Heap space overflow by loops");
			System.exit(0);
		}
		out.println("ldc " + repeat);
		out.println("istore " + loopVar);
		out.println("LOOP_" + loopCounter + ":");
		out.println("getstatic java/lang/System/out Ljava/io/PrintStream;");
		out.println("fload " + var);
		out.println("invokevirtual java/io/PrintStream/println(F)V");
		out.println("iinc " + loopVar + " -1");
		out.println("iload " + loopVar);
		out.println("ifne LOOP_" + loopCounter);
	}
}

prog : (statement NEWLINE)+ EOF;

statement
	:'let' ID 'be' expr{
		int var=0;
		if(this.variables.containsKey($ID.text))
			var = this.variables.get($ID.text);
		else {
			var = this.variables.size();
			this.variables.put($ID.text, var);
		}
		this.j_assign(var);
		flag=0;
	}
	|'print' varname=expr(COUNT 'times')?{
		int var = 0;
		int loop = 1;
		if(variables.containsKey($varname.text))
			var = variables.get($varname.text);
		else {
			System.out.println("Compiling error: " + $varname.text + " is not declared.");
			System.exit(0);
		}
		if($COUNT != null) {
			loop = Integer.parseInt($COUNT.text);
		}
		j_print_loop(var, loop);
		flag=0;
	}
	;

expr
	:FLOAT
		{
			if (flag>1)
				if (operation.equals("+")){
					out.println("fadd ");
				}
				else if (operation.equals("-")){
					out.println("fsub ");
				}
				else if (operation.equals("*")){
					out.println("fmul ");
				}
				else{
					out.println("fdiv ");
				}
			out.println("ldc " + $FLOAT.text);flag++;
		}
	|ID
		{
			if (flag>1)
				if (operation.equals("+")){
					out.println("fadd ");
				}
				else if (operation.equals("-")){
					out.println("fsub ");
				}
				else if (operation.equals("*")){
					out.println("fmul ");
				}
				else{
					out.println("fdiv ");
				}
		out.println("fload "+variables.get($ID.text));
		flag++;}
	|'(' op expr* ')'{
		if ($op.text.equals("+")){
			operation="+";
			out.println("fadd ");
		}
		else if ($op.text.equals("-")){
			operation="-";
			out.println("fsub ");
		}
		else if ($op.text.equals("*")){
			operation="*";
			out.println("fmul ");
		}
		else{
			operation="/";
			out.println("fdiv ");
		}
		flag++;
	}
	;

op
	:'+'
	|'-'
	|'*'
	|'/'
	;

ID:LETTER (LETTER|'0'..'9')*;

fragment LETTER
	:'$'
	|'A'..'Z'
	|'a'..'z'
	|'_'
	|'-'
	|'.'
	;

FLOAT:('0'..'9')+'.'('0'..'9')*;

COUNT:('0'..'9');

NEWLINE:('\r')?'\n';

WS:(' '|'\t')+{skip();};
