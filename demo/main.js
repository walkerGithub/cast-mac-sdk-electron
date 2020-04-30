const { app, BrowserWindow } = require('electron');

let mainWindow = null;

function showMainwindow(){
  if (!mainWindow)
  {
    mainWindow = new BrowserWindow({
      width: 1000,
      height: 400,
      webPreferences: {
        nodeIntegration: true
      } 
    });
    mainWindow.webContents.openDevTools()

    mainWindow.loadURL('file://' + __dirname + '/index.html');
  }
}

app.on('activate', function () {
  if (mainWindow === null) {
    createWindow()
  }
})

function createWindow () {
  // Create the browser window.
  showMainwindow();
}

app.on('ready', createWindow)
