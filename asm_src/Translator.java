import java.util.List;

/*
 * Handles all the translation of assembly to binary and back.
 */
public class Translator {
	/*
	 * Groups an instruction type with its op and function codes.
	 *  	- EX: ADD has the opcode 1010 and the function code 110.
	 */
	private static class Type {
		String name; // name of instruction
		String opcode;
		String fncode;
		
		private Type(String name, String opcode, String fncode) {
			this.name = name;
			this.opcode = opcode;
			this.fncode = fncode;
		}
	}

	// constants
	private static final String TAB = "    ";
	// BASE ////////////////////////////////////////////////////////////////////
	private static final Type ADD = new Type("ADD", "1010", "110");
	private static final Type SUB = new Type("SUB", "1010", "101");
	private static final Type AND = new Type("AND", "1010", "100");
	private static final Type OR = new Type("OR", "1010", "011");
	private static final Type NOT = new Type("NOT", "1010", "001");
	private static final Type XOR = new Type("XOR", "1010", "010");
	// SET /////////////////////////////////////////////////////////////////////
	private static final Type SU = new Type("SU", "0110", "001"); // set upper
	private static final Type SL = new Type("SL", "0110", "000"); // set lower
	// SHIFT ///////////////////////////////////////////////////////////////////
	private static final Type SHRA = new Type("SHRA", "1011", "100"); // shift right arithmetic (preserve sign)
	private static final Type SHRL = new Type("SHRL", "1011", "101"); // shift right logical (fill with zeros)
	private static final Type ROR = new Type("ROR", "1011", "110"); // rotate right
	private static final Type SHL = new Type("SHL", "1011", "111"); // shift left (fill with zeros)
	private static final Type ROL = new Type("ROL", "1011", "000"); // rotate left
	// MOVE ////////////////////////////////////////////////////////////////////
	private static final Type MV0 = new Type("MV0", "1100", "xxx");
	private static final Type MV1 = new Type("MV1", "1101", "xxx");
	private static final Type MV2 = new Type("MV2", "1110", "xxx");
	private static final Type MV3 = new Type("MV3", "1111", "xxx");
	// CONTROL FLOW ////////////////////////////////////////////////////////////
	private static final Type BRLT = new Type("BRLT", "0010", "000");
	private static final Type BRGT = new Type("BRGT", "0010", "001");
	private static final Type BRLE = new Type("BRLE", "0010", "010");
	private static final Type BRGE = new Type("BRGE", "0010", "011");
	private static final Type BREQ = new Type("BREQ", "0010", "100");
	private static final Type BRNE = new Type("BRNE", "0010", "101");
	private static final Type J = new Type("J", "0100", "xxx");
	// MEMORY //////////////////////////////////////////////////////////////////
	private static final Type LD = new Type("LD", "1000", "xxx"); // load
	private static final Type ST = new Type("ST", "0111", "xxx"); // store
	// SPECIAL /////////////////////////////////////////////////////////////////
	private static final Type LDC = new Type("LDC", "1001", "xxx"); // retrieve from special purpose reg
	private static final Type NOP = new Type("NOP", "0001", "xxx"); // no operation, does nothing
	private static final Type HALT = new Type("HALT", "0000", "xxx"); // stop executing
	// PSUEDO //////////////////////////////////////////////////////////////////
	private static final Type MOV = new Type("MOV", "xxxx", "xxx"); // MV0+MV1+MV2+MV3
	
	// static fields
	private static boolean debug = Driver.debug;
	private static SymbolTable symTab = null;
	
	/*
	 * Sets the translator's symbol table to the given table.
	 */
	public static void updateSymbolTable(SymbolTable symTab) {
		Translator.symTab = symTab;
	}
	
