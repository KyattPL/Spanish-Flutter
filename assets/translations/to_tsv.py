# Function to convert verbs list into TSV format, skipping blank lines
def convert_to_tsv(file_path):
    rows = []
    
    # Open the input text file and process line by line
    with open(file_path, "r") as file:
        for line in file:
            line = line.strip()  # Remove leading/trailing whitespace
            if not line:         # Skip empty lines
                continue
            
            # Split the line at '|' to get the word and translation
            if "|" in line:
                word, translation = line.split("|")
                rows.append(f"{word}\t{translation}")
    
    # Join the rows into TSV format
    tsv_output = "\n".join(rows)
    return tsv_output

# Example usage: input file path
input_file = "learning_I_6.txt"
output_file = "spanish_verbs_2.tsv"

# Convert the input file to TSV
tsv_data = convert_to_tsv(input_file)

# Save the TSV output to a file
with open(output_file, "w") as file:
    file.write(tsv_data)

print(f"TSV file '{output_file}' created successfully!")