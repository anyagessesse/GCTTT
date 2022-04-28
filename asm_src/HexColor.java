
public class HexColor {
	// constants
	private static final String HEX_COLOR = "5f8f57";
	
	/*
	 * Converts the given 32 bit binary string to a decimal integer.
	 */
	public static int binaryToDecimal(String bin) {
		int cin = 0; // carry in
		int dec = 0; // decimal value to return
		int bit = 0;
		String binInv = ""; // binary string inverted
		boolean negative = false; // true if we are converting a negative number
		
		// check for negativity
		// negative numbers should be converted to a positive binary number and 
		// then switched back to negative in decimal
		if(bin.charAt(31) == '1') {
			negative = true;
			
			// bitwise invert
			bin = bin.replaceAll("1", "X");
			bin = bin.replaceAll("0", "1");
			bin = bin.replaceAll("X", "0");
						
			// add 1
			cin = 1;
			binInv = "";
			for(int i = 0; i < 32; ++i) {
				if(bin.charAt(i) == '1' && cin == 1) { // 1+1, must carry to next digit
					binInv = binInv+"0";
					cin = 1;
				}
				else if(bin.charAt(i) == '0' && cin == 1) { // 0+1, no carry required 
					binInv = binInv+"1";
					cin = 0;
				}
				else { // carry in is 0 so just keep remaining bits
					binInv = binInv+bin.charAt(i);
					cin = 0;
				}
			}
			bin = binInv;
		}
		
		// we convert to decimal using exponents
		for(int i = 0; i < 32; ++i) {
			if(bin.charAt(i) == '1') {
				bit = 1;
			}
			else if(bin.charAt(i) == '0') {
				bit = 0;
			}
			else {
				System.out.printf("SYSTEM FAILURE! Unrecognized char in binary string %d.", bin);
				System.exit(0);
			}
			
			dec += bit*Math.pow(2, i);
		}
		
		// resolve negativity
		if(negative) {
			dec *= -1;
		}
		
		// conversion is good
		return dec;
	}
	
	/*
	 * Swaps the first char in the string with last one, swaps the second char
	 * in the string with the second to last one, ...
	 */
	private static String mirror(String str) {
		String mir = "";
		for(int i = 0; i < str.length(); ++i) {
			mir = str.charAt(i) + mir;
		}
		return mir;
	}

	public static void main(String[] args) {
		String hex = HEX_COLOR;
		String bin = "";
		String rBin = "";
		String gBin = "";
		String bBin = "";
		
		// format the hex color to just digits
		hex = hex.trim();
		hex = hex.replaceAll("#", "");
		hex = hex.toUpperCase();
		
		// quick sanity check on hex color
		if(hex.length() != 6) {
			System.out.println("Hex colors must be exactly 6 digits: "+hex);
			System.exit(0);
		}
		
		// convert hex to binary
		for(int i = 0; i < hex.length(); ++i) {
			switch(hex.charAt(i)) {
				case '0': bin += "0000"; break;
				case '1': bin += "0001"; break;
				case '2': bin += "0010"; break;
				case '3': bin += "0011"; break;
				case '4': bin += "0100"; break;
				case '5': bin += "0101"; break;
				case '6': bin += "0110"; break;
				case '7': bin += "0111"; break;
				case '8': bin += "1000"; break;
				case '9': bin += "1001"; break;
				case 'A': bin += "1010"; break;
				case 'B': bin += "1011"; break;
				case 'C': bin += "1100"; break;
				case 'D': bin += "1101"; break;
				case 'E': bin += "1110"; break;
				case 'F': bin += "1111"; break;
				default:
					System.out.println("Invalid hex color: "+hex);
					System.exit(0);
					break;
			}
		}
		
		// extract r, g, and b in binary
		rBin = mirror(bin.substring(0, 8));
		gBin = mirror(bin.substring(8, 16));
		bBin = mirror(bin.substring(16, 24));
		//System.out.printf("r = %s, g = %s, b = %s\n", rBin, gBin, bBin);
		
		// rebuild binary in 32 bit format expected by the processor
		bin = bBin + "00" + gBin + "00" + rBin + "0000";
		//System.out.println(bin);
		
		// convert binary to decimal and report result
		System.out.println(binaryToDecimal(bin));

	}

}