	/*
	 * Adds the machine code representation of the given instruction to given 
	 * list. Expects the line number from the assembly file as the first token 
	 * in instruction.
	 * 		- instr - encode this instruction, "<line_number> <raw_line>" will need processing
	 * 		- o - object file list to add instruction to
	 */
	public static void encodeInstruction(String instr, List<String> o) {
		String [] tokens;
		int lineNum; // where this instruction is located in the input file
		String name; // name of instruction we are translating
		String str = ""; // add this binary string as the translated instruction
		String rd = "000"; // register Rd in binary
		String rs = "000"; // register Rs in binary
		String rq = "000"; // register Rq in binary
		String imm = ""; // immediate
		String immToken = ""; // raw immediate taken directly from assembly instruction
		Symbol sym; // symbol pulled from symbol table
		int commentIndex; // location in instruction of first character of the comment
		
		// remove comment (if any exists)
		commentIndex = instr.indexOf('#');
		if(commentIndex >= 0) {
			instr = instr.substring(0, commentIndex);
		}
		commentIndex = instr.indexOf('/');
		if(commentIndex >= 0) {
			instr = instr.substring(commentIndex);
		}
		
		// separate instruction into tokens
		instr = instr.trim(); // remove leading and trailing whitespace
		while(instr.contains("\t")) instr = instr.replaceAll("\t", " "); // remove tabs
		while(instr.contains("  ")) instr = instr.replace("  ", " "); // remove extra spaces
		tokens = instr.split(" ");
		if(debug) {
			System.out.println("Translating "+instr+":");
		}
		
		// extract basics -- line number and name
		lineNum = Integer.parseInt(tokens[0]);
		name = tokens[1].toUpperCase();
		
		// identify instruction type
		try {
			// BASE ////////////////////////////////////////////////////////////
			if(name.contentEquals(ADD.name)) {
				// ADD Rd, Rs, Rq
				// <oooo><ddd><sss><qqq><fff>
				// extract registers
				rd = getRegBinary(tokens[2].replace(",",""), lineNum);
				rs = getRegBinary(tokens[3].replace(",",""), lineNum);
				rq = getRegBinary(tokens[4].replace(",",""), lineNum);
				
				// compose binary
				str = ADD.opcode+rd+rs+rq+ADD.fncode;
				o.add(str);
				if(debug) { System.out.println(TAB+str); }
			}
			else if(name.contentEquals(SUB.name)) {
				// SUB Rd, Rs, Rq
				// <oooo><ddd><sss><qqq><fff>
				// extract registers
				rd = getRegBinary(tokens[2].replace(",",""), lineNum);
				rs = getRegBinary(tokens[3].replace(",",""), lineNum);
				rq = getRegBinary(tokens[4].replace(",",""), lineNum);
				
				// compose binary
				str = SUB.opcode+rd+rs+rq+SUB.fncode;
				o.add(str);
				if(debug) { System.out.println(TAB+str); }
			}
			else if(name.contentEquals(AND.name)) {
				// AND Rd, Rs, Rq
				// <oooo><ddd><sss><qqq><fff>
				// extract registers
				rd = getRegBinary(tokens[2].replace(",",""), lineNum);
				rs = getRegBinary(tokens[3].replace(",",""), lineNum);
				rq = getRegBinary(tokens[4].replace(",",""), lineNum);
				
				// compose binary
				str = AND.opcode+rd+rs+rq+AND.fncode;
				o.add(str);
				if(debug) { System.out.println(TAB+str); }
			}
			else if(name.contentEquals(OR.name)) {
				// OR Rd, Rs, Rq
				// <oooo><ddd><sss><qqq><fff>
				// extract registers
				rd = getRegBinary(tokens[2].replace(",",""), lineNum);
				rs = getRegBinary(tokens[3].replace(",",""), lineNum);
				rq = getRegBinary(tokens[4].replace(",",""), lineNum);
				
				// compose binary
				str = OR.opcode+rd+rs+rq+OR.fncode;
				o.add(str);
				if(debug) { System.out.println(TAB+str); }
			}
			else if(name.contentEquals(NOT.name)) {
				// NOT Rd, Rs
				// <oooo><ddd><sss><xxx><fff>
				// extract registers
				rd = getRegBinary(tokens[2].replace(",",""), lineNum);
				rs = getRegBinary(tokens[3].replace(",",""), lineNum);
				
				// compose binary
				str = NOT.opcode+rd+rs+rq+NOT.fncode;
				o.add(str);
				if(debug) { System.out.println(TAB+str); }
			}
			else if(name.contentEquals(XOR.name)) {
				// XOR Rd, Rs, Rq
				// <oooo><ddd><sss><qqq><fff>
				// extract registers
				rd = getRegBinary(tokens[2].replace(",",""), lineNum);
				rs = getRegBinary(tokens[3].replace(",",""), lineNum);
				rq = getRegBinary(tokens[4].replace(",",""), lineNum);
				
				// compose binary
				str = XOR.opcode+rd+rs+rq+XOR.fncode;
				o.add(str);
				if(debug) { System.out.println(TAB+str); }
			}
			// SET /////////////////////////////////////////////////////////////
			else if(name.contentEquals(SU.name)) {
				// SU Rd, Rs
				// <oooo><ddd><sss><xxx><fff>
				// extract registers
				rd = getRegBinary(tokens[2].replace(",",""), lineNum);
				rs = getRegBinary(tokens[3].replace(",",""), lineNum);
				
				// compose binary
				str = SU.opcode+rd+rs+rq+SU.fncode;
				o.add(str);
				if(debug) { System.out.println(TAB+str); }
			}
			else if(name.contentEquals(SL.name)) {
				// SL Rd, Rs, Rq
				// <oooo><ddd><sss><xxx><fff>
				// extract registers
				rd = getRegBinary(tokens[2].replace(",",""), lineNum);
				rs = getRegBinary(tokens[3].replace(",",""), lineNum);
				
				// compose binary
				str = SL.opcode+rd+rs+rq+SL.fncode;
				o.add(str);
				if(debug) { System.out.println(TAB+str); }
			}
			// SHIFT ///////////////////////////////////////////////////////////
			else if(name.contentEquals(SHRA.name)) {
				// SHRA Rd, Rs, Rq
				// <oooo><ddd><sss><qqq><fff>
				// extract registers
				rd = getRegBinary(tokens[2].replace(",",""), lineNum);
				rs = getRegBinary(tokens[3].replace(",",""), lineNum);
				rq = getRegBinary(tokens[4].replace(",",""), lineNum);
				
				// compose binary
				str = SHRA.opcode+rd+rs+rq+SHRA.fncode;
				o.add(str);
				if(debug) { System.out.println(TAB+str); }
			}
			else if(name.contentEquals(SHRL.name)) {
				// SHRL Rd, Rs, Rq
				// <oooo><ddd><sss><qqq><fff>
				// extract registers
				rd = getRegBinary(tokens[2].replace(",",""), lineNum);
				rs = getRegBinary(tokens[3].replace(",",""), lineNum);
				rq = getRegBinary(tokens[4].replace(",",""), lineNum);
				
				// compose binary
				str = SHRL.opcode+rd+rs+rq+SHRL.fncode;
				o.add(str);
				if(debug) { System.out.println(TAB+str); }
			}
			else if(name.contentEquals(ROR.name)) {
				// ROR Rd, Rs, Rq
				// <oooo><ddd><sss><qqq><fff>
				// extract registers
				rd = getRegBinary(tokens[2].replace(",",""), lineNum);
				rs = getRegBinary(tokens[3].replace(",",""), lineNum);
				rq = getRegBinary(tokens[4].replace(",",""), lineNum);
				
				// compose binary
				str = ROR.opcode+rd+rs+rq+ROR.fncode;
				o.add(str);
				if(debug) { System.out.println(TAB+str); }
			}
			else if(name.contentEquals(SHL.name)) {
				// SHL Rd, Rs, Rq
				// <oooo><ddd><sss><qqq><fff>
				// extract registers
				rd = getRegBinary(tokens[2].replace(",",""), lineNum);
				rs = getRegBinary(tokens[3].replace(",",""), lineNum);
				rq = getRegBinary(tokens[4].replace(",",""), lineNum);
				
				// compose binary
				str = SHL.opcode+rd+rs+rq+SHL.fncode;
				o.add(str);
				if(debug) { System.out.println(TAB+str); }
			}
			else if(name.contentEquals(ROL.name)) {
				// ROL Rd, Rs, Rq
				// <oooo><ddd><sss><qqq><fff>
				// extract registers
				rd = getRegBinary(tokens[2].replace(",",""), lineNum);
				rs = getRegBinary(tokens[3].replace(",",""), lineNum);
				rq = getRegBinary(tokens[4].replace(",",""), lineNum);
				
				// compose binary
				str = ROL.opcode+rd+rs+rq+ROL.fncode;
				o.add(str);
				if(debug) { System.out.println(TAB+str); }
			}
			// MOVE ////////////////////////////////////////////////////////////
			else if(name.contentEquals(MV0.name)) {
				// MV0 Rd, imm8
				// <oooo><ddd><x><ii iii iii>
				// extract register
				rd = getRegBinary(tokens[2].replace(",",""), lineNum);
				
				// get immediate
				imm = getImmBinary(tokens[3].replace(",", ""), 0, 7, lineNum);
				
				// compose binary
				str = MV0.opcode+rd+"0"+imm;
				o.add(str);
				if(debug) { System.out.println(TAB+str); }
			}
			else if(name.contentEquals(MV1.name)) {
				// MV1 Rd, imm8
				// <oooo><ddd><x><ii iii iii>
				// extract register
				rd = getRegBinary(tokens[2].replace(",",""), lineNum);
				
				// get immediate
				imm = getImmBinary(tokens[3].replace(",", ""), 8, 15, lineNum);
				
				// compose binary
				str = MV1.opcode+rd+"0"+imm;
				o.add(str);
				if(debug) { System.out.println(TAB+str); }
			}
			else if(name.contentEquals(MV2.name)) {
				// MV2 Rd, imm8
				// <oooo><ddd><x><ii iii iii>
				// extract register
				rd = getRegBinary(tokens[2].replace(",",""), lineNum);
				
				// get immediate
				imm = getImmBinary(tokens[3].replace(",", ""), 16, 23, lineNum);
				
				// compose binary
				str = MV2.opcode+rd+"0"+imm;
				o.add(str);
				if(debug) { System.out.println(TAB+str); }
			}
			else if(name.contentEquals(MV3.name)) {
				// MV3 Rd, imm8
				// <oooo><ddd><x><ii iii iii>
				// extract register
				rd = getRegBinary(tokens[2].replace(",",""), lineNum);
				
				// get immediate
				imm = getImmBinary(tokens[3].replace(",", ""), 24, 31, lineNum);
				
				// compose binary
				str = MV3.opcode+rd+"0"+imm;
				o.add(str);
				if(debug) { System.out.println(TAB+str); }
			}
			// CONTROL FLOW ////////////////////////////////////////////////////
			else if(name.contentEquals(BRLT.name)) {
				// BRLT Rs, Rq
				// <oooo><xxx><sss><qqq><fff>
				// extract registers
				rs = getRegBinary(tokens[2].replace(",",""), lineNum);
				rq = getRegBinary(tokens[3].replace(",",""), lineNum);
				
				// compose binary
				str = BRLT.opcode+rd+rs+rq+BRLT.fncode;
				o.add(str);
				if(debug) { System.out.println(TAB+str); }
			}
			else if(name.contentEquals(BRGT.name)) {
				// BRGT Rs, Rq
				// <oooo><xxx><sss><qqq><fff>
				// extract registers
				rs = getRegBinary(tokens[2].replace(",",""), lineNum);
				rq = getRegBinary(tokens[3].replace(",",""), lineNum);
				
				// compose binary
				str = BRGT.opcode+rd+rs+rq+BRGT.fncode;
				o.add(str);
				if(debug) { System.out.println(TAB+str); }
			}
			else if(name.contentEquals(BRLE.name)) {
				// BRLE Rs, Rq
				// <oooo><xxx><sss><qqq><fff>
				// extract registers
				rs = getRegBinary(tokens[2].replace(",",""), lineNum);
				rq = getRegBinary(tokens[3].replace(",",""), lineNum);
				
				// compose binary
				str = BRLE.opcode+rd+rs+rq+BRLE.fncode;
				o.add(str);
				if(debug) { System.out.println(TAB+str); }
			}
			else if(name.contentEquals(BRGE.name)) {
				// BRGE Rs, Rq
				// <oooo><xxx><sss><qqq><fff>
				// extract registers
				rs = getRegBinary(tokens[2].replace(",",""), lineNum);
				rq = getRegBinary(tokens[3].replace(",",""), lineNum);
				
				// compose binary
				str = BRGE.opcode+rd+rs+rq+BRGE.fncode;
				o.add(str);
				if(debug) { System.out.println(TAB+str); }
			}
			else if(name.contentEquals(BREQ.name)) {
				// BREQ Rs, Rq
				// <oooo><xxx><sss><qqq><fff>
				// extract registers
				rs = getRegBinary(tokens[2].replace(",",""), lineNum);
				rq = getRegBinary(tokens[3].replace(",",""), lineNum);
				
				// compose binary
				str = BREQ.opcode+rd+rs+rq+BREQ.fncode;
				o.add(str);
				if(debug) { System.out.println(TAB+str); }
			}
			else if(name.contentEquals(BRNE.name)) {
				// BRNE Rs, Rq
				// <oooo><xxx><sss><qqq><fff>
				// extract registers
				rs = getRegBinary(tokens[2].replace(",",""), lineNum);
				rq = getRegBinary(tokens[3].replace(",",""), lineNum);
				
				// compose binary
				str = BRNE.opcode+rd+rs+rq+BRNE.fncode;
				o.add(str);
				if(debug) { System.out.println(TAB+str); }
			}
			else if(name.contentEquals(J.name)) {
				// J Rd
				// <oooo><ddd><xxx xxx xxx>
				// extract register
				rd = getRegBinary(tokens[2].replace(",",""), lineNum);
				
				// compose binary
				str = J.opcode+rd+"000000000";
				o.add(str);
				if(debug) { System.out.println(TAB+str); }
			}
			// MEMORY //////////////////////////////////////////////////////////
			else if(name.contentEquals(LD.name)) {
				// LD Rd, Rs, imm6
				// <oooo><ddd><sss><iii iii>
				// extract registers
				rd = getRegBinary(tokens[2].replace(",",""), lineNum);
				rs = getRegBinary(tokens[3].replace(",",""), lineNum);
				
				// get immediate
				imm = getOffsetBinary(tokens[4].replace(",",""), lineNum);
				
				// compose binary
				str = LD.opcode+rd+rs+imm;
				o.add(str);
				if(debug) { System.out.println(TAB+str); }
			}
			else if(name.contentEquals(ST.name)) {
				// ST Rd, Rs, imm6
				// <oooo><ddd><sss><iii iii>
				// extract registers
				rd = getRegBinary(tokens[2].replace(",",""), lineNum);
				rs = getRegBinary(tokens[3].replace(",",""), lineNum);
				
				// get immediate
				imm = getOffsetBinary(tokens[4].replace(",",""), lineNum);
				
				// compose binary
				str = ST.opcode+rd+rs+imm;
				o.add(str);
				if(debug) { System.out.println(TAB+str); }
			}
			// SPECIAL /////////////////////////////////////////////////////////
			else if(name.contentEquals(LDC.name)) {
				// LDC Rd
				// <oooo><ddd><xxx xxx xxx>
				// extract register
				rd = getRegBinary(tokens[2].replace(",",""), lineNum);
				
				// compose binary
				str = LDC.opcode+rd+"000000000";
				o.add(str);
				if(debug) { System.out.println(TAB+str); }
			}
			else if(name.contentEquals(NOP.name)) {
				// NOP
				// <oooo><xxx xxx xxx xxx>				
				// compose binary
				str = NOP.opcode+"000000000000";
				o.add(str);
				if(debug) { System.out.println(TAB+str); }
			}
			else if(name.contentEquals(HALT.name)) {
				// HALT
				// <oooo><xxx xxx xxx xxx>				
				// compose binary
				str = HALT.opcode+"000000000000";
				o.add(str);
				if(debug) { System.out.println(TAB+str); }
			}
			// PSUEDO //////////////////////////////////////////////////////////
			else if(name.contentEquals(MOV.name)) {
				// MOV Rd, imm32
				// 		MV0 Rd, imm8		<oooo><ddd><x><ii iii iii>
				// 		MV1 Rd, imm8		<oooo><ddd><x><ii iii iii>
				//		MV2 Rd, imm8		<oooo><ddd><x><ii iii iii>
				//		MV3 Rd, imm8		<oooo><ddd><x><ii iii iii>
				
				// extract target register and immediate token
				rd = getRegBinary(tokens[2].replace(",",""), lineNum);
				immToken = tokens[3].replace(",", "");
				
				// MV0
				imm = getImmBinary(immToken, 0, 7, lineNum);
				str = MV0.opcode+rd+"0"+imm;
				o.add(str);
				if(debug) { System.out.println(TAB+str); }
				
				// MV1
				imm = getImmBinary(immToken, 8, 15, lineNum);
				str = MV1.opcode+rd+"0"+imm;
				o.add(str);
				if(debug) { System.out.println(TAB+str); }
				
				// MV2
				imm = getImmBinary(immToken, 16, 23, lineNum);
				str = MV2.opcode+rd+"0"+imm;
				o.add(str);
				if(debug) { System.out.println(TAB+str); }
				
				// MV3
				imm = getImmBinary(immToken, 24, 31, lineNum);
				str = MV3.opcode+rd+"0"+imm;
				o.add(str);
				if(debug) { System.out.println(TAB+str); }
			}
			// ELSE ////////////////////////////////////////////////////////////
			else { // unrecognized line
				System.out.printf("%d: Unrecognized line. Unless I am very much mistaken, this is not an instruction.", lineNum);
				System.exit(0);
			}
		}
		catch(ArrayIndexOutOfBoundsException e) {
			System.out.printf("%d: Too few tokens for %s instruction.\n", lineNum, name);
			System.exit(0);
		}
		
		// instruction is good
	}
	
