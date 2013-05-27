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
            <script type="text/javascript">

                $(function()
                {
                    $('.RemoveDoc').live('click', function () {
                        $(this).hide(500, function() {
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
