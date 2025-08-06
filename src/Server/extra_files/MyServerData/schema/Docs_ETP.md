# Stored Procedure Documentation

## GSP_AddGameToService
- **Procedure**: GSP_AddGameToService
- **Description**: Adds a game to a specified service in the Game_Service table.
- **Parameters**:
  - `@GameId` (UNIQUEIDENTIFIER): ID of the game to add.
  - `@ServiceName` (NVARCHAR(30)): Name of the service to associate with the game.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## GSP_RemoveGameFromService
- **Procedure**: GSP_RemoveGameFromService
- **Description**: Removes a game from a specified service in the Game_Service table.
- **Parameters**:
  - `@GameId` (UNIQUEIDENTIFIER): ID of the game to remove.
  - `@ServiceName` (NVARCHAR(30)): Name of the service to disassociate.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## GSP_GetGameServices
- **Procedure**: GSP_GetGameServices
- **Description**: Retrieves all services associated with a specified game from the Game_Service table.
- **Parameters**:
  - `@GameId` (UNIQUEIDENTIFIER): ID of the game to query.
- **Returns**: Result set containing all services for the specified game.

## GSP_GetServiceGames
- **Procedure**: GSP_GetServiceGames
- **Description**: Retrieves all games associated with a specified service from the Game_Service table.
- **Parameters**:
  - `@ServiceName` (NVARCHAR(30)): Name of the service to query.
- **Returns**: Result set containing all games for the specified service.

## UDP_AddUserDiary
- **Procedure**: UDP_AddUserDiary
- **Description**: Adds a user-diary association to the User_Diary table.
- **Parameters**:
  - `@UserId` (UNIQUEIDENTIFIER): ID of the user.
  - `@DiaryId` (UNIQUEIDENTIFIER): ID of the diary.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## UDP_DeleteUserDiary
- **Procedure**: UDP_DeleteUserDiary
- **Description**: Removes a user-diary association from the User_Diary table.
- **Parameters**:
  - `@UserId` (UNIQUEIDENTIFIER): ID of the user.
  - `@DiaryId` (UNIQUEIDENTIFIER): ID of the diary.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## UDP_GetAllUserDiary
- **Procedure**: UDP_GetAllUserDiary
- **Description**: Retrieves all user-diary associations from the User_Diary table.
- **Parameters**: None
- **Returns**: Result set containing all user-diary pairs.

## UDP_GetDiariesOfUser
- **Procedure**: UDP_GetDiariesOfUser
- **Description**: Retrieves all diary IDs associated with a specified user.
- **Parameters**:
  - `@UserId` (UNIQUEIDENTIFIER): ID of the user to query.
- **Returns**: Result set containing diary IDs for the specified user, or NULL if the user does not exist.

## UDP_GetUsersOfDiary
- **Procedure**: UDP_GetUsersOfDiary
- **Description**: Retrieves all user IDs associated with a specified diary.
- **Parameters**:
  - `@DiaryId` (UNIQUEIDENTIFIER): ID of the diary to query.
- **Returns**: Result set containing user IDs for the specified diary, or NULL if the diary does not exist.

## ULP_AddUserList
- **Procedure**: ULP_AddUserList
- **Description**: Adds a user-list association to the User_List table.
- **Parameters**:
  - `@UserId` (UNIQUEIDENTIFIER): ID of the user.
  - `@ListId` (UNIQUEIDENTIFIER): ID of the list.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## ULP_DeleteUserList
- **Procedure**: ULP_DeleteUserList
- **Description**: Removes a user-list association from the User_List table.
- **Parameters**:
  - `@UserId` (UNIQUEIDENTIFIER): ID of the user.
  - `@ListId` (UNIQUEIDENTIFIER): ID of the list.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## ULP_GetAllUserList
- **Procedure**: ULP_GetAllUserList
- **Description**: Retrieves all user-list associations from the User_List table.
- **Parameters**: None
- **Returns**: Result set containing all user-list pairs.

