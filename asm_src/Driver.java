import java.io.File;
import java.io.FileNotFoundException;
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
	private static final int ASM_MODE_BINARY = 0; // assemble to 16 bit binary instructions
	private static final int ASM_MODE_HEX = 1; // assemble to 4 digit hex instructions
	private static final int ASM_MODE_MIF = 2; // assemble to memory initialization format
	private static final int ASM_MODE_REASSEMBLE = 3; // re-assemble 16 bit binary instructions
	private static final int DEBUG_MODE_ON = 1;
	private static final int DEBUG_MODE_OFF = 0;
	private static final int INSTR_WIDTH = 16;
	
	// static fields
	public static boolean debug = false;
	
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
					pc += line.contains("MOV") ? 4*PC_INC : PC_INC;
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
	 * Converts each 16 bit binary string in given list to a 4 digit hex string
	 */
	private static List<String> toHex(List<String> binary) {
		ArrayList<String> hex = new ArrayList<String>();
		
		for(int i = 0; i < binary.size(); ++i) {
			hex.add(Translator.binaryToHex(binary.get(i)));
		}
		
		return hex;
	}
	
	/*
	 * Converts the list of 16 bit binary instructions into the contents of a 
	 * .mif (memory initialization format) file.
	 */
	private static List<String> formatMIF(List<String> binary) {	
		List<String> mif = new ArrayList<String>();
		int numInstr = binary.size(); // actual number of instructions we will put in memory
		int depth = 0; // max number of instructions we can fit in memory
		int p = 0;
		
		// compute depth of memory (round to nearest power of 2 that can hold all instructions)
		while(depth < numInstr) {
			depth = (int)Math.pow(2, p);
			++p;
		}
		
		// create mif header
		mif.add("DEPTH = "+depth+";");
		mif.add("WIDTH = "+INSTR_WIDTH+";");
		mif.add("");
		mif.add("ADDRESS_RADIX = DEC;");
		mif.add("DATA_RADIX = BIN;");
		mif.add("");
		mif.add("CONTENT");
		mif.add("BEGIN");
		mif.add("");
		
		// create entry for each instruction
		for(int i = 0; i < numInstr; ++i) {
			mif.add(i+" : "+binary.get(i)+";");
		}
		
		// fill remaining memory (if any) with zeros
		if(numInstr != depth) { // instructions don't completely fill memory?
			mif.add("["+numInstr+".."+(depth-1)+"] : 0000000000000000;");
		}
		
		// create footer
		mif.add("END;");
		
		return mif;
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
	 * java Driver prog.asm
	 * 		- args[0] = filename - name of file to be operated on
	 * 		- args[1] = asmMode - 0 for asm-to-binary, 1 for asm-to-hex, 2 for asm-to-mif, 3 for binary reassemble
	 * 		- args[2] = debugMode - 0 for debug off, 1 for debug on
	 * Target file must be located in same directory as this.
	 */
	public static void main(String[] args) {
		int debugMode = DEBUG_MODE_OFF; // what sort of debug messages do we want
		int asmMode = ASM_MODE_BINARY; // which operation should we performed
		String filenameIn = null; // name of input file
		String fileExtIn = null; // extension of input file
		String filenameOut = null; // name of output file
		File fileIn = null; // input file for given operation
		File fileOut = null; // output file for given operation
		List<String> contents = null; // contents of output file where each element is a single line of text
		int instructionCount = 0;
		
		// make sure we have the right number of args
		if(args.length != 3) {
			System.out.println("Expecting 3 arguments not "+args.length+" arguments.");
			System.exit(0);
		}
		
		// get assembly mode and make sure it is valid
		try {
			asmMode = Integer.parseInt(args[1]);
			if(	asmMode != ASM_MODE_BINARY && 
				asmMode != ASM_MODE_HEX && 
				asmMode != ASM_MODE_REASSEMBLE &&
				asmMode != ASM_MODE_MIF
			) {
				throw new Exception();
			}
		}
		catch(Exception e) {
			System.out.println("Unrecognized assembly mode: "+args[1]);
			System.exit(0);
		}
		
		// get debug mode
		try {
			debugMode = Integer.parseInt(args[2]);
			
			if(debugMode != DEBUG_MODE_ON && debugMode != DEBUG_MODE_OFF) {
				throw new Exception();
			}
		}
		catch(Exception e) {
			System.out.println("Unrecognized debug mode: "+args[2]);
			System.exit(0);
		}
		debug = (debugMode == DEBUG_MODE_ON);
		
		// get filename and make sure extension matches operation
		filenameIn = args[0];
		if(asmMode == ASM_MODE_BINARY) { // expecting assembly file (.asm) outputting object file (.o)
			fileExtIn = filenameIn.substring(filenameIn.length()-4);
			if(!fileExtIn.equals(".asm")) {
				System.out.println("Failed to assemble. File must end in .asm: "+filenameIn);
				System.exit(0);
			}
			filenameOut = filenameIn.substring(0, filenameIn.length()-4) + ".o";
		}
		else if(asmMode == ASM_MODE_HEX) { // expecting assembly file (.asm) outputting hex file (.hex)
			fileExtIn = filenameIn.substring(filenameIn.length()-4);
			if(!fileExtIn.equals(".asm")) {
				System.out.println("Failed to assemble. File must end in .asm: "+filenameIn);
				System.exit(0);
			}
			filenameOut = filenameIn.substring(0, filenameIn.length()-4) + ".hex";
		}
		else if(asmMode == ASM_MODE_MIF) { // expecting assembly file (.asm) outputting mif file (.mif)
			fileExtIn = filenameIn.substring(filenameIn.length()-4);
			if(!fileExtIn.equals(".asm")) {
				System.out.println("Failed to assemble. File must end in .asm: "+filenameIn);
				System.exit(0);
			}
			filenameOut = filenameIn.substring(0, filenameIn.length()-4) + ".mif";
		}
		else { // ASM_MODE_REASSEMBLE - expecting object file (.o)
			fileExtIn = filenameIn.substring(filenameIn.length()-2);
			if(!fileExtIn.equals(".o")) {
				System.out.println("Failed to re-assemble. File must end in .o: "+filenameIn);
				System.exit(0);
			}
			filenameOut = filenameIn.substring(0, filenameIn.length()-2) + ".rsm";
		}
		
		// command line arguments are good, save to proceed
		fileIn = new File(filenameIn);
		if(asmMode == ASM_MODE_BINARY) {
			contents = assemble(fileIn);
			instructionCount = contents.size();
		}
		else if(asmMode == ASM_MODE_HEX) {
			contents = assemble(fileIn);
			instructionCount = contents.size();
			contents = toHex(contents);
		}
		else if(asmMode == ASM_MODE_MIF) {
			contents = assemble(fileIn);
			instructionCount = contents.size();
			contents = formatMIF(contents);
		}
		else {
			contents = reassemble(fileIn);
			instructionCount = contents.size();
		}
		
		// print the result of the operation to a file
		System.out.println("");
		fileOut = new File(filenameOut);
		printToFile(fileOut, contents);
		
		System.out.println("");
		System.out.printf("%s ---> %s\n", fileIn.getName(), fileOut.getName());
		System.out.printf("Instruction count: %d\n", instructionCount);

		return;
	}

} //  end class
