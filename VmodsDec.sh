#!/bin/bash
PROGRAM=$(realpath "$0")
PROGRAM_DIR=$(dirname "$PROGRAM")
TEST_FILE="$PROGRAM_DIR/TEST_FILE"
touch "$TEST_FILE"
chmod +x "$TEST_FILE" >/dev/null 2>&1
if [ ! -x "$TEST_FILE" ]; then
	echo "No execute permission. Please clone JS-DEC to other directory."
	rm -f "$TEST_FILE"
	exit 0
else
	rm -f "$TEST_FILE"
fi
if [ "$1" = "--setup" ]; then
	echo "Updating package list..."
	sleep 2
	apt update
	echo "Upgrading packages..."
	sleep 2
	apt upgrade -y
	if ! command -v git >/dev/null 2>&1; then
		echo "Installing git..."
		apt install git -y
		sleep 2
	else
		echo "git is already installed, skipping installation."
		sleep 2
	fi
	if ! command -v node >/dev/null 2>&1; then
		echo "Installing Node.js..."
		apt install nodejs-lts -y
		sleep 2
	else
		echo "Node.js is already installed, skipping installation."
		sleep 2
	fi
	if ! command -v pv >/dev/null 2>&1; then
		echo "Installing pv..."
		apt install pv -y
		sleep 2
	else
		echo "pv is already installed, skipping installation."
		sleep 2
	fi
	if [ ! -d "$PROGRAM_DIR/js-deobfuscator" ]; then
		echo "Setting up js-deobfuscator..."
		sleep 2
		ORIG_DIR=$(pwd)
		cd "$PROGRAM_DIR" || exit
		git clone https://github.com/0x1Avram/js-deobfuscator
		cd "$PROGRAM_DIR/js-deobfuscator" || exit
		echo "Setting Prettier dependency version..."
		npm pkg set dependencies.prettier="$(npm show prettier version)"
		echo "Installing dependencies..."
		npm install
		cd "$ORIG_DIR" || exit
		echo "Environment setup complete."
		sleep 2
	else
		echo "js-deobfuscator already set up, skipping."
		sleep 2
	fi
	exit 0
fi
if ! command -v git >/dev/null 2>&1 || ! command -v node >/dev/null 2>&1 || ! command -v pv >/dev/null 2>&1 || [ ! -d "$PROGRAM_DIR/js-deobfuscator" ]; then
	echo "Error: Required resource not installed. Run with --setup."
	sleep 2
	exit 1
fi
echo "By RiProG ID"
echo "JS Deobfuscator V2.0"
sleep 2
echo "Example:"
sleep 2
echo "1. Single JS file: /home/user/scripts/example.js"
sleep 2
echo "2. Directory of JS files: /home/user/scripts"
sleep 2
echo ""
printf "Enter the location: "
read -r input
js_files=$(find "$input" -type f -name "*.js" 2>/dev/null)
if [ -z "$js_files" ]; then
	echo "Warning: No .js files found."
	sleep 2
	exit 1
fi
echo ""
for js in $js_files; do
	SOURCE_FILE="$js"
	SOURCE_NAME=$(basename "$SOURCE_FILE")
	echo "Found: $SOURCE_NAME"
done
sleep 2
while true; do
	printf "Use Prettier? (0 for No, 1 for Yes): "
	read -r use_prettier
	if [ "$use_prettier" -eq 0 ]; then
		use_prettier=false
		break
	elif [ "$use_prettier" -eq 1 ]; then
		use_prettier=true
		break
	else
		echo "Invalid input. Enter 0 or 1."
		sleep 2
	fi
done
while true; do
	printf "Compare original and deobfuscated files? (0 for No, 1 for Yes): "
	read -r compare_files
	if [ "$compare_files" -eq 0 ]; then
		compare_files=false
		break
	elif [ "$compare_files" -eq 1 ]; then
		compare_files=true
		break
	else
		echo "Invalid input. Enter 0 or 1."
		sleep 2
	fi
done
for js in $js_files; do
	SOURCE_FILE="$js"
	SOURCE_NAME=$(basename "$SOURCE_FILE")
	INPUT_FILE="${SOURCE_FILE}.i.js"
	INPUT_NAME=$(basename "$INPUT_FILE")
	OUTPUT_FILE="${SOURCE_FILE}.o.js"
	OUTPUT_NAME=$(basename "$OUTPUT_NAME")
	echo "Deobfuscating $SOURCE_NAME..."
	sleep 2
	echo "Copying $SOURCE_NAME to $INPUT_NAME"
	sleep 2
	cp -f "$SOURCE_FILE" "$INPUT_FILE"
	ORIG_DIR=$(pwd)
	cd "$PROGRAM_DIR/js-deobfuscator/" || exit
	if [ "$use_prettier" = true ]; then
		echo "Formatting $INPUT_NAME with Prettier..."
		sleep 2
		npx prettier --write "$INPUT_NAME"
	fi
	echo "Running deobfuscation on $INPUT_NAME..."
	sleep 2
	node "index.js" -i "$INPUT_FILE" -o "$OUTPUT_FILE"
	echo "Deobfuscation complete. Output: $OUTPUT_NAME."
	sleep 2
	if [ "$use_prettier" = true ]; then
		echo "Formatting output $OUTPUT_NAME with Prettier..."
		sleep 2
		npx prettier --write "$OUTPUT_FILE"
	fi
	cd "$ORIG_DIR" || exit
	if [ "$compare_files" = true ]; then
		echo "Comparing $INPUT_NAME and $OUTPUT_NAME..."
		sleep 2
		git diff --color -- "$INPUT_FILE" "$OUTPUT_FILE" | stdbuf -oL pv -L 5k | cat
		echo "Comparison complete."
	else
		echo "Skipping comparison."
	fi
	echo "Deobfuscation for $SOURCE_NAME complete."
	sleep 2
	echo "Moving $OUTPUT_FILE to $SOURCE_NAME"
	sleep 2
	mv -f "$OUTPUT_FILE" "$SOURCE_FILE"
	echo "Removing intermediate file: $INPUT_NAME"
	sleep 2
	rm -f "$INPUT_FILE"
done
echo "All deobfuscation tasks completed."
sleep 2
