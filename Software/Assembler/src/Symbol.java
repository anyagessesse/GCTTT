
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
	String machineVal; // integer value in binary
	int type;
	
	
	public Symbol(String name, int value, int type) {
		this.name = name;
		this.intVal = value;
		this.machineVal = toBinary(value);
		this.type = type;
	}
	
	/*
	 * Converts the given integer value into binary.
	 */
	private static String toBinary(int val) {
		return "0";
	}
	
	public String toString() {
		return "["+name+": "+intVal+", "+machineVal+"]";
	}

}