## ULP_GetListsOfUser
- **Procedure**: ULP_GetListsOfUser
- **Description**: Retrieves all list IDs associated with a specified user.
- **Parameters**:
  - `@UserId` (UNIQUEIDENTIFIER): ID of the user to query.
- **Returns**: Result set containing list IDs for the specified user, or NULL if the user does not exist.

## ULP_GetUsersOfList
- **Procedure**: ULP_GetUsersOfList
- **Description**: Retrieves all user IDs associated with a specified list.
- **Parameters**:
  - `@ListId` (UNIQUEIDENTIFIER): ID of the list to query.
- **Returns**: Result set containing user IDs for the specified list, or NULL if the list does not exist.

## UUP_AddUserFollow
- **Procedure**: UUP_AddUserFollow
- **Description**: Adds a follower-following relationship to the User_User table.
- **Parameters**:
  - `@UserFollower` (UNIQUEIDENTIFIER): ID of the follower user.
  - `@UserFollowing` (UNIQUEIDENTIFIER): ID of the user being followed.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## UUP_RemoveUserFollow
- **Procedure**: UUP_RemoveUserFollow
- **Description**: Removes a follower-following relationship from the User_User table.
- **Parameters**:
  - `@UserFollower` (UNIQUEIDENTIFIER): ID of the follower user.
  - `@UserFollowing` (UNIQUEIDENTIFIER): ID of the user being followed.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## UUP_GetFollowingUsers
- **Procedure**: UUP_GetFollowingUsers
- **Description**: Retrieves all users that a specified user is following.
- **Parameters**:
  - `@UserFollower` (UNIQUEIDENTIFIER): ID of the follower user.
- **Returns**: Result set containing IDs of users being followed, or NULL if the user does not exist.

## UUP_GetFollowerUsers
- **Procedure**: UUP_GetFollowerUsers
- **Description**: Retrieves all users that are following a specified user.
- **Parameters**:
  - `@UserFollowing` (UNIQUEIDENTIFIER): ID of the user being followed.
- **Returns**: Result set containing IDs of follower users, or NULL if the user does not exist.

## UAP_CreateUserActivity
- **Procedure**: UAP_CreateUserActivity
- **Description**: Adds a user-activity association to the User_Activity table.
- **Parameters**:
  - `@UserId` (UNIQUEIDENTIFIER): ID of the user.
  - `@ActivityId` (UNIQUEIDENTIFIER): ID of the activity.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## UAP_DeleteUserActivity
- **Procedure**: UAP_DeleteUserActivity
- **Description**: Removes a user-activity association from the User_Activity table.
- **Parameters**:
  - `@UserId` (UNIQUEIDENTIFIER): ID of the user.
  - `@ActivityId` (UNIQUEIDENTIFIER): ID of the activity.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## UAP_GetAllUserActivity
- **Procedure**: UAP_GetAllUserActivity
- **Description**: Retrieves all user-activity associations from the User_Activity table.
- **Parameters**: None
- **Returns**: Result set containing all user-activity pairs.

## UAP_GetActivitiesByUser
- **Procedure**: UAP_GetActivitiesByUser
- **Description**: Retrieves all activity IDs associated with a specified user.
- **Parameters**:
  - `@UserId` (UNIQUEIDENTIFIER): ID of the user to query.
- **Returns**: Result set containing activity IDs for the specified user, or NULL if the user does not exist.

## UAP_GetUsersByActivity
- **Procedure**: UAP_GetUsersByActivity
- **Description**: Retrieves all user IDs associated with a specified activity.
- **Parameters**:
  - `@ActivityId` (UNIQUEIDENTIFIER): ID of the activity to query.
- **Returns**: Result set containing user IDs for the specified activity, or NULL if the activity does not exist.

## RUP_CreateReviewUser
- **Procedure**: RUP_CreateReviewUser
- **Description**: Adds a review-author association to the Review_User table.
- **Parameters**:
  - `@Author` (UNIQUEIDENTIFIER): ID of the user who authored the review.
  - `@ReviewId` (UNIQUEIDENTIFIER): ID of the review.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## RUP_DeleteReviewUser
