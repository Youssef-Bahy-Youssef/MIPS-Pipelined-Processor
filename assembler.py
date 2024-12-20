# Example usage
OPCODES = {
    "NOP": "00000",
    "HLT": "00010",
    "SETC": "00011",
    "NOT": "00100",
    "INC": "00101",
    "OUT": "00110",
    "IN": "00111",
    "MOV": "01000",
    "ADD": "01001",
    "SUB": "01010",
    "AND": "01011",
    "IADD": "01100",
    "PUSH": "01101",
    "POP": "10000",
    "LDM": "10001",
    "LDD": "10010",
    "STD": "10011",
    "JZ": "11000",
    "JN": "11001",
    "JC": "11010",
    "JMP": "11011",
    "CALL": "11100",
    "RET": "11110",
    "INT": "11101",
    "RTI": "11111",

    ".ORG": "00000",
}

REGISTER_CODES = {
    "R0": "000",
    "R1": "001",
    "R2": "010",
    "R3": "011",
    "R4": "100",
    "R5": "101",
    "R6": "110",
    "R7": "111",
}

def assemble_instruction(instruction):
  """Convert a single assembly instruction to machine code."""
  parts = instruction.strip().split()
  if not parts:
      return None

  mnemonic = parts[0].upper()
  operands = parts[1:] if len(parts) > 1 else []

  imm_instructions = ["IADD", "LDM", "LDD", "STD"]

  opcode = OPCODES[mnemonic]
  Rsrc1 = "000"
  Rsrc2 = "000"
  Rdst  = "000"
  immediate = "0000000000000000"
  index = "0000000000"
  useImmediate = mnemonic in imm_instructions
  start_address = "0000000000000000"

  match mnemonic:
      case "NOP" | "HLT" | "SETC":
          pass

      case "NOT" | "INC" | "MOV":
          if len(operands) != 2:
              raise ValueError("NOT requires 2 operands: destination and source")
          Rdst = REGISTER_CODES[operands[0][:-1].upper()]
          Rsrc1 = REGISTER_CODES[operands[1].upper()]

      case "OUT":
          if len(operands) != 1:
              raise ValueError("OUT requires 1 operand: source register")
          Rsrc1 = REGISTER_CODES[operands[0].upper()]

      case "IN":
          if len(operands) != 1:
              raise ValueError("IN requires 1 operand: destination register")
          Rdst = REGISTER_CODES[operands[0].upper()]

      case "ADD" | "SUB" | "AND":
          if len(operands) != 3:
              raise ValueError("ADD requires 3 operands: destination, source1, source2")
          Rdst = REGISTER_CODES[operands[0][:-1].upper()]
          Rsrc1 = REGISTER_CODES[operands[1][:-1].upper()]
          Rsrc2 = REGISTER_CODES[operands[2].upper()]

      case "IADD":
          if len(operands) != 3:
              raise ValueError("IADD requires 3 operands: destination, source, immediate")
          Rdst = REGISTER_CODES[operands[0][:-1].upper()]
          Rsrc1 = REGISTER_CODES[operands[1][:-1].upper()]
          immediate = format(int(operands[2]), "016b")  # Convert immediate to 16-bit binary
          print("immediate", immediate)
      case "PUSH":
          if len(operands) != 1:
              raise ValueError("PUSH requires 1 operand: source register")
          Rsrc2 = REGISTER_CODES[operands[0].upper()]

      case "POP":
          if len(operands) != 1:
              raise ValueError("POP requires 1 operand: destination register")
          Rdst = REGISTER_CODES[operands[0].upper()]

      # LDM (Load Immediate)
      case "LDM":
          if len(operands) != 2:
              raise ValueError("LDM requires 2 operands: destination register and immediate value")
          Rdst = REGISTER_CODES[operands[0][:-1].upper()]
          immediate = format(int(operands[1]), "016b")  # Convert immediate to 16-bit binary

      # LDD (Load from Memory with immediate)
      case "LDD":
          if len(operands) != 2:
              raise ValueError("LDD requires 2 operands: destination register and immediate(source register)")
          Rdst = REGISTER_CODES[operands[0][:-1].upper()]
          immediate, base  = operands[1].split('(')  # Extract base register and immediate
          Rsrc1 = REGISTER_CODES[base[:-1].upper()]
          immediate = format(int(immediate[:-1]), "010b")  # Convert immediate to 10-bit binary

      # STD (Store to Memory with immediate)
      case "STD":
          if len(operands) != 2:
              raise ValueError("STD requires 2 operands: source register and immediate(destination register)")
          Rsrc2 = REGISTER_CODES[operands[0][:-1].upper()]
          immediate, base = operands[1].split('(')  # Extract base register and immediate
          Rsrc1 = REGISTER_CODES[base[:-1].upper()]
          immediate = format(int(immediate[:-1]), "016b")  # Convert immediate to 16-bit binary

      case "JZ" | "JN" | "JC" | "JMP" |  "CALL":
          if len(operands) != 1:
              raise ValueError("JZ requires 1 operand: destination address")
          Rsrc1 = REGISTER_CODES[operands[0].upper()]

      case "RET":
        pass

      case "INT":
          if len(operands) != 1:
              raise ValueError("INT requires 1 operand: interrupt vector")
          index = format(int(operands[0]), "010b")  # Convert vector to 10-bit binary

      case "RTI":
          pass
      
      case ".ORG":
          if len(operands) != 1:
              raise ValueError(".ORG requires 1 operand: interrupt vector")
          start_address = int(operands[0])
      # Default case
      case _:
          raise ValueError(f"Unknown instruction: {mnemonic}")


  if mnemonic == "INT":
    machine_code = opcode + index + "0"
  elif mnemonic == "RTI":
    machine_code = opcode + "00_0000_0000" + "1"
  elif mnemonic == ".ORG":
    machine_code = "0000000000000000" # NOP
    
  else:
    machine_code = opcode +  Rsrc1 + Rsrc2 + Rdst + "00"

  return machine_code, immediate, useImmediate, start_address, mnemonic


