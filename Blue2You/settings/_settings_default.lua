Settings = 
{
    UserID = 0,
    Widgets =
    {
        {
            GroupName = "System",
            GroupOrder = 1,
            GroupWidth = 1,
            Widgets =
            {
                {
                    Order = 1,
                    Name = "Summary",
                    Desc = "Summary of recent activity with action short-cuts.",
                    Image = "images/widget_summary",
                    TargetScreen = "<none>",
                    Elements =
                    {
                        AddQuote( true ),
                    },
                    Settings = "mod_summary"
                },
                {
                    Order = 2,
                    Name = "Notifications",
                    Desc = "Notifications of new items.",
                    Image = "images/widget_notifications",
                    TargetScreen = "NotificationsScreen",
                    Settings = "mod_notification"
                },
                {
                    Order = 3,
                    Name = "Reminders",
                    Desc = "Reminders of scheduled events.",
                    Image = "images/widget_reminders",
                    TargetScreen = "RemindersScreen",
                    Settings = "mod_reminders"
                },
            },
        },
        {
            GroupName = "Modules",
            GroupOrder = 2,
            GroupWidth = 1,
            Widgets =
            {
                {
                    Order = 1,
                    Name = "Courses",
                    Desc = "Courses to help you take the next steps to a better you.",
                    Image = "images/widget_courses",
                    TargetScreen = "ModulesScreen",
                    Modules =
                    {
                        "course_intro",
                        "course_part2",
                    },
                },
                {
                    Order = 2,
                    Name = "Trackers",
                    Desc = "Trackers to help you monitor your progress.",
                    Image = "images/widget_trackers",
                    TargetScreen = "ModulesScreen",
                    Modules =
                    {
                        "tracker_mood",
                        "tracker_medication",
                    },
                },
                {
                    Order = 3,
                    Name = "Meditation",
                    Desc = "Meditations to calm your mind.",
                    Image = "images/widget_meditation",
                    TargetScreen = "ModulesScreen",
                    Modules =
                    {
                        "meditation_forest",
                        "meditation_beach",
                        "meditation_sunset",
                    },
                },
                {
                    Order = 4,
                    Name = "Games",
                    Desc = "Games to change your focus.",
                    Image = "images/widget_games",
                    TargetScreen = "ModulesScreen",
                    Modules =
                    {
                        "game_bubbles",
                        "game_feed_the_birds",
                        "game_rainstorm",
                    },
                },
                {
                    Order = 5,
                    Name = "Quotes",
                    Desc = "Quotes to pick you up.",
                    Image = "images/widget_quotes",
                    TargetScreen = "QuotesScreen",
                },
            },
        },
    },
}
