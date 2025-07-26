namespace Server.Source.Data
{
    public class BaseResponse
    {
        public bool success;
        public string message;

        public BaseResponse()
        {
            success = true;
            message = "";

        }
    }
}
