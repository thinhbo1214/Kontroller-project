using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Server.Source.Extra
{
    public class DeleteRequestBase
    {
        public string UserId { get; set; }
    }

    public class DeleteAccountRequest : DeleteRequestBase
    {
        public string Password { get; set; }
    }

    public class DeleteTargetRequest : DeleteRequestBase
    {
        public string TargetId { get; set; }
    }

    public class ParamsId
    {
        public string Id { get; set; }
    }

    public class ParamsChangePassword
    {
        public string UserId { get; set; }
        public string OldPassword { get; set; }
        public string NewPassword { get; set; }
    }

    public class ParamsChangeUsername
    {
        public string UserId { get; set; }
        public string Username { get; set; }
    }
    public class ParamsForgetPassword
    {
        public string UserId { get; set; }
        public string Email { get; set; }
    }

    public class ParamsChangeEmail
    {
        public string UserId { get; set; }
        public string Email { get; set; }
    }

    public class ParamsChangeAvatar
    {
        public string UserId { get; set; }
        public string Avatar { get; set; }
    }
}
