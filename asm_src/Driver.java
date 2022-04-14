import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

/*
 * This class processes command line arguments and commences assembly 
 * accordingly.
 */
public class Driver {
	
	// constants
	private static final int PC_INC = 1; // increment PC by this much for each instruction
	private static final int PC_START = 0; // address of first instruction
	
	// static fields
	private static boolean debug = false;
	
	/*
	 * Translates given assembly file to machine code and returns result as a 
	 * list where each element is a single line of text in the target machine 
	 * code file. Exits upon encountering any errors.
	 */
	private static List<String> assemble(File fileIn) {
		ArrayList<String> asm = new ArrayList<String>(); // read-in contents of assembly file
		ArrayList<String> o = new ArrayList<String>(); // write-out contents for object file
		Scanner scnr = null;
		String line = null;
		SymbolTable symTab = null;
		int lineNum = 1;
		int pc = PC_START;
		
		System.out.println("ASSEMBLING..."); // FIXME
		
		// read in file
		// build symbol table during this first pass
		// 	- label definitions start with a "_"
		// 	- macro definitions start with a "def"
		//  - comments start with either "//" or "#"
		symTab = new SymbolTable();
		try {
			// open file
			scnr = new Scanner(fileIn);
			
			// read line by line
			while(scnr.hasNextLine()) {
				line = scnr.nextLine();
				line = line.trim();
				
				// determine interpretation of line
				if(line.length() == 0) { // ignore whitespace lines
					// nothing
				}
				else if(line.length() > 0 && line.charAt(0) == '#') { // ignore '#' comments
					// nothing
				}
				else if(line.length() > 1 && line.charAt(0) == '/' && line.charAt(1) == '/') { // ignore "//" comments
					// nothing
				}
				else if(line.length() > 0 && line.charAt(0) == '_') { // add labels to symbol table
					addLabel(symTab, line, lineNum, pc);
				}
				else if(line.length() > 3 && line.substring(0, 3).equals("def")) { // add macros to symbol table
					addMacro(symTab, line, lineNum);
				}
				else { // save line for second pass
					line = lineNum+" "+line;
					asm.add(line);
					pc += PC_INC;
				}
				
				++lineNum;
			}
		}
		catch(FileNotFoundException e) { 
			System.out.println("Couldn't find file: "+fileIn.getName());
			System.out.println(e.getMessage());
			System.out.println(e.getStackTrace());
			System.exit(0);
		}
		
		// symbol table is complete
		Translator.updateSymbolTable(symTab);
		if(debug) {
			System.out.println(symTab);
		}
		
		// take a second pass through the assembly to actually translate
		for(int i = 0; i < asm.size(); ++i) {
			Translator.encodeInstruction(asm.get(i), o);
		}
		
		System.out.println("ASSEMBLED");
		return o;
	}
	
	/*
	 * Translates given object file to assembly language and returns result as a 
	 * list where each element is a single line of text in the target assembly 
	 * language file.
	 */
	private static List<String> reassemble(File fileIn) {
		ArrayList<String> o = new ArrayList<String>(); // read-in contents of object file
		ArrayList<String> rsm = new ArrayList<String>(); // write-out contents for reassembly file
		Scanner scnr = null;
		String line = "";
		int lineNum = 0;
		
		System.out.println("AM I WORTH THE RE-ASSEMBLE?"); // FIXME
		
		// read in file
		try {
			// open file
			scnr = new Scanner(fileIn);
					
			// read line by line
			while(scnr.hasNextLine()) {
				line = scnr.nextLine();
				line = line.trim();
						
				// perform quick sanity check for the line
				if(line.length() != 16) { // instructions must be 16 bits
					System.out.printf("%d: Instruction must be 16 bits not %d bits.", lineNum, line.length());
					System.exit(0);
				} 
				else { // line is good, lets decode
					o.add(lineNum+" "+line);
				}
						
				++lineNum;
			}
		}
		 catch(FileNotFoundException e) { 
			System.out.println("Couldn't find file: "+fileIn.getName());
			System.out.println(e.getMessage());
			System.out.println(e.getStackTrace());
			System.exit(0);
		}
		
		// decode each line
		// take a second pass through the assembly to actually translate
		for(int i = 0; i < o.size(); ++i) {
			Translator.decodeInstruction(o.get(i), rsm);
		}
		
		return rsm;
	}
	
	/*
	 * Parses the string definition of a macro and adds it to the symbol table.
	 * If the definition is bad, prints an error message and exits.
	 */
	private static void addMacro(SymbolTable symTab, String line, int lineNum) {
		String [] tokens = null; // array of relevant substrings
		String name = ""; // name of macro
		int val = 0; // value of macro
		
		// parse macro definition "def <name> <value> <optional_comment>"
		try {
			// remove "def" keyword
			line = line.replaceFirst("def", ""); 
			
			// remove excess whitespace
			line = line.trim();
			while(line.contains("\t")) { line = line.replaceAll("\t", " "); } // tabs
			while(line.contains("  ")) { line = line.replaceAll("  ", " "); } // extra spaces
			
			// get tokens
			tokens = line.split(" ");
			
			// check tokens
			if(tokens.length < 2) { // need a name and value
				throw new Exception("Needs at least 2 tokens");
			}
			if(tokens.length > 3) { // opted for comment
				if(tokens[2].charAt(0) != '#') { // not using a "#" comment
					if(tokens[2].length() < 2 || !tokens[2].substring(0,2).equals("//")) { // not using a "//" comment
						throw new Exception("Unrecognized tokens");
					}
				}
			}
			
			// tokens are good
			name = tokens[0];
			val = Integer.parseInt(tokens[1]);
		}
		catch(Exception e) {
			System.out.printf("%d: Bad macro definition. %s.\n", lineNum, e.getMessage());
			System.exit(0);
		}
		
		symTab.add(name, val, Translator.decimalToBinary(val, 32, lineNum), Symbol.MACRO, lineNum);
		return;
	}
	
