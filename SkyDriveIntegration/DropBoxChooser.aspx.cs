using System;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using HgCo.WindowsLive.SkyDrive;

namespace SkyDriveIntegration
{
    public partial class DropBoxChooser : System.Web.UI.Page
    {
        private const string DropBoxUsername = "santhosh@tillidsoft.com";
        private const string DropBoxPassword = "password@123";

        private const string ClientName = "Client1";
        private const string UserEmail = "santhoshonet@gmaill.com";

        protected void Page_Load(object sender, EventArgs e)
        {
            //string url = "https://m3udpa.sn2.livefilestore.com/y2mI1vPgzTxjYo-eZ1ZW9e8O8H5Km4QNl_O-9YJIz7bqIUncxuN6kWrcpMVBZyiJAzkkE2_ZT77Y-Aosp3xqsAg77Cs3IvuxeUvfx7z5WfCIJ8zRbumNyYQcdhLG_hXTr45/training%20(1).txt?download&psid=1";
            //DownloadFileFromSkyDrive(url);
        }

        protected void BtnUploadClick(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(HdnFiles.Value))
                return;

            // initiating the clietn fisrt
            var client = new SkyDriveServiceClient();

            // log on into drop box using username and password
            client.LogOn(DropBoxUsername, DropBoxPassword);

            // verifying the company folder is available or not
            WebFolderInfo userskyDrivefolder = null;
            WebFolderInfo clientskyDrivefolder = client.ListRootWebFolders().FirstOrDefault(subWebFolder => subWebFolder.Name == ClientName);

            // if the client folder is not found
            if (clientskyDrivefolder == null)
            {
                // create the folder for client first
                clientskyDrivefolder = client.CreateRootWebFolder(ClientName, WebFolderCategoryType.Photos, WebFolderItemShareType.Public);

                // create the user folder
                userskyDrivefolder = client.CreateSubWebFolder(UserEmail, clientskyDrivefolder);
            }
            else
            {
                // verifying whether the user folder is exists or not in the skydrive
                foreach (WebFolderInfo subWebFolder in client.ListSubWebFolders(clientskyDrivefolder))
                {
                    if (subWebFolder.Name == UserEmail)
                    {
                        userskyDrivefolder = subWebFolder;
                        break;
                    }
                }

                // if the client folder is not found
                if (userskyDrivefolder == null)
                    userskyDrivefolder = client.CreateSubWebFolder(UserEmail, clientskyDrivefolder);
            }

            // finally we got user folder, start uploading files
            foreach (string fileUrl in HdnFiles.Value.Split(','))
            {
                if (!string.IsNullOrEmpty(fileUrl))
                {
                    // code to download files from user drop box folder
                    try
                    {
                        var response = client.UploadWebFile(DownloadFile(fileUrl), userskyDrivefolder);
                    }
                    catch (Exception)
                    {
                        var response = client.UploadWebFile(DownloadFileFromSkyDrive(fileUrl), userskyDrivefolder);
                    }
                }
            }
        }

        private string DownloadFile(string fileUrl)
        {
            fileUrl = Server.UrlDecode(fileUrl.Substring(0, fileUrl.IndexOf('?')));
            var tempFile = Path.Combine(Path.GetDirectoryName(Path.GetTempFileName()), Path.GetFileName(fileUrl));

            if (File.Exists(tempFile))
            {
                File.Delete(tempFile);
            }

            var url = new Uri(fileUrl);

            ServicePointManager.ServerCertificateValidationCallback = ((sender, certificate, chain, sslPolicyErrors) => true);
            var cookieJar = new CookieContainer();

            var request = (HttpWebRequest)WebRequest.Create(url);
            request.CookieContainer = cookieJar;
            request.Method = "GET";
            HttpStatusCode responseStatus;

            using (var response = (HttpWebResponse)request.GetResponse())
            {
                responseStatus = response.StatusCode;
                url = request.Address;
            }

            if (responseStatus == HttpStatusCode.OK)
            {
                var urlBuilder = new UriBuilder(url);
                request = (HttpWebRequest)WebRequest.Create(urlBuilder.ToString());
                request.Referer = url.ToString();
                request.CookieContainer = cookieJar;
                request.Method = "POST";
                request.ContentLength = 0;
                request.ContentType = "application/x-www-form-urlencoded";
                using (var response = (HttpWebResponse)request.GetResponse())
                {
                    if (response.StatusCode == HttpStatusCode.OK)
                    {
                        using (Stream responseStream = response.GetResponseStream())
                        {
                            if (responseStream != null)
                            {
                                using (var responseReader = new StreamReader(responseStream))
                                {
                                    using (var streamWriter = new StreamWriter(tempFile))
                                    {
                                        responseReader.BaseStream.CopyTo(streamWriter.BaseStream);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return tempFile;
        }

        private string DownloadFileFromSkyDrive(string fileUrl)
        {
            fileUrl = Server.UrlDecode(fileUrl.Substring(0, fileUrl.IndexOf('?')));
            var tempFile = Path.Combine(Path.GetDirectoryName(Path.GetTempFileName()), Path.GetFileName(fileUrl));

            if (File.Exists(tempFile))
            {
                File.Delete(tempFile);
            }

            var url = new Uri(fileUrl);

            ServicePointManager.ServerCertificateValidationCallback = ((sender, certificate, chain, sslPolicyErrors) => true);

            var request = (HttpWebRequest)WebRequest.Create(url);
            request.Method = WebRequestMethods.Http.Get;
            WebResponse response = request.GetResponse();

            using (var responseStream = response.GetResponseStream())
            {
                using (var streamWriter = new StreamWriter(tempFile))
                {
                    if (responseStream != null) responseStream.CopyTo(streamWriter.BaseStream);
                }
            }

            return tempFile;
        }
    }
}