	/*
	 * Returns an assembly string corresponding to the given binary register.
	 * 		- EX: 011 corresponds to R3
	 */
	private static String getRegAsm(String regToken, int lineNum) {
		String reg = "";
		
		// look up table
		if(regToken.contentEquals("000")) {
			reg = "R0";
		}
		else if(regToken.contentEquals("001")) {
			reg = "R1";
		}
		else if(regToken.contentEquals("010")) {
			reg = "R2";
		}
		else if(regToken.contentEquals("011")) {
			reg = "R3";
		}
		else if(regToken.contentEquals("100")) {
			reg = "R4";
		}
		else if(regToken.contentEquals("101")) {
			reg = "R5";
		}
		else if(regToken.contentEquals("110")) {
			reg = "R6";
		}
		else if(regToken.contentEquals("111")) {
			reg = "R7";
		}
		else { // illegal token
			System.out.printf("%d: %s is not a register.\n", lineNum, regToken);
			System.exit(0);
		}
		
		return reg;
	}
	
	/*
	 * Returns a 3 digit binary string corresponding to the given register.
	 * token.
	 * 		- EX: R3 corresponds to 011
	 */
	private static String getRegBinary(String regToken, int lineNum) {
		String reg = "";
		
		// look up table
		if(regToken.contentEquals("R0")) {
			reg = "000";
		}
		else if(regToken.contentEquals("R1")) {
			reg = "001";
		}
		else if(regToken.contentEquals("R2")) {
			reg = "010";
		}
		else if(regToken.contentEquals("R3")) {
			reg = "011";
		}
		else if(regToken.contentEquals("R4")) {
			reg = "100";
		}
		else if(regToken.contentEquals("R5")) {
			reg = "101";
		}
		else if(regToken.contentEquals("R6")) {
			reg = "110";
		}
		else if(regToken.contentEquals("R7")) {
			reg = "111";
		}
		else { // illegal token
			System.out.printf("%d: %s is not a register.\n", lineNum, regToken);
			System.exit(0);
		}
		
		return reg;
	}
	
