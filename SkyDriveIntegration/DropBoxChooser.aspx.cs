using System;
using HgCo.WindowsLive.SkyDrive;

namespace SkyDriveIntegration
{
    public partial class DropBoxChooser : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //const string folderName = "Folder4";

            var client = new SkyDriveServiceClient();

            client.LogOn("santhosh@tillidsoft.com", "password@123");

            //var info = client.CreateRootWebFolder(folderName, WebFolderCategoryType.Photos,WebFolderItemShareType.Public);

            //foreach (WebFolderInfo subWebFolder in client.ListRootWebFolders())
            //{
            //    if (subWebFolder.Name == folderName)
            //    {
            //        var fileInfo = client.UploadWebFile(@"C:\Users\Santhosh.TILLID\Desktop\speed_up_software_development.jpg",subWebFolder);

            //        var url = "https://skydrive.live.com/?cid=" + fileInfo.OwnerCid + "&id=" + fileInfo.ResourceId;
            //    }
            //}

            //var webDriveInfo =  client.GetWebDriveInfo();

            //var accountInfo =  client.GetWebAccountInfo();
        }
    }
}