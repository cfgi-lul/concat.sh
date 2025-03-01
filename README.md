# concat.sh

`concat.sh` is a bash script that allows you to concatenate text files from a directory into a single output file. It provides several options to control the inclusion and exclusion of files, line filtering, and output file management.

## Features

- Concatenate all text files from a directory into a single output file.
- Exclude specific files or directories from being processed.
- Skip empty files during the concatenation process.
- Filter lines in the files using a regular expression pattern.
- Easily specify the input directory and output file.

## Installation

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/yourusername/concat.sh.git
   ```

2. Navigate to the directory:

   ```bash
   cd concat.sh
   ```

3. Make the script executable:

   ```bash
   chmod +x concat.sh
   ```

## Usage

```bash
./concat.sh [OPTIONS]
```

### Options:

- `-i, --input DIR`  
  Specify the input directory (default: current directory).

- `-o, --output FILE`  
  Specify the output file (default: `res.txt` in the current directory).

- `-s, --skipEmpty`  
  Skip empty files after processing.

- `-e, --exclude DIR`  
  Exclude specified directories or files (can be used multiple times).

- `-er, --excludeRegex REGEX`  
  Exclude lines matching the given regex pattern.

- `-h, --help`  
  Show this help message and exit.

### Examples:

1. **Concatenate files, excluding empty files, directories, and using regex:**

   ```bash
   ./concat.sh -i ./somePath -o output.txt -s -e ./dist ./node_modules -er '^import .*;'
   ```

   This will concatenate all files in `somePath`, excluding empty files, `dist`, and `node_modules`, removing lines starting with `import`, and write the output to `output.txt`.

2. **Concatenate files from a log directory, skipping empty files and removing lines containing "DEBUG":**

   ```bash
   ./concat.sh -i ./logs -s -er 'DEBUG'
   ```

   This will concatenate all files in the `logs` directory, skip empty files, and remove lines containing the string "DEBUG".

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.
