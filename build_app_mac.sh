
cd `dirname $0`

cd  ./demo
if [ -e "./node_modules/electron/dist/Electron.app/Contents/Frameworks/HPOfficeCastWork.framework" ];then
echo "file exist"
else
cd ./demo
npm install
npm run-script packager-mac
fi
npm run-script packager-mac