- **Procedure**: RUP_DeleteReviewUser
- **Description**: Removes a review-author association from the Review_User table.
- **Parameters**:
  - `@Author` (UNIQUEIDENTIFIER): ID of the user who authored the review.
  - `@ReviewId` (UNIQUEIDENTIFIER): ID of the review.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## RUP_GetAllReviewUsers
- **Procedure**: RUP_GetAllReviewUsers
- **Description**: Retrieves all review-author associations from the Review_User table.
- **Parameters**: None
- **Returns**: Result set containing all review-author pairs.

## RUP_GetReviewIdsByAuthor
- **Procedure**: RUP_GetReviewIdsByAuthor
- **Description**: Retrieves all review IDs authored by a specified user.
- **Parameters**:
  - `@Author` (UNIQUEIDENTIFIER): ID of the user to query.
- **Returns**: Result set containing review IDs for the specified author, or NULL if the author does not exist.

## RUP_GetAuthorsByReviewId
- **Procedure**: RUP_GetAuthorsByReviewId
- **Description**: Retrieves all author IDs for a specified review.
- **Parameters**:
  - `@ReviewId` (UNIQUEIDENTIFIER): ID of the review to query.
- **Returns**: Result set containing author IDs for the specified review, or NULL if the review does not exist.

## RRP_AddReviewRate
- **Procedure**: RRP_AddReviewRate
- **Description**: Adds a rate-review association to the Review_Rate table.
- **Parameters**:
  - `@RateId` (UNIQUEIDENTIFIER): ID of the rate.
  - `@ReviewId` (UNIQUEIDENTIFIER): ID of the review.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## RRP_DeleteReviewRate
- **Procedure**: RRP_DeleteReviewRate
- **Description**: Removes a rate-review association from the Review_Rate table.
- **Parameters**:
  - `@RateId` (UNIQUEIDENTIFIER): ID of the rate.
  - `@ReviewId` (UNIQUEIDENTIFIER): ID of the review.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## RRP_GetAllReviewRate
- **Procedure**: RRP_GetAllReviewRate
- **Description**: Retrieves all rate-review associations from the Review_Rate table.
- **Parameters**: None
- **Returns**: Result set containing all rate-review pairs.

## RRP_GetReviewsOfRate
- **Procedure**: RRP_GetReviewsOfRate
- **Description**: Retrieves all review IDs associated with a specified rate.
- **Parameters**:
  - `@RateId` (UNIQUEIDENTIFIER): ID of the rate to query.
- **Returns**: Result set containing review IDs for the specified rate, or NULL if the rate does not exist.

## RRP_GetRatesOfReview
- **Procedure**: RRP_GetRatesOfReview
- **Description**: Retrieves all rate IDs associated with a specified review.
- **Parameters**:
  - `@ReviewId` (UNIQUEIDENTIFIER): ID of the review to query.
- **Returns**: Result set containing rate IDs for the specified review, or NULL if the review does not exist.

## RRP_CreateReviewReaction
- **Procedure**: RRP_CreateReviewReaction
- **Description**: Adds a reaction-review association to the Review_Reaction table.
- **Parameters**:
  - `@ReactionId` (UNIQUEIDENTIFIER): ID of the reaction.
  - `@ReviewId` (UNIQUEIDENTIFIER): ID of the review.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## RRP_DeleteReviewReaction
- **Procedure**: RRP_DeleteReviewReaction
- **Description**: Removes a reaction-review association from the Review_Reaction table.
- **Parameters**:
  - `@ReactionId` (UNIQUEIDENTIFIER): ID of the reaction.
  - `@ReviewId` (UNIQUEIDENTIFIER): ID of the review.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## RRP_GetAllReviewReactions
- **Procedure**: RRP_GetAllReviewReactions
- **Description**: Retrieves all reaction-review associations from the Review_Reaction table.
- **Parameters**: None
- **Returns**: Result set containing all reaction-review pairs.

