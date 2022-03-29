import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

/*
 * This class processes command line arguments and commences assembly 
 * accordingly.
 */
public class Driver {
	
	private static boolean debug = true;
	
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
		
		System.out.println("ASSEMBLING"); // FIXME
		
		// read in file
		// build symbol table during this first pass
		// 	- label definitions start with a "_"
		// 	- macro definitions start with a "define "
		//  - comments start with either "//" or "#"
		try {
			// open file
			scnr = new Scanner(fileIn);
			
			// read line by line
			while(scnr.hasNextLine()) {
				line = scnr.nextLine();
				line = line.trim();
				
				// determine interpretation of line
				if(line.length() == 0) { // ignore whitespace lines
					continue;
				}
				else if(line.length() > 0 && line.charAt(0) == '#') { // ignore '#' comments
					continue;
				}
				else if(line.length() > 1 && line.charAt(0) == '/' && line.charAt(1) == '/') { // ignore "//" comments
					continue;
				}
				else if(line.length() > 0 && line.charAt(0) == '_') { // add labels to symbol table
					// TODO
				}
				else if(line.length() > 5 && line.substring(0, 6).equals("define")) { // add macros to symbol table
					// TODO
				}
				else { // save line for second pass
					asm.add(line);
				}
			}
		}
		catch(FileNotFoundException e) { 
			System.out.println("Couldn't find file: "+fileIn.getName());
			System.exit(0);
		}
		
		// take a second pass through the assembly to actually translate
		
		return o;
	}
	
	/*
	 * Translates given object file to assembly language and returns result as a 
	 * list where each element is a single line of text in the target assembly 
	 * language file.
	 */
	private static List<String> reassemble(File fileIn) {
		// TODO
		System.out.println("AM I WORTH THE RE-ASSEMBLE?"); // FIXME
		return null;
	}
	
	/*
	 * Prints each element of the contents list as its own line to the given 
	 * file.
	 */
	private static void printToFile(File fileOut, List<String> contents) {
		
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
			filenameOut = filenameIn.substring(0, filenameIn.length()-3) + ".o";
		}
		else { // expecting object file (.o)
			fileExtIn = filenameIn.substring(filenameIn.length()-2);
			if(!fileExtIn.equals(".o")) {
				System.out.println("Failed to re-assemble. File must end in .o: "+filenameIn);
				System.exit(0);
			}
			filenameOut = filenameIn.substring(0, filenameIn.length()-1) + ".rsm";
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
		fileOut = new File(filenameOut);
		printToFile(fileOut, contents);
		

		return;
	}

} //  end class
