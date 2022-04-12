import java.util.Hashtable;
import java.util.Set;
import java.util.Map.Entry;

/*
 * A symbol table is used to store macros and labels.
 */
public class SymbolTable {
	// static fields
	private static final String TAB = "    ";
	
	// instance fields
	private int size;
	private Hashtable<String, Symbol> table;

	// create empty symbol table
	public SymbolTable() {
		this.size = 0;
		this.table = new Hashtable<String, Symbol>();
	}
	
	public int size() {
		return this.size;
	}
	
	public void add(String name, int value, String machineVal, int type, int lineNum) {
		// don't allow multiple symbols of the same name
		if(table.containsKey(name)) {
			System.out.printf("%d: Macro (%s) was already defined somewhere else.\n", lineNum, name);
			System.exit(0);
		}
		table.put(name, new Symbol(name, value, machineVal, type));
		++size;
		return; 
	}
	
	/*
	 * Returns the 32 bit machine value associated with the given symbol or null 
	 * if symbol is not present in table. 
	 */
	public String get(String name) {
		Symbol sym = table.get(name);
		if(sym == null) {
			return null;
		}
		else {
			return sym.machineVal;
		}
	}
	
	public boolean remove(String name) {
		return false; // TODO
	}
	
	/*
	 * Returns string representation of symbol table with each entry to the hash
	 * table on its own line.
	 */
	public String toString() {
		Set<Entry<String, Symbol>> entries = table.entrySet();
		String str = "Symbol Table: begin\n";
		
		for(Entry<String, Symbol> entry : entries) {
			str += TAB + entry.getValue().toString()+"\n";
		}
		str += "end\n";
		
		return str;
	}
}