## RRP_GetReactionsByReview
- **Procedure**: RRP_GetReactionsByReview
- **Description**: Retrieves all reaction IDs associated with a specified review.
- **Parameters**:
  - `@ReviewId` (UNIQUEIDENTIFIER): ID of the review to query.
- **Returns**: Result set containing reaction IDs for the specified review, or NULL if the review does not exist.

## RRP_GetReviewsByReaction
- **Procedure**: RRP_GetReviewsByReaction
- **Description**: Retrieves all review IDs associated with a specified reaction.
- **Parameters**:
  - `@ReactionId` (UNIQUEIDENTIFIER): ID of the reaction to query.
- **Returns**: Result set containing review IDs for the specified reaction, or NULL if the reaction does not exist.

## GRP_AddGameReview
- **Procedure**: GRP_AddGameReview
- **Description**: Adds a game-review association to the Game_Review table.
- **Parameters**:
  - `@GameId` (UNIQUEIDENTIFIER): ID of the game.
  - `@ReviewId` (UNIQUEIDENTIFIER): ID of the review.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## GRP_DeleteGameReview
- **Procedure**: GRP_DeleteGameReview
- **Description**: Removes a game-review association from the Game_Review table.
- **Parameters**:
  - `@GameId` (UNIQUEIDENTIFIER): ID of the game.
  - `@ReviewId` (UNIQUEIDENTIFIER): ID of the review.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## GRP_GetAllGameReview
- **Procedure**: GRP_GetAllGameReview
- **Description**: Retrieves all game-review associations from the Game_Review table.
- **Parameters**: None
- **Returns**: Result set containing all game-review pairs.

## GRP_GetGameOfReview
- **Procedure**: GRP_GetGameOfReview
- **Description**: Retrieves all game IDs associated with a specified review.
- **Parameters**:
  - `@ReviewId` (UNIQUEIDENTIFIER): ID of the review to query.
- **Returns**: Result set containing game IDs for the specified review, or NULL if the review does not exist.

## GRP_GetReviewOfGame
- **Procedure**: GRP_GetReviewOfGame
- **Description**: Retrieves all review IDs associated with a specified game.
- **Parameters**:
  - `@GameId` (UNIQUEIDENTIFIER): ID of the game to query.
- **Returns**: Result set containing review IDs for the specified game, or NULL if the game does not exist.

## RUP_AddReactionUser
- **Procedure**: RUP_AddReactionUser
- **Description**: Adds a reaction-author association to the Reaction_User table.
- **Parameters**:
  - `@ReactionId` (UNIQUEIDENTIFIER): ID of the reaction.
  - `@Author` (UNIQUEIDENTIFIER): ID of the user who authored the reaction.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## RUP_DeleteReactionUser
- **Procedure**: RUP_DeleteReactionUser
- **Description**: Removes a reaction-author association from the Reaction_User table.
- **Parameters**:
  - `@ReactionId` (UNIQUEIDENTIFIER): ID of the reaction.
  - `@Author` (UNIQUEIDENTIFIER): ID of the user who authored the reaction.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## RUP_GetAllReactionUser
- **Procedure**: RUP_GetAllReactionUser
- **Description**: Retrieves all reaction-author associations from the Reaction_User table.
- **Parameters**: None
- **Returns**: Result set containing all reaction-author pairs.

## RUP_GetReactionsOfUser
- **Procedure**: RUP_GetReactionsOfUser
- **Description**: Retrieves all reaction IDs authored by a specified user.
- **Parameters**:
  - `@Author` (UNIQUEIDENTIFIER): ID of the user to query.
- **Returns**: Result set containing reaction IDs for the specified user, or NULL if the user does not exist.

## RUP_GetUsersOfReaction
- **Procedure**: RUP_GetUsersOfReaction
- **Description**: Retrieves all user IDs associated with a specified reaction.
- **Parameters**:
  - `@ReactionId` (UNIQUEIDENTIFIER): ID of the reaction to query.
