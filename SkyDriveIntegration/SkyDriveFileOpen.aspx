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
                mode: "Open"
            }).then(
                function (response) {
                    WL.upload({
                        path: response.data.folders[0].id,
                        element: "file",
                        overwrite: "rename"
                    }).then(
                        function (response) {
                            document.getElementById("info").innerText =
                                "File uploaded.";
                        },
                        function (responseFailed) {
                            document.getElementById("info").innerText =
                                "Error uploading file: " + responseFailed.error.message;
                        }
                    );
                },
                function (responseFailed) {
                    document.getElementById("info").innerText =
                        "Error getting folder info: " + responseFailed.error.message;
                }
            );
        }
    </script>
</head>
<body onload="uploadFile_fileDialog();">
    <form id="form1" runat="server">
        <div>
        </div>
    </form>
</body>
</html>