	/*
	 * Returns the 8 bit binary translation of the given immediate. An immediate can be an integer literal, macro, or label.
	 * The start and end indices indicate which which bits of the 32 bit immediate to take from. The immediate cannot exceed 8
	 * bits, so:
	 * 		- if bit range is less than 8, fill with zeros
	 * 		- if bit range equals 8, just return those 8
	 * 		- if bit range is greater than 8, return the 8 least significant bits
	 */
	private static String getImmBinary(String immToken, int start, int end, int lineNum) {
		int literal = 0;
		String imm32 = "";
		String imm8 = "";
		
		// check for token in symbol table
		imm32 = symTab.get(immToken);
		if(imm32 == null) { // immediate is not a macro or label, maybe literal?
			try {
				literal = Integer.parseInt(immToken);
			}
			catch(Exception e) {
				System.out.printf("%d: Expecting macro, label, or literal. Can't recognize: %s.\n", lineNum, immToken);
				System.exit(0);
			}
			
			// convert literal to binary
			imm32 = decimalToBinary(literal, 32, lineNum);
		}
		
		// narrow immediate to requested bits
		imm8 = imm32.substring(32-1-end, 32-start);
		
		return imm8;
	}
	
	/*
	 * Returns the decimal translation of the given 8 bit binary immediate. 
	 * Binary input should be treated as a signed number.
	 */
	private static String getImmAsm(String immToken, int lineNum) {
		return binaryToDecimal(immToken, lineNum)+"";
	}
	
