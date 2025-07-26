namespace Server.Source.Data
{
    /// <summary>
    /// A user activity that records a specific action performed by the user in the system.
    /// </summary>
    public class Activity
    {
        /// <summary>
        /// Unique identifier for the activity.
        /// </summary>
        /// <example>'001'</example>
        public string activityId;

        /// <summary>
        /// Description or content of the activity performed by the user.
        /// </summary>
        /// <example>'This is an activity.'</example>    
        public string content;

        /// <summary>
        /// The date the activity was performed, in YYYY-MM-DD format.
        /// </summary>
        /// <example>''2023-10-01''</example>    
        public string dateDo;

        public Activity()
        {
            activityId = "";
            content = "";
            dateDo = "";
        }

    }
}
