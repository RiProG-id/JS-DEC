#!/bin/bash
if [ "$1" = "--setup" ]; then
	apt update
	apt upgrade
	apt install git
	apt install nodejs-lts
	apt install pv
	exit 0
fi
git=false
node=false
pv=false
if command -v git >/dev/null 2>&1; then
	git=true
fi
if command -v node >/dev/null 2>&1; then
	node=true
fi
if command -v node >/dev/null 2>&1; then
	pv=true
fi
if [ "$git" = false ] || [ "$node" = false ] || [ "$pv" = false ]; then
	if [ "$git" = false ]; then
		echo "Error: git not found. Run script with --setup to install."
	fi
	if [ "$node" = false ]; then
		echo "Error: nodejs not found. Run script with --setup to install."
	fi
	if [ "$pv" = false ]; then
		echo "Error: pv not found. Run script with --setup to install."
	fi
	exit 1
fi
pattern=false
ulimit -s unlimited >/dev/null 2>&1
echo ""
echo "By RiProG ID"
echo "JS deobfuscator V1.2"
echo "For Vmods"
echo ""
echo "Example:"
echo "Single Input is a file"
echo "/sdcard/in/example.sh"
echo "Multi Input is a directory"
echo "/sdcard/in"
echo ""
printf "Enter the location: "
read -r input
if [ -z "$(find "$input" -maxdepth 1 -type f)" ]; then
	echo "Warning: Input not found."
	exit 1
fi
echo "Setting up environment.."
echo "Please wait..."
exec 3>&1 4>&2
exec >/dev/null 2>&1
rm -rf "$HOME/temp"
ORIG_DIR=$(pwd)
mkdir "$HOME/temp"
cd "$HOME/temp" || exit
git clone https://github.com/0x1Avram/js-deobfuscator
cd "$HOME/temp/js-deobfuscator" || exit
npm pkg set dependencies.prettier="$(npm show prettier version)"
npm install
cd "$ORIG_DIR" || exit
exec 1>&3 2>&4
echo "Complete"
sleep 2
find "$input" -type f -name "*.js" | while IFS= read -r js; do
	SOURCE_FILE="$js"
	SOURCE_NAME=$(basename "$SOURCE_FILE")
	INPUT_FILE="${SOURCE_FILE}.i.js"
	OUTPUT_FILE="${SOURCE_FILE}.o.js"
	dictionary="_0x167de0=>axeron