	/*
	 * Returns the 6 bit binary translation of the given integer literal offset.
	 */
	private static String getOffsetBinary(String offsetToken, int lineNum) {
		String imm6 = "";
		String imm32 = "";
		int literal = 0;
		
		try {
			literal = Integer.parseInt(offsetToken);
		}
		catch(Exception e) {
			System.out.printf("%d: Expecting integer literal. Can't recognize: %s.\n", lineNum, offsetToken);
			System.exit(0);
		}
		
		// convert literal to binary
		imm32 = decimalToBinary(literal, 32, lineNum);
		
		// narrow immediate to requested bits
		imm6 = imm32.substring(imm32.length()-6, imm32.length());
		
		return imm6;
	}
	
	/*
	 * Returns the decimal translation of the given 6 bit binary offset.
	 */
	private static String getOffsetAsm(String offsetToken, int lineNum) {
		return binaryToDecimal(offsetToken, lineNum)+"";
	}
	
	/*
	 * Returns an assembly representation of the given instruction.
	 */
	public static void decodeInstruction(String instr, List<String> rsm) {
		int lineNum = -1;
		String [] tokens = null;
		String binary = null;
		String opcode = null;
		String fncode = null;
		String rd = null;
		String rs = null;
		String rq = null;
		String imm = null; // immediate
		String str = null; // re-assembled instruction
		
		// extract line number and instruction
		tokens = instr.split(" ");
		try {
			lineNum = Integer.parseInt(tokens[0]);
			binary = tokens[1];
		}
		catch(Exception e) {
			System.out.printf("%d: Unrecognizable line.");
			System.exit(0);
		}
		
		// DEBUG
		if(debug) {
			System.out.println("Translating "+binary+":");
		}
		
		// extract codes
		opcode = binary.substring(0,4); // first 4 bits
		fncode = binary.substring(13,16); // last 3 bits
		
		// identify instruction type
		// BASE ////////////////////////////////////////////////////////////
		if(opcode.contentEquals(ADD.opcode) && fncode.contentEquals(ADD.fncode)) {
			// ADD Rd, Rs, Rq
			// <oooo><ddd><sss><qqq><fff>
			// extract registers
			rd = getRegAsm(binary.substring(4, 7), lineNum);
			rs = getRegAsm(binary.substring(7, 10), lineNum);
			rq = getRegAsm(binary.substring(10,13), lineNum);
						
			// compose assembly
			str = ADD.name+" "+rd+", "+rs+", "+rq;
			rsm.add(str);
			if(debug) { System.out.println(TAB+str); }
		}
		else if(opcode.contentEquals(SUB.opcode) && fncode.contentEquals(SUB.fncode)) {
			// SUB Rd, Rs, Rq
			// <oooo><ddd><sss><qqq><fff>
			// extract registers
			rd = getRegAsm(binary.substring(4, 7), lineNum);
			rs = getRegAsm(binary.substring(7, 10), lineNum);
			rq = getRegAsm(binary.substring(10,13), lineNum);
						
			// compose assembly
			str = SUB.name+" "+rd+", "+rs+", "+rq;
			rsm.add(str);
			if(debug) { System.out.println(TAB+str); }
		}
		else if(opcode.contentEquals(AND.opcode) && fncode.contentEquals(AND.fncode)) {
			// AND Rd, Rs, Rq
			// <oooo><ddd><sss><qqq><fff>
			// extract registers
			rd = getRegAsm(binary.substring(4, 7), lineNum);
			rs = getRegAsm(binary.substring(7, 10), lineNum);
			rq = getRegAsm(binary.substring(10,13), lineNum);
						
			// compose assembly
			str = AND.name+" "+rd+", "+rs+", "+rq;
			rsm.add(str);
			if(debug) { System.out.println(TAB+str); }
		}
		else if(opcode.contentEquals(OR.opcode) && fncode.contentEquals(OR.fncode)) {
			// OR Rd, Rs, Rq
			// <oooo><ddd><sss><qqq><fff>
			// extract registers
			rd = getRegAsm(binary.substring(4, 7), lineNum);
			rs = getRegAsm(binary.substring(7, 10), lineNum);
			rq = getRegAsm(binary.substring(10,13), lineNum);
						
			// compose assembly
			str = OR.name+" "+rd+", "+rs+", "+rq;
			rsm.add(str);
			if(debug) { System.out.println(TAB+str); }
		}
		else if(opcode.contentEquals(NOT.opcode) && fncode.contentEquals(NOT.fncode)) {
			// NOT Rd, Rs
			// <oooo><ddd><sss><xxx><fff>
			// extract registers
			rd = getRegAsm(binary.substring(4, 7), lineNum);
			rs = getRegAsm(binary.substring(7, 10), lineNum);
						
			// compose assembly
			str = NOT.name+" "+rd+", "+rs;
			rsm.add(str);
			if(debug) { System.out.println(TAB+str); }
		}
		else if(opcode.contentEquals(XOR.opcode) && fncode.contentEquals(XOR.fncode)) {
			// XOR Rd, Rs, Rq
			// <oooo><ddd><sss><qqq><fff>
			// extract registers
			rd = getRegAsm(binary.substring(4, 7), lineNum);
			rs = getRegAsm(binary.substring(7, 10), lineNum);
			rq = getRegAsm(binary.substring(10,13), lineNum);
			
			// compose assembly
			str = XOR.name+" "+rd+", "+rs+", "+rq;
			rsm.add(str);
			if(debug) { System.out.println(TAB+str); }
		}
		// SET /////////////////////////////////////////////////////////////
		else if(opcode.contentEquals(SU.opcode) && fncode.contentEquals(SU.fncode)) {
			// SU Rd, Rs
			// <oooo><ddd><sss><xxx><fff>
			// extract registers
			rd = getRegAsm(binary.substring(4, 7), lineNum);
			rs = getRegAsm(binary.substring(7, 10), lineNum);
						
			// compose assembly
			str = SU.name+" "+rd+", "+rs;
			rsm.add(str);
			if(debug) { System.out.println(TAB+str); }
		}
		else if(opcode.contentEquals(SL.opcode) && fncode.contentEquals(SL.fncode)) {
			// SL Rd, Rs, Rq
			// <oooo><ddd><sss><xxx><fff>
			// extract registers
			rd = getRegAsm(binary.substring(4, 7), lineNum);
			rs = getRegAsm(binary.substring(7, 10), lineNum);
						
			// compose assembly
			str = SL.name+" "+rd+", "+rs;
			rsm.add(str);
			if(debug) { System.out.println(TAB+str); }
		}
		// SHIFT ///////////////////////////////////////////////////////////
		else if(opcode.contentEquals(SHRA.opcode) && fncode.contentEquals(SHRA.fncode)) {
			// SHRA Rd, Rs, Rq
			// <oooo><ddd><sss><qqq><fff>
			// extract registers
			rd = getRegAsm(binary.substring(4, 7), lineNum);
			rs = getRegAsm(binary.substring(7, 10), lineNum);
			rq = getRegAsm(binary.substring(10,13), lineNum);
						
			// compose assembly
			str = SHRA.name+" "+rd+", "+rs+", "+rq;
			rsm.add(str);
			if(debug) { System.out.println(TAB+str); }
		}
		else if(opcode.contentEquals(SHRL.opcode) && fncode.contentEquals(SHRL.fncode)) {
			// SHRL Rd, Rs, Rq
			// <oooo><ddd><sss><qqq><fff>
			// extract registers
			rd = getRegAsm(binary.substring(4, 7), lineNum);
			rs = getRegAsm(binary.substring(7, 10), lineNum);
			rq = getRegAsm(binary.substring(10,13), lineNum);
						
			// compose assembly
			str = SHRL.name+" "+rd+", "+rs+", "+rq;
			rsm.add(str);
			if(debug) { System.out.println(TAB+str); }
		}
		else if(opcode.contentEquals(ROR.opcode) && fncode.contentEquals(ROR.fncode)) {
			// ROR Rd, Rs, Rq
			// <oooo><ddd><sss><qqq><fff>
			// extract registers
			rd = getRegAsm(binary.substring(4, 7), lineNum);
			rs = getRegAsm(binary.substring(7, 10), lineNum);
			rq = getRegAsm(binary.substring(10,13), lineNum);
						
			// compose assembly
			str = ROR.name+" "+rd+", "+rs+", "+rq;
			rsm.add(str);
			if(debug) { System.out.println(TAB+str); }
		}
		else if(opcode.contentEquals(SHL.opcode) && fncode.contentEquals(SHL.fncode)) {
			// SHL Rd, Rs, Rq
			// <oooo><ddd><sss><qqq><fff>
			// extract registers
			rd = getRegAsm(binary.substring(4, 7), lineNum);
			rs = getRegAsm(binary.substring(7, 10), lineNum);
			rq = getRegAsm(binary.substring(10,13), lineNum);
			
			// compose assembly
			str = SHL.name+" "+rd+", "+rs+", "+rq;
			rsm.add(str);
			if(debug) { System.out.println(TAB+str); }
		}
		else if(opcode.contentEquals(ROL.opcode) && fncode.contentEquals(ROL.fncode)) {
			// ROL Rd, Rs, Rq
			// <oooo><ddd><sss><qqq><fff>
			// extract registers
			rd = getRegAsm(binary.substring(4, 7), lineNum);
			rs = getRegAsm(binary.substring(7, 10), lineNum);
			rq = getRegAsm(binary.substring(10,13), lineNum);
						
			// compose assembly
			str = ROL.name+" "+rd+", "+rs+", "+rq;
			rsm.add(str);
			if(debug) { System.out.println(TAB+str); }
		}
		// MOVE ////////////////////////////////////////////////////////////
		else if(opcode.contentEquals(MV0.opcode)) {
			// MV0 Rd, imm8
			// <oooo><ddd><x><ii iii iii>
			// extract register
			rd = getRegAsm(binary.substring(4, 7), lineNum);
						
			// get immediate
			imm = getImmAsm(binary.substring(8, 16), lineNum);
						
			// compose assembly
			str = MV0.name+" "+rd+", "+imm;
			rsm.add(str);
			if(debug) { System.out.println(TAB+str); }
		}
		else if(opcode.contentEquals(MV1.opcode)) {
			// MV1 Rd, imm8
			// <oooo><ddd><x><ii iii iii>
			// extract register
			rd = getRegAsm(binary.substring(4, 7), lineNum);
						
			// get immediate
			imm = getImmAsm(binary.substring(8, 16), lineNum);
						
			// compose assembly
			str = MV1.name+" "+rd+", "+imm;
			rsm.add(str);
			if(debug) { System.out.println(TAB+str); }
		}
		else if(opcode.contentEquals(MV2.opcode)) {
			// MV2 Rd, imm8
			// <oooo><ddd><x><ii iii iii>
			// extract register
			rd = getRegAsm(binary.substring(4, 7), lineNum);
						
			// get immediate
			imm = getImmAsm(binary.substring(8, 16), lineNum);
						
			// compose assembly
			str = MV2.name+" "+rd+", "+imm;
			rsm.add(str);
			if(debug) { System.out.println(TAB+str); }
		}
		else if(opcode.contentEquals(MV3.opcode)) {
			// MV3 Rd, imm8
			// <oooo><ddd><x><ii iii iii>
			// extract register
			rd = getRegAsm(binary.substring(4, 7), lineNum);
						
			// get immediate
			imm = getImmAsm(binary.substring(8, 16), lineNum);
						
			// compose assembly
			str = MV3.name+" "+rd+", "+imm;
			rsm.add(str);
			if(debug) { System.out.println(TAB+str); }
		}
		// CONTROL FLOW ////////////////////////////////////////////////////
		else if(opcode.contentEquals(BRLT.opcode) && fncode.contentEquals(BRLT.fncode)) {
			// BRLT Rs, Rq
			// <oooo><xxx><sss><qqq><fff>
			// extract registers
			rs = getRegAsm(binary.substring(7, 10), lineNum);
			rq = getRegAsm(binary.substring(10, 13), lineNum);
						
			// compose assembly
			str = BRLT.name+" "+rs+", "+rq;
			rsm.add(str);
			if(debug) { System.out.println(TAB+str); }
		}
		else if(opcode.contentEquals(BRGT.opcode) && fncode.contentEquals(BRGT.fncode)) {
			// BRGT Rs, Rq
			// <oooo><xxx><sss><qqq><fff>
			// extract registers
			rs = getRegAsm(binary.substring(7, 10), lineNum);
			rq = getRegAsm(binary.substring(10, 13), lineNum);
						
			// compose assembly
			str = BRGT.name+" "+rs+", "+rq;
			rsm.add(str);
			if(debug) { System.out.println(TAB+str); }
		}
		else if(opcode.contentEquals(BRLE.opcode) && fncode.contentEquals(BRLE.fncode)) {
			// BRLE Rs, Rq
			// <oooo><xxx><sss><qqq><fff>
			// extract registers
			rs = getRegAsm(binary.substring(7, 10), lineNum);
			rq = getRegAsm(binary.substring(10, 13), lineNum);
						
			// compose assembly
			str = BRLE.name+" "+rs+", "+rq;
			rsm.add(str);
			if(debug) { System.out.println(TAB+str); }
		}
		else if(opcode.contentEquals(BRGE.opcode) && fncode.contentEquals(BRGE.fncode)) {
			// BRGE Rs, Rq
			// <oooo><xxx><sss><qqq><fff>
			// extract registers
			rs = getRegAsm(binary.substring(7, 10), lineNum);
			rq = getRegAsm(binary.substring(10, 13), lineNum);
						
			// compose assembly
			str = BRGE.name+" "+rs+", "+rq;
			rsm.add(str);
			if(debug) { System.out.println(TAB+str); }
		}
		else if(opcode.contentEquals(BREQ.opcode) && fncode.contentEquals(BREQ.fncode)) {
			// BREQ Rs, Rq
			// <oooo><xxx><sss><qqq><fff>
			// extract registers
			rs = getRegAsm(binary.substring(7, 10), lineNum);
			rq = getRegAsm(binary.substring(10, 13), lineNum);
						
			// compose assembly
			str = BREQ.name+" "+rs+", "+rq;
			rsm.add(str);
			if(debug) { System.out.println(TAB+str); }
		}
		else if(opcode.contentEquals(BRNE.opcode) && fncode.contentEquals(BRNE.fncode)) {
			// BRNE Rs, Rq
			// <oooo><xxx><sss><qqq><fff>
			// extract registers
			rs = getRegAsm(binary.substring(7, 10), lineNum);
			rq = getRegAsm(binary.substring(10, 13), lineNum);
						
			// compose assembly
			str = BRNE.name+" "+rs+", "+rq;
			rsm.add(str);
			if(debug) { System.out.println(TAB+str); }
		}
		else if(opcode.contentEquals(J.opcode)) {
			// J Rd
			// <oooo><ddd><xxx xxx xxx>
			// extract register
			rd = getRegAsm(binary.substring(4, 7), lineNum);
						
			// compose assembly
			str = J.name+" "+rd;
			rsm.add(str);
			if(debug) { System.out.println(TAB+str); }
		}
		// MEMORY //////////////////////////////////////////////////////////
		else if(opcode.contentEquals(LD.opcode)) {
			// LD Rd, Rs, imm6
			// <oooo><ddd><sss><iii iii>
			// extract registers
			rd = getRegAsm(binary.substring(4, 7), lineNum);
			rs = getRegAsm(binary.substring(7, 10), lineNum);
						
			// get immediate
			imm = getOffsetAsm(binary.substring(10, 16), lineNum);
						
			// compose assembly
			str = LD.name+" "+rd+", "+rs+", "+imm;
			rsm.add(str);
			if(debug) { System.out.println(TAB+str); }
		}
		else if(opcode.contentEquals(ST.opcode)) {
			// ST Rd, Rs, imm6
			// <oooo><ddd><sss><iii iii>
			// extract registers
			rd = getRegAsm(binary.substring(4, 7), lineNum);
			rs = getRegAsm(binary.substring(7, 10), lineNum);
						
			// get immediate
			imm = getOffsetAsm(binary.substring(10, 16), lineNum);
						
			// compose assembly
			str = ST.name+" "+rd+", "+rs+", "+imm;
			rsm.add(str);
			if(debug) { System.out.println(TAB+str); }
		}
		// SPECIAL /////////////////////////////////////////////////////////
		else if(opcode.contentEquals(LDC.opcode)) {
			// LDC Rd
			// <oooo><ddd><xxx xxx xxx>
			// extract register
			rd = getRegAsm(binary.substring(4, 7), lineNum);
						
			// compose assembly
			str = LDC.name+" "+rd;
			rsm.add(str);
			if(debug) { System.out.println(TAB+str); }
		}
		else if(opcode.contentEquals(NOP.opcode)) {
			// NOP
			// <oooo><xxx xxx xxx xxx>				
			// compose assembly
			str = NOP.name;
			rsm.add(str);
			if(debug) { System.out.println(TAB+str); }
		}
		else if(opcode.contentEquals(HALT.opcode)) {
			// HALT
			// <oooo><xxx xxx xxx xxx>				
			// compose assembly
			str = HALT.name;
			rsm.add(str);
			if(debug) { System.out.println(TAB+str); }
		}
		// ELSE ////////////////////////////////////////////////////////////
		else { // unrecognized line
			str = "???";
			rsm.add(str);
			if(debug) { System.out.println(TAB+str); }
		}
		
		return;
	}
	
