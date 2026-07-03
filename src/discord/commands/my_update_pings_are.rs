// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

use crate::discord::{self, DiscordContext, DiscordError};
use crate::model;

/// Tell fizz whether you want pings about your PRs waiting for your update.
///
/// Use `/whoami`` to find out all your ping preferences.
#[poise::command(slash_command, guild_only)]
pub async fn my_update_pings_are(
    ctx: DiscordContext<'_>,
    #[description = "Whether pings are enabled for PRs waiting for your update"]
    true_or_false: bool,
) -> Result<(), DiscordError> {
    {
        let guild_id: model::DiscordGuildId = ctx.guild_id().unwrap().into();
        let user_id: model::DiscordUserId = ctx.author().into();
        discord::util::update_user_config(ctx, guild_id, user_id, move |c| {
            c.ping_prs_to_update = true_or_false;
            Ok(())
        })
        .await?;
    }

    let reply = if true_or_false {
        format!(":white_check_mark: You will be pinged for your waiting PRs")
    } else {
        format!(":white_check_mark: You will not be pinged for your waiting PRs")
    };
    ctx.send(poise::CreateReply::default().content(reply).ephemeral(true))
        .await?;
    Ok(())
}
