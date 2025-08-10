using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;

try
{
    string loginUrl = "https://localhost:2000/api/auth/login";
    string uploadUrl = "https://localhost:2000/api/user/avatar";
    string filePath = @"D:\MySpace\Project\Kontroller-project\src\Server\bin\Debug\net9.0-windows\extra_files\www\FE_CleanDesign\avatar\robot.jpg";

    var handler = new HttpClientHandler();
    handler.ServerCertificateCustomValidationCallback = (message, cert, chain, errors) => true;

    using var client = new HttpClient(handler);

    // --- Bước 1: Đăng nhập ---
    var loginData = new
    {
        username = "admin",
        password = "Admin@123"
    };

    string loginJson = JsonSerializer.Serialize(loginData);
    var loginContent = new StringContent(loginJson, Encoding.UTF8, "application/json");

    var loginResponse = await client.PostAsync(loginUrl, loginContent);
    loginResponse.EnsureSuccessStatusCode();

    string loginBody = await loginResponse.Content.ReadAsStringAsync();
    Console.WriteLine("Login Response Body:");
    Console.WriteLine(loginBody);

    Console.WriteLine("Response Headers:");
    foreach (var header in loginResponse.Headers)
    {
        Console.WriteLine($"{header.Key}: {string.Join(", ", header.Value)}");
    }

    if (!loginResponse.Headers.TryGetValues("X_Token_Authorization", out var tokenHeaders))
    {
        Console.WriteLine("Không tìm thấy token trong header trả về.");
        return;
    }

    string token = string.Empty;
    foreach (var t in tokenHeaders)
    {
        token = t;
        break;
    }

    Console.WriteLine($"Token nhận được: {token}");

    // --- Bước 2: Gửi ảnh kèm token ---

    if (!File.Exists(filePath))
    {
        Console.WriteLine($"File không tồn tại: {filePath}");
        return;
    }

    FileInfo fileInfo = new FileInfo(filePath);
    Console.WriteLine($"Kích thước file gốc: {fileInfo.Length} bytes");

    using var fileStream = File.OpenRead(filePath);
    using var content = new MultipartFormDataContent();

    var fileContent = new StreamContent(fileStream);
    fileContent.Headers.ContentType = new MediaTypeHeaderValue("image/jpeg");
    content.Add(fileContent, "avatar", Path.GetFileName(filePath));

    // In kích thước nội dung multipart (ước lượng)
    var ms = new System.IO.MemoryStream();
    await content.CopyToAsync(ms);
    Console.WriteLine($"Kích thước nội dung multipart trước khi gửi: {ms.Length} bytes");

    client.DefaultRequestHeaders.Clear();
    client.DefaultRequestHeaders.Add("X_Token_Authorization", token);

    Console.WriteLine("Upload Request Headers:");
    foreach (var header in client.DefaultRequestHeaders)
    {
        Console.WriteLine($"{header.Key}: {string.Join(", ", header.Value)}");
    }

    Console.WriteLine($"Upload URL: {uploadUrl}");
    Console.WriteLine($"Upload Content Headers:");
    foreach (var header in content.Headers)
    {
        Console.WriteLine($"{header.Key}: {string.Join(", ", header.Value)}");
    }

    var uploadResponse = await client.PutAsync(uploadUrl, content);

    Console.WriteLine($"Upload Status Code: {uploadResponse.StatusCode}");

    string responseBody = await uploadResponse.Content.ReadAsStringAsync();
    Console.WriteLine($"Upload Response: {responseBody}");

    Console.WriteLine("Upload Response Headers:");
    foreach (var header in uploadResponse.Headers)
    {
        Console.WriteLine($"{header.Key}: {string.Join(", ", header.Value)}");
    }
}
catch (HttpRequestException ex)
{
    Console.WriteLine($"HTTP Error: {ex.Message}");
    if (ex.InnerException != null)
        Console.WriteLine($"Inner Exception: {ex.InnerException.Message}");
}
catch (Exception ex)
{
    Console.WriteLine($"Unexpected Error: {ex.Message}");
    Console.WriteLine(ex.StackTrace);
}
finally
{
    Console.WriteLine("Press any key to exit...");
    Console.ReadKey();
}
