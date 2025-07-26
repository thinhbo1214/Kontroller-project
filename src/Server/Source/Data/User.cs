namespace Server.Source.Data
{
    /// <summary>
    /// Represents a user in the system, including personal information and game-related data.
    /// </summary>
    public class User
    {
        /// <summary>
        /// Unique identifier for the user.
        /// </summary>
        /// <example>'001'</example>
        public string userId;

        /// <summary>
        /// Account credentials used for authentication (e.g., login form).
        /// </summary>
        public Account account;

        /// <summary>
        /// Email address associated with the user. Optional:only visible to owner or admin.
        /// </summary>
        /// <example>'admin@kontroller.com'</example>
        public string email;

        /// <summary>
        /// URL for the user's avatar image.
        /// </summary>
        /// <example>'https://example.com/avatar.jpg'</example>
        public string avatar;

        /// <summary>
        /// The user's personal game activity log.
        /// </summary>
        public Diary diary;

        /// <summary>
        /// List of games the user marked to play later.
        /// </summary>
        public List<Game> playLaterList;

        /// <summary>
        /// Indicates whether the user is currently logged in.
        /// </summary>
        /// <example>true</example>
        public bool isLoggedIn;

        /// <summary>
        /// List of users who follow this user.
        /// </summary>
        public List<User> follower;

        /// <summary>
        /// Custom game lists created by the user.
        /// </summary>
        public List<List> lists;

        /// <summary>
        /// Recorded actions the user has performed in the system.
        /// </summary>
        public List<Activity> activity;

        public User()
        {
            userId = "";
            account = new Account();
            email = "";
            avatar = "";
            diary = new Diary();
            playLaterList = new List<Game>();
            isLoggedIn = false;
            follower = new List<User>();
            lists = new List<List>();
            activity = new List<Activity>();
        }
    }
}