	/*
	 * Converts the given decimal integer value into binary.
	 * 	- val - convert this number to binary
	 *  - length - number of bits to represent val (if val is too big print error message and exits)
	 *  - lineNum - location in file where conversion is taking place
	 */
	public static String decimalToBinary(int val, int length, int lineNum) {
		int q; // quotient
		int r; // remainder
		int d; // dividend
		int cin; // carry in
		String str = ""; // binary string
		String negStr = "";
		boolean negative = false; // true if we are converting a negative number
		
		// check for negativity
		// negative numbers should be converted to binary as if they were 
		// positive and then switched back to negative in two's comp
		if(val < 0) {
			negative = true;
			val = val * -1;
		}
		
		// we convert to binary using long division method
		q = val; // initial q value to start us off
		for(int i = 0; i < length; ++i) {
			if(q == 0) { // value has already been fully represented? pad with zeros
				str = "0"+str;
				continue;
			}
			d = q; // new dividend is quotient from last round
			q = d/2;
			r = d%2;
			str = r+""+str; // append next digit
		}
		
		// check that val was fully represented
		if(q != 0) {
			System.out.printf("%d: Bad integer. Can't represent %d in %d bits.\n", lineNum, val, length);
			System.exit(0);
		}
		
		// resolve negativity
		// negate using two's comp
		if(negative) {
			// bitwise invert
			str = str.replaceAll("1", "X");
			str = str.replaceAll("0", "1");
			str = str.replaceAll("X", "0");
			
			// add 1
			cin = 1;
			negStr = "";
			for(int i = length-1; i >= 0; --i) {
				if(str.charAt(i) == '1' && cin == 1) { // 1+1, must carry to next digit
					negStr = "0"+negStr;
					cin = 1;
					if(i == 0) { // carry on last digit? conversion fails
						System.out.printf("%d: Bad integer. Can't represent %d in %d bits.\n", lineNum, val, length);
						System.exit(0);
					}
				}
				else if(str.charAt(i) == '0' && cin == 1) { // 0+1, no carry required 
					negStr = "1"+negStr;
					cin = 0;
				}
				else { // carry in is 0 so just keep remaining bits
					negStr = str.charAt(i)+negStr;
					cin = 0;
				}
			}
			str = negStr;
		}
		
		// conversion is good
		return str;
	}
	