- **Returns**: Result set containing user IDs for the specified reaction, or NULL if the reaction does not exist.

## RUP_AddRateUser
- **Procedure**: RUP_AddRateUser
- **Description**: Adds a rate-rater association to the Rate_User table.
- **Parameters**:
  - `@RateId` (UNIQUEIDENTIFIER): ID of the rate.
  - `@Rater` (UNIQUEIDENTIFIER): ID of the user who rated.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## RUP_DeleteRateUser
- **Procedure**: RUP_DeleteRateUser
- **Description**: Removes a rate-rater association from the Rate_User table.
- **Parameters**:
  - `@RateId` (UNIQUEIDENTIFIER): ID of the rate.
  - `@Rater` (UNIQUEIDENTIFIER): ID of the user who rated.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## RUP_GetAllRateUser
- **Procedure**: RUP_GetAllRateUser
- **Description**: Retrieves all rate-rater associations from the Rate_User table.
- **Parameters**: None
- **Returns**: Result set containing all rate-rater pairs.

## RUP_GetRatesOfUser
- **Procedure**: RUP_GetRatesOfUser
- **Description**: Retrieves all rate IDs associated with a specified user.
- **Parameters**:
  - `@Rater` (UNIQUEIDENTIFIER): ID of the user to query.
- **Returns**: Result set containing rate IDs for the specified user, or NULL if the user does not exist.

## RUP_GetUsersOfRate
- **Procedure**: RUP_GetUsersOfRate
- **Description**: Retrieves all user IDs associated with a specified rate.
- **Parameters**:
  - `@RateId` (UNIQUEIDENTIFIER): ID of the rate to query.
- **Returns**: Result set containing user IDs for the specified rate, or NULL if the rate does not exist.

## RGP_AddRateGame
- **Procedure**: RGP_AddRateGame
- **Description**: Adds a rate-game association to the Rate_Game table.
- **Parameters**:
  - `@RateId` (UNIQUEIDENTIFIER): ID of the rate.
  - `@TargetGame` (UNIQUEIDENTIFIER): ID of the game being rated.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## RGP_DeleteRateGame
- **Procedure**: RGP_DeleteRateGame
- **Description**: Removes a rate-game association from the Rate_Game table.
- **Parameters**:
  - `@RateId` (UNIQUEIDENTIFIER): ID of the rate.
  - `@TargetGame` (UNIQUEIDENTIFIER): ID of the game being rated.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## RGP_GetAllRateGame
- **Procedure**: RGP_GetAllRateGame
- **Description**: Retrieves all rate-game associations from the Rate_Game table.
- **Parameters**: None
- **Returns**: Result set containing all rate-game pairs.

## RGP_GetRatesOfGame
- **Procedure**: RGP_GetRatesOfGame
- **Description**: Retrieves all rate IDs associated with a specified game.
- **Parameters**:
  - `@TargetGame` (UNIQUEIDENTIFIER): ID of the game to query.
- **Returns**: Result set containing rate IDs for the specified game, or NULL if the game does not exist.

## RGP_GetGamesOfRate
- **Procedure**: RGP_GetGamesOfRate
- **Description**: Retrieves all game IDs associated with a specified rate.
- **Parameters**:
  - `@RateId` (UNIQUEIDENTIFIER): ID of the rate to query.
- **Returns**: Result set containing game IDs for the specified rate, or NULL if the rate does not exist.

## LLP_AddListListItem
- **Procedure**: LLP_AddListListItem
- **Description**: Adds a list-list item association to the List_ListItem table.
- **Parameters**:
  - `@ListId` (UNIQUEIDENTIFIER): ID of the list.
  - `@ListItemId` (UNIQUEIDENTIFIER): ID of the list item.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## LLP_DeleteListListItem
- **Procedure**: LLP_DeleteListListItem
- **Description**: Removes a list-list item association from the List_ListItem table.
- **Parameters**:
  - `@ListId` (UNIQUEIDENTIFIER): ID of the list.
  - `@ListItemId` (UNIQUEIDENTIFIER): ID of the list item.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## LLP_GetAllListListItem