_0x5bd58a=>stateKey
_0x1dbd85=>stateValue
_0x55456a=>createElement
_0xcd9e53=>dialogContainer
_0x5e274f=>dialogOverlay
_0x560955=>dialogContent
_0x14d31b=>closeButton
_0x36286f=>closeDialog
_0x265c18=>dpiValue
_0x3ad54e=>updateMessage
_0x2a6717=>updateButton
_0x3f1c90=>updateDialog
_0x4d7da4=>updateContainer
_0x500189=>updateContent
_0x742a7f=>messageStyle
_0x28b108=>elementId
_0x1c3974=>spanElement
_0x57f01b=>inputElement
_0x5a8796=>settingsElement
_0x363b39=>index
_0x452b6d=>calibratedValue
_0x30b0c8=>switchKeys
_0x4433dc=>textSettingKeys
_0x8e8001=>styleOptions
_0x47a412=>elementAttributes
_0x428e22=>styleProperty
_0xa8ed32=>styleElement
_0x131b0b=>dialogOverlay
_0x521632=>dialogBox
_0x273d0d=>dialogTitle
_0x4db02c=>dialogDescription
_0x3f08ff=>progressBarContainer
_0xedacbe=>progressBar
_0x4e770d=>downloadButton
_0x69b75a=>progressPercentage
_0xf8b35=>progressInterval
_0x17daba=>tapToClose
_0xf0ca70=>clickEvent
_0x608a81=>axeronConfig
_0x2f1496=>axConstant
_0xe51ed3=>styleLink
_0x8a3271=>requestHeaders
_0x879add=>requestOptions
_0x4f8872=>responseFetch
_0x445138=>responseJson
_0xc29c51=>errorHandler
_0x4c50af=>responseBinaryFetch
_0x3dd9fe=>binaryContent
_0x50bbdf=>errorBinaryFetch
_0x2d1cd7=>versionResponse
_0x5f0c07=>versionText
_0x36c546=>versionString
_0x34457b=>versionError
_0x101665=>currentVersion
_0xa4a46b=>githubUpdateFetch
_0x579892=>githubUpdateJson
_0x138965=>updateDescription
_0x58e09d=>formattedDescription
_0x361032=>githubErrorFetch
_0x2c1753=>vipUserFetch
_0x17179a=>vipUserJson
_0x5c777f=>isVipUser
_0x475722=>userFetchError
_0x1309be=>uiFetchResponse
_0x4100be=>uiResponseJson
_0x1a2293=>uiError
_0x1c839e=>errorFetchingData
_0x5cd1f4=>eventData
_0x4103a4=>toggleChange
_0x12ca24=>updateRequired
_0x2961e0=>updatedMessage
_0x6fb81d=>elementType
_0x29c2dd=>parentElement
_0x195b82=>elementAttributes
_0x1cd8ed=>styleOptions
_0x5f0a4c=>createdElement
_0xad9ce2=>inputField
_0xc33caf=>buttonElement
_0x4f2fef=>createNewElement
_0x5212ef=>tagName
_0x28aa56=>targetParent
_0x1e0e33=>newElement
_0x20a055=>attrName
_0x3354a4=>cssProperty
_0x3a9954=>eventData
_0x163953=>axeronConfig
_0x71fd37=>delayDuration
_0x191e27=>setTimeoutPromise
_0x4290e2=>globalAllData
_0x43152e=>ufcUpdate
_0x4297a9=>updateError
_0x4e82d9=>switchStateValue
_0x4bb657=>hertzValue
_0xb54b97=>memoryConfiguration
_0x1e4cd8=>loadingElement
_0x57c931=>initElement
_0x4437b4=>statusContainer
_0x17ba64=>logoImage
_0x26a933=>switchKey
_0x106327=>switchState
_0x77e7d5=>switchKey
_0x41b97=>checkboxElement
_0x36f819=>userAgent
_0x83394d=>androidVersionMatch
_0x15d7fe=>androidVersion
_0x248b19=>compileSelection
_0x36f285=>hzSelection
_0x344e6a=>downscaleSelection
_0x54668d=>factorSelection
_0x2ab021=>compileSetValue
_0xbde1ff=>hzSetValue
_0x585f8a=>downScaleValue
_0x2b0d70=>factorSetValue
_0x494284=>loadingDialogStyle
_0x3358ad=>axeronConfig
_0x3842a1=>compileSetElement
_0x97e011=>compileSetElementAgain
_0x499aaa=>hzSetElement
_0x44c956=>hzSetElementAgain
_0x364086=>downScaleElement
_0x4ffff4=>downScaleElementAgain
_0x29e9f4=>factorSetElement
_0x32d1f0=>factorSetElementAgain
_0x34971d=>loadingDialogStyleElement
"
	echo "Deobfuscating $SOURCE_NAME..."
	echo "Please wait..."
	exec 3>&1 4>&2
	exec >/dev/null 2>&1
	cp -f "$SOURCE_FILE" "$INPUT_FILE"
	npx prettier --write "$INPUT_FILE"
	node "$HOME/temp/js-deobfuscator/index.js" -i "$INPUT_FILE" -o "$OUTPUT_FILE"
	for replace in $dictionary; do
		pattern="${replace%%=>*}"
		if grep -q "$pattern" "$OUTPUT_FILE"; then
			replacement="${replace##*=>}"
			sed -i -e "s/$pattern/$replacement/g" "$OUTPUT_FILE"
		fi
	done
	npx prettier --write "OUTPUT_FILE"
	exec 1>&3 2>&4
	echo "" >"$OUTPUT_FILE"
	git diff --color -- "$INPUT_FILE" "$OUTPUT_FILE" | stdbuf -oL pv -L 5k | cat
	echo "Complete"
	sleep 2
	mv -f "$OUTPUT_FILE" "$SOURCE_FILE"
	rm -f "$INPUT_FILE"
done
echo "Cleaning up environment..."
rm -rf "$HOME/temp"
echo "Complete"
sleep 2