	/*
	 * Converts the given binary integer value into decimal.
	 * 	- val - convert this number to decimal
	 *  - lineNum - location in file where conversion is taking place
	 */
	public static int binaryToDecimal(String val, int lineNum) {
		int cin = 0; // carry in
		int literal = 0; // decimal value to return
		int bit = 0;
		int bitIndex = 0;
		String negStr = "";
		boolean negative = false; // true if we are converting a negative number
		
		// check for negativity
		// negative numbers should be converted to decimal as if they were 
		// positive and then switched back to negative
		if(val.charAt(0) == '1') {
			negative = true;
			
			// bitwise invert
			val = val.replaceAll("1", "X");
			val = val.replaceAll("0", "1");
			val = val.replaceAll("X", "0");
						
			// add 1
			cin = 1;
			negStr = "";
			for(int i = val.length()-1; i >= 0; --i) {
				if(val.charAt(i) == '1' && cin == 1) { // 1+1, must carry to next digit
					negStr = "0"+negStr;
					cin = 1;
				}
				else if(val.charAt(i) == '0' && cin == 1) { // 0+1, no carry required 
					negStr = "1"+negStr;
					cin = 0;
				}
				else { // carry in is 0 so just keep remaining bits
					negStr = val.charAt(i)+negStr;
					cin = 0;
				}
			}
			val = negStr;
		}
		
		// we convert to decimal using exponents
		for(int i = 0; i < val.length(); ++i) {
			bitIndex = val.length()-1-i; // inverse or char index
			if(val.charAt(i) == '1') {
				bit = 1;
			}
			else if(val.charAt(i) == '0') {
				bit = 0;
			}
			else {
				System.out.printf("%d: Could not convert %s to decimal.", lineNum, val);
				System.exit(0);
			}
			
			literal += bit*Math.pow(2, bitIndex);
		}
		
		// resolve negativity
		if(negative) {
			literal *= -1;
		}
		
		// conversion is good
		return literal;
	}
	