- **Procedure**: LLP_GetAllListListItem
- **Description**: Retrieves all list-list item associations from the List_ListItem table.
- **Parameters**: None
- **Returns**: Result set containing all list-list item pairs.

## LLP_GetListItemsOfList
- **Procedure**: LLP_GetListItemsOfList
- **Description**: Retrieves all list item IDs associated with a specified list.
- **Parameters**:
  - `@ListId` (UNIQUEIDENTIFIER): ID of the list to query.
- **Returns**: Result set containing list item IDs for the specified list, or NULL if the list does not exist.

## LLP_GetListsOfListItem
- **Procedure**: LLP_GetListsOfListItem
- **Description**: Retrieves all list IDs associated with a specified list item.
- **Parameters**:
  - `@ListItemId` (UNIQUEIDENTIFIER): ID of the list item to query.
- **Returns**: Result set containing list IDs for the specified list item, or NULL if the list item does not exist.

## LIGP_AddListItemGame
- **Procedure**: LIGP_AddListItemGame
- **Description**: Adds a list item-game association to the ListItem_Game table.
- **Parameters**:
  - `@ListItemId` (UNIQUEIDENTIFIER): ID of the list item.
  - `@TargetGame` (UNIQUEIDENTIFIER): ID of the game.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## LIGP_DeleteListItemGame
- **Procedure**: LIGP_DeleteListItemGame
- **Description**: Removes a list item-game association from the ListItem_Game table.
- **Parameters**:
  - `@ListItemId` (UNIQUEIDENTIFIER): ID of the list item.
  - `@TargetGame` (UNIQUEIDENTIFIER): ID of the game.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## LIGP_GetAllListItemGame
- **Procedure**: LIGP_GetAllListItemGame
- **Description**: Retrieves all list item-game associations from the ListItem_Game table.
- **Parameters**: None
- **Returns**: Result set containing all list item-game pairs.

## LIGP_GetGamesOfListItem
- **Procedure**: LIGP_GetGamesOfListItem
- **Description**: Retrieves all game IDs associated with a specified list item.
- **Parameters**:
  - `@ListItemId` (UNIQUEIDENTIFIER): ID of the list item to query.
- **Returns**: Result set containing game IDs for the specified list item, or NULL if the list item does not exist.

## LIGP_GetListItemsOfGame
- **Procedure**: LIGP_GetListItemsOfGame
- **Description**: Retrieves all list item IDs associated with a specified game.
- **Parameters**:
  - `@TargetGame` (UNIQUEIDENTIFIER): ID of the game to query.
- **Returns**: Result set containing list item IDs for the specified game, or NULL if the game does not exist.

## CUP_AddCommentUser
- **Procedure**: CUP_AddCommentUser
- **Description**: Adds a comment-author association to the Comment_User table.
- **Parameters**:
  - `@CommentId` (UNIQUEIDENTIFIER): ID of the comment.
  - `@Author` (UNIQUEIDENTIFIER): ID of the user who authored the comment.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## CUP_DeleteCommentUser
- **Procedure**: CUP_DeleteCommentUser
- **Description**: Removes a comment-author association from the Comment_User table.
- **Parameters**:
  - `@CommentId` (UNIQUEIDENTIFIER): ID of the comment.
  - `@Author` (UNIQUEIDENTIFIER): ID of the user who authored the comment.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## CUP_GetAllCommentUser
- **Procedure**: CUP_GetAllCommentUser
- **Description**: Retrieves all comment-author associations from the Comment_User table.
- **Parameters**: None
- **Returns**: Result set containing all comment-author pairs.

## CUP_GetCommentsOfUser
- **Procedure**: CUP_GetCommentsOfUser
- **Description**: Retrieves all comment IDs authored by a specified user.
- **Parameters**:
  - `@Author` (UNIQUEIDENTIFIER): ID of the user to query.
