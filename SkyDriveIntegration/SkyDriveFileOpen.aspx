<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SkyDriveFileOpen.aspx.cs" Inherits="SkyDriveIntegration.SkyDriveFileOpen" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="//js.live.net/v5.0/wl.js"></script>
    <script type="text/javascript">
        WL.init({ client_id: '000000004C0F3108', redirect_uri: "http://skydriveintegration.apphb.com/SkyDriveChooser.aspx" });
        function uploadFile_fileDialog() {
            WL.fileDialog({
                mode: "open",
                select: "multi",
            }).then(
                function (response) {
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
                    alert(msg);
                },
                function (responseFailed) {
                    document.getElementById("info").innerText =
                        "Error getting folder info: " + responseFailed.error.message;
                }
            );
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div onclick="uploadFile_fileDialog();">skydrive </div>
    </form>
</body>
</html>