	public static String binaryToHex(String binary) {
		String hex = "";
		String quarter = "";
		String digit = "";
		
		for(int i = 0; i < 16; i+=4) {
			quarter = binary.substring(i, i+4);
			digit = "X";
			if(quarter.contentEquals("0000")) {
				digit = "0";
			}
			else if(quarter.contentEquals("0001")) {
				digit = "1";
			}
			else if(quarter.contentEquals("0010")) {
				digit = "2";
			}
			else if(quarter.contentEquals("0011")) {
				digit = "3";
			}
			else if(quarter.contentEquals("0100")) {
				digit = "4";
			}
			else if(quarter.contentEquals("0101")) {
				digit = "5";
			}
			else if(quarter.contentEquals("0110")) {
				digit = "6";
			}
			else if(quarter.contentEquals("0111")) {
				digit = "7";
			}
			else if(quarter.contentEquals("1000")) {
				digit = "8";
			}
			else if(quarter.contentEquals("1001")) {
				digit = "9";
			}
			else if(quarter.contentEquals("1010")) {
				digit = "A";
			}
			else if(quarter.contentEquals("1011")) {
				digit = "B";
			}
			else if(quarter.contentEquals("1100")) {
				digit = "C";
			}
			else if(quarter.contentEquals("1101")) {
				digit = "D";
			}
			else if(quarter.contentEquals("1110")) {
				digit = "E";
			}
			else if(quarter.contentEquals("1111")) {
				digit = "F";
			}
			else {
				System.out.println("SYSTEM FAILURE. Translation missing: "+quarter);
				System.exit(0);
			}
			
			hex += digit;
		}
		
		if(debug) {
			System.out.println("Translating "+binary);
			System.out.println(TAB+hex);
		}
		
		return hex;
	}
}