- **Returns**: Result set containing comment IDs for the specified user, or NULL if the user does not exist.

## CUP_GetUsersOfComment
- **Procedure**: CUP_GetUsersOfComment
- **Description**: Retrieves all user IDs associated with a specified comment.
- **Parameters**:
  - `@CommentId` (UNIQUEIDENTIFIER): ID of the comment to query.
- **Returns**: Result set containing user IDs for the specified comment, or NULL if the comment does not exist.

## CRP_AddCommentReaction
- **Procedure**: CRP_AddCommentReaction
- **Description**: Adds a comment-reaction association to the Comment_Reaction table.
- **Parameters**:
  - `@CommentId` (UNIQUEIDENTIFIER): ID of the comment.
  - `@ReactionId` (UNIQUEIDENTIFIER): ID of the reaction.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## CRP_DeleteCommentReaction
- **Procedure**: CRP_DeleteCommentReaction
- **Description**: Removes a comment-reaction association from the Comment_Reaction table.
- **Parameters**:
  - `@CommentId` (UNIQUEIDENTIFIER): ID of the comment.
  - `@ReactionId` (UNIQUEIDENTIFIER): ID of the reaction.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## CRP_GetAllCommentReaction
- **Procedure**: CRP_GetAllCommentReaction
- **Description**: Retrieves all comment-reaction associations from the Comment_Reaction table.
- **Parameters**: None
- **Returns**: Result set containing all comment-reaction pairs.

## CRP_GetReactionsOfComment
- **Procedure**: CRP_GetReactionsOfComment
- **Description**: Retrieves all reaction IDs associated with a specified comment.
- **Parameters**:
  - `@CommentId` (UNIQUEIDENTIFIER): ID of the comment to query.
- **Returns**: Result set containing reaction IDs for the specified comment, or NULL if the comment does not exist.

## CRP_GetCommentsOfReaction
- **Procedure**: CRP_GetCommentsOfReaction
- **Description**: Retrieves all comment IDs associated with a specified reaction.
- **Parameters**:
  - `@ReactionId` (UNIQUEIDENTIFIER): ID of the reaction to query.
- **Returns**: Result set containing comment IDs for the specified reaction, or NULL if the reaction does not exist.

## CRP_AddCommentReview
- **Procedure**: CRP_AddCommentReview
- **Description**: Adds a comment-review association to the Comment_Review table.
- **Parameters**:
  - `@CommentId` (UNIQUEIDENTIFIER): ID of the comment.
  - `@ReviewId` (UNIQUEIDENTIFIER): ID of the review.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## CRP_DeleteCommentReview
- **Procedure**: CRP_DeleteCommentReview
- **Description**: Removes a comment-review association from the Comment_Review table.
- **Parameters**:
  - `@CommentId` (UNIQUEIDENTIFIER): ID of the comment.
  - `@ReviewId` (UNIQUEIDENTIFIER): ID of the review.
  - `@Result` (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
- **Returns**: None (sets `@Result` to indicate success or failure).

## CRP_GetAllCommentReview
- **Procedure**: CRP_GetAllCommentReview
- **Description**: Retrieves all comment-review associations from the Comment_Review table.
- **Parameters**: None
- **Returns**: Result set containing all comment-review pairs.

## CRP_GetReviewsByComment
- **Procedure**: CRP_GetReviewsByComment
- **Description**: Retrieves all review IDs associated with a specified comment.
- **Parameters**:
  - `@CommentId` (UNIQUEIDENTIFIER): ID of the comment to query.
- **Returns**: Result set containing review IDs for the specified comment, or NULL if the comment does not exist.

## CRP_GetCommentsByReview
- **Procedure**: CRP_GetCommentsByReview
- **Description**: Retrieves all comment IDs associated with a specified review.
- **Parameters**:
  - `@ReviewId` (UNIQUEIDENTIFIER): ID of the review to query.
- **Returns**: Result set containing comment IDs for the specified review, or NULL if the review does not exist.