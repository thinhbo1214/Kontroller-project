INSERT INTO diaries (
    diary_id,
    user_id,
    title,
    content,
    game_id,
    is_public,
    created_at,
    updated_at
)
VALUES (
    @DiaryId,
    @UserId,
    @Title,
    @Content,
    @GameId,
    @IsPublic,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);