def assemble_file(input_file, output_file):
    """Assemble a text file of instructions into machine code."""
    with open(input_file, "r") as infile, open(output_file, "w") as outfile:  # Open for appending
        # Predefined values for the first 8 addresses
        predefined_values = {
            0: "0000000000000000",  # Example predefined value for IM[0]
            1: "0000000000000001",  # Example predefined value for IM[1]
            2: "0000000000000010",  # Example predefined value for IM[2]
            3: "0000000000000011",  # Example predefined value for IM[3]
            4: "0000000000000100",  # Example predefined value for IM[4]
            5: "0000000000000101",  # Example predefined value for IM[5]
            6: "0000000000000110",  # Example predefined value for IM[6]
            7: "0000000000000111",  # Example predefined value for IM[7]
            8: "0000000000001000",  # Example predefined value for IM[8]
        }

        # First loop to write the predefined values for IM[0] to IM[8]
        for addr in range(8+1):  # For addresses 0 to 7
            if addr in predefined_values:
                outfile.write(predefined_values[addr] + "\n")

        # Now assemble the remaining instructions starting from the next address
        i = 10  # Start from address 8

        for line in infile:
            if not line.strip() or line.startswith(";"):
                continue  # Skip empty lines and comments
            try:
                machine_code, immediate, useImmediate, start_address, mnemonic  = assemble_instruction(line)
                if machine_code:
                    outfile.write(machine_code + "\n")

                if useImmediate:
                    outfile.write(immediate + "\n")

                if mnemonic == ".ORG":
                    for j in range(i+1, start_address):
                        outfile.write(machine_code + "\n")
            except ValueError as e:
                print(f"Error assembling line: {line.strip()}")
                print(e)
            i = i + 1


if __name__ == "__main__":
    input_file = "program.asm"  # Input assembly file
    output_file = "program.mc"  # Output machine code file
    assemble_file(input_file, output_file)
    print(f"Assembly completed. Machine code written to {output_file}.")