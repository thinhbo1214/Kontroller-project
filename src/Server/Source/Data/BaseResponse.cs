namespace Server.Source.Data
{
    public class BaseResponse
    {
        public bool Success { get; set; }
        public string Message { get; set; }

        public BaseResponse()
        {
            Success = true;
            Message = "";

        }
    }
}
