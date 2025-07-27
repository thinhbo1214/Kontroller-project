INSERT INTO lists (
    list_id,
    user_id,
    title,
    description,
    is_public,
    created_at,
    updated_at
)
VALUES (
    @ListId,
    @UserId,
    @Title,
    @Description,
    @IsPublic,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);
