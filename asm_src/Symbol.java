
/*
 * Simply groups relevant details about a symbol. A symbol can either be a macro 
 * or a label.
 */
public class Symbol {
	// static fields
	public static final int LABEL = 0; // code designating a symbol as a label
	public static final int MACRO = 1; // code designating a symbol as a macro
	
	// instance fields
	String name;
	int intVal;
	String machineVal; // 32 bit integer value in binary
	String mv0; // bits 7:0 of machine val
	String mv1; // bits 15:8 of machine val
	String mv2; // bits 23:16 of machine val
	String mv3; // bits 31:24 of machine val
	int type;
	
	
	public Symbol(String name, int value, String machineVal, int type) {
		this.name = name;
		this.intVal = value;
		this.machineVal = machineVal;
		this.mv0 = this.machineVal.substring(0,8);
		this.mv1 = this.machineVal.substring(8,16);
		this.mv2 = this.machineVal.substring(16,24);
		this.mv3 = this.machineVal.substring(24,32);
		this.type = type;
	}
	
	/*
	 * Returns entire 32 bit binary value.
	 */
	public String getVal() {
		return machineVal;
	}
	
	/*
	 * Returns bits [end:start] of binary value.
	 */
	public String getVal(int start, int end) {
		return machineVal.substring(start, end+1);
	}
	
	
	public String toString() {
		return "["+name+": "+intVal+", "+machineVal+"]";
	}

}
