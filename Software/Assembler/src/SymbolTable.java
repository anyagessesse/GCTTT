import java.util.Hashtable;

/*
 * A symbol table is used to store macros and labels.
 */
public class SymbolTable {
	// static fields
	
	// instance fields
	private int size;
	private Hashtable<String, Symbol> table;

	// create empty symbol table
	public SymbolTable() {
		this.size = 0;
		this.table = new Hashtable();
	}
	
	public int size() {
		return this.size;
	}
	
	public void add(String name, int value, int type) {
		return; // TODO
	}
	
	public int get(String name) {
		return 0; // TODO
	}
	
	public boolean remove(String name) {
		return false; // TODO
	}
	
	/*
	 * Returns each entry to the hash table on its own line.
	 */
	public String toString() {
		return ""; // TODO - START HERE
	}
}
