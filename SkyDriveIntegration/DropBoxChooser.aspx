<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DropBoxChooser.aspx.cs" Inherits="SkyDriveIntegration.DropBoxChooser" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="https://www.dropbox.com/static/api/1/dropins.js"
        id="dropboxjs" data-app-key="aow0w34qrmxvr39">
    </script>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8/jquery.min.js">
    </script>
    <script src="//js.live.net/v5.0/wl.js"></script>
    <script type="text/javascript">
        WL.init({ client_id: '000000004C0F3108', redirect_uri: "http://skydriveintegration.apphb.com/SkyDriveFileOpen.aspx" });
        function uploadFile_fileDialog() {
            WL.fileDialog({
                mode: "open",
                select: "multi"
            }).then(
                function (response) {
                    var msg = "";
                    // For each file selected...
                    if (response.data.files != undefined && response.data.files.length > 0) {
                        for (var file = 0; file < response.data.files.length; file++) {
                            var rowClone = $('#hidden').clone();
                            rowClone.find('img').attr('src', '');
                            rowClone.find('img').attr('href', '');
                            rowClone.find('.name').html(response.data.files[file].name);
                            rowClone.find('.link').html(response.data.files[file].source);
                            $('#TblFiles tbody').append(rowClone);
                            rowClone.show(500);
                            rowClone.attr('id', '');
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
    <link href="Content/SkyDriveChooser.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">

            <input type="dropbox-chooser" name="selected-file"
                style="visibility: hidden;"
                data-multiselect="True"
                data-link-type="direct"
                id="db-chooser" />
            <br />

            <button id="skydriveopenpickerbutton" title="Choose from SkyDrive" style="direction: ltr; background-color: rgb(255, 255, 255); border: 1px solid rgb(9, 74, 178); height: 20px; padding-left: 4px; padding-right: 4px; text-align: center; cursor: pointer;">
                <img alt="" src="//js.live.net/v5.0/images/SkyDrivePicker/SkyDriveIcon_blue.png" style="vertical-align: middle; height: 16px;"><span style="font-family: 'Segoe UI', 'Segoe UI Web Regular', 'Helvetica Neue', 'BBAlpha Sans', 'S60 Sans', Arial, sans-serif; font-size: 12px; font-weight: bold; color: rgb(9, 74, 178); text-align: center; vertical-align: middle; margin-left: 2px; margin-right: 0px;">Open from SkyDrive</span></button>

            <script type="text/javascript">

                $(function () {
                    $('.RemoveDoc').live('click', function () {
                        $(this).hide(500, function () {
                            $(this).parents('tr').remove();
                        });
                    });
                    var files = '';
                    $('input[type="submit"]').click(function () {
                        $('#TblFiles tbody tr').not('#hidden').each(function () {
                            files += "," + $(this).find('.link').html();
                        });
                        $('input[id$="HdnFiles"]').val(files);
                    });
                });

                document.getElementById("db-chooser").addEventListener("DbxChooserSuccess",
                    function (e) {
                        for (var index = 0; index < e.files.length; index++) {
                            var rowClone = $('#hidden').clone();
                            rowClone.find('img').attr('src', e.files[index].icon);
                            rowClone.find('img').attr('href', e.files[index].icon);
                            rowClone.find('.name').html(e.files[index].name);
                            rowClone.find('.link').html(e.files[index].link);
                            $('#TblFiles tbody').append(rowClone);
                            rowClone.show(500);
                            rowClone.attr('id', '');
                        }
                    }, false);
            </script>

            <table id="TblFiles">
                <thead>
                    <tr>
                        <th>
                            <p>
                                Icon
                            </p>
                        </th>
                        <th>
                            <p>
                                FileName
                            </p>
                        </th>
                        <th>
                            <p>
                                Url
                            </p>
                        </th>
                        <th>
                            <p>
                                Actions
                            </p>
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <tr id="hidden">
                        <td>
                            <img alt="icon" />
                        </td>
                        <td>
                            <div class="name">
                            </div>
                        </td>
                        <td>
                            <div class="link">
                            </div>
                        </td>
                        <td>
                            <a href="#" class="RemoveDoc">Remove</a>
                        </td>
                    </tr>
                </tbody>
            </table>

            <div>
                <asp:Button ID="BtnUpload" runat="server" Text="Upload Files" OnClick="BtnUploadClick" />
                <asp:HiddenField ID="HdnFiles" runat="server" Value="" />
            </div>
        </div>
    </form>
</body>
</html>