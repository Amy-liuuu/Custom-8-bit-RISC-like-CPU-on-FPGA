def string_to_binary_file(input_string, output_file):
    # Convert each character in the string to its binary representation
    binary_lines = [format(ord(char), '08b') for char in input_string]

    # Write the binary lines to the specified output file
    with open(output_file, 'w') as f:
        f.write('\n'.join(binary_lines))

# Example usage
input_string = r"Hello World**VLSI 8-bit CPU**===================**"
output_file = "output.txt"

string_to_binary_file(input_string, output_file)
print(f"Binary representation of '{input_string}' written to {output_file}.")
