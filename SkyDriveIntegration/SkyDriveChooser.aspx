<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SkyDriveChooser.aspx.cs" Inherits="SkyDriveIntegration.SkyDriveChooser" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="//js.live.net/v5.0/wl.js"></script>
    <script type="text/javascript">
        WL.init({ client_id: '000000004C0F3108', redirect_uri: "http://skydriveintegration.apphb.com/SkyDriveFileOpen.aspx" });
        WL.ui({
            name: "skydrivepicker",
            element: "skydrivechooser",
            mode: "open",
            select: "multi",
            onselected: onDownloadFileCompleted,
            onerror: onUploadFileError
        });
        function onDownloadFileCompleted(response) {
            var msg = "";
            // For each folder selected...
            if (response.data.folders.length > 0) {
                for (folder = 0; folder < response.data.folders.length; folder++) {
                    // Use folder IDs to iterate through child folders and files as needed.
                    msg += "\n" + response.data.folders[folder].id;
                }
            }
            // For each file selected...
            if (response.data.files.length > 0) {
                for (file = 0; file < response.data.files.length; file++) {
                    // Use file IDs to iterate through files as needed.
                    msg += "\n" + response.data.files[file].id;
                }
            }
            document.getElementById("info").innerText =
                "Selected folders/files:" + msg;
        };

        function onUploadFileError(response) {
            document.getElementById("info").innerText =
                "Error getting folder info: " + response.error.message;
            alert(response.error.message);
        }
    </script>
</head>
<body>
    <form runat="server">
        <div id="skydrivechooser">
        </div>
        <div id="info">
        </div>
    </form>
</body>
</html>