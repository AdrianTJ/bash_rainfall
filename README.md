### Tiny Rain Simulator

**Description:**
This Bash script simulates the a rain effect, where characters fall down the screen, creating a nice display.

**Usage:**
1. **Save the script:** Copy the provided code and save it as a `.sh` file (e.g., `rain.sh`).
2. **Make it executable:** Open a terminal and navigate to the directory where you saved the script. Use the following command to make it executable (the following should work for UNIX based systems):
   ```bash
   chmod +x rain.sh
   ```
3. **Run the script:** Execute the script using:
   ```bash
   ./rain.sh
   ```
   The script will start displaying the matrix rain effect.

**Customization:**
- **Rain speed:** Adjust the sleep time in the script (currently set to 0.05 seconds) to control the speed of the falling characters. A smaller value will result in faster rain.
- **Character set:** Modify the `if` condition within the loop to include different characters or symbols. For example, you could add numbers, special characters, or even a custom set of characters.

**Note:** This script is designed for terminal environments and may not display correctly in other contexts.
