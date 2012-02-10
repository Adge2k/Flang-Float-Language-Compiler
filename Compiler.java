//Ben Waters
/*
This file is part of Flang Compiler.

Flang Compiler is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Flang Compiler is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Flang Compiler.  If not, see <http://www.gnu.org/licenses/>.
*/
import org.antlr.runtime.ANTLRInputStream;
import org.antlr.runtime.CharStream;
import org.antlr.runtime.CommonTokenStream;
import java.io.*;

public class Compiler{
	public PrintWriter out;
        public static void main(String[] args){
                String filename;
                if (args.length!=1){
                        System.out.println("Usage: java Compiler <filename>");
                        System.exit(1);
                }
                filename=args[0];
                try{
                        FileInputStream istream=new FileInputStream(filename);
                        try{
                                CharStream input=new ANTLRInputStream(istream);
                                FlangLexer lexer= new FlangLexer(input);
                                FlangParser parser=new FlangParser(new CommonTokenStream(lexer));
				PrintWriter out=new PrintWriter(new FileOutputStream("a.j"));
				parser.out=out;
				out.println(".class public A");
				out.println(".super java/lang/Object");
				out.println(".method public <init>()V");
				out.println("aload_0");
				   out.println("invokenonvirtual java/lang/Object/<init>()V");
				   out.println("return");
				   out.println(".end method");
				out.println(".method public static main([Ljava/lang/String;)V");
				out.println(".limit stack 10");
				out.println(".limit locals 10");
				parser.prog();
				out.println("return");
				out.println(".end method");
				out.close();
                        }catch(Exception e){
                                System.err.println("Error: "+e.getMessage());
                        }
                }catch(FileNotFoundException e){
                        System.out.println(e.getMessage());
                }
        }
}