	/*
	 * Parses the string definition of a label and adds it to the symbol table.
	 * If the definition is bad, prints an error message and exits.
	 */
	private static void addLabel(SymbolTable symTab, String line, int lineNum, int pc) {
		String [] tokens = null; // array of relevant substrings
		String name = ""; // name of label
		
		// parse label definition "_<name> <optional_comment>"
		try {
			// remove "_" indicator
			line = line.replaceFirst("_", ""); 
			
			// remove excess whitespace
			line = line.trim();
			while(line.contains("\t")) { line = line.replaceAll("\t", " "); } // tabs
			while(line.contains("  ")) { line = line.replaceAll("  ", " "); } // extra spaces
			
			// get tokens
			tokens = line.split(" ");
			
			// check tokens
			if(tokens.length < 1) { // need at least a name
				throw new Exception("Needs at least 2 tokens");
			}
			if(tokens.length > 2) { // opted for comment
				if(tokens[1].charAt(0) != '#') { // not using a "#" comment
					if(tokens[1].length() < 2 || !tokens[1].substring(0,2).equals("//")) { // not using a "//" comment
						throw new Exception("Unrecognized tokens");
					}
				}
			}
			
			// tokens are good
			name = tokens[0];
		}
		catch(Exception e) {
			System.out.printf("%d: Bad label definition. %s.\n", lineNum, e.getMessage());
			System.exit(0);
		}
		
		symTab.add(name, pc, Translator.decimalToBinary(pc, 32, lineNum), Symbol.LABEL, lineNum);
		return;
	}
	
	
	/*
	 * Prints each element of the contents list as its own line to the given 
	 * file.
	 */
	private static void printToFile(File fileOut, List<String> contents) {
		PrintWriter out = null;
		
		System.out.println("WRITING TO "+fileOut.getName()+"...");
		
		// open file
		try {
			out = new PrintWriter(fileOut);
		} catch (FileNotFoundException e) {
			System.out.println("Could not find object file: "+fileOut.getName());
			System.exit(0);
		}		
		
		// write each line
		for(int i = 0; i < contents.size(); ++i) {
			out.println(contents.get(i));
			if(debug) {
				System.out.println(contents.get(i));
			}
		}

		System.out.println("WRITTEN");
		
		// clean up
		out.close();
		return;
	}

	/*
	 * Expecting command line arguments:
	 * 		- opcode - 0 for assembly, 1 for re-assembly
	 * 		- filename - name of file to be operated on
	 * Target file must be located in same directory as this.
	 */
	public static void main(String[] args) {
		int opcode = 0; // number corresponding to which operation we should perform
		String filenameIn = null; // name of input file
		String fileExtIn = null; // extension of input file
		String filenameOut = null; // name of output file
		File fileIn = null; // input file for given operation
		File fileOut = null; // output file for given operation
		List<String> contents = null; // contents of output file where each element is a single line of text
		
		// make sure we have the right number of args
		if(args.length != 2) {
			System.out.println("Must have 2 arguments: "+args.length);
			System.exit(0);
		}
		
		// get opcode and make sure it is recognized
		try {
			opcode = Integer.parseInt(args[0]);
			if(opcode < 0 || opcode > 1) {
				throw new Exception();
			}
		}
		catch(Exception e) {
			System.out.println("Invalid opcode: "+args[0]);
			System.exit(0);
		}
		
		// get filename and make sure extension matches operation
		filenameIn = args[1];
		if(opcode == 0) { // expecting assembly file (.asm)
			fileExtIn = filenameIn.substring(filenameIn.length()-4);
			if(!fileExtIn.equals(".asm")) {
				System.out.println("Failed to assemble. File must end in .asm: "+filenameIn);
				System.exit(0);
			}
			filenameOut = filenameIn.substring(0, filenameIn.length()-4) + ".o";
		}
		else { // expecting object file (.o)
			fileExtIn = filenameIn.substring(filenameIn.length()-2);
			if(!fileExtIn.equals(".o")) {
				System.out.println("Failed to re-assemble. File must end in .o: "+filenameIn);
				System.exit(0);
			}
			filenameOut = filenameIn.substring(0, filenameIn.length()-2) + ".rsm";
		}
		
		// command line arguments are good, save to proceed
		fileIn = new File(filenameIn);
		if(opcode == 0) {
			contents = assemble(fileIn);
		}
		else {
			contents = reassemble(fileIn);
		}
		
		// print the result of the operation to a file
		System.out.println("");
		fileOut = new File(filenameOut);
		printToFile(fileOut, contents);
		
		System.out.println("");
		System.out.printf("%s ---> %s\n", fileIn.getName(), fileOut.getName());
		System.out.printf("Instruction count: %d\n", contents.size());

		return;
	}

} //  end class